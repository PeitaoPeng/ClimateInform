#!/bin/sh

set -eaux

codedir=/home/ppeng/ClimateInform/src/opr/src
#
vnmb2=v4
#
bash $codedir/plot.fcst_sst_map.sh
bash $codedir/plot.fcst_TP_Prob_map.sh
bash $codedir/plot.fcst_TP_det_map.sh
bash $codedir/plot.fcst_nino34.sh
#
bash $codedir/plot.ACC_SST_map.sh
bash $codedir/plot.ACC_TP_map.sh
bash $codedir/plot.HSS_TP_map.sh
bash $codedir/plot.RPSS_TP_map.sh
bash $codedir/plot.ACC_nino34.sh
#
