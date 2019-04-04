source ~/.bash_aliases
output=$(newman run $1 -e $2 --reporter-cli-no-failures --reporter-cli-no-banner --reporter-cli-no-console)	

exitCode=$?

state=$(head -n 1 $4)

host="Host : *$HOSTNAME*"

webhook=$3

if [ $exitCode -gt 0 ] ;
then
	if [ $state == "OK" ] ; 
	then
		state_string="State : *FAILED*"
		output=$(echo "$output" | sed "s/\"/ /g" | sed "s/\`/ /g" | sed "s/\'/ /g")
		final_output="$host '\n' $state_string '\n' \`\`\`"$output"\`\`\`"
		curl -X POST --data "{\"text\": \"$final_output\"}" $webhook
		echo 'FAILED' > $4
	fi
elif [ $state == "FAILED" ]
then
        state_string="State : *OK*"
	output=$(echo "$output" | sed "s/\"/ /g" | sed "s/\`/ /g" | sed "s/\'/ /g" | head -1)
        final_output="$host '\n' $state_string '\n' \`\`\`"$output"\`\`\`"
        curl -X POST --data "{\"text\": \"$final_output\"}" $webhook
	echo 'OK' > $4

fi
