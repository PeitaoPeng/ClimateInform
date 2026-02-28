C==========================================================
C  skill (cor & rms) of OCN prd based on PC
C==========================================================
      include "parm.h"
      real obs(imx,jmx)
      real obs3d(imx,jmx,nyr,12)
      real nino34(nyr,12)
      real ssti(nyr),sst(nyr),wk1(nyr-1),wk2(nyr-1)
C
      real fld3d(imx,jmx,nyr),obsfld(imx,jmx,nyr)
      real fld1d(nyr),fld1d2(nyr),fld1d3(nyr),trend(nyr)
      real freq(imx,jmx),cmpp(imx,jmx) !for wp&ct cmp
      real w2d1(imx,jmx),w2d2(imx,jmx)
      real cmp(imx,jmx,5),frq(imx,jmx,5)
      real cfdn(imx,jmx,nyr-1,5),cmpn(imx,jmx,5)
      real bord(imx,jmx,2)
c
      real fld3d2(imx,jmx,nyr-1),fld3d3(imx,jmx,nyr-1)
      real fldn(imx,jmx,nyr-1)
      real fcst(imx,jmx,nyr),fcst2(imx,jmx,nyr)
      real regr(imx,jmx),corr(imx,jmx),cons(imx,jmx)
      real acts(nyr),acts2(nyr)
      real acsp(imx,jmx),acsp2(imx,jmx)
      real ssti2(nyr-1),ssti3(nyr-1),sst2(nyr-1)
      real wk3(nyr),wk4(nyr)
c
      dimension nc(5)
c
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx) !monthly temp or prec
      open(unit=11,form='unformatted',access='direct',recl=4) !monthly nino34
c
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4)
c
c== read in temp or prec data (1948.1-cur)
      ir=0
      do n=1,nyr
      do m=1,12
      ir=ir+1
        if(ir.gt.ltime) go to 111
        read(10,rec=ir) obs
        do i=1,imx
        do j=1,jmx
          obs3d(i,j,n,m)=obs(i,j)
        enddo
        enddo
      enddo
      enddo
  111 continue
c== read in monthly nino34 (1948.1-cur)
      ir=0
      do n=1,nyr
      do m=1,12
      ir=ir+1
        if(ir.gt.ltime) go to 222
        read(11,rec=ir) nino34(n,m)
      enddo
      enddo
  222 continue
c
c== seasonal mean
      call season_mean_2d(obs3d,nyr,iseason,imx,jmx,obsfld)
      call season_mean_1d(nino34,nyr,iseason,fld1d)
c== detrend nino34
      if(iseason.eq.11.or.iseason.eq.12) then
      ite=nyr-1
      else
      ite=nyr
      endif
      write(6,*) 'nyr=',nyr,'  ite=',ite
      call ltrend(fld1d,ssti,trend,1,nyr,1,ite,a,b)
c== detrend temp or prec
      do i=1,imx
      do j=1,jmx
      if(abs(obsfld(i,j,1)).lt.900) then
        do it=1,ite
        wk3(it)=obsfld(i,j,it)
        enddo
        call hp_flt(wk3,wk4,nyr,1,ite)
        do it=1,ite
        fld3d(i,j,it)=wk4(it)
        enddo
      else
        do it=1,ite
        fld3d(i,j,it)=-9999.0
        enddo
      endif
      enddo
      enddo
c
C== normalize sst index
      call normal(ssti,nyr,ite,std)
c
c== just pick up ENSO year data
c
      kt=0
      do jt=1,ite
      if(abs(ssti(jt)).lt.0.56) go to 555   !avoid ENSO normal  year
      kt=kt+1
      do i=1,imx
      do j=1,jmx
      fld3d2(i,j,kt)=fld3d(i,j,jt)
      enddo
      enddo
      ssti2(kt)=ssti(jt)
 555  continue
      enddo  !jt loop
c
c== Time loop for cross validation
c
      iw=0
      do it=1,kt
