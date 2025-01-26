#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/src
datadir=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/tmp

cp $lcdir/us_consl.allseason.f    $TMPDIR/regr.f
cp $lcdir/mtrx_inv.s.f  $TMPDIR/regr.s.f
cd $TMPDIR

#
f77 -o regr.x regr.f regr.s.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
 ln -s $datadir/t2m_obs102_djf_1982-2006.dat          fort.10
 ln -s $datadir/t2m_cca102_djf_ld_1_1982-2006.dat     fort.20
 ln -s $datadir/t2m_cfs102_djf_ld_1_1982-2006.esm.dat fort.30
 ln -s $datadir/t2m_smlr102__djf_ld_1_1982-2006.dat     fort.40
#
ln -s $datadir/t2m_obs_and_prd.dat             fort.60
 
regr.x>$lcdir/out
ja -s
