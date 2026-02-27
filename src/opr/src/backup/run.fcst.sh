#!/bin/sh

set -eaux

codedir=/home/ppeng/ClimateInform/src/opr/src
#
vnmb=v3_1
vnmb2=v4
#
bash $codedir/pcr_ersst_2_sst.3mon.mics_meofs.pac.sh
#
bash $codedir/pcr_ersst_2_tpz.3mon.mics_meofs.$vnmb.sh
bash $codedir/pcr_slp_2_tpz.3mon.mics_meofs.$vnmb.sh
bash $codedir/eeof_p_2_t.3mon.$vnmb.sh
bash $codedir/eeof_sst_2_tpz.3mon.$vnmb.sh
bash $codedir/eeof_tpz_2_tpz.3mon.$vnmb.sh
#
bash $codedir/frac_4_opt_prob.cor.$vnmb2.sh
bash $codedir/synth_fcst_ensm.cor.$vnmb2.sh

bash $codedir/frac_4_opt_prob.sim.$vnmb2.sh
bash $codedir/synth_fcst_ensm.sim.$vnmb2.sh
#
