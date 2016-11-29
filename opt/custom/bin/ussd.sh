#!/bin/bash
#Encode USSD number *124*#
USSDCODE="*124*#"
CODE=`perl -e '@a=split(//,unpack("b*", "'$USSDCODE'")); for ($i=7; $i < $#a; $i+=8) { $a[$i]="" } print uc(unpack("H*", pack("b*", join("", @a))))."\n"'`
TEXT=`gammu getussd $CODE | grep -i "Service reply" | tr -d "Service reply :" | tr -d '"'`
#Decode USSD
echo -e "\n############################"
perl -e '@a=split(//,unpack("b*", pack("H*","'$TEXT'"))); for ($i=6; $i < $#a; $i+=7) {$a[$i].="0" } print pack("b*", join("", @a)).""'
echo -e "\n############################"