c
      ktt=0
      do jt=1,kt
      if(jt.eq.it) go to 666   !avoid target year data
      ktt=ktt+1
      do i=1,imx
      do j=1,jmx
      fld3d3(i,j,ktt)=fld3d2(i,j,jt)
      enddo
      enddo
      ssti3(ktt)=ssti2(jt)
 666  continue
      enddo  !jt loop
      write(6,*) 'ktt=',ktt
        
C== composite based on nino34
      nyr2=nyr-1
      nyr3=ktt
      call comp_5ctg(ssti3,fld3d3,imx,jmx,nyr2,nyr3,ssttgt,cmp,frq,
     &cmpp,freq,sst2,cmpn,fldn,cfdn,nc,bord,wk1,wk2)
c
      call regr_nino(ssti3,fld3d3,imx,jmx,nyr2,nyr3,ssttgt,regr,corr,
     &cons)
      do i=1,imx
      do j=1,jmx
      fcst(i,j,it)=cmpp(i,j)
      fcst2(i,j,it)=cons(i,j)
      enddo
      enddo
      iw=iw+1
      write(20,rec=iw) cmpp
      iw=iw+1
      write(20,rec=iw) cons

      ENDDO ! it loop
c
c== calculate acc skill in time domain
c
      do i=1,imx
      do j=1,jmx
        if(abs(fld3d(i,j,1)).lt.900) then
        do it=1,kt
c       do it=1,ite
        fld1d(it)=fcst(i,j,it)
        fld1d2(it)=fcst2(i,j,it)
        fld1d3(it)=fld3d(i,j,it)
        enddo
c       call acc_s(fld1d,fld1d3,nyr,ite,acsp(i,j))
c       call acc_s(fld1d2,fld1d3,nyr,ite,acsp2(i,j))
        call acc_s(fld1d,fld1d3,nyr,kt,acsp(i,j))
        call acc_s(fld1d2,fld1d3,nyr,kt,acsp2(i,j))
        else
        acsp(i,j)=-9999.0
        acsp2(i,j)=-9999.0
        endif
      enddo
      enddo
      iw=1
      write(21,rec=iw) acsp
      iw=iw+1
      write(21,rec=iw) acsp2
     
      stop
      end
c
      SUBROUTINE regr_nino(f1d,f3d,imx,jmx,nyr,nyr2,ssttgt,regr,corr,
     &cons)

      real f1(nyr),f2(nyr)
      real f1d(nyr),f3d(imx,jmx,nyr)
      real regr(imx,jmx),corr(imx,jmx)
      real cons(imx,jmx)
c
      DO i=1,imx
      DO j=1,jmx
c
      do it=1,nyr2
        f1(it)=f1d(it)
        f2(it)=f3d(i,j,it)
      enddo
c
      IF(abs(f2(1)).lt.999) then
      v1=0.
      v2=0.
      do it=1,nyr2 
      v1=v1+f1(it)/float(nyr2)
      v2=v2+f2(it)/float(nyr2)
      enddo

      cor=0.
      sd1=0.
      sd2=0.
      do it=1,nyr2
         cor=cor+(f1(it)-v1)*(f2(it)-v2)/float(nyr2)
         sd1=sd1+(f1(it)-v1)*(f1(it)-v1)/float(nyr2)
         sd2=sd2+(f2(it)-v2)*(f2(it)-v2)/float(nyr2)
      enddo
c
      sd1=sd1**0.5
      sd2=sd2**0.5
      regr(i,j)=cor/(sd1)
      corr(i,j)=cor/(sd1*sd2)
      cons(i,j)=ssttgt*regr(i,j)/sd1  !constructed anom
      sstnm=ssttgt/sd1
c     write(6,*) 'normalized sst=',sstnm
c
      else
c
      regr(i,j)=-9999.0
      corr(i,j)=-9999.0
      cons(i,j)=-9999.0
c
      endif
