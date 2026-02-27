#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp/test
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/cpc/analysis/verif/ocean/sst/oi/ctl
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/casst
#
latest_mon=may2016  #the end-mon of latest IC season
icmon_mid=apr2016   #the mid-mon of latest IC season
icseason=3  # jfm=1
tmax=821  # 816=dec2015
nyear=68 # 1948-2015
#
ndec=4   #decade # 51-80, 61-90, 71-00, 81-10 
kocn=15

cd $tmp
#=======================================
# have HAD sst jan1948-oct1981
#=======================================
sstdir=/cpc/home/wd52pp/data/obs/sst
bjha=/cpc/GODAS/bjha/MERGEDSST
datadir=/cpc/home/wd52pp/data/ca_prd
outdir=/cpc/home/wd52pp/data/casst
#
outsst1=hadsst.jan1948-oct1981
times=jan1948
timee=oct1981
#
cat >hadsst<<EOF
run havehadsst.gs
EOF
#
cat >havehadsst.gs<<EOF
'reinit'
'open $bjha/ncar.SST.HAD187001-198110.OI198111-201003.ctl'
'open $sstdir/mask_had.ctl'
'set gxout fwrite'
'set fwrite $outsst1.gr'
'set x 1 360'
'set y 1 180'
'set time '$times' '$timee''
'd maskout(sst,mask.2(time=jan1949)-1)'
'c'
EOF
#===========================================
# excute grads data process
#===========================================
grads -l <hadsst
#
#=======================================
# have OI sst nov1981-cur
#=======================================
outsst2=oisst.nov1981-cur
times=nov1981
timee=$latest_mon
#
cat >oisst<<EOF
run haveoisst.gs
EOF
#
cat >haveoisst.gs<<EOF
'reinit'
'open /cpc/analysis/verif/ocean/sst/oi/ctl/monoiv2.ctl'
'open $sstdir/mask_oi.ctl'
'set gxout fwrite'
'set fwrite $outsst2.gr'
'set x 1 360'
'set y 1 180'
'set time '$times' '$timee''
'd maskout(273.16+sst,mask.2(time=nov1981)-1)'
'c'
EOF
#
#
#===========================================
# excute grads data process
#===========================================
grads -l <oisst
#
outfile=sst.hadoi.jan1948-cur.mon
#
cat $outsst1.gr $outsst2.gr > $outfile.gr
#
cat>$outfile.ctl<<EOF
dset ^$outfile.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 01 LEVELS 1
tdef 9999 linear jan1948 1mo
VARS 1
sst  0 99     veg
ENDVARS
EOF
#=======================================
# regrid to 2x2
#=======================================
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /cpc/home/wd52pp/data/obs/sst/grid.2x2.ctl'
'set gxout fwrite'
'set fwrite $outfile.2x2.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'set lon 0 358'
'set lat -88 88'
'd lterp(sst,sst.2(time=jan1949))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$outfile.2x2.ctl<<EOF
dset ^$outfile.2x2.gr
undef -9.99E+8
*
options little_endian
*
xdef 180 linear   0  2
ydef  89 linear -88  2
ZDEF 1 LEVELS 1
tdef 1200 linear jan1948 1mo
*
VARS 1
sst 1  99   u10m
ENDVARS
EOF
#
#=======================================
# have monthly anomalies
#=======================================
outfile2=hadoisst.mon.1948-curr
ts=1
te=$tmax
#
cat >anom<<EOF
run haveanom.gs
EOF
#
cat >haveanom.gs<<EOF
'reinit'
'open $outfile.2x2.ctl'
'set gxout fwrite'
'set fwrite $outfile2.gr'
'set x 1 180'
'set y 1 89'
'set t 1 12'
'define sstc=ave(sst,t+396,t=756,1yr)'
*'define sstc=ave(sst,t+0,t=$tmax,1yr)'
'modify sstc seasonal'
'set t 1 '$te''
'd sst-sstc'
'c'
EOF
#
grads -l <anom
#
cat>$outfile2.ctl<<EOF
dset ^$outfile2.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
xdef 180 linear   0  2
ydef  89 linear -88  2
ZDEF 1 LEVELS 1
tdef 1200 linear jan1948 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
#
#=======================================
# have 3-mon avg anomalies
#=======================================
outfile3=hadoisst.3mon.1948-curr
ts=2
te=`expr $tmax - 1`
#
cat >3mavg<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open $outfile2.ctl'
'set x 1 180'
'set y 1  89'
'set gxout fwrite'
'set fwrite $outfile3.gr'
'set t '$ts' '$te''
'd ave(sst,t-1,t+1)'
'c'
EOF
#
grads -l <3mavg
#
cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
*options little_endian
undef -999000000
TITLE  3mon avg
xdef 180 linear   0  2
ydef  89 linear -88  2
ZDEF 1 LEVELS 1
tdef 1200 linear feb1948 1mo
VARS 1
t  0 99     anom
ENDVARS
EOF
#
mv $outfile2* $datadir
mv $outfile3* $datadir
#
#======================================
# define some parameters
#======================================
sst_analysis=hadoisst
#
#for eof_range in tp_ml tp_np; do
for eof_range in tp_ml; do
#
#eof_range=tp_np   #30S-60N
#eof_range=tp_ml   #45S-45N
#
if [ $eof_range == tp_np ]; then neoflat=46; eoflats=-30; lats=30; late=75; ngrd=5670; fi
if [ $eof_range == tp_ml ]; then neoflat=47; eoflats=-46; lats=22; late=68; ngrd=6438; fi
#
#======================================
# have ic data
#======================================
outfile=${sst_analysis}.msic.ic
cat >haveic<<EOF
run sstic.gs
EOF
ic1=`expr $tmax - 2`
ic2=`expr $ic1 - 3`
ic3=`expr $ic1 - 6`
ic4=`expr $ic1 - 9`
cat >sstic.gs<<EOF
'reinit'
'open $datadir/$outfile3.ctl'
'set x 1 180'
'set y 1  89'
'set gxout fwrite'
'set fwrite $datadir/$outfile.gr'
'set t $ic1'
'd t'
'set t $ic2'
'd t'
'set t $ic3'
'd t'
'set t $ic4'
'd t'
'c'
EOF
#
grads -l <haveic
#
cat>$datadir/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
TITLE Tsfc
*
xdef  180 linear   0. 2.
ydef   89 linear -89. 2.
zdef   1 linear 1 1
tdef   9999 linear jan2015 1mo
vars 1
t  1 99 3-mon mean (C)
ENDVARS
EOF
#
nps=11     #width of data window in season
nwextb=10  # 3mon season number to be extended at begining of a row of the array
nwexte=10  # 3mon season number to be extended at the end of a row of the array
runeof=1 # 0: read in ; 1: run eof
nseason=`expr $nyear - 2` #for eof and ca analysis
#
mlead=10  #maximum lead
mldp=`expr $mlead + 1` 
#
#for msic in 1; do
for msic in 1 2 3 4; do
#for modemax in 20 25 30 40 50 60; do
for modemax in 15 20 25 30 35 40; do
#for modemax in 35 40 45 50 55 60; do
#
cp $lcdir/realtime.ca_msic.season.sst.2x2.f $tmp/sst_prd.f
cp $lcdir/eof_4_ca.s.f $tmp/eof_4_ca.s.f

