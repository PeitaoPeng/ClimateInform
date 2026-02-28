CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C convert forecast to categorical data
C===========================================================
      include "parm.h"
      parameter(ms1=20,ms2=60)  !ensemble sizes for different periods
c     parameter(imx=180,jmx=91,imo=36,jmo=19)
      DIMENSION mask(imo,jmo),wko(imo,jmo)
      DIMENSION wk1(imx,jmx),wk2(imx,jmx)
      DIMENSION wk3(imo,jmo),wk4(imo,jmo)
      DIMENSION abov(imo,jmo)
      DIMENSION belw(imo,jmo)
      DIMENSION ctgr(imo,jmo)
      DIMENSION abln(imo,jmo,12,2)
C
      OPEN(unit=11,form='unformatted',access='direct',recl=imx*jmx*4)
      OPEN(unit=12,form='unformatted',access='direct',recl=imx*jmx*4)
      OPEN(unit=13,form='unformatted',access='direct',recl=imo*jmo*4)
C
      OPEN(unit=21,form='unformatted',access='direct',recl=imo*jmo*4)
      OPEN(unit=22,form='unformatted',access='direct',recl=imo*jmo*4)
      OPEN(unit=23,form='unformatted',access='direct',recl=imo*jmo*4)
C
C= read in mask
      read(13,rec=1) wko
      call real_2_itg(wko,mask,imo,jmo)
      write(6,*) 'have read in mask'
C= read in tercile boundaries
      ir=0
      do im=1,12
      ir=ir+1
        read(12,rec=ir) wk1
      ir=ir+1
        read(12,rec=ir) wk2
      call to_us(wk1,wk3,imx,jmx,imo,jmo)
      call to_us(wk2,wk4,imx,jmx,imo,jmo)
        do i=1,imo
        do j=1,jmo
          abln(i,j,im,1)=wk3(i,j)
          abln(i,j,im,2)=wk4(i,j)
        enddo
        enddo
      enddo
      write(6,*) 'have read bnd'
C= read fld data
      it=0
      ir=0
      mm=ms1
      uu=11
      do iy=1,50  !1995-
      do im=1,12
      it=it+1
      if(it.gt.ltime) go to 100
c
      call setzero(abov,imo,jmo)
      call setzero(belw,imo,jmo)
c
      DO m=1,mm
      ir=ir+1
      write(6,*) 'it=',it,'  ir=',ir,'  uu=',uu
      read(uu,rec=ir) wk1
C limit to US region
      call to_us(wk1,wko,imx,jmx,imo,jmo)
c
      do i=1,imo
      do j=1,jmo
c
      if(mask(i,j).eq.1) then
C
      a=abln(i,j,im,1)
      b=abln(i,j,im,2)
      IF (wko(i,j).le.b) belw(i,j)=belw(i,j)+100./float(mm)
      IF (wko(i,j).gt.a) abov(i,j)=abov(i,j)+100./float(mm)
C
      else
C
      belw(i,j)=-999.0
      abov(i,j)=-999.0
C
      end if
C
      enddo
      enddo
c
      ENDDO   !m=1->mm loop
c
      write(21,rec=it) belw
      write(22,rec=it) abov
C
C  have categorical #
C
      call categ(belw,abov,ctgr,mask,imo,jmo)
      write(23,rec=it) ctgr
C
      ENDDO  !im loop
      ENDDO  !iy loop
100   PRINT 150
150   FORMAT('program complete')
      STOP
      END
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  real 2 integer
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine real_2_itg(wk,mw,m,n)
      dimension wk(m,n),mw(m,n)
c
      do i=1,m
      do j=1,n
      mw(i,j)=wk(i,j)
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set mxn matrix zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(wk,m,n)
      dimension wk(m,n)
c
      do i=1,m
      do j=1,n
      wk(i,j)=0.
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  write out us area
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine to_us(wk1,wk2,imx,jmx,imo,jmo)
      dimension wk1(imx,jmx),wk2(imo,jmo)
c
      do i=116,151
      do j=56,74
      wk2(i-115,j-55)=wk1(i,j)
      end do
      end do
c
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  have categorical #
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine categ(wkb,wka,wko,mask,imx,jmx)
      dimension wkb(imx,jmx),wka(imx,jmx)
      dimension wko(imx,jmx),mask(imx,jmx)
c
      do i=1,imx
      do j=1,jmx
c
      if(mask(i,j).eq.1) then
C
      k1=wkb(i,j)
      k3=wka(i,j)
      k2=100-k1-k3
      call compares(k1,k2,k3,ct)
      write(6,*) k1,k2,k3,ct
      wko(i,j)=ct
C
      else
C
      wko(i,j)=-999.0
C
      end if
C
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  have categorical #
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine compares(k1,k2,k3,co)
c
      ko=MAX0(k1,k2,k3)
      if (ko.eq.k1) co=1
      if (ko.eq.k2) co=2
      if (ko.eq.k3) co=3
c
      return
      end
