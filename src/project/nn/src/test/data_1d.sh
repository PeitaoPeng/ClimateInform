set -euax
#
ltime=1000
#
lcdir=/cpc/home/wd52pp/project/nn/src
datadir=/cpc/home/wd52pp/data/nn
cd /cpc/home/wd52pp/tmp
cp $lcdir/data_1d.f .
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(alpha=0.5)
eof
#
\rm fort.10
 gfortran -o data.x data_1d.f
 ln -s $datadir/data_test.1d.bi   fort.10
 test_data.x 
exit
   

