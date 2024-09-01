vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.md", "*.mdx" },
    callback = function()
        vim.bo.filetype = "markdown"
    end,
})
