
source /Users/mei/.docker/init-fish.sh || true # Added by Docker Desktop

# plugin conifg
cod init $fish_pid fish | source

# fifc config
set fifc_fd_opts --max-depth=1

# use can use fish_key_reader to get the key code
# $ fish_key_reader
# <C-g>
bind -M insert \a _find_directory

function _find_directory
    cd $(zoxide query --interactive)
    fish_prompt # force relaod prompt
end

abbr -a vi nvim

## brew setup
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

thefuck --alias | source
