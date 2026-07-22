vim.loader.enable()
require("vim._core.ui2").enable()

-- PackChanged hooks (must precede any vim.pack.add; plugin/ files source after init.lua)
vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == "nvim-treesitter" and kind == "update" then
    if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
    vim.cmd("TSUpdate")
  end
end })

require("options")
require("commands")
require("keymaps")
vim.cmd.colorscheme("default")