c
      ENDDO
      ENDDO
      write(6,*) 'current Nino34 SST=',ssttgt, '  stdv of sst=',sd1
c
      return
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set 3-D array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE setzero_3d(fld,n,m,k)
      real fld(n,m,k)
      do i=1,n
      do j=1,m
      do l=1,k
         fld(i,j,l)=0.0
      enddo
      enddo
      enddo
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  5-category composite based on Nino34 SST
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE comp_5ctg(ssti,fld,imx,jmx,nt,nt2,ssttgt,cmp,frq,
     &cmpp,freq,sst,cmpn,fldn,cfdn,nc,bord,wk1,wk2)
c
      real ssti(nt),sst(nt)
      real fld(imx,jmx,nt),fldn(imx,jmx,nt)
c
      real cmp(imx,jmx,5),frq(imx,jmx,5)
      real cfdn(imx,jmx,nt,5),cmpn(imx,jmx,5)
      real cmpp(imx,jmx),freq(imx,jmx)
c
      real wk1(nt),wk2(nt)
      real bord(imx,jmx,2)
      DIMENSION nc(5)  !# of each composite
c
      crt1=1.2
      crt2=0.56
      crt3=-0.56
      crt4=-1.2
c
c     write(6,*) 'imx,jmx=',imx,jmx
      call setzero_3d(cmp,imx,jmx,5)
      call setzero_3d(cmpn,imx,jmx,5)
      call setzero_3d(frq,imx,jmx,5)

      do k=1,5
        nc(k)=0
      enddo
c
c==normalize sst, HP filte fld and normalize it
c
      do it=1,nt2
        sst(it)=ssti(it)
      enddo

c     call normal(sst,nt,nt2,std)

      do i=1,imx
      do j=1,jmx

      if(abs(fld(i,j,1)).lt.900) then

c== HP fld
      do k=1,nt2
        wk1(k)=fld(i,j,k)
      enddo

      call hp_flt(wk1,wk2,nt,1,nt2)

      do k=1,nt2
        fld(i,j,k)=wk2(k)
      enddo
c== normalize
        do k=1,nt2
          wk1(k)=fld(i,j,k)
          wk2(k)=fld(i,j,k)
        enddo

        call normal(wk1,nt,nt2,std)
        call anomaly(wk2,nt,nt2)

        do k=1,nt2
          fldn(i,j,k)=wk1(k)
          fld(i,j,k)=wk2(k)
        enddo

      else

        do k=1,nt2
          fldn(i,j,k)=-9999.0
          fld(i,j,k)=-9999.0
        enddo

      endif

      enddo
      enddo

c==make composite for each category

      do it=1,nt2
c
      si=sst(it)
      if(si.gt.crt1) then
        nc(1)=nc(1)+1
        do i=1,imx
        do j=1,jmx
        cmp(i,j,1)=cmp(i,j,1)+fld(i,j,it)
        cmpn(i,j,1)=cmpn(i,j,1)+fldn(i,j,it)
        cfdn(i,j,nc(1),1)=fldn(i,j,it)
        enddo
        enddo
      else if(si.gt.crt2.and.si.le.crt1) then
        nc(2)=nc(2)+1
        do i=1,imx
        do j=1,jmx
        cmp(i,j,2)=cmp(i,j,2)+fld(i,j,it)
        cmpn(i,j,2)=cmpn(i,j,2)+fldn(i,j,it)
        cfdn(i,j,nc(2),2)=fldn(i,j,it)
        enddo
        enddo
      else if(si.ge.crt3.and.si.le.crt2) then
        nc(3)=nc(3)+1
        do i=1,imx
        do j=1,jmx
        cmp(i,j,3)=cmp(i,j,3)+fld(i,j,it)
        cmpn(i,j,3)=cmpn(i,j,3)+fldn(i,j,it)
        cfdn(i,j,nc(3),3)=fldn(i,j,it)
        enddo
        enddo
      else if(si.lt.crt3.and.si.ge.crt4) then
        nc(4)=nc(4)+1
        do i=1,imx
        do j=1,jmx
        cmp(i,j,4)=cmp(i,j,4)+fld(i,j,it)
        cmpn(i,j,4)=cmpn(i,j,4)+fldn(i,j,it)
        cfdn(i,j,nc(4),4)=fldn(i,j,it)
        enddo
        enddo
      else if(si.lt.crt4) then
        tt=it+1947
