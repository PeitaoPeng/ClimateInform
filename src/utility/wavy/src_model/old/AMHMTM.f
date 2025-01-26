      SUBROUTINE AMHMTM(DEL,RPI,SV,P1,P2,AM,HM,TM,KMAX,KMAXM)
C
      save
      include "comnum"
      include "comphc"
      DIMENSION DEL(KMAX),RPI(KMAXM),SV( KMAX ),
     1          P1 (KMAX),P2 (KMAX),
     2          AM (KMAX,KMAX),HM(KMAX,KMAX),TM(KMAX,KMAX)
      DIMENSION LLL(32),MMM(32)
C
      ERSQIV=ONE/ER**2
C
      DO 5 K=1, KMAX*KMAX
      HM(K,1) = ZERO
      TM(K,1) = ZERO
5     CONTINUE
CVD$R NOVECTOR
      DO 6 K=1, KMAXM
      HM(K,K) = ONE
      TM(K,K) = HALF *  CP   * (RPI(K)-ONE)
CMRF  TM(K,K) = HALF *1005.S0* (RPI(K)-ONE)
6     CONTINUE
      DO 66 K=1, KMAXM
      HM(K,K+1) = -ONE
      TM(K,K+1) = HALF * CP    * (ONE-ONE/RPI(K))
CMRF  TM(K,K+1) = HALF *1005.S0* (ONE-ONE/RPI(K))
66    CONTINUE
      DO 7 K=1, KMAX
      HM( KMAX ,K) = DEL(K)
      TM( KMAX ,K) =  GASR   * DEL(K)
7     CONTINUE
      CALL IMINV (HM,  KMAX , DET, LLL, MMM)
      DO 8 I=1, KMAX
      DO 8 J=1, KMAX
      AM(I,J) = ZERO
      DO 8 K=1, KMAX
      AM(I,J) = AM(I,J) + HM(I,K)*TM(K,J)
8     CONTINUE
C     HERE IS A GOOD PLACE TO DIVIDE BY A**2 FOR LAPLACIAN
C     STORE AM IN TM AND DIVIDE AM
CVD$L VECTOR
      DO 10 K=1, KMAX*KMAX
      TM(K,1) = AM(K,1)
      HM(K,1) = AM(K,1)
      AM(K,1) = AM(K,1) *ERSQIV
10    CONTINUE
      CALL IMINV(TM, KMAX ,DET,LLL,MMM)
CVD$R NOVECTOR
      DO 9 K=1, KMAX
      SV(K) = -DEL(K)
9     CONTINUE
      DO 11 K=1, KMAXM
      P1(K) = ONE / RPI(K)
      P2(K+1) = RPI(K)
11    CONTINUE
      P1(KMAX) = ZERO
      P2( 1  ) = ZERO
      PRINT 333
333   FORMAT(1H0,'SHALOM  AMHMTM')
      RETURN
      END
