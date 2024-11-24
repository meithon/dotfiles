get_word_start_and_end() {
    local buffer=$1
    local column=$2
    local positions=()
    local ends=()
    local current_pos=0
    
    # Collect word positions
    while [[ $current_pos -lt ${#buffer} ]]; do
        # Skip spaces
        while [[ "${buffer:$current_pos:1}" == " " && $current_pos -lt ${#buffer} ]]; do
            ((current_pos++))
        done
        
        if [[ $current_pos -lt ${#buffer} ]]; then
            positions+=($current_pos)
            
            local word_end=$current_pos
            while [[ "${buffer:$word_end:1}" != " " && $word_end -lt ${#buffer} ]]; do
                ((word_end++))
            done
            ends+=($((word_end - 1)))
        fi
        
        current_pos=$((word_end + 1))
    done
    
    # Return positions for the requested column (adjusting for 1-based indexing)
    if [[ $column -le ${#positions[@]} ]]; then
        echo "${positions[$column]} ${ends[$column]}"
    else
        echo "-1 -1"
    fi
}

function zvm_select_sub_command() {
    local poss=($(get_word_start_and_end "$BUFFER" 2))
    
    if [[ ${#poss[@]} -eq 2 && $poss[1] != -1 ]]; then
        local start=$poss[1]
        local end=$poss[2]
        
        CURSOR=$start
        zvm_enter_visual_mode v
        CURSOR=$end
    fi
}

zle -N zvm_select_sub_command
bindkey -M vicmd 's' zvm_select_sub_command


