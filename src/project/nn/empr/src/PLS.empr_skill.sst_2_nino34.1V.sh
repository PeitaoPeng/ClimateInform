#!/bin/sh

set -eaux

#=========================================================
# ANN empr forecast of NINO3.4 
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/empr/src
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir=/cpc/home/wd52pp/data/nn/empr
#
cd $tmp
#
for var in sst d20 sl ssttdc; do
#for var in sst d20; do
#for nmod in 3 5 7 9 11 13 15; do
for nmod in 3 5; do
#
model=pls
#var=sst
nlead=9
nyr=41
#nmod=3 #11 for sst alone
#
nfld=`expr $nmod + 1` # +1 for putting obs nino34
#
imx=144
jmx=73
#
for tgtss in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
#for tgtss in djf; do

if [ $tgtss == jfm ]; then itgtbgn=13; ssn=1; fi
if [ $tgtss == fma ]; then itgtbgn=14; ssn=2; fi
if [ $tgtss == mam ]; then itgtbgn=15; ssn=3; fi
if [ $tgtss == amj ]; then itgtbgn=16; ssn=4; fi
if [ $tgtss == mjj ]; then itgtbgn=17; ssn=5; fi
if [ $tgtss == jja ]; then itgtbgn=18; ssn=6; fi
if [ $tgtss == jas ]; then itgtbgn=19; ssn=7; fi
if [ $tgtss == aso ]; then itgtbgn=20; ssn=8; fi
if [ $tgtss == son ]; then itgtbgn=21; ssn=9; fi
if [ $tgtss == ond ]; then itgtbgn=22; ssn=10; fi
if [ $tgtss == ndj ]; then itgtbgn=23; ssn=11; fi
if [ $tgtss == djf ]; then itgtbgn=24; ssn=12; fi

ld=1
while  [ $ld -le $nlead ]
do
/bin/rm fort.*
#
# pick up tgt nino34 and predictor IC month data
#
cat > pick.f << eof
      program pickdata
      parameter(nt=$nyr,ld=$ld)
      parameter(itgtbgn=$itgtbgn)
      parameter(imx=$imx,jmx=$jmx)
c
      dimension xn34(nt),xsst(imx,jmx,nt)
      dimension w2d(imx,jmx),w2d2(imx,jmx)
      dimension w2d3(imx,jmx),w2d4(imx,jmx)
c
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
c
      ir1=itgtbgn
      ir2=itgtbgn-ld-1 ! -1 is for the 1st to be 1mon-lead
      do it=1,$nyr
        read(11,rec=ir1) xn
        read(12,rec=ir2) w2d

        write(21,rec=it) xn
        write(22,rec=it) w2d
        
       ir1=ir1+12
       ir2=ir2+12
      enddo !it loop
c
      stop
      end
eof
 gfortran -o pick.x pick.f
 ln -s $datadir/hadoi.nino34.3mon.1979-curr.gr   fort.11
 ln -s $datadir/obs.$var.mon.1979-curr.gr       fort.12
 ln -s obs.n34.gr                     fort.21
 ln -s obs.$var.gr                   fort.22
 pick.x
