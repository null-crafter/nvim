local M = {}

local state = {
  buf = nil,
  win = nil,
  height = 14,
}

local function buf_valid()
  return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end

local function win_valid()
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function open_window()
  vim.cmd('botright ' .. state.height .. 'split')
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.win, state.buf)
  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].signcolumn = 'no'
  vim.cmd('startinsert')
end

function M.toggle()
  if win_valid() then
    state.height = vim.api.nvim_win_get_height(state.win)
    vim.api.nvim_win_hide(state.win)
    state.win = nil
    return
  end

  if not buf_valid() then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].bufhidden = 'hide'
    open_window()
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = function()
        state.buf = nil
        state.win = nil
      end,
    })
  else
    open_window()
  end
end

vim.api.nvim_create_user_command('TermToggle', M.toggle, {})

return M
