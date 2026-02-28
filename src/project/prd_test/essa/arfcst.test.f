C *****************************************************************************

C       This program computes the AR model fcst test


      PARAMETER (NPTS=9000,NORD=30)
      PARAMETER (NDT=2000)
      PARAMETER (NPRD=1)  !step number of forecast
      PARAMETER (NFT=50)  !the length of forecast

      DIMENSION TS(NPTS),TIN(NPTS), PRD(NPRD)

      DIMENSION RN(NPTS),  A(0:NORD)

      open(unit=10,form='unformatted',access='direct',recl=4)

      PI = 4.0*ATAN(1.0)
      TPI = 2.0*PI

C----have white noise time series 
      ir=3
      do i=1,NPTS
         RN(i)=ran1(ir)-0.5
      end do
c
      SIG=1. !variance of white noise time series
      IP=2     !AR order
c----input AR coefficients
      A(0)=1
      A(1)=0.5
      A(2)=0.3
        DO IR=IP+1,3*NDT
          SUM = 0.0
          DO I=1,IP
            SUM = SUM + A(I)*TS(IR-I)
          END DO
          TS(IR) = RN(IR)*SQRT(SIG) - SUM
C         TS(IR) = RN(IR)*SQRT(SIG) - 2*SIN(PI*IR*1000/PI)
        END DO
      write(6,*)'finished random generation'
C fcst test
      iw=0
      DO IF=1,NFT
        DO I=1,NDT+IF-1
          TIN(I) = TS(I+NDT)
        END DO
        NIN=NDT+IF-1
      CAll ARPRD(TIN,NIN,PRD,NPRD)
      write(6,*)'OBS=',TS(NIN+NDT+1),'PRD=',PRD
      iw=iw+1
      write(10,rec=iw) TS(NIN+NDT+1)
      iw=iw+1
      write(10,rec=iw) PRD
      ENDDO

      STOP
      END

      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
  11    continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END

