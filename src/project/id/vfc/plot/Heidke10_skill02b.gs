#-----/u/Zeng-Zhen.Hu/nfs/WorkGroup/CFSV2skill/Prec/Heidke10_skill02b.gs
# Lead 0-8 Month of Mean of Jan-Dec
# Heidke (10 Deciles) skill of Seasonal CFSv2 hindcasts
#
rm tmp2.gs
cat << EOR > tmp2.gs
*-----------------------------------------------------------
'c'
'reinit'
'open Heidke10_skill02.ctl'
'open /u/Zeng-Zhen.Hu/gpfs/WorkGroup_CFSv2/Prec/land.mask.global.gri1.000m.lnx.ctl'
'run /u/Zeng-Zhen.Hu/save/grads/lib/rgbset2.gs'
'enable print Heidke10_skill02b.met'
*----------------------------------------------------------
lat1=23.0
lat2=72.0
lon1=360.0-170
lon2=360.0-60

*-------------------------------figure A1-------------------
Lead=1
Lead0=Lead-1
z0=1

'set dfile 1'
'set vpage off'
'set frame on'
'set grads off'
'set cterp off'
'set xlab on'
'set ylab on'
*'set yflip on'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 1.0 4.0 6.0 8.0'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

*'set gxout contour'
*'set clevs 0.5'
*'set ccols 1'
*'set cthick 6'
*'set ccols 1'
*'d cc'

'set string 1 c 3 00'
'set strsiz 0.11 0.11'
'draw string 5.5 8.40 Seasonal Prec Heidke (10 Deciles) Score (%) of FSv2 Forecasts (Jan1982-Dec2015, Jan-Dec Mean)'
'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 2.5 8.15 (a) Lead 'Lead0' Month'

'set string 1 c 3 0'
'run /u/Zeng-Zhen.Hu/save/grads/lib/cbarn.gs 0.80 0 5.5 0.5'

'set strsiz 0.07 0.07'
'set string 1 c 3 0'
'draw string 5.9 0.15 /u/Zeng-Zhen.Hu/nfs/WorkGroup/CFSV2skill/Prec/Heidke10_skill02.scr&Heidke10_skill02b.gs'
'print'

*-------------------------------figure A2-------------------
Lead=2
Lead0=Lead-1

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 4.1 7.1 6.0 8.0'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 5.6 8.15 (b) Lead 'Lead0' Month'
'print'

*-------------------------------figure A3-------------------
Lead=3
Lead0=Lead-1

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 7.2 10.2 6.0 8.0'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 8.7 8.15 (c) Lead 'Lead0' Month'
'print'

*-------------------------------figure B1-------------------
Lead=4
Lead0=Lead-1

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab on'
'set ylpos 0.0 l'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 1.0 4.0 3.5 5.5'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 2.5 5.65 (d) Lead 'Lead0' Month'
'print'

*-------------------------------figure B2-------------------
Lead=5
Lead0=Lead-1

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 4.1 7.1 3.5 5.5'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 5.6 5.65 (e) Lead 'Lead0' Month'
'print'

*-------------------------------figure B3-------------------
Lead=6
Lead0=Lead-1

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 7.2 10.2 3.5 5.5'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 8.7 5.65 (f) Lead 'Lead0' Month'
'print'

*-------------------------------figure C1-------------------
Lead=7
Lead0=Lead-1

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab on'
'set ylpos 0.0 l'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 1.0 4.0 1.0 3.0'
'set gxout shaded'
'set clevs   -4   -2    2     4   6    8    10'
'set ccols 47    43   0    23   24   26   28   29'
'd maskout(ave(heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 2.5 3.15 (g) Lead 'Lead0' Month' 
'print'

'printim Heidke10_skill02b.jpg jpg white'
*'printim Heidke10_skill02b.gif gif white'
'disable print'
pull dummy
'quit'
EOR
#/usrx/local/grads/bin/2.0.a3/xgrads -lc "run tmp2.gs"
grads -lc "run tmp2.gs"

#gxeps -c -i Heidke10_skill02b.met -o Heidke10_skill02b.eps
rm tmp2.gs Heidke10_skill02b.met

scp Heidke10_skill02b.jpg hzz@cpc-ls-work1:/cpc/home/hzz/WorkGroup/skillCFSv2/Prec/.
scp Heidke10_skill02b.gs hzz@cpc-ls-work1:/cpc/home/hzz/WorkGroup/skillCFSv2/Prec/.
