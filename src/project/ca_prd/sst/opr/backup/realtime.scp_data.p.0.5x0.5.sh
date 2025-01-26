#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp/opr2
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/ca_prd
#
cd $datadir
#
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#curyr=2022  # yr of making fcst
#curmo=12  # mo of making fcst
pasyr=`expr $curyr - 1`
#
if [ $curmo = 01 ]; then icmon=12 ; icyr=$pasyr ; fi 
if [ $curmo = 02 ]; then icmon=01 ; icyr=$curyr ; fi
if [ $curmo = 03 ]; then icmon=02 ; icyr=$curyr ; fi
if [ $curmo = 04 ]; then icmon=03 ; icyr=$curyr ; fi
if [ $curmo = 05 ]; then icmon=04 ; icyr=$curyr ; fi
if [ $curmo = 06 ]; then icmon=05 ; icyr=$curyr ; fi
if [ $curmo = 07 ]; then icmon=06 ; icyr=$curyr ; fi
if [ $curmo = 08 ]; then icmon=07 ; icyr=$curyr ; fi
if [ $curmo = 09 ]; then icmon=08 ; icyr=$curyr ; fi
if [ $curmo = 10 ]; then icmon=09 ; icyr=$curyr ; fi
if [ $curmo = 11 ]; then icmon=10 ; icyr=$curyr ; fi
if [ $curmo = 12 ]; then icmon=11 ; icyr=$curyr; fi
#
rzdmdir=/home/people/cpc/www/htdocs/products/people/wd52pp/sst/$icyr$icmon
lcdata=/cpc/home/wd52pp/data/season_fcst/ca/$icyr/$icmon
scp $lcdata/*.png wd52pp@vm-cprk-rzdm01:$rzdmdir/.
