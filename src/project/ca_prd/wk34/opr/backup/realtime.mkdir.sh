#!/bin/sh

set -eaux
#forecast date
fy4=`date --date='today' '+%Y'`
fm2=`date --date='today' '+%m'`
fd2=`date --date='today' '+%d'`
 
if [ ! -d /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4 ] ; then
  mkdir -p /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4
fi

if [ ! -d /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2 ] ; then
  mkdir -p /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2
fi

if [ ! -d /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2 ] ; then
  mkdir -p /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2
fi
#copy 1-day before data
bfy4=`date --date='1 day ago' '+%Y'`
bfm2=`date --date='1 day ago' '+%m'`
bfd2=`date --date='1 day ago' '+%d'`
#cd /cpc/home/wd52pp/data/wk34_fcst/ca/$bfy4/$bfm2/$bfd2
#cp ca* /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2/.
