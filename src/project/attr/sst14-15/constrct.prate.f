      program constrct
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      real fld(imx,jmx)
      real regr1(imx,jmx),regr2(imx,jmx)
      real wk(imx,jmx)
      real obs(imx,jmx,ltp),cons(imx,jmx,2,nmod)
      real regr(imx,jmx,2,nmod),pc(ltp,2,nmod)
      real pct(ltime,2,nmod)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !obs sst
      open(11,form='unformatted',access='direct',recl=4*imx*jmx) !sst eofs
      open(12,form='unformatted',access='direct',recl=4) !PCs
C
      open(50,form='unformatted',access='direct',recl=4*imx*jmx) !cons sst
C
      undef=-9999.0
c
C==read in obs
      ir=0
      do it=1,ltp
      ir=ir+1
        read(10,rec=ir) fld
        do i=1,imx
        do j=1,jmx
         obs(i,j,it)=fld(i,j)
        enddo
        enddo
      enddo
c
C==read in eof, regr, reof and rregr
      ir=0
      do m=1,nmod
      ir=ir+1
      read(11,rec=ir) eof1
      ir=ir+1
      read(11,rec=ir) regr1
      do i=1,imx
      do j=1,jmx
        regr(i,j,1,m)=regr1(i,j)
      enddo
      enddo
      ir=ir+1
      read(11,rec=ir) eof2
      ir=ir+1
      read(11,rec=ir) regr2
      do i=1,imx
      do j=1,jmx
        regr(i,j,2,m)=regr2(i,j)
      enddo
      enddo

      enddo !mode
c     write(6,*) regr
c
c== read in PCs
c
      ir=0
      do it=1,ltime
      do m=1,nmod
      ir=ir+1
      read(12,rec=ir) pct(it,1,m)
      ir=ir+1
      read(12,rec=ir) pct(it,2,m)
      enddo
      enddo
c
c== have the pc with length as long as prate
c
      do it=1,ltp
      do m=1,nmod
      pc(it,1,m)=pct(it+nskip,1,m)
      pc(it,2,m)=pct(it+nskip,2,m)
      enddo
      enddo
c     write(6,*) pc
c
c== construct sst
c
      iw=0

      do it=1,ltp

      do i=1,imx
      do j=1,jmx

      cons(i,j,1,1)=pc(it,1,1)*regr(i,j,1,1)
      cons(i,j,2,1)=pc(it,2,1)*regr(i,j,2,1)
      cons(i,j,1,2)=cons(i,j,1,1)+pc(it,1,2)*regr(i,j,1,2)
      cons(i,j,2,2)=cons(i,j,2,1)+pc(it,2,2)*regr(i,j,2,2)
      cons(i,j,1,3)=cons(i,j,1,2)+pc(it,1,3)*regr(i,j,1,3)
      cons(i,j,2,3)=cons(i,j,2,2)+pc(it,2,3)*regr(i,j,2,3)
      cons(i,j,1,4)=cons(i,j,1,3)+pc(it,1,4)*regr(i,j,1,4)
      cons(i,j,2,4)=cons(i,j,2,3)+pc(it,2,4)*regr(i,j,2,4)
      cons(i,j,1,5)=cons(i,j,1,4)+pc(it,1,5)*regr(i,j,1,5)
      cons(i,j,2,5)=cons(i,j,2,4)+pc(it,2,5)*regr(i,j,2,5)
      cons(i,j,1,6)=cons(i,j,1,5)+pc(it,1,6)*regr(i,j,1,6)
      cons(i,j,2,6)=cons(i,j,2,5)+pc(it,2,6)*regr(i,j,2,6)

      enddo !imx
      enddo !jmx

      do i=1,imx
      do j=1,jmx
        fld(i,j)=obs(i,j,it)
      enddo
      enddo
      iw=iw+1
      write(50,rec=iw) fld

      do m=1,6
      do n=1,2
        do i=1,imx
        do j=1,jmx
        fld(i,j)=cons(i,j,n,m)
        enddo
        enddo
        iw=iw+1
        write(50,rec=iw) fld
      enddo
      enddo

      enddo !it

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
