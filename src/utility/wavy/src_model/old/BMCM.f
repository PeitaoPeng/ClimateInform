      SUBROUTINE BMCM(TOV,P1,P2,H1,H2,DEL,CI,BM,CM,DT,SV,AM,KMAX,KMAXP)
C
      save
      include "comnum"
      include "comphc"
      DIMENSION BM(KMAX,KMAX),CM(KMAX,KMAX),
     1          TOV(KMAX),P1(KMAX ),P2(KMAX),H1(KMAX),H2(KMAX),
     2          DEL(KMAX),CI(KMAXP),SV(KMAX),AM(KMAX,KMAX )
C
      RK =  GASR /CP
      DO 1 K=1,KMAX-1
      H1(K) = P1(K) * TOV(K+1) - TOV(K)
1     CONTINUE
      H1(KMAX)=ZERO
      H2(   1)=ZERO
      DO 2 K=2, KMAX
      H2(K) = TOV(K) - P2(K) * TOV(K-1)
2     CONTINUE
      RETURN
      END
