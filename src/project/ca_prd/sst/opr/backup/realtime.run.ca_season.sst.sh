#!/bin/sh

set -eaux

codedir=/cpc/home/wd52pp/project/ca_prd/sst/opr
#
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.ca_msic.season.ersst.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.ca_msic.season.hadoisst.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.nino34.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.fcst.sst.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.skill.sst.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.sstonly.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.weight_avg.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.scp_data.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.html.sh
