#!/bin/sh

set -eaux

#=========================================================
# clm & std & verfication data 
# update every month
# update clim every 10 yrs, next time is jan 10,2031  
# don't forget to change clim file name  
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/opr
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir=/cpc/consistency/nn/obs
#
cd $tmp
#
#curmo=`date --date='today' '+%m'`  # mo of making fcst
 for curmo in 12 01 02 03 04 05 06 07 08 09 10 11; do
#for curmo in 05; do
#curyr=20`date --date='today' '+%y'`  # current_yr=20"xx"
curyr=2020
#curyr=2019

if [ $curmo = 01 ]
then 
lastmo=0
else
lastmo=`expr $curmo - 1`
fi

lastyr=`expr $curyr - 1`
totyr=`expr $lastyr - 1981`  # data from jan1982
clmperiod=1982-2011
#clmperiod=1991-2020
#
totmon=`expr $totyr \* 12 + $lastmo` # jan1982 to lst mon
nmon=`expr $totmon - 9` # back 9 mon to align with fcst data
nyr_anom=`expr $nmon / 12` # yrs of data for anom
mon_rsd=`expr $nmon - $nyr_anom \* 12 + 1` # number of residual mon
#
data_bgn=jan1982
# determine data_end
if [ $curmo = 01 ]; then data_end=dec$lastyr; fi
if [ $curmo = 02 ]; then data_end=jan$curyr; fi
if [ $curmo = 03 ]; then data_end=feb$curyr; fi
if [ $curmo = 04 ]; then data_end=mar$curyr; fi
if [ $curmo = 05 ]; then data_end=apr$curyr; fi
if [ $curmo = 06 ]; then data_end=may$curyr; fi
if [ $curmo = 07 ]; then data_end=jun$curyr; fi
if [ $curmo = 08 ]; then data_end=jul$curyr; fi
if [ $curmo = 09 ]; then data_end=aug$curyr; fi
if [ $curmo = 10 ]; then data_end=sep$curyr; fi
if [ $curmo = 11 ]; then data_end=oct$curyr; fi
if [ $curmo = 12 ]; then data_end=nov$curyr; fi
#
#for var in sst tmp2m prate; do
 for var in sst; do
#
outfile=obs.$var.1982-$lastyr.mon
#
undef_data=-9.99E+8
#
nleadmon=9
nleadss=7
imx=144
jmx=73
#=======================================
# process data
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 'sst' ]; then
cat >data_rewrite.gs<<EOF
'reinit'
'open /cpc/consistency/nn/obs/oisst.jan1982-cur.mon.tot.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set time $data_bgn $data_end'
'd sst'
'c'
EOF
#
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
ydef  180 linear  -89.5  1.0
xdef  360 linear    0.5  1.0
tdef 9999 linear jan1982 1mo
zdef    1 linear 1 1
vars 1
$var 0 99 obs
ENDVARS
EOF
fi
#=======================================
# process t2m data
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 'tmp2m' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'open /cpc/home/mingyue/PRODUCTS/TempSfcGlbMerg/TempSfcGlbMerg.MonTot.ctl'
'set x 1 144'
'set y 1 73'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set time $data_bgn $data_end'
'd tmpsfc'
'c'
EOF
#
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
ydef  73 linear  -90. 2.5
xdef 144 linear    0. 2.5
tdef 9999 linear jan1982 1mo
zdef    1 linear 1 1
vars 1
$var 0 99 obs
ENDVARS
EOF
fi
#
#=======================================
# rewrite prec data
#=======================================
undef_data=-9.99E+8
#
if [ $var = 'prate' ]; then
cat >data_rewrite.gs<<EOF3
    'reinit'
'open /cpc/prcp/PRODUCTS/CMAP/monthly/current/cmap_mon.lnx.ctl'
'set x 1 144'
'set y 1 72'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set time $data_bgn $data_end'
'd cmap'
'c'
EOF3
#
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
ydef  72 linear -88.75 2.5
xdef 144 linear   1.25 2.5
tdef 9999 linear jan1982 1mo
zdef    1 linear 1 1
vars 1
$var 0 99 obs
ENDVARS
EOF
fi
#
/usr/local/bin/grads -bl <havedata
#
#=======================================
# regrid to 2.5x2.5
#=======================================
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /cpc/home/wd52pp/project/nn/nmme/data_proc/land.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $outfile.2.5x2.5.gr'
nt=1
while ( nt <= $totmon)

