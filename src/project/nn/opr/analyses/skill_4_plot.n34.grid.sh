set -euax
#
#
lcdir=/cpc/home/wd52pp/project/nn/opr/analyses
tmp=/cpc/home/wd52pp/tmp
cd $tmp
#
clim=2c
var=SSTem
#model=nmme
model=cfsv2_ww
datadir=/cpc/consistency/nn/$model
nleadss=7
nleadmon=9

for tp in ss; do

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

ltime=`expr $nlead + 11`

cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nld=$nlead)
eof

\rm fort.*
cp $lcdir/skill_4_plot.n34.f skill.f
 gfortran -o skill.x skill.f

 ln -s $datadir/skill.${var}_2_nino34.$tp.dec_ic.1982-2019.ld1-$nlead.$clim.gr fort.11
 ln -s $datadir/skill.${var}_2_nino34.$tp.jan_ic.1982-2019.ld1-$nlead.$clim.gr fort.12
 ln -s $datadir/skill.${var}_2_nino34.$tp.feb_ic.1982-2019.ld1-$nlead.$clim.gr fort.13
 ln -s $datadir/skill.${var}_2_nino34.$tp.mar_ic.1982-2019.ld1-$nlead.$clim.gr fort.14
 ln -s $datadir/skill.${var}_2_nino34.$tp.apr_ic.1982-2019.ld1-$nlead.$clim.gr fort.15
 ln -s $datadir/skill.${var}_2_nino34.$tp.may_ic.1982-2019.ld1-$nlead.$clim.gr fort.16
 ln -s $datadir/skill.${var}_2_nino34.$tp.jun_ic.1982-2019.ld1-$nlead.$clim.gr fort.17
 ln -s $datadir/skill.${var}_2_nino34.$tp.jul_ic.1982-2019.ld1-$nlead.$clim.gr fort.18
 ln -s $datadir/skill.${var}_2_nino34.$tp.aug_ic.1982-2019.ld1-$nlead.$clim.gr fort.19
 ln -s $datadir/skill.${var}_2_nino34.$tp.sep_ic.1982-2019.ld1-$nlead.$clim.gr fort.20
 ln -s $datadir/skill.${var}_2_nino34.$tp.oct_ic.1982-2019.ld1-$nlead.$clim.gr fort.21
 ln -s $datadir/skill.${var}_2_nino34.$tp.nov_ic.1982-2019.ld1-$nlead.$clim.gr fort.22

 ln -s $datadir/skill.${var}_2_nino34.ld1-$nlead.$clim.gr fort.40

 skill.x 
#
cat>$datadir/skill.${var}_2_nino34.ld1-$nlead.$clim.ctl<<EOF2
dset ^skill.${var}_2_nino34.ld1-$nlead.$clim.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR  0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear Jun1983 1mon
edef 12 names 01 02 03 04 05 06 07 08 09 10 11 12 
vars 4
acm  1 99 ac of model
rmsm 1 99 ac of model
acn  1 99 ac of nn
rmsa 1 99 ac of nn
endvars
#
EOF2
   
done