c       write(6,*) 'strong cold year=',tt
        nc(5)=nc(5)+1
        do i=1,imx
        do j=1,jmx
        cmp(i,j,5)=cmp(i,j,5)+fld(i,j,it)
        cmpn(i,j,5)=cmpn(i,j,5)+fldn(i,j,it)
        cfdn(i,j,nc(5),5)=fldn(i,j,it)
        enddo
        enddo
      endif
c
      enddo  !it
c
      do k=1,5
      do i=1,imx
      do j=1,jmx
        cmp(i,j,k)=cmp(i,j,k)/float(nc(k))
        cmpn(i,j,k)=cmpn(i,j,k)/float(nc(k))
      enddo
      enddo
      enddo

      write(6,*) 'composite size:',nc(1),nc(2),nc(3),nc(4),nc(5)
c
c== have frequency for each composite
c

c== have borders of 3-terciles
      do i=1,imx
      do j=1,jmx

      if(abs(fld(i,j,1)).lt.900) then

      do k=1,nt2
        wk1(k)=fldn(i,j,k)
        wk2(k)=k
      enddo

      call hpsort(nt,nt2,wk1,wk2)
c
        if(i.eq.180.and.j.eq.240) then
c       write(6,444) wk1
        naa=2*nt/3
        nbb=nt/3
        write(6,*) 'naa,nbb=',naa,nbb
  444 format(10f7.2)
        end if
c
        naa=2*nt2/3
        nbb=nt2/3

        bord(i,j,1)=wk1(naa)
        bord(i,j,2)=wk1(nbb)

      else

        do k=1,nt2
          bord(i,j,1)=-9999.0
          bord(i,j,2)=-9999.0
        enddo

      endif

      enddo
      enddo

      do k=1,5
      do i=1,imx
      do j=1,jmx

      if(abs(fld(i,j,1)).lt.900) then

      aa=bord(i,j,1)
      bb=bord(i,j,2)

      cc=0.0

      if(cmpn(i,j,k).gt.cc)then

      do it=1,nc(k)
        if(cfdn(i,j,it,k).gt.cc) then
        frq(i,j,k)=frq(i,j,k)+100./float(nc(k))
        endif
      enddo

      else if(cmpn(i,j,k).lt.cc) then

      do it=1,nc(k)
        if(cfdn(i,j,it,k).lt.cc) then
        frq(i,j,k)=frq(i,j,k)+100./float(nc(k))
        endif
      enddo

      endif


      else

        frq(i,j,k)=-9999.0
        cmp(i,j,k)=-9999.0

      endif
      enddo
      enddo
      enddo

