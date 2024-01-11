return {
  'willothy/veil.nvim',
  lazy = true,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local builtin = require("veil.builtin")

    require('veil').setup({
      sections = {
        builtin.sections.animated(builtin.headers.frames_nvim, {
          hl = { fg = "#5de4c7" },
        }),
        builtin.sections.buttons({
          {
            icon = "",
            text = "Find Files",
            shortcut = "f",
            callback = function()
              require("telescope.builtin").find_files()
            end,
          },
          {
            icon = "",
            text = "Find Word",
            shortcut = "w",
            callback = function()
              require("telescope.builtin").live_grep()
            end,
          },
          {
            icon = "",
            text = "Buffers",
            shortcut = "b",
            callback = function()
              require("telescope.builtin").buffers()
            end,
          },
          {
            icon = "",
            text = "Config",
            shortcut = "c",
            callback = function()
              require("telescope.builtin").find_files({
                cwd = vim.fn.stdpath("config"),
              })
            end,
          },
        }),
        builtin.sections.oldfiles(),
      },
      mappings = {},
      startup = true,
      listed = false
    })
  end
}
