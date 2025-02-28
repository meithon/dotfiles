source ~/dotfiles/config/zsh/z4h/core/zshrc

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# source ~/dotfiles/config/zsh/zinit/.zshrc
#
# # bun completions
# [ -s "/Users/mei/.bun/_bun" ] && source "/Users/mei/.bun/_bun"
#
#
# awsp() {
#   local profile=$(aws configure list-profiles | fzf --preview 'aws --profile {} sts get-caller-identity' --height 40%)
#   if [ -n "$profile" ]; then
#     export AWS_PROFILE=$profile
#     echo "Switched to AWS Profile: $profile"
#     aws sts get-caller-identity
#   fi
# }
#
# alias pf=pueue-follow-fzf
# function pueue-follow-fzf() {
#   local tasks=$(pueue status --json | jq -r '.tasks[] | " \(.id)  \(.command) "')
#   local selectedLine=$(echo $tasks | fzf-tmux --preview 'echo {} | awk "{print \$1}" | xargs pueue follow')
#   local task_id=$(echo $selectedLine | awk '{print $1}')
#
#   if [ -z $task_id ]; then
#     return
#   fi
#   pueue follow $task_id
# }
#
# # function gitconfig_chpwd() {
# #   local work_dir="${HOME}/workspace/work"
# #   local current_git_config=$GIT_CONFIG
# #   local current_aws_profile=$AWS_PROFILE
# #
# #   if [[ "${PWD}" = "${work_dir}"* ]]; then
# #     if [[ "$current_git_config" != "${work_dir}/.gitconfig" ]]; then
# #       export GIT_CONFIG="${work_dir}/.gitconfig"
# #       export AWS_PROFILE="honda-aws"
# #       print "GIT_CONFIG set to ${work_dir}/.gitconfig"
# #     fi
# #   else
# #     if [[ -n "$current_git_config" ]]; then
# #       unset GIT_CONFIG
# #       unset AWS_PROFILE 
# #       print "GIT_CONFIG unset"
# #     fi
# #   fi
# # }
# # # chpwdフック配列に関数を追加
# # typeset -ga chpwd_functions
# # chpwd_functions+=(gitconfig_chpwd)
# # 起動時に一度実行
# # gitconfig_chpwd
#


PATH=~/.console-ninja/.bin:$PATH