#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/src
datadir=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/tmp

cp $lcdir/mme.test.f    $TMPDIR/regr.f
cp $lcdir/mtrx_inv.s.f  $TMPDIR/regr.s.f
cd $TMPDIR

#
f77 -o regr.x regr.f regr.s.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
 ln -s $datadir/random_data_1.txt        fort.10
 ln -s $datadir/random_data_2.txt        fort.20
 ln -s $datadir/random_data_3.txt        fort.30
 ln -s $datadir/random_data_4.txt        fort.40
#
ln -s $datadir/mme_test.txt              fort.60
 
regr.x>$lcdir/out.test
ja -s
