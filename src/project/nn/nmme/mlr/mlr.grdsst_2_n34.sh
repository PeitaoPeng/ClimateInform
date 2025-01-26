set -euax
########################################################
# have grid SST input 
###############################################
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/mlr
datadir2=/cpc/consistency/nn/nmme
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/mlr.grdsst_2_n34.f test_data.f
#
ltime=38
 for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do

nlead=7
area=whole
#area=nwp
#defining resolution in MLR
idel=4
jdel=2
ngrd=145
#ngrd=22
#
ridge=0.01
#ridge=0.05
del_ridge=0.05
#
#
if [ $icmon = 'may' ]; then ld=7; fi
if [ $icmon = 'jun' ]; then ld=6; fi
if [ $icmon = 'jul' ]; then ld=5; fi
if [ $icmon = 'aug' ]; then ld=4; fi
if [ $icmon = 'sep' ]; then ld=3; fi
if [ $icmon = 'oct' ]; then ld=2; fi
if [ $icmon = 'nov' ]; then ld=1; fi
#
nfld=`expr $ngrd + 1`
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=134
c      parameter(is=49,ie=65,js=37,je=45) !120-160; 0N-20N ngrd=22
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(idel=$idel,jdel=$jdel)
       parameter(ridge=$ridge,del=$del_ridge)
eof
#
\rm fort.*
#
 gfortran -o test_data.x test_data.f
icmonyr=jan1983
#
 gfortran -o test_data.x test_data.f
 ln -s $datadir2/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.20
 ln -s $datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2019.djf.$area.gr fort.30
 test_data.x 
#
cat>$datadir/mlr.grdsst_2_n34.${icmon}_ic.1982-2019.djf.$area.ctl<<EOF3
dset ^mlr.grdsst_2_n34.${icmon}_ic.1982-2019.djf.$area.gr
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
