#!/bin/sh
######################################################
# calculate HSS in spatial domain, output is time series
# in Oct 2020, set line 30 and 43 back to old setting 
######################################################

set -eaux

lcdir=/cpc/home/wd52pp/project/id/vfc/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir1=/cpc/consistency/id/nmme/hcst
datadir2=/cpc/consistency/id/obs
dataout=/cpc/consistency/id/nmme/skill
#
cd $tmp
#
# define area
is=1
ie=51
js=36
je=115

yrs=1982
yre=2018  # last year
#ntotyr=`expr $yre - $yrs + 1`  # total year for calculating HSS (2012-last yr)
ntotyr=`expr $yre - $yrs`  # total year for calculating HSS (2012-last yr)
oskip=`expr $yrs - 1981`      # skip for obs data
nvyr=`expr $yre - $yrs + 1`   # total year for calculating HSS
nlead=5
for var in tmp2m prate; do
#for var in prate; do
for icmon in jan feb mar apr may jun jul aug sep oct nov dec; do
#for icmon in jan; do
for tmean  in mon ss; do
#
infile1=NMME.$var.$tmean.${icmon}_ic.1982-$yre.ld1-5.esm
infile2=NMME.$var.$tmean.clim_std.${icmon}_ic.1982-2010.ld1-5.esm
infile3=obs.$var.$tmean.${icmon}_ic.1981-$yre.ld1-5
#infile3=obs.$var.$tmean.${icmon}_ic.1981-2018.ld1-5
infile4=obs.$var.$tmean.clim_std.${icmon}_ic.1981-2010

outfile1=HSS.NMME.$var.$tmean.${icmon}_ic.$yrs-$yre.ts

cp $datadir1/$infile1.gr .
cp $datadir1/$infile2.gr .
cp $datadir2/$infile3.gr .
cp $datadir2/$infile4.gr .
#
xdim=360
ydim=181
nlead=5
undef=-9.99e+8
#=======================================
# hss calculation for 2012-last_year
#=======================================
cat >have.hss.f<<EOF
      parameter(im=$xdim,jm=$ydim)
      parameter(undef=$undef)
      parameter(nvy=$nvyr,nld=$nlead)
      parameter(is=$is,ie=$ie,js=$js,je=$je)
c
      real*4 w1d1(nvy),w1d2(nvy),w1d3(nvy)
      real*4 w2d(im,jm),w2d2(im,jm)
      real*4 clmo(im,jm,nld),clmf(im,jm,nld)
      real*4 stdo(im,jm,nld),stdf(im,jm,nld)
      real*4 fldo(im,jm,nvy,nld),fldf(im,jm,nvy,nld)
      dimension mfo(im,jm,nvy,nld),mff(im,jm,nvy,nld)
      dimension m2d1(im,jm),m2d2(im,jm)
c
      open(11,
     &file='$infile1.gr',
     &access='direct',form='unformatted',recl=im*jm*4)
      open(12,
     &file='$infile2.gr',
     &access='direct',form='unformatted',recl=im*jm*4)
      open(13,
     &file='$infile3.gr',
     &access='direct',form='unformatted',recl=im*jm*4)
      open(14,
     &file='$infile4.gr',
     &access='direct',form='unformatted',recl=im*jm*4)
C
      open(20,
     &file='$outfile1.gr',
     &access='direct',form='unformatted',recl=4)

c read in f&o data
      nskipo=${oskip}*nld

      iro=nskipo+1
      irf=1

      do iy=1,nvy
      do il=1,nld

      read(11,rec=irf) w2d
      read(13,rec=iro) w2d2

        do i=1,im
        do j=1,jm
          fldf(i,j,iy,il)=w2d(i,j)
          fldo(i,j,iy,il)=w2d2(i,j)
        enddo
        enddo

      iro=iro+1
      irf=irf+1

      enddo
      enddo

