#!/bin/sh

set -eaux

##=====================================
## us field data to correct nino34 hcst (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
area=whole
#area=nwtp
#area=NWTP
 nflds=135 # inputs + outputs
#nflds=50 # inputs + outputs
#nflds=23 # inputs + outputs
#nflds=57  # inputs + outputs for NWTPnoeq for 2.5x5
#nflds=73  # inputs + outputs for NWTP for 2.5x5

neurons=35 # for whole TP, hidden neuron number
#neurons=10 # for NWTP, hidden neuron number
#neurons=20 # for NWTPnoeq for 2.5x5
#neurons=25 # for NWTP for 2.5x5
#
 for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do
#
nt_tot=38 # N(year)
ntrain=37 # N-1 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
lrate=0.1 # learning rate (>0 to 2)
#lrate=0.01 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.CV.f90 mlp.f90
#
cat > parm.h << eof
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nflds)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)
eof
#
gfortran -g -fbacktrace -o mlp.x mlp.f90
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi

ln -s $datadir/input_sst.${icmon}_ic.1982-2019.djf.gr fort.10
ln -s $datadir/prd_train.bi   fort.20
ln -s $datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.$area.bi  fort.30
ln -s $datadir/prd_val.bi     fort.40

#excute program
mlp.x > $datadir/out
#
cat>$datadir/mlp.djf.grdsst_2_n34.${icmon}_ic.$area.ctl<<EOF
dset ^mlp.djf.grdsst_2_n34.${icmon}_ic.$area.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
#
cat>$datadir/prd_train.ctl<<EOF
dset ^prd_train.bi
undef -9.99E+33
title EXP1
XDEF  $ntrain LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
done
