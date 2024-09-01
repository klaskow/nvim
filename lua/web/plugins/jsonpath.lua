local deps = require("deps-lock")

return {
    "phelipetls/jsonpath.nvim",
    commit = deps.jsonpathNvim.commit,
    config = function()
        if vim.fn.exists("+winbar") == 1 then
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "json",
                callback = function()
                    vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
                end,
            })
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "json",
            callback = function()
                vim.keymap.set("n", "y<C-p>", function()
                    vim.fn.setreg("+", require("jsonpath").get())
                end, { desc = "Copy JSON path", buffer = true })
            end,
        })
    end,
}
