#!/bin/bash

template_file='scripts/load_balancer_template.conf'
output_file='temp/load_balancer.conf'

rm $output_file &>/dev/null
cp $template_file $output_file

rows=$(terraform output -raw minitwit-swarm-leader-ip-address)
rows+=' '
rows+=$(terraform output -json minitwit-swarm-manager-ip-address | jq -r .[])
rows+=' '
rows+=$(terraform output -json minitwit-swarm-worker-ip-address | jq -r .[])

for ip in $rows; do
	sed -i "/upstream echoapp {/a server $ip:5000;" $output_file
	sed -i "/upstream echoapi {/a server $ip:5001;" $output_file
done
