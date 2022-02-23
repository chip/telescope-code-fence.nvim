local pwd = os.getenv('PWD')
package.path = pwd .. "/../fixtures/?;" .. package.path
local TEXT_WITHOUT_CODE_FENCES = require(
                                   "tests.fixtures.TEXT_WITHOUT_CODE_FENCES")
local MARKDOWN = require("tests.fixtures.MARKDOWN")
local spy = require("luassert.spy")
local eq = assert.are.same
local tcf_input = require("telescope._extensions.telescope-code-fence.input")
local tcf_url = require("telescope._extensions.telescope-code-fence.url")
local tcf_data = require("telescope._extensions.telescope-code-fence.data")

local missing_repo_msg =
  "Please run plugin again and enter a repo name when prompted."

describe("tcf_input", function()
  describe(".ask_for_repo", function()
    it("returns stubbed data from input.ask", function()
      tcf_input.ask = spy.new(function() return "blah/blah" end)
      eq("blah/blah", tcf_input.ask_for_repo())
      tcf_input.ask:revert()
    end)

    it("returns error when stubbed data from input.ask is empty", function()
      tcf_input.ask = spy.new(function() return "" end)
      local actual, err = tcf_input.ask_for_repo()
      eq(actual, nil)
      eq(err, missing_repo_msg)
      tcf_input.ask:revert()
    end)
  end)

  describe(".ask_for_file", function()
    it("returns stubbed data from input.ask", function()
      tcf_input.ask = spy.new(function() return "readme" end)
      eq("readme", tcf_input.ask_for_file())
      tcf_input.ask:revert()
    end)

    it("returns default README.md when stubbed data from input.ask is empty",
       function()
      tcf_input.ask = spy.new(function() return "" end)
      eq("README.md", tcf_input.ask_for_file())
      tcf_input.ask:revert()
    end)
  end)
end)

describe("tcf_data", function()
  describe(".parse", function()
    it("returns error when text is not defined", function()
      local msg = "parsing failed due to lack of data"
      local actual, err = tcf_data.parse()
      eq(actual, nil)
      eq(err, msg)
    end)

    it(
      "returns default table when stubbed text does not contain markdown code fences",
      function()
        local actual, err = tcf_data.parse(TEXT_WITHOUT_CODE_FENCES)
        local expected = {
          {
            "dotfiles for osx",
            {
              "dotfiles for osx",
              "Currently using the following:",
              "* iTerm2 terminal",
              "* Terminal theme: Profiles->Colors->Color Presets...-> srcery_iterm"
            },
            ""
          }
        }
        eq(expected, actual)
        eq(err, nil)
      end)

    it("returns table of fences after using stubbed markdown", function()
      local actual, err = tcf_data.parse(MARKDOWN)
      local expected = {
        {
          "call dein#add('nvim-lua/plenary.nvim')",
          {
            "call dein#add('nvim-lua/plenary.nvim')",
            "call dein#add('nvim-telescope/telescope.nvim')"
          },
          "viml"
        },
        {
          "use {",
          {
            "use {",
            "  'nvim-telescope/telescope.nvim',",
            "  requires = { {'nvim-lua/plenary.nvim'} }",
            "}"
          },
          "lua"
        }
      }
      eq(expected, actual)
      eq(err, nil)
    end)

  end)

end)

-- Like Go: return result, error_message
-- SUCCESS: return "some data", nil
-- FAILURE: return nil, "wuh-oze"
describe("tcf_url", function()
  describe(".build", function()
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

  describe(".fetch", function()
    it("has error when repo is not defined", function()
      local actual, err = tcf_url.fetch()
      eq(actual, nil)
      eq(err, missing_repo_msg)
    end)

    it("returns body when stubbed request is successful", function()
      local fake_curl = {
        request = function() return {status = 200, body = "whassup"} end
      }
      local actual, err = tcf_url.fetch({
        repo = "chip/dotfiles",
        fetch_service = fake_curl
      })
      eq("whassup", actual)
      eq(err, nil)
    end)

    it("returns error when stubbed request returns failure status", function()
      local fake_curl = {
        request = function()
          return {status = 404, body = "404 not found"}
        end
      }
      local actual, err = tcf_url.fetch({
        repo = "chip/dotfiles",
        fetch_service = fake_curl
      })
      eq(nil, actual)
      eq(err, "Fetch failed for Github repo chip/dotfiles with 404 not found")
    end)

  end)

end)
