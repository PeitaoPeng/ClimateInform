set -euax
#
ltime=1000
nfld=2
#
lcdir=/cpc/home/wd52pp/project/nn/src
datadir=/cpc/home/wd52pp/data/nn
cd /cpc/home/wd52pp/tmp
cp $lcdir/data_1d.f .
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(alpha=0.3)
       parameter(nfld=$nfld)
eof
#
\rm fort.10
 gfortran -o data.x data_1d.f
 ln -s $datadir/data_test.1d.bi   fort.10
data.x 
exit
   

