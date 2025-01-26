#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/skill_vfc/auto_corr/src
tmp=/cpc/home/wd52pp/tmp
datadir1=/cpc/home/wd52pp/data/skill_ac
datadir3=/cpc/home/wd52pp/data/skill_ac
#
model=AMIP
ybgn=1981
var=z200
nss=468
nran=10000
nlead=1
#

cp $lcdir/auto_ac.f $tmp/ac.f
cp $lcdir/lag_corr.s.f $tmp/lag.f
cd $tmp
/bin/rm $tmp/fort.*         
#
cat > parm.h << eof
       parameter(nss=$nss,nran=$nran)
       parameter(imx=144,jmx=73)
eof
#
gfortran -o ac.x lag.f ac.f
echo "done compiling"

#
 ln -s $datadir1/z200.3mon.fma1981-jfm2021.amip.gr  fort.11
 ln -s $datadir1/z200.3mon.fma1981-jfm2021.cdas.gr  fort.12

 ln -s $datadir3/$model.skill.cor_t.$var.gr              fort.21
 ln -s $datadir3/$model.skill.cor_s.$var.gr              fort.22
 ln -s $datadir3/$model.skill.cor_s.$var.p1.gr           fort.25
 ln -s $datadir3/$model.cor_s_lag1.$var.gr               fort.23
 ln -s $datadir3/random.ts.gr                     fort.24
#
ac.x
#

cat>$datadir3/$model.skill.cor_t.$var.ctl<<EOF
dset ^$model.skill.cor_t.$var.gr
undef -9.99e+8
*
TITLE fcst
*
xdef  144 linear    0.  2.5
ydef   73 linear  -90   2.5
zdef    1 linear 1 1
tdef  999 linear feb${ybgn} 1mo
vars 4
cor  1 99 prd_vs_obs
plag 1 99 lag1 auto_cor of prd
olag 1 99 lag1 auto_cor of obs
op   1 99 plag*olag
ENDVARS
EOF

cat>$datadir3/$model.skill.cor_s.$var.ctl<<EOF
dset ^$model.skill.cor_s.$var.gr
undef -9.99e+8
*
TITLE fcst
*
xdef  1 linear    0.  2.5
ydef  1 linear  -90   2.5
zdef  1 linear 1 1
tdef  $nss linear feb${ybgn} 1mo
vars 3
glc   1 99 global
tpc   1 99 tropics
etc   1 99 ext_tp
ENDVARS
EOF

cat>$datadir3/$model.skill.cor_s.$var.p1.ctl<<EOF
dset ^$model.skill.cor_s.$var.p1.gr
undef -9.99e+8
*
TITLE fcst
*
xdef  1 linear    0.  2.5
ydef  1 linear  -90   2.5
zdef  1 linear 1 1
tdef  $nss linear feb${ybgn} 1mo
vars 3
glc   1 99 global
tpc   1 99 tropics
etc   1 99 ext_tp
ENDVARS
EOF

cat>$datadir3/$model.cor_s_lag1.$var.ctl<<EOF
dset ^$model.cor_s_lag1.$var.gr
undef -9.99e+8
*
TITLE fcst
*
xdef  1 linear    0.  2.5
ydef  1 linear  -90   2.5
zdef  1 linear 1 1
tdef  $nss linear feb${ybgn} 1mo
vars 6
glp   1 99 prd global
tpp   1 99 prd tropics
etp   1 99 prd ext_tp
glo   1 99 obs global
tpo   1 99 obs tropics
eto   1 99 obs ext_tp
ENDVARS
EOF
#
cat>$datadir3/random.ts.ctl<<EOF
dset ^random.ts.gr
undef -9.99e+8
*
TITLE fcst
*
xdef  1 linear    0.  2.5
ydef  1 linear  -90   2.5
zdef  1 linear 1 1
tdef  500 linear feb${ybgn} 1mo
vars 2
r   1 99 white noise
m   1 99 3-p runing mean
ENDVARS
EOF
