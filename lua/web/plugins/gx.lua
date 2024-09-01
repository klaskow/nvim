local deps = require("deps-lock")

return {
    "chrishrb/gx.nvim",
    commit = deps.gxNvim.commit,
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    config = true,
}
