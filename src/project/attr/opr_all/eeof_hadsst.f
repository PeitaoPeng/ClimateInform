      program eof
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. eof/pc analysis for errsst
C===========================================================
      PARAMETER (imx=90,jmx=89)
c     PARAMETER (nfld=lreal-ml+1,nw=2*nfld+15,nmod=10)
      PARAMETER (nw=2*nfld+15)
      PARAMETER (lats=35,late=75,lons=30,lone=75) !Pan Pacific: 20S-60N, 120E-60W
c     PARAMETER (lats=15,late=75,lons=1,lone=180) !global SST: 60S-60N, 0E-0W
c     PARAMETER (lats=35,late=75,lons=1,lone=180) !trop to NH SST: 20S-60N, 0E-0W
c     PARAMETER (ngrd=2836) !pan Pacific 
      PARAMETER (ngrd=2811) !pan Pacific 
c     PARAMETER (ngrd=8281) !global ocean 
      real fld3d(imx,jmx,lreal)
      real fld4d(imx,jmx,ml,nfld)
      real reg4d(imx,jmx,ml,nmod),reg4d2(imx,jmx,ml,nmod)
      real fldin(imx,jmx)
      real fld1(imx,jmx),fld2(imx,jmx),fld3(imx,jmx)
      real stdv(imx,jmx),corr(imx,jmx),rcorr(imx,jmx)
      real regr(imx,jmx),rregr(imx,jmx)
      real aaa(ml*ngrd,nfld),wk(nfld,ml*ngrd),tt(nmod,nmod)
      real eval(nfld),evec(ml*ngrd,nfld),coef(nfld,nfld)
      real rin(nfld),rot(nfld)
      real weval(nfld),wevec(ml*ngrd,nfld),wcoef(nfld,nfld)
      real reval(nmod),revec(ml*ngrd,nfld),rcoef(nmod,nfld)
      real xlat(jmx),coslat(jmx)
      real rwk(ml*ngrd),rwk2(ml*ngrd,nmod)
      real ts1(nfld),ts2(nfld),ts3(nfld),ts4(nfld)
      real ptn1(imx,jmx),ptn2(imx,jmx)
      real con4d(imx,jmx,ml,nfld),con4d2(imx,jmx,ml,nfld)
      dimension mask(imx,jmx)
