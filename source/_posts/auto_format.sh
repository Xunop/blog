---
date: 2023-06-09
title: 
---

git checkout main
git status --short
files=$(git status --short | awk '{print $2}')

<!-- more -->
echo "files: $files"

for file in $files
do
  ../my_scripts/format.sh -f "$file"
done
