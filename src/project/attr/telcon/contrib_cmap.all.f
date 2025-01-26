      
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      real fld(imx,jmx)
      real trd(imx,jmx)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real obs(imx,jmx),obs3d(imx,jmx,ltime)
      real reg(imx,jmx),reg3d(imx,jmx,nmod)
      real fld3d(imx,jmx,nmod+1)
      real fld4d(imx,jmx,nmod+1,ltime)
      real f3d(imx,jmx,ltime)
      real tcof(nmod,ltime)
      real cofc(nmod)
      real corr(imx,jmx),regr(imx,jmx)
      real ts1(ltime),ts2(ltime)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !regr
      open(12,form='unformatted',access='direct',recl=4)
      open(13,form='unformatted',access='direct',recl=4*imx*jmx) !trd
C
      open(50,form='unformatted',access='direct',recl=4*imx*jmx)
      open(60,form='unformatted',access='direct',recl=4)
      open(70,form='unformatted',access='direct',recl=imx*jmx*4)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-88.75+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
c     write(6,*) 'coslat=',coslat
c
C==read in regr patterns
      m=0
      do ir=2,14,2
      m=m+1
      read(11,rec=ir) reg
        do i=1,imx
        do j=1,jmx
          reg3d(i,j,m)=reg(i,j)
        enddo
        enddo
      enddo
c== read in PCs
      ir=0
      do it=1,ltime
      do  m=1,nmod
      ir=ir+1
      read(12,rec=ir) tcof(m,it)
      enddo
      enddo
c
c attribution for all years
c
      iw1=0
      iw2=0
      DO it=1,ltime

      read(10,rec=it) obs

        do i=1,imx
        do j=1,jmx
         obs3d(i,j,it)=obs(i,j)
        enddo
        enddo

      iw1=iw1+1
      write(50,rec=iw1) obs

c contribution from each component

      do m=1,nmod
        do i=1,imx
        do j=1,jmx
          fld3d(i,j,m)=tcof(m,it)*reg3d(i,j,m)
          fld4d(i,j,m,it)=fld3d(i,j,m)
        enddo
        enddo
      enddo
c 
      read(13,rec=it) trd
      do i=1,imx
      do j=1,jmx
        fld3d(i,j,nmod+1)=trd(i,j)
        fld4d(i,j,nmod+1,it)=trd(i,j)
      enddo
      enddo

c write out fld3d
      do m=1,nmod+1
        do i=1,imx
        do j=1,jmx
         fld(i,j)=fld3d(i,j,m)
        enddo
        enddo
        iw1=iw1+1
        write(50,rec=iw1) fld
      enddo ! m loop
c
c spatial corr for each pattern 
c     lon1=77
c     lon2=121
c     lat1=45
c     lat2=65
      lon1=1
      lon2=144
      lat1=1
      lat2=72
      do m=1,nmod+1
      do i=1,imx
      do j=1,jmx
        fld(i,j)=fld3d(i,j,m)
      enddo
      enddo
      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)
      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr
      enddo  ! m loop

c rpc1-2 together
      call setzero(fld,imx,jmx)
      do i=1,imx
      do j=1,jmx

        do m=2,3
        fld(i,j)=fld(i,j)+fld3d(i,j,m)
        enddo

      enddo
      enddo
c write out pat
        iw1=iw1+1
        write(50,rec=iw1) fld

      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)

      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr

c rpc1-3 together
      call setzero(fld,imx,jmx)
      do i=1,imx
      do j=1,jmx

        do m=2,4
        fld(i,j)=fld(i,j)+fld3d(i,j,m)
        enddo

      enddo
      enddo
c write out pat
        iw1=iw1+1
        write(50,rec=iw1) fld

      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)

      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr

c rpc1-4 together
      call setzero(fld,imx,jmx)
      do i=1,imx
      do j=1,jmx

        do m=2,5
        fld(i,j)=fld(i,j)+fld3d(i,j,m)
        enddo

      enddo
      enddo
c write out pat
        iw1=iw1+1
        write(50,rec=iw1) fld

      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)

      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr

c rpc1-5 together
      call setzero(fld,imx,jmx)
      do i=1,imx
      do j=1,jmx

        do m=2,6
        fld(i,j)=fld(i,j)+fld3d(i,j,m)
        enddo

      enddo
      enddo