#
cat>obs.n34.ctl<<EOF
dset ^obs.n34.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1980 1yr
vars 1
o    1 99 model fcst
ENDVARS
EOF
#
##=====================================
## PLS nino34 hcst
##=====================================
#
infile1=obs.n34.gr
infile2=obs.$var.gr
outfile1=pls.ld$ld
#
cat > parm.h << eof
       parameter(nyr=$nyr,iskip=0)
       parameter(im=$imx,jm=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 20S-20N
       parameter(mode=$nmod, ID=1)
eof
cat>pls.f<<EOF
      include "parm.h"
c
      real*4 ots(nyr),f1(nyr),f2(nyr)
      real*4 w2d(im,jm),w2d2(im,jm)
      real*4 w3din(im,jm,nyr),wic(im,jm)
      real*4 xlat(jm),cosl(jm)
      real*4 pc(nyr-1,mode),pat(im,jm,mode),pat2(im,jm,mode)
      real*4 var(mode),corr(mode),pcprd(nyr),pco(mode)
      real*4 w1d(nyr-1),w1d2(nyr-1),w3d(im,jm,nyr-1)
      real*4 vart(nyr),avg(nyr)
      real*4 pcd(nyr,mode)
c
c sst data
      open(11,
     1file='$infile1',
     2access='direct',form='unformatted',recl=4)
      open(12,
     1file='$infile2',
     2access='direct',form='unformatted',recl=im*jm*4)
c
      open(21,
     1file='$outfile1.bi',
     2access='direct',form='unformatted',recl=4)

      PI=4.*atan(1.)
      CONV=PI/180.
      do j=1,jm
        xlat(j)=-90+(j-1)*2.5
      enddo

      do j=1,jm
        cosl(j)=COS(xlat(j)*CONV)
      enddo
c
c read in data
      write(6,*) 'read in data'
c
      do iy=1,nyr
        read(11,rec=iy) ots(iy)
        read(12,rec=iy) w2d
        do i=1,im
        do j=1,jm
          w3din(i,j,iy)=w2d(i,j)
        enddo
        enddo
c     print *, ' ots(iy)=',ots(iy)
c     print *, ' w2d(181,91)=',w2d(181,91)
      enddo
c
c hcst start
      DO ity=1,nyr

        it=0
        do iy=1,nyr

        if(iy.eq.ity) go to 100
        it=it+1
          w1d(it)=ots(iy)
        do i=1,im
        do j=1,jm
          w3d(i,j,it)=w3din(i,j,iy)
        enddo
        enddo

100     continue
        enddo !iy loop

        do i=1,im
        do j=1,jm
          wic(i,j)=w3din(i,j,ity)
        enddo
        enddo

      call anom(w1d,nyr-1,av)
      avg(ity)=av
c
c anom input data w3d
      do i=1,im
      do j=1,jm
        if(abs(w3d(i,j,1)).lt.999) then

        do iy=1,nyr-1
          w1d2(iy)=w3d(i,j,iy)
        enddo

        call anom(w1d2,nyr-1,av)
        do iy=1,nyr-1
          w3d(i,j,iy)=w1d2(iy)
        enddo

        wic(i,j)=wic(i,j)-av

        endif
      enddo
      enddo

      call pls_hcst(nyr-1,im,jm,is,ie,js,je,mode,
     &w1d,w3d,wic,pc,pco,pat,pat2,var,cosl,undef,ID)
c
c     print *, ' var(m)=',var
c
c compose pcprd for targetyr
      pcprd(ity)=0.
      vart(ity)=0.
      do m=1,mode
        pcprd(ity)=pcprd(ity)+pco(m)
        vart(ity)=vart(ity)+var(m)
      enddo
c
      ENDDO !ity loop
c
c     print *, ' vart=',vart
c
c cor and explained variance
        call cor_reg(nyr,pcprd,ots,cort,reg)
c
      vartot=cort*cort
c     write(6,*) 'vartot=',vartot
      write(6,*) 'hcst cor=',cort
c write out
      iw=0
      do it=1,nyr
        iw=iw+1
        write(21,rec=iw) ots(it)
        iw=iw+1
        write(21,rec=iw) pcprd(it)
      enddo
      write(6,*) 'obs34=',ots

      stop
      end
c
c========================
      subroutine anom(ts,nt,avg)
      dimension ts(nt)
        av=0
        do i=1,nt
          av=av+ts(i)
        end do
        avg=av/float(nt)
        do i=1,nt
          ts(i)=ts(i)-avg
        end do
      return
      end
ccccccccccccccccccccccc
EOF
#
cp $lcdir/pls_hcst.s.f pls.s.f
#
 gfortran -o pls.x pls.s.f pls.f
#
 pls.x
#
cat>pls.ld$ld.ctl<<EOF
dset ^pls.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $nyr linear jan1980 1yr
vars  2
o     1 99 obs nino34
p     1 99 prd
endvars
#
EOF
#
# calculate skill of OBS
#
cat >have_skill<<EOF
run skill.gs
EOF
cat >skill.gs<<EOF
ts=2
te=40
'reinit'
'open obs.n34.ctl'
'open pls.ld$ld.ctl'
'set gxout fwrite'
'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t='ts',t='te'))'
'define pp=sqrt(ave(p.2*p.2,t='ts',t='te'))'
'define ac=ave(o*p.2,t='ts',t='te')/(oo*pp)'
'define rms=sqrt(ave((o-p.2)*(o-p.2),t='ts',t='te'))'
'd ac'
'd rms'
EOF
#
/usr/local/bin/grads -bl <have_skill
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

mv skill.1 acrms.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat acrms.$ldm  skill.$ld > acrms.$ld

\rm acrms.$ldm

ld=$(( ld+1 ))
done  # for ld
#
mv acrms.$nlead sk.$ssn

done  # for tgtseason
#=========================================
# cat skill of all season together
#=========================================
mv sk.1 ac.1
ss=2
while  [ $ss -le 12 ]
do
ssm=$((ss-1))

cat ac.$ssm  sk.$ss > ac.$ss

\rm ac.$ssm
\rm sk.$ss

ss=$(( ss+1 ))
done  # for ss
#
mv ac.12 $datadir/skill.$model.1V.${var}_2_nino34.nmod${nmod}.gr

cat>$datadir/skill.$model.1V.${var}_2_nino34.nmod${nmod}.ctl<<EOF
dset ^skill.$model.1V.${var}_2_nino34.nmod${nmod}.gr
undef -9.99e+33
*
TITLE model
*
XDEF  1 LINEAR    0.  2.5
YDEF  1 LINEAR  -90.  2.5
zdef  1 linear 1 1
tdef $nlead linear jan1980 1mon
edef 12 names 1 2 3 4 5 6 7 8 9 10 11 12
vars 2
ac  1 99 ac of ann
rms 1 99 rms of ann
ENDVARS
EOF
#
#
done
done
