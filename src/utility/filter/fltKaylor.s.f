      SUBROUTINE FLTM(U0,U2,pr1,pr2,ipass)
#include "parm.s.h"
C
C U0:    input time series
C U2:    output time series
C IPASS: filter type to use
C          0 band pass
C          1 low  pass
C          2 high pass
C pr1: cutoff period for low  pass or high pass
C      OR lower bound of period for band pass filtering
C pr2: meaningless for low  pass or high pass
C      OR higher bound of period for band pass filtering
C
      PARAMETER (NT=ltime)

      PARAMETER (IM=1,JM=1,NSRS=IM)

      DIMENSION U0(NT),U2(NT)

      DIMENSION MM(IM),NFLTR(IM),FCO(IM),FBO(IM),NDEC(IM)
      DATA SR /1./

      do i=1,NT
       U2(i)=U0(i)
      enddo
      
C
C BAND PASS FILTER
C
      if(ipass.eq.0) then
       FCUT1=1./pr1
       FCUT2=1./pr2
       DO I=1,NSRS
        MM(I)=NT
        NDEC(I)=0
C NFLTR(I)=--- (put the value of NFLTR in the call statement)
       enddo
       FCUTC=(FCUT1+FCUT2)*0.5
       DFCUT=ABS(FCUT1-FCUTC)
       DO I=1,NSRS
        FCO(I)=FCUTC
        FBO(I)=DFCUT
       enddo
       CALL FLTR(U2,MM,NT,NSRS,-33,FCO,FBO,NDEC,SR)
      endif

C
C LOW PASS FILTER
C
      if(ipass.eq.1) then
       DO I=1,NSRS
        MM(I)=NT
        FBO(I)=0.
        NDEC(I)=0
C NFLTR(I)=--- (put the value of NFLTR in the call statement)
       enddo
       DO I=1,NSRS
        FCO(I)=1./pr1
       enddo
       CALL FLTR(U2,MM,NT,NSRS,-31,FCO,FBO,NDEC,SR)
      endif

C
C HIGH PASS FILTER
C
      if(ipass.eq.2) then
       DO I=1,NSRS
        MM(I)=NT
        FBO(I)=0.
        NDEC(I)=0
C NFLTR(I)=--- (put the value of NFLTR in the call statement)
       enddo
       DO I=1,NSRS
        FCO(I)=1./pr1
       enddo
       CALL FLTR(U2,MM,NT,NSRS,-32,FCO,FBO,NDEC,SR)
      endif

      RETURN
      END
 
      SUBROUTINE FLTR(T,N,NMAX,NSRS,NFLTR,FCO,FBO,NDEC,SR)
