
## hot realod
```sh
❯ tmux-executing-command | rg watchexec
%2 watchexec -w . -- bun run index.ts --tsls --root .
```

watchexecでhot reloadを有効にしてる場合があります。
logの確認が必要な場合(修正が完了した後など)
そのtmux paneをcaptureしてログを確認してください

```sh
❯ tmux capture-pane -p -S - -t $PANE_ID | tail -n 50
