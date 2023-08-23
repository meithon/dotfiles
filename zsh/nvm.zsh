
# 仮の nvm コマンド
nvm() {
    # まず仮の nvm コマンドを unset
    unset -f nvm

    # nvm.sh をロード
    # ここで本物の nvm コマンドが定義される
    source "${NVM_DIR:-$HOME/.nvm}/nvm.sh"

    # 仮の nvm コマンドに渡された引数を本物に受け渡す
    nvm "$@"
}

# あらかじめ `nvm default vX.Y.Z` してエイリアス "default" を作っておく

PATH=${NVM_DIR:-$HOME/.nvm}/default/bin:$PATH
MANPATH=${NVM_DIR:-$HOME/.nvm}/default/share/man:$MANPATH
export NODE_PATH=${NVM_DIR:-$HOME/.nvm}/default/lib/node_modules

# （以下 Zsh のみ）
# $NODE_PATH にバージョン番号が含まれていないと `yo doctor` が警告を出す
# 次のように書くと $NODE_PATH のシンボリックリンクが展開され、警告が出なくなる
# (Hint: .nvm/default は .nvm/vX.Y.Z へのシンボリックリンク)
NODE_PATH=${NODE_PATH:A}
