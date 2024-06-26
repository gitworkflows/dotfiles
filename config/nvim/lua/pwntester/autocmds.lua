local create = vim.api.nvim_create_augroup
local define = vim.api.nvim_create_autocmd


define({ "User" }, {
  pattern = "LazyVimStarted",
  callback = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    local pad_footer = string.rep(" ", 8)
    print("⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms")
  end,
})

create("bitacora", { clear = true })

define({ "TermEnter", "WinEnter", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.filetype
    if vim.tbl_contains({ "octo", "frecency", "TelescopePrompt", "TelescopeResults" }, ft) then
      vim.wo.foldcolumn = '0'
    elseif vim.tbl_contains(g.special_buffers, ft) then
      vim.wo.foldcolumn = '0'
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
    elseif ft == "" or vim.bo.buftype == "terminal" then
      vim.wo.foldcolumn = '0'
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
    else
      vim.wo.foldcolumn = '1'
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal")
    end
    vim.api.nvim_command [[au FileType * set fo-=c fo-=r fo-=o]]
    if vim.bo.buftype == "terminal" then
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
      vim.wo.cursorline = false
    end
  end,
})
define({ "FocusGained", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    -- check if file was changed externally
    vim.cmd [[checktime]]
  end,
})
define({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank { on_visual = false, higroup = "IncSearch", timeout = 500 }
  end,
})
define({ "BufEnter" }, {
  pattern = { "*.txt" },
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "help" then
      vim.cmd [[wincmd L]]
    end
  end,
})
define({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.bo.ft == "markdown" then
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    else
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = "»",
        },
      })
    end
  end,
})
-- define({ "BufWritePost" }, {
--   pattern = { "*/plugins/init.lua" },
--   callback = function()
--     vim.cmd [[source <afile> | PackerCompile | echo "Reloaded!" ]]
--   end,
-- })
-- winbar
define({ "CursorMoved", "BufWinEnter", "BufFilePost", "LspAttach" }, {
  pattern = { "*" },
  callback = function()
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")
    local filetype = vim.bo.filetype
    local bufname = vim.fn.bufname()
    if buftype == "nofile" and vim.split(bufname, ":/")[1] == "ql" then
      vim.opt_local.winbar = require("gitworkflows.winbar").winbar()
    elseif vim.tbl_contains(g.special_buffers, filetype) or
        buftype == "prompt" or
        buftype == "nofile" or
        filetype == "markdown" then
      vim.opt_local.winbar = nil
    else
      vim.opt_local.winbar = require("gitworkflows.winbar").winbar()
    end
  end,
})
-- define({ "BufWritePost" }, {
--   group = "bitacora",
--   pattern = { "*/bitacora/*" },
--   callback = function()
--     require("gitworkflows.markdown").asyncPush()
--   end,
-- })
