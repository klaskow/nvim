local deps = require("deps-lock")

return {
    "norcalli/nvim-colorizer.lua",
    commit = deps.nvimColorizerLua.commit,
    config = function()
        require("colorizer").setup({
            "*",
        }, {
            mode = "background",
            RGB = true,
            RRGGBB = true,
            RRGGBBAA = true,
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
            names = false,
        })
    end,
}
