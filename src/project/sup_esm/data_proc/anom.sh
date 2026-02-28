#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/data_proc
datadir=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/test

cp $lcdir/anom.f $TMPDIR/read.f
cd $TMPDIR

#
f77 -o read.x read.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#

 ln -s $datadir/t2m_obs102_jfm_1982-2006.dat       fort.10
 ln -s $datadir/t2m_obs102_jfm_1982-2006.anom.dat  fort.60
 
read.x > out
ja -s
