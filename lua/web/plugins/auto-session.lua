local deps = require("deps-lock")

return {
    "rmagatti/auto-session",
    commit = deps.autoSession.commit,
    config = function()
        local auto_session = require("auto-session")

        auto_session.setup({
            auto_restore = false,
            suppressed_dirs = { "~", "~/", "~/Downloads", "~/Desktop/" },
        })

        vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore Session" })
        vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save Session" })
    end,
}
