[master]
${names[0]} ansible_host=${addrs[0]}

[workers]
${names[1]} ansible_host=${addrs[1]}
${names[2]} ansible_host=${addrs[2]}

[gitlab]
${names[3]} ansible_host=${addrs[3]}

[prometheus]
${names[4]} ansible_host=${addrs[4]}

[rabbit]
${names[5]} ansible_host=${addrs[5]}