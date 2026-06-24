-- Color for catppuccin
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", ctermbg = "none" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", ctermbg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "none" })
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "catppuccin*",
  callback = function()
    vim.api.nvim_set_hl(0, "Comment", { fg = "#c3cbce" })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "Operator", { fg = "#ffffff" })
  end,
})

vim.cmd.colorscheme("catppuccin")


-- Open left explorer
vim.g.netrw_winsize = 25
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    command = "silent! lcd %:p:h"
})

vim.keymap.set('n', '<C-a>', function()
    local netrw_win = nil
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "netrw" then
            netrw_win = win
            break
        end
    end

    if netrw_win then
        vim.api.nvim_win_close(netrw_win, true)
    else
        vim.cmd('Lexplore')
    end
end, { silent = true })


local function resize_netrw(amount)
    local netrw_win = nil
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "netrw" then
            netrw_win = win
            break
        end
    end

    if netrw_win then
        local current_win = vim.api.nvim_get_current_win()
        
        vim.api.nvim_set_current_win(netrw_win)
        vim.cmd("vertical resize " .. amount)
        vim.api.nvim_set_current_win(current_win)
    end
end

-- decrease/increase of the left explorer
vim.keymap.set('n', '<C-x>', function()
    resize_netrw("-5")
end, { silent = true })

vim.keymap.set('n', '<C-c>', function()
    resize_netrw("+5")
end, { silent = true })

-- Copy
vim.keymap.set(
    'v', '<C-y>', '"+y', 
    { noremap = true, silent = true }
)

-- Enter visual mode from ANY state for selection with arrows
vim.keymap.set(
    { 'n', 'i', 'v' },
    '<A-C-a>', '<Esc>v',
    { noremap = true, silent = true }
)

-- Deleting a word using Ctrl + Backspace in insert modevim.keymap.set(
vim.keymap.set(
    'i', '<C-BS>', '<C-w>',
    { noremap = true, silent = true }
)