C
C****************************************************************************
C                  
C                      SPECTRAL ESTIMATES PACKAGE - SPEC
C                      FILTERING AND DECIMATION SUBROUTINE
C
C        USAGE:  
C
C	 CALL FLTR(T,N,NMAX,NSRS,NFLTR,FCO,FBO,NDEC,SR)
C
C        THE  ARGUMENTS ARE:
C
C      T: THE ARRAY OF DATA POINTS, DIMENSIONED 'NMAX' BY 'NSRS, EACH DATA
C         SET 'I' CONTAINS 'N(I)' DATA POINTS.  ON OUTPUT, EACH SET WITH NON-
C         ZERO 'NFLTR(I)' IS MODIFIED BY THE FILTER, EACH SET WITH NON-ZERO 
C         'NDEC(I)' HAS BEEN DECIMATED.
C              INPUT AND OUTPUT:  FLOATING POINT      DIM(NMAX,NSRS)
C
C      N: A LINEAR ARRAY OF LENGTH 'NSRS' CONTAINING FOR EACH 'N(I)' THE
C        ACTUAL NUMBER OF ENTRIES IN DATA SET 'I'.
C             INPUT: INTEGER                           DIM(NSRS)
C  
C  NMAX: THE MAXIMUM NUMBER OF DATA POINTS IN ANY DATA SET, THE FIRST
C        DIMENSION OF ARRAY 'T'.
C             INPUT: INTEGER
C
C  NSRS: THE NUMBER OF DATA SETS, THE SECOND DIMENSION OF ARRAY 'T', AND
C        THE DIMENSION OF ARRAYS 'N', 'NFLTR', 'FCO', 'FBO', AND 'NDEC'.
C             INPUT: INTEGER
C
C NFLTR: A ONE DIMENSIONAL ARRAY OF LENGTH 'NSRS'.  IF NFLTR(I) IS A
C        COMBINATION OF INTEGERS 'J' AND 'L',   'J' BETWEEN 1 AND 20, 'L'
C        BETWEEN 1 AND 4, THE I(TH) SERIES WILL BE FILTERED AS FOLLOWS:
C
C        L=1  A 2*J-POLE RECURSIVE LOW-PASS FILTER WITH CUT-OFF FREQUENCY
C             GIVEN BY FCO(I).
C        L=2  A 2*J-POLE RECURSIVE HIGH-PASS FILTER WITH CUT-OFF FREQUENCY
C             GIVEN BY FCO(I).
C        L=3  A 2*J-POLE RECURSIVE BAND-PASS FILTER WITH HALF-BANDWIDTH
C             GIVEN BY FBO(I), CENTERED AT FREQUENCY GIVEN BY FCO(I).
C        L=4  A 2*J-POLE RECURSIVE BAND-STOP FILTER WITH HALF-BANDWIDTH 
C             GIVEN BY FBO(I), CENTERED AT FREQUENCY GIVEN BY FCO(I).
C
C
C             IF 'JL' IS A POSITIVE INTEGER, THE SERIES WILL BE FILTERED
C             WITH A NON-SYMETRIC FILTER, GIVING A PHASE SHIFT.  IF 'JL'
C             IS NEGATIVE, THE SERIES WILL BE DOUBLE FILTERED, RESULTING
C             IN A SYMETRIC FILTER AND NO PHASE SHIFT.
C 
C
C    EXAMPLE: NFLTR(I)=32  IMPLIES THE I(TH) SERIES WILL BE FILTERED WITH
C             A HIGH-PASS FILTER WITH 6-POLE.
C                INPUT: INTEGER                          DIM(NSRS)
C
C
C   FCO: A ONE DIMENSIONAL ARRAY OF LENGTH 'NSRS'.  FCO(I) IS THE CENTER
C        OR CUT-OFF FREQUENCY FOR FILTER EXPLAINED ABOVE.
C          (FREQUENCY MEASURED IN CYCLES PER TIME UNIT.)
C                INPUT: FLOATING POINT                   DIM(NSRS)
C   
C   FBO: A ONE DIMENSIONAL ARRAY OF LENGTH 'NSRS'.  FBO(I) IS THE HALF-
C        BANDWIDTH FOR BAND-PASS FILTER EXPLAINED ABOVE.
C          (MEASURED IN CYCLES PER TIME UNIT.)
C                 INPUT: FLOATING POINT                   DIM(NSRS)
C
C
C         ************************* NOTE ************************
C 
C          IF A SERIES IS FILTERED, THE MEAN OF THAT SERIES IS REMOVED 
C          BEFORE (BUT NOT AFTER) FILTERING.
C
C
C  NDEC: A ONE DIMENSIONAL ARRAY OF LENGTH 'NSRS'.  IF NDEC(I) IS A
C        POSITIVE INTEGER 'L' GREATER THAN ONE, THE I(TH) DATA SERIES WILL
C        BE DECIMATED WITH AN 1:L ORDER DECIMATION AFTER FILTERING.  
C        NOTE THAT DECIMATION ONLY MAKES SENSE FOR LOW-PASS FILTERS WITH
C        A CUT-OFF BELOW THE NEW NYQUIST FREQUENCY, GIVEN BY:
C                  FN(NEW) = FN(OLD)/L
C
C        NOTE ALSO THAT SERIES TO BE CROSS ANALYZED
C        MUST HAVE THE SAME NUMBER OF POINTS AND TIME INCREMENTS
C                 INPUT: INTEGER                            DIM(NSRS)
C
C
C    SR: THE NOMINAL SPACING BETWEEN DATA POINTS, COMMON TO ALL SERIES.
C        (DELTA T OR DELTA X).
C                 INPUT: FLOATING POINT
C
C*****************************************************************************
C
C
      REAL T(NMAX,NSRS)
      COMMON /BLK2/H1,H2,H3,H4,H5,G1,G2,DUM
      INTEGER N(1),NFLTR(1),NDEC(1)	
      REAL FCO(1),FBO(1)
      DIMENSION H1(20),H2(20),H3(20),H4(20),H5(20),G1(20),G2(20)
      DIMENSION DUM(200)
      DATA PI/3.141592653589793/

      NPAG=0
  200 CONTINUE
      SQ2=SQRT(2.)-1.
      DO 400 I=1,NSRS
        IF(NFLTR(I) .EQ. 0) GO TO 400
        NN2=N(I)
        IF(NN2 .EQ. 0) GO TO 400
        NPAG=1
        NAK=0
        IF(NFLTR(I) .LT. 0) NAK=1
        NFLTR(I)=ABS(NFLTR(I))
        AK=FLOAT(NFLTR(I))*0.1
        K=AK
        J=NFLTR(I)-(K*10)
        AL=1./FLOAT(4*K)
        FFO=FCO(I)*PI*SR
        FFD=ATAN((TAN(FFO))/(SQ2**AL))
