      SUBROUTINE DZTOUV(QDIV,QROT,QU,QV,E,MEND1,NEND1,NEND2,JEND2,MNWV0,
     1                  MNWV1,KMAX,LA0,LA1,E0,E1)
C
      save
      include "comnum"
      include "comphc"
      DIMENSION QDIV(2,MNWV0,KMAX),QROT(2,MNWV0,KMAX),
     1          QU  (2,MNWV1,KMAX),QV  (2,MNWV1,KMAX),
     2          E(MNWV1),E0(MNWV1),E1(MNWV0)
      DIMENSION LA0(MEND1,NEND1),LA1(MEND1,NEND2)
C
      JEND1=JEND2-1
      E0(1)=ZERO
      E1(1)=ZERO
      DO 100 MM=2,MEND1
      E0(MM)=ZERO
      E1(MM)=ER/FLOAT(MM)
  100 CONTINUE
      L=MEND1
      DO 120 NN=2,NEND2
        IF(NN.LE.JEND2-MEND1+1) THEN
        MMAX=MEND1
        ELSE
        MMAX=JEND2-NN+1
        END IF
      DO 120 MM=1,MMAX
      L=L+1
      E0(L)=ER*E(L)/FLOAT(NN+MM-2)
  120 CONTINUE
      L=MEND1
      DO 140 NN=2,NEND1
        IF(NN.LE.JEND2-MEND1  ) THEN
        MMAX=MEND1
        ELSE
        MMAX=JEND2-NN
        END IF
      DO 140 MM=1,MMAX
      L=L+1
      AN=NN+MM-2
      AM=MM-1
      E1(L)=ER*AM/(AN+AN*AN)
  140 CONTINUE
C
      IF(JEND1.EQ.MEND1+NEND1-1) THEN
C=================================
C...PARALLELOGRAMIC TRUNCATION...=
C=================================
      L=MEND1
      DO 200 K=1,KMAX
C
      DO 220 MM=1,MEND1
      QU(1,MM,K)= E0(MM+L)*QROT(1,MM+L,K)+E1(MM)*QDIV(2,MM,K)
      QU(2,MM,K)= E0(MM+L)*QROT(2,MM+L,K)-E1(MM)*QDIV(1,MM,K)
      QV(1,MM,K)=-E0(MM+L)*QDIV(1,MM+L,K)+E1(MM)*QROT(2,MM,K)
      QV(2,MM,K)=-E0(MM+L)*QDIV(2,MM+L,K)-E1(MM)*QROT(1,MM,K)
  220 CONTINUE
      L2=MEND1*2
      DO 240 MN=1,MEND1*(NEND1-2)
      QU(1,MN+L,K)=-E0(MN+L)*QROT(1,MN  ,K)+E0(MN+L2)*QROT(1,MN+L2,K)
     1             +E1(MN+L)*QDIV(2,MN+L,K)
      QU(2,MN+L,K)=-E0(MN+L)*QROT(2,MN  ,K)+E0(MN+L2)*QROT(2,MN+L2,K)
     1             -E1(MN+L)*QDIV(1,MN+L,K)
      QV(1,MN+L,K)= E0(MN+L)*QDIV(1,MN  ,K)-E0(MN+L2)*QDIV(1,MN+L2,K)
     1             +E1(MN+L)*QROT(2,MN+L,K)
      QV(2,MN+L,K)= E0(MN+L)*QDIV(2,MN  ,K)-E0(MN+L2)*QDIV(2,MN+L2,K)
     1             -E1(MN+L)*QROT(1,MN+L,K)
  240 CONTINUE
C
      LP= NEND1   *MEND1
      L0=(NEND1-1)*MEND1
      LM=(NEND1-2)*MEND1
      DO 260 MM=1,MEND1
      QU(1,MM+L0,K)=-E0(MM+L0)*QROT(1,MM+LM,K)
     1              +E1(MM+L0)*QDIV(2,MM+L0,K)
      QU(2,MM+L0,K)=-E0(MM+L0)*QROT(2,MM+LM,K)
     1              -E1(MM+L0)*QDIV(1,MM+L0,K)
      QV(1,MM+L0,K)=+E0(MM+L0)*QDIV(1,MM+LM,K)
     1              +E1(MM+L0)*QROT(2,MM+L0,K)
      QV(2,MM+L0,K)= E0(MM+L0)*QDIV(2,MM+LM,K)
     1              -E1(MM+L0)*QROT(1,MM+L0,K)
  260 CONTINUE
      DO 280 MM=1,MEND1
      QU(1,MM+LP,K)=-E0(MM+LP)*QROT(1,MM+L0,K)
      QU(2,MM+LP,K)=-E0(MM+LP)*QROT(2,MM+L0,K)
      QV(1,MM+LP,K)=+E0(MM+LP)*QDIV(1,MM+L0,K)
      QV(2,MM+LP,K)= E0(MM+LP)*QDIV(2,MM+L0,K)
  280 CONTINUE
