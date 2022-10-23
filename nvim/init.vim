let splt  = split(glob("~/dotfiles/nvim/settings/" . "*.vim"))
let splt += split(glob("~/dotfiles/nvim/settings/" . "*.lua"))
let splt += split(glob("~/dotfiles/nvim/settings/plugin/" . "*.vim"))
let splt += split(glob("~/dotfiles/nvim/settings/plugin/" . "*.lua"))

let splt += split(glob("~/dotfiles/nvim/settings/lsp/" . "*.vim"))
let splt += split(glob("~/dotfiles/nvim/settings/lsp/" . "*.lua"))

for file in splt
    execute 'source' file
endfor

