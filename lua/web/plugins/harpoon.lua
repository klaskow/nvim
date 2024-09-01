local deps = require("deps-lock")

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    commit = deps.harpoon.commit,
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            commit = deps.plenaryNvim.commit,
        },
    },
    config = function()
        local harpoon = require("harpoon")

        vim.keymap.set("n", "<leader>ba", function()
            harpoon:list():add()
            vim.api.nvim_echo({ { "File added to Harpoon!", "Normal" } }, false, {})
            vim.defer_fn(function()
                vim.api.nvim_echo({ { "" } }, false, {})
            end, 1000)
        end)
        vim.keymap.set("n", "<leader>bl", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)
        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end)
        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end)
        vim.keymap.set("n", "<leader>5", function()
            harpoon:list():select(5)
        end)
        vim.keymap.set("n", "<leader>6", function()
            harpoon:list():select(6)
        end)
        vim.keymap.set("n", "<leader>7", function()
            harpoon:list():select(7)
        end)
        vim.keymap.set("n", "<leader>8", function()
            harpoon:list():select(8)
        end)
        vim.keymap.set("n", "<leader>9", function()
            harpoon:list():select(9)
        end)
        vim.keymap.set("n", "<leader>0", function()
            harpoon:list():select(0)
        end)
        vim.keymap.set("n", "<leader>bp", function()
            harpoon:list():prev()
        end)
        vim.keymap.set("n", "<leader>bn", function()
            harpoon:list():next()
        end)
    end,
}
