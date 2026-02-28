#!/bin/sh

set -eaux

##=====================================
# have SST for certain ss or mon from model anmd obs data
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/opr/analyses
tmp=/cpc/home/wd52pp/tmp/test

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
model=CFSv2
nyr=38
yrend=2019
nlead=7
icmon=may
tgtss=djf
lead=7
imx=144
jmx=73

if [ $model = 'CFSv2' ];  then subdir=cfsv2; fi
if [ $model = 'NMME' ];  then subdir=nmme; fi
datadir=/cpc/consistency/nn/$subdir
datadir2=/cpc/consistency/nn/obs
#
#
#=======================================
cat > parm.h << eof
      parameter(nt=$nyr)
      parameter(imx=$imx,jmx=$jmx)
      parameter(nld=$nlead)
      parameter(ld=$lead)
      parameter(undef=-9.99e+8)
eof
cat > have_data.f << EOF
      program havedata
      include "parm.h"
      dimension w2d(imx,jmx),wd2(imx,jmx)
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
C
c*************************************************
C
C read model sst

      ir=ld
      do it=1,nt

        read(10,rec=ir) w2d        !model hcst sst
        read(11,rec=ir) w2d2        !obs sst
        write(20,rec=it) w2d       !model hcst sst
        write(21,rec=it) w2d2       !obs sst

c       print *, 'ir=',ir
        ir=ir+nld
      enddo ! it loop
      stop
      end
EOF
#
gfortran -g -fbacktrace -o data.x have_data.f

#if [ -d fort.10 ] ; then
/bin/rm fort.*
#fi

ln -s $datadir/$model.tmpsfc.ss.${icmon}_ic.1982-$yrend.ld1-$nlead.esm.anom.gr fort.10
ln -s $datadir2/obs.sst.ss.${icmon}_ic.1982-cur.ld1-$nlead.anom.gr fort.11
ln -s $datadir/${model}_sst.${icmon}_ic.1982-$yrend.$tgtss.bi      fort.20
ln -s $datadir2/obs_sst.1982-$yrend.$tgtss.bi                      fort.21

#excute program
data.x
#
cat>$datadir/${model}_sst.${icmon}_ic.1982-$yrend.$tgtss.ctl<<EOF2
dset ^${model}_sst.${icmon}_ic.1982-$yrend.$tgtss.bi
undef -9.99E+8
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF2
#
cat>$datadir2/obs_sst.1982-$yrend.$tgtss.ctl<<EOF2
dset ^obs_sst.1982-$yrend.$tgtss.bi
undef -9.99E+8
title EXP1
XDEF  $imx LINEAR    0  2.5
YDEF  $jmx LINEAR  -90  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1983 1yr
vars 1
sst 1 99 grd sst fcst for DJF(lead=7)
endvars
#
EOF2
