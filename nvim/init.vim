let splt  = split(glob("~/dotfiles/nvim/settings/" . "*.vim"))
let splt += split(glob("~/dotfiles/nvim/settings/plugin" . "*.vim"))

for file in splt
    " 読み込んだファイルを表示するもの消しても大丈夫
    echo "load " . file
    " ファイルの読み込み
    execute 'source' file
endfor

