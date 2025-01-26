#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/data_proc
datadir1=/export/lnx225/wd53du/cddata
datadir2=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/test

cp $lcdir/read_obs.f $TMPDIR/read.f
cd $TMPDIR

#
f77 -o read.x read.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
 ln -s $datadir1/cd102t.dat    fort.10
#
#ln -s $datadir2/t2m_obs102_jfm_1982-2006.dat    fort.60
#ln -s $datadir2/t2m_obs102_jfm_1982-2006.hf.dat    fort.61
 ln -s $datadir2/t2m_obs102_djf_1951-2000.dat    fort.60
 ln -s $datadir2/t2m_obs102_djf_1951-2000.hf.dat    fort.61
 
read.x > out
cp out $lcdir/out
ja -s
