local deps = require("deps-lock")

return {
    "kdheepak/lazygit.nvim",
    commit = deps.lazygitNvim.commit,
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            commit = deps.plenaryNvim.commit,
        },
    },
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open Lazygit" },
    },
}
