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
 for var in ssttdc; do
#
#yyyys=1949
yyyys=1979
lastyr=2020
thisyr=2021
totyr=`expr $lastyr - $yyyys + 1`
totyr2=`expr $lastyr - 1948 + 1`
#
totmon=`expr $totyr \* 12 + 3` # from jan$yyyys to Mar of this year
totmon2=`expr $totyr2 \* 12 + 3` # from jan$yyyys to Mar of this year
data_bgn=jan$yyyys 
data_end=mar$thisyr # past month
#
outfile=obs.${var}  #tendency: sst(t)-sst(t-1)
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
if [ $var = 'ssttdc' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'open $dataout/hadoisst.mon.1948-curr.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $outfile.gr'
*nt=13
nt=373
while ( nt <= $totmon2)
mt=nt-1
'd sst(t='nt')-sst(t='mt')'
nt=nt+1
endwhile
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
'set fwrite $outfile.mon.1979-curr.gr'
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
cat>$outfile.mon.1979-curr.ctl<<EOF
dset ^$outfile.mon.1979-curr.gr
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
outfile1=$outfile.$mon.$yyyys-$lastyr.anom
#
nmon=`expr $totyr \* 12 + 3`
#
cat >mon_season<<fEOF
reinit
run wout.gs
fEOF
cat >wout.gs<<gsEOF
'reinit'
'open $outfile.mon.1979-curr.ctl'
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
gsEOF

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

mv $outfile1.* $dataout
#
done  # for imon
mv $outfile.mon.1979-curr.* $dataout
done  # for var
