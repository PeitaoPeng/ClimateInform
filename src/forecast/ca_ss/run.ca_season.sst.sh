#!/bin/sh

set -eaux

codedir=/home/ppeng/src/forecast/ca_ss
cd $codedir
#
bash realtime.ca_msic.season.ersst.sh
bash realtime.ca_msic.season.hadoisst.sh
bash nino34.sh
bash plot.fcst.sst.sh
bash plot.skill.sst.sh
bash plot.sstonly.sh
bash weight_avg.sh
#$codedir/scp_data.sh
#$codedir/realtime.html.sh
