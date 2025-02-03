return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x', -- Ensure you're using the latest stable v3.x branch
    dependencies = {
      'nvim-lua/plenary.nvim', -- Utility library required by NeoTree
      'nvim-tree/nvim-web-devicons', -- Icon support
      'MunifTanjim/nui.nvim', -- UI component library required by NeoTree
    },
    cmd = 'Neotree',
    keys = {
      {
        '<D-b>',
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
        end,
        desc = 'Toogle NeoTree',
      },
      {
        '<leader>e', -- Focus on NeoTree without closing it
        function()
          -- Check if NeoTree is open by looking for its window
          local neotree_win = vim.fn.bufname() == 'neo-tree'
          if not neotree_win then
            -- If NeoTree isn't open, open it and don't toggle its visibility
            require('neo-tree.command').execute { dir = vim.fn.getcwd() }
          else
            -- Focus on NeoTree if it's already open
            vim.cmd 'Neotree focus'
          end
        end,
        desc = 'Focus on NeoTree',
      },
      {
        '<leader>o',
        function()
          vim.cmd 'wincmd p' -- Focus the previous window (i.e., the editor if NeoTree is open)
        end,
        desc = 'Focus to Editor',
      },
    },
    init = function()
      -- Lazy-load NeoTree only when needed based on the buffer
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('Neotree_start_directory', { clear = true }),
        desc = 'Start Neo-tree with directory',
        once = true,
        callback = function()
          if package.loaded['neo-tree'] then
            return true
          else
            -- Ensure we are getting the first argument safely and it is a string
            local arg_path = vim.fn.argv(0)

            -- Ensure arg_path is a string (it could be a table if multiple arguments are passed)
            if type(arg_path) == 'table' then
              arg_path = arg_path[1] -- Take the first element if it's a table
            end

            -- Ensure the argument is not empty and is a valid path
            if arg_path and arg_path ~= '' then
              local stats = vim.uv.fs_stat(arg_path) -- Now checking the path safely

              -- Check if the path is a directory
              if stats and stats.type == 'directory' then
                require 'neo-tree'
              end
            end
          end
        end,
      })
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      source_selector = {
        winbar = false,
        statusline = true,
      },
      window = {
        mappings = {
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<space>'] = 'none',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['O'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              -- vim.fn.jobstart { 'xdg-open', path } -- Linux-specific (use system's default file opener)
              -- For macOS, use "open":
              vim.fn.jobstart { 'open', path }
              -- For Windows, use "start":
              -- vim.fn.jobstart({ "start", path }, { shell = true })
            end,
            desc = 'Open with System Application',
          },
          ['P'] = { 'toggle_preview', config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- Enables expanders for file nesting
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
          symbols = {
            unstaged = '󰄱',
            staged = '󰱒',
          },
        },
      },
    },
    config = function(_, opts)
      -- local function on_move(data)
      --   -- Custom file move/rename handling (you can replace this with your own logic)
      --   -- For example, you could log it or just perform other actions
      --   vim.cmd(string.format('rename %s %s', data.source, data.destination)) -- You can use this for renaming
      -- end

      -- local events = require 'neo-tree.events'
      opts.event_handlers = opts.event_handlers or {}
      -- vim.list_extend(opts.event_handlers, {
      --   { event = events.FILE_MOVED, handler = on_move },
      --   { event = events.FILE_RENAMED, handler = on_move },
      -- })

      require('neo-tree').setup(opts)

      -- Automatically refresh git status after `lazygit` terminal closes
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },
}
