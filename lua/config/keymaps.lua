local map = vim.keymap.set

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })

map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle file explorer' })
map('n', '<leader>o', '<cmd>NvimTreeFocus<cr>', { desc = 'Focus file explorer' })

local function toggle_term()
  require('config.terminal').toggle()
end

map({ 'n', 't' }, '<C-\\>', toggle_term, { desc = 'Toggle terminal' })
map({ 'n' }, '<leader>t', toggle_term, { desc = 'Toggle terminal' })

map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
map('t', '<C-Up>', [[<C-\><C-n><C-u>]], { desc = 'Scroll up half page' })                     
map('t', '<C-Down>', [[<C-\><C-n><C-d>]], { desc = 'Scroll down half page' })
map('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Window left from term' })
map('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = 'Window down from term' })
map('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Window up from term' })
map('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Window right from term' })

map('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

map('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Prev diagnostic' })
map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Next diagnostic' })
map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'LSP rename' })
map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'LSP code action' })
map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, { desc = 'LSP format' })

