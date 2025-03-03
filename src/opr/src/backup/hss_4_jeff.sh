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
#======================================
# define some parameters
#======================================
#
version=cvcor
for var in t2m prec; do
#for var in prec hgt t2m; do
#
nt=158  #jfm2011 -> fma2024
#
infile1=$version.$var.prob_A.JFM2011-FMA2024
infile2=$version.$var.prob_B.JFM2011-FMA2024
infile3=$var.OBS_3C.JFM2011-FMA2024

outfile1=$version.hss.$var.JFM2011-FMA2024
#
imx=360
jmx=180
undef=-999.0
#=======================================

cat > parm.h << EOF
      parameter(nt=$nt)
      parameter(imx=$imx,jmx=$jmx)
EOF
cat > hss_skill.f << EOF
      program hss_skill
      include "parm.h"
      dimension pa(imx,jmx,nt),pb(imx,jmx,nt),pn(imx,jmx,nt)
      dimension o3(imx,jmx,nt)
      dimension w2d(imx,jmx,nt),w3d2(imx,jmx,nt),w2d3(imx,jmx,nt)
      dimension w1d(3)
      dimension ts1(nt),ts2(nt)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4*nt)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C
C read obs & model data
      do it=1,nt
        read(11,rec=it) w2d
        read(12,rec=it) w2d2d
        read(13,rec=it) w2d3
        do i=1,imx
        do j=1,jmx
           pa(i,j,it)=w2d(i,j)
           pb(i,j,it)=w2d2(i,j)
           o3(i,j,it)=w2d3(i,j)
        enddo
        enddo

       ir1=ir1+12
       ir2=ir2+12
      enddo !it loop
EOF
cp $lcdir/reof.s.f reof.s.f
cp $lcdir/pls_tmarch.s.f  pls.s.f
#
 gfortran -o prd.x reof.s.f pls.s.f pls.f
 ln -s $datadir1/$var1.$var1_tp.${byear}-curr.1x1.gr fort.10
 ln -s $datadir1/$var2.${byear}_cur.$var2_tp.1x1.gr  fort.20
#
 ln -s acrms.$ld                           fort.30
 ln -s spcor.$ld                           fort.40
 ln -s prdmp.$ld                           fort.50

 ln -s eofv2.ld$ld.gr                      fort.51
 ln -s pcv2.ld$ld.gr                       fort.52

 ln -s ptnv1.ld$ld.gr                      fort.53

 ln -s pls_skill.${var1}_2_${var2}.$tgtss.ld$ld.txt fort.60

 prd.x

cat>$outfile1.ctl<<EOF
dset $outfile1.bi
undef -9.99e+08
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear jan2011 1mo
zdef  01 levels 1
vars 1
pa  0 99 prob_a
ENDVARS
EOF

cat>$outfile2.ctl<<EOF
dset $outfile2.bi
undef -9.99e+08
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear jan2011 1mo
zdef  01 levels 1
vars 1
pb  0 99 prob_b
ENDVARS
EOF

cat>$outfile3.ctl<<EOF
dset $outfile3.bi
undef -9.99e+08
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear jan2011 1mo
zdef  01 levels 1
vars 1
o3c  0 99 o3c
ENDVARS
EOF

/usr/bin/grads -bl <have_hcst

done  # for var
