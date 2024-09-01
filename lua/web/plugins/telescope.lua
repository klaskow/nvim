local deps = require("deps-lock")
local common_rg_args = require("web.core.common_rg_args")

return {
    {
        "nvim-telescope/telescope.nvim",
        commit = deps.telescopeNvim.commit,
        dependencies = {
            {
                "nvim-lua/plenary.nvim",
                commit = deps.plenaryNvim.commit,
            },
            {
                "nvim-tree/nvim-web-devicons",
                commit = deps.nvimWebDevicons.commit,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                commit = deps.telescopeFileBrowserNvim.commit,
            },
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                commit = deps.telescopeLiveGrepArgsNvim.commit,
            },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local layout = require("telescope.actions.layout")
            local action_state = require("telescope.actions.state")
            local lga_actions = require("telescope-live-grep-args.actions")
            local lga_shortcuts = require("telescope-live-grep-args.shortcuts")

            local function grep_visual_selection()
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg("v")
                text = string.gsub(text, "\n", "")
                telescope.extensions.live_grep_args.live_grep_args({
                    default_text = '"' .. text .. '"' .. " " .. "-F",
                })
            end

            local function open_project(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                local is_dir = vim.fn.isdirectory(entry.path) == 1
                if is_dir then
                    local package_json = entry.path .. "/package.json"
                    local readme_md = entry.path .. "/README.md"

                    if vim.fn.filereadable(package_json) == 1 then
                        vim.cmd("tabnew " .. package_json)
                        return
                    elseif vim.fn.globpath(entry.path, "README.md", 0, 1)[1] then
                        vim.cmd("tabnew " .. readme_md)
                        return
                    end
                end

                vim.cmd("tabnew " .. entry.path)
            end

            local OPEN_MODE = {
                SYSTEM_DEFAULT_APP = { use_system_default = true },
                FILE_MANAGER_WITH_SELECT = { use_system_default = false }
            }

            local function get_mac_open_command(file_path, mode)
                if vim.fn.isdirectory(file_path) == 1 or not mode.use_system_default then
                    return { "open", "-R", file_path }
                else
                    return { "open", file_path }
                end
            end

            local function is_command_available(command)
                return os.execute("command -v " .. command .. " > /dev/null 2>&1") == 0
            end

            local function get_linux_open_command(file_path, mode)
                local is_directory = vim.fn.isdirectory(file_path) == 1

                local file_manager_cmd
                if is_command_available("dolphin") then
                    file_manager_cmd = { "dolphin", "--select", file_path }
                elseif is_command_available("thunar") then
                    file_manager_cmd = { "thunar", file_path }
                else
                    file_manager_cmd = { "xdg-open", file_path }
                end

                if is_directory or not mode.use_system_default then
                    return file_manager_cmd
                else
                    return { "xdg-open", file_path }
                end
            end

            local function get_open_command(file_path, mode)
                local system_name = vim.loop.os_uname().sysname

                if system_name == "Darwin" then
                    return get_mac_open_command(file_path, mode)
                elseif system_name == "Linux" then
                    return get_linux_open_command(file_path, mode)
                else
                    return { "xdg-open", file_path }
                end
            end

            local function open_selection_in_default_app(prompt_bufnr)
                local selected_entry = require("telescope.actions.state").get_selected_entry()
                local file_path = selected_entry.path or selected_entry.filename
                local open_cmd = get_open_command(file_path, OPEN_MODE.SYSTEM_DEFAULT_APP)
                -- require("telescope.actions").close(prompt_bufnr)
                vim.fn.jobstart(open_cmd, { detach = true })
            end

            local function open_selection_in_file_explorer(prompt_bufnr)
                local selected_entry = require("telescope.actions.state").get_selected_entry()
                local file_path = selected_entry.path or selected_entry.filename
                local open_cmd = get_open_command(file_path, OPEN_MODE.FILE_MANAGER_WITH_SELECT)
                -- require("telescope.actions").close(prompt_bufnr)
                vim.fn.jobstart(open_cmd, { detach = true })
            end

            local function delete_last_word_in_prompt(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local current_line = picker:_get_prompt()
                local new_line = current_line:gsub("%s*%S+%s*$", "")
                picker:set_prompt(new_line)
            end

            telescope.setup({
                defaults = {
                    dynamic_preview_title = true,
                    winblend = 10,
                    wrap_results = true,
                    scroll_strategy = "limit",
                    path_display = {
                        filename_first = {
                            reverse_directories = true,
                        },
                    },
                    vimgrep_arguments = vim.list_extend({ "rg" }, common_rg_args),
                    layout_strategy = "vertical",
                    layout_config = {
                        preview_cutoff = 1,
                    },
                    mappings = {
                        i = {
                            ["<C-o>"] = open_selection_in_default_app,
                            ["<C-e>"] = open_selection_in_file_explorer,
                            ["<C-l>"] = layout.cycle_layout_next,
                            ["<C-h>"] = layout.cycle_layout_prev,
                            ["<C-Down>"] = require("telescope.actions").cycle_history_next,
                            ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
                        },
                        n = {
                            ["<C-o>"] = open_selection_in_default_app,
                            ["<C-e>"] = open_selection_in_file_explorer,
                            ["<C-l>"] = layout.cycle_layout_next,
                            ["<C-h>"] = layout.cycle_layout_prev,
                            ["<C-Down>"] = require("telescope.actions").cycle_history_next,
                            ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = vim.list_extend({ "rg", "--files" }, common_rg_args),
                    },
                    live_grep = {
                        previewer = true,
                    },
                },
                extensions = {
                    file_browser = {
                        theme = "ivy",
                        mappings = {
                            ["i"] = {
                                ["<C-t>"] = open_project,
                                ["<C-w>"] = delete_last_word_in_prompt,
                            },
                            ["n"] = {
                                ["t"] = open_project,
                            },
                        },
                    },
                    live_grep_args = {
                        auto_quoting = true,
                        previewer = true,
                        mappings = {
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                -- freeze the current list and start a fuzzy search in the frozen list
                                ["<C-space>"] = actions.to_fuzzy_refine,
                            },
                        },
                    },
                },
            })

            telescope.load_extension("file_browser")
            telescope.load_extension("live_grep_args")

            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep_args<cr>", { desc = "Live Grep with Args" })
            vim.keymap.set("n", "<leader>fw", lga_shortcuts.grep_word_under_cursor, { desc = "Grep Word Under Cursor" })
            vim.keymap.set("v", "<leader>fv", grep_visual_selection, { desc = "Grep Visual Selection Under Cursor" })
            vim.keymap.set(
                "n",
                "<leader>fl",
                "<cmd>Telescope oldfiles theme=dropdown previewer=false<cr>",
                { desc = "Find Last Used Files" }
            )
            vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
            vim.keymap.set(
                "n",
                "<leader>fr",
                "<cmd>Telescope resume<cr>",
                { desc = "Lists Results of the Previous Picker" }
            )

            -- file browser
            vim.keymap.set("n", "<leader>fc", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
                { desc = "Browse Directory of the File " })
            vim.keymap.set("n", "<leader>fp", "<cmd>Telescope file_browser cwd=~/Projects<CR>", { desc = "Projects" })
            vim.keymap.set(
                "n",
                "<leader>f.",
                ":Telescope find_files cwd=~/.config/nvim<CR>",
                { desc = "Neovim Config" }
            )

            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopePreviewerLoaded",
                callback = function()
                    vim.wo.wrap = true
                    vim.wo.linebreak = true
                end,
            })

            return true
        end,
    },
    {
        "folke/todo-comments.nvim",
        commit = deps.todoCommentsNvim.commit,
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                commit = deps.telescopeNvim.commit,
            },
            {
                "nvim-lua/plenary.nvim",
                commit = deps.plenaryNvim.commit,
            },
            {
                "nvim-tree/nvim-web-devicons",
                commit = deps.nvimWebDevicons.commit,
            },
        },
        vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" }),
    },
}