C
  200 CONTINUE
C....
      ELSE
C====================================
C...GENERAL PENTAGONAL TRUNCATION...=
C====================================
CVD$R NOVECTOR
      DO 300  K=1,KMAX
      DO 300 MM=1,MEND1
      IF(MM.LE.JEND2-NEND2+1) THEN
      NMAX=NEND2
      ELSE
      NMAX=JEND2+1-MM
      END IF
      QU(1,MM,K)= E1(MM)*QDIV(2,MM,K)
      QU(2,MM,K)=-E1(MM)*QDIV(1,MM,K)
      QV(1,MM,K)= E1(MM)*QROT(2,MM,K)
      QV(2,MM,K)=-E1(MM)*QROT(1,MM,K)
      IF(NMAX.GE.3) THEN
      L=MEND1
      QU(1,MM,K)=QU(1,MM,K)+E0(MM+L)*QROT(1,MM+L,K)
      QU(2,MM,K)=QU(2,MM,K)+E0(MM+L)*QROT(2,MM+L,K)
      QV(1,MM,K)=QV(1,MM,K)-E0(MM+L)*QDIV(1,MM+L,K)
      QV(2,MM,K)=QV(2,MM,K)-E0(MM+L)*QDIV(2,MM+L,K)
      END IF
      IF(NMAX.GE.4) THEN
      DO 320 NN=2,NMAX-2
      L0 =LA0(MM,NN)
      L0P=LA0(MM,NN+1)
      L0M=LA0(MM,NN-1)
      L1 =LA1(MM,NN)
      L1P=LA1(MM,NN+1)
      QU(1,L1,K)=-E0(L1)*QROT(1,L0M,K)+E0(L1P)*QROT(1,L0P,K)
     1           +E1(L0)*QDIV(2,L0 ,K)
      QU(2,L1,K)=-E0(L1)*QROT(2,L0M,K)+E0(L1P)*QROT(2,L0P,K)
     1           -E1(L0)*QDIV(1,L0 ,K)
      QV(1,L1,K)= E0(L1)*QDIV(1,L0M,K)-E0(L1P)*QDIV(1,L0P,K)
     1           +E1(L0)*QROT(2,L0 ,K)
      QV(2,L1,K)= E0(L1)*QDIV(2,L0M,K)-E0(L1P)*QDIV(2,L0P,K)
     1           -E1(L0)*QROT(1,L0 ,K)
  320 CONTINUE
      END IF
C
      IF(NMAX.GE.3) THEN
      NN=NMAX-1
      L0 =LA0(MM,NN)
      L0M=LA0(MM,NN-1)
      L1 =LA1(MM,NN)
      QU(1,L1,K)=-E0(L1)*QROT(1,L0M,K)
     1           +E1(L0)*QDIV(2,L0 ,K)
      QU(2,L1,K)=-E0(L1)*QROT(2,L0M,K)
     1           -E1(L0)*QDIV(1,L0 ,K)
      QV(1,L1,K)= E0(L1)*QDIV(1,L0M,K)
     1           +E1(L0)*QROT(2,L0 ,K)
      QV(2,L1,K)= E0(L1)*QDIV(2,L0M,K)
     1           -E1(L0)*QROT(1,L0 ,K)
      END IF
C
      IF(NMAX.GE.2) THEN
      NN=NMAX
      L0M=LA0(MM,NN-1)
      L1 =LA1(MM,NN)
      QU(1,L1,K)=-E0(L1)*QROT(1,L0M,K)
      QU(2,L1,K)=-E0(L1)*QROT(2,L0M,K)
      QV(1,L1,K)= E0(L1)*QDIV(1,L0M,K)
      QV(2,L1,K)= E0(L1)*QDIV(2,L0M,K)
      END IF
C
  300 CONTINUE
C
      END IF
C
      RETURN
      END
