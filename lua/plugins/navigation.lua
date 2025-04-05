-- lua with lazy.nvim

return {
  {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup {
      mappings = {
        v = { -- don't exit visual mode with jk...
          j = {
            k = false
          },
        },
      }
    }
  end,
  }
}
