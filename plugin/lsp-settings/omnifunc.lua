-- plugin/autocomplete.lua

local group_name = "AutoCompletionGroup"
local file_types = {'c', 'cpp', 'cuda', 'lua', 'sh', 'python', 'dockerfile'}
local file_types_to_extensions = {
    lua = 'lua',
    c = 'c',
    cpp = 'cpp',
    python = 'py',
    cuda = 'cu',
    sh = 'sh',
    dockerfile = 'dockerfile'
}

local is_active = true

local function set_autocomplete(file_type, group_name)

    vim.o.completeopt = "menuone,noselect"

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*." .. file_types_to_extensions[file_type],
        callback = function()
            vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
        group = group_name
    })

    vim.api.nvim_create_autocmd("InsertCharPre", {
        pattern = "*." .. file_types_to_extensions[file_type],
        callback = function()
            if vim.fn.col('.') > 1 then
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
                    'n', true
                )
            end
        end,
        group = group_name
    })

end

local function create_autogroup(group_name, file_types)
    vim.api.nvim_create_augroup(group_name, {clear = true})
    for _, file_type in ipairs(file_types) do
        set_autocomplete(file_type, group_name)
    end
    is_active = true
end

local function delete_autogroup(group_name)
    vim.api.nvim_create_augroup(group_name, {clear = true})
    is_active = false
end

local function toggle_autogroup()
    if is_active then
        delete_autogroup(group_name)
    else
        create_autogroup(group_name, file_types)
    end
end

-- Navigate completion options with <Tab> and <Shift-Tab>
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true, silent = true })

-- Enter to confirm completion without moving to a new line
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { noremap = true, expr = true, silent = true })

vim.api.nvim_create_user_command("ToggleAutoCompletionGroup", toggle_autogroup, {})

toggle_autogroup()

-- Customize the appearance of the completion menu in Lua with Kanagawa theme
-- vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#16161D', fg = '#DCD7BA' })  -- Dark background with light text (matches Kanagawa's style)
-- vim.api.nvim_set_hl(0, 'PmenuKind', { bg = '#1F1F28', fg = '#DCD7BA' })  -- Dark background with light text (matches Kanagawa's style)
-- 
-- vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#2d4f67', fg = '#C8C093' })  -- Light highlight background and yellow text for selected item
-- vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#16161D', fg = '#C8C093' })  -- Customize the scrollbar thumb (Kanagawa's accent color)
-- 
-- vim.api.nvim_set_hl(0, 'PmenuBorder', { bg = '#ffffff', fg = '#ffffff' })



