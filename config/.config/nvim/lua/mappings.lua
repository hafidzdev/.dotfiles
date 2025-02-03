local map = vim.keymap.set
local toggleterm = require('toggleterm.terminal').Terminal

map('n', '<leader>w', ':w<CR>', { desc = 'Save Buffer' })
map('n', '<leader>q', ':bd<CR>:bnext<CR>', { desc = 'Close Buffer' })
map('n', '<leader>Q', ':qa<CR>', { desc = 'Quit Neovim' })

--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '|', '<Cmd>vsplit<CR>', { desc = 'Horizontal Split' })

-- lazygit
map('n', '<leader>gg', function()
  local lazygit = toggleterm:new {
    cmd = 'lazygit', -- Use relative file path
    direction = 'float',
    close_on_exit = true,
    hidden = true,
  }
  lazygit:toggle()
end, {
  desc = '[G]it Lazy Git',
})

map('n', '<leader>gh', function()
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('No file to show Git history for!', vim.log.levels.ERROR)
    return
  end

  local cwd = vim.fn.fnamemodify(file, ':h')
  local relative_file = vim.fn.fnamemodify(file, ':.')

  local lazygit = toggleterm:new {
    cmd = 'lazygit -f ' .. vim.fn.shellescape(relative_file),
    dir = cwd,
    direction = 'float',
    close_on_exit = true,
    hidden = true,
  }
  lazygit:toggle()
end, { desc = 'Git Lazy Git for [H]istory of current file' })

-- nvimtree
local function toggle_nvimtree()
  if vim.fn.bufname():match 'NvimTree_' then
    vim.cmd.wincmd 'p'
  else
    vim.cmd 'NvimTreeFindFile'
  end
end

map('n', '<D-b>', '<cmd>NvimTreeToggle<CR>', { desc = 'NvimTree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'Nvimtree focus window' })
map('n', '<leader>o', toggle_nvimtree, { desc = 'Toggle NvimTree and editor' })

-- telescope
local builtin = require 'telescope.builtin'

map('n', '<leader>fh', function()
  builtin.help_tags {
    prompt_title = 'Find Help',
  }
end, { desc = 'Find [H]elp' })

map('n', '<leader>ff', function()
  builtin.find_files {
    prompt_title = 'Find Files',
  }
end, { desc = 'Find [F]iles' })

map('n', '<leader>fs', function()
  builtin.lsp_document_symbols {
    prompt_title = 'Find Symbol',
  }
end, { desc = 'Find [S]ymbol' })

map('n', '<leader>fc', function()
  builtin.grep_string {
    prompt_title = 'Find Current Word',
  }
end, { desc = 'Find [C]urrent Word' })

map('n', '<leader>fw', function()
  builtin.live_grep {
    prompt_title = 'Find by Word',
  }
end, { desc = 'Find by [W]ord' })

map('n', '<leader>fd', function()
  builtin.diagnostics {
    prompt_title = 'Find Diagnostics',
  }
end, { desc = 'Find [D]iagnostics' })

map('n', '<leader>f/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Find Word in Open Files',
  }
end, { desc = 'Find [/] in Open Files' })

-- Shortcut for searching your Neovim configuration files
map('n', '<leader>fn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Find [N]eovim Files' })

map('n', '<leader>fk', function()
  builtin.keymaps {
    prompt_title = 'Find Keymaps',
  }
end, { desc = 'Find [K]eymaps' })

-- ToogleTerm
map('n', '<leader>th', '<Cmd>ToggleTerm size=20 direction=horizontal<CR>', { desc = 'ToggleTerm horizontal split' })
map('n', '<leader>tv', '<Cmd>ToggleTerm size=60 direction=vertical<CR>', { desc = 'ToggleTerm vertical split' })
