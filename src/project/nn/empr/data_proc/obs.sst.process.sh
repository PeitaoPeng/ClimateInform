#!/bin/sh

set -eaux

#=========================================================
# for clm and std and verfication data 
# run this after current year Jul data available 
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/empr/data_proc
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

dataout=/cpc/home/wd52pp/data/nn/empr
#
cd $tmp
#
#for var in sst tmp2m prate; do
 for var in sst; do
#
yyyys=1949
#yyyys=1979
lastyr=2020
thisyr=2021
totyr=`expr $lastyr - $yyyys + 1`
#
totmon=`expr $totyr \* 12 + 3` # from jan$yyyys to Mar of this year
data_bgn=jan$yyyys  #jan1981 or 1949
data_end=mar$thisyr # past month
#
outfile=obs.$var.$yyyys-$thisyr.mon
#
undef_data=-9.99E+8
#
imx=144
jmx=73
#=======================================
# process sst data
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 'sst' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'open $dataout/hadoisst.mon.1948-curr.ctl'
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
tdef 9999 linear jan$yyyys 1mo
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
tdef 9999 linear jan$yyyys 1mo
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
tdef 9999 linear jan$yyyys 1mo
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
'open /cpc/home/wd52pp/project/nn/empr/data_proc/land.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $outfile.2.5x2.5.gr'
nt=1
while ( nt <= $totmon)

'set t 'nt
say 'time='nt
'set lon   0. 357.5'
'set lat -90.  90.'
'd lterp($var,land.2(time=jan1981))'

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
tdef   9999 linear jan$yyyys 1mo
*
VARS 1
o    0 99   monthly ave
ENDVARS
EOF
#
#=======================================
#
  for imon in 01 02 03 04 05 06 07 08 09 10 11 12; do
# for imon in 06; do
#
if [ $imon = 01 ]; then mon=jan; ss=jfm; fi
if [ $imon = 02 ]; then mon=feb; ss=fma; fi
if [ $imon = 03 ]; then mon=mar; ss=mam; fi
if [ $imon = 04 ]; then mon=apr; ss=amj; fi
if [ $imon = 05 ]; then mon=may; ss=mjj; fi
if [ $imon = 06 ]; then mon=jun; ss=jja; fi
if [ $imon = 07 ]; then mon=jul; ss=jas; fi
if [ $imon = 08 ]; then mon=aug; ss=aso; fi
if [ $imon = 09 ]; then mon=sep; ss=son; fi
if [ $imon = 10 ]; then mon=oct; ss=ond; fi
if [ $imon = 11 ]; then mon=nov; ss=ndj; fi
if [ $imon = 12 ]; then mon=dec; ss=djf; fi
#
# have field for a particular month or season
outfile1=obs.$var.$mon.$yyyys-$lastyr
outfile2=obs.$var.$ss.$yyyys-$lastyr
#
nmon=`expr $totyr \* 12 + 3`
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
it=$imon
while ( it <= $nmon)
'set t 'it
'd o'
it=it+12
endwhile
'disable fwrite'
*
'set gxout fwrite'
'set fwrite $outfile2.gr'
it=$imon
while ( it <= $nmon)
ite=it+2
say 'time='it
'd ave(o,t='it',t='ite')'
it=it+12
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
zdef  01 levels 1 
tdef   9999 linear ${mon}$yyyys 1yr
*
VARS 1
o    0 99   monthly ave
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
zdef  01 levels 1 
tdef   9999 linear ${mon}$yyyys 1yr
*
VARS 1
o    0 99   3-mon ave
ENDVARS
EOF
#
cat >clm_std_mon<<EOF
run woutm.gs
EOF
#
cat >woutm.gs<<EOF
'reinit'
'open $outfile1.ctl'
'set gxout fwrite'
'set fwrite obs.$var.$mon.clim_std.$yyyys-2020.gr'
'set x 1 $imx'
'set y 1 $jmx'
*'define clm=ave(o,t=1,t=42)'
'define clm=ave(o,t=31,t=72)'
'd clm'
'define std=sqrt(ave((o-clm)*(o-clm),t=1,t=30))'
'd std'
EOF
#
grads -bl <clm_std_mon
#
cat >clm_std_season<<EOF
run wouts.gs
EOF
#
cat >wouts.gs<<EOF
'reinit'
'open $outfile2.ctl'
'set gxout fwrite'
'set fwrite obs.$var.$ss.clim_std.$yyyys-2020.gr'
'set x 1 $imx'
'set y 1 $jmx'
*'define clm=ave(o,t=1,t=42)'
'define clm=ave(o,t=31,t=72)'
'd clm'
'define std=sqrt(ave((o-clm)*(o-clm),t=1,t=30))'
'd std'
EOF
#
grads -bl <clm_std_season
#
cat>obs.$var.$mon.clim_std.$yyyys-2020.ctl<<EOF
dset ^obs.$var.$mon.clim_std.$yyyys-2020.gr
undef -9.99e+8
*
TITLE fcst
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  01 levels 1 
tdef 9999 linear ${mon}$yyyys 1yr
vars 2
clm 1 99 over 30-yrs
std 1 99 over 30-yrs
ENDVARS
EOF
#
cat>obs.$var.$ss.clim_std.$yyyys-2020.ctl<<EOF
dset ^obs.$var.$ss.clim_std.$yyyys-2020.gr
undef -9.99e+8
*
TITLE fcst
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  01 levels 1 
tdef 9999 linear ${mon}$yyyys 1yr
vars 2
clm 1 99 over 30-yrs
std 1 99 over 30-yrs
ENDVARS
EOF
#
# for ss anom
#
cat >anom<<EOF
run anom.gs
EOF
cat >anom.gs<<EOF
'reinit'
'open $outfile2.ctl'
'open obs.$var.$ss.clim_std.$yyyys-2020.ctl'
'set gxout fwrite'
'set fwrite $outfile2.anom.gr'
'set x 1 144'
'set y 1 73'
nyr=$totyr
iy=1
while ( iy <= nyr)
'set t 'iy''
'd o-clm.2(t=1)'
iy=iy+1
endwhile
EOF
#
grads -bl <anom
#
cat>$outfile2.anom.ctl<<EOF
dset ^$outfile2.anom.gr
undef -9.99e+8
*
TITLE obs
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef    1 linear 1 1
tdef 9999 linear ${mon}$yyyys 1yr
vars 1
o 1 99 anom
ENDVARS
EOF
#
# for mon anom
#
cat >anom<<EOF
run anom.gs
EOF
cat >anom.gs<<EOF
'reinit'
'open $outfile1.ctl'
'open obs.$var.$mon.clim_std.$yyyys-2020.ctl'
'set gxout fwrite'
'set fwrite $outfile1.anom.gr'
'set x 1 144'
'set y 1 73'
nyr=$totyr
iy=1
while ( iy <= nyr)
'set t 'iy''
'd o-clm.2(t=1)'
iy=iy+1
endwhile
EOF
#
grads -bl <anom
#
cat>$outfile1.anom.ctl<<EOF
dset ^$outfile1.anom.gr
undef -9.99e+8
*
TITLE obs
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef    1 linear 1 1
tdef 9999 linear ${mon}$yyyys 1yr
vars 1
o 1 99 anom
ENDVARS
EOF

mv obs.$var.*.clim_std.* $dataout
mv $outfile1.anom.* $dataout
mv $outfile2.anom.* $dataout
#
done  # for imon
done  # for var
