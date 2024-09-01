local deps = require("deps-lock")

return {
    "MeanderingProgrammer/render-markdown.nvim",
    commit = deps.renderMarkdown.commit,
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter",
            commit = deps.nvimTreesitter.commit,
        },
        {
            "nvim-tree/nvim-web-devicons",
            commit = deps.nvimWebDevicons.commit,
        },
    },
    config = function()
        require('render-markdown').setup({
            heading = {
                enabled = false,
            }
        })
    end
}
