return {
  {
    'axkirillov/easypick.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = function(_, opts)
      local easypick = require 'easypick'
      local list = [[
        <<EOF
        :LspInfo
        EOF
        ]]
      opts.pickers = {
        -- list files inside current folder with default previewer
        {
          -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
          name = 'ls',
          -- the command to execute, output has to be a list of plain text entries
          command = 'ls',
          -- specify your custom previwer, or use one of the easypick.previewers
          previewer = easypick.previewers.default(),
        },
        {
          name = 'comand_palette',
          comand = 'cat ' .. list,
          action = easypick.actions.nvim_commandf '%s',
          opts = require('telescope.themes').get_dropdown {},
        },
      }
    end,
  },
}
