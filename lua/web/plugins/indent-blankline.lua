local deps = require("deps-lock")

return {
    "lukas-reineke/indent-blankline.nvim",
    commit = deps.indentBlanklineNvim.commit,
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
        indent = { char = "┊" },
        scope = { enabled = true },
    },
}
