return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,3
        illuminate = true,
        lazy_nvim = true,
        markdown = true,
        mason = true,
        neo_tree = true,
        neogit = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = {
          enabled = true,
          style = "nvchad", 
        },
        treesitter = true,
        which_key = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

