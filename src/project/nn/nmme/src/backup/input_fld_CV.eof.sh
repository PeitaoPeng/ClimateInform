set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=38
icmon=may

ngrdm=1005
ngrdo=1073
nmodm=13 # model modes kept
nmodo=13 # obs modes kept

#ngrdm=4723
#ngrdo=5107
#nmodm=13 # model modes kept
#nmodo=13 # obs modes kept

nfldm=`expr $nmodm + 1`
nfldo=`expr $nmodo + 1`
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/nmme/src
datadir=/cpc/consistency/nn/nmme
tmp=/cpc/home/wd52pp/tmp
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
       parameter(nld=$nlead)
       parameter(nmodm=$nmodm,nmodo=$nmodo,id=0)
eof
#
rm fort.*
 gfortran -o test_data.x reof.s.f test_data.f
 ln -s $datadir/NMME.tmpsfc.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
 ln -s $datadir/obs_sst.1982-2019.djf.bi fort.11
#
 ln -s $datadir/input_fld_CV.eof.model.gr fort.20
 ln -s $datadir/input_fld_CV.eof.obs.gr fort.21
#
 ln -s $datadir/eof.sst.${icmon}_ic.1982-2019.djf.gr fort.30
 ln -s $datadir/eof.sst.obs.1982-2019.djf.gr fort.31
 ln -s $datadir/NMME.sst.${icmon}_ic.1982-2019.djf.gr fort.32
#
 test_data.x 
#
cat>$datadir/NMME.sst.${icmon}_ic.1982-2019.djf.ctl<<EOF
dset ^NMME.sst.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
regr 1 99 regression
endvars
#
EOF

cat>$datadir/eof.sst.${icmon}_ic.1982-2019.djf.ctl<<EOF
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

cat>$datadir/eof.sst.obs.1982-2019.djf.ctl<<EOF2
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
   

