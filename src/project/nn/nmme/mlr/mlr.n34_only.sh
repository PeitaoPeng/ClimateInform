set -euax
########################################################
# have grid SST input 
###############################################
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/mlr
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/mlr.n34_only.f test_data.f
#
ltime=38
for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do

ngrd=1 
#
#ridge=0.01
ridge=0.0
del_ridge=0.05
#
nfld=`expr $ngrd + 1`
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(ridge=$ridge,del=$del_ridge)
eof
#
\rm fort.*
#
 gfortran -o test_data.x test_data.f
icmonyr=jan1983
#
 gfortran -o test_data.x test_data.f
 ln -s $datadir/NMME.nino34.${icmon}_ic.1982-2019.djf.gr fort.10
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.20
 ln -s $datadir/mlr.djf.n34.${icmon}_ic.bi fort.30
 test_data.x 
#
cat>$datadir/mlr.djf.n34.${icmon}_ic.ctl<<EOF3
dset ^mlr.djf.n34.${icmon}_ic.gr
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
