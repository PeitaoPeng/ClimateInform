set -euax
#
clim=2c #clim type
ltime=38
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src
datadir=/cpc/home/wd52pp/data/nn/cfsv2
datadir2=/cpc/consistency/nn/obs
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/skill_4_plot.jja.f skill.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nld=$nlead)
eof

\rm fort.*
 gfortran -o skill.x skill.f
 ln -s $datadir2/oisst.nino34.1982-cur.jja.gr fort.10

 ln -s $datadir/CFSv2.nino34.nov_ic.1982-2020.jja.$clim.gr fort.11
 ln -s $datadir/CFSv2.nino34.dec_ic.1982-2020.jja.$clim.gr fort.12
 ln -s $datadir/CFSv2.nino34.jan_ic.1982-2020.jja.$clim.gr fort.13
 ln -s $datadir/CFSv2.nino34.feb_ic.1982-2020.jja.$clim.gr fort.14
 ln -s $datadir/CFSv2.nino34.mar_ic.1982-2020.jja.$clim.gr fort.15
 ln -s $datadir/CFSv2.nino34.apr_ic.1982-2020.jja.$clim.gr fort.16
 ln -s $datadir/CFSv2.nino34.may_ic.1982-2020.jja.$clim.gr fort.17

 ln -s $datadir/mlp.jja.grdsst_2_n34.nov_ic.whole.$clim.bi fort.21
 ln -s $datadir/mlp.jja.grdsst_2_n34.dec_ic.whole.$clim.bi fort.22
 ln -s $datadir/mlp.jja.grdsst_2_n34.jan_ic.whole.$clim.bi fort.23
 ln -s $datadir/mlp.jja.grdsst_2_n34.feb_ic.whole.$clim.bi fort.24
 ln -s $datadir/mlp.jja.grdsst_2_n34.mar_ic.whole.$clim.bi fort.25
 ln -s $datadir/mlp.jja.grdsst_2_n34.apr_ic.whole.$clim.bi fort.26
 ln -s $datadir/mlp.jja.grdsst_2_n34.may_ic.whole.$clim.bi fort.27

 ln -s $datadir/mlr.grdsst_2_n34.nov_ic.1982-2020.jja.whole.$clim.gr fort.31
 ln -s $datadir/mlr.grdsst_2_n34.dec_ic.1982-2020.jja.whole.$clim.gr fort.32
 ln -s $datadir/mlr.grdsst_2_n34.jan_ic.1982-2020.jja.whole.$clim.gr fort.33
 ln -s $datadir/mlr.grdsst_2_n34.feb_ic.1982-2020.jja.whole.$clim.gr fort.34
 ln -s $datadir/mlr.grdsst_2_n34.mar_ic.1982-2020.jja.whole.$clim.gr fort.35
 ln -s $datadir/mlr.grdsst_2_n34.apr_ic.1982-2020.jja.whole.$clim.gr fort.36
 ln -s $datadir/mlr.grdsst_2_n34.may_ic.1982-2020.jja.whole.$clim.gr fort.37


 ln -s $datadir/skill.vs.lead.nino34.jja.$clim.gr fort.40
 skill.x 
#
cat>$datadir/skill.vs.lead.nino34.jja.$clim.ctl<<EOF2
dset ^skill.vs.lead.nino34.jja.$clim.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR  0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $nlead linear jan1983 1yr
vars 6
acm  0 99 ac of model
acn  0 99 ac of nn
acr  0 99 ac of nn
rmsm  0 99 rms of model
rmsn  0 99 rms of nn
rmsr  0 99 rms of nn
endvars
#
EOF2
   

