#!/bin/sh
#################################################
# calculate RPSS on spacial domain, output is a time series
#################################################

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
###################################################
yrs=1982
yre=2018  # last year
ntotyr=`expr $yre - $yrs + 1`  # total year for calculating HSS (2012-last yr)
#fskip=`expr 2011 - 1982 + 1`  # skip for fcast data
oskip=`expr $yrs - 1981`      # skip for obs data
nvyr=`expr $yre - $yrs + 1`   # total year for calculating RPSS

#for var in tmp2m prate; do
 for var in prate; do
for icmon in jan feb mar apr may jun jul aug sep oct nov dec; do
for tmean  in mon seas; do

otmean=mon
if [ $tmean = seas ]; then otmean=ss; fi
#
infile1=NMME.$var.$tmean.${icmon}_ic.1982-$yre.prob.adj.ld1-5
#infile1=NMME.$var.$tmean.${icmon}_ic.1982-$yre.prob.ld1-5
infile2=obs.$var.$otmean.${icmon}_ic.1981-$yre.ld1-5
infile3=obs.$var.$otmean.clim_std.${icmon}_ic.1981-2010

outfile1=RPSS.NMME.$var.$otmean.${icmon}_ic.2012-$yre.ts

cp $datadir1/$infile1.gr .
cp $datadir2/$infile2.gr .
cp $datadir2/$infile3.gr .
#
xdim=360
ydim=181
nlead=5
undef=-9.99e+8
#=======================================
# hss calculation for 2012-last_year
#=======================================
cat >have.rpss.f<<EOF
      parameter(im=$xdim,jm=$ydim)
      parameter(undef=$undef)
      parameter(nvy=$nvyr,nld=$nlead)
      parameter(is=$is,ie=$ie,js=$js,je=$je)
c
      real*4 w1d1(nvy),w1d2(nvy),w1d3(nvy)
      real*4 w2d(im,jm),w2d2(im,jm)
      real*4 clmo(im,jm,nld),clmf(im,jm,nld)
      real*4 stdo(im,jm,nld),stdf(im,jm,nld)
      real*4 fldo(im,jm,nvy,nld),fldf(im,jm,nvy,nld,3)
      real*4 pbo(im,jm,nvy,nld,3)
      real*4 rps(im,jm,nld,nvy),rpsc(im,jm,nld,nvy)
      real*4 rps_t(im,jm,nld),rpsc_t(im,jm,nld)
      real*4 rpss_t(im,jm,nld)
      dimension m1d1(nvy),m1d2(nvy)
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
C
      open(20,
     &file='$outfile1.gr',
     &access='direct',form='unformatted',recl=4)

c read in prob fcst data

      irf=1

      do iy=1,nvy
      do il=1,nld
      do ip=1,3   !a,n,b of prob

      read(11,rec=irf) w2d

        do i=1,im
        do j=1,jm
          fldf(i,j,iy,il,ip)=w2d(i,j)
        enddo
        enddo

      irf=irf+1

      enddo
      enddo
      enddo

c
c process obs data
c
c read in obs data
      nskipo=${oskip}*nld

      iro=nskipo+1

      do iy=1,nvy
      do il=1,nld

      read(12,rec=iro) w2d

        do i=1,im
        do j=1,jm
          fldo(i,j,iy,il)=w2d(i,j)
        enddo
        enddo

      iro=iro+1

      enddo
      enddo

c read in obs clm and std data
      ir=1
      do il=1,nld
        read(13,rec=ir) w2d
        do i=1,im
        do j=1,jm
          clmo(i,j,il)=w2d(i,j)
        enddo
        enddo
        ir=ir+1
        read(13,rec=ir) w2d
        do i=1,im
        do j=1,jm
          stdo(i,j,il)=w2d(i,j)
        enddo
        enddo
      ir=ir+1
      enddo

c normalizing obs anomalies
      
      do iy=1,nvy
      do il=1,nld

      do i=1,im
      do j=1,jm
      if(abs(clmo(i,j,1)).lt.999) then
        fldo(i,j,iy,il)=(fldo(i,j,iy,il)-clmo(i,j,il))/stdo(i,j,il)
      else
        fldo(i,j,iy,il)=undef
      endif
      enddo
      enddo

      enddo
      enddo

c convert to prob for each category
      aa=0.43
      bb=-0.43
      do iy=1,nvy
      do il=1,nld

      do i=1,im
      do j=1,jm
      if(abs(clmo(i,j,1)).lt.999) then
       pbo(i,j,iy,il,3)=0.
       pbo(i,j,iy,il,2)=0.
       pbo(i,j,iy,il,1)=0.
       if (fldo(i,j,iy,il).lt.bb) pbo(i,j,iy,il,3)=1
       if (fldo(i,j,iy,il).gt.aa) pbo(i,j,iy,il,1)=1
       if (fldo(i,j,iy,il).le.aa.and.fldo(i,j,iy,il).ge.bb) 
     & pbo(i,j,iy,il,2)=1
      endif
      enddo
      enddo

      enddo
      enddo

c have RPSS
      do il=1,nld

      do i=1,im
      do j=1,jm
      if(abs(clmo(i,j,1)).lt.999) then
        do iy=1,nvy

          prd_b=fldf(i,j,iy,il,3)
          prd_n=fldf(i,j,iy,il,2)
          prd_a=fldf(i,j,iy,il,1)
          vfc_b=pbo(i,j,iy,il,3)
          vfc_n=pbo(i,j,iy,il,2)
          vfc_a=pbo(i,j,iy,il,1)

          y1=prd_b
          y2=prd_b+prd_n
          y3=1.

          o1=vfc_b
          o2=vfc_b+vfc_n
          o3=1.

          rps(i,j,il,iy)=(y1-o1)**2
     &+(y2-o2)**2   !rps
          rpsc(i,j,il,iy)=(1./3.-o1)**2
     &+(2./3.-o2)**2   !rpsc
        enddo ! iy loop
      endif

      enddo ! i loop
      enddo ! j loop

      enddo ! il loop
c
c have time series of spacially averaged rps
c
      iw=0
      do iy=1,nvy
      do il=1,nld

        ng=0
        exp=0.
        expc=0.
        do i=is,ie
        do j=js,je
          IF(abs(rps(i,j,il,iy)).lt.999.) then
            ng=ng+1
            exp=exp+rps(i,j,il,iy)
            expc=expc+rpsc(i,j,il,iy)
          END IF
        enddo
        enddo
        rps_s=exp/float(ng)
        rpsc_s=expc/float(ng)
        rpss_s=1.- rps_s/rpsc_s

      iw=iw+1
      write(20,rec=iw) rpss_s
      print *, 'iw=',iw,'  rpss_s=',rpss_s

      enddo ! il loop
      enddo ! yr loop

      STOP  
      END
EOF
#
gfortran -o rpss.x have.rpss.f
echo "done compiling"
./rpss.x 
#
mv $outfile1.gr $dataout

cat>$dataout/$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
title EXP1
XDEF  1 LINEAR    0.  1.0
YDEF  1 LINEAR  -90.  1.0
zdef  1 linear 1 1
tdef  999 linear $icmon$yrs 1yr
vars  5
rp1  1 99 1-mon lead
rp2  1 99 2-mon lead
rp3  1 99 3-mon lead
rp4  1 99 4-mon lead
rp5  1 99 5-mon lead
endvars
EOF
#
done  # for tmean(mon or season
done  # for icmon
done  # var
