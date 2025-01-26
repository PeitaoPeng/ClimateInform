      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C subtract some external forced parts then eof
C===========================================================
      PARAMETER (ifld=ltime,nw=2*ifld+15)
      PARAMETER (ngrd=(late-lats+1)*(lone-lons+1))
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real sst(ltime),tps(ltime)
      real ts1(ltime),ts2(ltime),ts3(ltime)
      real pc1(ltime),pc2(ltime)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real amipa(imx,jmx,ltime)
      real obsa(imx,jmx,ltime)
      real afld(imx,jmx,ltime)
      real regr(imx,jmx)
      real eof1(imx,jmx),regr1(imx,jmx)
      real eof2(imx,jmx),regr2(imx,jmx)
      real tcof(nmod,ltime)
      real tcof2(nmod,ltime)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !obs
C
      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(52,form='unformatted',access='direct',recl=4)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
      write(6,*) 'coslat=',coslat
C==read in obs
      do it=1,ltime
        read(10,rec=it) fld
        do i=1,imx
        do j=1,jmx
          afld(i,j,it)=fld(i,j)
        enddo
        enddo
      enddo
c
ccc EOF calculation
ccc feed matrix aaa
      do it=1,ltime
        ng=0
        do j=lats,late
        do i=lons,lone
          ng=ng+1
          aaa(ng,it)=afld(i,j,it)*cosr(j)
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

      totv2=0
      do i=1,nmod
      write(6,*)'reval= ',i,reval(i)
      totv2=totv2+reval(i)
      end do
      write(6,*)'total= ',totv2
c
c==CORR between coef and data
c
      iw=0
      DO m=1,nmod !loop over mode

      do it=1,ltime
        ts1(it)=coef(m,it)
        ts2(it)=rcoef(m,it)
      enddo
c
      call normal(ts1,pc1,ltime)
      call normal(ts2,pc2,ltime)
c
      do it=1,ltime
        tcof(m,it)=pc1(it)
        tcof2(m,it)=pc2(it)
      enddo
c     write(6,*) 'pc=',pc2
c
      do j=1,jmx
      do i=1,imx

      do it=1,ltime
        ts3(it)=afld(i,j,it)
      enddo

      call regr_t(pc1,ts3,ltime,eof1(i,j),regr1(i,j))
      call regr_t(pc2,ts3,ltime,eof2(i,j),regr2(i,j))

      enddo
      enddo

      iw=iw+1
      write(51,rec=iw) eof1
      iw=iw+1
      write(51,rec=iw) regr1
      iw=iw+1
      write(51,rec=iw) eof2
      iw=iw+1
      write(51,rec=iw) regr2
c
      enddo   !mode
c
c write out pc
      iw=0
      do it=1,ltime
      do m=1,nmod
      iw=iw+1
      write(52,rec=iw) tcof(m,it)
      iw=iw+1
      write(52,rec=iw) tcof2(m,it)
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
