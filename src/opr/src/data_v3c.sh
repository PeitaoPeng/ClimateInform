#r
!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp
outdir=/home/ppeng/data/pcr_prd
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
#======================================
# have SST IC
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#
if [ $curmo = 01 ]; then cmon=1; icmon_end=dec; icmoe=12; icmon_mid=nov; icssnmb=10; fi #icmon_mid: mid mon of icss
if [ $curmo = 02 ]; then cmon=2; icmon_end=jan; icmoe=01 ; icmon_mid=dec; icssnmb=11; fi #icssnmb: 1st mon of icss
if [ $curmo = 03 ]; then cmon=3; icmon_end=feb; icmoe=02 ; icmon_mid=jan; icssnmb=12 ; fi
if [ $curmo = 04 ]; then cmon=4; icmon_end=mar; icmoe=03 ; icmon_mid=feb; icssnmb=1 ; fi
if [ $curmo = 05 ]; then cmon=5; icmon_end=apr; icmoe=04 ; icmon_mid=mar; icssnmb=2; fi
if [ $curmo = 06 ]; then cmon=6; icmon_end=may; icmoe=05 ; icmon_mid=apr; icssnmb=3; fi
if [ $curmo = 07 ]; then cmon=7; icmon_end=jun; icmoe=06 ; icmon_mid=may; icssnmb=4; fi
if [ $curmo = 08 ]; then cmon=8; icmon_end=jul; icmoe=07 ; icmon_mid=jun; icssnmb=5; fi
if [ $curmo = 09 ]; then cmon=9; icmon_end=aug; icmoe=08 ; icmon_mid=jul; icssnmb=6; fi
if [ $curmo = 10 ]; then cmon=10; icmon_end=sep; icmoe=09 ; icmon_mid=aug; icssnmb=7; fi
if [ $curmo = 11 ]; then cmon=11; icmon_end=oct; icmoe=10; icmon_mid=sep; icssnmb=8; fi
if [ $curmo = 12 ]; then cmon=12; icmon_end=nov; icmoe=11; icmon_mid=oct; icssnmb=9; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
#
icmomidyr=$icmon_mid$yyyy
if [ $cmon -le 2 ]; then icmomidyr=$icmon_mid$yyym; fi
#
icseason=$icssnmb  # jfm=1
#
yrn=`expr $curyr - 1948` # total full years,=68 for 1948-2015
if [ $cmon = 1 ]; then yrn=`expr $yyym - 1948`; fi
mmn=`expr $yrn \* 12`
#
tmax=`expr $mmn + $icmoe` # 816=dec2015
#
nyear=`expr $curyr - 1948`  # total full year data used for CA
if [ $cmon -le 2 ]; then nyear=`expr $curyr - 1948 - 1`; fi # for having 12 3-mon avg data for past year
#
icyr=$curyr
if [ $icmoe = 12 ]; then icyr=`expr $curyr - 1`; fi
#
dirs=(
"/home/ppeng/data/ss_fcst/pcr/2024/1"
"/home/ppeng/data/ss_fcst/pcr/2024/2"
"/home/ppeng/data/ss_fcst/pcr/2024/3"
"/home/ppeng/data/ss_fcst/pcr/2024/4"
"/home/ppeng/data/ss_fcst/pcr/2024/5"
"/home/ppeng/data/ss_fcst/pcr/2024/6"
"/home/ppeng/data/ss_fcst/pcr/2024/7"
"/home/ppeng/data/ss_fcst/pcr/2024/8"
"/home/ppeng/data/ss_fcst/pcr/2024/9"
"/home/ppeng/data/ss_fcst/pcr/2024/10"
"/home/ppeng/data/ss_fcst/pcr/2024/11"
"/home/ppeng/data/ss_fcst/pcr/2024/12"
)
#
#======================================
# define some parameters
#======================================
#
version=cvcor
for var in t2m prec; do
#for var in prec hgt t2m; do
#
nts=1  # 2005
nte=`expr $nts + 43 - 1` # mid-mon of the latest season
#
outfile1=$version.$var.v3c.mam1981-fma2024
#
imx=360
jmx=180
undef=-999.0
#=======================================
# have obs data
#=======================================
for ii in "${!dirs[@]}"; do 
dir="${dirs[$ii]}"
cat>"$ii.ctl"<<EOF
dset ${dir}/$version.obs_3c.ensmsynth.$var.mlead7.3mon.gr
undef -999.0
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear mar1981 1mo
zdef  01 levels 1
edef  7 names 1 2 3 4 5 6 7
vars 2
obs   1 99 obs
o3c   1 99 3C obs
ENDVARS
EOF

done

cat >have_obs<<EOF
run obs_data.gs
EOF
#
cat >obs_data.gs<<EOF
'reinit'
'open 0.ctl'
'open 1.ctl'
'open 2.ctl'
'open 3.ctl'
'open 4.ctl'
'open 5.ctl'
'open 6.ctl'
'open 7.ctl'
'open 8.ctl'
'open 9.ctl'
'open 10.ctl'
'open 11.ctl'

'set x 1 $imx'
'set y 1 $jmx'

'set gxout fwrite'
'set fwrite $outfile1.gr'

it=$nts
while ( it <= $nte)

'set t 'it
say 'it=' it
im=1
while ( im <= 12)
*say 'im=' im
'd obs.'im
'd o3c.'im
im=im+1
endwhile

it=it+1
endwhile
EOF

cat>$outfile1.ctl<<EOF
dset $outfile1.gr
undef -9.99e+08
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear mar1981 1mo
zdef  01 levels 1
vars 2
obs  0 99 obs
o3c  0 99 obs
ENDVARS
EOF

/usr/bin/grads -bl <have_obs

done  # for var
