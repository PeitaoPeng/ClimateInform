CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C convert forecast to categorical data
C===========================================================
      include "parm.h"
      parameter(ms1=20,ms2=60)  !ensemble sizes for different periods
c     parameter(imx=180,jmx=91,imo=36,jmo=19)
      DIMENSION mask(imo,jmo),wko(imo,jmo)
      DIMENSION wk1(imx,jmx),wk2(imx,jmx)
      DIMENSION wk3(imo,jmo),wk4(imo,jmo)
      DIMENSION ctgr(imo,jmo)
      DIMENSION abln(imo,jmo,12,2)
C
      OPEN(unit=11,form='unformatted',access='direct',recl=imx*jmx*4)
      OPEN(unit=12,form='unformatted',access='direct',recl=imo*jmo*4)
C
      OPEN(unit=21,form='unformatted',access='direct',recl=imo*jmo*4)
C
C= read in mask
      read(12,rec=1) wko
      call real_2_itg(wko,mask,imo,jmo)
      write(6,*) 'have read in mask'
C= read fld data
      it=0
      ir=0
      mm=ms1
      do iy=1,50  !1995-
      do im=1,12
      it=it+1
      if(it.gt.ltime) go to 100
c
      call setzero(wk3,imo,jmo)
c
      DO m=1,mm
      ir=ir+1
      write(6,*) 'it=',it,'  ir=',ir,'  uu=',uu
      read(11,rec=ir) wk1
C limit to US region
      call to_us(wk1,wko,imx,jmx,imo,jmo)
c
      do i=1,imo
      do j=1,jmo
c
      if(mask(i,j).eq.1) then
C
      wk3(i,j)=wk3(i,j)+wko(i,j)/float(mm)
C
      else
C
      wk3(i,j)=-999.0
C
      end if
C
      enddo
      enddo
c
      ENDDO   !m=1->mm loop
c
      write(21,rec=it) wk3
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