c== to see which category the tgtseason falls
      si=ssttgt
      if(si.gt.crt1) then

      do i=1,imx
      do j=1,jmx
      cmpp(i,j)=cmp(i,j,1)
      freq(i,j)=frq(i,j,1)
      enddo
      enddo

      else if(si.gt.crt2.and.si.le.crt1) then

      do i=1,imx
      do j=1,jmx
      cmpp(i,j)=cmp(i,j,2)
      freq(i,j)=frq(i,j,2)
      enddo
      enddo

      else if(si.ge.crt3.and.si.le.crt2) then

      do i=1,imx
      do j=1,jmx
      cmpp(i,j)=cmp(i,j,3)
      freq(i,j)=frq(i,j,3)
      enddo
      enddo

      else if(si.lt.crt3.and.si.ge.crt4) then

      do i=1,imx
      do j=1,jmx
      cmpp(i,j)=cmp(i,j,4)
      freq(i,j)=frq(i,j,4)
      enddo
      enddo

      else if(si.lt.crt4) then

      do i=1,imx
      do j=1,jmx
      cmpp(i,j)=cmp(i,j,5)
      freq(i,j)=frq(i,j,5)
      enddo
      enddo

      endif

      return
      end

      subroutine season_mean_1d(fld,nyear,mons,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal mean of 102 cd data
C===========================================================
      real fld(nyear,12)
      real clim(12),out(nyear)
c
      IF(mons.eq.12) THEN

      m1=12
      m2=1
      m3=2
c
      do ny=1,nyear-1
        out(ny)=(fld(ny,m1)+fld(ny+1,m2)+fld(ny+1,m3))/3.
      enddo

      ELSE IF (mons.eq.11) THEN
c

      m1=11
      m2=12
      m3=1
c
      do ny=1,nyear-1
        out(ny)=(fld(ny,m1)+fld(ny,m2)+fld(ny+1,m3))/3.
      enddo
c
      ELSE

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
      do ny=1,nyear
        out(ny)=(fld(ny,m1)+fld(ny,m2)+fld(ny,m3))/3.
      enddo

      END IF
c
      return
      END
c
      subroutine season_mean_2d(fld,nyear,mons,imx,jmx,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal mean of 102 cd data
C===========================================================
      real fld(imx,jmx,nyear,12)
      real clim(imx,jmx,12),out(imx,jmx,nyear)
c
      IF(mons.eq.12) THEN

      m1=12
      m2=1
      m3=2
c
      do ny=1,nyear-1
        do i=1,imx
        do j=1,jmx
      out(i,j,ny)=(fld(i,j,ny,m1)+fld(i,j,ny+1,m2)+fld(i,j,ny+1,m3))/3.
        enddo
        enddo
      enddo

      ELSE IF (mons.eq.11) THEN
c

      m1=11
      m2=12
      m3=1
c
      do ny=1,nyear-1
        do i=1,imx
        do j=1,jmx
        out(i,j,ny)=(fld(i,j,ny,m1)+fld(i,j,ny,m2)+fld(i,j,ny+1,m3))/3.
        enddo
        enddo
      enddo
c
      ELSE

      m1=mons      !m1=1 -> JFM;
      m2=m1+1
      m3=m2+1
c
      do ny=1,nyear
        do i=1,imx
        do j=1,jmx
        out(i,j,ny)=(fld(i,j,ny,m1)+fld(i,j,ny,m2)+fld(i,j,ny,m3))/3.
        enddo
        enddo
      enddo

      END IF
c
      return
      END
c

      subroutine season_anom(fld,nytot,nys,nyear,mons,nmax,out)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. calculate seasonal anom & clim of 102 cd data
C===========================================================
      real fld(nmax,nytot,12)
      real clim(nmax,12),out(nmax,nytot)
c
      call setzero(clim,nmax,12)
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
c
      SUBROUTINE anomaly(rot,ltime,ite)
      DIMENSION rot(ltime)
c
      avg=0
      do i=1,ite
      avg=avg+rot(i)/float(ite)
      enddo

      do i=1,ite
        rot(i)=rot(i)-avg
      enddo

      return
      end
c
      SUBROUTINE normal(rot,ltime,ite,sd)
      DIMENSION rot(ltime)
c
      avg=0
      do i=1,ite
      avg=avg+rot(i)/float(ite)
      enddo
      do i=1,ite
      rot(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,ite
        sd=sd+rot(i)*rot(i)/float(ite)
      enddo
        sd=sqrt(sd)
      do i=1,ite
        rot(i)=rot(i)/sd
      enddo

      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  have anom wrt 11-yr runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine hp_flt(fld,out,nt,its,ite)
      dimension fld(nt),out(nt)
c
      do j=its+5,ite-5
        avg=0.
        do k=j-5,j+5
          avg=avg+fld(k)/11.
        enddo
        out(j)=fld(j)-avg
        js=its+5
        je=ite-5
        if(j.eq.js) avgs=avg
        if(j.eq.je) avge=avg
      enddo !j
c
      do j=1,5
        out(its+j-1)=fld(its+j-1)-avgs
        out(ite+j-5)=fld(ite+j-5)-avge
      enddo !j
        out(ite+1)=fld(ite+1)-avge
c
      return
      end
c
      subroutine d2_2_d3(eof,eof_t,imax,mmax,ntprd,kt) !save eofs for later use
      real eof(imax,mmax),eof_t(imax,mmax,ntprd)
      do m=1,mmax
      do i=1,imax
        eof_t(i,m,kt)=eof(i,m)
      enddo
      enddo
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  using least square to have y=a+bx
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ltrend(grid,out,out2,ncd,nt,its,ite,a,b)
      dimension grid(ncd,nt),out(ncd,nt)
      dimension out2(ncd,nt)
      dimension a(ncd),b(ncd)
      real lxx, lxy
c
      do i=1,ncd
c
      xb=0
      yb=0
      do j=its,ite
        xb=xb+float(j)/float(ite-its+1)
        yb=yb+grid(i,j)/float(ite-its+1)
      enddo
c
      lxx=0.
      lxy=0.
      do j=its,ite
      lxx=lxx+(j-xb)*(j-xb)
      lxy=lxy+(j-xb)*(grid(i,j)-yb)
      enddo
      b(i)=lxy/lxx
      a(i)=yb-b(i)*xb
      enddo !over i
c
      do i=1,ncd
      do j=1,nt
        out(i,j)=grid(i,j)-b(i)*float(j)-a(i) !detrended
        out2(i,j)=b(i)*float(j)+a(i) !trend
      enddo
      enddo
c
      return
      end
C
      subroutine anom_wmo(fldin,fldout,ncd,nt,ntprd,ndec)
      real fldin(ncd,nt),clm(ndec,ncd)
      real fldout(ncd,ntprd)
c have wmo clim
      do id=1,ndec
      do i=1,ncd
      clm(id,i)=0.
      do k=1,30
        clm(id,i)=clm(id,i)+fldin(i,k+(id-1)*10)/30.
      enddo
      enddo
      enddo
c anom w.r.t wmo clim
      do id=1,ndec-1
      do i=1,ncd
      do k=1,10
        kt=k+30+(id-1)*10
        fldout(i,kt-30)=fldin(i,kt)-clm(id,i)
      enddo
      enddo
      enddo
c
      ks=30+(ndec-1)*10+1
      do i=1,ncd
      do k=ks,nt !2001-cur (at most 2010)
        fldout(i,k-30)=fldin(i,k)-clm(ndec,i)
      enddo
      enddo
      
      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  acc for spatial pattern
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine acc_s(a,b,nn,n,c)
      real a(nn),b(nn)
c
      avg_a=0.
      avg_b=0.
      do i=1,n
        avg_a=avg_a+a(i)/float(n)
        avg_b=avg_b+b(i)/float(n)
      enddo
c
      do i=1,n
      a(i)=a(i)-avg_a
      b(i)=b(i)-avg_b
      enddo
c
      sd_a=0
      sd_b=0
      ac=0
      do i=1,n
      sd_a=sd_a+a(i)*a(i)/float(n)
      sd_b=sd_b+b(i)*b(i)/float(n)
      ac=ac+a(i)*b(i)/float(n)
      enddo
      sd_a=sqrt(sd_a)
      sd_b=sqrt(sd_b)
      if(abs(sd_a).gt.0.0001) then
      c=ac/(sd_a*sd_b)
      else
      c=-9999.0
      endif
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  rms
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine rms_s(a,b,n,c)
      real a(n),b(n)
c
      c=0.
      do i=1,n
      c=c+(a(i)-b(i))*(a(i)-b(i))/float(n)
      enddo
      c=sqrt(c)
c
      return
      end

      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END
