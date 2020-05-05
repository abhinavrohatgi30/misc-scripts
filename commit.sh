tickets=$(git rev-parse --abbrev-ref HEAD | grep -o NB-[0-9]* | xargs)
commitMessage="'$*'" 
finalMessage=$tickets" "$commitMessage
git commit -m "$finalMessage"
