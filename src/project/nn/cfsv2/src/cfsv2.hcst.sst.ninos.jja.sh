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
datain=/cpc/consistency/nn/cfsv2_ww
dataout=/cpc/home/wd52pp/data/nn/cfsv2
#
clim=2c
nyear=38
nlead=7
nt=266
#for icmon in nov dec jan feb mar apr may; do
for icmon in nov; do
icmonyr=jan1983

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
'open $datain/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.ctl'
'set x  1 144'
'set y  1 73'
'set gxout fwrite'
'set fwrite $dataout/CFSv2.sst.${icmon}_ic.1982-2020.jja.$clim.gr'
*
'set z $ld'
yt=1
while(yt<=$nyear)
'set t 'yt''
'd f'
yt=yt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <sst_anom
#
cat>$dataout/CFSv2.sst.${icmon}_ic.1982-2020.jja.$clim.ctl<<EOF2
dset ^CFSv2.sst.${icmon}_ic.1982-2020.jja.$clim.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR -90  2.5
zdef 1 linear 1 1
tdef $nyear linear $icmonyr 1yr
vars 1
f  1 99 sst fcst
endvars
#
EOF2
#
#
# have model indices
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
'open $datain/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.ctl'
'set x 73'
'set y 37'
'set gxout fwrite'
'set fwrite $dataout/CFSv2.nino34.${icmon}_ic.1982-2020.jja.$clim.gr'
*
'set z $ld'
yt=1
while(yt<=$nyear)
'set t 'yt''

'd aave(f,lon=190,lon=240,lat=-5,lat=5)'

yt=yt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <nino
#
cat>$dataout/CFSv2.nino34.${icmon}_ic.1982-2020.jja.$clim.ctl<<EOF
dset ^CFSv2.nino34.${icmon}_ic.1982-2020.jja.$clim.gr
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
EOF
done  # icmon loop
