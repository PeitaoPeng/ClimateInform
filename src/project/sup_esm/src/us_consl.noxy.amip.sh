#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/src
datadir=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/tmp

cp $lcdir/us_consl.noxy.amip.f    $TMPDIR/regr.f
cp $lcdir/mtrx_inv.s.f  $TMPDIR/regr.s.f
cd $TMPDIR

#
f77 -o regr.x regr.f regr.s.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
#ln -s $datadir/sfct.obs.52-01.djf.102cd.txt        fort.10
 ln -s $datadir/t2m_obs102_djf_1952-2001.dat        fort.10
 ln -s $datadir/sfct.echam4.52-01.djf.102cd.txt     fort.20
 ln -s $datadir/sfct.gfdl3.52-01.djf.102cd.txt      fort.30
 ln -s $datadir/sfct.nsipp.52-01.djf.102cd.txt      fort.40
#
ln -s $datadir/t2m_obs_and_prd.noxy.amip.dat             fort.60
 
regr.x>$lcdir/out.noxy.amip
ja -s
