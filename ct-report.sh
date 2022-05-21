#!/bin/bash

[[ -f /usr/bin/apt ]] || (printf 'Sorry, you are at the wrong place\nMaybe next time\nBye\n' ; exit)
# no need to run as root + not recommended
if [[ $USER = root ]] ; then 
    printf 'No need to run this script as root. You can, but not recommended\nAre you sure you want to continue ? [y/n]\n'
    read A
    [[ $A = y ]] && echo "Ok, let's go" || exit
fi

  if [[ -f /etc/lsb-release ]]   ; then D=$(awk -F= '/DESC/ {print $2}' /etc/lsb-release)
elif [[ -f /etc/debian_version ]]; then D=$(cat /etc/debian_version)
else D='unknown'
  fi

printf "\n\x1b[32m● Distribution identification:\x1b[0m $D ~ $(env |awk -F= '/CURRENT_D/ {print $2}')\n"
printf '\n\x1b[32m● Debian / Ubuntu repositories:\x1b[0m\n\n'

grep -Phrs '^d.*(debian|ubuntu|cherrytree)' /etc/apt/{,sources.list.d/}*.list

printf '\n\x1b[32m● Cherrytree dependencies:\x1b[0m\n\n'

dpkg -l |awk '$2~/cherryt|lib(c6|glib2.0-0|gcc-s1|stdc|fmt|spd|atkm|curl4|gspell-1-.:|gtksourceviewmm|sqlite3|rsvg2-c|uchardet0|xml\+)/&&/^i/&&!/-dev/{sub(":a[^ ]*","");printf"%-27s %s\n",$2,$3}'

exit
