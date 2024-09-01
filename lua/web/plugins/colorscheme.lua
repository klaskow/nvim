local deps = require("deps-lock")

return {
    "Mofiqul/vscode.nvim",
    commit = deps.vscodeNvim.commit,
    priority = 1000,
    config = function()
        require("vscode").setup({
            style = "dark",
            transparent = true,
            italic_comments = true,
        })
        require("vscode").load()

        vim.cmd([[
            highlight CursorLine guibg=NONE
            highlight StatusLine guibg=NONE
        ]])

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                local c = require("vscode.colors").get_colors()

                vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = c.vscRed, bold = true })
                vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = c.vscPink, bold = true })
                vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = c.vscOrange, bold = true })
                vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = c.vscBlue, bold = true })
                vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = c.vscGreen, bold = true })
                vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = c.vscPurple, bold = true })
                vim.api.nvim_set_hl(
                    0,
                    "@custom.fenced_code_block_language.markdown",
                    { fg = c.vscFront, bold = true, italic = true, underline = true, reverse = false }
                )
            end,
        })
    end,
}
