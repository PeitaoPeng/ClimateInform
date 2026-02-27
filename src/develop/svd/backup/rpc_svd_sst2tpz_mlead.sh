#
#======================================
# PC_SVD from sst to tpz
#=======================================

set -eaux

lcdir=/home/peitao/src/develop/svd
tmp=/home/peitao/tmp
datain1=/home/peitao/data/sst
datain2=/home/peitao/data/tpz
datadir=/home/peitao/data/test
#
nyr=75
nmon=900  # nmon=nyr*12
sst_area=tp_nml # gltp,tp_nml
tpz_area=nhml # nhm,na, conus
del=3 # =1 if monthly sst
nfyr_start=48 # 48: 1995
mv1=15
mv2=15
msvd=15
id=0 # =1 for cor matrix; =0 for var metrix
#
nskip=0
undef=-999.0
#
for var1 in ersst; do  # hadoisst, ersst
	if [ $var1 = hadoisst ] && [ $sst_area = gltp ]; then ngrdv1=11399; fi
	if [ $var1 = hadoisst ] && [ $sst_area = tp_nml ]; then ngrdv1=18632; fi
	if [ $var1 = hadoisst ] && [ $sst_area = nml ]; then ngrdv1=7233; fi
	if [ $var1 = ersst ] && [ $sst_area = gltp ]; then ngrdv1=11020; fi
	if [ $var1 = ersst ] && [ $sst_area = tp_nml ]; then ngrdv1=17888; fi
	if [ $var1 = ersst ] && [ $sst_area = nml ]; then ngrdv1=6868; fi

	if [ $tpz_area = conus ]; then ngrdv2=1153; fi
	if [ $tpz_area = nhml ]; then ngrdv2=9282; fi
	echo ngrdv1

	if [ $sst_area = gltp ]; then isv1=1;iev1=360;jsv1=70;jev1=111; fi #global tropics
	if [ $sst_area = gl ]; then isv1=1;iev1=360;jsv1=1;jev1=180; fi #global
	if [ $sst_area = tp_nml ]; then isv1=1;iev1=360;jsv1=70;jev1=150; fi #tropical and N. mid-lad
	if [ $sst_area = nml ]; then isv1=1;iev1=360;jsv1=112;jev1=150; fi #tropical and N. mid-lad
	if [ $sst_area = tp_p ]; then isv1=119;iev1=291;jsv1=70;jev1=111; fi #tropical Pacific

	if [ $tpz_area = conus ]; then isv2=230;iev2=300;jsv2=115;jev2=140; fi #conus
	if [ $tpz_area = nhml ]; then isv2=1;iev2=360;jsv2=115;jev2=160; fi #nhml

for var2 in prec; do  # prec,t2m,hgt
#for nmod in 1 3 5 7 9 11 13 15; do
for nmod in 15; do
#for tgtss in djf mam jja son; do
for tgtss in djf; do
for ilead in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
#for ilead in 17 18 19 20; do
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
cp $lcdir/rpc_svd_sst2tpz_mlead.f $tmp/svd.f

cp $lcdir/svd.s.f $tmp/svd.s.f
cp $lcdir/reof.s.f $tmp/reof.s.f
cd $tmp
#
cat > parm.h << eof
       parameter(nyr=$nyr,nmon=$nmon,del=$del)
       parameter(itgt=$itgt,ilead=$ilead)
       parameter(nfys=$nfyr_start)
       parameter(imx=360,jmx=180)
       parameter(mv1=$mv1,mv2=$mv2,msvd=$msvd)
       parameter(ng1=$ngrdv1,ng2=$ngrdv2)
       parameter(isv1=$isv1,iev1=$iev1,jsv1=$jsv1,jev1=$jev1)
       parameter(isv2=$isv2,iev2=$iev2,jsv2=$jsv2,jev2=$jev2)
       parameter(id=$id)
       parameter(undef=$undef)
eof
#
infile1=$var1.3mon.1948-curr.total.1x1
infile2=$var2.1948_cur.3mon.total.1x1
outfile=${var1}_2_$var2.ld$ilead.nmod$nmod.$tgtss.sst_${sst_area}.tpz_${tpz_area}
outfile1=svd_prd.$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_${sst_area}.tpz_${tpz_area}
outfile2=skill.svd_vs_obs.$var2.$tgtss.ld$ilead.95-22.nmod$nmod.${var1}_${sst_area}.tpz_${tpz_area}
#
\rm $tmp/fort.*
#
gfortran -o svd.x svd.s.f reof.s.f svd.f
echo "done compiling"
#
ln -s $datain1/$infile1.gr            fort.10
ln -s $datain2/$infile2.gr            fort.11

ln -s $datadir/rpc.$outfile.gr         fort.20
ln -s $datadir/reof.$outfile.gr        fort.21
#
ln -s $datadir/$outfile1.gr           fort.31
ln -s $datadir/$outfile2.gr           fort.32
#
./svd.x > $datadir/out_svd.$outfile
#
cat>$datadir/rpc.$outfile.ctl<<EOF
dset $datadir/rpc.$outfile.gr
undef $undef
title Realtime Surface Obs
xdef  1 linear   0.5 1.
ydef  1 linear -89.5 1.
zdef  1 levels 1
tdef 75 linear jan1948 1yr
edef $nmod names 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
vars  2
cf1   0 99 sst
cf2   0 99 tpz
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
vars  4
c1  0 99 corr
r1  0 99 regr
c2  0 99 corr
r2  0 99 regr
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
done # loop ilead
done # loop nmod
done # loop var2
done # loop eof_range
done # loop var1
