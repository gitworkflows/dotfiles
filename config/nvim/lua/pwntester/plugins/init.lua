-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local plugin_specs = {

  -- THEMES & COLORS
  {
    'kwsp/halcyon-neovim'
  },
  {
    'Shatur/neovim-ayu',
    config = function()
      require('ayu').setup({
        mirage = true,
        overrides = {},
        -- overrides = {
        --   Normal = { bg = "None" },
        --   ColorColumn = { bg = "None" },
        --   SignColumn = { bg = "None" },
        --   Folded = { bg = "None" },
        --   FoldColumn = { bg = "None" },
        --   CursorLine = { bg = "None" },
        --   CursorColumn = { bg = "None" },
        --   WhichKeyFloat = { bg = "None" },
        --   VertSplit = { bg = "None" },
        -- },
      })
    end
  },
  {
    "gitworkflows/nautilus.nvim",
    dev = true,
    config = function()
      require("nautilus").load {
        transparent = false,
        mode = "octonauts"
      }
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    branch = "color-editor",
  },
  {
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup({})
    end
  },

  -- BASICS
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },
  {
    "kazhala/close-buffers.nvim",
    config = function()
      require("close_buffers").setup {
        filetype_ignore = {},
        preserve_window_layout = { "this" },
      }
    end,
    -- BDelete! all glob=*octo://*
  },

  -- TELESCOPE.NVIM
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = "tami5/sqlite.lua",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-github.nvim" }
    },
    config = function()
      require("gitworkflows.plugins.telescope").setup()
    end,
  },
  {
    "gitworkflows/telescope-zip.nvim",
    dev = true,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    }
  },

  -- COMPLETION
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      --[[{
        "L3MON4D3/LuaSnip",
        dependencies = {
          { "nvim-cmp" },
          { "rafamadriz/friendly-snippets" },
        },
        config = function()
          require("gitworkflows.plugins.luasnip").setup()
        end,
      },]] --
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-emoji" },
    },
    config = function()
      require("gitworkflows.plugins.nvim-cmp").setup()
    end,
  },

  -- SNIPPETS
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.cmd([[imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")]])
      vim.g.copilot_filetypes = {
        ["*"] = false,
        python = true,
        sh = true,
        lua = true,
        go = true,
        ql = true,
        html = true,
        javascript = true,
        typescript = true,
      }
    end,
  },

  -- LISTS
  {
    "gaoDean/autolist.nvim",
    config = function()
      require('autolist').setup({})
    end,
  },
  -- PAIRS
  {
    "windwp/nvim-autopairs",
    dependencies = { "nvim-cmp" },
    config = function()
      local npairs = require "nvim-autopairs"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local Rule = require "nvim-autopairs.rule"
      npairs.setup {
        disable_filetype = { "TelescopePrompt", "octo" },
        --ignored_next_char = [[ [%w%%%{%(%[%'%'%.] ]]
        ignored_next_char = "[%w%.%(%{%[]",
      }
      npairs.add_rule(Rule("|", "", "ql"))
      local cmp = require "cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    dependencies = {
      "gitworkflows/nautilus.nvim",
      "nvim-treesitter/playground",
      "nvim-treesitter/completion-treesitter",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("gitworkflows.plugins.treesitter").setup()
    end,
  },

  -- ALIGNING
  {
    "junegunn/vim-easy-align",
    keys = "<Plug>(EasyAlign)",
    --- MD tables: `EasyAlign*<Bar>`
  },
  {
    "dhruvasagar/vim-table-mode",
    setup = function()
      vim.g.table_mode_corner = '|'
    end,
    ft = { "markdown" },
    -- align markdown tables
    -- :TableModeToggle mapped to <Leader>tm
  },

  -- TEXT OBJECTS/MOTIONS/OPERATORS
  {
    'echasnovski/mini.indentscope',
    version = '*',
    config = function()
      require("mini.indentscope").setup {
        draw = {
          -- Delay (in ms) between event and start of drawing scope indicator
          delay = 200,
          -- Animation rule for scope's first drawing. A function which, given next
          -- and total step numbers, returns wait time (in ms). See
          -- |MiniIndentscope.gen_animation()| for builtin options. To not use
          -- animation, supply `require('mini.indentscope').gen_animation('none')`.
          --animation = MiniIndentscope.gen_animation.none()
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Textobjects
          object_scope = "ii",
          object_scope_with_border = "ai",
          -- Motions (jump to respective border line; if not present - body line)
          goto_top = "[i",
          goto_bottom = "]i",
        },

        -- Options which control computation of scope. Buffer local values can be
        -- supplied in buffer variable `vim.b.miniindentscope_options`.
        options = {
          -- Type of scope's border: which line(s) with smaller indent to
          -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
          border = "both",
          -- Whether to use cursor column when computing reference indent. Useful to
          -- see incremental scopes with horizontal cursor movements.
          indent_at_cursor = true,
          -- Whether to first check input line to be a border of adjacent scope.
          -- Use it if you want to place cursor on function header to get scope of
          -- its body.
          try_as_border = false,
        },

        -- Which character to use for drawing scope indicator
        symbol = "╎",
      }
    end,
  },
  {
    'echasnovski/mini.cursorword',
    version = '*',
    config = function()
      require("mini.cursorword").setup {
        delay = 100,
      }
    end,
  },
  {
    'echasnovski/mini.surround',
    version = '*',
    config = function()
      require("mini.surround").setup {
        -- Number of lines within which surrounding is searched
        n_lines = 20,

        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 500,

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          add = "sa",            -- sa{motion/textobject}{delimiter}
          delete = "sd",         -- sd{delimiter}
          find = "sf",           -- Find surrounding (to the right)
          find_left = "sF",      -- Find surrounding (to the left)
          highlight = "sh",      -- Highlight surrounding
          replace = "sr",        --- sr{old}{new}
          update_n_lines = "sn", -- Update `n_lines`
        },
      }
    end,
  },
  {
    "chaoren/vim-wordmotion",
    config = function()
      vim.g.wordmotion_prefix = "_"
    end,
  },

  -- FOLDS
  {
    'kevinhwang91/nvim-ufo',
    enabled = true,
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      require("gitworkflows.plugins.ufo").setup()
    end
  },

  -- UI
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        action_keys = {
          jump_close = {},
          jump = { "<cr>", "<tab>", "o" },
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("gitworkflows.plugins.noice").setup()
    end
  },
  { "p00f/nvim-ts-rainbow" },
  -- {
  --   "folke/which-key.nvim",
  --   config = function()
  --     require("gitworkflows.plugins.which-key").setup()
  --   end
  -- },

  -- WINBAR
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup {
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
      }
    end
  },
  {
    "gitworkflows/nvim-gps",
    branch = "patch-1",
    config = function()
      require("nvim-gps").setup {
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        text_hl = "SpecialKey",
        icon_hl = "Tag"
      }
    end
  },

  -- WINDOWS
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").ignored_buftypes = g.special_buffers
      require("smart-splits").ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
      }
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup({
        hint = 'statusline-winbar',
        show_prompt = true,
        prompt_message = 'Pick window: ',
        selection_chars = 'FJDKSLA;CMRUEIWOQP',
        filter_rules = {
          autoselect_one = true,
          include_current = false,
          bo = {
            filetype = g.special_buffers,
            buftype = { 'terminal', 'quickfix' },
          },
          wo = {},
          file_path_contains = {},
          file_name_contains = {},
        },
        highlights = {
          statusline = {
            focused = {
              fg = '#ededed',
              bg = '#e35e4f',
              bold = true,
            },
            unfocused = {
              fg = '#ededed',
              bg = '#44cc41',
              bold = true,
            },
          },
          winbar = {
            focused = {
              fg = '#ededed',
              bg = '#e35e4f',
              bold = true,
            },
            unfocused = {
              fg = '#ededed',
              bg = '#44cc41',
              bold = true,
            },
          },
        }
      })
    end,
  },

  -- TERMINAL
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = "<Plug>(ToggleTerm)",
        shade_filetypes = { 'none' },
        direction = 'horizontal',
        insert_mappings = false,
        start_in_insert = true,
        float_opts = { border = 'rounded', winblend = 3 },
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return math.floor(vim.o.columns * 0.4)
          end
        end,
        highlights = {
          Normal = {
            link = 'NormalAlt'
          },
        },
      })
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        hidden = true,
        direction = 'float',
      })
      vim.keymap.set('n', '<Plug>(LazyGit)', function() lazygit:toggle() end)
    end
  },


  -- STATUSLINE & TABLINE
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
    config = function()
      require("gitworkflows.plugins.lualine_vscode").setup()
    end,
  },

  -- FILE EXPLORER
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
      "mrbjarksen/neo-tree-diagnostics.nvim",
    },
    config = function()
      require("gitworkflows.plugins.neo-tree").setup()
    end,
  },

  -- COMMENTS
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- ROOTER
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "lsp", "pattern" },
        manual_mode = false,
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
        ignore_lsp = { "codeqlls" },
        silent_chdir = true,
        datapath = vim.fn.stdpath "data",
      }
    end,
  },

  -- STATIC ANALYSIS
  {
    "gitworkflows/codeql.nvim",
    dev = true,
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("gitworkflows.plugins.codeql").setup()
    end
  },
  {
    'gitworkflows/fortify.nvim',
    dev = true,
    enabled = false,
    config = function()
      require 'gitworkflows.plugins.fortify'.setup()
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "cmp-nvim-lsp",
      "none-ls.nvim",
      "williamboman/mason.nvim",
      "gitworkflows/codeql.nvim",
    },
    config = function()
      require("gitworkflows.lsp").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig"
    },
    config = function()
      local servers = require("gitworkflows.lsp").servers
      require("mason").setup()
      require("mason-lspconfig").setup({ ensure_installed = servers })
    end
  },
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    -- CodeActionMenu
  },
  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({
        ignore = {},
        autocmd = { enabled = true },
      })
    end
  },
  {
    "folke/lsp-colors.nvim",
    config = function()
      require("lsp-colors").setup({
        Error = "#d38391",
        Warning = "#ffae57",
        Information = "#9bbdcb",
        Hint = "#98c379"
      })
    end
  },
  { "ii14/lsp-command" },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("gitworkflows.plugins.none-ls").setup({
        --debug = true,
      })
    end
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {
        width = 120,              -- Width of the floating window
        height = 15,              -- Height of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false,            -- Print debug information
        opacity = nil,            -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil,     -- A function taking two arguments, a buffer and a window to be ran as a hook.
      }
    end,
  },
  {
    "filipdutescu/renamer.nvim",
    branch = "master",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("renamer").setup {}
    end,
  },
  { "lukas-reineke/lsp-format.nvim" },
  {
    "mickael-menu/zk-nvim",
    enabled = false,
    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end
    -- :ZkNew { dir = "daily", date = "yesterday" },
    -- require("zk.commands").get("ZkNew")({ dir = "daily" })
    -- :ZkNotes { createdAfter = "3 days ago", tags = { "work" } },
    -- require("zk.commands").get("ZkNotes")({ createdAfter = "3 days ago", tags = { "work" } })
    -- :ZkBacklinks [{}] Opens a notes picker for the backlinks of the current buffer
    -- :ZkLinks [{options}] Opens a notes picker for the outbound links of the current buffer
    -- :'<,'>ZkNewFromTitleSelection [{options}] Creates a new note and uses the last visual selection as the title
    -- :'<,'>ZkNewFromContentSelection [{options}] Creates a new note and uses the last visual selection as the content
    -- :'<,'>ZkMatch Opens a notes picker, filters for notes that match the text in the last visual selection
  },

  -- MARKDOWN
  {
    "epwalsh/obsidian.nvim",
    -- lazy = true,
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/obsidian/**.md" },
    -- cmd = {
    --   "ObsidianNew",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      dir = "~/obsidian",
      notes_subdir = "inbox",
      daily_notes = {
        folder = "resources/journals",
        date_format = "%Y_%m_%d"
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "notes_subdir",

        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = true
      },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
    },
  },
  {
    "ekickx/clipboard-image.nvim",
    config = function()
      require("clipboard-image").setup {
        markdown = {
          img_dir = "resources/attachments",
          img_dir_txt = "resources/attachments",
          affix = "![image](/%s)",
        },
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    build = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- SCROLLBAR
  {
    "petertriho/nvim-scrollbar",
    config = function()
      --local c = require("nautilus.theme").colors
      require("scrollbar").setup {
        excluded_filetypes = g.special_buffers,
        handle = {
          text = " ",
          color = "#354360",
          --color = c.cobalt,
          hide_if_all_visible = true, -- Hides handle if all lines are visible
        },
        marks = {
          Search = { text = { "-", "=" }, priority = 0, color = "orange" },
          Error = { text = { "-", "=" }, priority = 1, color = "red" },
          Warn = { text = { "-", "=" }, priority = 2, color = "yellow" },
          Info = { text = { "-", "=" }, priority = 3, color = "blue" },
          Hint = { text = { "-", "=" }, priority = 4, color = "green" },
          Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
        },
      }
      vim.cmd [[
          augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
          augroup END
        ]]
    end,
  },

  -- HTTP CLIENT
  {
    "diepm/vim-rest-console"
    -- set ft=rest
  },
  {
    "NTBBloodbath/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      }
      vim.cmd [[autocmd FileType http nmap <C-j> <Plug>RestNvim]]
    end,
  },

  -- { "alexghergh/nvim-tmux-navigation" },
  { "nathom/tmux.nvim" },

  -- DOCKER
  {
    "gitworkflows/crane.nvim",
    dev = true,
    enabled = false,
    config = function()
      require("crane").setup()
    end,
  },

  -- GIT
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitlinker").setup({
        mappings = nil
      })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitworkflows.plugins.gitsigns").setup()
    end,
  },
  {
    "gitworkflows/octo.nvim",
    dev = true,
    config = function()
      require("octo").setup {
        picker = "telescope",
        --picker = "fzf-lua",
        use_local_fs = true,
        reaction_viewer_hint_icon = "",
        enable_builtin = true,
        ui = {
          use_sign_column = false
        }
      }
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "gitworkflows/octo-notifications.nvim",
    dev = true,
    enabled = false,
    dependencies = "gitworkflows/octo.nvim",
  },
  { "sindrets/diffview.nvim" },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require('git-conflict').setup({
        disable_diagnostics = true,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function()
          vim.notify("Conflicts detected! Enabling git conflict mappings...")
          g.map(require("gitworkflows.mappings").gitconflict, { silent = false }, 0)
        end
      })
    end
  },

  -- 1PASSWORD
  {
    'mrjones2014/op.nvim',
    build = "make install",
  },

  -- AI
  {
    "jackMort/ChatGPT.nvim",
    --event = "VeryLazy",
    cmd = {
      "ChatGPT",
    },
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "op read op://Personal/OpenAI/notes --no-newline"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<leader>as", desc = "summarize text" },
      { "<leader>ag", desc = "generate git message" },
    },
    config = function()
      require("neoai").setup({
        models = {
          {
            name = "openai",
            model = "gpt-4",
            params = nil,
          },
        },
        open_ai = {
          api_key = {
            get = function()
              return require('op.api').item.get({ 'OpenAI', '--fields', 'text' })[1]
            end,
          }
        },
        shortcuts = {
          {
            name = "textify",
            key = "<leader>as",
            desc = "fix text with AI",
            use_context = true,
            prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
            modes = { "v" },
            strip_function = nil,
          },
          {
            name = "gitcommit",
            key = "<leader>ag",
            desc = "generate git commit message",
            use_context = false,
            prompt = function()
              return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
            end,
            modes = { "n" },
            strip_function = nil,
          },
        },
      })
    end,
  },
}
local opts = {
  dev = {
    path = "~/src/github.com/gitworkflows",
    patterns = { "gitworkflows" }
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    --colorscheme = { "nautilus" },
    colorscheme = { "nautilus" },
  },
}
require("lazy").setup(plugin_specs, opts)
