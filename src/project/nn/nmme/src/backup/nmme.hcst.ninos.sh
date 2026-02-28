#!/bin/sh
#####################################################
# calculated Nino indices from NMME ensemble forecast
#####################################################
set -eaux

lcdir=/cpc/home/wd52pp/project/nn/nmme
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datain=/cpc/consistency/id/nmme/hcst
dataout=/cpc/home/wd52pp/data/nn/nmme
#
nyear=38
nlead=7
#for icmon in jan feb mar apr may jun jul aug sep oct nov dec; do
for icmon in may; do
icmonyr=${icmon}1982
#
cd $tmp
#
# have SST anom
#
cat >anom<<EOF
 run sstanom.gs
EOF

cat >sstanom.gs<<EOFgs
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
'open $datain/NMME.tmpsfc.ss.may_ic.1982-2019.ld1-7.esm.ctl'
'open $datain/NMME.tmpsfc.ss.clim_std.may_ic.1982-2010.ld1-7.esm.ctl'
'set x 1 360'
'set y 1 181'
'set gxout fwrite'
'set fwrite $dataout/NMME.tmpsfc.ss.may_ic.1982-2019.ld1-7.esm.anom.gr'
it=0
yt=1
while(yt<=$nyear)
ld=1
'set t 'yt''
while(ld<=$nlead)
it=it+1
'd f(t='it')-clm.2(t='ld')'

ld=ld+1
endwhile
yt=yt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <anom
#
cat>$dataout/NMME.tmpsfc.ss.may_ic.1982-2019.ld1-7.esm.anom.ctl<<EOF2
dset ^NMME.tmpsfc.ss.may_ic.1982-2019.ld1-7.esm.anom.gr
undef -9.99E+8
title EXP1
XDEF 360 LINEAR      0  1.0
YDEF 181 LINEAR    -90  1.0
zdef   1 linear 1 1
tdef $nyear linear $icmonyr 1yr
vars 7
a1    1 99 anom 
a2    1 99 anom 
a3    1 99 anom 
a4    1 99 anom 
a5    1 99 anom 
a6    1 99 anom 
a7    1 99 anom 
endvars
#
EOF2
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
'open $dataout/NMME.tmpsfc.ss.may_ic.1982-2019.ld1-7.esm.anom.ctl'
'set x 180'
'set y  91'
'set gxout fwrite'
'set fwrite $dataout/NMME.nino1-4.ss.may_ic.1982-2019.ld1-7.esm.anom.gr'
*
yt=1
while(yt<=$nyear)
'set t 'yt''

ld=1
while(ld<=$nlead)
'd aave(a'ld',x=271,x=280,y=86,y=91)'
ld=ld+1
endwhile

ld=1
while(ld<=$nlead)
'd aave(a'ld',x=211,x=270,y=86,y=96)'
ld=ld+1
endwhile

ld=1
while(ld<=$nlead)
'd aave(a'ld',x=171,x=241,y=86,y=96)'
ld=ld+1
endwhile

ld=1
while(ld<=$nlead)
'd aave(a'ld',x=161,x=211,y=86,y=96)'
ld=ld+1
endwhile

yt=yt+1
endwhile
EOFgs
#
/usr/local/bin/grads -bl <nino
#
cat>$dataout/NMME.nino1-4.ss.may_ic.1982-2019.ld1-7.esm.anom.ctl<<EOF2
dset ^NMME.nino1-4.ss.may_ic.1982-2019.ld1-7.esm.anom.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR      0  1.0
YDEF 1 LINEAR    -90  1.0
zdef   7 linear 1 1
tdef $nyear linear $icmonyr 1yr
vars 4
n12  7 99 nino
n3   7 99 nino
n4   7 99 nino
n34  7 99 nino
endvars
#
EOF2
#
# have nmme indices
done  # icseason loop
