---
date: 2023-06-09
title: 
---

files=$(git status --short | awk '{print $2}')
echo "files: $files"


<!-- more -->
for file in $files
do
  ../my_scripts/format.sh -f "$file"
done
