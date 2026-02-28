#crontab on ppeng workstation is Estern Time (ET)
MAILTO=peitaopeng@hotmail.com

# Data ftp & process
00 16 6 * * bash /home/ppeng/ClimateInform/src/opr/src/ftp_data.sh > /home/ppeng/data/downloads/0log1 2>&1
00 17 6 * * bash /home/ppeng/ClimateInform/src/opr/data_proc/run.data_process.sh > /home/ppeng/ClimateInform/src/opr/data_proc/0log1 2>&1
# seasonal prd
00 18 6 * * /home/ppeng/ClimateInform/src/opr/src/run.fcst.sh > /home/ppeng/ClimateInform/src/opr/src/0log1 2>&1
# update source files to github
0 2 * * * /home/ppeng/save/update_save_repo_periodically.sh > /home/ppeng/save/0log1 2>&1
