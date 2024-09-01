local deps = require("deps-lock")

return {
    "NeogitOrg/neogit",
    commit = deps.neogit.commit,
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            commit = deps.plenaryNvim.commit,
        },
        {
            "sindrets/diffview.nvim",
            commit = deps.diffviewNvim.commit,
        },
        {
            "nvim-telescope/telescope.nvim",
            commit = deps.telescopeNvim.commit,
        },
    },
    config = true,
}
