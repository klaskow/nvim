local deps = require("deps-lock")

return {
    "stevearc/oil.nvim",
    commit = deps.oilNvim.commit,
    dependencies = {
        { "nvim-tree/nvim-web-devicons", commit = deps.nvimWebDevicons.commit },
    },
    opts = {},
    config = function()
        require("oil").setup({
            silent = true,
            keymaps = {
                ["gd"] = {
                    desc = "Toggle Details",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end,
                },
            },
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            delete_to_trash = true,
            win_options = {
                winbar = "%f %= %q %m",
            },
        })

        -- Hide '/001, /002' when 'syntax off' is set
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                if vim.bo.filetype == "oil" then
                    vim.cmd("syntax on")
                end
            end,
        })
        vim.api.nvim_create_autocmd("BufLeave", {
            callback = function()
                if vim.bo.filetype == "oil" then
                    vim.cmd("syntax off")
                end
            end,
        })

        -- local function append_to_log(message)
        --     local log_dir = vim.fn.expand("~/.oil")
        --     local log_file = log_dir .. "/message.log"

        --     if vim.fn.isdirectory(log_dir) == 0 then
        --         vim.fn.mkdir(log_dir, "p")
        --     end

        --     local text_message = type(message) == "table" and vim.inspect(message) or message

        --     local file = io.open(log_file, "a")
        --     if file then
        --         file:write(text_message .. "\n")
        --         file:close()
        --     else
        --         print("Nie można otworzyć pliku logu: " .. log_file)
        --     end
        -- end

        local function move_sync_vault(action)
            local src_path = action.src_url:gsub("^oil://", "")
            local dest_path = action.dest_url and action.dest_url:gsub("^oil://", "")
            local notes_base = vim.fn.expand("$HOME/GTD/Notes")
            local vault_base = vim.fn.expand("$HOME/GTD/Vault")

            local vault_src_path = src_path:gsub(notes_base, vault_base)
            local vault_dest_path = dest_path and dest_path:gsub(notes_base, vault_base)

            if action.entry_type == "file" then
                vault_src_path = vault_src_path .. ".gpg"
                if vault_dest_path then
                    vault_dest_path = vault_dest_path .. ".gpg"
                end
            end

            if vault_dest_path then
                os.execute(string.format("mkdir -p '%s'", vim.fn.fnamemodify(vault_dest_path, ":h")))
                os.execute(string.format("mv '%s' '%s'", vault_src_path, vault_dest_path))
            end
        end

        local function delete_sync_vault(action)
            local src_path = action.url:gsub("^oil://", "")
            local notes_base = vim.fn.expand("$HOME/GTD/Notes")
            local vault_base = vim.fn.expand("$HOME/GTD/Vault")
            local vault_path = src_path:gsub(notes_base, vault_base)

            if action.entry_type == "file" then
                vault_path = vault_path .. ".gpg"
            end

            os.execute(string.format("rm -rf '%s'", vault_path))
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(args)
                vim.schedule(function()
                    if args.data.err then
                        return
                    end

                    local current_dir = vim.fn.getcwd()
                    local gtd_base = vim.fn.expand("$HOME/GTD")
                    if current_dir:sub(1, #gtd_base) ~= gtd_base then
                        return
                    end

                    for _, action in ipairs(args.data.actions) do
                        if action.type == "move" then
                            move_sync_vault(action)
                        elseif action.type == "delete" then
                            delete_sync_vault(action)
                        end
                    end
                end)
            end,
        })

        vim.keymap.set("n", "<leader>o", "<cmd>silent! :Oil<CR>", { desc = "Open Oil" })
    end,
}
