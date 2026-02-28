#!/bin/sh

set -eaux

lcdir=/export/hobbes/wd52pp/project/sup_esm/src
datadir=/export-12/cacsrv1/wd52pp/super_esm
TMPDIR=/export/hobbes/wd52pp/tmp

cp $lcdir/us_consl.best.f    $TMPDIR/regr.f
cp $lcdir/mtrx_inv.s.f  $TMPDIR/regr.s.f
cd $TMPDIR

#
f77 -o regr.x regr.f regr.s.f
echo "done compiling"

/bin/rm $TMPDIR/fort.*
#
 ln -s $datadir/t2m_obs102_jfm_1982-2006.dat          fort.10
 ln -s $datadir/t2m_cca102_jfm_ld_1_1982-2006.dat     fort.20
 ln -s $datadir/t2m_cfs102_jfm_ld_1_1982-2006.esm.nbc.dat fort.30
 ln -s $datadir/t2m_smlr102_jfm_ld_1_1982-2006.dat     fort.40
 ln -s $datadir/skill_CB_spind_t2m_jfm_1982-2006.i3e     fort.50
#
ln -s $datadir/t2m_obs_and_prd.best.dat             fort.60
 
regr.x>$lcdir/out.best
#
#
# convert data into grads format
#

cat>$datadir/skill_CB_spind_t2m_jfm_1982-2006.ctl<<EOF
dset $datadir/skill_CB_spind_t2m_jfm_1982-2006.gr
dtype station
options sequential
stnmap $datadir/skill_CB_spind_t2m_jfm_1982-2006.map
undef 10e10
title ac_skill
tdef 5 linear 00z01jan1998  1hr
vars   1
z 0 0 weight of cca
endvars
EOF
#
#===convert data to grads file
#
source1=/export/hobbes/wd52pp/project/LF_prd/plot_cd

cd $source1/convert
cat > parm.h << eof
       parameter(nyear=5)
eof
#

/bin/rm fort.*
f77 -o cd_2_grads.x cd_2_grads.f

   ln -s      $datadir/skill_CB_spind_t2m_jfm_1982-2006.i3e         fort.11
#
   ln -s      $source1/convert/data_102/lalo102       fort.12

#
   ln -s      $datadir/skill_CB_spind_t2m_jfm_1982-2006.gr    fort.55

   cd_2_grads.x

 stnmap -i $datadir/skill_CB_spind_t2m_jfm_1982-2006.ctl       #create map file
done

exit
ja -s
