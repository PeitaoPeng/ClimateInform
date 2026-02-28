#!/bin/sh
#set -x
#
#*****************************************************************
# PROGRAM: 
# directory: /cpc/prod/cwlinks/cdb_teleconnection_indices-rh6/scripts
# script name: oper_monthly_tele_indices_update.sh
#
# LANGUAGE: Bourne Shell
#
# MACHINE: Compute Farm
#----------------------------------------------------------------*
#NOTE:
# This job MUST be set to run in cron BEFORE the lnx356 job runs to update 
# the CDB scripts. That script is
#/cpc/home/wd52gb/bulletin_1981-2010clim/run_cdb_update_extratropics.sh
#
# PURPOSE: 
#Trigger codes to update the 500-hPa tele indices and plots for CPC monitoring, Web, and Climate Diagnostics Bulletin
#Creates Fig. E7 for CDB
#    
#----------------------------------------------------------------*
# USAGE: Climate monitoring, web products, CDB products
#----------------------------------------------------------------*
# INPUT FILES:   
# eofmonftp_700.tim: 700-hPa monthly tele index archive file to be updated 
# eofmonftp_new.tim: 500-hPa monthly tele index archive file to be updated 
# eofdayftp_new.tim: 500-hPa daily tele index archive file to be updated 
# daily_clim_ctl: grads control file pointing to 1950-2000 daily mean and standar deviation
# cdas_monthly_ctl: Grads control file for monthly CDAS data
# cdas_daily_ctl: Grads control file for daily CDAS data
#              
# OUTPUT FILES 
# monthly_eof_to_table_e1.tim: Data file of teleconnection indices for most recent month- for table E1 in CDB
# *.timeseries.gif: web plots with updated tele time series
# *_index.tim ascii data files of the teleconnection indices 
#telemonc_new.ps: Fig. E7 for the CDB
#telemonc_new.gif: Fig. E7 for the web
#
#----------------------------------------------------------------*
# SCRIPTS AND SOURCE CODES THAT GET TRIGGERED:  
# daily_tele_filename.exe: FORTRAN code to write out daily CDAS file name  
# oper_monthly_tele_lastdate.exe: FORTRAN code to find last date in monthy tele index archive file                     
# oper_monthly_tele_indices.gs: grads script to extract monthly standardized 500-hPa height anomalies and 
#                               700-hPa heights for tele calculations
# oper_daily_tele_indices.gs: grads script to extract daily standardized 500-hPa height anomalies
# read700.exe: FORTRAN code to covert 700-hPa monthly heights to 358-pt grid
# oper_monthly_old_teleindices_update.exe: FORTRAN to calculate the 700-hPa tele indices
# oper_monthly_tele_indices.exe: FORTRAN to update new-climo monthly 500-hPa tele indices
# oper_daily_tele_indices.exe: FORTRAN to update new-climo daily 500-hPa tele indices
# tele_indices_fige7_cdb.gs: Grads script to produce Fig. E7 for CDB and for the web
# monthly_tele_timeseries_eofnew.gs: updates 500-hPa tele time series for the web
#
#---------------------------------------------------------------
# FUNCTIONS USED:   MATLAT75, Grads
#                     
#----------------------------------------------------------------
# INPUT VARIABLES:   
#
#LOCAL VARIABLES
#monbeg,iyrbeg: beginning month and year to calcualte tele indices 
#monend, iyrend: ending month and year to calcualte tele indices
#cf_webdir=compute farm web directory       
#cf_ftpdir=compute farm ftp directory       
#index_monthly: name of monthly tele index Grads control file
#index_monthly_ctl=name monthly tele index Grads control file
#archive: CDAS operational tele index archive
#daymon_tele.dat: temp file with date of previous month
#daily_tele_filenm.dat: text file with daily CDAS file name
#daymon_beg+end_tele.dat: file containing last date in monthy tele index archive file
#
#----------------------------------------------------------------*
# AUTHOR(S):        Gerry Bell
#----------------------------------------------------------------*
# DATE               3/21/2011
#----------------------------------------------------------------*
# MODIFICATIONS:
#******************************************************************
. $HOME/.profile
#homedir=/cpc/prod/cwlinks/cdb_teleconnection_indices
homedir=$CDB_TELECONNECTION_INDICES
logdir=$homedir/logs
start_time=`date`
#
# Begin Process
#
env 

