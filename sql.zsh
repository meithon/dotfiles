function fzf-sqlite-select() {
  local selected
  local query="
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where places.dir = '$(sql_escape $PWD)'
      group by commands.argv
      order by count(*) desc
  "
  local selected
  selected=$(
    _histdb_query -separator '\x1e' "$query" |
      bat --plain --language sql --color always |
      fzf --read0 --ansi --layout reverse \
        --preview 'echo {}' \
        --preview-window=up:3:wrap \
        --separator='\x1e' \
        --with-nth=1.. \
        --highlight-line
  )

  if [ -n "$selected" ]; then
    BUFFER="${selected}"
    CURSOR=$#BUFFER
  fi
}

zle -N fzf-sqlite-select
bindkey '^S' fzf-sqlite-select

_histdb_query " 
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where places.dir = '$(sql_escape $PWD)'
      group by commands.argv
      order by count(*) desc
  " |fzf --read0

echo hello\
  some


_histdb_query -json "
select commands.argv from history
left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir = '$(sql_escape $PWD)'
group by commands.argv
order by count(*) desc" | \
jq -j '.[].argv | gsub("\n$";"") + "\u0000"' | \
  perl -pe 's/\n/\x1E/g' | \
  tr '\0' '\n' | \
  syncat --language bash | \
  tr '\n' '\0' | \
  perl -pe 's/\x1E/\n/g' | \
  fzf --read0 \
    --ansi \
    --layout=reverse \
    --no-sort \
    --height=60% \
    --preview 'echo {}| syncat -l bash' \
    --preview-window=down:3:wrap \
    --prompt='History > ' \
    --highlight-line \
    --header='[CTRL-Y:copy, CTRL-R:execute]' \
    --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)' \
    --bind 'ctrl-r:execute(echo {} | sh)'


_histdb_query -json "
select commands.argv from history
left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir = '$(sql_escape $PWD)'
group by commands.argv
order by count(*) desc" | \
jq -j '.[].argv | gsub("\n$";"") + "\u0000"' 



cat -A json
vi -b json
_histdb_query -json "
select commands.argv from history
left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir = '$(sql_escape $PWD)'
group by commands.argv
order by count(*) desc" | jq -j '.[].argv | gsub("\n$";"") + "\u0000"' | perl -pe 's/\n/\x1E/g' | tr '\0' '\n' | syncat --language bash | tr '\n' '\0' | perl -pe 's/\x1E/\n/g';



setopt HIST_SUBST_PATTERN
echo "hello
world"

bindkey -M vicmd '^r' search_history

bindkey '^r' select_history



cat json | perl -pe 's/\x00/\n\x1E/g' | syncat --language bash | perl -0777 -pe 's/\n\x1E/\x00/g' | fzf --read0 --ansi


cat json | perl -pe 's/\x00/\n\x1E/g' | syncat --language bash | perl -0777 -pe 's/\n\x1E/\x00/g' | fzf --read0 --ansi

cat json | perl -pe 's/\x00/\n\x1E/g' | syncat --language bash > 1
cat json | perl -pe 's/\x00/;\n\x1E/g' | syncat --language bash > 2

❯ cat json | perl -pe 's/\x00/;\n\x1E/g' | perl -pe 's/\x1E$//' | syncat --language bash | perl -0777 -pe 's/;\n+/\x00/g' | fzf --read0 --ansi
$
cat json | \
  # NULバイトをセミコロン+改行+RSマーカーに変換
  perl -pe 's/\x00/;\n\x1E/g' | \
  # 最後のRSマーカーを削除（syncat用の前処理）
  perl -pe 's/\x1E$//' | \
  # パイプとその他の演算子をバックスラッシュ+改行に変換
  perl -pe 's/\s*(\||&&|\|\|)\s*/ \\\n/g' | \
  # シンタックスハイライトを適用
  syncat --language bash | \
  # セミコロン+改行をNULバイトに戻す（fzf用の後処理）
  perl -0777 -pe 's/;\n+/\x00/g' | \
  # NULバイト区切りでfzf表示（ANSIカラー対応）
  fzf --read0 --ansi

