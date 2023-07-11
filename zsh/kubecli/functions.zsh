function delete-crd() {
	local crd_list
	crd_list=$(k get crd | cut -d " " -f 1 | tail -n +2 )
	local selected
	selected=$(echo "$crd_list" | fzf -m)
	
	echo $selected
	# k delete crd $SELECTED -o yaml
}
