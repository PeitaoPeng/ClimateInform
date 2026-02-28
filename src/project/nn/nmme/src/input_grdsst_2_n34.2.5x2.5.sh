set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=38
nlead=7
for icmon in may jun jul aug sep oct nov; do
if [ $icmon = may ]; then ld=7; fi
if [ $icmon = jun ]; then ld=6; fi
if [ $icmon = jul ]; then ld=5; fi
if [ $icmon = aug ]; then ld=4; fi
if [ $icmon = sep ]; then ld=3; fi
if [ $icmon = oct ]; then ld=2; fi
if [ $icmon = nov ]; then ld=1; fi
#icmon=may
#ld=7

#defining resolution
idel=2
jdel=1

#give ngrd
#ngrd=56
ngrd=72

nfld=`expr $ngrd + 1`
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir2=/cpc/consistency/nn/nmme
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_grdsst_2_n34.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
c      parameter(is=49,ie=121,js=29,je=45) !120 -300 ngrd=
c      parameter(is=49,ie=65,js=29,je=45) !120-160; 20S-20N ngrd=
       parameter(is=49,ie=65,js=37,je=45) !120-160; 0N-20N ngrd=72
c      parameter(is=49,ie=65,js=39,je=45) !120-160; 5N-20N ngrd=56
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(idel=$idel,jdel=$jdel)
eof
#
\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datadir2/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.20
 ln -s $datadir/input_sst.${icmon}_ic.1982-2019.djf.gr fort.30
 test_data.x 
#
cat>$datadir/input_sst.${icmon}_ic.1982-2019.djf.ctl<<EOF3
dset ^input_sst.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF $nfld LINEAR 1  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF
endvars
#
EOF3
   
done

