_lazyload_completion() {
  local cmd_name="$1"
  local completion_path="$2"
  local completion_func="$3"

  eval "_load_${cmd_name}_completion() {
    source '$completion_path'
    compdef $completion_func $cmd_name
    unfunction _load_${cmd_name}_completion
  }"
  compdef "_load_${cmd_name}_completion" $cmd_name
}


_aws() {
	autoload bashcompinit && bashcompinit
	complete -C $(which aws_completer) aws
}

_lazyload_completion "aws" $(which aws_completer) "_aws"
