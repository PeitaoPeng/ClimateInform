      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. eof/pc analysis for errsst
C===========================================================
      PARAMETER (ncd=102)
      PARAMETER (imx=36,jmx=19)
      PARAMETER (nw=2*nfld+15)
      PARAMETER (ngrd=ncd) !pan Pacific 
      real fld3d(ncd,ltime+1)
      real fld4d(ncd,ml,nfld)
      real reg4d(ncd,ml,nmod),reg4d2(ncd,ml,nmod)
      real fldin(ncd,ltime+1,12)
      real fld1(ncd),fld2(ncd),fld3(ncd)
      real stdv(ncd),corr(ncd),rcorr(ncd)
      real regr(ncd),rregr(ncd)
      real aaa(ml*ngrd,nfld),wk(nfld,ml*ngrd),tt(nmod,nmod)
      real eval(nfld),evec(ml*ngrd,nfld),coef(nfld,nfld)
      real rin(nfld),rot(nfld)
      real weval(nfld),wevec(ml*ngrd,nfld),wcoef(nfld,nfld)
      real reval(nmod),revec(ml*ngrd,nfld),rcoef(nmod,nfld)
      real rwk(ml*ngrd),rwk2(ml*ngrd,nmod)
      real ts1(nfld),ts2(nfld),ts3(nfld),ts4(nfld)
      real con4d(ncd,ml,nfld),con4d2(ncd,ml,nfld)
      real out1(imx,jmx),out2(imx,jmx)
c
      open(unit=10,form='formatted') !monthly cd temp or prec
      open(50,form='unformatted',access='direct',recl=4*nfld)
      open(55,form='unformatted',access='direct',recl=4*imx*jmx)
      open(60,form='unformatted',access='direct',recl=4*nfld)
      open(65,form='unformatted',access='direct',recl=4*imx*jmx)
      open(70,form='unformatted',access='direct',recl=4*imx*jmx)
c
c== read in 102CD data (1931-cur)
      do ny=1,ltime+1
      do m=1,12
        read(10,888) fld1
 888  format(10f7.1)
        do i=1,ncd
          fldin(i,ny,m)=fld1(i)
        enddo
c       write(6,888) fld1
      enddo
      enddo
c
c== seasonal mean
      call season_anom(fldin,ltime+1,1,ltime,iseason,ncd,fld3d)
c       write(6,888) fld3d
c
c feed in to a matrix for EOF claculation
c
      do it=1,ltime-ml+1
        do mt=1,ml

c have fld4d for latter use 
        do i=1,ncd
          fld4d(i,mt,it)=fld3d(i,it+mt-1)
        enddo
c
        ng=0
        do i=1,ncd
          ng=ng+1
          aaa(ng+(mt-1)*ngrd,it)=fld3d(i,it+mt-1)
        end do
        enddo !mt loop
      end do !it loop

      write(6,*) 'ngrd= ',ng
      write(6,*) 'irec= ',ltime
      write(6,*) 'nfld= ',nfld
c     go to 1000

