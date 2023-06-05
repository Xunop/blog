#!/bin/sh

date=$(date +%Y-%m-%d)
echo $date
date=$(sed -n '1,20{/^date:/{p;q}}' test.md | awk '{ print $2}')

if [ -z "$date" ]; then
  date=$(date +%Y-%m-%d)
fi
echo $date

