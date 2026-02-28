#!/bin/sh

set -eaux

##=====================================
## correct field fcst with field data (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/consistency/nn/nmme
datadir2=/cpc/consistency/nn/obs
tmp=/cpc/home/wd52pp/tmp/test

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
icmon=may
nlead=7
model=NMME
imx=144
jmx=73
#
#ngrd=1005 # total non-undef grid number in the interested domain
ngrd=134 # total non-undef grid number in the interested domain
nflds=`expr $ngrd + 1`
nt_tot=38 # N(year)
ntrain=37 # N-1 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=30 # hidden neuron number
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
#=======================================
# core part of correcting process 
#=======================================
#
cp $lcdir/mlp_bp.fld.CV.f90 mlp.f90
#
cat > parm.h << eof
      parameter(nt=$nt_tot)
      parameter(imx=$imx,jmx=$jmx)
      parameter(is=49,ie=121,js=29,je=45)
      parameter(ngrd=$ngrd,nfld=$nflds)
      parameter(nld=$nlead)
      parameter(undef=-9.99e+8)
!
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nflds)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)
eof
#
gfortran -g -fbacktrace -o mlp.x mlp.f90

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $datadir/$model.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.15
ln -s $datadir2/obs.sst.ss.may_ic.1982-cur.ld1-7.anom.gr fort.25
#
ln -s $datadir/input.1_grid.gr fort.10
#
ln -s $datadir/prd_train.1_grd.bi   fort.20
ln -s $datadir/mlp.1_grd.bi   fort.30
ln -s $datadir/prd_val.1_grd.bi   fort.40
#
ln -s $datadir/${model}_sst.${icmon}_ic.1982-2019.djf.bi  fort.50
ln -s $datadir/obs_sst.1982-2019.djf.bi               fort.51
ln -s $datadir/mlp.sst.${icmon}_ic.1982-2019.djf.bi   fort.52

#excute program
mlp.x > $lcdir/out
#
cat>$datadir/mlp.sst.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^mlp.sst.${icmon}_ic.1982-2019.djf.bi
undef -9.99E+08
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
#
cat>$datadir/${model}_sst.${icmon}_ic.1982-2019.djf.ctl<<EOF2
dset ^${model}_sst.${icmon}_ic.1982-2019.djf.bi
undef -9.99E+8
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef 1 linear 1 1
tdef $nt_tot linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF2

cat>$datadir/obs_sst.1982-2019.djf.ctl<<EOF3
dset ^obs_sst.1982-2019.djf.bi
undef -9.99E+8
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef 1 linear 1 1
tdef $nt_tot linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF3
