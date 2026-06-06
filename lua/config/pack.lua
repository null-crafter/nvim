vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'telescope-fzf-native.nvim' then
      vim.notify('Building telescope-fzf-native...', vim.log.levels.INFO)
      local r = vim.system({ 'make' }, { cwd = ev.data.path }):wait()
      if r.code ~= 0 then
        vim.notify('fzf-native build failed:\n' .. (r.stderr or ''), vim.log.levels.ERROR)
      end
    elseif name == 'blink.cmp' then
      vim.notify('Building blink.cmp...', vim.log.levels.INFO)
      local r = vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
      if r.code ~= 0 then
        vim.notify('blink.cmp build failed:\n' .. (r.stderr or ''), vim.log.levels.ERROR)
      end

    elseif name == 'nvim-treesitter' then
      vim.notify('Updating treesitter parsers...', vim.log.levels.INFO)


      vim.cmd('TSUpdateSync')
    end
  end,
})


vim.filetype.add({
  extension = {
    cl = 'lisp',
  },
})

vim.pack.add({
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.cmp' },
})

require('nvim-treesitter.parsers').elixir = {
  install_info = {
    url = 'https://github.com/elixir-lang/tree-sitter-elixir',
    revision = 'e2d9e6e0e76b0c436fa48a0b8c32a031d0cbdf49', -- commit hash for revision to check out; HEAD if missing
    -- optional entries:
    queries = 'queries', -- also install queries from given directory
  },
}
require('nvim-treesitter').install({ 'elixir' })

require('tokyonight').setup({
  style = 'night',
  transparent = false,
})
vim.cmd.colorscheme('tokyonight')

require('nvim-web-devicons').setup({})

require('snacks').setup({
  notifier = { enabled = true },
  input = { enabled = true },
  indent = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
  },
})

require('noice').setup({})


local cmp = require('blink.cmp')

cmp.build():wait(60000)
cmp.setup({
  keymap = { preset = 'enter' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  signature = { enabled = true },
})

require('lualine').setup({
  options = { theme = 'tokyonight' },
})

require('telescope').setup({
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = { prompt_position = 'top' },
    sorting_strategy = 'ascending',
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})
pcall(require('telescope').load_extension, 'fzf')

require('nvim-treesitter').install({
  'python', 'bash', 'json', 'yaml',
  'markdown_inline', 'clojure', 'commonlisp',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'python', 'lua', 'vim', 'help', 'bash', 'sh', 'json', 'yaml',
    'markdown', 'clojure', 'lisp', 'commonlisp', 'elixir', 'eelixir'
  },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

require('which-key').setup({})

require('nvim-surround').setup({})

local lisp_fts = { lisp = true, clojure = true, commonlisp = true, scheme = true }
require('nvim-autopairs').setup({})
require('nvim-autopairs').disable()
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  callback = function()
    if lisp_fts[vim.bo.filetype] then
      require('nvim-autopairs').enable()
    else
      require('nvim-autopairs').disable()
    end
  end,
})

require('nvim-tree').setup({
  disable_netrw = true,
  hijack_netrw = true,
  view = {
    side = 'left',
    width = 32,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
  },
})