'set t 'nt
*say 'time='nt
'set lon   0. 357.5'
'set lat -90.  90.'
'd lterp($var,land.2(time=feb1982))'

nt=nt+1
endwhile
gsEOF
#
/usr/local/bin/grads -pb <int
#
cat>$outfile.2.5x2.5.ctl<<EOF
dset ^$outfile.2.5x2.5.gr
undef -9.99E+8
*
options little_endian
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  01 levels 1 
tdef   9999 linear jan1982 1mo
*
VARS 1
o    0 99   monthly ave
ENDVARS
EOF
#
# VFC data for differnt IC_months =======================================
#
#
imon=$curmo
if [ $imon = 01 ]; then icmonw=dec; tgtm=jan; fi
if [ $imon = 02 ]; then icmonw=jan; tgtm=feb; fi
if [ $imon = 03 ]; then icmonw=feb; tgtm=mar; fi
if [ $imon = 04 ]; then icmonw=mar; tgtm=apr; fi
if [ $imon = 05 ]; then icmonw=apr; tgtm=may; fi
if [ $imon = 06 ]; then icmonw=may; tgtm=jun; fi
if [ $imon = 07 ]; then icmonw=jun; tgtm=jul; fi
if [ $imon = 08 ]; then icmonw=jul; tgtm=aug; fi
if [ $imon = 09 ]; then icmonw=aug; tgtm=sep; fi
if [ $imon = 10 ]; then icmonw=sep; tgtm=oct; fi
if [ $imon = 11 ]; then icmonw=oct; tgtm=nov; fi
if [ $imon = 12 ]; then icmonw=nov; tgtm=dec; fi
#
# have field for a particular month or season
outfile1=obs.$var.mon.${icmonw}_ic.1982-cur.ld1-$nleadmon
outfile2=obs.$var.ss.${icmonw}_ic.1982-cur.ld1-$nleadss
#
 nyr_a=$nyr_anom
 if [ $imon -lt $mon_rsd ]  
 then 
 nyr_a=`expr $nyr_anom + 1` 
 fi
#
cat >mon_season<<fEOF
reinit
run wout.gs
fEOF
cat >wout.gs<<gsEOF
'reinit'
'open $outfile.2.5x2.5.ctl'
'set x 1 $imx'
'set y 1 $jmx'

'set gxout fwrite'
'set fwrite $outfile1.gr'
nt=$imon
while ( nt <= $nmon)
it=nt
nte=nt+$nleadmon-1
while ( it <= nte)
'set t 'it
say 'time='it
'd o'
it=it+1
endwhile
nt=nt+12
endwhile
'disable fwrite'
*
'set gxout fwrite'
'set fwrite $outfile2.gr'
nt=$imon
while ( nt <= $nmon)
it=nt
nte=nt+$nleadss-1
while ( it <= nte)
ite=it+2
*say 'time='it
'd ave(o,t='it',t='ite')'
it=it+1
endwhile
nt=nt+12
endwhile
gsEOF
#
/usr/local/bin/grads -pb <mon_season

cat>$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef   1 levels 1 
tdef   9999 linear ${tgtm}1982 1mo
*
VARS 1
o    1 99   monthly ave
ENDVARS
EOF

cat>$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef -9.99E+8
*
options little_endian
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef   1 levels 1 
tdef   9999 linear ${tgtm}1982 1mo
*
VARS 1
o    1 99   3-mon ave
ENDVARS
EOF
#
for tp in mon ss; do

#yr_skip=`expr 1991 - 1981`  # skip 1982-1990 for clim of 1991-2020
yr_skip=0  # no skip for clim of 1982-2011

clm_mon_s=`expr $yr_skip \* $nleadmon + 1` # mon_start for clim
clm_mon_e=`expr $clm_mon_s + 29 \* $nleadmon - 1` # mon_end for clim

