t!/bin/sh

set -eaux

#=========================================================
# ANN crrection for model forecasted NINO3.4 
# update every month
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/opr
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/nn/obs
datadir2=/cpc/consistency/nn/cfsv2_ww
#
cd $tmp
cp /cpc/home/wd52pp/project/nn/cfsv2/mlr/mlr.grdsst_2_n34.f mlr.f
#
#curmo=`date --date='today' '+%m'`  # mo of making fcst
for curmo in 11; do
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#curyr=20`date --date='today' '+%y'`  # current_yr=20"xx"
curyr=2020
#model=NMME
model=CFSv2
clim=2c
vname=SSHem

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr
clmperiod=1991-2020

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
#for var in sst tmp2m prate; do
 for var in $vname; do
#
clim=2c
nleadmon=9
nleadss=7
imx=144
jmx=73
#defining resolution in MLR
idel=4
jdel=2
#give ngrd, which is from input.f
ngrd=145 # 134 for NMME; 145 for CFSv2
nfld=`expr $ngrd + 1` # +1 for putting obs nino34
#
ridge=0.05
del_ridge=0.05
#ridge=0.01
#del_ridge=0.01
#
# have input data to ANN package =======================================
#
imon=$curmo
if [ $imon = 01 ]; then icmonw=jan; tmons=feb; fi
if [ $imon = 02 ]; then icmonw=feb; tmons=mar; fi
if [ $imon = 03 ]; then icmonw=mar; tmons=apr; fi
if [ $imon = 04 ]; then icmonw=apr; tmons=may; fi
if [ $imon = 05 ]; then icmonw=may; tmons=jun; fi
if [ $imon = 06 ]; then icmonw=jun; tmons=jul; fi
if [ $imon = 07 ]; then icmonw=jul; tmons=aug; fi
if [ $imon = 08 ]; then icmonw=aug; tmons=sep; fi
if [ $imon = 09 ]; then icmonw=sep; tmons=oct; fi
if [ $imon = 10 ]; then icmonw=oct; tmons=nov; fi
if [ $imon = 11 ]; then icmonw=nov; tmons=dec; fi
if [ $imon = 12 ]; then icmonw=dec; tmons=jan; fi
#
#for tp in mon ss; do
for tp in ss; do

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

ld=1
while  [ $ld -le $nlead ]
do
 
nfld=`expr $ngrd + 1`
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=134
c      parameter(is=49,ie=65,js=37,je=45) !120-160; 0N-20N ngrd=23
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(ridge=$ridge,del=$del_ridge)
eof
#
\rm fort.*

cp $lcdir/mlr.grdsst_2_n34.f mlr.f

gfortran -o mlr.x mlr.f

 ln -s $datadir2/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.gr fort.10
 ln -s $datadir3/nino34.oi.1982-2020.djf.gr fort.20
 ln -s $datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.gr fort.30
 test_data.x
#
#cat>$datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.ctl<<EOF3
#dset ^mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.gr
#undef -9.99E+8
#title EXP1
#XDEF 1 LINEAR 0  1.0
#YDEF 1 LINEAR    -90  1.0
#zdef 1 linear 1 1
#tdef $ltime linear jan1983 1yr
#vars 2
#o 0 99 obs nino34
#p 0 99 corrected nmme fcst
#endvars
##
#EOF3
#done
# #
#  gfortran -o test_data.x test_data.f
#   ln -s $datadir2/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.gr fort.10
#    ln -s $datadir3/nino34.oi.1982-2020.djf.gr fort.20
#     ln -s $datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.gr fort.30
#      test_data.x
#      #
#      cat>$datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.ctl<<EOF3
#      dset ^mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.gr
#      undef -9.99E+8
#      title EXP1
#      XDEF 1 LINEAR 0  1.0
#      YDEF 1 LINEAR    -90  1.0
#      zdef 1 linear 1 1
#      tdef $ltime linear jan1983 1yr
#      vars 2
#      o 0 99 obs nino34
#      p 0 99 corrected nmme fcst
#      endvars
#      #
#      EOF3
#      done
#

##=====================================
## use field data to correct nino34 hcst
##=====================================
#
#excute program
mlp.x > $tmp/out
#
cat>mlr.ld$ld.ctl<<EOF
dset ^mlr.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nyr} linear jan1982 1yr
vars  1
p  0 99 prd
endvars
#
EOF
#
# calculate nino34 of model fcst
#
cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
*'open $datadir2/$model.$var.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.ctl'
'open $datadir2/$model.SSTem.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.ctl'
'set gxout fwrite'
'set fwrite model.n34.ld$ld.gr'
'set x 72'
'set y 37'
it=1
while ( it <= $nyr)
'set t 'it''
'set z '$ld''
'd aave(f,lon=190,lon=240,lat=-5,lat=5))'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>model.n34.ld$ld.ctl<<EOF
dset ^model.n34.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
f 1 99 model fcst
ENDVARS
EOF
#
# calculate nino34 of OBS
#
cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
'open $datadir1/obs.sst.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.anom.ctl'
'set gxout fwrite'
'set fwrite obs.n34.ld$ld.gr'
'set x 72'
'set y 37'
it=1
while ( it <= $nyr)
'set t 'it''
'set z '$ld''
'd aave(o,lon=190,lon=240,lat=-5,lat=5))'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>obs.n34.ld$ld.ctl<<EOF
dset ^obs.n34.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
o 1 99 model fcst
ENDVARS
EOF
#
# calculate nino34 of OBS
#
cat >have_skill<<EOF
run skill.gs
EOF
cat >skill.gs<<EOF
'reinit'
'open obs.n34.ld$ld.ctl'
'open model.n34.ld$ld.ctl'
'open mlp.ld$ld.ctl'
'set gxout fwrite'
'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t=1,t=$nyr))'
'define mm=sqrt(ave(f.2*f.2,t=1,t=$nyr))'
'define pp=sqrt(ave(p.3*p.3,t=1,t=$nyr))'
'define om=ave(o*f.2,t=1,t=$nyr)/(oo*mm)'
'define op=ave(o*p.3,t=1,t=$nyr)/(oo*pp)'
'define rmsom=sqrt(ave((o-f.2)*(o-f.2),t=1,t=$nyr))'
'define rmsop=sqrt(ave((o-p.3)*(o-p.3),t=1,t=$nyr))'
'd om'
'd rmsom'
'd op'
'd rmsop'
EOF
#
/usr/local/bin/grads -bl <have_skill
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

mv skill.1 acrms.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat acrms.$ldm  skill.$ld > acrms.$ld

\rm acrms.$ldm

ld=$(( ld+1 ))
done  # for ld
#

mv acrms.$nlead $datadir2/skill.MLR.${var}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.$clim.gr

cat>$datadir2/skill.MLR.${var}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.$clim.ctl<<EOF
dset ^skill.MLR.${var}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.$clim.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 4
acm  1 99 ac of model
rmsm 1 99 rms of model
aca  1 99 ac of ann
rmsa 1 99 rms of ann
ENDVARS
EOF

done  # for tp
#
done  # for var
done  # for curmo
