local util = require('lspconfig.util')


vim.lsp.start({
    cmd = {'bash-language-server', 'start'},
    filetypes = {'sh'},
    root_dir = vim.fn.getcwd(),
    single_file_support = true,
    settings = {
        bashIde = {
            globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
        },
    }
})