#
# Create path names
#
# Full path names are:
#gradsdir=/usr/local/bin
#library=/cpc/prod/cwlinks/cdb_teleconnection_indices/library
#input=/cpc/prod/cwlinks/cdb_teleconnection_indices/input
#output=/cpc/prod/cwlinks/cdb_teleconnection_indices/output
#sources=/cpc/prod/cwlinks/cdb_teleconnection_indices/sources
#build=/cpc/prod/cwlinks/cdb_teleconnection_indices/build
#work=/cpc/prod/cwlinks/cdb_teleconnection_indices/work
#archive_monthly=/cpc/data/analysis/climate_phenomena/long_range/global/teleconnections_monthly
#archive_daily=/cpc/data/analysis/climate_phenomena/short_range/global/teleconnections_daily
#cf_webdir=/cpc/web/www/htdocs/data/teledoc
#cf_ftpdir=/cpc/web/ftp/wd52dg/data/indices

gradsdir=$CW_GRADS
library=$homedir/library
scriptdir=$homedir/scripts
input=$homedir/input
output=$homedir/output
sources=$homedir/sources
build=$homedir/build
work=$homedir/work
archive_monthly=$DATA_OUT/analysis/climate_phenomena/long_range/global/teleconnections_monthly
archive_daily=$DATA_OUT/analysis/climate_phenomena/short_range/global/teleconnections_daily
cf_webdir=$CF_WEB/htdocs/data/teledoc
cf_ftpdir=$CF_FTP/wd52dg/data/indices
ename=gerry.bell@noaa.gov

cd $scriptdir
read logfile < $logdir/logfile.dat
echo "CDB Teleconnection Update Process began at $start_time" >> $logdir/$logfile
echo $homedir/oper_monthly_tele_indices_update.sh >> $logdir/$logfile
echo $homedir >> $work/homedir
echo "CDB Teleconnection Update Process began at $start_time" 
echo $homedir/oper_monthly_tele_indices_update.sh 
#
index_monthly_ctl=$archive_monthly/monthly_tele_indices.ctl
cdas_monthly_ctl=$CW_CDAS_MTH/prs.grib.mean.y1949-cur.ctl
echo "Path names have been created" >> $logdir/$logfile
#
#
#Get date for previous month
#
year1=`date +%Y --date "-1 month" `
month1=` date +%m --date "-1 month" `
echo $month1 > $work/daymon_tele.dat
echo $year1 >> $work/daymon_tele.dat
echo $month1" "$year1
#daily_clim_ctl=$CW_TND/HGT.daily.clim.NH.1950-2000.harmc4.ctl
####
####
daily_clim_ctl=$archive_daily/HGT.daily.clim.NH.1950-2000.harmc4.ctl
####
####
echo "Date for previous month is $month1 $year1" >> $logdir/$logfile
##
##find last date in teleconnection table
##
cd $scriptdir
scriptname=oper_monthly_tele_lastdate
     echo " " >> $logdir/$logfile
     echo "   Running $scriptname.exe " >> $logdir/$logfile
$build/$scriptname.exe $archive_monthly/eofmonftp_new.tim > $logdir/scriptname.log
   echo "    $scriptname.exe completed"
   echo "    $scriptname.exe completed" >> $logdir/$logfile
read mm1yy1mm2yy2 < $work/daymon_beg+end_tele.dat
echo $mm1yy1mm2yy2
monbeg=`echo $mm1yy1mm2yy2 | cut -c1-3`
iyrbeg=`echo $mm1yy1mm2yy2 | cut -c4-7`
monend=`echo $mm1yy1mm2yy2 | cut -c8-10`
iyrend=`echo $mm1yy1mm2yy2 | cut -c11-14`
echo "Teleconnection indices will be updated from $monbeg $iyrbeg to $monend $iyrend" >> $logdir/$logfile 
#
# Calculate if month is a leap month. Also determine file name for daily input data
#
scriptname=daily_tele_filename
     echo " " >> $logdir/$logfile
     echo "   Running $scriptname.exe " >> $logdir/$logfile
$build/$scriptname.exe > $logdir/scriptname.log
   echo "    $scriptname.exe completed"
   echo "    $scriptname.exe completed" >> $logdir/$logfile
#$build/daily_tele_filename.exe 
read filenm < $work/daily_tele_filenm.dat
daymon=`echo $filenm | cut -c34-35`
#echo $daymon" "$filenm
cdas_daily_ctl=$CW_CDAS_ARCHIVE/$filenm
#echo $cdas_daily_ctl
echo "File name for daily input data is $filenm" >> $logdir/$logfile
#
#Check to ensure that both the monthly and daily gridded files are available
#If they are not, stop the job
#
if [ -e $cdas_monthly_ctl ] && [ -e $cdas_daily_ctl ]
then
#
#Get monthly data for the new and old teleconnection indices
#  
   $gradsdir/grads -blc "oper_monthly_tele_indices.gs $cdas_monthly_ctl $monbeg $iyrbeg $monend $iyrend" 
   echo "Monthly file for std. anoms was created" >> $logdir/$logfile
