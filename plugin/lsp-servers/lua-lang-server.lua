-- plugin/lsp-servers/lua-lang-server.lua

local function start_lua_lang_server()

    local util = require('lspconfig/util')

    local root_files = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
    }

    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Get the filename (full path) of the current buffer
    local filename = vim.api.nvim_buf_get_name(bufnr)

    local function get_root_dir(filename)
        return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
    end

    vim.lsp.start({
        cmd = { 'lua-language-server' },
        root_dir = get_root_dir(filename),
        single_file_support = true,
    })

end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  desc = 'Start lua-language-server LSP',
  callback = start_lua_lang_server,
})
