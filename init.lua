---------------------------------------------------------------------------------------------------
-- Author Preetham Rakshith (c) 2024.
-- github profile : github.com/th-blitz
-- My personal nvim config file. 
----------------------------------------------------------------------------------------------------


-- from nvim-treesitter readme repo:
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "rust", "cpp", "python", "lua", "vim", "vimdoc", "query", "hcl", "terraform", "bash" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {  },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = {  },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

require'nvim-web-devicons'.setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    -- override = {
        --  zsh = {
            --    icon = "",
            --    color = "#428850",
            --    cterm_color = "65",
            --    name = "Zsh"
            --  }
            -- };
            -- globally enable different highlight colors per icon (default to true)
            -- if set to false all icons will have the default icon's color
            color_icons = true;
            -- globally enable default icons (default to false)
            -- will get overriden by `get_icons` option
            default = true;
            -- globally enable "strict" selection of icons - icon will be looked up in
            -- different tables, first by filename, and if not found by extension; this
            -- prevents cases when file doesn't have any extension but still gets some icon
            -- because its name happened to match some extension (default to false)
            strict = true;
            -- same as `override` but specifically for overrides by filename
            -- takes effect when `strict` is true
            -- override_by_filename = {
                --  [".gitignore"] = {
--    icon = "",
--    color = "#f1502f",
--    name = "Gitignore"
--  }
-- };
-- -- same as `override` but specifically for overrides by extension
-- -- takes effect when `strict` is true
-- override_by_extension = {
--  ["log"] = {
    --    icon = "",
    --    color = "#81e043",
    --    name = "Log"
    --  }
    -- };
}

require("ibl").setup()

-- Default options:
require('kanagawa').setup({
    compile = true,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    theme = "wave",              -- Load "wave" theme when 'background' option is not set
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",           -- try "dragon" !
        light = "lotus"
    },
})

-- setup must be called before loading;
vim.cmd("colorscheme kanagawa")

-- setup lualine;
require('lualine').setup({
    sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {'buffers'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },

})

-- toggle term;
-- require("toggleterm").setup()
require("telescope").setup {
    defaults = {
        case_sensitive = true,
    }
}

----------------------------------------------------------------------------------------------------

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true

vim.opt.wrap = true
vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.path:append "**"
----------------------------------------------------------------------------------------------------
-- source : https://toddknutson.bio/posts/how-to-enable-neovim-undo-backup-and-swap-files-when-switching-linux-groups/
-- purpose of this block : To create backups, swap files and persistent undo capabilities for edited files in nvim.

vim.g.backups = vim.env.HOME .. "/.nvimcache/"

BACKUP_DIR = vim.g.backups .. "backup/"
SWAP_DIR = vim.g.backups .. "swap/"
UNDO_DIR = vim.g.backups .. "undo/"

if vim.fn.isdirectory(SWAP_DIR) == 0 then
    vim.fn.mkdir(SWAP_DIR, "p", "0o700")
end

if vim.fn.isdirectory(BACKUP_DIR) == 0 then
    vim.fn.mkdir(BACKUP_DIR, "p", "0o700")
end

if vim.fn.isdirectory(UNDO_DIR) == 0 then
    vim.fn.mkdir(UNDO_DIR, "p", "0o700")
end

vim.opt.directory = SWAP_DIR
vim.opt.backupdir = BACKUP_DIR
vim.opt.undodir = UNDO_DIR

vim.opt.swapfile = true
vim.opt.backup = true
vim.opt.undofile = true

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local extension = "~" .. vim.fn.strftime("%Y-%m-%d-%H%M%S")
        vim.o.backupext = extension
    end,
})

----------------------------------------------------------------------------------------------------
-- lsp setup.
-- https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
-- purpose of the script : Manage LSP.

vim.lsp.set_log_level('debug')
vim.opt.signcolumn = 'yes'

-- you can add this in your init.lua
-- (note: diagnostics are not exclusive to LSP)
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local bufmap = function(mode, lhs, rhs)
            local opts = {buffer = event.buf}
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- You can find details of these function in the help page
        -- see for example, :help vim.lsp.buf.hover()

        -- Trigger code completion
        bufmap('i', '<C-Space>', '<C-x><C-o>')

        -- Display documentation of the symbol under the cursor
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

        -- Jump to declaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Lists all the implementations for the symbol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

        -- Lists all the references 
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

        -- Displays a function's signature information
        bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        -- Renames all references to the symbol under the cursor
        bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

        -- Format current file
        bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format()<cr>')

        -- Selects a code action available at the current cursor position
        bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    end
})

vim.opt.completeopt = { "menu", "menuone", "noselect" }  -- Add other options you need, but omit 'preview'

-- set .sbatch files as `sh` filetype in nvim.
-- vim.cmd('autocmd BufNewFile,BufRead *.sbatch set filetype=sh')

----------------------------------------------------------------------------------------------------

-- Custome keybindings for most used plugins.

vim.api.nvim_set_keymap('n', '<C-n>', ':lua vim.cmd("bnext")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':lua vim.cmd("bprev")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':Explore<CR>', { noremap = true, silent = true })

--- :NvimTreeToggle
-- vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = false })

vim.g.mapleader = " "

--- :Telescope find_files 
vim.api.nvim_set_keymap('n', '<Leader>tf', ':Telescope find_files <CR>', { noremap = true, silent = false })

--- :Telescope live_grep 
vim.api.nvim_set_keymap('n', '<Leader>ts', ':Telescope grep_string search_dirs=. <CR>', { noremap = true, silent = false })

--- :undotreeToggle
vim.api.nvim_set_keymap('n', '<Leader>ut', ':UndotreeToggle<CR>', { noremap = true, silent = false })

--- :1ToggleTerm
vim.api.nvim_set_keymap('n', '<Leader>tt', ':1ToggleTerm<CR>', { noremap = true, silent = false })

--- :2ToggleTerm
vim.api.nvim_set_keymap('n', '<Leader>2tt', ':2ToggleTerm<CR>', { noremap = true, silent = false })

--- :3ToggleTerm
vim.api.nvim_set_keymap('n', '<Leader>3tt', ':3ToggleTerm<CR>', { noremap = true, silent = false })

--- :qa! 
vim.api.nvim_set_keymap('n', '<Leader>qa', ':qa!<CR>', { noremap = true, silent = false })

-- :w
vim.api.nvim_set_keymap('n', '<Leader>s', ':w<CR>', { noremap = true, silent = false })

-- remap terminal esc. 
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = false })

----------------------------------------------------------------------------------------------------

-- vim.cmd("colorscheme spaceduck")

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

