local spy = require("luassert.spy")
local eq = assert.are.same
local input = require("telescope._extensions.telescope-code-fence.input")

describe("input", function()
  describe("ask_for_repo()", function()
    it("returns stubbed data from input.ask()", function()
      input.ask = spy.new(function() return "blah/blah" end)
      eq("blah/blah", input.ask_for_repo())
      input.ask:revert()
    end)

    it("has error when stubbed data from input.ask() is empty", function()
      input.ask = spy.new(function() return "" end)
      assert.has.errors(input.ask_for_repo,
                        "Please run plugin again and enter a repo name when prompted.")
      input.ask:revert()
    end)
  end)

  describe("ask_for_file()", function()
    it("returns stubbed data from input.ask()", function()
      input.ask = spy.new(function() return "readme" end)
      eq("readme", input.ask_for_file())
      input.ask:revert()
    end)

    it("has error when stubbed data from input.ask() is empty", function()
      input.ask = spy.new(function() return "" end)
      eq("README.md", input.ask_for_file())
      input.ask:revert()
    end)
  end)
end)
