require("vim._core.ui2").enable()

require("options")
require("commands")
require("plugins").setup()
require("keymaps")

vim.cmd.colorscheme("default")
