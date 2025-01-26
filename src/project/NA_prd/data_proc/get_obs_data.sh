#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/NA_prd/data_proc
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/consistency/NA_prd/obs
#
cd $tmp
#
#======================================
#curyr=`date --date='today' '+%Y'`  # yr of making fcst
#curmo=`date --date='today' '+%m'`  # mo of making fcst
#
curyr=2022
curmo=01 

yyyy=$curyr
yyym=`expr $curyr - 1`
#
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
mmn=`expr $yrn \* 12`
#
tmax=`expr $mmn + $curmo - 1` # if after the 6th day of curmon
#
#======================================
# define some parameters
#======================================
#
for var in prec t2m hgt; do
#
clm_bgn=516  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=13  # jan1949
nte=`expr $tmax` # latest mon
outfile=$var.1949_cur.mon
imax=720
jmax=360
#=======================================
# rewrite t2m data from grib to grads
#=======================================
cat >havedata<<EOF
run data_rewrite.gs
EOF
#
if [ $var = 't2m' ]; then
cat >data_rewrite.gs<<EOF
    'reinit'
*'open /cpc/home/ebecker/ghcn_cams/ghcn_cams_0.5_grb.ctl'
'open /cpc/home/wd51yf/glb_lb/t2m/ghcn_cams_grid_1948_cur.ctl'
'set x 1 $imax'
'set y 1 $jmax'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(t,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(TMP2m,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd t-clm'
'c'
EOF
fi
#
#=======================================
# rewrite prec data
#=======================================
undef_data=-9.99E+8
#
if [ $var = 'prec' ]; then
cat >data_rewrite.gs<<EOF3
    'reinit'
'open /cpc/data/cpcsat/cpcPRECmonthlyRT/land/grid05m/bin_little/precl_mon_v1.0.ctl'
'set x 1 $imax'
'set y 1 $jmax'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(rain,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(rain,t+0, t=$tmax,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd (rain-clm)*0.1'
'c'
EOF3
fi
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
ydef 360 linear -89.750000 0.5
xdef 720 linear 0.250000 0.500000
tdef 9999 linear jan1949 1mo
zdef  01 levels 1
vars 1
$var  0 99 obs
ENDVARS
EOF
#=======================================
# rewrite hgt
#=======================================
if [ $var = 'hgt' ]; then
tmaxz=`expr $tmax - 12` # from jan1949
clm_bgn=504  #dec1990
clm_end=`expr $clm_bgn + 360`
nts=1  # jan1949
nte=`expr $tmaxz - 1` # mid-mon of the latest season
cat >data_rewrite.gs<<EOF3
    'reinit'
'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
'set x 1 144'
'set y 1  73'
'set z 10'
'set t 1 12'
*anom wrt wmo clim 1991-2020
'define clm=ave(HGT,t+$clm_bgn, t=$clm_end,1yr)'
*anom wrt clim from 1948 to curr
*'define clm=ave(HGT,t+0, t=$tmaxz,1yr)'
'modify clm seasonal'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set t $nts $nte'
'd HGT-clm'
'c'
EOF3
cat>$outfile.ctl<<EOF
dset $outfile.gr
undef $undef_data
xdef 144 linear 0 2.5
ydef  73 linear -90 2.5
tdef 9999 linear jan1949 1mo
zdef  01 levels 1
vars 1
$var  0 99 regression
ENDVARS
EOF
fi
#
/usr/local/bin/grads -bl <havedata
#
#=======================================
# regrid to 1x1
#=======================================
ntend=`expr $tmax - 12` # from jan1949 to the latest mon
cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'open /cpc/home/wd52pp/data/obs/sst/grid.1x1.ctl'
'set gxout fwrite'
'set fwrite $datadir/$outfile.1x1.gr'
nt=1
while ( nt <= $ntend)

'set t 'nt
say 'time='nt
'set lon   0.5 359.5'
'set lat -89.5  89.5'
'd lterp($var,sst.2(time=jan1950))'

nt=nt+1
endwhile
gsEOF

/usr/local/bin/grads -pb <int

cat>$datadir/$outfile.1x1.ctl<<EOF
dset ^$outfile.1x1.gr
undef -9.99E+8
*
options little_endian
*
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
zdef  01 levels 1 
tdef   9999 linear jan1949 1mo
*
VARS 1
$var 1  99   mon
ENDVARS
EOF
#=======================================
#
done  # for var
