#!/bin/sh

set -eaux

codedir=/home/ppeng/ClimateInform/src/develop/data_proc
#
bash $codedir/have_ersst_3mon.total.sh
bash $codedir/have_ersst_mon.total.sh
bash $codedir/have_hadoisst_3mon.total.sh
bash $codedir/have_hadoisst_mon.total.sh
bash $codedir/have_tpz_3mon.total.sh
bash $codedir/have_olr_3mon.total.sh
bash $codedir/have_slp_3mon.total.sh
