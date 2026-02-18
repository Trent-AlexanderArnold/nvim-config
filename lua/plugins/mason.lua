-- Customize Mason

local is_termux = (vim.fn.has "android" == 1) or ((vim.env.PREFIX or ""):find("com.termux", 1, true) ~= nil)

local unsupported_termux_tools = {
  ["lua-language-server"] = true,
  ["stylua"] = true,
  ["codelldb"] = true,
}

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua-language-server",
        "neocmakelsp",
        "stylua",
        "tree-sitter-cli",
      })

      -- Mason does not provide these binaries for Termux/Android.
      if is_termux and type(opts.ensure_installed) == "table" then
        opts.ensure_installed = vim.tbl_filter(function(tool) return not unsupported_termux_tools[tool] end, opts.ensure_installed)
      end
    end,
  },
}
