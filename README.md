# nvim.config

My Neovim configuration. Uses `vim.pack`, `vim.lsp.config/enable`, builtin `undotree`.

## System dependencies

Install these outside Neovim:

- git
- ripgrep
- gcc (or clang) + make
- curl
- unzip
- a Nerd Font
- a clipboard provider: xclip, xsel, or wl-clipboard

## Layout

```
init.lua                  entry point; loads options, commands, keymaps, theme
lua/
  options.lua             vim.opt settings
  keymaps.lua             keymaps
  commands.lua            user commands (:PackAdd, :PackDel, :PackUpdate, :MasonLock, :TSLock)
  themes.lua              colorscheme (nordic)
  modules/
    mason-lock.lua        custom: mason package version lock
    treesitter-lock.lua   custom: treesitter parser set lock
plugin/
  00-mini.lua             mini.nvim + mini-pick-preview
  10-lsp.lua              mason, nvim-treesitter, nvim-lspconfig
  90-extras.lua           vim-fugitive, friendly-snippets
```

## Custom plugins

Two small local modules under `lua/modules/` act like package-manager locks (the kind `vim.pack` does not ship):

- **mason-lock** (`lua/modules/mason-lock.lua`) — snapshots installed mason package versions to `mason-lock.json` and restores them on startup. Run `:MasonLock` to write the lock manually; it also auto-snapshots on any mason install/uninstall.
- **treesitter-lock** (`lua/modules/treesitter-lock.lua`) — snapshots the *set* of installed tree-sitter parsers to `treesitter-lock.json` and installs any missing ones on startup. Run `:TSLock` to write the lock manually; it also auto-snapshots on every `:TSInstall`/`:TSUninstall`. nvim-treesitter pins parser commits internally, so this lock only tracks the set, not versions.

Both restore on startup and write the lock back whenever the set changes.

## Lock files

- `nvim-pack-lock.json` — `vim.pack` plugin pins (managed by Neovim)
- `mason-lock.json` — mason package versions (managed by mason-lock)
- `treesitter-lock.json` — installed treesitter parser set (managed by treesitter-lock)
