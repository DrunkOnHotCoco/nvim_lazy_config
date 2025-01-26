-- require("config.lazy")
-- Folding
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
---WORKAROUND
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})
---ENDWORKAROUND

-- Barbar/Bufferline nvim-tree integration
local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)

--- Telescope
local actions    = require('telescope.actions')
local previewers = require('telescope.previewers')
local sorters    = require('telescope.sorters')

local cdPicker = function(name, cmd)
    pickers.new({}, {
        prompt_title = name,
        finder = finders.new_table{ results = utils.get_os_command_output(cmd) },
        previewer = previewers.vim_buffer_cat.new({}),
        sorter = sorters.get_fuzzy_file(),
        attach_mappings = function(prompt_bufnr)
            actions_set.select:replace(function(_, type)
                local entry = actions.get_selected_entry()
                actions.close(prompt_bufnr)
                local dir = from_entry.path(entry)
                vim.cmd('cd '..dir)
            end)
            return true
        end,
    }):find()
end

function Cd(path)
    path = path or '.'
    cdPicker('Cd', {vim.o.shell, '-c', "fd . "..path.." --type=d 2>/dev/null"})
end

function Cdz()
    cdPicker('z directories', {vim.o.shell, '-c', "cat ~/.z | cut -d '|' -f1"})
end

vim.keymap.set('n', 'f', function() require("flash").jump() end, {noremap = true})
vim.keymap.set('v', 'f', function() require("flash").jump() end, {noremap = true})


-- local mc = require("multicursor-nvim")

-- mc.setup()
--
-- local set = vim.keymap.set
--
-- -- Add or skip cursor above/below the main cursor.
-- set({"n", "v"}, "<up>",
--     function() mc.lineAddCursor(-1) end)
-- set({"n", "v"}, "<down>",
--     function() mc.lineAddCursor(1) end)
-- set({"n", "v"}, "<leader><up>",
--     function() mc.lineSkipCursor(-1) end)
-- set({"n", "v"}, "<leader><down>",
--     function() mc.lineSkipCursor(1) end)
--
-- -- Add or skip adding a new cursor by matching word/selection
-- set({"n", "v"}, "<leader>n",
--     function() mc.matchAddCursor(1) end)
-- set({"n", "v"}, "<leader>s",
--     function() mc.matchSkipCursor(1) end)
-- set({"n", "v"}, "<leader>N",
--     function() mc.matchAddCursor(-1) end)
-- set({"n", "v"}, "<leader>S",
--     function() mc.matchSkipCursor(-1) end)
--
-- -- Add all matches in the document
-- set({"n", "v"}, "<leader>A", mc.matchAllAddCursors)
--
-- -- You can also add cursors with any motion you prefer:
-- -- set("n", "<right>", function()
-- --     mc.addCursor("w")
-- -- end)
-- -- set("n", "<leader><right>", function()
-- --     mc.skipCursor("w")
-- -- end)
--
-- -- Rotate the main cursor.
-- set({"n", "v"}, "<left>", mc.nextCursor)
-- set({"n", "v"}, "<right>", mc.prevCursor)
--
-- -- Delete the main cursor.
-- set({"n", "v"}, "<leader>x", mc.deleteCursor)
--
-- -- Add and remove cursors with control + left click.
-- set("n", "<c-leftmouse>", mc.handleMouse)
--
-- -- Easy way to add and remove cursors using the main cursor.
-- set({"n", "v"}, "<c-q>", mc.toggleCursor)
--
-- -- Clone every cursor and disable the originals.
-- set({"n", "v"}, "<leader><c-q>", mc.duplicateCursors)
--
-- set("n", "<esc>", function()
--     if not mc.cursorsEnabled() then
--         mc.enableCursors()
--     elseif mc.hasCursors() then
--         mc.clearCursors()
--     else
--         -- Default <esc> handler.
--     end
-- end)
--
-- -- bring back cursors if you accidentally clear them
-- set("n", "<leader>gv", mc.restoreCursors)
--
-- -- Align cursor columns.
-- set("n", "<leader>a", mc.alignCursors)
--
-- -- Split visual selections by regex.
-- set("v", "S", mc.splitCursors)
--
-- -- Append/insert for each line of visual selections.
-- set("v", "I", mc.insertVisual)
-- set("v", "A", mc.appendVisual)
--
-- -- match new cursors within visual selections by regex.
-- set("v", "M", mc.matchCursors)
--
-- -- Rotate visual selection contents.
-- set("v", "<leader>t",
--     function() mc.transposeCursors(1) end)
-- set("v", "<leader>T",
--     function() mc.transposeCursors(-1) end)