##
#Get daily data for the new teleconnection indices
# 
$gradsdir/grads -blc "oper_daily_tele_indices.gs $daily_clim_ctl $cdas_daily_ctl $monbeg $iyrbeg $monend $iyrend $daymon" 
echo "Daily file for std. anoms was created" >> $logdir/$logfile
#
#transform monthly 700-mb data to 358-pt grid for the old teleconnection indices
#
scriptname=read700
     echo " " >> $logdir/$logfile
     echo "   Running $scriptname.exe " >> $logdir/$logfile
$build/$scriptname.exe > $logdir/scriptname.log
   echo "    $scriptname.exe completed"
   echo "    $scriptname.exe completed" >> $logdir/$logfile
#$build/read700.exe
echo "700-hPa grids have been converted to 358-pt grid" >> $logdir/$logfile
#########################################################################
### SET PATHS FOR MATLAB ####
#CW_MATLAB_LIB=/cpc/prod/cwlinks/matlab75/bin/glnxa64
#CW_MATLAB_LICEN=/cpc/prod/cwlinks/matlab75/etc
#CW_MATLAB_BIN=/cpc/prod/cwlinks/matlab75/bin
#This command must be commented out if using MATLAB2011
#$CW_MATLAB_LICEN/lmstart
LD_LIBRARY_PATH=$CW_MATLAB_LIB
export LD_LIBRARY_PATH
PATH=$CW_MATLAB_BIN/:$PATH
export PATH
echo "MATLAB paths have been set" >> $logdir/$logfile
#
####### Run MATLAB EXECUTABLES #############
# 
#update the 700-hPa monthly teleconnection indices
#
scriptname=oper_monthly_old_teleindices_update
     echo " " >> $logdir/$logfile
     echo "   Running $scriptname.exe " >> $logdir/$logfile
$build/$scriptname.exe $archive_monthly/eofmonftp_700.tim > $logdir/$scriptname.log
     err_matlab=`grep "Can't start MATLAB engine" $logdir/$scriptname.log`
     echo $err_matlab
     err_abort=`grep "Aborted" $logdir/$scriptname.log`
     echo $err_abort
     if [ "$err_matlab" != "" ]; then
        err_process="Can't start MATLAB engine" 
        echo $err_proces
     fi
     if [ "$err_abort" != "" ]; then
        err_process="Process Aborted"  
        echo $err_process
     fi 
     if [ "$err_matlab" != "" ] || [ "$err_abort" != "" ]; then
        echo " " >> $logdir/$logfile
        echo "$err_process while running $scriptname.exe  "
        echo "$err_process. This ERROR ocurred while running FORTRAN code $scriptname.exe" >> $logdir/$logfile
        echo "The output log from the failed FORTRAN code is located in $logdir/$scriptname.log " >> $logdir/$logfile
        echo " " >> $logdir/$logfile
     exit
fi
   echo "    $scriptname.exe completed"
   echo "    $scriptname.exe completed" >> $logdir/$logfile
cp $archive_monthly/eofmonftp_700.tim $output/eofmonftp.tim
echo "Updated Monthly 700-hPa tele indices are" 
tail -2 $archive_monthly/eofmonftp_700.tim 
echo "Updated Monthly 700-hPa tele indices are" >> $logdir/$logfile
tail -2 $archive_monthly/eofmonftp_700.tim >> $logdir/$logfile
#
#Update the new-climo monthly teleconnection indices
#Below, the unix command "tail -2" reads off the last 2 lines of the file
#
scriptname=oper_monthly_tele_indices
     echo " " >> $logdir/$logfile
     echo "   Running $scriptname.exe " >> $logdir/$logfile
$build/$scriptname.exe $archive_monthly/eofmonftp_new.tim $archive_monthly/monthly_tele_indices.bi $archive_monthly/monthly_tele_indices.ctl $archive_monthly/monthly_newtele_to_table_E1.tim > $logdir/$scriptname.log
     err_matlab=`grep "Can't start MATLAB engine" $logdir/$scriptname.log`
     echo $err_matlab
     err_abort=`grep "Aborted" $logdir/$scriptname.log`
     echo $err_abort
     if [ "$err_matlab" != "" ]; then
        err_process="Can't start MATLAB engine" 
        echo $err_proces
     fi
     if [ "$err_abort" != "" ]; then
        err_process="Process Aborted"  
        echo $err_process
     fi 
     if [ "$err_matlab" != "" ] || [ "$err_abort" != "" ]; then
        echo " " >> $logdir/$logfile
        echo "$err_process while running $scriptname.exe  "
        echo "$err_process. This ERROR ocurred while running FORTRAN code $scriptname.exe" >> $logdir/$logfile
        echo "The output log from the failed FORTRAN code is located in $logdir/$scriptname.log " >> $logdir/$logfile
        echo " " >> $logdir/$logfile
     exit
