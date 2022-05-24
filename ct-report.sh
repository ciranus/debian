#!/bin/bash
# 20220524 - Cherrytree compatibility check with Debian/Ubuntu + derivatives
if [[ "$1" != nc ]]; then G='\x1b[32m'; M='\x1b[35m'; Y='\x1b[33m'; R='\x1b[0m'; fi

[[ -f /usr/bin/apt ]] || (printf 'Sorry, you are at the wrong place\nMaybe next time\nBye\n' ;exit)
# no need to run as root + not recommended
[[ $USER = root ]] && printf "${M}No need to run this script as root. You can, but not recommended\nBut ok...${R}\n"

printf "${G}● Distribution Id:${R} $(sed -n '/PRETTY/{s/^.*=//;s/GNU.Linux //;p}' /etc/os-release) ~ $(env |awk -F= '/CURRENT_D/ {print $2}')\n\n"
printf "${G}● Debian / Ubuntu repositories:${R}\n"

grep -Phrs '^d.*((debian|ubuntu).*main|giuspen)' /etc/apt/{,sources.list.d/}*.list |grep -v 'security\|updates'
echo '---'
if dpkg -l cherrytree |grep -q '^i' ; then dpkg -l cherrytree | sed -n '/cherry/{s/ii //;s/amd64.*/ : installed/;p}'
else printf '\ncompatibility check -> '; apt-cache policy libfmt{7,8} |sed -n '1{s/://;p}'
fi
echo '---'
printf "${G}● Cherrytree dependencies status:${R} [$(date +%Y-%m-%d)]\n\n"

dpkg -l |awk '$2~/lib(c6|glib2.0-0|gcc-s1|stdc|fmt|spd|atkm|curl4|gspell-1-.:|gtksourceviewmm|sqlite3|rsvg2-c|uchardet0|xml\+)/&&/^i/&&!/-dev/{sub(":a[^ ]*","");printf" %-27s %s\n",$2,$3}'
echo
if [[ $USER = root ]]; then printf "${M} >>> current user is root -> EXIT <<<${R}\n" ;exit ;fi
CONF="/home/$USER/.config/cherrytree/config.cfg"
printf "${Y}doc %-8s%-8s%-8s $R \n" size type images
for i in {0..6} ; do
  F=$(sed -n "/doc_${i}/{s/^.*=//;p}" $CONF)
  [[ ! -f $F ]] && break
  ST=$(ls -sh --format=single-colum $F |sed 's/\/.*ctb/sqlite/;s/\/.*ctd/xml/;s/\/.*ctx/Sql-7z/;s/\/.*ctz/xml-7z/')
  Ftype=$(echo $F |cut -d. -f2)
    if [[ "$Ftype" = ctb ]] ; then
    [[ -f /usr/bin/strings ]] && P=$(strings $F |grep  'type="image/\|src="data\|encoded_' |wc -l) || P='<binutils package needed>'
  elif [[ "$Ftype" = ctd ]] ; then P=$(grep  'type="image\|src="data\|encoded_/' $F |wc -l)
  elif [[ "$Ftype" = ct[xz] ]] ; then P='<protected>'
    fi
  printf " %-3s%-8s%-8s $P\n" $i $ST
done

printf "\n${Y}Config:${R}\n" ; grep 'autosave\|backup' $CONF
[[ -d $(awk -F= '/^custom_backup_dir/ {print $2}' $CONF) ]] || printf "$M >> backup dir does not exist << $R "
echo

exit

