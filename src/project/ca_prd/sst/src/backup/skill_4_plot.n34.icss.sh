set -euax
#
#
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
cd $tmp
#
datadir=/cpc/consistency/id/ca_hcst/seasonal
nlead=17
nldout=`expr $nlead - 3`

ltime=`expr $nldout + 11`

cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nld=$nlead)
       parameter(nldo=$nldout)
eof

\rm fort.*
cp $lcdir/skill_4_plot.n34.icss.f skill.f
 gfortran -o skill.x skill.f

 ln -s $datadir/skill.cahcst.nino34.ond_ic.esm.gr fort.11
 ln -s $datadir/skill.cahcst.nino34.ndj_ic.esm.gr fort.12
 ln -s $datadir/skill.cahcst.nino34.djf_ic.esm.gr fort.13
 ln -s $datadir/skill.cahcst.nino34.jfm_ic.esm.gr fort.14
 ln -s $datadir/skill.cahcst.nino34.fma_ic.esm.gr fort.15
 ln -s $datadir/skill.cahcst.nino34.mam_ic.esm.gr fort.16
 ln -s $datadir/skill.cahcst.nino34.amj_ic.esm.gr fort.17
 ln -s $datadir/skill.cahcst.nino34.mjj_ic.esm.gr fort.18
 ln -s $datadir/skill.cahcst.nino34.jja_ic.esm.gr fort.19
 ln -s $datadir/skill.cahcst.nino34.jas_ic.esm.gr fort.20
 ln -s $datadir/skill.cahcst.nino34.aso_ic.esm.gr fort.21
 ln -s $datadir/skill.cahcst.nino34.son_ic.esm.gr fort.22

 ln -s $datadir/skill.cahcst.esm.nino34.icss_vs_lead.gr fort.40

 skill.x 
#
cat>$datadir/skill.cahcst.esm.nino34.icss_vs_lead.ctl<<EOF2
dset ^skill.cahcst.esm.nino34.icss_vs_lead.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR  0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear oct1981 1mon
edef 12 names 01 02 03 04 05 06 07 08 09 10 11 12 
vars 2
ac  1 99 ac of nn
rms 1 99 ac of nn
endvars
#
EOF2