fi
   echo "    $scriptname.exe completed"
   echo "    $scriptname.exe completed" >> $logdir/$logfile
cp $archive_monthly/eofmonftp_new.tim $cf_ftpdir/tele_index.nh
cp $archive_monthly/eofmonftp_new.tim $output/.
cp $archive_monthly/monthly_newtele_to_table_E1.tim $output/.
cp $output/*_index.tim $archive_monthly/.
cp $output/*_index.tim $cf_ftpdir/.
echo "Updated Monthly 500-hPa tele indices are" 
tail -2 $archive_monthly/eofmonftp_new.tim 
echo "Updated Monthly 500-hPa tele indices are" >> $logdir/$logfile
tail -2 $archive_monthly/eofmonftp_new.tim >> $logdir/$logfile
#
#Update the new-climo daily teleconnection indices
#
scriptname=oper_daily_tele_indices
     echo " " >> $logdir/$logfile
     echo "   Running $scriptname.exe " >> $logdir/$logfile
$build/$scriptname.exe $archive_daily/eofdayftp_new.tim > $logdir/$scriptname.log
     err_matlab=`grep "Can't start MATLAB engine" $logdir/$scriptname.log`
     echo $err_matlab
     err_abort=`grep "Aborted" $logdir/$scriptname.log`
     echo $err_abort
     if [ "$err_matlab" != "" ]; then
        err_process="Can't start MATLAB engine" 
        echo $err_proces
     fi
     if [ "$err_abort" != "" ]; then
        err_process="Process Aborted"  
        echo $err_process
     fi 
     if [ "$err_matlab" != "" ] || [ "$err_abort" != "" ]; then
        echo " " >> $logdir/$logfile
        echo "$err_process while running $scriptname.exe  "
        echo "$err_process. This ERROR ocurred while running FORTRAN code $scriptname.exe" >> $logdir/$logfile
        echo "The output log from the failed FORTRAN code is located in $logdir/$scriptname.log " >> $logdir/$logfile
        echo " " >> $logdir/$logfile
     exit
fi
   echo "    $scriptname.exe completed"
   echo "    $scriptname.exe completed" >> $logdir/$logfile
   
cp $archive_daily/eofdayftp_new.tim $output/.
echo "Updated Daily 500-hPa tele indices are" 
tail -2 $archive_daily/eofdayftp_new.tim 
echo "Updated Daily 500-hPa tele indices are" >> $logdir/$logfile
tail -2 $archive_daily/eofdayftp_new.tim >> $logdir/$logfile
#
#######################################
# SHUT DOWN MATLAB LICENSE #############
#This command must be commented out if using MATLAB2011
#$CW_MATLAB_LICEN/lmdown
######################################
# Produce Fig. E7 in monthly Climate Diagnostics Bulletin
# telemonc_new.ps plot goes to CF data archive directory. 
# telemonc_new.gif plot goes to CF web directory
$gradsdir/grads -bpc "tele_indices_fige7_cdb.gs $index_monthly_ctl $output"
cd $output
$library/draw_2_ps.scr telemonc_new
$library/convert -crop 0x0 telemonc_new.ps telemonc_new.gif
cp telemonc_new.gif $cf_webdir/.
cp telemonc_new.ps $archive_monthly/.
echo "Fig. E7 for CDB has been plotted" >> $logdir/$logfile
##-------------------------
## update the WEB historical monthly time series for all teleconnection indices
## Send the .gif plots to the CF web directory
##
cd $scriptdir
$gradsdir/grads -blc "monthly_tele_timeseries_eofnew.gs $index_monthly_ctl $output"
cd $output
cp *.gif $cf_webdir/.
echo "Tele time series for the web have been plotted" >> $logdir/$logfile
#
#
   end_time=`date`
   echo "*** Successful Teleconnections Process completed at $end_time***" 
   echo "*** Successful Teleconnections Process completed at $end_time***" >> $logdir/$logfile

else

   end_time=`date`
   echo "******The CDB Monthly Teleconnections Update Process Aborted at $end_time"
   echo "The monthly data grids were not available"
   echo "******The CDB Monthly Teleconnections Update Process Aborted at $end_time">> $logdir/$logfile
   echo "The monthly CDAS data grids were not available" >> $logdir/$logfile
fi

