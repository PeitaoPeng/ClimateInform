#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/src
datadir=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/tmp

cp $lcdir/skill.f    $TMPDIR/skill.f
cd $TMPDIR

#
f77 -o skill.x skill.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
#ln -s $datadir/t2m_obs102_jfm_1982-2006.dat          fort.10
 ln -s $datadir/2mt.wmoanom.jfm.1982-2006.txt        fort.10
 ln -s $datadir/t2m_cca102_jfm_ld_1_1982-2006.dat     fort.20
 ln -s $datadir/t2m_cfs102_jfm_ld_1_1982-2006.esm.nbc.dat fort.30
 ln -s $datadir/t2m_smlr102_jfm_ld_1_1982-2006.dat     fort.40
 ln -s $datadir/t2m_eocn102_jfm_1982-2006.dat     fort.50
#
skill.x>$lcdir/out.skill
ja -s
