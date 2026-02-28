set -euax
#
ltime=38
icmon=may
nfld1=2
nfld2=5
nlead=7
#
lcdir=/cpc/home/wd52pp/project/nn/nmme
datadir=/cpc/home/wd52pp/data/nn/nmme
datadir=/cpc/home/wd52pp/data/nn/nmme
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_nino.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nfld1=2)
       parameter(nfld2=5)
       parameter(nld=$nlead)
eof
#
\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datadir/NMME.nino1-4.ss.${icmon}_ic.1982-2019.ld1-7.esm.anom.gr fort.10
 ln -s $datadir/nino34.oi.dec1982-feb2020.djf.gr fort.20
 ln -s $datadir/input_n34.${icmon}_ic.1982-2019.djf.gr fort.30
 ln -s $datadir/input_n1_4.${icmon}_ic.1982-2019.djf.gr fort.40
 test_data.x 
#
cat>$datadir/input_n34.${icmon}_ic.1982-2019.djf.ctl<<EOF2
dset ^input_n34.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 2 LINEAR      0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
n34  1 99 nino34 of nmme and oi sst
endvars
#
EOF2
   
cat>$datadir/input_n1_4.${icmon}_ic.1982-2019.djf.ctl<<EOF3
dset ^input_n1_4.${icmon}_ic.1982-2019.djf.gr
undef -9.99E+8
title EXP1
XDEF 5 LINEAR      0  1.0
YDEF 1 LINEAR    -90  1.0
zdef 1 linear 1 1
tdef $ltime linear jan1983 1yr
vars 1
nino 1 99 nino34 of nmme and oi sst
endvars
#
EOF3
   

