local spy = require("luassert.spy")
-- local mock = require("luassert.mock")
local eq = assert.are.same
local tcf_input = require("telescope._extensions.telescope-code-fence.input")
local tcf_data = require("telescope._extensions.telescope-code-fence.markdown")
local tcf_url = require("telescope._extensions.telescope-code-fence.url")

local missing_repo_msg =
  "Please run plugin again and enter a repo name when prompted."

describe("tcf_input", function()
  describe(".ask_for_repo()", function()
    it("returns stubbed data from input.ask()", function()
      tcf_input.ask = spy.new(function() return "blah/blah" end)
      eq("blah/blah", tcf_input.ask_for_repo())
      tcf_input.ask:revert()
    end)

    it("has error when stubbed data from input.ask() is empty", function()
      tcf_input.ask = spy.new(function() return "" end)
      assert.has.errors(tcf_input.ask_for_repo, missing_repo_msg)
      tcf_input.ask:revert()
    end)
  end)

  describe(".ask_for_file()", function()
    it("returns stubbed data from input.ask()", function()
      tcf_input.ask = spy.new(function() return "readme" end)
      eq("readme", tcf_input.ask_for_file())
      tcf_input.ask:revert()
    end)

    it("has error when stubbed data from input.ask() is empty", function()
      tcf_input.ask = spy.new(function() return "" end)
      eq("README.md", tcf_input.ask_for_file())
      tcf_input.ask:revert()
    end)
  end)
end)

describe("tcf_data", function()
  describe(".fetch()", function()
    pending("has error when repo is not defined",
            function() assert.has.errors(tcf_data.fetch, missing_repo_msg) end)

    it("writes error to nvim command line when repo is not defined", function()
      local msg = "[ERROR telescope-code-fence.nvim] " .. missing_repo_msg
      vim.api.nvim_err_writeln = spy.new(function() end)
      tcf_data.fetch()
      assert.spy(vim.api.nvim_err_writeln).was.called_with(msg)
      vim.api.nvim_err_writeln:revert()
    end)
  end)
end)

-- Like Go: return result, error_message
-- SUCCESS: return "some data", nil
-- FAILURE: return nil, "wuh-oze"
describe("tcf_url", function()
  describe(".build()", function()
    it("returns error when passed in no args", function()
      local actual, err = tcf_url.build()
      eq(actual, nil)
      eq(err, missing_repo_msg)
    end)

    it("returns error when passed in empty repo arg", function()
      local actual, err = tcf_url.build({repo = ''})
      eq(actual, nil)
      eq(err, missing_repo_msg)
    end)

    it("returns error when passed in nil repo arg", function()
      local actual, err = tcf_url.build({repo = nil})
      eq(actual, nil)
      eq(err, missing_repo_msg)
    end)

    it("returns full url when passed in repo arg only", function()
      local expected =
        "https://raw.githubusercontent.com/foo/bar/master/README.md"
      local actual, err = tcf_url.build({repo = "foo/bar"})
      eq(actual, expected)
      eq(err, nil)
    end)

    it("returns full url when passed in repo and file args", function()
      local expected = "https://raw.githubusercontent.com/foo/bar/master/readme"
      local actual, err = tcf_url.build({repo = "foo/bar", file = "readme"})
      eq(actual, expected)
      eq(err, nil)
    end)

    it("returns full url when passed in repo, file, and branch args", function()
      local expected =
        "https://raw.githubusercontent.com/foo/bar/main/readme.md"
      local actual, err = tcf_url.build({
        repo = "foo/bar",
        file = "readme.md",
        branch = "main"
      })
      eq(actual, expected)
      eq(err, nil)
    end)

    it("returns full url when passed in repo, file, branch, and service args",
       function()
      local expected = "https://other-service.org/foo/bar/main/readme.md"
      local actual, err = tcf_url.build({
        repo = "foo/bar",
        file = "readme.md",
        branch = "main",
        service = "https://other-service.org"
      })
      eq(actual, expected)
      eq(err, nil)
    end)
  end)
end)
