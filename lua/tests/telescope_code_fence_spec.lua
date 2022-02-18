-- https://stackoverflow.com/questions/48409979/mocking-local-imports-when-unit-testing-lua-code-with-busted?utm_source=pocket_mylist
-- local _original_require = require
-- function require(modname, ...)
--   -- print(string.format("modname = %s", modname))
--   -- if modname == "telescope._extensions.telescope-code-fence.utils" then
--   if modname == "---- fake ----" then
--     -- implement the exception here
--     return _original_require("fake_utils")
--   end
--   -- otherewise act as normal
--   return _original_require(modname, ...)
-- pend
local mock = require("luassert.mock")
local match = require("luassert.match")
local utils = require("telescope._extensions.telescope-code-fence.utils")
local input = require("telescope._extensions.telescope-code-fence.input")
local markdown = require("telescope._extensions.telescope-code-fence.markdown")

describe("input", function()

  pending("prompt_user()", function()
    it("has error when repo is empty", function()
      -- Add fake implementation to override blocking vim.ui.input()
      local original_ask = input.ask
      input.ask = function() return 'chip/dotfilez' end
      assert.are.same(input.prompt_user({}), {repo = 'chip/dotfilez'})
      input.ask = original_ask
    end)

    it("has error when repo is empty", function()
      -- assert.has_error(input.ask, "woops") end)
      local utils_orig = utils
      local m = mock(utils_orig, true)
      input.prompt_user({})
      assert.stub(utils_orig.error).was.called_with('wu-ohs')
      mock.revert(m)
    end)
  end)

  describe("ask()", function()
    it("vim.ui.input is called", function()
      local ui_orig = vim.ui
      local m = mock(ui_orig, true)
      input.ask("Enter repo: ")
      assert.stub(m.input).was.called_with({prompt = "Enter repo: "}, match._)
      mock.revert(m)
    end)
  end)
end)

describe("markdown", function()
  describe("fetch()", function()
    it("has error when repo is empty",
       function() assert.has_error(markdown.fetch, "woops") end)
  end)
end)
