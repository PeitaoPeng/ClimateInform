      program detrd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      real w3d(imx,jmx,ltime),w3d2(imx,jmx,ltime),afld(imx,jmx,ltime)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real aa(imx,jmx),bb(imx,jmx)
      real w4d(imx,jmx,5,ltime)
      real w4d2(imx,jmx,5,ltime)
      real coslat(jmx),xlat(jmx),cosr(jmx)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) 
c
      open(50,form='unformatted',access='direct',recl=4*imx*jmx)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*1
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
c read in ndjfm z200 data
      ir=0
      do iy=1,nyr
        do im=1,5
        ir=ir+1
        read(10,rec=ir) w2d
        do i=1,imx
        do j=1,jmx
          w4d(i,j,im,iy)=w2d(i,j)
        enddo
        enddo
       enddo !im loop
      enddo ! iy loop
c== detrend data
      do im=1,5
        do iy=1,ltime
        do i=1,imx
        do j=1,jmx
          w3d(i,j,iy)=w4d(i,j,im,iy)
        enddo
        enddo
        enddo
      call ltrend(w3d,afld,w3d2,imx,jmx,ltime,1,ltime,aa,bb)
c put detrended data into w4d for later use
        do iy=1,ltime
        do i=1,imx
        do j=1,jmx
          w4d2(i,j,im,iy)=afld(i,j,iy)
        enddo
        enddo
        enddo
      enddo  ! loop im
c
c write out detrended data
c
      iw=0
      do iy=1,ltime
      do im=1,5
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w4d2(i,j,im,iy)
        enddo
        enddo
      iw=iw+1
      write(50,rec=iw) w2d
      enddo
      enddo
      iw=iw+1
      write(50,rec=iw) aa
      iw=iw+1
      write(50,rec=iw) bb

      stop
      end

      subroutine anom_wmo(fldin,fldout,imx,jmx,nt,ntprd,ndec)
      real fldin(imx,jmx,nt),clm(ndec,imx,jmx)
      real fldout(imx,jmx,ntprd)
c have wmo clim
      do id=1,ndec
      do i=1,imx
      do j=1,jmx
      clm(id,i)=0.
      do k=4,33  !data is from 1957, clim for 1961-90
        clm(id,i,j)=clm(id,i,j)+fldin(i,j,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
c anom w.r.t wmo clim
      do i=1,imx
      do j=1,jmx
      do k=1,10
        kt=k+30+(id-1)*10
        fldout(i,j,kt-30)=fldin(i,j,kt)-clm(id,i,j)
      enddo
      enddo
      enddo
c
      ks=30+(ndec-1)*10+1
      do i=1,ncd
      do k=ks,nt !2011-cur (at most 2020)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo

      return
      end

      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE anom(rot,ltime)
      DIMENSION rot(ltime)
      avg=0.
      do i=1,ltime
         avg=avg+rot(i)/float(ltime)
      enddo
      do i=1,ltime
        rot(i)=rot(i)-avg
      enddo
c
      return
      end

      SUBROUTINE normal(rot,rot2,ltime)
      DIMENSION rot(ltime),rot2(ltime)
      avg=0.
      do i=1,ltime
         avg=avg+rot(i)/float(ltime)
      enddo
      do i=1,ltime
        rot2(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,ltime
        sd=sd+rot2(i)*rot2(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot2(i)=rot2(i)/sd
      enddo
      return
      end

      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end

      SUBROUTINE area_avg(fld,coslat,imx,jmx,is,ie,js,je,out)

      real fld(imx,jmx),coslat(jmx)

      area=0
      do j=js,je
      do i=is,ie
        area=area+coslat(j)
      enddo
      enddo
c     write(6,*) 'area2=',area

      out=0.
      do j=js,je
      do i=is,ie

        out=out+fld(i,j)*coslat(j)/area

      enddo
      enddo

      return
      end

      SUBROUTINE sp_cor_rms(fld1,fld2,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)

      real fld1(imx,jmx),fld2(imx,jmx),coslat(jmx)

      area=0.
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo
c     write(6,*) 'area=',area

      cor=0.
      rms=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
         cor=cor+fld1(i,j)*fld2(i,j)*coslat(j)/area
         rms=rms+(fld1(i,j)-fld2(i,j))*(fld1(i,j)-fld2(i,j))
     &*coslat(j)/area
         sd1=sd1+fld1(i,j)*fld1(i,j)*coslat(j)/area
         sd2=sd2+fld2(i,j)*fld2(i,j)*coslat(j)/area
      enddo
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)
      rms=rms**0.5

      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend(grid,out,out2,imx,jmx,nt,its,ite,a,b)
      dimension grid(imx,jmx,nt),out(imx,jmx,nt)
      dimension out2(imx,jmx,nt)
      dimension a(imx,jmx),b(imx,jmx)
      real lxx, lxy
c
      do i=1,imx
      do j=1,jmx
c
      xb=0
      yb=0
      do it=its,ite
        xb=xb+float(it)/float(ite-its+1)
        yb=yb+grid(i,j,it)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do it=its,ite
      lxx=lxx+(it-xb)*(it-xb)
      lxy=lxy+(it-xb)*(grid(i,j,it)-yb)
      enddo
      b(i,j)=lxy/lxx
      a(i,j)=yb-b(i,j)*xb
      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,nt
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      enddo
      enddo
      enddo
c
      return
      end