C
C
C**** CALCULATE AND REMOVE MEAN OF SERIES BEFORE FILTERING.
C
        TMEAN=0.0
        DO 2 JK=1,NN2
          TMEAN=TMEAN+T(JK,I)
    2   CONTINUE
        TMEAN=TMEAN/FLOAT(NN2)
        DO 5 JK=1,NN2
          T(JK,I)=T(JK,I)-TMEAN
    5   CONTINUE
C
C**** EXTEND ENDS OF SERIES BY DUPLICATING END POINTS 
C
C
        IJ=NN2/10
        IF(IJ .GT. 100) IJ=100
        IF(IJ .LT. 50)  IJ=50
        DO 15 JK=1,IJ
          JL=JK+100
          DUM(JK)=T(1,I)
          DUM(JL)=T(NN2,I)
   15   CONTINUE
        FFDD=FFD-FFO
        IF(J .GT. 2) GO TO 75
C
C**** LOW-PASS AND HIGH-PASS FILTERS.
C
        IF(J .EQ. 2) FFO=(PI/2.)-FFO
C
C
C**** ADJUST CUT-OFF FOR SYMMETRIC FILTERING.
C
C
        IF(NAK .EQ. 1) FFO=FFO+FFDD
        CO=1./TAN(FFO)
        CO2=CO*CO
        HH1=2.*(1.-CO2)
C
C
C**** DETERMINE ROOTS OF Z-TRANSFORM.
C
C
        DO 21 JK=1,K
          AK=(FLOAT(JK-1)*2.0+1.)*AL
          ROOT=2.*SIN(PI*AK)
          ROOT=ROOT*CO
          G1(JK)=1./(1.+ROOT+CO2)
          H2(JK)=1.-ROOT+CO2
   21   CONTINUE
C
C
C**** APPLY FILTERS TO DATA SERIES.
C
C
        DO 35 JL=1,K
          ISET=1
          NN3=1
          NN4=NN2
          NN5=1
          NN6=1
          NN7=2
          NN8=3
          NN9=IJ
   22     CONTINUE
C
C
C**** FILTER EXTENDED END OF SERIES.
C
C
          A=DUM(NN6)
          B=DUM(NN7)
          BB=B
          CC=A
          C=G1(JL)
          D=HH1
          E=H2(JL)
          DO 25 JK=NN8,NN9
            AA=DUM(JK)
            IF(J .EQ. 1) DUM(JK)=C*(AA+2.*B+A-D*BB-E*CC)
            IF(J .EQ. 2) DUM(JK)=C*(AA-2.*B+A+D*BB-E*CC)
            A=B
            B=AA
            CC=BB
            BB=DUM(JK)
   25     CONTINUE
C
C
C**** FILTER SERIES.
C
C
          DO 30 JK=NN3,NN4,NN5
            AA=T(JK,I)
            IF(J .EQ. 1) T(JK,I)=C*(AA+2.*B+A-D*BB-E*CC)
            IF(J .EQ. 2) T(JK,I)=C*(AA-2.*B+A+D*BB-E*CC)
            A=B
            B=AA
            CC=BB
            BB=T(JK,I)
   30     CONTINUE
          IF(NAK .EQ. 0) GO TO 35
          IF(ISET .EQ. 2) GO TO 35
C
C
C**** REVERSE DIRECTION OF FILTERING FOR SYMMETRIC FILTERS.
C
C
          ISET=2
          NN3=NN2
          NN4=1
          NN5=-1
          NN6=101
          NN7=102
          NN8=103
          NN9=IJ+100
          GO TO 22
   35     CONTINUE
          GO TO 400	
C        
   75     CONTINUE
C
C
C****BAND-PASS AND NOTCH FILTERS. 
C
	FFO=FCO(I)
	FFB=FBO(I)
	IF(NAK.EQ.0) GO TO 76
C
C***ADJUST WIDTH FOR SYMMETRIC FILTERS
C
	FFDD=FFDD/(PI*SR*2.0)
	IF(J.EQ.3)FFB=FFB+FFDD
	IF(J.EQ.4)FFB=FFB-FFDD
   76   CONTINUE	
	FU=FFO+FFB
	FL=FFO-FFB
	ALP=COS(PI*SR*(FU+FL))/COS(PI*SR*(FU-FL))
	ALP2=ALP*ALP
	IF(J.EQ.4) GO TO 80
