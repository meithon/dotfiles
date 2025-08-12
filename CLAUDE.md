# Claude Assistant Notes

## Neovim/LazyVim 修正方法

### プラグインのソースコード場所
- **LazyVimのソースコード**: `~/.local/share/nvim/lazy/LazyVim/`
- **インストール済みプラグイン**: `~/.local/share/nvim/lazy/[プラグイン名]/`
- **設定ファイル**: `~/dotfiles/config/nvim/lua/`

### 設定ファイル構造
```
~/dotfiles/config/nvim/lua/
├── config/
│   └── options.lua        # Neovim基本設定
├── plugins/
│   ├── added.lua         # 追加プラグイン
│   └── extend.lua        # LazyVim拡張設定
```

### 問題の調査方法

#### 1. LazyVimのデフォルト設定を確認
```bash
# LazyVimのLSP設定を確認
cat ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua

# プラグインの設定を検索
grep -r "pattern" ~/.local/share/nvim/lazy/LazyVim/
```

#### 2. 現在の設定を確認
```bash
# 自分の設定ファイルを検索
grep -r "pattern" ~/dotfiles/config/nvim/lua/
```

### よくある修正パターン

#### LSP関連の問題修正
- **場所**: `plugins/extend.lua`
- **方法**: 既存のnvim-lspconfigエントリを探してoptsを修正

```lua
{
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- 設定をここに追加
    return opts
  end,
}
```

#### Code Actionの電球マークチラつき修正（解決済み）
```lua
-- plugins/extend.lua内のnvim-lspconfig設定
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "", 
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})
```

#### 基本オプション設定
- **場所**: `config/options.lua`
- **例**: `vim.opt.updatetime = 1000`

### トラブルシューティング手順

1. **問題の特定**
   - LazyVimのソースコードで該当機能を検索
   - 現在の設定ファイルで関連設定を確認

2. **設定の修正**
   - `plugins/extend.lua`で既存プラグインを拡張
   - `config/options.lua`で基本設定を変更

3. **動作確認**
   - Neovim再起動
   - 設定が反映されているか確認

### 注意事項
- LazyVimのデフォルト設定を直接編集しない
- 自分の設定ファイル（`~/dotfiles/config/nvim/lua/`）で上書きする
- 設定変更後は必ずNeovim再起動