set -euax
#
latestmon=10
nyear=92  #once come to a new year, nyear must plus 1
#
cd /cpc/home/wd52pp/tmp
cp /cpc/home/wd52pp/project/LF_prd/ocn_prd/read_cd.f .
#datadir1=/cpc/data/observations/land_air/long_range/conus/temp_precip/cds
datadir1=/cpc/prod/operations/processes/make_ncdc_cds/library/rotating/$latestmon
datadir2=/cpc/home/wd52pp/data/unger
datadir3=/cpc/home/wd52pp/data/LF_prd
#
cat > parm.h << eof
       parameter(nyear=$nyear)
eof
#
\rm fort.*
gfortran -o read_cd.x read_cd.f
 ln -s $datadir2/cdldict.dat             fort.11
 ln -s $datadir1/t.long                  fort.61
 ln -s $datadir1/p.long                  fort.62
 ln -s $datadir3/temp_102.txt            fort.80
 ln -s $datadir3/prec_102.txt            fort.81
read_cd.x > read_cd.out &
exit
   

