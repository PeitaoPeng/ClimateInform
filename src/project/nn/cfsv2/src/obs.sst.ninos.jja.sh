#!/bin/sh
#####################################################
# calculated DJF Nino34 from NMME ensemble forecast
#####################################################
set -eaux

lcdir=/cpc/home/wd52pp/project/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain=/cpc/consistency/nn/obs
dataout=/cpc/consistency/nn/obs
#
nyear=38
nlead=7
nt=266
#for icmon in nov dec jan feb mar apr may; do
for icmon in nov; do
icmonyr=jul1983

if [ $icmon = 'nov' ]; then ld=7; fi
if [ $icmon = 'dec' ]; then ld=6; fi
if [ $icmon = 'jan' ]; then ld=5; fi
if [ $icmon = 'feb' ]; then ld=4; fi
if [ $icmon = 'mar' ]; then ld=3; fi
if [ $icmon = 'apr' ]; then ld=2; fi
if [ $icmon = 'may' ]; then ld=1; fi
#
cd $tmp
#
# have model sst
#
cat >sst_anom<<EOF
 run sst.gs
EOF
#
cat >sst.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $datain/obs.sst.ss.${icmon}_ic.1982-cur.ld1-7.anom.ctl'
'set x  1 144'
'set y  1 73'
'set gxout fwrite'
'set fwrite $dataout/oisst.1982-cur.jja.anom.gr'
*
'set z $ld'
yt=1
while(yt<=$nyear)
'set t 'yt''
'd o'
yt=yt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <sst_anom
#
cat>$dataout/oisst.1982-cur.jja.anom.ctl<<EOF2
dset ^oisst.1982-cur.jja.anom.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR -90  2.5
zdef 1 linear 1 1
tdef $nyear linear $icmonyr 1yr
vars 1
o  1 99 sst fcst
endvars
#
EOF2
#
#
# have obs nino indices
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
'open $datain/obs.sst.ss.${icmon}_ic.1982-cur.ld1-7.anom.ctl'
'set x 73'
'set y 37'
'set gxout fwrite'
'set fwrite $dataout/oisst.nino34.1982-cur.jja.gr'
*
'set z $ld'
yt=1
while(yt<=$nyear)
'set t 'yt''

'd aave(o,lon=190,lon=240,lat=-5,lat=5)'

yt=yt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <nino
#
cat>$dataout/oisst.nino34.1982-cur.jja.ctl<<EOF
dset ^oisst.nino34.1982-cur.jja.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR   0  1.0
YDEF 1 LINEAR -90  1.0
zdef 1 linear 1 1
tdef $nyear linear $icmonyr 1yr
vars 1
o  1 99 nino34
endvars
#
EOF
done  # icmon loop
