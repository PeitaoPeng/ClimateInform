set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=38
icmon=may
imx=144
jmx=73
nmodo=13 # obs modes kept
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src/fld
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/output_fld_CV.eof.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=$imx,jmx=$jmx)
       parameter(nmodo=$nmodo)
eof
#
 gfortran -o test_data.x test_data.f

for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do
#
rm fort.*
#
 ln -s $datadir/mlp.sst_coef.${icmon}_ic.bi fort.11
 ln -s $datadir/eof.sst.obs.1982-2019.djf.gr fort.12
 ln -s $datadir/mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi fort.13
#
 test_data.x 
#
cat>$datadir/mlp.sst_eof.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^mlp.sst_eof.${icmon}_ic.1982-2019.djf.bi
undef -9.99E+08
title EXP1
XDEF  144 LINEAR    0  2.5
YDEF   73 LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  $ltime linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
done
