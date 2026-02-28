set -euax
#
ltime=1000
#
lcdir=/cpc/home/wd52pp/project/nn/src
cd /cpc/home/wd52pp/tmp
cp $lcdir/test_data.f .
#
cat > parm.h << eof
       parameter(nt=$ltime)
       parameter(wt=0.3)
eof
#
#\rm fort.*
 gfortran -o test_data.x test_data.f
#ln -s $lcdir/data_test.csv   fort.10
 test_data.x 
 mv data_test.csv $lcdir
exit
   

