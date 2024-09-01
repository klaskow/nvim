local deps = require("deps-lock")

return {
    "folke/trouble.nvim",
    commit = deps.troubleNvim.commit,
    dependencies = {
        {
            "nvim-tree/nvim-web-devicons",
            commit = deps.nvimWebDevicons.commit,
        },
        {
            "folke/todo-comments.nvim",
            commit = deps.todoCommentsNvim.commit,
        },
    },
    opts = {
        focus = true,
        auto_preview = true,
        restore = true,
        auto_close = false,
        auto_open = false,
        auto_refresh = true,
        auto_jump = false,
        follow = false,
    },
    cmd = "Trouble",
    keys = {
        {
            "<leader>xw",
            "<cmd>Trouble diagnostics toggle<CR>",
            desc = "Open Trouble Workspace Diagnostics",
        },
        {
            "<leader>xd",
            "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
            desc = "Open Trouble Document Diagnostics",
        },
        { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open Trouble Quickfix List" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open Trouble Location List" },
        { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open TODOs in Trouble" },
        { "<leader>xx", "<cmd>Trouble toggle<CR>", desc = "Close Trouble" },
    },
}