c
      open(10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(50,form='unformatted',access='direct',recl=4*nfld)
      open(55,form='unformatted',access='direct',recl=4*imx*jmx)
      open(60,form='unformatted',access='direct',recl=4*nfld)
      open(65,form='unformatted',access='direct',recl=4*imx*jmx)
      open(70,form='unformatted',access='direct',recl=4*imx*jmx)
c
      do j=1,jmx
        xlat(j)=-88+(j-1)*2.            !rsst 2x2 resolution
        coslat(j)=sqrt(cos(xlat(j)*3.14159/180))
      end do

ccc loop over time

      iu=10
      its=iskip+1
c
c read in data
c
      iread=0
      do it=its,ltime,itdel
        read(iu,rec=it) fldin
        iread=iread+1
        do j=1,jmx
        do i=1,imx
          fld3d(i,j,iread)=fldin(i,j)
        enddo
        enddo
      enddo
      write(6,*) 'iread=',iread
c
c have a mask file 
c(if data in any grid in history is missing, take that as mising)
c
      do j=1,jmx
      do i=1,imx
        mask(i,j)=0
      enddo
      enddo
c
      do j=1,jmx
      do i=1,imx
        do it=1,iread 
        if(abs( fld3d(i,j,it)).gt.50) then
        mask(i,j)=1
        go to 777
        endif
        enddo
  777 continue

      enddo
      enddo
c
c feed in to a matrix for EOF claculation
c
      do it=1,iread-ml+1
        do mt=1,ml

c have fld4d for latter use 
        do j=1,jmx
        do i=1,imx
          if(mask(i,j).eq.0) then
          fld4d(i,j,mt,it)=fld3d(i,j,it+mt-1)
          else
          fld4d(i,j,mt,it)=-999.0
          endif
        enddo
        enddo
c
        ng=0
        do j=lats,late
        do i=lons,lone
          if(mask(i,j).eq.0) then
          ng=ng+1
          aaa(ng+(mt-1)*ngrd,it)=fld3d(i,j,it+mt-1)*coslat(j)
          end if
        end do
        end do
        enddo !mt loop
      end do !it loop

      write(6,*) 'ngrd= ',ng
      write(6,*) 'irec= ',iread
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

      do i=1,imx
      do j=1,jmx
        if(mask(i,j).eq.0) then
        itr=0
c       do it=mt,nfld+mt-1
        do it=1,nfld
          itr=itr+1
c         ts3(itr)=fld3d(i,j,it)
          ts3(itr)=fld4d(i,j,mt,it)
        enddo
c       write(6,*) 'itr=',itr
        call regr_t(ts1,ts3,nfld,itr,corr(i,j),regr(i,j))
        call regr_t(ts2,ts3,nfld,itr,rcorr(i,j),rregr(i,j))
        else
        corr(i,j)=-999.0
        regr(i,j)=-999.0
        rcorr(i,j)=-999.0
        rregr(i,j)=-999.0
        endif
      enddo
      enddo

      iw1=iw1+1
      write(55,rec=iw1) corr
      iw1=iw1+1
      write(55,rec=iw1) regr 
      iw2=iw2+1
      write(65,rec=iw2) rcorr
      iw2=iw2+1
      write(65,rec=iw2) rregr 

      do j=1,jmx
      do i=1,imx
        reg4d(i,j,mt,m)=regr(i,j)
        reg4d2(i,j,mt,m)=rregr(i,j)
      enddo
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
      call setzero(con4d,imx,jmx,ml,nfld)
      call setzero(con4d2,imx,jmx,ml,nfld)
      do it=1,nfld

      do i=1,imx
      do j=1,jmx
      do mt=1,ml

      if(mask(i,j).eq.0) then
      do m=1,nmod
        con4d(i,j,mt,it)=con4d(i,j,mt,it)+coef(m,it)*reg4d(i,j,mt,m)
        con4d2(i,j,mt,it)=con4d2(i,j,mt,it)+rcoef(m,it)*reg4d2(i,j,mt,m)
      enddo
      else
        con4d(i,j,mt,it)=-999.0
        con4d2(i,j,mt,it)=-999.0
      endif

      enddo
      enddo
      enddo

      enddo ! it loop
c
c write out obs and the recontructed
c
      iw=0
      do it=1,nfld

      do i=1,imx
      do j=1,jmx
        fld1(i,j)=fld4d(i,j,1,it)
        fld2(i,j)=con4d(i,j,1,it)
        fld3(i,j)=con4d2(i,j,1,it)
      enddo
      enddo

      iw=iw+1
      write(70,rec=iw) fld1
      iw=iw+1
      write(70,rec=iw) fld2
      iw=iw+1
      write(70,rec=iw) fld3

      enddo  ! it loop

      do mt=2,ml

      do i=1,imx
      do j=1,jmx
        fld1(i,j)=fld4d(i,j,mt,nfld)
        fld2(i,j)=con4d(i,j,mt,nfld)
        fld3(i,j)=con4d2(i,j,mt,nfld)
      enddo
      enddo

      iw=iw+1
      write(70,rec=iw) fld1
      iw=iw+1
      write(70,rec=iw) fld2
      iw=iw+1
      write(70,rec=iw) fld3

      enddo  ! mt loop
 1000 continue
      
      stop
      end

      SUBROUTINE setzero(fld,n,m,k,nt)
      DIMENSION fld(n,m,k,nt)

      do i=1,n
      do j=1,m
      do l=1,k
      do it=1,nt
         fld(i,j,l,it)=0.0
      enddo
      enddo
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

