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
#for var in d20 sl; do
for var in sl; do
#
lastyr=2020
thisyr=2021
totyr=`expr $lastyr - 1978`
#
totmon=`expr $totyr \* 12 + 3` # from jan1979 to Mar of this year
data_bgn=jan1979 
data_end=mar$thisyr # past month
#
outfile=obs.$var.1979-$thisyr.mon
#
undef_data=-9.99E+8
#
imx=144
jmx=73
#=======================================
# process d20 data
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 'd20' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'open /cpc/GODAS/month/mnth.d20.ctl'
'set x 1 360'
'set y 1 139'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set time $data_bgn $data_end'
'd d20'
'c'
EOF
#
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef  360 linear    0.5  1.0
ydef  139 linear  -74. 1.0
tdef 9999 linear jan1979 1mo
zdef    1 linear 1 1
vars 1
$var 0 99 obs
ENDVARS
EOF
fi
#=======================================
# process sea level height data
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 'sl' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
'open /cpc/GODAS/month/mnth.sl.ctl'
'set x 1 360'
'set y 1 139'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set time $data_bgn $data_end'
'd $var'
'c'
EOF
#
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef 360 linear  0.5 1.
ydef 139 linear  -74. 1.
tdef 9999 linear jan1979 1mo
zdef    1 linear 1 1
vars 1
$var 0 99 obs
ENDVARS
EOF
fi
#
#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
/usr/local/bin/grads -bl <havedata
#
# convert data from 360x139 to 360x181
#
cat>cvt.f<<EOF
      program convert
      parameter(imx=360,jmx=139,jmxo=181)
      parameter(nt=$totmon)
      parameter(undef=-9.99e+8)
C===========================================================
      real w2d1(imx,jmx),w2d2(imx,jmxo)
c
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmxo)
C
      do it=1,nt
        read(10,rec=it) w2d1

        do i=1,imx
        do j=1,jmxo
          w2d2(i,j)=undef
        enddo
        enddo

        do i=1,imx
        do j=1,jmx
          w2d2(i,j+16)=w2d1(i,j)
        enddo
        enddo

        write(20,rec=it) w2d2
      enddo

      stop
      end
EOF
gfortran -o cvt.x cvt.f
#
cat>$outfile.full.ctl<<EOF
dset $outfile.full.gr
undef $undef_data
xdef 360 linear  0.5 1.
ydef 181 linear -90. 1.
tdef 9999 linear jan1979 1mo
zdef    1 linear 1 1
vars 1
$var 0 99 obs
ENDVARS
EOF

ln -s $outfile.gr  fort.10
ln -s $outfile.full.gr  fort.20

#excute program
cvt.x
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
'open $outfile.full.ctl'
'open /cpc/home/wd52pp/project/nn/empr/data_proc/land.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $outfile.2.5x2.5.gr'
nt=1
while ( nt <= $totmon)

'set t 'nt
say 'time='nt
'set lon   0. 357.5'
'set lat  -90.  90.'
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
tdef   9999 linear jan1979 1mo
*
VARS 1
o    0 99   monthly ave
ENDVARS
EOF
#
#=======================================
# have monthly anomalies
#=======================================
outfile1=obs.$var.mon.1979-curr
ts=1
te=$totmon
clm_bgn=0   #dec1978
clm_end=`expr $clm_bgn + 504` # dec2020
#
cat >anom<<EOF
run haveanom.gs
EOF
#
cat >haveanom.gs<<EOF
'reinit'
'open $outfile.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $outfile1.gr'
'set x 1 144'
'set y 1 73'
'set t 1 12'
'define oc=ave(o,t+$clm_bgn,t=$clm_end,1yr)'
'modify oc seasonal'
'set t $ts $te'
'd o-oc'
'c'
EOF
#
/usr/local/bin/grads -bl <anom
#
cat>$outfile1.ctl<<EOF
dset ^$outfile1.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months

XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
ZDEF  01 LEVELS 1
tdef 1200 linear jan1979 1mo
VARS 1
$var 0 99     anom
ENDVARS
EOF

#
#=======================================
#
for imon in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for imon in 11; do
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
outfile2=obs.$var.$mon.1979-$lastyr.anom
outfile3=obs.$var.$ss.1979-$lastyr.anom
#
nmon=$totmon
#
cat >mon_season<<fEOF
reinit
run wout.gs
fEOF
cat >wout.gs<<gsEOF
'reinit'
'open $outfile1.ctl'
'set x 1 $imx'
'set y 1 $jmx'

'set gxout fwrite'
'set fwrite $outfile2.gr'
it=$imon
while ( it <= $nmon)
'set t 'it
'd $var'
it=it+12
endwhile
'disable fwrite'
*
'set gxout fwrite'
'set fwrite $outfile3.gr'
it=$imon
while ( it <= $nmon)
ite=it+2
say 'time='it
'd ave($var,t='it',t='ite')'
it=it+12
endwhile
gsEOF
#
/usr/local/bin/grads -pb <mon_season

cat>$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef -9.99E+8
*
options little_endian
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  01 levels 1 
tdef   9999 linear ${mon}1979 1yr
*
VARS 1
o    0 99   monthly ave
ENDVARS
EOF

cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef -9.99E+8
*
options little_endian
*
XDEF 144 LINEAR    0.  2.5
YDEF  73 LINEAR  -90.  2.5
zdef  01 levels 1 
tdef   9999 linear ${mon}1979 1yr
*
VARS 1
o    0 99   3-mon ave
ENDVARS
EOF
#
mv $outfile2.* $dataout
#mv $outfile3.* $dataout
#
done  # for imon
mv $outfile1.* $dataout
done  # for var
