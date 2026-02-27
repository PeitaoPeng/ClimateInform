#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/hcast
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/ca_prd
outdir=/cpc/home/wd52pp/data/wk34_fcst/ca/2015
bindir=/cpc/home/wd52pp/bin
#
cd $tmp
#
#fy4=2015
iw=65 #= 0 4 9 13 17 22 26 30 35 39 43 48 52 57 61 65
#fm2=09
#for fd2 in 04 11 18 25; do
#fm2=10
#for fd2 in 02 09 16 23 30; do
#fm2=11
#for fd2 in 06 13 20 27; do
#fm2=12
#for fd2 in 04 11 18 25; do

fy4=2016
#fm2=01
#for fd2 in 01 08 15 22 29; do
#fm2=02
#for fd2 in 05 12 19 26; do
#fm2=03
#for fd2 in 04 11 18 25; do
#fm2=04
#for fd2 in 01 08 15 22 29; do
#fm2=05
#for fd2 in 06 13 20 27; do
#fm2=06
#for fd2 in 03 10 17 24; do
#fm2=07
#for fd2 in 01 08 15 22 29; do
#fm2=08
#for fd2 in 05 12 19 26; do
#fm2=09
#for fd2 in 02 09 16 23 30; do
#fm2=10
#for fd2 in 07 14 21 28; do
#fm2=11
#for fd2 in 03 11 18 25; do
fm2=12
for fd2 in 02 09; do

outd=/cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2
outdata=${outd}/$fd2
if [ ! -d $outd ] ; then
  mkdir -p $outd
fi
if [ ! -d $outdata ] ; then
  mkdir -p $outdata
fi
#

iw=`expr $iw + 1`

iweek=$iw+35
if [ $iw -gt 17 ] ; then
  iweek=`expr $iw - 17`
fi
echo iweek= $iweek
#
cat >readic<<EOF
run read.gs
EOF
cat >read.gs<<EOF
'reinit'
'open $datadir/psi.wk.sep2015-cur.ctl'
'set x 1 144'
'set y 1 73'
'set gxout fwrite'
'set fwrite $tmp/psi200.gr'
'set t $iw'
'd psi'
'c'
EOF
grads -l <readic

nps=15   #width of data window in wk#
nwextb=5  #wk number to be extended at begining of a row of the array
nwexte=`expr $nps - $nwextb - 1`  #wk number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nyear=37 # 1979-2015
#nyear=`expr $fy4 - 1979`
nseason=`expr $nyear - 2` #for eof and ca analysis
kocn=15 # 15 or 8years
#
npp=`expr $nps - 4`
#
for modemax in 35; do
cp $lcdir/hcast.ca_w34.tz.f $tmp/sat_prd.f
cp $lcdir/eof_4_ca.s.f $tmp/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=144,jms=73)  !input psi200 dimension
      parameter(imt=144,jmt=73)    !input  sat dimension
c
      parameter(lons=1,lone=144)   !lon range for EOFs analysis (0-360)
c     parameter(eoflats=20,lats=45,late=72)   !lat range for EOFs analysis (20N-90N)
      parameter(eoflats=-20,lats=29,late=72)  !lat range for EOFs analysis (20S-90N)
      parameter(imp=lone-lons+1,jmp=late-lats+1)
c
      parameter(modemax=$modemax)
      parameter(nyear=$nyear)
      parameter(nseason=$nseason)
      parameter(nps=$nps)
      parameter(nwextb=$nwextb)
      parameter(nwexte=$nwexte)
c
      parameter(kocn=$kocn)
      parameter(itgtw=$iweek)
eof
#
gfortran -o ca.x sat_prd.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmp/fort.*
#
ln -s $tmp/psi200.gr fort.10
ln -s $datadir/wk.psia.1979-curr.gr fort.11
ln -s $datadir/wk.sata.1979-curr.gr fort.12
ln -s $datadir/wk.psi_clim.1981-2010.gr fort.13
#
ln -s $tmp/real_prd.psi200_wkly.bin fort.85
ln -s $tmp/real_prd_psi200_sat_wkly.bin fort.86
ln -s $tmp/ca_sat_wk34.bin fort.87
#
./ca.x > $lcdir/realtime.w34.ca.out
#
cat>$tmp/real_prd_psi200_sat_wkly.ctl<<EOF
dset ^real_prd_psi200_sat_wkly.bin
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef  73 linear  -90 2.5
zdef   1 levels 500
tdef  1 linear     jan94     1mon
vars  6
tic   1 99 constructed
pw1   1 99 wk1 fcst
pw2   1 99 wk2 fcst
pw3   1 99 wk3 fcst
pw4   1 99 wk4 fcst
pw34  1 99 wk34 fcst
endvars
EOF
#
cat>$tmp/real_prd.psi200_wkly.ctl<<EOF
dset ^real_prd.psi200_wkly.bin
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef   1 levels 500
tdef   1 linear     jan94     1mon
vars  7
pic   1 99 psi ic
cic   1 99 constructed ic
pw1   1 99 wk1 fcst
pw2   1 99 wk2 fcst
pw3   1 99 wk3 fcst
pw4   1 99 wk4 fcst
pw34   1 99 wk34 fcst
endvars
EOF
done
#

cat>$tmp/ca_sat_wk34.ctl<<EOF
dset ^ca_sat_wk34.bin
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef  73 linear  -90 2.5
zdef   1 levels 500
tdef  1  linear     jan94     1mon
vars  9
psi   1 99 psi based prd
ocn   1 99 OCN prd
prd   1 99 psi-based + trd
prb   1 99 prob format of prd
trd   1 99 trend per year
hss   1 99 HSS_2c
pic   1 99 psi ic
ostd 1 99 obs std
pstd 1 99 prd std
endvars
EOF

cp $tmp/ca_sat_wk34.ctl /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2
cp $tmp/ca_sat_wk34.bin /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2

done
