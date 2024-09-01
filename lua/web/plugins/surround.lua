local deps = require("deps-lock")

return {
    "kylechui/nvim-surround",
    commit = deps.nvimSurround.commit,
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end,
}
