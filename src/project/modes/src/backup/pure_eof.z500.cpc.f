      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C calculate REOF of Z500 for consecutive 3 month data
C===========================================================
      PARAMETER (ifld=3*ny,nw=2*ifld+15)
      PARAMETER (ngrd=(je-js+1)*(ie-is+1))
      real fld(imx,jmx),fld1(imx,jmx),fld2(imx,jmx)
      real f3d(imx,jmx,ny),f4d(imx,jmx,ny,3),f4d2(imx,jmx,ny,3)
      real clim(imx,jmx),stdv(imx,jmx)
      real varp(imx,jmx),var3m(imx,jmx,3),vartot(imx,jmx)
      real corr(imx,jmx),rcorr(imx,jmx)
      real ts1(ny),ts2(ny)
      real ts3(ifld),ts4(ifld)
      real aaa(ngrd,ifld),wk(ifld,ngrd),tt(nmod,nmod)
      real eval(ifld),evec(ngrd,ifld),coef(ifld,ifld)
      real rin(ifld),rot2(ifld),rot(ifld)
      real weval(ifld),wevec(ngrd,ifld),wcoef(ifld,ifld)
      real reval(nmod),revec(ngrd,ifld),rcoef(nmod,ifld)
      real xlat(jmx),coslat(jmx),cosr(jmx)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real afld(imx,jmx,ifld)
      real regr(imx,jmx)
      real corr2(imx,jmx),regr2(imx,jmx)
      real tcof(nmod,ifld)
C
      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !obs
C
      open(51,form='unformatted',access='direct',recl=4*imx*jmx)
      open(52,form='unformatted',access='direct',recl=4*ifld)
      open(53,form='unformatted',access='direct',recl=4*imx*jmx)
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use 
        cosr(j)=sqrt(coslat(j))  !for EOF use 
      enddo
      write(6,*) 'coslat=',coslat
c
C==read in data
c
      do ms=1,3
        if(ms.eq.1) ims=imm 
        if(ms.eq.2) ims=mons 
        if(ms.eq.3) ims=imp 
        iw=0
        do it=ims,ntotm,12
        read(10,rec=it) fld
        iw=iw+1
        do i=1,imx
        do j=1,jmx
          f4d(i,j,iw,ms)=fld(i,j)
        enddo
        enddo
        enddo
        write(6,*) 'ms=',ms,'iw=',iw
      enddo ! loop ms
C
c clim, std and normalize
      its=clm_s
      do ms=1,3

      do it=1,ny
      do i=1,imx
      do j=1,jmx
         f3d(i,j,it)=f4d(i,j,it,ms)
      enddo
      enddo
      enddo
c clm_std
      call clm_std(f3d,imx,jmx,ny,its,clim,stdv)
      if(ms.eq.2) then
      write(53,rec=1) clim
      write(53,rec=2) stdv
      endif
c
      do i=1,imx
      do j=1,jmx
         var3m(i,j,ms)=stdv(i,j)*stdv(i,j)
      enddo
      enddo
c normalize
      do i=1,imx
      do j=1,jmx
        do it=1,ny
          ts1(it)=f3d(i,j,it)
        enddo
        call normal(ts1,ts2,ny)
        do it=1,ny
        if(mtx.eq.1) then
          f4d(i,j,it,ms)=ts2(it) ! normalized
        else
          f4d(i,j,it,ms)=ts1(it) ! raw
        endif
          f4d2(i,j,it,ms)=ts1(it) ! raw
        enddo
      enddo
      enddo

      enddo ! loop ms
c totvar
      do i=1,imx
      do j=1,jmx
        vartot(i,j)=0
        do ms=1,3
         vartot(i,j)=vartot(i,j)+var3m(i,j,ms)/3.
        enddo
      enddo
      enddo
      call area_avg(vartot,coslat,imx,jmx,is,ie,js,je,vout0)
      write(6,*) 'vout0=',vout0
