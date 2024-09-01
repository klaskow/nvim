local deps = require("deps-lock")

return {
    "numToStr/Comment.nvim",
    commit = deps.commentNvim.commit,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            commit = deps.nvimTsContextCommentstring.commit,
        },
    },
    config = function()
        local comment = require("Comment")
        local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

        comment.setup({
            pre_hook = ts_context_commentstring.create_pre_hook(),
        })
    end,
}
