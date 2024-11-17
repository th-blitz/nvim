-- ftplugin/php.lua

local root_files = {'composer.json'}
local paths = vim.fs.find(root_files, {stop = vim.env.HOME})
local root_dir = vim.fs.dirname(paths[1])


if root_dir then
    vim.lsp.start({
        cmd = {'intelephense', '--stdio'},
        root_dir = root_dir,
        settings = {
            intelephense = {
                files = {
                    maxSize = 1000000,
                }
            },
        }
    })
end
