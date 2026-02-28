set -euax
#
#
lcdir=/cpc/home/wd52pp/project/nn/opr/analyses
tmp=/cpc/home/wd52pp/tmp
cd $tmp
#
#tool=ann
tool=mlr
eof_type=eeof
varn=3V
var=SSTem_sst_d20
#var=SSTem_casst_d20_sst
nmod=5
datadir=/cpc/consistency/nn/cfsv2_ww
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
cp $lcdir/skill_4_plot.n34.tgtss.f skill.f
 gfortran -o skill.x skill.f

 ln -s $datadir/skill.$tool.$varn.${var}_2_nino34.ld1-$nlead.nmod$nmod.$eof_type.gr fort.10
 ln -s $datadir/skill.$tool.tgtss.$varn.${var}_2_nino34.ld1-$nlead.nmod$nmod.$eof_type.gr fort.40

 skill.x 
#
cat>$datadir/skill.$tool.tgtss.$varn.${var}_2_nino34.ld1-$nlead.nmod$nmod.$eof_type.ctl<<EOF2
dset ^skill.$tool.tgtss.$varn.${var}_2_nino34.ld1-$nlead.nmod$nmod.$eof_type.gr
undef -9.99E+8
XDEF  1 LINEAR    0.  2.5
YDEF  1 LINEAR  -90.  2.5
zdef  1 linear 1 1
tdef $nlead linear jan1980 1mon
edef 12 names 1 2 3 4 5 6 7 8 9 10 11 12
vars 4
acm  1 99 ac of model
rmsm 1 99 rms of model
acn  1 99 ac of $tool
rmsn 1 99 ac of $tool
endvars
#
EOF2
   
done

