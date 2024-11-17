local util = require 'lspconfig.util'

local function organize_imports()

  local params = {
    command = 'pyright.organizeimports',
    arguments = { vim.uri_from_bufnr(0) },
  }

  local clients = util.get_lsp_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    client.request('workspace/executeCommand', params, nil, 0)
  end
end

local function set_python_path(path)
  local clients = util.get_lsp_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client.notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

local function start_pyright_server()

    local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    }
    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Get the filename (full path) of the current buffer
    local filename = vim.api.nvim_buf_get_name(bufnr)

    local function get_root_dir(filename)
        return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
    end

    vim.lsp.start({
        cmd = { 'pyright-langserver', '--stdio' },
        root_dir = get_root_dir(filename),
        single_file_support = true,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
        commands = {
          PyrightOrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
          PyrightSetPythonPath = {
            set_python_path,
            description = 'Reconfigure pyright with the provided python path',
            nargs = 1,
            complete = 'file',
          },
        },
    })
end


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  desc = 'Start pyright LSP',
  callback = start_pyright_server,
})


