return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
    keys = {
      { '<leader>ccp', '<cmd>CopilotChatPrompts<cr>', mode = { 'n', 'x' }, desc = 'CopilotChat - Select Prompt' },
      { '<leader>ccm', '<cmd>CopilotChatModels<cr>', desc = 'CopilotChat - Select Model' },
      { '<leader>cct', '<cmd>CopilotChatToggle<cr>', mode = { 'n', 'x' }, desc = 'CopilotChat - Toggle Window' },
      { '<leader>ccr', '<cmd>CopilotChatReset<cr>', desc = 'CopilotChat - Reset Chat' },
      { '<leader>ccs', '<cmd>CopilotChatStop<cr>', desc = 'CopilotChat - Stop Chat' },
    },
  },
}
