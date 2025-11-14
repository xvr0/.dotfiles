-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall pyright css-lsp html-lsp lua-language-server typescript-language-server stylua prettier"
end, {})