c
c put f4d into afld for late regression
      
      ir=0
      do ms=1,3
      do it=1,ny
      ir=ir+1
        do j=1,jmx
        do i=1,imx
          afld(i,j,ir)=f4d(i,j,it,ms)
        end do
        end do
      end do
      end do
      write(6,*) 'afld=',afld(20,20,1),afld(20,20,72)
ccc EOF calculation
      iw=0
      iw2=0
ccc feed matrix aaa
      ir=0
      do ms=1,3
      do it=1,ny
      ir=ir+1
        ng=0
        do j=js,je
        do i=is,ie
          ng=ng+1
          aaa(ng,ir)=f4d(i,j,it,ms)*cosr(j)
        end do
        end do
      end do
      end do
      write(6,*) 'ngrd= ',ng, ' nt=',ir
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
c== put rcoef to tcof for easy later use
c
      do m=1,nmod
      do it=1,ifld
        tcof(m,it)=rcoef(m,it)
      enddo
      enddo
c
c==CORR between coef and data
c
      
      DO m=1,nmod !loop over mode

      do it=1,ifld
        ts3(it)=tcof(m,it)
      enddo
c
      do j=1,jmx
      do i=1,imx

      do it=1,ifld
        ts4(it)=afld(i,j,it)
      enddo

      call regr_t(ts3,ts4,ifld,corr(i,j),regr(i,j),undef)

      enddo
      enddo
c
      do i=1,imx
      do j=1,jmx
        varp(i,j)=regr(i,j)*regr(i,j)
      enddo
      enddo
        
      call area_avg(varp,coslat,imx,jmx,is,ie,js,je,out2)
      ratio=out2/vout0
      write(6,*)'mode=',m, ' ratio= ',ratio

      iw=iw+1
      write(51,rec=iw) corr
      iw=iw+1
      write(51,rec=iw) regr
c
      call normal(ts3,ts4,ifld)
c
      iw2=iw2+1
      write(52,rec=iw2) ts4
c
      enddo !loop over modes

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

      SUBROUTINE clm_std(f,mx,my,nt,its,clm,std)
      DIMENSION f(mx,my,nt),clm(mx,my),std(mx,my)
      do i=1,mx
      do j=1,my

      clm(i,j)=0.
      std(i,j)=0.

      ite=nt
      do it=its,ite
         clm(i,j)=clm(i,j)+f(i,j,it)
      enddo
      clm(i,j)=clm(i,j)/float(nt)
c
      do it=1,nt
        f(i,j,it)=f(i,j,it)-clm(i,j)
      enddo
c
      do it=1,nt
        std(i,j)=std(i,j)+f(i,j,it)*f(i,j,it)
      enddo
      std(i,j)=sqrt(std(i,j)/float(nt))   

      enddo
      enddo
c
      return
      end
c
      SUBROUTINE anom(rot,ifld)
      DIMENSION rot(ifld)
      avg=0.
      do i=1,ifld
         avg=avg+rot(i)/float(ifld)
      enddo
      do i=1,ifld
        rot(i)=rot(i)-avg
      enddo
c
      return
      end

      SUBROUTINE normal(rot,rot2,ifld)
      DIMENSION rot(ifld),rot2(ifld)
      avg=0.
      do i=1,ifld
         avg=avg+rot(i)/float(ifld)
      enddo
      do i=1,ifld
c       rot2(i)=rot(i)-avg
        rot2(i)=rot(i)
      enddo
c
      sd=0.
      do i=1,ifld
        sd=sd+rot2(i)*rot2(i)/float(ifld)
      enddo
        sd=sqrt(sd)
      do i=1,ifld
        rot2(i)=rot2(i)/sd
      enddo
      return
      end

      SUBROUTINE regr_t(f1,f2,ifld,cor,reg,undef)

      real f1(ifld),f2(ifld)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ifld
         cor=cor+f1(it)*f2(it)/float(ifld)
         sd1=sd1+f1(it)*f1(it)/float(ifld)
         sd2=sd2+f2(it)*f2(it)/float(ifld)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      if(f2(1).gt.99999) then
        reg=undef
        cor=undef
      endif

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
