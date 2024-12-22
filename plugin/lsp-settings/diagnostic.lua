-- Set diagnostic signs 
vim.diagnostic.config({
  virtual_text = true,
  float = {
    style = 'minimal',
    border = 'rounded',
    source = 'always'
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
})

-- Show diagnostics in a floating window
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

-- Move to the previous diagnostic
vim.keymap.set('n', 'd]', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

-- Move to the next diagnostic
vim.keymap.set('n', 'd[', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- Diagnostic window
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

-- Help window
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)
