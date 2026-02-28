set -euax
#
ltime=38
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/skill_4_plot.n34only.f skill.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nld=$nlead)
eof

\rm fort.*
 gfortran -o skill.x skill.f
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.10

 ln -s $datadir/NMME.nino34.may_ic.1982-2019.djf.gr fort.11
 ln -s $datadir/NMME.nino34.jun_ic.1982-2019.djf.gr fort.12
 ln -s $datadir/NMME.nino34.jul_ic.1982-2019.djf.gr fort.13
 ln -s $datadir/NMME.nino34.aug_ic.1982-2019.djf.gr fort.14
 ln -s $datadir/NMME.nino34.sep_ic.1982-2019.djf.gr fort.15
 ln -s $datadir/NMME.nino34.oct_ic.1982-2019.djf.gr fort.16
 ln -s $datadir/NMME.nino34.nov_ic.1982-2019.djf.gr fort.17

 ln -s $datadir/mlp.djf.n34.may_ic.bi fort.21
 ln -s $datadir/mlp.djf.n34.jun_ic.bi fort.22
 ln -s $datadir/mlp.djf.n34.jul_ic.bi fort.23
 ln -s $datadir/mlp.djf.n34.aug_ic.bi fort.24
 ln -s $datadir/mlp.djf.n34.sep_ic.bi fort.25
 ln -s $datadir/mlp.djf.n34.oct_ic.bi fort.26
 ln -s $datadir/mlp.djf.n34.nov_ic.bi fort.27

 ln -s $datadir/mlr.djf.n34.may_ic.bi fort.31
 ln -s $datadir/mlr.djf.n34.jun_ic.bi fort.32
 ln -s $datadir/mlr.djf.n34.jul_ic.bi fort.33
 ln -s $datadir/mlr.djf.n34.aug_ic.bi fort.34
 ln -s $datadir/mlr.djf.n34.sep_ic.bi fort.35
 ln -s $datadir/mlr.djf.n34.oct_ic.bi fort.36
 ln -s $datadir/mlr.djf.n34.nov_ic.bi fort.37

 ln -s $datadir/skill.vs.lead.n34_only.djf.gr fort.40
 skill.x 
#
cat>$datadir/skill.vs.lead.n34_only.djf.ctl<<EOF2
dset ^skill.vs.lead.n34_only.djf.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR  0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $nlead linear jan1983 1yr
vars 6
acm  0 99 ac of model
acn  0 99 ac of nn
acr  0 99 ac of mlr
rmsm  0 99 rms of model
rmsn  0 99 rms of nn
rmsr  0 99 rms of mlr
endvars
#
EOF2
   

