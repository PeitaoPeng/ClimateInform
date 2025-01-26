#!/bin/sh

set -eaux

codedir=/cpc/home/wd52pp/project/ca_prd/sst/opr
#
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.ca_msic.month.ersst.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.ca_msic.month.hadoisst.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.fcst.sst.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.plot.skill.sst.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.scp_data.month.sh
/cpc/home/wd52pp/project/ca_prd/sst/opr/realtime.html.month.sh
