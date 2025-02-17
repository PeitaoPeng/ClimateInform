#!/bin/sh

set -eaux

codedir=/home/ppeng/ClimateInform/src/opr/src
#
bash $codedir/pcr_ersst_2_sst.3mon.mics_meofs.sh
bash $codedir/pcr_ersst_2_tpz.3mon.dtrd.mics_meofs.sh
bash $codedir/pcr_olr_2_tpz.3mon.dtrd.mics_meofs.sh
bash $codedir/pcr_slp_2_tpz.3mon.dtrd.mics_meofs.sh
bash $codedir/ocn_tpz.3mon.sh
