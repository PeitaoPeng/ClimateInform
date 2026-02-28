      program CD102to2x2
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c     CD102 to 2x2 resolution in 36x19 area
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imax=36,jmax=19,nst=102)
      real fot(imax,jmax),fin(nst)
c     open(unit=20,form='formatted')
      open(unit=20,form='unformatted',access='direct',recl=4*nst)
      open(unit=21,form='unformatted',access='direct',recl=4*imax*jmax)
C
      do it=1,ltime
        read(20,rec=it) fin
c       read(20,888) fin
        call CD102_2_2x2(fin,fot)
        write(21,rec=it) fot
      enddo
  888 format(10f7.1)

      stop
      END

      SUBROUTINE CD102_2_2x2(z,zg)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c     CD102 to 2x2 resolution in 36x19 area
C     READS AN ARRAY OF 102 CLIMATE DIVISIONS AND PUTS IT ON TO THE
C     36x19 2x2 DEGREE GRID AS A STANDARDIZED ANOMALY FORECAST.
C     FILE NUMBER 10 = 1/2 DEGREE GRID TO 102 DIVISION MAPPING FILE
C                 11 = land-sea mask with land=1
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER (NDS=102,NDX=36,NDY=19,NDXH=161,NDyH=81,NDZH=9)
C
C    NDS = 102 = DIMENSION OF INPUT ARRAY
C    NDX,NDY = DIMENSION OF FINAL OUTPUT ARRAY
C    NDXH,NDYH = DIMENSION OF INTERMEDIATE HALF-DEGREE ARRAY
C    NDZH      = QUARTER DEGREE RESOLUTION WEIGHT TO HALF DEGREE SQUARE
c    mx,w = arrays from mapping files.   
c    z  standardized anomaly on 102 division
c
      DIMENSION zg(ndx,ndy),zgh(ndxh,ndyh),
     2  mx(ndxh,ndyh,ndzh),w(ndzh),
     3  z(nds),
     4  mask(ndx,ndy),wk(ndx,ndy)
c
      DATA w/.0625,.125,.0625,.125,.25,.125,.0625,.125,.0625/
c
c     open(unit=10,form='formatted')
c     open(unit=11,form='unformatted',access='direct',recl=4*ndx*ndy)

c
c read in quarter degree map of 102CD
      CALL OFSTG36(10)
      DO 100 jy=1,ndyh
      DO 100 jx=1,ndxh
      READ(10,91) kx,ky,(mx(jx,jy,jq),jq=1,ndzh)
  100 CONTINUE
   91 FORMAT(11I4)
c
c read in 2x2 land-sea mask
      read(11,rec=1) wk
      call real_2_itg(wk,mask,ndx,ndy)
c interpolation start
C       zero array, and go through a quarter degree map of the 
c       102 FD's and put into a 1/2 degree grid, averaging the 
c       forecast values.

	DO 120 ky=1,ndyh
	DO 120 kx=1,ndxh
  120	zgh(kx,ky)=0.

	DO 130 kyh=1,ndyh
	DO 130 kxh=1,ndxh
	DO 130 kzh=1,ndzh
	js=ABS(mx(kxh,kyh,kzh))
	zgh(kxh,kyh)=zgh(kxh,kyh)+w(kzh)*z(js)
 130    CONTINUE
c
C     next put the 1/2 degree grid onto the 2 degree grid, again 
C     averaging.
      jhn=4  !ratio of output to input grid resolution 2/.5 = 4
      jyh1=1 !jxh1,jxh2,jyh1,jyh2 = start and end of x and y half-degree grid
      jyh2=78
      jxh1=20
      jxh2=158
        rhn2=1./REAL(jhn*jhn)
        DO 140 ky=1,ndy
        DO 140 kx=1,ndx
  140   zg(kx,ky)=0.              

        DO 150 kyh=jyh1,jyh2,jhn
        ky=(kyh-jyh1)/jhn +1
        DO 150 kxh=jxh1,jxh2,jhn
        kx=(kxh-jxh1)/jhn +1
	kyhp=kyh+jhn-1 
	kxhp=kxh+jhn-1
	sum=0. 
        DO 145 kyh2=kyh,kyhp
        DO 145 kxh2=kxh,kxhp
        sum=sum+zgh(kxh2,kyh2)
 145    CONTINUE
        zg(kx,ky)=sum*rhn2
 150    CONTINUE
        do j=1,ndy
        do i=1,ndx
          if(mask(i,j).ne.1) zg(i,j)=-9999.
        enddo
        enddo
      close(10)
      return
      END

      SUBROUTINE OFSTG36(NU)
      OPEN(NU,file=
     2'/export/hobbes/wd52pp/utility/intpl/fd102161x81.dat')
      NUP=NU+1
      OPEN(NUP,file=
     2'/export/hobbes/wd52pp/utility/intpl/mask_2x2.data'
     3  ,access='direct',recl=36*19*4)
      RETURN
      END      
      
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
