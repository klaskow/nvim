local deps = require("deps-lock")

return {
    "nanozuki/tabby.nvim",
    commit = deps.tabbyNvim.commit,
    dependencies = {
        {
            "nvim-tree/nvim-web-devicons",
            commit = deps.nvimWebDevicons.commit,
        },
    },
    config = function()
        local tabby = require("tabby")
        local telescope = require("telescope")

        tabby.setup({})
        telescope.setup({
            vim.keymap.set("n", "<leader>tj", "<cmd>Tabby jump_to_tab<CR>", { desc = "Jump to Tab" }),
        })

        local function rename_tab_with_cwd()
            local cwd = vim.fn.getcwd()
            local project_name = vim.fn.fnamemodify(cwd, ":t")
            vim.cmd("Tabby rename_tab " .. project_name)
        end

        vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
            callback = function()
                rename_tab_with_cwd()
            end,
        })
    end,
}
