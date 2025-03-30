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
for var in prec; do
#for var in prec hgt t2m; do
#
nts=1  # 2005
nte=`expr $nts + 43 - 1` # mid-mon of the latest season
#
#outfile1=$version.$var.hcst.mam1981-fma2024
#outfile2=$version.$var.hcst_skill.mam1981-fma2024
outfile1=$version.$var.hcst.mam1981-fma2024.test
outfile2=$version.$var.hcst_skill.mam1981-fma2024.test
#
imx=360
jmx=180
undef=-999.0
#=======================================
# have hcst data
#=======================================
for ii in "${!dirs[@]}"; do 
dir="${dirs[$ii]}"
cat>"$ii.ctl"<<EOF
dset ${dir}/$version.hcst.ensmsynth.$var.mlead7.3mon.test.gr
undef -999.0
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear mar1981 1mo
zdef  01 levels 1
edef  7 names 1 2 3 4 5 6 7
vars 6
o  1 99 obs
p  1 99 hcst
pr 1 99 prob hcst
pa 1 99 prob_a
pb 1 99 prob_b
s  1 99 std of obs
ENDVARS
EOF

done

cat >have_hcst<<EOF
run hcst_data.gs
EOF
#
cat >hcst_data.gs<<EOF
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
*say 'it=' it
im=1
while ( im <= 12)
*say 'im=' im
'd o.'im
'd p.'im
'd s.'im
'd pa.'im
'd pb.'im
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
vars 5
o  0 99 obs
p  0 99 hcst
s  0 99 stdo
pa 0 99 prob_A
pb 0 99 prob_B
ENDVARS
EOF

/usr/bin/grads -bl <have_hcst

#=======================================
# have hcst skill
#=======================================
for ii in "${!dirs[@]}"; do 
dir="${dirs[$ii]}"
cat>"$ii.ctl"<<EOF
dset ${dir}/$version.skill_1d.ensmsynth.$var.mlead7.3mon.test.gr
undef -999.0
xdef 1 linear 0.5 1.
ydef 1 linear -89.5 1.
zdef 1 linear 1 1
tdef 43 linear dec1981 1yr
edef 7 names 1 2 3 4 5 6 7
vars 8
cor1   1 99 20N-70N sp_cor
rms1   1 99 20N-70N sp_rms
cor2   1 99 CONUS sp_cor
rms2   1 99 CONUS sp_rms
hss1   1 99 20N-70N sp_hss
hss2   1 99 CONUS sp_hss
rpss1   1 99 20N-70N rpss_s
rpss2   1 99 CONUS rpss_s
ENDVARS
EOF

done

cat >have_skill<<EOF
run hcst_skill.gs
EOF
#
cat >hcst_skill.gs<<EOF
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

'set gxout fwrite'
'set fwrite $outfile2.gr'

it=$nts
while ( it <= $nte)

'set t 'it
say 'it=' it
im=1
while ( im <= 12)
*say 'im=' im
'd cor1.'im
'd cor2.'im
'd hss1.'im
'd hss2.'im
'd rpss1.'im
'd rpss2.'im
im=im+1
endwhile

it=it+1
endwhile
EOF

cat>$outfile2.ctl<<EOF
dset $outfile2.gr
undef -9.99e+08
xdef 1 linear 0.5 1.
ydef 1 linear -89.5 1.
zdef 1 linear 1 1
tdef 999 linear mar1981 1mo
edef 7 names 1 2 3 4 5 6 7
vars 6
cor1  0 99 cor for NH_ML
cor2  0 99 cor for CONUS
hss1  0 99 hss for NH_ML
hss2  0 99 hss for CONUS
rpss1  0 99 rpss for NH_ML
rpss2  0 99 rpss for CONUS
ENDVARS
EOF

/usr/bin/grads -bl <have_skill

done  # for var
