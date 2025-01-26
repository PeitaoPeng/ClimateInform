set -euax
#
#
lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
cd $tmp
#
datadir=/cpc/consistency/id/ca_hcst/seasonal
nlead=14

ltime=`expr $nlead + 11`

cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nld=$nlead)
eof

\rm fort.*
cp $lcdir/skill_4_plot.n34.tgtss.f skill.f
 gfortran -o skill.x skill.f

 ln -s $datadir/skill.cahcst.esm.nino34.icss_vs_lead.gr  fort.10
 ln -s $datadir/skill.cahcst.esm.nino34.tgtss_vs_lead.gr fort.40

 skill.x 
#
cat>$datadir/skill.cahcst.esm.nino34.tgtss_vs_lead.ctl<<EOF2
dset ^skill.cahcst.esm.nino34.tgtss_vs_lead.gr
undef -9.99E+8
XDEF  1 LINEAR    0.  2.5
YDEF  1 LINEAR  -90.  2.5
zdef  1 linear 1 1
tdef $nlead linear jan1980 1mon
edef 12 names 1 2 3 4 5 6 7 8 9 10 11 12
vars 2
ac  1 99 ac skill
rms 1 99 rms skill
endvars
#
EOF2

