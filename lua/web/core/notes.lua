local function attach_todo_comments()
    vim.defer_fn(function()
        local status_ok, todo_comments = pcall(require, "todo-comments.highlight")
        if status_ok then
            todo_comments.attach(0)
            vim.cmd("redraw")
        end
    end, 10)
end

vim.api.nvim_create_user_command("Notes", function()
    vim.cmd("edit " .. vim.fn.expand("~/Notes"))
end, { desc = "Open ~/Notes Directory" })

vim.api.nvim_create_user_command("Inbox", function()
    local dir_path = vim.fn.expand("~/Notes/Inbox/")

    local file_name = vim.g.is_termux and "Inbox_Mobile.md" or "Inbox.md"
    local file_path = dir_path .. file_name

    if vim.fn.isdirectory(dir_path) == 0 then
        vim.fn.mkdir(dir_path, "p")
    end

    if vim.fn.bufnr(file_path) ~= -1 and vim.fn.filereadable(file_path) == 0 then
        vim.cmd("bwipeout " .. vim.fn.bufnr(file_path))
    end

    local file_exists = vim.fn.filereadable(file_path) == 1

    vim.cmd("edit " .. file_path)

    if not file_exists then
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# Inbox" })
    end

    attach_todo_comments()
    vim.cmd("write")
end, { desc = "Open Inbox Notes" })

vim.api.nvim_create_user_command("Journal", function()
    local current_date = os.date("%Y-%m-%d")
    local dir_path = vim.fn.expand("~/Notes/Journal/")

    if vim.fn.isdirectory(dir_path) == 0 then
        vim.fn.mkdir(dir_path, "p")
    end

    local file_name = vim.g.is_termux and current_date .. "_Mobile.md" or current_date .. ".md"
    local file_path = dir_path .. file_name
    local buf_exists = vim.fn.bufnr(file_path) ~= -1

    if buf_exists and vim.fn.filereadable(file_path) == 0 then
        vim.cmd("bwipeout " .. vim.fn.bufnr(file_path))
    end

    local file_exists = vim.fn.filereadable(file_path) == 1

    vim.cmd(":e " .. file_path)

    if not file_exists then
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. current_date })
    end

    attach_todo_comments()
    vim.cmd(":w")
end, { desc = "Open Journal" })

local function handle_gpg_file(bufnr)
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if not filepath:match("%.gpg$") then
        return
    end

    local decrypted_path = filepath:gsub("/Vault/", "/Notes/"):gsub("%.gpg$", "")
    local destination_dir = vim.g.is_termux and vim.fn.expand("$HOME/storage/downloads") or
        vim.fn.expand("$HOME/Downloads")

    local decrypted_dir = vim.fn.fnamemodify(decrypted_path, ":h")
    if vim.fn.isdirectory(decrypted_dir) == 0 then
        vim.fn.mkdir(decrypted_dir, "p")
        vim.api.nvim_out_write("Directory created: " .. decrypted_dir .. "\n")
    end

    if vim.fn.filereadable(decrypted_path) == 1 then
        local confirm_overwrite = vim.fn.confirm("File '" .. decrypted_path .. "' exists. Overwrite?", "&Yes\n&No", 2)
        if confirm_overwrite ~= 1 then
            vim.api.nvim_out_write("Decryption canceled. The file was not overwritten.\n")
            vim.cmd("edit " .. decrypted_path)
            return
        end

        os.remove(decrypted_path)
        vim.api.nvim_out_write("Existing file removed: " .. decrypted_path .. "\n")
    end

    os.execute(string.format("gpg --quiet --yes --output '%s' --decrypt '%s'", decrypted_path, filepath))
    vim.api.nvim_out_write("File decrypted and moved to: " .. decrypted_path .. "\n")

    local confirm_copy = vim.fn.confirm("Do you want to copy the file to " .. destination_dir .. "?", "&Yes\n&No", 2)
    if confirm_copy == 1 then
        local file_name = vim.fn.fnamemodify(decrypted_path, ":t")
        local copy_command = string.format("cp '%s' '%s/'", decrypted_path, destination_dir)
        os.execute(copy_command)
        vim.api.nvim_out_write("File copied to: " .. destination_dir .. "/" .. file_name .. "\n")
    else
        vim.api.nvim_out_write("File was not copied.\n")
    end

    vim.cmd("edit " .. decrypted_path)

    -- Refresh the interface
    vim.schedule_wrap(function()
        vim.api.nvim_command("redraw!")
        vim.api.nvim_command("mode")
    end)()
end

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.gpg",
    callback = function(args)
        handle_gpg_file(args.buf)
    end,
})
