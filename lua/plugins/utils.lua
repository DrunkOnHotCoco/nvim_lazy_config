return {
  {
    'rmagatti/auto-session',
    lazy = false,

    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    }
  },
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      terminal = { enabled = true },
    },
    keys = {
      { "<leader>;",      function() require('snacks').terminal() end, desc = "Toggle Terminal" },
    },

  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")

        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({"n", "v"}, "<up>",
            function() mc.lineAddCursor(-1) end)
        set({"n", "v"}, "<down>",
            function() mc.lineAddCursor(1) end)
        set({"n", "v"}, "<leader><up>",
            function() mc.lineSkipCursor(-1) end)
        set({"n", "v"}, "<leader><down>",
            function() mc.lineSkipCursor(1) end)
        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "v"}, "<leader>n",
            function() mc.matchAddCursor(1) end)
        set({"n", "v"}, "<leader>s",
            function() mc.matchSkipCursor(1) end)
        set({"n", "v"}, "<leader>N",
            function() mc.matchAddCursor(-1) end)
        set({"n", "v"}, "<leader>S",
            function() mc.matchSkipCursor(-1) end)

        -- Add all matches in the document
        set({"n", "v"}, "<leader>A", mc.matchAllAddCursors)

        -- Rotate the main cursor.
        set({"n", "v"}, "<left>", mc.nextCursor)
        set({"n", "v"}, "<right>", mc.prevCursor)

        -- Delete the main cursor.
        set({"n", "v"}, "<leader>x", mc.deleteCursor)

        -- Add and remove cursors with control + left click.
        set("n", "<c-leftmouse>", mc.handleMouse)

        -- Easy way to add and remove cursors using the main cursor.
        set({"n", "v"}, "<c-q>", mc.toggleCursor)

        -- Clone every cursor and disable the originals.
        set({"n", "v"}, "<leader><c-q>", mc.duplicateCursors)

        set("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            elseif mc.hasCursors() then
                mc.clearCursors()
            else
                -- Default <esc> handler.
            end
        end)
    end
  }
}
