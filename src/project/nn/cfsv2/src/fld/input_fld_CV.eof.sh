set -euax
########################################################
# have grid SST input 
###############################################
#
clim=2c
ltime=38
ngrdm=1061
ngrdo=1073
nmodm=13 # model modes kept
nmodo=13 # obs modes kept

nfldm=`expr $nmodm + 1`
nfldo=`expr $nmodo + 1`
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src/fld
datadir1=/cpc/consistency/nn/cfsv2_ww
datadir2=/cpc/consistency/nn/obs
datadir3=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp
#
for icmon in may jun jul aug sep oct nov; do
#for icmon in may; do
if [ $icmon = may ]; then ld=7; fi
if [ $icmon = jun ]; then ld=6; fi
if [ $icmon = jul ]; then ld=5; fi
if [ $icmon = aug ]; then ld=4; fi
if [ $icmon = sep ]; then ld=3; fi
if [ $icmon = oct ]; then ld=2; fi
if [ $icmon = nov ]; then ld=1; fi

cd $tmp
cp $lcdir/input_fld_CV.eof.f test_data.f
cp $lcdir/reof.s.f reof.s.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120-300; 20S-20N
C      parameter(is=1,ie=144,js=13,je=61) !0-360; 60S-60N
       parameter(ngrdm=$ngrdm,nfldm=$nfldm)
       parameter(ngrdo=$ngrdo,nfldo=$nfldo)
       parameter(nld=$nlead,ld=$ld)
       parameter(nmodm=$nmodm,nmodo=$nmodo,id=0)
eof
#
rm fort.*
 gfortran -o test_data.x reof.s.f test_data.f
 ln -s $datadir1/CFSv2.SSTem.ss.${icmon}_ic.1982-2020.ld1-7.esm.anom.$clim.gr fort.10
 ln -s $datadir2/oisst.1982-cur.djf.anom.gr fort.11
#
 ln -s $datadir3/input_fld_CV.eof.model.${icmon}_ic.gr fort.20
 ln -s $datadir3/input_fld_CV.eof.obs.gr fort.21
#
 ln -s $datadir3/eof.sst.${icmon}_ic.1982-2019.djf.gr fort.30
 ln -s $datadir3/eof.sst.obs.1982-2019.djf.gr fort.31
 ln -s $datadir3/CFSv2.sst.${icmon}_ic.1982-2019.djf.gr fort.32
#
 test_data.x 
#
cat>$datadir3/CFSv2.sst.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^CFSv2.sst.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
p 1 99 regression
endvars
#
EOF

cat>$datadir3/eof.sst.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^eof.sst.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmodm linear jan1983 1yr
vars 1
regr 1 99 regression
endvars
#
EOF

cat>$datadir3/eof.sst.obs.1982-2019.djf.ctl<<EOF2
dset ^eof.sst.obs.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmodo linear jan1983 1yr
vars 1
regr 1 99 regression
endvars
#
EOF2
done
   