c write out pat
        iw1=iw1+1
        write(50,rec=iw1) fld

      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)

      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr

c rpc1-6 together
      call setzero(fld,imx,jmx)
      do i=1,imx
      do j=1,jmx

        do m=2,7
        fld(i,j)=fld(i,j)+fld3d(i,j,m)
        enddo

      enddo
      enddo
c write out pat
        iw1=iw1+1
        write(50,rec=iw1) fld

      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)

      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr

c all components together
      call setzero(fld,imx,jmx)
      do i=1,imx
      do j=1,jmx
        do m=1,5
        fld(i,j)=fld(i,j)+fld3d(i,j,m)
        enddo
      enddo
      enddo
      do i=1,imx
      do j=1,jmx
        fld(i,j)=fld(i,j)+fld3d(i,j,nmod+1)
      enddo
      enddo
c
c write out pat
        iw1=iw1+1
        write(50,rec=iw1) fld

      call sp_cor_rms(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,cor,rms)
      call sp_rms_ratio(fld,obs,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,vr)

      iw2=iw2+1
      write(60,rec=iw2) cor
      iw2=iw2+1
      write(60,rec=iw2) rms
      iw2=iw2+1
      write(60,rec=iw2) vr
c
      ENDDO ! it loop
c
c temporal corr of each components
c
      iw3=0
      do m=1,nmod+1
        do i=1,imx
        do j=1,jmx
          do it=1,ltime
          ts1(it)=fld4d(i,j,m,it)
          ts2(it)=obs3d(i,j,it)
          enddo
          call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j)) 
        enddo
        enddo
      iw3=iw3+1
      write(70,rec=iw3) corr
      iw3=iw3+1
      write(70,rec=iw3) regr
      enddo

c temporal corr of reconstructed
c mode RPC1-4
      do it=1,ltime
      do i=1,imx
      do j=1,jmx
         xx=0
         do m=2,5
         xx=xx+fld4d(i,j,m,it)
         enddo
         f3d(i,j,it)=xx
      enddo
      enddo
      enddo

      do i=1,imx
      do j=1,jmx
        do it=1,ltime
        ts1(it)=f3d(i,j,it)
        ts2(it)=obs3d(i,j,it)
        enddo
        call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j)) 
      enddo
      enddo
      iw3=iw3+1
      write(70,rec=iw3) corr
      iw3=iw3+1
      write(70,rec=iw3) regr
        
c mode ENSO + RPC1-4 + trd
      do it=1,ltime
      do i=1,imx
      do j=1,jmx
         xx=0
         do m=1,5
         xx=xx+fld4d(i,j,m,it)
         enddo
         f3d(i,j,it)=xx
         f3d(i,j,it)=f3d(i,j,it)+fld4d(i,j,nmod+1,it)
      enddo
      enddo
      enddo

      do i=1,imx
      do j=1,jmx
        do it=1,ltime
        ts1(it)=f3d(i,j,it)
        ts2(it)=obs3d(i,j,it)
        enddo
        call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j)) 
      enddo
      enddo
      iw3=iw3+1
      write(70,rec=iw3) corr
      iw3=iw3+1
      write(70,rec=iw3) regr
      
      stop
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

      SUBROUTINE setzero3d(fld,n,m,k)
      DIMENSION fld(n,m,k)
      do i=1,n
      do j=1,m
      do l=1,k
         fld(i,j,l)=0.0
      enddo
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
         rms=rms+(fld1(i,j)-fld2(i,j))**2
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
C============================
C have spatial variance ratio
C============================
      SUBROUTINE sp_rms_ratio(fld1,fld2,coslat,imx,jmx,
     &lon1,lon2,lat1,lat2,ratio)

      real fld1(imx,jmx),fld2(imx,jmx),coslat(jmx)

      v1=0.
      v2=0.

      do j=lat1,lat2
      do i=lon1,lon2
         v1=v1+fld1(i,j)*fld1(i,j)*coslat(j)
         v2=v2+fld2(i,j)*fld2(i,j)*coslat(j)
      enddo
      enddo

      ratio=v1/v2

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
