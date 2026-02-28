#!/bin/bash
YEAR=`date --date='20 day ago' '+%Y'`
MONTH=`date --date='20 day ago' '+%m'`
Yb2=`date --date='50 day ago' '+%Y'`
Mb2=`date --date='50 day ago' '+%m'`
cd /home/ppeng/data/downloads
ftp -n  https://www.ncei.noaa.gov/data/outgoing-longwave-radiation-monthly/access/olr-monthly_v02r07_197901_$YEAR$MONTH.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/noaa.ersst.v5/sst.mnmean.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/Monthlies/pressure/hgt.mon.mean.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/Monthlies/surface/slp.mon.mean.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/precl/1.0deg/precip.mon.mean.1x1.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/precl/0.5deg/precip.mon.mean.0.5x0.5.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/ghcncams/air.mon.mean.nc
#ftp -n https://ftp.cpc.ncep.noaa.gov/wd51yf/GHCN_CAMS/ghcn_cams_1948_cur.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/noaa.oisst.v2.highres/sst.mon.mean.nc
\rm olr-monthly_v02r07_197901_$Yb2$Mb2.nc
exit 0

