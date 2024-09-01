local deps = require("deps-lock")

return {
    "ggandor/leap.nvim",
    commit = deps.leapNvim.commit,
    dependencies = {
        { "tpope/vim-repeat", commit = deps.vimRepeat.commit, },
    },
    config = function()
        local leap = require("leap")
        leap.setup({
            default_keymaps = false,
            safe_labels = {},
            preview_filter = function() return false end,
        })

        vim.api.nvim_set_keymap("n", "s", "<Plug>(leap-forward)", {})
        vim.api.nvim_set_keymap("n", "S", "<Plug>(leap-backward)", {})
    end,
}
