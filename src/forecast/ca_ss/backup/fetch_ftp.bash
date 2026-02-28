#!/bin/bash
ftp -n https://downloads.psl.noaa.gov/Datasets/noaa.ersst.v5/sst.mnmean.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/Monthlies/pressure/hgt.mon.mean.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/precl/1.0deg/precip.mon.mean.1x1.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/ghcncams/air.mon.mean.nc
ftp -n https://downloads.psl.noaa.gov/Datasets/noaa.oisst.v2.highres/sst.mon.mean.nc
exit 0

