return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup()

    vim.keymap.set({'n', 't'}, '<C-;>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Bottom terminal' })

    -- Scooter integration

    local Terminal = require("toggleterm.terminal").Terminal
    local scooter_term = nil

    local function open_scooter()
        if not scooter_term then
            scooter_term = Terminal:new({
                cmd = "scooter",
                direction = "float",
                close_on_exit = true,
                on_exit = function()
                    scooter_term = nil
                end
            })
        end
        scooter_term:open()
    end

    _G.EditLineFromScooter = function(file_path, line)
        if scooter_term and scooter_term:is_open() then
            scooter_term:close()
        end

        local current_path = vim.fn.expand("%:p")
        local target_path = vim.fn.fnamemodify(file_path, ":p")

        if current_path ~= target_path then
            vim.cmd.edit(vim.fn.fnameescape(file_path))
        end

        vim.api.nvim_win_set_cursor(0, { line, 0 })
    end

    _G.OpenScooterSearchText = function(search_text)
        if scooter_term and scooter_term:is_open() then
            scooter_term:close()
        end

        local escaped_text = vim.fn.shellescape(search_text:gsub("\r?\n", " "))
        scooter_term = Terminal:new({
            cmd = "scooter --search-text " .. escaped_text,
            direction = "float",
            close_on_exit = true,
            on_exit = function()
                scooter_term = nil
            end
        })
        scooter_term:open()
    end

    vim.keymap.set('n', '<leader>ts', open_scooter, { desc = 'Toggle scooter' })
    vim.keymap.set('v', '<leader>ts',
        '"ay<ESC><cmd>lua OpenScooterSearchText(vim.fn.getreg("a"))<CR>',
        { desc = 'Search selected text in scooter' })
  end
}