C
C***ROOTS FOR BAND-PASS FILTERS
C
	WA=TAN(PI*SR*(FU-FL))
	WA2=WA*WA
	DO 77 JK=1,K
	AK=(FLOAT(JK-1)*2.0+1.0)*AL
	ROOT=2.0*SIN(PI*AK)
	AN=WA2+ROOT*WA+1.0
	G1(JK)=WA2/AN
	H1(JK)=(-2.0*ROOT*WA*ALP-4.0*ALP)/AN
	H2(JK)=(-2.0*WA2+4.0*ALP2+2.0)/AN
	H3(JK)=(2.0*ROOT*WA*ALP-4.0*ALP)/AN
	H4(JK)=(WA2-ROOT*WA+1.0)/AN
   77   CONTINUE
	GO TO 90
   80   CONTINUE
C
C***ROOTS FOR NOTCH FILTERS
C
	WA=1.0/TAN(PI*SR*(FU-FL))
	WA2=WA*WA
	DO 85 JK=1,K
	AK=(FLOAT(JK-1)*2.0+1.0)*AL
	ROOT=2.0*SIN(PI*AK)
	AN=WA2+ROOT*WA+1.0
	G1(JK)=WA2/AN
	H1(JK)=(4.0*ALP*WA2+2.0*ROOT*WA*ALP)/AN
	H2(JK)=(4.0*ALP2*WA2+2.0*WA2-2.0)/AN
	H3(JK)=(-4.0*ALP*WA2+2.0*ROOT*WA*ALP)/AN
	H4(JK)=(WA2-ROOT*WA+1.0)/AN
	G2(JK)=4.0*ALP*WA2/AN
	H5(JK)=WA2*(4.0*ALP2+2.0)/AN
   85   CONTINUE
   90   CONTINUE
C
C***APPLY FILTERS TO DATA SERIES
C
	DO 115 JL=1,K
	ISET=1
	NN3=1
	NN4=NN2
	NN5=1
	NN6=1
	NN7=2
	NN8=3
	NN9=4
	NN10=5
	NN11=IJ
   92   CONTINUE
C
C***FILTER EXTENDED END OF SERIES
	AM=G1(JL)
	SS=G2(JL)
	O=H1(JL)
	P=H2(JL)
	Q=H3(JL)
	R=H4(JL)
	TS=H5(JL)
	A=DUM(NN6)
	B=DUM(NN7)
	C=DUM(NN8)
	D=DUM(NN9)
	BB=A
	CC=B
	DD=C
	EE=D
	DO 95 JK=NN10,NN11
	AA=DUM(JK)
	IF(J.EQ.3)DUM(JK)=AM*(AA-2.0*B+D)-O*BB-P*CC-Q*DD-R*EE
	IF(J.EQ.4)DUM(JK)=AM*(AA+D)-SS*(A+C)+TS*B+O*BB-P*CC-Q*DD-R*EE 
	D=C
	C=B
	B=A
	A=AA
	EE=DD
	DD=CC
	CC=BB
	BB=DUM(JK)
   95   CONTINUE
C
C***FILTER SERIES
C
	DO 100 JK=NN3,NN4,NN5
	AA=T(JK,I)
	IF(J.EQ.3)T(JK,I)=AM*(AA-2.0*B+D)-O*BB-P*CC-Q*DD-R*EE
	IF(J.EQ.4)T(JK,I)=AM*(AA+D)-SS*(A+C)+TS*B+O*BB-P*CC-Q*DD-R*EE
	D=C
	C=B
	B=A
	A=AA
	EE=DD
	DD=CC
	CC=BB
	BB=T(JK,I)
  100   CONTINUE
	IF(NAK.EQ.0)GO TO 115
	IF(ISET.EQ.2)GO TO 115
	ISET=2
C
C***RESERVE DIRECTION OF FILTERING FOR SYMMETRIC FILTERS
C
	NN3=NN2
	NN4=1
	NN5=-1
	NN6=101	
	NN7=102	
	NN8=103	
	NN9=104	
	NN10=105	
	NN11=IJ+100
	GO TO 92
 115    CONTINUE	
        
C	DO 45 JK=1,NN2
C          T(JK,I)=T(JK,I)+TMEAN
C   45   CONTINUE
  400 CONTINUE
C
C
C**** DECIMATION OF SERIES.
C
C
        DO 460 I=1,NSRS
          NN3=NDEC(I)
          IF(NN3 .LE. 1) GO TO 460
          NN2=N(I)
          IF(NN2 .EQ. 0) GO TO 460
          NN4=NN2/NN3
          IF(NN4*NN3 .NE. NN2) NN4=NN4+1
          DO 450 J=2,NN4
            NN5=(J-1)*NN3+1
            IF(NN5 .GT. NN2) GO TO 450
            T(J,I)=T(NN5,I)
            NN6=J
  450     CONTINUE
          N(I)=NN6
  460   CONTINUE
C
C
      RETURN
      END
C
