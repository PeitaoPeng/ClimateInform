      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C eof is applied to detrended data
C===========================================================
      PARAMETER (ifld=ltime,nw=2*ifld+15)
      PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
c     PARAMETER (ngrd=2016)
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real fld3(imx,jmx),fld4(imx,jmx),fld5(imx,jmx)
      real sst(ltime),tps(ltime)
      real ts1(ltime),ts2(ltime)
      real ts3(ltime),ts4(ltime)
      real xn34(ltime),xn34c(imx,jmx),xn34p(imx,jmx)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real afld(imx,jmx,ltime)
      real w3d(imx,jmx,ltime),w3d2(imx,jmx,ltime)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real cof(nmod+1,ltime)
      real rcof(nmod+1,ltime)
      real pc1(ltime),pc2(ltime)
      real regr(imx,jmx),corr(imx,jmx)
      real rregr(imx,jmx),rcorr(imx,jmx)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
      open(11,form='unformatted',access='direct',recl=4) 
C
      open(31,form='unformatted',access='direct',recl=4*imx*jmx) !trd
      open(32,form='unformatted',access='direct',recl=4*imx*jmx) !rsd
      open(33,form='unformatted',access='direct',recl=4*imx*jmx)

      open(41,form='unformatted',access='direct',recl=4*imx*jmx)
      open(42,form='unformatted',access='direct',recl=4)

      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(52,form='unformatted',access='direct',recl=4)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-88.75+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
c     write(6,*) 'coslat=',coslat
C==read in obs
      do it=1,ltime
        read(10,rec=it) fld
        do i=1,imx
        do j=1,jmx
          w3d(i,j,it)=fld(i,j)
        enddo
        enddo
      enddo
c
c== read in nino34 index
c
      do it=1,ltime
      read(11,rec=it) sst(it)
      enddo
      call normal(sst,xn34,ltime)
      do it=1,ltime
      cof(1,it)=xn34(it)
      rcof(1,it)=xn34(it)
      enddo
c
c== detrend data
c
      call ltrend(w3d,afld,w3d2,imx,jmx,ltime,1,ltime,w2d,w2d2)
c write out yearly trend
        do i=1,imx
        do j=1,jmx
          w2d2(i,j)=w2d2(i,j)
        enddo
        enddo
      write(31,rec=1) w2d2
c write out of trend data of all years
      do it =1,ltime
        do i=1,imx
        do j=1,jmx
          w2d2(i,j)=w3d2(i,j,it)
        enddo
        enddo
      write(33,rec=it) w2d2
      enddo
c
c== regr nino34 to detrended data
      do j=1,jmx
      do i=1,imx

      if(w2d2(i,j).gt.-1000) then

      do it=1,ltime
        ts2(it)=afld(i,j,it)
      enddo

      call regr_t(xn34,ts2,ltime,corr(i,j),regr(i,j))
      else

      corr(i,j)= -9999.
      regr(i,j)= -9999.

      endif

      enddo
      enddo
      iw=1
      write(41,rec=iw) corr
      write(51,rec=iw) corr
      iw=iw+1
      write(41,rec=iw) regr
      write(51,rec=iw) regr
c
c have residual
c
      do it=1,ltime
        do i=1,imx
        do j=1,jmx
        if(w2d2(i,j).gt.-100) then
          w3d2(i,j,it)=afld(i,j,it)-xn34(it)*regr(i,j)
        else
          w3d2(i,j,it)=w3d(i,j,it)
        endif
        enddo
        enddo
      enddo
c
c write out rsd
c
      do it=1,ltime
        do i=1,imx
        do j=1,jmx
          fld(i,j)=w3d2(i,j,it)
        enddo
        enddo
        write(32,rec=it) fld
      enddo
c
ccc feed matrix aaa
c
      do it=1,ltime
        ng=0
        do j=lats,late
        do i=lons,lone
        if(w2d2(i,j).gt.-900) then
          ng=ng+1
          aaa(ng,it)=w3d2(i,j,it)*cosr(j)
        endif
        end do
        end do
      end do
      write(6,*) 'ngrd= ',ng
c
cc... EOF analysis begin
c
      call eofs(aaa,ngrd,ifld,ifld,eval,evec,coef,wk,id)
      call REOFS(aaa,ngrd,ifld,ifld,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arange reval,revec and rcoef in decreasing order
      call order(ngrd,ifld,nmod,reval,revec,rcoef)
cc... write out eval and reval
      totv1=0
      do i=1,20
      write(6,*)'eval= ',i,eval(i)
      totv1=totv1+eval(i)
      end do
      write(6,*)'total= ',totv1
c
c==CORR between coef and data
      do m=1,nmod

      do it=1,ltime
        ts1(it)=coef(m,it)
        ts2(it)=rcoef(m,it)
      enddo
c
      call normal(ts1,pc1,ltime)
      call normal(ts2,pc2,ltime)
c
      do it=1,ltime
        cof(m+1,it)=pc1(it)
        rcof(m+1,it)=pc2(it)
      enddo
c
      do j=1,jmx
      do i=1,imx

      if(w2d2(i,j).gt.-1000) then

      do it=1,ltime
        ts2(it)=w3d2(i,j,it)
c       ts2(it)=w3d(i,j,it)
      enddo

      call regr_t(pc1,ts2,ltime,corr(i,j),regr(i,j))
      call regr_t(pc2,ts2,ltime,rcorr(i,j),rregr(i,j))
      else

      corr(i,j)= -9999.
      regr(i,j)= -9999.

      endif

      enddo
      enddo

      iw=iw+1
      write(41,rec=iw) corr
      write(51,rec=iw) rcorr
      iw=iw+1
      write(41,rec=iw) regr
      write(51,rec=iw) rregr

      enddo ! m loop

c write out coef
      iw=0
      undef=-9999.0
      do it =1,ltime
      do  m =1,nmod+1
      iw=iw+1
      write(42,rec=iw) cof(m,it)
      write(52,rec=iw) rcof(m,it)
      enddo
      enddo
c
      it=ltime+1
      do  m =1,nmod+1
      iw=iw+1
      write(42,rec=iw) undef
      write(52,rec=iw) undef
      enddo
       
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
