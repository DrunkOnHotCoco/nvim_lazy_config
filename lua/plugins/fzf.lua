return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {
      winopts = {
        preview = {
          layout = "flex",
        }
      }
    },
    keys = {
      { "<leader>pf", "<cmd>FzfLua files<cr>"},
      { "<leader>pF", 
        function()
          local search_paths = vim.fn.input("Search Paths: ")
          require('fzf-lua').files({cwd=search_paths})
        end,
      },
      { "<leader>pg", "<cmd>FzfLua live_grep<cr>"},
      { "<leader>pG", 
        function()
          local function select_file(callback)
            local cwd = vim.fn.getcwd()
            require('fzf-lua').files({
              cwd = cwd,  
              prompt = 'Select Search Path(s)❯ ',
              cmd = 'fd --color=never --type d',
              git_icons = false, file_icons = false, color_icons = false,
              actions = {
                ["default"] = function(selected, opts)
                  local file = require('fzf-lua').path.entry_to_file(selected[1])
                  callback(file.path)
                  -- callback(cwd .. selected[1])
                end,
              }
            })
          end
          select_file(function(search_path)
            vim.print(type(search_path))
            vim.print(search_path)
            require('fzf-lua').live_grep({search_paths={search_path}})
          end)
        
        end,
      },
      { "<leader>po", "<cmd>FzfLua oldfiles<cr>"},
      { "<leader>pr", "<cmd>FzfLua resume<cr>"},
    },
    
  },
}
