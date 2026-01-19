return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      -- This ensures neo-tree doesn't hijack the behavior when opening a directory
      -- or appearing unexpectedly during session restores.
      hijack_netrw_behavior = "disabled",
    },
  },
}
