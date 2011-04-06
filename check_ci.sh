#!/bin/bash

cd /Users/daniellewis/Desktop/FYTM

mv rssAll rssAll.old

# log in
wget -q "http://71.42.28.83:8080/j_acegi_security_check" --post-data="j_username=ap2&j_password=yourmomisfat&remember_me=on&from=&json=%7B%22j_username%22%3A+%22ap2%22%2C+%22j_password%22%3A+%22yourmomisfat%22%2C+%22remember_me%22%3A+true%2C+%22from%22%3A+%22%22%7D&Submit=log+in" --save-cookies a.txt -O - >/dev/null

# get new file
wget "http://71.42.28.83:8080/job/ComeRockUs/rssAll" --load-cookies a.txt

diff rssAll.old rssAll && exit

output="`grep -oE "<title>[^<]*</title>" rssAll |head -n2|tail -n1`"

function announce_failure() { 
  echo 0 > build_status
  mplayer STcomp016.wav  
}
function announce_fixed() {
  echo 1 > build_status
  echo "Thank you for fixing the build." | say
}
function announce_working() {
  echo 1 > build_status
  mplayer STcomp001.wav
}
function announce_abort() {
  echo 0 > build_status
  echo "Why did you abort me? I'm just a lonely build job." | say
}

echo "$output" | grep broken && announce_failure
echo "$output" | grep "back to normal" && announce_fixed
echo "$output" | grep stable && announce_working
echo "$output" | grep aborted && announce_abort
