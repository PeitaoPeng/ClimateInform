#!/bin/sh
#####################################################
# calculated DJF Nino34 from NMME ensemble forecast
#####################################################
set -eaux

lcdir=/cpc/home/wd52pp/project/nn/nmme
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain=/cpc/consistency/nn/nmme
dataout=/cpc/home/wd52pp/data/nn/nmme
#
nyear=38
nlead=7
nt=266
#for icmon in jan feb mar apr may jun jul aug sep oct nov dec; do
for icmon in may jun jul aug sep oct nov; do
icmonyr=jan1983

if [ $icmon = 'may' ]; then ld=7; fi
if [ $icmon = 'jun' ]; then ld=6; fi
if [ $icmon = 'jul' ]; then ld=5; fi
if [ $icmon = 'aug' ]; then ld=4; fi
if [ $icmon = 'sep' ]; then ld=3; fi
if [ $icmon = 'oct' ]; then ld=2; fi
if [ $icmon = 'nov' ]; then ld=1; fi
#
cd $tmp
#
# have nmme indices
#
cat >nino<<EOF
 run ninos.gs
EOF
#
cat >ninos.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $datain/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.ctl'
'set x 73'
'set y 37'
'set gxout fwrite'
'set fwrite $dataout/NMME.nino34.${icmon}_ic.1982-2019.djf.gr'
*
yt=$ld
while(yt<=$nt)
'set t 'yt''

'd aave(f,lon=190,lon=240,lat=-5,lat=5)'

yt=yt+$nlead
endwhile
EOFgs
#
/usr/local/bin/grads -bl <nino
#
cat>$dataout/NMME.nino34.${icmon}_ic.1982-2019.djf.ctl<<EOF2
dset ^NMME.nino34.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR   0  1.0
YDEF 1 LINEAR -90  1.0
zdef 1 linear 1 1
tdef $nyear linear $icmonyr 1yr
vars 1
f  1 99 nino34
endvars
#
EOF2
#
done  # icmon loop
