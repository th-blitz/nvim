-- plugin/lsp-servers/clangd.lua

local function start_clangd()

    local util = require('lspconfig/util')

    local root_files = {
        'compile_commands.json',
        '.clangd',
    }

    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Get the filename (full path) of the current buffer
    local filename = vim.api.nvim_buf_get_name(bufnr)

    local function get_root_dir(filename)
        return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
    end

    vim.lsp.start({
        cmd = { 'clangd' },
        -- filetypes = { 'c', 'cpp', 'cu' },
        root_dir = get_root_dir(filename),
        offset_encoding = 'utf-32',
        single_file_support = true,
    })

end

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'c', 'cpp', 'cuda' },
  desc = 'Start clangd LSP',
  callback = start_clangd,
})
