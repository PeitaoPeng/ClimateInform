
c* read SST of WMO normal period and calculate clim
        do month=1,12!choice
        sst3=0.
        do iyr=1981,2010
        call readsst(sst,idim,jdim,iyr,month)
        sst3=sst3+sst/30.
        enddo
        clim(:,:,month)=sst3(:,:)
        enddo
C* this makes the 12 monthly
c
C* determine month to date climo (like days 1-23) for the final month
c
        do i=1,idim
        do j=1,jdim
          do m=1,12
          ps(m)=clim(i,j,m)
          enddo
         y=0.
         do id=1,iday
         day=float(id)
         call wave(ps,mfinal,day,x,0.5)
         y=y+x/float(iday)
        if (i.eq.73.and.j.eq.17)write(6,123)i,j,id,ps,x
         enddo
         climtrunc(i,j)=y
        if (i.eq.1.and.j.eq.17)write(6,123)i,j,iday,ps,y
        if (i.eq.73.and.j.eq.17)write(6,123)i,j,iday,ps,y
        enddo
        enddo
123     format(1h ,'check',3i5,12f7.2,f8.2)

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
      eND
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
