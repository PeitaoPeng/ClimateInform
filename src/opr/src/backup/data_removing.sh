#!/bin/sh
#===============================================
# remove some testing data
#===============================================

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
#
datain=/home/ppeng/data/ss_fcst
#
cd /home/ppeng
du --block-size=GB --max-depth=1 | sort -n

#for curyr in 2021 2022 2023 2024; do
for curyr in 2025; do

#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
for curmo in 01 02 03 04 05 06 07 08 09 10; do
#
if [ $curmo = 01 ]; then cmon=1; icmon=12; icmonc=dec; tgtmon=jan; tgtss=jfm; fi #tgtmon:1st mon of the lead-0 season
if [ $curmo = 02 ]; then cmon=2; icmon=1 ; icmonc=jan; tgtmon=feb; tgtss=fma; fi
if [ $curmo = 03 ]; then cmon=3; icmon=2 ; icmonc=feb; tgtmon=mar; tgtss=mam; fi
if [ $curmo = 04 ]; then cmon=4; icmon=3 ; icmonc=mar; tgtmon=apr; tgtss=amj; fi
if [ $curmo = 05 ]; then cmon=5; icmon=4 ; icmonc=apr; tgtmon=may; tgtss=mjj; fi
if [ $curmo = 06 ]; then cmon=6; icmon=5 ; icmonc=may; tgtmon=jun; tgtss=jja; fi
if [ $curmo = 07 ]; then cmon=7; icmon=6 ; icmonc=jun; tgtmon=jul; tgtss=jas; fi
if [ $curmo = 08 ]; then cmon=8; icmon=7 ; icmonc=jul; tgtmon=aug; tgtss=aso; fi
if [ $curmo = 09 ]; then cmon=9; icmon=8 ; icmonc=aug; tgtmon=sep; tgtss=son; fi
if [ $curmo = 10 ]; then cmon=10; icmon=9; icmonc=sep; tgtmon=oct; tgtss=ond; fi
if [ $curmo = 11 ]; then cmon=11; icmon=10; icmonc=oct; tgtmon=nov; tgtss=ndj; fi
if [ $curmo = 12 ]; then cmon=12; icmon=11; icmonc=nov; tgtmon=dec; tgtss=djf; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
yyyp=`expr $curyr + 1`
#
tgtmoyr=$tgtmon$yyyy  # 1st mon of lead-1 season
#
outyr_s=1951 # for hcst
skill_yr_s=1981 # for skill
its_skill=`expr $skill_yr_s - 1950` # =31 for skill_yr_s=1981
#
if [ $icmon -eq 12 ]; then tgtmoyr=$tgtmon$yyyp; skill_yr_s=1982; fi
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi

yrdir=/home/ppeng/data/ss_fcst/pcr/$icyr
ymdir=${yrdir}/$icmon

/bin/rm $ymdir/cvcor*pac*

done # curmo loop
done # curyr loop

cd /home/ppeng
du --block-size=GB --max-depth=1 | sort -n
