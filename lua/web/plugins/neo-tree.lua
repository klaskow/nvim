local deps = require("deps-lock")

return {
    "nvim-neo-tree/neo-tree.nvim",
    commit = deps.neoTreeNvim.commit,
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            commit = deps.plenaryNvim.commit,
        },
        {
            "nvim-tree/nvim-web-devicons",
            commit = deps.nvimWebDevicons.commit,
        },
        {
            "MunifTanjim/nui.nvim",
            commit = deps.nuiNvim.commit,
        },
    },
    config = function()
        vim.keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Toggle File Explorer" })
        vim.keymap.set(
            "n",
            "<leader>er",
            "<cmd>Neotree toggle reveal<CR>",
            { desc = "Toggle File Explorer on Current File" }
        )
        vim.keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Collapse file explorer" })
    end,
}
