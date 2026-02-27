set -euax
########################################################
# have grid SST input 
###############################################
#
nyear=36
icss=fma
ngrd=123
nfld=`expr $ngrd + 1`
nlead=17 #ld=1: IC, ld=4, 0-lead
#
lcdir=/cpc/home/wd52pp/project/nn/ca
datasst=/cpc/home/wd52pp/data/casst
datadir=/cpc/home/wd52pp/data/nn/ca
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#for icss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
for icss in fma; do
#
if [ $icss = jfm ]; then cmon=4;  icmomid=feb; icssnmb=1; tld=12; fi #icmon_mid: mid mon of icss
if [ $icss = fma ]; then cmon=5;  icmomid=mar; icssnmb=2; tld=11; fi #icssnmb: 1st mon of icss
if [ $icss = mam ]; then cmon=6;  icmomid=apr; icssnmb=3; tld=10; fi #tld: ld# from icss to taget ss djf
if [ $icss = amj ]; then cmon=7;  icmomid=may; icssnmb=4; tld=9; fi
if [ $icss = mjj ]; then cmon=8;  icmomid=jun; icssnmb=5; tld=8; fi
if [ $icss = jja ]; then cmon=9;  icmomid=jul; icssnmb=6; tld=7; fi
if [ $icss = jas ]; then cmon=10;  icmomid=aug; icssnmb=7; tld=6; fi
if [ $icss = aso ]; then cmon=11;  icmomid=sep; icssnmb=8; tld=5; fi
if [ $icss = son ]; then cmon=12;  icmomid=oct; icssnmb=9; tld=16; fi
if [ $icss = ond ]; then cmon=1; icmomid=nov; icssnmb=10; tld=15; fi
if [ $icss = ndj ]; then cmon=2; icmomid=dec; icssnmb=11; tld=14; fi
if [ $icss = djf ]; then cmon=3; icmomid=jan; icssnmb=12; tld=13; fi
#
icmomidyr=${icmomid}1981
if [ $icss = djf ]; then icmomidyr=${icmomid}1982; fi

nyear=36  # years of forecast to be checked
cp $lcdir/input_sst.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$nyear)
       parameter(imx=360,jmx=180)
       parameter(is=121,ie=300,js=66,je=105)
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead,itld=$tld)
eof
#
\rm fort.*
 gfortran -o test_data.x test_data.f
 ln -s $datasst/cahcst.sst.${icss}_ic.esm.gr fort.10
 ln -s $datadir/cahcst.djf.nino34.${icss}_ic.esm.gr fort.20
 ln -s $datadir/input_sst.${icss}_ic.djf.gr fort.30
 test_data.x 
#
cat>$datadir/input_sst.${icss}_ic.djf.ctl<<EOF3
dset ^input_sst.${icss}_ic.djf.gr
undef -9.99E+8
title EXP1
XDEF $nfld LINEAR 1  1.0
YDEF 1 LINEAR    -89.5  1.0
zdef 1 linear 1 1
tdef $nyear linear jan1982 1yr
vars 1
sst 1 99 grd sst fcst for DJF
endvars
#
EOF3
done
