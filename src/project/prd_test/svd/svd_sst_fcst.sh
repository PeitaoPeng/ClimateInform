#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/attr/djf15-16
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/attr/djf15-16
#
var1=z200
var2=hadoisst
#
mtx=cor #cor or var
tmax=67 #R1=63, amip=61, cmip=100
nmod=5 
type=raw # input-data type for svd: rsd or raw
hs1=np   #hemisphere
hs2=tp   #hemisphere
#
cp $lcdir/rsd_svd.z200_sst.f $tmp/svd.f
cp $lcdir/svd.s.f  $tmp/.
cd $tmp
#
if [ "$mtx" = cor ]; then id=1; fi
if [ "$mtx" = var ]; then id=0; fi
if [ "$type" = rsd ]; then rsd=1; fi
if [ "$type" = raw ]; then rsd=0; fi
cat > parm.h << eof
       parameter(ltime=$tmax)
       parameter(imx2=180,jmx2=89)
       parameter(imx1=144,jmx1=73)
       parameter(nmod=$nmod)
       parameter(lons1=1,lone1=144,lats1=37,late1=71)! glb
       parameter(lons2=1,lone2=180,lats2=30,late2=60)! tp
       parameter(id=$id,rsd=$rsd)
eof
#
#for season in djf mam jja son; do
for season in djf; do
#
\rm $tmp/fort.*         
#
gfortran -o svd.x svd.s.f svd.f
echo "done compiling"

#
 ln -s $datadir/$var2.$season.49-cur.2x2.gr         fort.12
 ln -s $datadir/$var1.$season.1949-cur.gr         fort.11
#
 ln -s $datadir/nino34.hadoisst.$season.49-cur.gr  fort.21
#
 ln -s $datadir/${type}_svd.hom.$var2.$season.$hs2.$mtx.gr       fort.31
 ln -s $datadir/${type}_svd.het.$var2.$season.$hs2.$mtx.gr       fort.32
#
 ln -s $datadir/${type}_svd.hom.$var1.$season.$hs1.$mtx.gr       fort.41
 ln -s $datadir/${type}_svd.het.$var1.$season.$hs1.$mtx.gr       fort.42
#
 ln -s $datadir/${type}_ts.$var2.$season.$hs2.$mtx.gr        fort.52
 ln -s $datadir/${type}_ts.$var1.$season.$hs1.$mtx.gr        fort.51
#
#svd.x > $datadir/${type}_svd.$season.$mtx.out
svd.x
#
cat>$datadir/${type}_svd.hom.$var1.$season.$hs1.$mtx.ctl<<EOF
dset $datadir/${type}_svd.hom.$var1.$season.$hs1.$mtx.gr
undef -9999.0
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   73 linear -90 2.5
zdef    1 levels 200
tdef 999 linear jan1950  1yr
vars   10
cor1  0 99 corr to svd1
reg1  0 99 regr to svd1
cor2  0 99 corr of svd2
reg2  0 99 regr of svd2
cor3  0 99 corr of mode 1
reg3  0 99 regr of mode 1
cor4  0 99 corr of mode 1
reg4  0 99 regr of mode 1
cor5  0 99 corr of mode 1
reg5  0 99 regr of mode 1
endvars
EOF
#
cat>$datadir/${type}_svd.het.$var1.$season.$hs1.$mtx.ctl<<EOF
dset $datadir/${type}_svd.het.$var1.$season.$hs1.$mtx.gr
undef -9999.0
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   73 linear -90 2.5
zdef    1 levels 200
tdef 999 linear jan1950  1yr
vars   10
cor1  0 99 corr to svd1
reg1  0 99 regr to svd1
cor2  0 99 corr of svd2
reg2  0 99 regr of svd2
cor3  0 99 corr of mode 1
reg3  0 99 regr of mode 1
cor4  0 99 corr of mode 1
reg4  0 99 regr of mode 1
cor5  0 99 corr of mode 1
reg5  0 99 regr of mode 1
endvars
EOF
#
cat>$datadir/${type}_svd.hom.$var2.$season.$hs2.$mtx.ctl<<EOF
dset $datadir/${type}_svd.hom.$var2.$season.$hs2.$mtx.gr
undef -9999.0
title Realtime Surface Obs
XDEF 180 LINEAR    0.  2.0
YDEF  89 LINEAR  -88.  2.0
zdef    1 levels 200
tdef 999 linear jan1950  1yr
vars   10
cor1  0 99 corr to svd1
reg1  0 99 regr to svd1
cor2  0 99 corr of svd2
reg2  0 99 regr of svd2
cor3  0 99 corr of mode 1
reg3  0 99 regr of mode 1
cor4  0 99 corr of mode 1
reg4  0 99 regr of mode 1
cor5  0 99 corr of mode 1
reg5  0 99 regr of mode 1
endvars
EOF
#
cat>$datadir/${type}_svd.het.$var2.$season.$hs2.$mtx.ctl<<EOF
dset $datadir/${type}_svd.het.$var2.$season.$hs2.$mtx.gr
undef -9999.0
title Realtime Surface Obs
XDEF 180 LINEAR    0.  2.0
YDEF  89 LINEAR  -88.  2.0
zdef    1 levels 200
tdef 999 linear jan1950  1yr
vars   10
cor1  0 99 corr to svd1
reg1  0 99 regr to svd1
cor2  0 99 corr of svd2
reg2  0 99 regr of svd2
cor3  0 99 corr of mode 1
reg3  0 99 regr of mode 1
cor4  0 99 corr of mode 1
reg4  0 99 regr of mode 1
cor5  0 99 corr of mode 1
reg5  0 99 regr of mode 1
endvars
EOF
#
cat>$datadir/${type}_ts.$var2.$season.$hs2.$mtx.ctl<<EOF
dset $datadir/${type}_ts.$var2.$season.$hs2.$mtx.gr
undef -9999.0
title Realtime Surface Obs
xdef    1 linear 0 2.8125
ydef    1 linear -90 2.8125
zdef    1 levels 200
tdef 999 linear jan1950  1yr
vars   5
cf1   0 99 CP1
cf2   0 99 PC2
cf3   0 99 PC3
cf4   0 99 PC4
cf5   0 99 PC5
endvars
EOF
#
cat>$datadir/${type}_ts.$var1.$season.$hs1.$mtx.ctl<<EOF2
dset $datadir/${type}_ts.$var1.$season.$hs1.$mtx.gr
undef -9999.0
title Realtime Surface Obs
xdef    1 linear 0 2.8125
ydef    1 linear -90 2.8125
zdef    1 levels 200
tdef 999 linear jan1950  1yr
vars  5
cf1   0 99 PC1
cf2   0 99 PC2
cf3   0 99 PC3
cf4   0 99 PC4
cf5   0 99 PC5
endvars
EOF2
#
done

