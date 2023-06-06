#!/bin/sh

head_info="sadasda\n111"
echo -e "$head_info" | sed "1i \\$cat($1)"
