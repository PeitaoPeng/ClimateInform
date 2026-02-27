copied from /u/wx52ww/crons 
(0) rlogin s1n1 to go to a specific node on snow
(1) use crontab -e to edit a crontab file
(2) use crontab -r to remove a crontab job

example:
to run script at 8:01AM, use
01 08 * * * /nfsuser/g03/wx52ww/CFSfcst/Realtime/0SubmitDailyUpdate.sh 1>/dev/null 2>/dev/null


