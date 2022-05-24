#!/bin/bash
# Cherrytree compatibility check with Debian/Ubuntu + derivatives

[[ -f /usr/bin/apt ]] || (printf 'Sorry, you are at the wrong place\nMaybe next time\nBye\n' ;exit)
# no need to run as root + not recommended
[[ $USER = root ]] && printf '\x1b[35mNo need to run this script as root. You can, but not recommended\nBut ok...\x1b[0m\n'

printf "\n\x1b[32m● Distribution Id:\x1b[0m $(sed -n '/PRETTY/{s/^.*=//;s/GNU.Linux //;p}' /etc/os-release) ~ $(env |awk -F= '/CURRENT_D/ {print $2}')\n"
printf '\n\x1b[32m● Debian / Ubuntu repositories:\x1b[0m\n\n'

grep -Phrs '^d.*((debian|ubuntu).*main|giuspen)' /etc/apt/{,sources.list.d/}*.list |grep -v 'security\|updates'

if dpkg -l cherrytree |grep -q '^i' ; then dpkg -l cherrytree | sed -n '/cherry/{s/ii //;s/amd64.*/ : installed/;p}'
else printf '\ncompatibility check -> '; apt-cache policy libfmt{7,8} |sed -n '1{s/://;p}' ; echo
fi

printf "\n\x1b[32m● Cherrytree dependencies status:\x1b[0m [$(date +%Y-%m-%d)]\n\n"

dpkg -l |awk '$2~/lib(c6|glib2.0-0|gcc-s1|stdc|fmt|spd|atkm|curl4|gspell-1-.:|gtksourceviewmm|sqlite3|rsvg2-c|uchardet0|xml\+)/&&/^i/&&!/-dev/{sub(":a[^ ]*","");printf"%-27s %s\n",$2,$3}'
echo
printf 'Document file size/type:\t';ls -shS --format=single-colum $(awk -F = '/doc_0/ {print $2}' ~/.config/cherrytree/config.cfg) | sed 's/\/.*ctb/sqlite/;s/\/.*ctd/xml/'
echo
grep 'backup' ~/.config/cherrytree/config.cfg
echo
exit
