local function is_command_available(command)
    return os.execute("command -v " .. command .. " > /dev/null 2>&1") == 0
end

local function get_linux_file_explorer_command(file_path)
    if is_command_available("dolphin") then
        return { "dolphin", "--select", file_path }
    elseif is_command_available("nautilus") then
        return { "nautilus", "--select", file_path }
    elseif is_command_available("thunar") then
        return { "thunar", file_path }
    end
end

function OpenBufferInFileExplorer()
    local system_name = vim.loop.os_uname().sysname
    local file_path = vim.fn.expand("%:p")
    local open_cmd

    if system_name == "Darwin" then
        open_cmd = { "open", "-R", file_path }
    elseif system_name == "Linux" then
        open_cmd = get_linux_file_explorer_command(file_path)
    end

    vim.fn.jobstart(open_cmd, { detach = true })
end


function OpenBufferInDefaultApp()
    local system_name = vim.loop.os_uname().sysname
    local file_path = vim.fn.expand("%:p")
    local open_cmd

    if system_name == "Darwin" then
        open_cmd = { "open", file_path }
    elseif system_name == "Linux" then
        open_cmd = { "xdg-open", file_path }
    end

    vim.fn.jobstart(open_cmd, { detach = true })
end

vim.api.nvim_set_keymap(
    'n',
    '<leader>ge',
    [[:lua OpenBufferInFileExplorer()<CR>]],
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>go',
    [[:lua OpenBufferInDefaultApp()<CR>]],
    { noremap = true, silent = true }
)
