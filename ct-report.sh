#!/bin/bash

printf '\n\x1b[32m● Distribution identification: \x1b[0m'

  if [[ -f /etc/lsb-release ]]   ; then awk -F= '/DESC/ {print $2}' /etc/lsb-release
elif [[ -f /etc/debian_version ]]; then cat /etc/debian_version
else echo 'unknown'
  fi

printf '\n\x1b[32m● Debian / Ubuntu repositories:\x1b[0m\n\n'

grep -Phrs '^d.*(debian|ubuntu)' /etc/apt/{,sources.list.d/}*.list

printf '\n\x1b[32m● Cherrytree dependencies:\x1b[0m\n\n'

dpkg -l |awk '/^i.*(cherryt|lib(c6|glib2.0-0|gcc-s1|stdc|fmt|spd|atkm|curl4|gspell-1-.:|gtksourceviewmm|sqlite3|rsvg2|uchardet0|xml\+))/&&!/-dev/{sub(":a[^ ]*","");printf"%-27s %s\n",$2,$3}'

exit
