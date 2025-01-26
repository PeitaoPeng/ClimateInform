#
#======================================
# PCR from sst to tpz
#=======================================

set -eaux

lcdir=/home/ppeng/src/develop/pcr
tmp=/home/ppeng/tmp
datain1=/home/ppeng/data/sst
datain2=/home/ppeng/data/tpz
datadir=/home/ppeng/data/test
#
#var1=ersst
#var1=hadoisst
#var2=hgt # t2m,prec,hgt
#
nyr=75
nmon=900  # nmon=nyr*12
eof_area=tp_nml # gltp,tp_nml
del=3 # =1 if monthly sst
nfyr_start=48 # 48: 1995
nskip=0
undef=-999.0
ngrd=10000
#
for var1 in ersst; do
	if [ $var1 = hadoisst ] && [ $eof_area = gltp ]; then ngrd=11399; fi
	if [ $var1 = hadoisst ] && [ $eof_area = tp_nml ]; then ngrd=18632; fi
	if [ $var1 = hadoisst ] && [ $eof_area = nml ]; then ngrd=7233; fi
	if [ $var1 = ersst ] && [ $eof_area = gltp ]; then ngrd=11020; fi
	if [ $var1 = ersst ] && [ $eof_area = tp_nml ]; then ngrd=17888; fi
	if [ $var1 = ersst ] && [ $eof_area = nml ]; then ngrd=6868; fi
	echo ngrd

	if [ $eof_area = gltp ]; then lons=1;lone=360;lats=70;late=111; fi #global tropics
	if [ $eof_area = gl ]; then lons=1;lone=360;lats=1;late=180; fi #global
	if [ $eof_area = tp_nml ]; then lons=1;lone=360;lats=70;late=150; fi #tropical and N. mid-lad
	if [ $eof_area = nml ]; then lons=1;lone=360;lats=112;late=150; fi #tropical and N. mid-lad
	if [ $eof_area = tp_p ]; then lons=119;lone=291;lats=70;late=111; fi #tropical Pacific

for var2 in prec; do
#for nmod in 1 3 5 7 9 11 13 15; do
for nmod in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25; do
#for tgtss in djf mam jja son; do
for tgtss in djf; do
for ilead in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
#
#ngrd=42325  # hadoi for gl
#ngrd=40300  # ersst for gl
#ngrd=19568 # for tp_nml
#
if [ $tgtss = jfm ]; then itgt=1; fi
if [ $tgtss = fma ]; then itgt=2; fi
if [ $tgtss = mam ]; then itgt=3; fi
if [ $tgtss = amj ]; then itgt=4; fi
if [ $tgtss = mjj ]; then itgt=5; fi
if [ $tgtss = jja ]; then itgt=6; fi
if [ $tgtss = jas ]; then itgt=7; fi
if [ $tgtss = aso ]; then itgt=8; fi
if [ $tgtss = son ]; then itgt=9; fi
if [ $tgtss = ond ]; then itgt=10; fi
if [ $tgtss = ndj ]; then itgt=11; fi
if [ $tgtss = djf ]; then itgt=12; fi
#
cp $lcdir/rpcr_sst2tpz_mlead.f $tmp/pcr.f

cp $lcdir/reof.s.f $tmp/reof.s.f
cd $tmp
#
cat > parm.h << eof
       parameter(nyr=$nyr,nmon=$nmon,del=$del)
       parameter(itgt=$itgt,ilead=$ilead)
       parameter(nfys=$nfyr_start)
       parameter(imx=360,jmx=180)
       parameter(nmod=$nmod)
       parameter(ngrd=$ngrd)
       parameter(lons=$lons,lone=$lone,lats=$lats,late=$late) !eof_area=tp Pacific
       parameter(id=0)
eof
#
infile1=$var1.3mon.1948-curr.total.1x1
infile2=$var2.1948_cur.3mon.total.1x1
outfile=${var1}_2_$var2.ld$ilead.nmod$nmod.$tgtss.${eof_area}
outfile1=rpcr_$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_eof_${eof_area}
outfile2=skill.rpcr_vs_obs.$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_eof_${eof_area}
outfile3=${var2}_rregr.$tgtss.ld$ilead.48-21.${var1}_reof_${eof_area}
#
\rm $tmp/fort.*
#
gfortran -o pcr.x reof.s.f pcr.f
echo "done compiling"
#
ln -s $datain1/$infile1.gr            fort.10
ln -s $datain2/$infile2.gr            fort.11

ln -s $datadir/rpc.$outfile.gr         fort.20
ln -s $datadir/reof.$outfile.gr        fort.21
#
ln -s $datadir/$outfile3.gr           fort.30
ln -s $datadir/$outfile1.gr           fort.31
ln -s $datadir/$outfile2.gr           fort.32
#
./pcr.x > $datadir/out_rpcr.$outfile
#
cat>$datadir/rpc.$outfile.ctl<<EOF
dset $datadir/rpc.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  1 linear   0.5 1.
ydef  1 linear -89.5 1.
zdef  1 levels 1
tdef 75 linear jan1948 1yr
edef $nmod names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
vars  1
cf   0 99 PC
endvars
EOF
#
cat>$datadir/reof.$outfile.ctl<<EOF
dset $datadir/reof.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nmod linear jan1980 1yr
vars  2
cor  0 99 corr
reg  0 99 regr
endvars
EOF
#
cat>$datadir/$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  999 linear jan1995 1yr
vars  2
o     0 99 regr
p     0 99 regr
endvars
EOF
#
cat>$datadir/$outfile2.ctl<<EOF
dset $datadir/$outfile2.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  1 linear jan1995 1yr
vars  2
cor   0 99 regr
rms   0 99 regr
endvars
EOF
#
cat>$datadir/$outfile3.ctl<<EOF
dset $datadir/$outfile3.gr
undef $undef
title Realtime Surface Obs
xdef  360 linear   0.5 1.
ydef  180 linear -89.5 1.
zdef  1 levels 1
tdef  $nmod linear jan1995 1yr
vars  2
cor   0 99 corr
reg   0 99 regr
endvars
EOF
#
done # loop ilead
done # loop nmod
done # loop var2
done # loop eof_range
done # loop var1
