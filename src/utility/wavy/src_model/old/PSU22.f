      SUBROUTINE PSU22 (AM,AP,BM,BP,FLN,QLNWCS,QDER,
     1                  IMAX,MEND1,NEND1,JEND1,MNWV2,KMAX,S)
      save
C***********************************************************************
C
C     PSU22 : CALCULATES THE SPECTRAL REPRESENTATIONS OF THE HORIZONTAL
C             VORTICITY  OF PSEUDO-VECTOR FIELDS FROM THE FOURIER
C             REPRESENTATIONS OF THE SYM[ETRIC AND ANTI-SYMMETRIC
C             PORTIONS OF THE TWO INDIVIDUAL FIELDS.
C
C***********************************************************************
C
C     PSU22 IS CALLED BY THE SUB GLOOP.
C
C     PSU22 CALLS NO SUBS.
C
C***********************************************************************
C
C    ARGUMENT(DIMENSIONS)                       DESCRIPTION
C
C         AM(IMAX,KMAX)           INPUT :  FOURIER REPRESENTATION OF
C                                          ANTI-SYMMETRIC PORTION OF
C                                          ZONAL PSEUDO-WIND FIELD AT
C                                          ONE GAUSSIAN LATITUDE.
C         AP(IMAX,KMAX)           INPUT :  FOURIER REPRESENTATION OF
C                                          SYMMETRIC PORTION OF ZONAL
C                                          PSEUDO-WIND FIELD AT ONE
C                                          GAUSSIAN LATITUDE.
C         BM(IMAX,KMAX)           INPUT :  FOURIER REPRESENTATION OF
C                                          ANTI-SYMMETRIC PORTION OF
C                                          MERIDIONAL PSEUDO-WIND FIELD
C                                          AT ONE GAUSSIAN LATITUDE.
C         BP(IMAX,KMAX)           INPUT :  FOURIER REPRESENTATION OF
C                                          SYMMETRIC PORTION OF
C                                          MERIDIONAL PSEUDO-WIND FIELD
C                                          AT ONE GAUSSIAN LATITUDE.
C        FLN(MNWV2,KMAX)          INPUT :  SPECTRAL REPRESENTATION OF
C                                          THE VORTICITY  OF THE GLOBAL
C                                          WIND FIELD. INCLUDES
C                                          CONTRIBUTIONS FROM GAUSSIAN
C                                          LATITUDES UP TO BUT NOT
C                                          INCLUDING CURRENT ITERATION
C                                          OF GAUSSIAN LOOP IN CALLING
C                                          ROUTINE.
C                                OUTPUT :  SPECTRAL REPRESENTATION OF
C                                          THE VORTICITY  OF THE GLOBAL
C                                          WIND FIELD. INCLUDES
C                                          CONTRIBUTIONS FROM GAUSSIAN
C                                          LATITUDES UP TO AND
C                                          INCLUDING CURRENT ITERATION
C                                          OF GAUSSIAN LOOP IN CALLING
C                                          ROUTINE.
C       QLNWCS(MNWV2)             INPUT :  VALUES OF THE ASSOCIATED
C                                          LEGENDRE FUNCTIONS AT ONE
C                                          GAUSSIAN LATITUDE, MULTIPLIED
C                                          BY ZONAL WAVE NUMBER AND
C                                          DIVIDED BY SIN(LATITUDE)**2.
C                                          COMPUTED IN ROUTINE "GOZRIM".
C       QDER  (MNWV2)             INPUT :  VALUES OF THE LATITUDINAL
C                                          DERIVATIVE OF THE ASSOCIATED
C                                          LEGENDRE FUNCTIONS AT ONE
C                                          GAUSSIAN LATITUDE, MULTIPLIED
C                                          BY COS(LATITUDE). COMPUTED IN
C                                          ROUTINE "GOZRIM".
C       S     (MNWV2,2)                    WORK AREA
C
C             IMAX                INPUT :  NUMBER OF GRIDS ON ONE GAUSS-
C                                          IAN LATITUDE
C             MEND1
C             NEND1               INPUT :  TRUNCATION WAVE NUMBER
C             JEND1
C             MNWV2               INPUT :  (NUMBER OF OF WAVE
C                                          COEFFICIENTS) *2, (REAL,IMAG)
C             KMAX                INPUT :  NUMBER OF VERTICAL LEVELS.
C***********************************************************************
C... CREATED AT NMC JUNE 15 1984.......
C... REVISED BY N.SATO AT UMCP JAN 31 1986
C
C
      DIMENSION AM(IMAX,KMAX),AP(IMAX,KMAX),
     1          BM(IMAX,KMAX),BP(IMAX,KMAX),
     2          QLNWCS(MNWV2),QDER(MNWV2),FLN(MNWV2,KMAX),
     3          S(MNWV2,2),MNROW(10)
      DATA IFP/1/
C
      IF(IFP.EQ.1) THEN
      MEND2=2*MEND1
C...IFAC IS THE LARGEST FACTOR THAT SATISFIES  2**IFAC.LE.NEND1
      IFAC=0
1     CONTINUE
      IFAC=IFAC+1
      IF(2**IFAC.LE.NEND1) GO TO 1
      IFAC=IFAC-1
C
      NFAC=2**IFAC
      NRES=NEND1-NFAC
      MNSTR=MEND2*NFAC
      MNRES=MEND2*NRES
CVD$L NOVECTOR
      DO 2 ITR=1,IFAC
      MNROW(ITR)=MEND2*2**ITR
   2  CONTINUE
C
      IFP=0
      END IF
C
      IF(JEND1.EQ.MEND1+NEND1-1) THEN
C================================C
C...PARALLELOGRAMIC TRUNCATION...C
C================================C
C
CVD$R NODEPCHK
CVD$R NOLSTVAL
      DO 100 K=1,KMAX
C
      DO 120 MM=1,MEND2
      S(MM      ,1)= AM(MM,K)
      S(MM+MEND2,1)= AP(MM,K)
  120 CONTINUE
C
      IF(IFAC.GE.2) THEN
      DO 140 ITR=1,IFAC-1
      MNEND=MNROW(ITR)
      DO 140 MN=1,MNEND
      S(MN+MNEND,1)=S(MN,1)
  140 CONTINUE
      END IF
C
      MNEND=MNROW(IFAC)
      DO 160 MN=1,MNEND
      S(MN      ,2)=S(MN,1)*QDER(MN      )
  160 CONTINUE
C
      IF(MNRES.GT.0) THEN
      DO 180 MN=1,MNRES
      S(MN+MNSTR,2)=S(MN,1)*QDER(MN+MNSTR)
  180 CONTINUE
      END IF
C
      DO 200 MN=1,MNWV2
      FLN(MN,K)=FLN(MN,K)+S(MN,2)
  200 CONTINUE
C
      DO 220 MM=1,MEND2,2
      S(MM        ,1)=-BP(MM+1,K)
      S(MM+1      ,1)= BP(MM  ,K)
      S(MM  +MEND2,1)=-BM(MM+1,K)
      S(MM+1+MEND2,1)= BM(MM  ,K)
  220 CONTINUE
C
      IF(IFAC.GE.2) THEN
      DO 240 ITR=1,IFAC-1
      MNEND=MNROW(ITR)
      DO 240 MN=1,MNEND
      S(MN+MNEND,1)=S(MN,1)
  240 CONTINUE
      END IF
C
      MNEND=MNROW(IFAC)
      DO 260 MN=1,MNEND
      S(MN      ,2)=S(MN,1)*QLNWCS(MN      )
  260 CONTINUE
      IF(MNRES.GT.0) THEN
      DO 280 MN=1,MNRES
      S(MN+MNSTR,2)=S(MN,1)*QLNWCS(MN+MNSTR)
  280 CONTINUE
      END IF
C
      DO 290 MN=1,MNWV2
      FLN(MN,K)=FLN(MN,K)+S(MN,2)
  290 CONTINUE
C
  100 CONTINUE
C
      ELSE
C============================
C...PENTAGONAL TRUNCATION...=
C============================
      DO 300 K=1,KMAX
      L=0
      DO 320 NN=1,NEND1
        IF(NN.LE.JEND1+1-MEND1) THEN
        MMAX=MEND2
        ELSE
        MMAX=2*(JEND1+1-NN)
        END IF
      IF(MOD(NN-1,2).EQ.0) THEN
      DO 340 MM=1,MMAX
      L=L+1
      S(L,2)=AM(MM,K)
  340 CONTINUE
      ELSE
      DO 360 MM=1,MMAX
      L=L+1
      S(L,2)=AP(MM,K)
  360 CONTINUE
      END IF
  320 CONTINUE
C
      DO 380 MN=1,MNWV2
      FLN(MN,K)=FLN(MN,K)+S(MN,2)*QDER(MN)
  380 CONTINUE
C
      L=0
      DO 400 NN=1,NEND1
        IF(NN.LE.JEND1+1-MEND1) THEN
        MMAX=MEND2
        ELSE
        MMAX=2*(JEND1+1-NN)
        END IF
      IF(MOD(NN-1,2).EQ.0) THEN
      DO 420 MM=1,MMAX,2
      L=L+1
      S(2*L-1,2)=-BP(MM+1,K)
      S(2*L  ,2)=+BP(MM  ,K)
  420 CONTINUE
      ELSE
      DO 440 MM=1,MMAX,2
      L=L+1
      S(2*L-1,2)=-BM(MM+1,K)
      S(2*L  ,2)=+BM(MM  ,K)
  440 CONTINUE
      END IF
  400 CONTINUE
C
      DO 460 MN=1,MNWV2
      FLN(MN,K)=FLN(MN,K)+S(MN,2)*QLNWCS(MN)
  460 CONTINUE
C
  300 CONTINUE
C
      END IF
C
      RETURN
      END