#
cat > parm.h << eof
      parameter(nruneof=$runeof)
c
      parameter(ims=180,jms=89)   !input sst dimension
c
      parameter(lons=1,lone=180)   !lon range for EOFs analysis (0-360)
      parameter(eoflats=$eoflats,lats=$lats,late=$late)  !lat range for EOFs analysis (25S-65N)
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
      parameter(ndec=$ndec)
      parameter(itgtm=$icseason)
      parameter(mlead=$mlead)
      parameter(mldp=$mldp)
      parameter(ngrd=$ngrd)
      parameter(msic=$msic)
eof
#
gfortran -o ca.x sst_prd.f eof_4_ca.s.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
ln -s $datadir/${sst_analysis}.msic.ic.gr fort.10
ln -s $datadir/${sst_analysis}.3mon.1948-curr.gr fort.11
#
ln -s $outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr fort.70
#
ln -s $outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr fort.85
#
ca.x > $outdata/realtime.${sst_analysis}.${eof_range}.$modemax.${msic}ics.out
#ca.x 
#
cat>$outdata/eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.ctl<<EOF
dset ^eof.${sst_analysis}.${eof_range}.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef  $neoflat linear $eoflats 2.
zdef  1 linear 1 1
tdef  99 linear jan1949 1mon
vars  1
eof   1 999 constructed
endvars
EOF
#
cat>$outdata/real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.ctl<<EOF
dset ^real_ca_prd.${sst_analysis}.${eof_range}.$modemax.${msic}ics.3mon.gr
undef -9.99E+33
title EXP1
xdef  180 linear   0. 2.
ydef   89 linear -88. 2.
zdef  1 linear 1 1
tdef  $mldp linear $icmon_mid 1mon
vars  5
sst   1 99 sst prd
sdo   1 99 std of obs
sdf   1 99 std of fcst
ac    1 99 ac skill
rms   1 99 rms skill
endvars
EOF
#
done  # maxmode
done  # msics
done  # eof_range
