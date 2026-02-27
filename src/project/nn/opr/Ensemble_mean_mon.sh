#!/bin/sh
set -xe

# compute Ensemble mean of CFSv2 hindcasts
#
var=SSH
#
#postdir=/cpc/cfsr_ipvcdb/ipv/CFSv2/CFSv2HCSTmonpost/${var}em
postdir=/cpc/consistency/nn/CFSv2${var}em
if [ ! -d $postdir ] ; then
 mkdir -p $postdir
fi
grads=/usr/local/bin/grads

yyyyb=1999
yyyye=2020
yyyy=$yyyyb
cd $postdir
until [ $yyyy -gt $yyyye ] ; do
cat <<gsEOF> sstem.gs
'open /cpc/cfsr_ipvcdb/ipv/CFSv2/CFSv2HCSTmonpost/$var/CFSv2$var.ctl'
'set gxout fwrite'
'set fwrite CFSv2${var}em$yyyy.gr'
'set x 1 360'
'set y 1 181'

yyyy=$yyyy
mm=1
'set e 4'
while(mm<=12)
 smon=mmconv(mm)
 time=smon''yyyy
 'set time 'time
 ee=8
 if(yyyy=1982&mm=1); ee=7;endif
 z=1
 while(z<=9)
  'set z 'z
  say 'time='time'  z='z
  'define esm=ave((f00+f06+f12+f18)/4,e=4,e='ee')'
  'define esmmsk=esm+f00-f00'
  'd const(esmmsk,-9999.00,-u)'
  z=z+1
 endwhile
 mm=mm+1
endwhile

function mmconv(mm)
  if(mm=1); cmo='Jan'; endif
  if(mm=2); cmo='Feb'; endif
  if(mm=3); cmo='Mar'; endif
  if(mm=4); cmo='Apr'; endif
  if(mm=5); cmo='May'; endif
  if(mm=6); cmo='Jun'; endif
  if(mm=7); cmo='Jul'; endif
  if(mm=8); cmo='Aug'; endif
  if(mm=9); cmo='Sep'; endif
  if(mm=01); cmo='Jan'; endif
  if(mm=02); cmo='Feb'; endif
  if(mm=03); cmo='Mar'; endif
  if(mm=04); cmo='Apr'; endif
  if(mm=05); cmo='May'; endif
  if(mm=06); cmo='Jun'; endif
  if(mm=07); cmo='Jul'; endif
  if(mm=08); cmo='Aug'; endif
  if(mm=09); cmo='Sep'; endif
  if(mm=10); cmo='Oct'; endif
  if(mm=11); cmo='Nov'; endif
  if(mm=12); cmo='Dec'; endif
return (cmo)
gsEOF

grads -bl <<EOF
 run sstem.gs
 quit
EOF
/bin/rm sstem.gs
yyyy=`expr $yyyy + 1`
done

cat >CFSv2${var}em.ctl<< ctlEOF
dset ^CFSv2${var}em%y4.gr
undef -9999.00
options template little_endian
* /cpc/home/wd20wq/projx/CFSv2/CFSv2Hcst/Ensemble_mean_mon.sh
title CFSv2 $var
ydef 181 linear -90.000000 1
xdef 360 linear 0.000000 1.000000
* ZDEF target month: z=1 for month one; z=9 for month nine
zdef 9 linear 1 1
* TDEF: First target month
tdef 600 linear jan1982 1mo
vars 1
${var}em 9  99 CFSv2 $var
ENDVARS
ctlEOF
