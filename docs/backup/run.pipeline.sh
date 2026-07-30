#!/bin/sh

set -eaux

codedir=/home/ppeng/ClimateInform/docs
#
bash $codedir/clean_working_tree.sh
bash $codedir/climateinform_pipeline.sh
#
