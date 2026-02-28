      SUBROUTINE GOZRIM(PLN,DER,EPS,LAT,PLNWCS,RCS2,WGTL,MEND1,
     1                  NEND1,NEND2,JEND1,MNWV0,MNWV1,JMAXHF,X,LA1)
      save
C***********************************************************************
C
C     GOZRIM : CALCULATES ZONAL AND MERIDIONAL PSEUDO-DERIVATIVES AS
C              WELL AS LAPLACIANS OF THE ASSOCIATED LEGENDRE FUNCTIONS.
C
C***********************************************************************
C
C     GOZRIM IS CALLED BY THE SUB GLOOP.
C
C     GOZRIM CALLS NO SUBS.
C
C***********************************************************************
C
C    ARGUMENT(DIMENSIONS)                       DESCRIPTION
C
C      PLN   (MNWV1)              INPUT : ASSOCIATED LEGENDRE FUNCTION
C                                         VALUES AT GAUSSIAN LATITUDE
C                                         WHOSE INDEX IS GIVEN BY "LAT".
C                                         COMPUTED IN ROUTINE "PLN2".
C                                OUTPUT : PLN(L,N)=
C                                         PLN(L,N)*(L+N-2)*(L+N-1)/A**2.
C                                         ("A" DENOTES EARTH'S RADIUS)
C                                         USED IN CALCULATING THE
C                                         LAPLACIAN OF GLOBAL FIELDS
C                                         IN SPECTRAL FORM.
C      DER   (MNWV0)             OUTPUT : COSINE-WEIGHTED DERIVATIVES OF
C                                         ASSOCIATED LEGENDRE FUNCTIONS
C                                         AT GAUSSIAN LATITUDE WHOSE
C                                         INDEX IS GIVEN BY "LAT".
C      EPS   (MNWV1)              INPUT : ARRAY OF CONSTANTS USED TO
C                                         CALCULATE "DER" FROM "PLN".
C                                         COMPUTED IN ROUTINE "EPSLON".
C      LAT                        INPUT : GAUSSIAN LATITUDE INDEX. SET
C                                         IN ROUTINE "GLOOP".
C      PLNWCS(MNWV0)             OUTPUT : PLNWCS(L,N)=
C                                         PLN(L,N)*(L-1)/
C                                         SIN(LATITUDE)**2.
C      RCS2  (JMAXHF)             INPUT : 1.0/SIN(LATITUDE)**2 AT
C                                         GAUSSIAN LATITUDES.
C                                         COMPUTED IN ROUTINE "GLATS".
C      WGTL                       INPUT : GAUSSIAN WEIGHT, AT GAUSSIAN
C                                         LATITUDE WHOSE INDEX IS GIVEN
C                                         BY "LAT". COMPUTED IN ROUTINE
C                                         "GLATS".
C
C      X     (MNWV1)                      WORK AREA
C
C      MEND1
C      NEND1                      INPUT : TRUNCATION WAVE NUMBER
C      JEND1
C      NEND2                      INPUT : NEND1+1
C      LA1(MEND1,NEND2)           INPUT : NUMBERING ARRAY FOR PLN
C***********************************************************************
C
C... CREATED AT NMC JUNE 15 1984.......
      DIMENSION PLN   (MNWV1),DER(MNWV0),
     1          PLNWCS(MNWV0),EPS(MNWV1),RCS2(JMAXHF),
     2 X     (MNWV1),AN(200)
      DIMENSION LA1(MEND1,NEND2)
      DATA IFP/1/
C
C...  COMPUTE PLN DERIVATIVES
C
      IF(IFP.EQ.1) THEN
      ERIV  =1.0/REAL(6370000)
      ERSQIV=ERIV*ERIV
      MEND2 =MEND1*2
      DO 80 N=1,JEND1+1
      AN(N)=N-1
   80 CONTINUE
      IFP=0
      END IF
C
      RAA =WGTL*ERSQIV
      WCSA=RCS2(LAT)*WGTL*ERIV
      L=0
      DO 100 NN=1,NEND2
      IF(NN.LE.JEND1-MEND1+2) THEN
      MMAX=MEND1
      ELSE
      MMAX=JEND1-NN+2
      END IF
      DO 100 MM=1,MMAX
      L=L+1
      X(L)=AN(MM+NN-1)
  100 CONTINUE
C
CVD$R NODEPCHK
      IF(JEND1.EQ.MEND1+NEND1-1) THEN
C
      DO 200 MN=1,MEND1*(NEND1-1)
      DER(MN+MEND1)=X(MN+MEND2)*EPS(MN+MEND1)*PLN(MN)
     1             -X(MN+MEND1)*EPS(MN+MEND2)*PLN(MN+MEND2)
  200 CONTINUE
      DO 220 MM=1,MEND1
      DER(MM)=-X(MM)*EPS(MM+MEND1)*PLN(MM+MEND1)
  220 CONTINUE
      DO 240 MN=1,MNWV0
      DER(MN)=WCSA*DER(MN)
  240 CONTINUE
C...
      DO 260 NN=1,NEND1
      DO 260 MM=1,MEND1
      PLNWCS(MM+(NN-1)*MEND1)=AN(MM)*PLN(MM+(NN-1)*MEND1)
  260 CONTINUE
      DO 270 MN=1,MNWV0
      PLNWCS(MN)=WCSA*PLNWCS(MN)
  270 CONTINUE
C...
      DO 280 MN=1,MNWV0
      PLN(MN)=X(MN)*X(MN+MEND1)*RAA*PLN(MN)
  280 CONTINUE
C...
      ELSE
C...
      L=MEND1
      DO 300 NN=2,NEND1
      IF(NN.LE.JEND1-MEND1+1) THEN
      MMAX=MEND1
      ELSE
      MMAX=JEND1-NN+1
      END IF
      DO 300 MM=1,MMAX
      L=L+1
      LM=LA1(MM,NN-1)
      L0=LA1(MM,NN  )
      LP=LA1(MM,NN+1)
      DER(L)=X(LP)*EPS(L0)*PLN(LM)-X(L0)*EPS(LP)*PLN(LP)
  300 CONTINUE
      DO 320 MM=1,MEND1
      DER(MM)=-X(MM)*EPS(MM+MEND1)*PLN(MM+MEND1)
  320 CONTINUE
      DO 340 MN=1,MNWV0
      DER(MN)=WCSA*DER(MN)
  340 CONTINUE
C...
      L=0
      DO 360 NN=1,NEND1
      IF(NN.LE.JEND1-MEND1+1) THEN
      MMAX=MEND1
      ELSE
      MMAX=JEND1-NN+1
      END IF
      DO 360 MM=1,MMAX
      L=L+1
      L0=LA1(MM,NN)
      PLNWCS(L)=AN(MM)*PLN(L0)
  360 CONTINUE
      DO 380 MN=1,MNWV0
      PLNWCS(MN)=WCSA*PLNWCS(MN)
  380 CONTINUE
C...
      DO 400 NN=1,NEND1
      IF(NN.LE.JEND1-MEND1+1) THEN
      MMAX=MEND1
      ELSE
      MMAX=JEND1-NN+1
      END IF
      DO 400 MM=1,MMAX
      L0=LA1(MM,NN)
      LP=LA1(MM,NN+1)
      PLN(L0)=X(L0)*X(LP)*RAA*PLN(L0)
  400 CONTINUE
C
      END IF
C
      RETURN
      END
