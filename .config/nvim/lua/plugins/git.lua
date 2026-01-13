return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- This turns on the Zed-style ghost text
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- End of line
        delay = 300, -- How fast the text appears (ms)
      },
      -- This makes the text look clean like Zed:
      current_line_blame_formatter = "   <author> • <author_time:%R> • <summary>",
    },
  },
}
