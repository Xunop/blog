-e --- date: 2023-06-10 title: ---

git checkout main
git diff HEAD^ HEAD --name-only
files=$(git diff HEAD^ HEAD --name-only)

<!-- more -->
echo "files: $files"

for file in $files
do
  ../my_scripts/format.sh -f "$file"
done
