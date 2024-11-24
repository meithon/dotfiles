[34mcat[0m [38;5;

m-A[0m json
[34mvi[0m [38;5;

m-b[0m json
[34m_histdb_query[0m [38;5;

m-json[0m "[32m[0m
select commands.argv from history[32m[0m
left join commands on history.command_id = commands.rowid[32m[0m
left join places on history.place_id = places.rowid[32m[0m
where places.dir = '[3
m$([0m[34msql_escape[0m [3
m$[0m[3
mPWD[0m[3
m)[0m'[32m[0m
group by commands.argv[32m[0m
order by count(*) desc" [35m|[0m [34mjq[0m [38;5;

m-j[0m [32m'.[].argv | gsub("\n$";"") + "\u0000"'[0m [35m|[0m [34mperl[0m [38;5;

m-pe[0m [32m's/\n/\


/g'[0m [35m|[0m [34mtr[0m [32m'\0'[0m [32m'\n'[0m [35m|[0m [34msyncat[0m [38;5;

m--language[0m bash [35m|[0m [34mtr[0m [32m'\n'[0m [32m'\0'[0m [35m|[0m [34mperl[0m -pe [32m's/\


/\n/g'[0m
setopt HIST_SUBST_PATT
RN
echo "hello \n world"
bindkey -M vicmd [32m'^r'[0m search_history
bindkey [32m'^r'[0m select_history
_histdb_query -json "