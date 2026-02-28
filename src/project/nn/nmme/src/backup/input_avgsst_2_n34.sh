set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=38
icmon=may
narea=12 # number of areas to be averaged
ngrd=12 # number of areas to be used
nfld=`expr $ngrd + 1`
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir2=/cpc/consistency/nn/nmme
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_avgsst_2_n34.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is1=49,ie1=52,js1=41,je1=45) !120-150, 0-20N
       parameter(is2=49,ie2=52,js2=37,je2=40) !120-150, 20S-0
       parameter(is3=53,ie3=56,js3=41,je3=45) !150-180, 0-20N
       parameter(is4=53,ie4=56,js4=37,je4=40) !150-180, 20S-0
       parameter(is5=57,ie5=60,js5=41,je5=45) !180-210, 0-20N
       parameter(is6=57,ie6=60,js6=37,je6=40) !180-210, 20S-0
       parameter(is7=61,ie7=64,js7=41,je7=45) !210-240, 0-20N
       parameter(is8=61,ie8=64,js8=37,je8=40) !210-240, 20S-0
       parameter(is9=65,ie9=68,js9=41,je9=45) !240-280, 0-20N
       parameter(is10=65,ie10=68,js10=37,je10=40) !240-280, 20S-0
       parameter(is11=69,ie11=73,js11=41,je11=45) !240-280, 20S-0
       parameter(is12=69,ie12=73,js12=37,je12=40) !240-280, 20S-0
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(narea=$narea)
       parameter(nld=$nlead)
eof
#
#\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datadir2/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.20
 ln -s $datadir/input_avgsst.${icmon}_ic.1982-2019.djf.gr fort.30
 test_data.x 
#
cat>$datadir/input_avgsst.${icmon}_ic.1982-2019.djf.ctl<<EOF3
dset ^input_avgsst.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF $nfld LINEAR 1  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF3
   

