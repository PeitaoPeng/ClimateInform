set -euax
########################################################
# MLR correction with input from input_grdsst_2_n34.eof.djf.sh 
###############################################
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/mlr
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/mlr.grdsst_2_n34.eof.f test_data.f
#
clim=2c
ltime=38
for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do

area=whole
nmod=11
#area=nwp
#
ridge=0.05
del_ridge=0.05
#ridge=0.01
#del_ridge=0.01
#ridge=0.1
#del_ridge=0.1
#
nfld=`expr $nmod + 1`
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(ngrd=$nmod,nfld=$nfld)
       parameter(ridge=$ridge,del=$del_ridge)
eof
#
\rm fort.*
#
 gfortran -o test_data.x test_data.f
icmonyr=jan1983
#
 gfortran -o test_data.x test_data.f
#
 ln -s $datadir/input_sst.${icmon}_ic.1982-2020.djf.$clim.gr fort.10
 ln -s $datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.gr fort.20
 test_data.x 
#
cat>$datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.ctl<<EOF3
dset ^mlr.grdsst_2_n34.${icmon}_ic.1982-2020.djf.$area.$clim.gr
undef -9.99E+8
title EXP1
XDEF 1 LINEAR 0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 2
o 0 99 obs nino34
p 0 99 corrected nmme fcst
endvars
#
EOF3
done
