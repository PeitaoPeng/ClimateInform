#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/collins
#
cp $lcdir/nino34_table.f $tmp/table.f
cd $tmp
#
cat > parm.h << eof
c
      parameter(nvar=3)
      parameter(nld=17,nesm=12)
      parameter(nyr=36,nss=12)
eof

#
gfortran -o table.x table.f
echo "done compiling"

#if [ -d fort.10 ] ; then
/bin/rm $tmp/fort.*
#fi
#
ln -s $datadir/cahcst.ersst.nino34.jfm_ic.gr fort.11
ln -s $datadir/cahcst.hadoisst.nino34.jfm_ic.gr fort.12
ln -s $datadir/cahcst.ersst.nino34.fma_ic.gr fort.13
ln -s $datadir/cahcst.hadoisst.nino34.fma_ic.gr fort.14
ln -s $datadir/cahcst.ersst.nino34.mam_ic.gr fort.15
ln -s $datadir/cahcst.hadoisst.nino34.mam_ic.gr fort.16
ln -s $datadir/cahcst.ersst.nino34.amj_ic.gr fort.17
ln -s $datadir/cahcst.hadoisst.nino34.amj_ic.gr fort.18
ln -s $datadir/cahcst.ersst.nino34.mjj_ic.gr fort.19
ln -s $datadir/cahcst.hadoisst.nino34.mjj_ic.gr fort.20
ln -s $datadir/cahcst.ersst.nino34.jja_ic.gr fort.21
ln -s $datadir/cahcst.hadoisst.nino34.jja_ic.gr fort.22
ln -s $datadir/cahcst.ersst.nino34.jas_ic.gr fort.23
ln -s $datadir/cahcst.hadoisst.nino34.jas_ic.gr fort.24
ln -s $datadir/cahcst.ersst.nino34.aso_ic.gr fort.25
ln -s $datadir/cahcst.hadoisst.nino34.aso_ic.gr fort.26
ln -s $datadir/cahcst.ersst.nino34.son_ic.gr fort.27
ln -s $datadir/cahcst.hadoisst.nino34.son_ic.gr fort.28
ln -s $datadir/cahcst.ersst.nino34.ond_ic.gr fort.29
ln -s $datadir/cahcst.hadoisst.nino34.ond_ic.gr fort.30
ln -s $datadir/cahcst.ersst.nino34.ndj_ic.gr fort.31
ln -s $datadir/cahcst.hadoisst.nino34.ndj_ic.gr fort.32
ln -s $datadir/cahcst.ersst.nino34.djf_ic.gr fort.33
ln -s $datadir/cahcst.hadoisst.nino34.djf_ic.gr fort.34
#
ln -s $datadir/cahcst.nino34.anom.text fort.71
ln -s $datadir/cahcst.nino34.total.text fort.72

table.x > $datadir/table.out
#
