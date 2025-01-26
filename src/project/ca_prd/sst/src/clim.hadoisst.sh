#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir0=/cpc/analysis/verif/ocean/sst/oi/ctl
datadir=/cpc/home/wd52pp/data/ca_prd
#
#
cd $tmp
#
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
outsst2=oisst.nov1981-2021
times=nov1981
timee=mar2021
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
'd maskout(273.16+sst,mask.2(time=jan1982)-1)'
'c'
EOF
#
#
#===========================================
# excute grads data process
#===========================================
grads -l <oisst
#
outfile=sst.hadoi.tot
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
sst  0 99     ave
ENDVARS
EOF
#
#=======================================
# have monthly clim 
#=======================================
outfile2=hadoisst.mon.1948-curr
#
cat >clim<<EOF
run haveclim.gs
EOF
#
cat >haveclim.gs<<EOF
'reinit'
'open $outfile.ctl'
'set gxout fwrite'
'set fwrite $outfile2.gr'
'set x 1 360'
'set y 1 180'
'set t 1 12'
*'define sstc=ave(sst,t+516,t=876,1yr)'
'define sstc=ave(sst,t+396,t=756,1yr)'
'modify sstc seasonal'
'set t 1 50'
'd sstc'
'c'
EOF
#
grads -l <clim
#
cat>$outfile2.ctl<<EOF
dset ^$outfile2.gr
*options little_endian
undef -999000000
TITLE  Nr. of Valid Months
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 1200 linear jan1948 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
#
#=======================================
# have monthly and 3-mon
#=======================================
outfile3=clim.hadoisst.3mon.1x1
outfile4=clim.hadoisst.mon.1x1
ts=2
te=49
#
cat >climout<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open $outfile2.ctl'
'set x 1 360'
'set y 1 180'
'set gxout fwrite'
'set fwrite $outfile3.gr'
'set t '$ts' '$te''
'd ave(sst-273.16,t-1,t+1)'
'c'
'disable fwrite'
'set gxout fwrite'
'set fwrite $outfile4.gr'
'set t '$ts' '$te''
'd sst-273.16'
'c'
EOF
#
grads -l <climout
#
cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
*options little_endian
undef -999000000
TITLE  3mon avg
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 999 linear feb1981 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
cat>$outfile4.ctl<<EOF
dset ^$outfile4.gr
*options little_endian
undef -999000000
TITLE  3mon avg
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
ZDEF 1 LEVELS 1
tdef 999 linear feb1981 1mo
VARS 1
sst  0 99     anom
ENDVARS
EOF
#
mv $outfile3* $datadir
mv $outfile4* $datadir
