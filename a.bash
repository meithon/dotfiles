IFS=',' read -r -a list <<<'a,s,d,f'

for element in ${list[@]}; do
  echo $element_name
done
