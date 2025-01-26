#!/bin/sh

set -eaux

codedir=/cpc/home/wd52pp/project/ca_prd/sst/opr
#
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.ca_msic.month.sst_tpz.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.fcst.pz.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.fcst.t2m.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.skill.tpz.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.scp_data.month.sh
#for 0.5x0.5 prec forecast, but not skill
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.ca_msic.month.sst_p.0.5x0.5.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.fcst.p.0.5x0.5.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.scp_data.p.0.5x0.5.month.sh
