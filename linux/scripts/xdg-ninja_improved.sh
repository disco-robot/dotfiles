#!/bin/bash
xdg-ninja | sed -e 's/\x1b\[[0-9;]*m//g' | tail +13 | head -n -4 | awk '{if($1 ~ "```*"){i=i+1};if(i%2 != 0){print $0}}' | grep -v \`\`\`bash | grep -v \`\`\`
