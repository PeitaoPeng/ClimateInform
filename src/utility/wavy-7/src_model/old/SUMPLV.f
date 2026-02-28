      SUBROUTINE SUMPLV (FLN,AP,AM,QLN,
     1                   IMAX,MEND1,NEND2,JEND2,MNWV3,KMAX,S)
      save
C***********************************************************************
C
C     SUMPLV : CALCULATES THE FOURIER REPRESENTATION OF A FIELD AT A
C              PAIR OF LATITUDES SYMMETRICALLY LOCATED ABOUT THE
C              EQUATOR.  THE CALCULATION IS MADE USING THE SPECTRAL
C              REPRESENTATION OF THE FIELD AND THE VALUES OF THE
C              ASSOCIATED LEGENDRE FUNCTIONS AT THAT LATITUDE.
C
C***********************************************************************
C
C     SUMPLV IS CALLED BY THE SUB GLOOP.
C
C     SUMPLV CALLS NO SUBS.
C
C***********************************************************************
C
C    ARGUMENT(DIMENSIONS)                       DESCRIPTION
C
C        FLN(MNWV3,KMAX)          INPUT :  SPECTRAL REPRESENTATION OF A
C                                          GLOBAL FIELD.
C         AP(IMAX,KMAX)          OUTPUT :  FOURIER REPRESENTATION OF
C                                          A GLOBAL FIELD AT THE
C                                          LATITUDE IN THE NORTHERN
C                                          HEMISPHERE AT WHICH THE
C                                          ASSOCIATED LEGENDRE FUNCTIONS
C                                          HAVE BEEN DEFINED. (SEE
C                                          DESCRIPTION OF "QLN" BELOW).
C         AM(IMAX,KMAX)          OUTPUT :  FOURIER REPRESENTATION OF
C                                          A GLOBAL FIELD AT THE
C                                          LATITUDE IN THE SOUTHERN
C                                          HEMISPHERE AT WHICH THE
C                                          ASSOCIATED LEGENDRE FUNCTIONS
C                                          HAVE BEEN DEFINED (SEE
C                                          DESCRIPTION OF "QLN" BELOW).
C         QLN(MNWV3)              INPUT :  VALUES OF THE ASSOCIATED
C                                          LEGENDRE FUNCTIONS AT ONE
C                                          LATITUDE IN THE NORTHERN
C                                          HEMISPHERE. IN THE SOUTHERN
C                                          HEMISPHERE, THE SAME VALUE
C                                          IS USED FOR SYMMETRIC
C                                          FUNCTIONS; THE NEGATIVE OF
C                                          THE VALUE IS USED FOR
C                                          ANTI-SYMMETRIC FUNCTIONS.
C
C         S  (MNWV3)                       WORK AREA
C
C             IMAX                INPUT :  NUMBER OF GRIDS ON A GAUSSIAN
C                                          LATITUDE
C             MEND1               INPUT :
C             NEND2               INPUT : } TRUNCATION WAVE NUMBERS
C             JEND2               INPUT :
C
C                          !
C                     JEND2!_   ______
C                          !   /     !
C                          !  /      !
C                          ! /       /
C                     NEND2!/       /
C                          !       /
C                          !      /
C                          !     /
C                          !    /
C                          !   /
C                          !  /
C                          ! /
C                          !/________!_____
C                          1       MEND1
C             MNWV3               INPUT :  (NUMBER OF WAVECOEFFICIENTS)
C                                           * 2 ,   (REAL,IMAG)
C             KMAX                INPUT :  NUMBER OF VERTICAL LEVELS.
C***********************************************************************
C
C... CREATED AT NMC JUNE 15 1984.......
C... REVISED BY N.SATO AT UMCP JAN 31 1986
      DIMENSION AP (IMAX,KMAX), AM (IMAX ,KMAX),
     1          QLN(MNWV3)    , FLN(MNWV3,KMAX),
     2          S  (MNWV3)    , MNROW(10)
      DATA IFP/1/
      IF(IFP.EQ.1) THEN
C
      MEND2=2*MEND1
C...IFAC IS THE LARGEST FACTOR THAT SATISFIES  2**IFAC.LE.NEND2
      IFAC=0
1     CONTINUE
      IFAC=IFAC+1
      IF(2**IFAC.LE.NEND2) GO TO 1
      IFAC=IFAC-1
C
      NFAC=2**IFAC
      NRES=NEND2-NFAC
      MNSTR=NFAC*MEND2
      MNRES=NRES*MEND2
CVD$L NOVECTOR
      DO 2 ITR=1,IFAC-1
      MNROW(ITR)=MEND2*2**ITR
   2  CONTINUE
C
      IFP=0
      END IF
C
C     GO TO 1000
      IF(JEND2.EQ.MEND1+NEND2-1) THEN
C================================C
C   PARALLELOGRAMIC TRUNCATION   C
C================================C
C
CVD$R NODEPCHK
CVD$R NOLSTVAL
      DO 100 K=1,KMAX
C
      DO 120 MN=1,MNWV3
      S(MN)=QLN(MN)*FLN(MN,K)
  120 CONTINUE
      IF(MNRES.GT.0) THEN
      DO 140 MN=1,MNRES
      S(MN)=S(MN)+S(MN+MNSTR)
  140 CONTINUE
      END IF
C
      IF(IFAC.GE.2) THEN
      DO 160 ITR=IFAC-1,1,-1
      MNEND=MNROW(ITR)
      DO 160 MN=1,MNEND
      S(MN)=S(MN)+S(MN+MNEND)
  160 CONTINUE
      END IF
C
      DO 180 MM=1,MEND2
      AP(MM,K)=S(MM)+S(MM+MEND2)
      AM(MM,K)=S(MM)-S(MM+MEND2)
  180 CONTINUE
C
  100 CONTINUE
C
      ELSE
C=================================================C
C   PENTAGONAL TRUNCATION (INCLUDES TRIANGULAR)   C
C=================================================C
C1000 CONTINUE
      DO 200 K=1,KMAX
C
      DO 220 MN=1,MNWV3
      S(MN)=QLN(MN)*FLN(MN,K)
  220 CONTINUE
C
      L=MEND2
      IF(2.GE.JEND2-MEND1+1) THEN
      MMAX1=2*(JEND2+1-2)
      ELSE
      MMAX1=MEND2
      END IF
      L=L+MMAX1
C
      DO 240 NN=3,NEND2
        IF(NN.GE.JEND2-MEND1+1) THEN
        MMAX=2*(JEND2+1-NN)
        ELSE
        MMAX=MEND2
        END IF
      IF(MOD(NN-1,2).EQ.0) THEN
      MSTR=0
      ELSE
      MSTR=MEND2
      END IF
      DO 240 MM=1,MMAX
      L=L+1
      S(MM+MSTR)=S(MM+MSTR)+S(L)
  240 CONTINUE
C
      DO 260 MM=1,MEND2
      AP(MM,K)=S(MM)
      AM(MM,K)=S(MM)
  260 CONTINUE
      DO 280 MM=1,MMAX1
      AP(MM,K)=AP(MM,K)+S(MM+MEND2)
      AM(MM,K)=AM(MM,K)-S(MM+MEND2)
  280 CONTINUE
C
  200 CONTINUE
C
      END IF
C
      RETURN
      END