c read in clm and std data
      ir=1
      do il=1,nld
        read(12,rec=ir) w2d
        read(14,rec=ir) w2d2
        do i=1,im
        do j=1,jm
          clmf(i,j,il)=w2d(i,j)
          clmo(i,j,il)=w2d2(i,j)
        enddo
        enddo
        ir=ir+1
        read(12,rec=ir) w2d
        read(14,rec=ir) w2d2
        do i=1,im
        do j=1,jm
          stdf(i,j,il)=w2d(i,j)
          stdo(i,j,il)=w2d2(i,j)
        enddo
        enddo
      ir=ir+1
      enddo

c normalizing anomalies
      
      do iy=1,nvy
      do il=1,nld

      do i=1,im
      do j=1,jm
      if(abs(clmo(i,j,1)).lt.999) then
        fldf(i,j,iy,il)=(fldf(i,j,iy,il)-clmf(i,j,il))/stdf(i,j,il)
        fldo(i,j,iy,il)=(fldo(i,j,iy,il)-clmo(i,j,il))/stdo(i,j,il)
      else
        fldf(i,j,iy,il)=undef
        fldo(i,j,iy,il)=undef
      endif
      enddo
      enddo

      enddo
      enddo

c convert to categorical numbe -1 0 -1
      aa=0.43
      bb=-0.43
      iw=1
      do iy=1,nvy
      do il=1,nld

      do i=1,im
      do j=1,jm
      if(abs(clmo(i,j,1)).lt.999) then
       if (fldf(i,j,iy,il).lt.bb) mff(i,j,iy,il)=-1
       if (fldf(i,j,iy,il).gt.aa) mff(i,j,iy,il)= 1
       if (fldf(i,j,iy,il).le.aa.and.fldf(i,j,iy,il).ge.bb) 
     & mff(i,j,iy,il)=0

       if (fldo(i,j,iy,il).lt.bb) mfo(i,j,iy,il)=-1
       if (fldo(i,j,iy,il).gt.aa) mfo(i,j,iy,il)= 1
       if (fldo(i,j,iy,il).le.aa.and.fldo(i,j,iy,il).ge.bb) 
     & mfo(i,j,iy,il)=0
      else
       mff(i,j,iy,il)=undef
       mfo(i,j,iy,il)=undef
      endif
      enddo
      enddo

      enddo
      enddo

c have hss
      iw=0
      do iy=1,nvy
      do il=1,nld

      do i=1,im
      do j=1,jm
      if(abs(clmo(i,j,1)).lt.999) then
        m2d1(i,j)=mff(i,j,iy,il)
        m2d2(i,j)=mfo(i,j,iy,il)
      else
        m2d2(i,j)=999
      endif
      enddo ! i loop
      enddo ! j loop

        call hss_s(m2d1,m2d2,hs,im,jm,is,ie,js,je)

      iw=iw+1
      write(20,rec=iw) hs

      enddo ! il loop
      enddo ! iy loop

      STOP  
      END
c====================================

      subroutine hss_s(mw1,mw2,hs,n,m,is,ie,js,je)
      dimension mw1(n,m),mw2(n,m)

      h=0.
      ng=0
      do i=is,ie
      do j=js,je
        if(abs(mw2(i,j)).lt.900) then
        ng=ng+1
        if (mw1(i,j).eq.mw2(i,j)) h=h+1
        endif
      enddo
      enddo
      tot=float(ng)
      hs=100.*(h-tot/3.)/(tot-tot/3.)
      return
      end
EOF
#
gfortran -o hss.x have.hss.f
echo "done compiling"
./hss.x
#
mv $outfile1.gr $dataout

cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  1 LINEAR    0.  1.0
YDEF  1 LINEAR  -90.  1.0
zdef  1 linear 1 1
tdef 999 linear $icmon$yrs 1yr
vars  5
h1  1 99 1-mon lead
h2  1 99 2-mon lead
h3  1 99 3-mon lead
h4  1 99 4-mon lead
h5  1 99 5-mon lead
endvars
EOF
#
done  # for tp( mon or season
done  # for icmon
done  # var
