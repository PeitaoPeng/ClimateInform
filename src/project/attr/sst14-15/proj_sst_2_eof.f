      program proj
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real afld(imx,jmx,ltime)
      real p1(ltime),p3(ltime)
      real pc1(ltime),pc3(ltime)
      real eof1(imx,jmx),eof3(imx,jmx)
      real regr1(imx,jmx),regr2(imx,jmx)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
C
      open(50,form='unformatted',access='direct',recl=4)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-89.5+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j)) 
      enddo
c     write(6,*) 'coslat=',coslat
C==read in obs sst
      do it=1,ltime
        read(10,rec=it) fld
        do i=1,imx
        do j=1,jmx
          afld(i,j,it)=fld(i,j)
        enddo
        enddo
      enddo
c
C==read in eof
        read(11,rec=2)  eof1 ! regr of PC1
        read(11,rec=10) eof3 ! regr of PC3
c
ccc proj SST to eofs
c
      iw=0
      do it=1,ltime

        do i=1,imx
        do j=1,jmx
          fld(i,j)=afld(i,j,it)
        enddo
        enddo

      call projsst(fld,eof1,coslat,imx,jmx,lons,lone,lats,late,cf1)
      call projsst(fld,eof3,coslat,imx,jmx,lons,lone,lats,late,cf3)

      iw=iw+1
      write(50,rec=iw) cf1
      iw=iw+1
      write(50,rec=iw) cf3

      if(it.eq.792) then
      write(6,*) 'cf1&3=',cf1,cf3
      endif

      enddo
c
      stop
      end

      SUBROUTINE projsst(f1,f2,coslat,imx,jmx,lons,lone,lats,late,out)
      DIMENSION f1(imx,jmx),f2(imx,jmx)
      DIMENSION coslat(jmx)
      pr=0
      ar=0
      var=0
      do j=lats,late
      do i=lons,lone
         if(abs(f1(i,j)).lt.1000) then
         pr=pr+coslat(j)*f1(i,j)*f2(i,j)
         ar=ar+coslat(j)
         var=var+coslat(j)*f2(i,j)*f2(i,j)
         endif
      enddo
      enddo
      out=pr/var

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
      if(grid(i,j,1).gt.-1000) then
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

      else 
      a(i,j)=-9.99E+8
      b(i,j)=-9.99E+8
      endif

      enddo !over j
      enddo !over i
c
      do i=1,imx
      do j=1,jmx
      do it=1,nt

      if(grid(i,j,1).gt.-1000) then
        out(i,j,it)=grid(i,j,it)-b(i,j)*float(it)-a(i,j) !detrended
        out2(i,j,it)=b(i,j)*float(it)+a(i,j) !trend
      else
        out(i,j,it)=-9.99E+8
        out2(i,j,it)=-9.99E+8
      endif

      enddo
      enddo
      enddo
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  split Nino34 or PCs into strong warm/cold and EP/CP El Nino
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine splitpc(xin,nt,undef,out1,out2,out3,out4)
      dimension xin(nt),out1(nt),out2(nt)
      dimension out3(nt),out4(nt)
      do it=1,nt
        out1(it)=undef
        out2(it)=undef
        out3(it)=undef
        out4(it)=undef
      enddo
      do it=1,nt
c CP warm
      if(it.eq.21.or.it.eq.40.or.it.eq.47) out1(it)=xin(it)
      if(it.eq.55.or.it.eq.59.or.it.eq.62) out1(it)=xin(it)
c EP warm
      if(it.eq.10.or.it.eq.18.or.it.eq.25) out2(it)=xin(it)
      if(it.eq.35.or.it.eq.39.or.it.eq.50) out2(it)=xin(it)
c     if(it.eq.22.or.it.eq.44) out2(it)=xin(it)
c strong warm
      if(it.eq.10.or.it.eq.25.or.it.eq.35) out3(it)=xin(it)
      if(it.eq.44.or.it.eq.50.or.it.eq.62) out3(it)=xin(it)
c strong cold
      if(it.eq.2.or.it.eq.26.or.it.eq.28) out4(it)=xin(it)
      if(it.eq.41.or.it.eq.51.or.it.eq.52) out4(it)=xin(it)
      enddo
      return
      end
