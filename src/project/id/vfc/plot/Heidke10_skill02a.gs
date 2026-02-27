#-----/u/Zeng-Zhen.Hu/nfs/WorkGroup/CFSV2skill/Prec/Heidke10_skill02a.gs
# Heidke10 seasonal obs and CFSv2 hindcasts
#
rm tmp2.gs
cat << EOR > tmp2.gs
*-----------------------------------------------------------
'c'
'reinit'
'open Heidke10_skill02.ctl'
'open /u/Zeng-Zhen.Hu/gpfs/WorkGroup_CFSv2/Prec/land.mask.global.gri1.000m.lnx.ctl'
'run /u/Zeng-Zhen.Hu/save/grads/lib/rgbset2.gs'
'enable print Heidke10_skill02a.met'
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
'set xlab off'
'set ylab on'
*'set yflip on'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set t 'z0
'set z 'Lead
'set xlint 30'
'set ylint 10'

'set parea 0.5 2.9 6.5 8.0'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

*'set gxout contour'
*'set clevs 0.5'
*'set ccols 1'
*'set cthick 6'
*'set ccols 1'
*'d Heidke10'

'set string 1 c 3 00'
'set strsiz 0.11 0.11'
'draw string 5.5 8.40 Seasonal Prec Heidke (10 Deciles) Score (%) of CFSv2 Forecasts (CAMS; Jan1982-Dec2015, 'Lead0' Month Lead)'
'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 1.7 8.15 (a) Jan'

'set string 1 c 3 0'
'run /u/Zeng-Zhen.Hu/save/grads/lib/cbarn.gs 0.80 0 5.5 0.65'

'set strsiz 0.07 0.07'
'set string 1 c 3 0'
'draw string 5.9 0.15 /u/Zeng-Zhen.Hu/nfs/WorkGroup/CFSV2skill/Prec/Heidke10_skill02.scr&Heidke10_skill02a.gs'
'print'

*-------------------------------figure A2-------------------
z0=2

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 3.0 5.4 6.5 8.0'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 4.2 8.15 (b) Feb'
'print'

*-------------------------------figure A3-------------------
z0=3

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 5.5 7.9 6.5 8.0'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 6.7 8.15 (c) Mar'
'print'

*-------------------------------figure A4-------------------
z0=4

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab on'
'set ylpos 0.0 r'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 8.0 10.4 6.5 8.0'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 9.2 8.15 (d) Apr'
'print'

*-------------------------------figure B1-------------------
z0=5

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab on'
'set ylpos 0.0 l'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 0.5 2.9 4.7 6.2'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 1.7 6.35 (e) May'
'print'

*-------------------------------figure B2-------------------
z0=6

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 3.0 5.4 4.7 6.2'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 4.2 6.35 (f) Jun'
'print'

*-------------------------------figure B3-------------------
z0=7

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 5.5 7.9 4.7 6.2'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 6.7 6.35 (g) Jul'
'print'

*-------------------------------figure B4-------------------
z0=8

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab on'
'set ylpos 0.0 r'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 8.0 10.4 4.7 6.2'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 9.2 6.35 (h) Aug'
'print'

*-------------------------------figure C1-------------------
z0=9

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab on'
'set ylpos 0.0 l'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 0.5 2.9 2.9 4.4'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 1.7 4.55 (i) Sep'
'print'

*-------------------------------figure C2-------------------
z0=10

'set vpage off'
'set frame on'
'set grads off'
'set xlab off'
'set ylab off'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 'z0
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 3.0 5.4 2.9 4.4'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 4.2 4.55 (j) Oct'
'print'

*-------------------------------figure D1-------------------
z0=11

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

'set parea 0.5 2.9 1.1 2.6'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 1.7 2.75 (k) Nov'
'print'

*-------------------------------figure D2-------------------
z0=12

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

'set parea 3.0 5.4 1.1 2.6'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(Heidke10,land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 4.2 2.75 (l) Dec'
'print'

*-------------------------------figure F-------------------
* Jan-Dec mean

'set vpage off'
'set frame on'
'set grads off'
'set xlab on'
'set ylab on'
'set ylpos 0.0 r'
'set mproj scaled'
'set lon 'lon1' 'lon2
'set lat 'lat1' 'lat2
'set z 1'
'set t 'Lead
'set xlint 30'
'set ylint 10'

'set parea 5.5 10.4 1.1 4.4'
'set gxout shaded'
'set clevs  -4  -2  2   4   6  8  10 12'
'set ccols 47  43  0  23  24 25 26 28 29'
'd maskout(ave(Heidke10,z=1,z=12),land.2(z=1,t=1)-0.5)'

'set strsiz 0.10 0.10'
'set string 1 c 3 00'
'draw string 8.1 4.55 (m) Mean Of Jan-Dec'
'print'

'printim Heidke10_skill02a.jpg jpg white'
*'printim Heidke10_skill02a.gif gif white'
'disable print'
pull dummy
'quit'
EOR
#/usrx/local/grads/bin/2.0.a3/xgrads -lc "run tmp2.gs"
grads -lc "run tmp2.gs"

#gxeps -c -i Heidke10_skill02a.met -o Heidke10_skill02a.eps
rm tmp2.gs Heidke10_skill02a.met

scp Heidke10_skill02.scr hzz@cpc-ls-work1:/cpc/home/hzz/WorkGroup/skillCFSv2/Prec/.
scp Heidke10_skill02a.jpg hzz@cpc-ls-work1:/cpc/home/hzz/WorkGroup/skillCFSv2/Prec/.
scp Heidke10_skill02a.gs hzz@cpc-ls-work1:/cpc/home/hzz/WorkGroup/skillCFSv2/Prec/.
