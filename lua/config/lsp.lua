local servers = {
  js_and_ts = {
      cmd = {'typescript-language-server', '--stdio'},
      filetypes = {'typescriptreact', 'typescript', 'javascriptreact', 'javascript', }, -- tsx, ts, js, jsx
      root_markers = {'package.json', 'node_modules'},
      settings = {},
  },
  expert = {
    cmd = { 'expert', '--stdio'},
    filetypes = { 'elixir' },
    root_markers = {'mix.exs'},
    settings = {
    },
  },
  pyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
          typeCheckingMode = 'basic',
        },
      },
    },
  },
  jedi = {
    cmd = { 'jedi-language-server'},
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
    settings = {
    },
  },

}


for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
end
vim.lsp.enable(vim.tbl_keys(servers))

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 2000 })
        end,
      })
    end
  end,
})
