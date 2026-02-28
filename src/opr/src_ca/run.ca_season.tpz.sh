#!/bin/sh

set -eaux

codedir=/home/ppeng/ClimateInform/src/opr/src_ca
#
$codedir/realtime.ca_msic.season.sst_tpz.sh
$codedir/plot.fcst.pz.sh
$codedir/plot.fcst.t2m.sh
$codedir/plot.skill.tpz.sh
#$codedir/scp_data.sh
#for 0.5x0.5 prec forecast, but not skill
#$codedir/realtime.ca_msic.season.sst_p.0.5x0.5.sh
#$codedir/plot.fcst.p.0.5x0.5.sh
#$codedir/scp_data.p.0.5x0.5.sh
