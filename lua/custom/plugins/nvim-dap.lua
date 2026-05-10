return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local dap_virtual_text = require 'nvim-dap-virtual-text'

      dapui.setup()
      dap_virtual_text.setup {
        enabled_commands = true,
      }

      vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end

      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/codelldb',
        name = 'lldb',
      }
      dap.adapters.python = {
        type = 'executable',
        command = '/usr/bin/python',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations = {
        rust = {
          {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            args = function()
              local input = vim.fn.input 'Enter arguments: '
              return vim.split(input, ' ')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            initCommands = function()
              -- Find out where to look for the pretty printer Python module
              local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')

              local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
              local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

              local commands = {}
              local file = io.open(commands_file, 'r')
              if file then
                for line in file:lines() do
                  table.insert(commands, line)
                end
                file:close()
              end
              table.insert(commands, 1, script_import)

              return commands
            end,
          },
        },
        python = {
          {
            -- The first three options are required by nvim-dap
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',
            name = 'Run KPI wrapper locally',

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = '${workspaceFolder}/app/wrapper.py', -- This configuration will launch the current file if used.
            justMyCode = false,
            --args = { '--local_path', 'app/scratchspace', '--config_list=app/test_config.json', '--start_date', '2025-09-01', '--end_date', '2025-09-02' },
            --args = { '--local_path', 'app/scratchspace', '--config_list=app/test_config.json' },
            args = { '--debug_mode=True', '--config_list=app/oetker.json' },
            -- args = { '--debug_mode=True' },
            console = 'integratedTerminal',
            cwd = '${workspaceFolder}',
            pythonPath = function()
              local venv = os.getenv 'VIRTUAL_ENV'
              if venv then
                return venv .. '/bin/python'
              else
                return '/usr/bin/python'
              end
            end,
          },
        },
      }
    end,
    keys = {
      { '<leader>b', '', desc = '+Debugger' },
      {
        '<leader>bt',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<leader>bc',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<leader>bi',
        function()
          require('dap').step_into()
        end,
        desc = 'Step Into',
      },
      {
        '<leader>bo',
        function()
          require('dap').step_over()
        end,
        desc = 'Step Over',
      },
      {
        '<leader>bu',
        function()
          require('dap').step_out()
        end,
        desc = 'Step Out',
      },
      {
        '<leader>br',
        function()
          require('dap').repl.open()
        end,
        desc = 'Open REPL',
      },
      {
        '<leader>bl',
        function()
          require('dap').run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<leader>bq',
        function()
          require('dap').terminate()
          require('dapui').close()
          pcall(require('nvim-dap-virtual-text').toggle)
        end,
        desc = 'Terminate',
      },
      {
        '<leader>bb',
        function()
          require('dap').list_breakpoints()
        end,
        desc = 'List Breakpoints',
      },
      {
        '<leader>be',
        function()
          require('dap').set_exception_breakpoints { 'all' }
        end,
        desc = 'Set Exception Breakpoints',
      },
      {
        '<leader>bd',
        function()
          require('dapui').eval(nil, { enter = true })
        end,
        desc = 'Describe variable under cursor',
      },
    },
  },
}
