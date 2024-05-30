#chmod u+x filename.sh

# Default
echo "Type the branch name"
read BRANCH
echo "Type the commit message"
read MESSAGE

echo "You are deleting the history of $BRANCH and creating a new one with the following message: $MESSAGE"
read -p "Are you sure? " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY = [Yy] ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

git checkout --orphan newBranch
git add -A  # Add all files and commit them
#git reset "git-renew.sh"
git commit -m "$MESSAGE"
git branch -D "$BRANCH"  # Deletes the branch
git branch -m "$BRANCH"  # Rename the current branch

echo "Push to ...?"
OPTIONS="None Origin Other"
select opt in $OPTIONS; do
	if [ "$opt" = "None" ]; then
		break
	elif [ "$opt" = "Origin" ]; then
		git push -f origin "$BRANCH"  # Force push branch to origin
		break
	elif [ "$opt" = "Origin+Heroku" ]; then
		git push -f origin "$BRANCH"
		git push -f heroku "$BRANCH"
		break
	elif [ "$opt" = "Other" ]; then
		echo "Type the repo"
		read REPO
		git push -f "$REPO" "$BRANCH"  # Force push branch to repo
		break
	else
		echo bad option
	fi
done