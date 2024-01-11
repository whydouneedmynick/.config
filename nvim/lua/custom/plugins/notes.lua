return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim", "laher/neorg-exec", "folke/zen-mode.nvim", },
  lazy = true,
  cmd = { "Neorg" },
  ft = { "norg" },
  config = function()
    require("neorg").setup {
      load = {
        ["core.esupports.indent"] = {},
        ["core.defaults"] = {},
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
        ["core.concealer"] = {
          config = {
            folds = false,
          },
        },
        ["core.summary"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
          },
        },
        ["external.exec"] = {}
      },
    }
  end,
}
