#!/bin/bash
# Cherrytree compatibility check with Debian/Ubuntu + derivatives

[[ -f /usr/bin/apt ]] || (printf 'Sorry, you are at the wrong place\nMaybe next time\nBye\n' ;exit)
# no need to run as root + not recommended
[[ $USER = root ]] && printf '\x1b[35mNo need to run this script as root. You can, but not recommended\nBut ok...\x1b[0m\n'

  if [[ -f /etc/lsb-release ]]   ; then D=$(awk -F= '/DESC/ {print $2}' /etc/lsb-release)
elif [[ -f /etc/debian_version ]]; then D=$(cat /etc/debian_version)
else D=$(apt-cache policy apt |grep -o '[^ ]*main' |cut -d '/' -f1)
  fi

[[ -z $D ]] && D='???'

printf "\n\x1b[32m● Distribution identification:\x1b[0m $D ~ $(env |awk -F= '/CURRENT_D/ {print $2}')\n"
printf '\n\x1b[32m● Debian / Ubuntu repositories:\x1b[0m\n\n'

grep -Phrs '^d.*(debian|ubuntu|giuspen)' /etc/apt/{,sources.list.d/}*.list |grep -v 'security\|updates'

printf '\n\x1b[32m● Cherrytree dependencies:\x1b[0m\n\n'

dpkg -l |awk '$2~/cherryt|lib(c6|glib2.0-0|gcc-s1|stdc|fmt|spd|atkm|curl4|gspell-1-.:|gtksourceviewmm|sqlite3|rsvg2-c|uchardet0|xml\+)/&&/^i/&&!/-dev/{sub(":a[^ ]*","");printf"%-27s %s\n",$2,$3}'
dpkg -l cherrytree |grep -q '^i' || (printf '\nlibfmt compatibility check -> '; apt-cache policy libfmt{7,8} |sed -n '1{s/://;p}')

exit