cc... EOF analysis begin
      write(6,*) 'eof begins'
      call EOFS(aaa,ml*ngrd,nfld,nfld,eval,evec,coef,wk,ID)
      write(6,*) 'reof begins'
      call REOFS(aaa,ml*ngrd,nfld,nfld,wk,ID,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
cc... arrange reval,revec and rcoef in decreasing order
      call order(ml*ngrd,nfld,nmod,reval,revec,rcoef)
c
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
C
CCC...CORR between coef(or rcoef) and data
C
      iw1=0
      iw2=0
      DO m=1,nmod      !loop over mode (1-6)
c
      do it=1,nfld
        ts1(it)=coef(m,it)
        ts2(it)=rcoef(m,it)
      enddo
      call normal(ts1,nfld)
      call normal(ts2,nfld)

      do mt=1,ml

      do i=1,ncd
        itr=0
        do it=1,nfld
          itr=itr+1
          ts3(itr)=fld4d(i,mt,it)
        enddo
c       write(6,*) 'itr=',itr
        call regr_t(ts1,ts3,nfld,itr,corr(i),regr(i))
        call regr_t(ts2,ts3,nfld,itr,rcorr(i),rregr(i))
      enddo

      iw1=iw1+1
      call CD102_2_2x2(corr,out1)
      write(55,rec=iw1) out1
      iw1=iw1+1
      call CD102_2_2x2(regr,out1)
      write(55,rec=iw1) out1 
      iw2=iw2+1
      call CD102_2_2x2(rcorr,out1)
      write(65,rec=iw2) out1
      iw2=iw2+1
      call CD102_2_2x2(rregr,out1)
      write(65,rec=iw2) out1 

      do i=1,ncd
        reg4d(i,mt,m)=regr(i)
        reg4d2(i,mt,m)=rregr(i)
      enddo

      enddo  !mt loop
c
      do n=1,nfld
        rot(n)=rcoef(m,n)
      end do

      call normal(rot,nfld)

      do n=1,nfld
        rcoef(m,n)=rot(n) !save the normalized for later use
      end do

      write(60,rec=m) rot

      do n=1,nfld
        rot(n)=coef(m,n)
      end do
c
      call normal(rot,nfld)
c
      do n=1,nfld
        coef(m,n)=rot(n) !save the normalized for later use
      end do

      write(50,rec=m) rot

      END DO    !loop over mode 
c
c construct data and compare with obs (write out both)
c
      call setzero(con4d,ncd,ml,nfld)
      call setzero(con4d2,ncd,ml,nfld)
      do it=1,nfld

      do i=1,ncd
      do mt=1,ml

      do m=1,nmod
        con4d(i,mt,it)=con4d(i,mt,it)+coef(m,it)*reg4d(i,mt,m)
        con4d2(i,mt,it)=con4d2(i,mt,it)+rcoef(m,it)*reg4d2(i,mt,m)
      enddo

      enddo
      enddo

      enddo ! it loop
c
c write out obs and the recontructed
c
      iw=0
      do it=1,nfld

      do i=1,ncd
        fld1(i)=fld4d(i,1,it)
        fld2(i)=con4d(i,1,it)
        fld3(i)=con4d2(i,1,it)
      enddo

      iw=iw+1
      call CD102_2_2x2(fld1,out1)
      write(70,rec=iw) out1
      iw=iw+1
      call CD102_2_2x2(fld2,out1)
      write(70,rec=iw) out1
      iw=iw+1
      call CD102_2_2x2(fld3,out1)
      write(70,rec=iw) out1

      enddo  ! it loop

      do mt=2,ml

      do i=1,ncd
        fld1(i)=fld4d(i,mt,nfld)
        fld2(i)=con4d(i,mt,nfld)
        fld3(i)=con4d2(i,mt,nfld)
      enddo

      iw=iw+1
      call CD102_2_2x2(fld1,out1)
      write(70,rec=iw) out1
      iw=iw+1
      call CD102_2_2x2(fld2,out1)
      write(70,rec=iw) out1
      iw=iw+1
      call CD102_2_2x2(fld3,out1)
      write(70,rec=iw) out1

      enddo  ! mt loop
 1000 continue
      
      stop
      end

      SUBROUTINE setzero(fld,n,k,nt)
      DIMENSION fld(n,k,nt)

      do i=1,n
      do l=1,k
      do it=1,nt
         fld(i,l,it)=0.0
      enddo
      enddo
      enddo

      return
      end
      SUBROUTINE setzero2(fld,n,k)
      DIMENSION fld(n,k)

      do i=1,n
      do l=1,k
         fld(i,l)=0.0
      enddo
      enddo

      return
      end

      SUBROUTINE normal(rot,ltime)
      DIMENSION rot(ltime)
      sd=0.
      do i=1,ltime
        sd=sd+rot(i)*rot(i)/float(ltime)
      enddo
      sd=sqrt(sd)
      do i=1,ltime
      rot(i)=rot(i)/sd
      enddo
      return
      end

      SUBROUTINE correl(fld1,fld2,n,m,cr)
      DIMENSION fld1(n,m),fld2(n,m)
      cr=0
      sd1=0
      sd2=0
      do i=1,n
      do j=1,m
         cr=cr+fld1(i,j)*fld2(i,j)
         sd1=sd1+fld1(i,j)*fld1(i,j)
         sd2=sd2+fld2(i,j)*fld2(i,j)
      enddo
      enddo
         sd1=sqrt(sd1)
         sd2=sqrt(sd2)
         cr=cr/(sd1*sd2)
      return
      end

      SUBROUTINE regr_t(f1,f2,ltime,lreal,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,lreal
         cor=cor+f1(it)*f2(it)/float(lreal)
         sd1=sd1+f1(it)*f1(it)/float(lreal)
         sd2=sd2+f2(it)*f2(it)/float(lreal)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end

      subroutine season_mean(fld,nyear,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal mean of 102 cd data
C===========================================================
      real fld(nmax,nyear,12)
      real clim(nmax,12),out(nmax,nyear-1)
c
      IF(mons.eq.12) THEN

      m1=12
      m2=1
      m3=2
c
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny+1,m2)+fld(i,ny+1,m3))/3.
        enddo
      enddo

      ELSE IF (mons.eq.11) THEN
c

      m1=11
      m2=12
      m3=1
c
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny+1,m3))/3.
        enddo
      enddo
c
      ELSE

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
      do ny=1,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny,m3))/3.
        enddo
      enddo

      END IF
c
      return
      END
      subroutine season_anom(fld,nytot,nys,nyear,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      real fld(nmax,nytot,12)
      real clim(nmax,12),out(nmax,nytot)
c
      call setzero2(clim,nmax,12)
      do m=1,12
      do ny=nys,nyear-1
        do i=1,nmax
         clim(i,m)=clim(i,m)+fld(i,ny,m)/float(nyear-nys)
        enddo
      end do
      end do
c
c have seasonal mean
c
      IF(mons.eq.12) THEN

      m1=12
      m2=1
      m3=2
c
c for history
      do ny=nys,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny+1,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo
c for target year
        do i=1,nmax
      out(i,nyear)=(fld(i,nyear,m1)+fld(i,nyear+1,m2)+fld(i,nyear+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo

      ELSE IF (mons.eq.11) THEN
c

      m1=11
      m2=12
      m3=1
c
c for history
      do ny=nys,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo
c for target year
        do i=1,nmax
      out(i,nyear)=(fld(i,nyear,m1)+fld(i,nyear,m2)+fld(i,nyear+1,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
c
      ELSE
      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
c for history
      do ny=nys,nyear-1
        do i=1,nmax
        out(i,ny)=(fld(i,ny,m1)+fld(i,ny,m2)+fld(i,ny,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo
      enddo
c for target year
        do i=1,nmax
      out(i,nyear)=(fld(i,nyear,m1)+fld(i,nyear,m2)+fld(i,nyear,m3)-
     &         (clim(i,m1)+clim(i,m2)+clim(i,m3)))/3.
        enddo

      END IF
c
      return
      END


