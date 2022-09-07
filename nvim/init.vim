let splt  = split(glob("~/dotfiles/nvim/settings/" . "*.vim"))
let splt += split(glob("~/dotfiles/nvim/settings/plugin/" . "*.vim"))
let splt += split(glob("~/dotfiles/nvim/settings/plugin/" . "*.lua"))

for file in splt
    execute 'source' file
endfor

