local deps = require("deps-lock")
local common_rg_args = require("web.core.common_rg_args")

return {
    "folke/todo-comments.nvim",
    commit = deps.todoCommentsNvim.commit,
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            commit = deps.plenaryNvim.commit,
        },
    },
    config = function()
        local todo_comments = require("todo-comments")

        vim.keymap.set("n", "<leader>]t", function()
            todo_comments.jump_next()
        end, { desc = "Next TODO" })

        vim.keymap.set("n", "<leader>[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous TODO" })

        todo_comments.setup({
            highlight = {
                comments_only = false,
            },
            search = {
                command = "rg",
                args = common_rg_args,
            },
        })
    end,
}
