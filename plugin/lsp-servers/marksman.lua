-- plugin/lsp-servers/marksman.lua

local function start_marksman_server()

    local util = require('lspconfig/util')

    local root_files = {
        '.remarkrc',
    }

    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Get the filename (full path) of the current buffer
    local filename = vim.api.nvim_buf_get_name(bufnr)

    local function get_root_dir(filename)
        return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
    end

    vim.lsp.start({
        cmd = {'remark-language-server', '--stdio'},
        filetypes = {'markdown'},
        single_file_support = true,
    })

end

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'markdown' },
--   desc = 'Start remark LSP',
--   callback = start_marksman_server,
-- })

require'lspconfig'.remark_ls.setup {
    settings = {
        remark = {
            requireConfig = true
        }
    }
}


