      program day2mon
      include "parm.h"
C======================================
C have daily amom then monthly anom
C=======================================
      DIMENSION ps(12),daysst(idim,jdim,nday)
      DIMENSION clim(idim,jdim,12),climtrunc(idim,jdim)
      DIMENSION f2d(idim,jdim),f4d(idim,jdim,12,30)
c
      open(unit=10,form='unformatted',access='direct',recl=4*idim*jdim)
      open(unit=11,form='unformatted',access='direct',recl=4*idim*jdim)
      open(unit=30,form='unformatted',access='direct',recl=4*idim*jdim)
c
       undef=-999000000
c
c* read daily SST 
       ir=0
       do id=1,nday
         ir=ir+1
         read(10,rec=ir) f2d
         do i=1,idim
         do j=1,jdim
         daysst(i,j,id)=f2d(i,j)
         enddo
         enddo
       enddo
c* read SST for WMO normal period
       ir=33*12   !1948-1980
       do iy=1,30  !1981-2010
       do im=1,12
         ir=ir+1
         read(11,rec=ir) f2d
         do i=1,idim
         do j=1,jdim
         f4d(i,j,im,iy)=f2d(i,j)
         enddo
         enddo
       enddo
       enddo
c
c* calculate clim
       do im=1,12
         do i=1,idim
         do j=1,jdim
         if(abs(f4d(i,j,1,1)).lt.500) then
           xx=0.0
           do iy=1,30
           xx=xx+f4d(i,j,im,iy)
           enddo
           clim(i,j,im)=xx/30.
         else
           clim(i,j,im)=undef
         endif
         enddo
         enddo
       enddo
C
C* determine month to date climo (like days 1-23) for the final month
c
      do i=1,idim
      do j=1,jdim
        if(abs(f4d(i,j,1,1)).lt.500) then
        do m=1,12
        ps(m)=clim(i,j,m)
        enddo
        y=0.
        do id=1,nday
          day=float(id)
          call wave(ps,mfinal,day,x,0.5)
          y=y+x/float(nday)
        enddo
         climtrunc(i,j)=y
        else
         climtrunc(i,j)=undef
        endif
      enddo
      enddo
c
c* nday mean of daily sst
      do i=1,idim
      do j=1,jdim
        xx=0
        do id=1,nday
        xx=xx+daysst(i,j,id)
        enddo
        f2d(i,j)=xx/float(nday)
      enddo
      enddo
c
c* anon of final month
      do i=1,idim
      do j=1,jdim
        if(abs(f4d(i,j,1,1)).lt.500) then
        f2d(i,j)=f2d(i,j)-climtrunc(i,j)
        else
        f2d(i,j)=undef
        endif
      enddo
      enddo
      write(30,rec=1) f2d
c
      stop
      end

      function dayvalue(AM,BM,month,day,type)
C* HARMONIC ANALYSIS TAYLORED FOR 12 MONTHLY MEANS.
C* we here return a daily value valid at month, day
C* basic time unit is 1 for one month.
c* the average month has 30.5 days!
      DIMENSION AM(0:6),BM(0:6)
      OMEGA=2.*ATAN(1.)*4./12.
      x=0.
c* middle of month time:
      TIME=FLOAT(month)-type
c* end of month time:
      TIME=FLOAT(month)
c* fine tune the day for end of month situation:
      time=time+(day-30.5)/30.5
      DO 10 IWAVE=0,6
      ANGLE=TIME*OMEGA*FLOAT(IWAVE)
      x=x+AM(IWAVE)*SIN(ANGLE)+BM(IWAVE)*COS(ANGLE)
10    CONTINUE
      dayvalue=x
      RETURN
      END
c
      SUBROUTINE FOUR12(T,IWAVE,AM,BM,type)
C* HARMONIC ANALYSIS TAYLORED FOR 12 MONTHLY MEANS.
      DIMENSION T(12),AM(0:6),BM(0:6)
      OMEGA=2.*ATAN(1.)*4./12.
      AA=0.
      BB=0.
      ITOT=0
      DO 10 I=1,12
c* middle of month time:
      TIME=FLOAT(I)-type
c* end of month time:
c     TIME=FLOAT(I)
      ANGLE=TIME*OMEGA*FLOAT(IWAVE)
      XX=T(I)
      AA=AA+XX*SIN(ANGLE)
      BB=BB+XX*COS(ANGLE)
      ITOT=ITOT+1
10    CONTINUE
      TOT=FLOAT(ITOT)
      A=AA/TOT*2.
      IF (IWAVE.EQ.0)A=A/2.
      IF (IWAVE.EQ.6)A=A/2.
      B=BB/TOT*2.
      IF (IWAVE.EQ.0)B=B/2.
      IF (IWAVE.EQ.6)B=B/2.
      AM(IWAVE)=A
      BM(IWAVE)=B
      RETURN
      END
c
      subroutine wave(ps,month,day,x,type)
c*    parameter (type=0.5)!centered monthly means
c*    parameter (type=0.0)!end-of-month type of data
      DIMENSION ps(12),AM(0:6),BM(0:6)

      DO 10 IWAVE=0,6
      CALL FOUR12(PS,IWAVE,AM,BM,TYPE)
10    CONTINUE

      x=dayvalue(AM,BM,month,day,type)

      RETURN
      END
