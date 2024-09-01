local deps = require("deps-lock")

return {
    {
        enable = false,
        "airblade/vim-rooter",
        commit = deps.vimRooter.commit,
        config = function()
            vim.g.rooter_cd_cmd = "tcd"
            vim.g.rooter_silent_chdir = 1
            vim.g.rooter_resolve_links = 1
            vim.g.rooter_patterns = { '=Notes', 'package.json', '.git' }
        end,
    },
}
