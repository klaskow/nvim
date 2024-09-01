local deps = require("deps-lock")

local function disable_on_large_files_or_long_lines(lang, buf)
    local ignores_filetypes = { "md", "mdx", "ts", "tsx" }
    local filename = vim.api.nvim_buf_get_name(buf)
    for _, ext in ipairs(ignores_filetypes) do
        if filename:match("%." .. ext .. "$") then
            return false
        end
    end

    local max_filesize = 512 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
        return true
    end

    local max_line_length = 512
    local line_count = math.min(25, vim.api.nvim_buf_line_count(buf))
    for i = 1, line_count do
        local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
        if #line > max_line_length then
            return true
        end
    end

    return false
end

return {
    "nvim-treesitter/nvim-treesitter",
    commit = deps.nvimTreesitter.commit,
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            ensure_installed = {
                "angular",
                "awk",
                "bash",
                "bash",
                "c_sharp",
                "c",
                "cmake",
                "cpp",
                "css",
                "dockerfile",
                "editorconfig",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "gpg",
                "graphql",
                "groovy",
                "html",
                "http",
                "java",
                "javascript",
                "jsdoc",
                "json",
                "json5",
                "kotlin",
                "lua",
                "luadoc",
                "make",
                "markdown_inline",
                "markdown",
                "norg",
                "perl",
                "php",
                "phpdoc",
                "powershell",
                "prisma",
                "python",
                "query",
                "regex",
                "ruby",
                "rust",
                "scheme",
                "scss",
                "sql",
                "ssh_config",
                "styled",
                "tmux",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "vue",
                "xml",
                "yaml",
            },
            highlight = {
                enable = true,
                disable = disable_on_large_files_or_long_lines,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
