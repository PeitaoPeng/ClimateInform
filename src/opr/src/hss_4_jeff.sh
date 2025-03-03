# skill of the combinded hcst and fcst
!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp
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
version=sim #sim or cvcor
for var in t2m prec; do
#for var in prec hgt t2m; do
#
nt=158  #jfm2011 -> fma2024
#
infile1=$var.OBS_3C.JFM2011-FMA2024
#infile2=$version.$var.prob_A.JFM2011-FMA2024
#infile3=$version.$var.prob_B.JFM2011-FMA2024
infile2=$version.comb.$var.prob_A.JFM2011-FMA2024
infile3=$version.comb.$var.prob_B.JFM2011-FMA2024

#outfile1=$version.hss_1d.$var.JFM2011-FMA2024
#outfile2=$version.$var.prd_3C.JFM2011-FMA2024
#outfile3=$version.hss_2d.$var.JFM2011-FMA2024
outfile1=$version.comb.hss_1d.$var.JFM2011-FMA2024
outfile2=$version.comb.$var.prd_3C.JFM2011-FMA2024
outfile3=$version.comb.hss_2d.$var.JFM2011-FMA2024
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
      dimension pa(imx,jmx,nt),pb(imx,jmx,nt)
      dimension prd(imx,jmx,nt),o3(imx,jmx,nt)
      dimension w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      dimension nw2d(imx,jmx)
      dimension ts0(nt),ts1(nt),ts2(nt)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)

      open(unit=21,form='unformatted',access='direct',recl=4)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=23,form='unformatted',access='direct',recl=4*imx*jmx)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C
C read in data
      do it=1,nt
        read(11,rec=it) w2d
        read(12,rec=it) w2d2
        read(13,rec=it) w2d3
        do i=1,imx
        do j=1,jmx
           o3(i,j,it)=w2d(i,j)
           pa(i,j,it)=w2d2(i,j)
           pb(i,j,it)=w2d3(i,j)
        enddo
        enddo
      enddo !it loop
C
C hss_s from pa & pb
      do it=1,nt

        do i=1,imx
        do j=1,jmx
	   w2d(i,j)=o3(i,j,it)
	   w2d2(i,j)=pa(i,j,it)
	   w2d3(i,j)=pb(i,j,it)
        enddo
        enddo

      call hss3c_prob_s(w2d,w2d2,w2d3,nw2d,imx,jmx,1,360,115,160,
     &coslat,ts1(it))

      write(21,rec=it) ts1(it)

      call hss3c_prob_s(w2d,w2d2,w2d3,nw2d,imx,jmx,1,360,1,180,
     &coslat,ts1(it))

      write(22,rec=it) nw2d

      enddo !it loop
C
C hss_t from pa & pb
      do i=1,imx
      do j=1,jmx

        if(w2d(i,j).gt.-900.and.w2d2(i,j).gt.-900) then

	do it=1,nt
          ts0(it)=o3(i,j,it)
          ts1(it)=pa(i,j,it)
          ts2(it)=pb(i,j,it)
        enddo

        call hss3c_prob_t(ts0,ts1,ts2,nt,nt,w2d(i,j))

       else

        w2d(i,j)=-9.99e+08

       endif

      enddo
      enddo

      write(23,rec=1) w2d

      stop
      end

      SUBROUTINE hss3c_prob_s(obs,pa,pb,nprd,imx,jmx,
     &is,ie,js,je,coslat,hs)
      dimension obs(imx,jmx),pa(imx,jmx),pb(imx,jmx)
      dimension nobs(imx,jmx),nprd(imx,jmx)
      dimension coslat(jmx)
      dimension w1d(3)

      do i=is,ie
      do j=js,je
        if(obs(i,j).gt.-900.and.pa(i,j).gt.-900) then

	  nobs(i,j)=obs(i,j)

          w1d(3)=pa(i,j)
          w1d(1)=pb(i,j)
          w1d(2)=1.- pa(i,j)-pb(i,j)
          maxp = maxloc(w1d,1)

          if(maxp.eq.1) nprd(i,j)=-1
          if(maxp.eq.2) nprd(i,j)=0
          if(maxp.eq.3) nprd(i,j)=1
        else
          nprd(i,j)=-9.99e+08
        endif
      enddo
      enddo

      h=0.
      tot=0.
      do i=is,ie
      do j=js,je
        if(obs(i,j).gt.-900..and.pa(i,j).gt.-900.) then
        tot=tot+coslat(j)
        if (nobs(i,j).eq.nprd(i,j)) h=h+coslat(j)
        endif
      enddo
      enddo
      hs=(h-tot/3.)/(tot-tot/3.)*100.

      return
      end

      SUBROUTINE hss3c_prob_t(obs,pa,pb,ny,nt,hs)
      dimension obs(ny),pa(ny),pb(ny)
      dimension nobs(ny),nprd(ny)
      dimension w1d(3)

      do it=1,nt

c       if(obs(it).gt.0.43) nobs(it)=1
c       if(obs(it).lt.-0.43) nobs(it)=-1
c       if(obs(it).ge.-0.43.and.obs(it).le.0.43) nobs(it)=0

        nobs(it)=obs(it)

        w1d(3)=pa(it)
        w1d(1)=pb(it)
        w1d(2)=1.- pa(it)-pb(it)
        maxp = maxloc(w1d,1)

          if(maxp.eq.3) nprd(it)=1
          if(maxp.eq.1) nprd(it)=-1
          if(maxp.eq.2) nprd(it)=0

      enddo

      h=0.
      tot=0.
      do i=1,nt
      tot=tot+1
      if (nobs(i).eq.nprd(i)) h=h+1
      enddo
      hs=(h-tot/3.)/(tot-tot/3.)*100.
      return
      end
EOF

\rm fort.*
 gfortran -o skill.x hss_skill.f

 ln -s $infile1.bi fort.11
 ln -s $infile2.bi fort.12
 ln -s $infile3.bi fort.13

 ln -s $outfile1.bi fort.21
 ln -s $outfile2.bi fort.22
 ln -s $outfile3.bi fort.23
#
./skill.x

cat>$outfile1.ctl<<EOF
dset $outfile1.bi
undef -9.99e+08
xdef 1 linear  0.5 1
ydef 1 linear 89.5 1
zdef 1 linear 1 1
tdef $nt linear jan2011 1mon
vars  1
hss   1 99 for 20N-70N
endvars
EOF

cat>$outfile2.ctl<<EOF
dset $outfile2.bi
undef -9.99e+08
XDEF 360 LINEAR    0.5  1.0
YDEF 180 LINEAR  -89.5  1.0
tdef 999 linear jan2011 1mo
zdef  01 levels 1
vars 1
f  0 99 forecast in 3 categories
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
hss  0 99 hss_t
ENDVARS
EOF
done  # for var