clm_ss_s=`expr $yr_skip \* $nleadss + 1`   # ss_start for clim
clm_ss_e=`expr $clm_ss_s + 29 \* $nleadss - 1`   # ss_end for clim

if [ $tp = 'mon' ]; then nlead=$nleadmon; clm_s=$clm_mon_s; clm_e=$clm_mon_e; outfile3=$outfile1; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; clm_s=$clm_ss_s;  clm_e=$clm_ss_e; outfile3=$outfile2; fi

cat >std_clm<<EOF
run wout2.gs
EOF
#
cat >wout2.gs<<EOF
'reinit'
'open obs.$var.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.ctl'
'set gxout fwrite'
'set fwrite obs.$var.$tp.clim_std.${icmonw}_ic.$clmperiod.gr'
'set x 1 $imx'
'set y 1 $jmx'
nte=$clm_s + $nlead -1
nt=$clm_s
say 'clm_s='nt
while ( nt <= nte)
'define clm=ave(o,t='nt',t=$clm_e,$nlead)'
'd clm'
'define std=sqrt(ave((o-clm)*(o-clm),t='nt',t=$clm_e,$nlead))'
'd std'
say 'nt='nt
nt=nt+1
endwhile
EOF
#
/usr/local/bin/grads -bl <std_clm
#
cat>obs.$var.$tp.clim_std.${icmonw}_ic.$clmperiod.ctl<<EOF
dset ^obs.$var.$tp.clim_std.${icmonw}_ic.$clmperiod.gr
undef -9.99e+8
*
TITLE fcst
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef   1 levels 1 1
tdef 9999 linear ${tgtm}1981 1mo
vars 2
clm 1 99 over 30-yrs
std 1 99 over 30-yrs
ENDVARS
EOF
#
# for anom
#
cat >anom<<EOF
run anom.gs
EOF
cat >anom.gs<<EOF
'reinit'
'open $outfile3.ctl'
'open obs.$var.$tp.clim_std.${icmonw}_ic.$clmperiod.ctl'
'set gxout fwrite'
'set fwrite $outfile3.anom.gr'
'set x 1 144'
'set y 1 73'
nyr=$nyr_a
say 'nyr=' nyr
nld=$nlead
iy=1
ir=1
while ( iy <= nyr)
ld=1
while ( ld <= nld)
'set t 'ir''
'd o-clm.2(t='ld')'
ld=ld+1
ir=ir+1
endwhile
iy=iy+1
endwhile
EOF
#
/usr/local/bin/grads -bl <anom
#
cat>$outfile3.anom.ctl<<EOF
dset ^$outfile3.anom.gr
undef -9.99e+8
*
TITLE obs
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  $nlead linear 1 1
tdef 9999 linear ${tgtm}1982 1yr
vars 1
o $nlead 99 lead1-$nlead
ENDVARS
EOF
#
# have Nino 34 index
#
if [ $var = 'sst' ]; then

cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
'open $outfile3.anom.ctl'
'set gxout fwrite'
'set fwrite obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.gr'
'set x 72'
'set y 37'
nyr=$nyr_a
say 'nyr=' nyr
nld=$nlead
iy=1
while ( iy <= nyr)
'set t 'iy
ld=1
while ( ld <= nld)
'set z 'ld
'd aave(o,lon=190,lon=240,lat=-5,lat=5))'
ld=ld+1
endwhile
iy=iy+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.ctl<<EOF
dset ^obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.gr
undef -9.99e+8
*
TITLE obs
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef $nlead linear 1 1
tdef 9999 linear ${tgtm}1982 1yr
vars 1
o $nlead 99 lead1-$nlead
ENDVARS
EOF

fi

#
done  # for tp
#
mv obs.$var.*.clim_std.* $datadir
mv obs*anom*.* $datadir
mv obs.nino34.* $datadir
#mv $outfile1.* $datadir
#mv $outfile2.* $datadir
#mv $outfile.2.5x2.5* $datadir
#done  # for imon
done  # for var
done  # for curm
