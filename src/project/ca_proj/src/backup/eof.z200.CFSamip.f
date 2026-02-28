      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ifld=ltime,nw=2*ifld+15)
      PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real corr(imx,jmx),rcorr(imx,jmx)
      real sst(ltime),tps(ltime)
      real ts1(ltime),ts2(ltime)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real afld(imx,jmx,ltime)
      real w3d(imx,jmx,ltime),w3d2(imx,jmx,ltime),w3d3(imx,jmx,ltime)
      real w2d(imx,jmx),w2d2(imx,jmx)
      real aa(imx,jmx),bb(imx,jmx)
      real regr(imx,jmx)
      real tcof(nmod,ltime)
      real cof(nmod,ltime)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !3_d data
C
      open(31,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(41,form='unformatted',access='direct',recl=4*imx*jmx)
      open(42,form='unformatted',access='direct',recl=4)
c
      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(52,form='unformatted',access='direct',recl=4)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90.+(j-1)*1
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
c     write(6,*) 'coslat=',coslat
C==read in data
      do it=1,ltime
        itr=iskip_fld+it
        read(10,rec=itr) fld
        do i=1,imx
        do j=1,jmx
          w3d(i,j,it)=fld(i,j) !for z200
c         w3d(i,j,it)=fld(i,j)/100000.  ! for psi200
        enddo
        enddo
      enddo
c
c== detrend data
c
c     call ltrend(w3d,afld,w3d2,imx,jmx,ltime,1,ltime,aa,bb)
c write out trend per year
c     write(31,rec=1) bb
c
ccc feed matrix aaa
c
      do it=1,ltime
        ng=0
        do j=lats,late
        do i=lons,lone
          ng=ng+1
          aaa(ng,it)=w3d(i,j,it)*cosr(j)
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
c== put coef to cof for easy later use
c
      do m=1,nmod
      do it=1,ltime
        cof(m,it)=coef(m,it)
        tcof(m,it)=rcoef(m,it)
      enddo
      enddo
c
c==CORR between coef and data
c
      iw=0
      DO m=1,nmod !loop over mode
c
      do it=1,ltime
      ts1(it)=cof(m,it)
      enddo
      call normal(ts1,ts2,ltime)
      do jt=1,ltime
        ts1(jt)=ts2(jt)
      enddo
      do jt=1,ltime
        cof(m,jt)=ts2(jt)
      enddo

 888  continue
c
      do j=1,jmx
      do i=1,imx

      do it=1,ltime
        ts2(it)=w3d(i,j,it)
      enddo

      call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j))

      enddo
      enddo

      iw=iw+1
      write(41,rec=iw) corr
      iw=iw+1
      write(41,rec=iw) regr

      enddo

c== write out coef
      iw=0
      do m=1,nmod
      do it=1,ltime
      iw=iw+1
      write(42,rec=iw) cof(m,it)
      enddo
      enddo
c
c==CORR between rcoef and data
c
      iw=0
      DO m=1,nmod !loop over mode
c
      do it=1,ltime
      ts1(it)=tcof(m,it)
      enddo
      call normal(ts1,ts2,ltime)
      do jt=1,ltime
        ts1(jt)=ts2(jt)
      enddo
c     if(m.gt.1) then
      do jt=1,ltime
        tcof(m,jt)=ts2(jt)
      enddo
c     endif

 999  continue
c
      do j=1,jmx
      do i=1,imx

      do it=1,ltime
        ts2(it)=w3d(i,j,it)
      enddo

      call regr_t(ts1,ts2,ltime,corr(i,j),regr(i,j))

      enddo
      enddo

      iw=iw+1
      write(51,rec=iw) corr
      iw=iw+1
      write(51,rec=iw) regr
c
      enddo !loop over modes
c
c== write out rcoef
      iw=0
      do m=1,nmod
      do it=1,ltime
      iw=iw+1
      write(52,rec=iw) tcof(m,it)
      enddo
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
