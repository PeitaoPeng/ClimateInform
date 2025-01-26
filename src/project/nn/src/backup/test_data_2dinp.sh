set -euax
#
ltime=1000
#
lcdir=/cpc/home/wd52pp/project/nn/src
datadir=/cpc/home/wd52pp/data/nn
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/test_data_2dinp.f test_data.f
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(nfld=3)
       parameter(wt=0.5)
eof
#
\rm fort.20
 gfortran -o test_data.x test_data.f
 ln -s $datadir/data_test.bi   fort.20
 test_data.x 
 mv data_test.csv $datadir
exit
   

