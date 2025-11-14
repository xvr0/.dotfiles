local map = vim.keymap.set
map("n","<leader>nn",function() vim.cmd("bn") end)
map("n","<leader>pp",function() vim.cmd("bp") end)
map("n","<leader>dd",function() vim.cmd("bd") end)
map("n","<leader>bl",function() vim.cmd("buffers") end)

map("n","<leader><leader>",function() vim.cmd("w") end)
map("n","zz","ZZ")

map("n","<leader>nh",function() vim.cmd("noh") end)

map("n","<leader>u",function() vim.cmd("undo") end)
map("n","<leader>r",function() vim.cmd("redo") end)


map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

local function switch_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end

  vim.cmd("term")  -- You can use :vsplit if you prefer vertical split
end

-- Map <leader>t to toggle_terminal
vim.keymap.set('n', '<leader>t', switch_terminal, { noremap = true, silent = true })

map("n","<leader>bt",function() vim.cmd("bd!") end)

local function RunFile()
    -- Ensure the current file is saved before running
    vim.cmd('w')

    -- Get the current filetype (e.bo.filetype is buffer-local option)
    local filetype = vim.bo.filetype
    
    -- Get the current file path, escaped for safe shell execution
    local filename = vim.fn.shellescape(vim.fn.expand('%'))

    -- The command to run in the terminal
    local command = nil

    if filetype == 'python' then
        -- Execute Python script
        command = 'terminal python3 ' .. filename
    elseif filetype== 'tex' then
        command= 'TeXpresso %'
    elseif filetype == 'sh' or filetype == 'bash' then
        -- Execute shell script
        command = 'terminal ' .. filename
    elseif filetype == 'c' then
        -- Compile and run C code (Requires gcc and assumes you want to run immediately)
        local base_name = vim.fn.expand('%:r') -- filename without extension
        -- Use && to chain the commands: compile, then run the executable
        command = 'terminal gcc ' .. filename .. ' -o ' .. base_name .. ' && ./' .. base_name
    end

    if command then
        vim.cmd(command)
    else
        vim.notify('No run command defined for filetype: ' .. filetype, vim.log.levels.WARN)
    end
end 
-- Create a Normal mode mapping (e.g., F5) to run the file
vim.keymap.set('n', '<leader>x', RunFile, {
    desc = 'Run/Execute Current File (Filetype-Aware)',
    silent = true
})


map("n", "<leader>ht", function() vim.cmd("terminal htop") end)
-- general mappings
map("n", "<C-s>", function() vim.cmd("w") end)
map("i", "jk", "<ESC>")
 map("n", "<C-c>", function() vim.cmd("%y+") end) -- copy whole filecontent


vim.g.ranger_map_keys = 0
map("n", "<leader>fr", function() vim.cmd("Ranger") end)
-- telescope
-- After
vim.keymap.set('n', '<leader>ff', function()
    require('telescope.builtin').find_files({ hidden = true })
end, {})
map("n", "<leader>fo", function() require('telescope.builtin').oldfiles() end)
map("n", "<leader>fw", function() require('telescope.builtin').live_grep() end)
map("n", "<leader>gt", function() require('telescope.builtin').git_status() end)

-- bufferline, cycle buffers
map("n", "<Tab>", function() vim.cmd("BufferLineCycleNext") end)
map("n", "<S-Tab>", function() vim.cmd("BufferLineCyclePrev") end)
map("n", "<C-q>", function() vim.cmd("bd") end)

-- comment.nvim
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- format
map("n", "<leader>fm", function()
  require("conform").format()
end)
