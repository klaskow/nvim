local deps = require("deps-lock")

return {
    "goolord/alpha-nvim",
    commit = deps.alphaNvim.commit,
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {}
        dashboard.section.buttons.val = {
            dashboard.button("i", "  > Inbox", "<cmd>Inbox<CR>"),
            dashboard.button("j", "  > Journal", "<cmd>Journal<CR>"),
            dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
            dashboard.button("SPC wr", "󰁯  > Restore Session for CWD", "<cmd>SessionRestore<CR>"),
            dashboard.button("q", "  > Quit Neovim", "<cmd>qa<CR>"),
        }
        dashboard.opts.layout = {
            { type = "padding", val = 0 },
            dashboard.section.buttons,
        }

        alpha.setup(dashboard.opts)
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
