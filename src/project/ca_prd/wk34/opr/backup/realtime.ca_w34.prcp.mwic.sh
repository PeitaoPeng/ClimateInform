#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmpdir=/cpc/home/wd52pp/tmp/opr
tmpp=/cpc/home/wd52pp/tmp/opr/prcp
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
if [ ! -d $tmpp ] ; then
  mkdir -p $tmpp
fi
datadir=/cpc/home/wd52pp/data/ca_prd
bindir=/cpc/home/wd52pp/bin
#
# IC date and week#
YEAR=`date --date='2 day ago' '+%Y'`
MONTH=`date --date='2 day ago' '+%m'`
DAY=`date --date='2 day ago' '+%d'`
idate=$YEAR/$MONTH/$DAY
jday=`date -d $idate +%j`
if [ $jday -le 7 ]; then jday=7; fi
iweek=`expr $jday / 7`
#
#forecast date
fy4=`date --date='today' '+%Y'`
fm2=`date --date='today' '+%m'`
fd2=`date --date='today' '+%d'`
#
if [ $fm2 = 01 ]; then icmon=jan; fi
if [ $fm2 = 02 ]; then icmon=feb; fi
if [ $fm2 = 03 ]; then icmon=mar; fi
if [ $fm2 = 04 ]; then icmon=apr; fi
if [ $fm2 = 05 ]; then icmon=may; fi
if [ $fm2 = 06 ]; then icmon=jun; fi
if [ $fm2 = 07 ]; then icmon=jul; fi
if [ $fm2 = 08 ]; then icmon=aug; fi
if [ $fm2 = 09 ]; then icmon=sep; fi
if [ $fm2 = 10 ]; then icmon=oct; fi
if [ $fm2 = 11 ]; then icmon=nov; fi
if [ $fm2 = 12 ]; then icmon=dec; fi
#
ddmmyy=$fd2$icmon$fy4
#
cd $tmpdir
nps=15   #width of data window in wk#
nwextb=5  #wk number to be extended at begining of a row of the array
nwexte=`expr $nps - $nwextb - 1`  #wk number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nyear=42 # 1979-2020
nseason=`expr $nyear - 2` #for eof and ca analysis
kocn=15  # or 15years
#
npp=`expr $nps - 4`
#
#
for mwic in 1 4; do
#for mwic in 1 2 3 4; do
#for modemax in 15 25 35; do
for modemax in 35; do
cp $lcdir/realtime.ca_w34.p.mwic.f $tmpdir/prcp_prd.f
cp $lcdir/eof_4_ca.s.f $tmpdir/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=144,jms=73)  !input psi200 dimension
      parameter(imt=144,jmt=73)    !input  prcp dimension
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
      parameter(mwic=$mwic)
eof
#
gfortran -o ca.x prcp_prd.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $tmpdir/psi200.mwic.gr fort.10
ln -s $datadir/wk.psia.1979-curr.gr fort.11
ln -s $datadir/wk.prcpa.1979-curr.gr fort.12
ln -s $datadir/wk.prcpa_normalized.1979-curr.gr fort.14
ln -s $datadir/wk.psi_clim.1991-2020.gr fort.13
#
ln -s $tmpdir/real_prd.psi200_wkly.${mwic}ics.$modemax.bin fort.85
ln -s $tmpdir/real_prd_psi200_prcp_wkly.${mwic}ics.$modemax.bin fort.86
ln -s $tmpdir/ca_prcp_wk34.${mwic}ics.$modemax.bin fort.87
#
./ca.x > $lcdir/realtime.w34.ca.${mwic}ics.$modemax.out
#
cat>$tmpdir/real_prd_psi200_prcp_wkly.${mwic}ics.$modemax.ctl<<EOF
dset ^real_prd_psi200_prcp_wkly.${mwic}ics.$modemax.bin
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef   73 linear  -90 2.5
zdef   1 levels 500
tdef   1 linear $ddmmyy 1dy
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
cat>$tmpdir/real_prd.psi200_wkly.${mwic}ics.$modemax.ctl<<EOF
dset ^real_prd.psi200_wkly.${mwic}ics.$modemax.bin
undef -9.99E+33
title EXP1
xdef  144 linear   0.  2.5
ydef   44 linear -20.  2.5
zdef   1 levels 500
tdef   1 linear $ddmmyy 1dy
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
#

cat>$tmpdir/ca_prcp_wk34.${mwic}ics.$modemax.ctl<<EOF
dset ^ca_prcp_wk34.${mwic}ics.$modemax.bin
undef -9.99E+33
title prcp unit=0.1mm/day
xdef  144 linear   0 2.5
ydef   73 linear  -90 2.5
zdef   1 levels 500
tdef   1 linear $ddmmyy 1dy
vars  12
w34   1 99 psi based wk34
ocn   1 99 OCN prd
wk2   1 99 psi-based + trd
wk3   1 99 psi-based + trd
wk4   1 99 psi-based + trd
prd   1 99 wk34 + trd
prb   1 99 prob format of prd
trd   1 99 trend per year
hss   1 99 HSS_2c
pic   1 99 psi ic
ostd 1 99 obs std
pstd 1 99 prd std
endvars
EOF

#cp $tmpdir/ca_prcp_wk34.${mwic}ics.$modemax.ctl /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2
#cp $tmpdir/ca_prcp_wk34.${mwic}ics.$modemax.bin /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2

done
done
