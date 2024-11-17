-- plugin/lsp-servers/bash-lang-server.lua

local function start_bash_lang_server()

    local util = require('lspconfig/util')
--
--    local root_files = {
--        '.git',
--    }
--
--    -- Get the current buffer number
--    local bufnr = vim.api.nvim_get_current_buf()
--    
--    -- Get the filename (full path) of the current buffer
--    local filename = vim.api.nvim_buf_get_name(bufnr)
--
--    local function get_root_dir(filename)
--        return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
--    end
--
    vim.lsp.start({
        cmd = {'bash-language-server', 'start'},
        settings = {
          bashIde = {
            -- Glob pattern for finding and parsing shell script files in the workspace.
            -- Used by the background analysis features across files.

            -- Prevent recursive scanning which will cause issues when opening a file
            -- directly in the home directory (e.g. ~/foo.sh).
            --
            -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
            globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
          },
        },
        filetypes = { 'sh' },
--        root_dir = util.find_git_ancestor,
        single_file_support = true
    })

end


-- set .sbatch files as `sh` filetype in nvim.
vim.cmd('autocmd BufNewFile,BufRead *.sbatch set filetype=sh')


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh' },
  desc = 'Start bash langauge server LSP',
  callback = start_bash_lang_server,
})


