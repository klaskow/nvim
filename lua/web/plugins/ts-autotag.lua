local deps = require("deps-lock")

return {
    'windwp/nvim-ts-autotag',
    commit = deps.nvimTsAutotag.commit,
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter', commit = deps.nvimTreesitter.commit }
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('nvim-ts-autotag').setup({})
    end,
}
