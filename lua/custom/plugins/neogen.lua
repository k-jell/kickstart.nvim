--https://www.reddit.com/r/neovim/comments/18vo94l/comment/kftyb5y/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
-- https://github.com/danymat/neogen
return {
  'danymat/neogen',
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
  opts = {
    snippet_engine = 'luasnip',
    languages = {
      python = {
        template = {
          annotation_convention = 'reST',
        },
      },
    },
  },
}
