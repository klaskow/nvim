local deps = require("deps-lock")

return {
    "sindrets/diffview.nvim",
    commit = deps.diffviewNvim.commit,
    dependencies = {
        { "nvim-lua/plenary.nvim", commit = deps.plenaryNvim.commit }
    },
    config = function()
        require("diffview").setup({})

        vim.keymap.set("n", "<leader>df", ":DiffviewFileHistory %<CR>", { desc = "Diff Current File" })
    end,
}
