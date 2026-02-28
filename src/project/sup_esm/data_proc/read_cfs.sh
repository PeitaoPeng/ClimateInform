#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/data_proc
datadir1=/export/lnx225/wd53du/conustp/data
datadir2=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/test

cp $lcdir/read_cfs.f $TMPDIR/read.f
cd $TMPDIR

#
f77 -o read.x read.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
 ln -s $datadir1/cfsenst102.dat    fort.10

 ln -s $datadir2/t2m_cfs102_jfm_ld_1_1982-2006.ind.dat  fort.60
 ln -s $datadir2/t2m_cfs102_jfm_ld_1_1982-2006.esm.dat  fort.61
 ln -s $datadir2/t2m_cfs102_jfm_ld_1_1982-2006.esm.nbc.dat  fort.62
 
read.x > out
cp out $lcdir/out
ja -s
