      SUBROUTINE DELLNP(QLNP,QDPHI,QDLAM,EPS,MEND1,NEND1,NEND2,JEND1,
     1                  MNWV0,MNWV1,LA0,LA1)
C
      save
      include "comnum"
      include "comphc"
      DIMENSION QLNP (2,MNWV0),QDPHI(2,MNWV1),
     1          QDLAM(2,MNWV0),EPS  (  MNWV1)
      DIMENSION LA0(MEND1,NEND1),LA1(MEND1,NEND2)
C
      L=0
      DO 2 NN=1,NEND1
        IF(NN.LE.JEND1-MEND1+1) THEN
        MMAX=MEND1
        ELSE
        MMAX=JEND1+1-NN
        END IF
      AM=-ONE
      DO 2 MM=1,MMAX
      L =L +1
      AM=AM+ONE
      QDLAM(1,L)=-AM*QLNP(2,L)
      QDLAM(2,L)= AM*QLNP(1,L)
    2 CONTINUE
C
      DO 4 MM=1,MEND1
      AM=MM-1
      AN=AM
      IF(JEND1.GT.MEND1.OR.MM.LT.MEND1)THEN
      QDPHI(1,MM)=QLNP(1,MM+MEND1)*(AN+TWO)*EPS(MM+MEND1)
      QDPHI(2,MM)=QLNP(2,MM+MEND1)*(AN+TWO)*EPS(MM+MEND1)
      ELSE
      QDPHI(1,MM)=ZERO
      QDPHI(2,MM)=ZERO
      END IF
        IF(MM.LE.JEND1+1-NEND1) THEN
        NMAX=NEND2
        ELSE
        NMAX=JEND1+2-MM
        END IF
      IF(NMAX.GE.4) THEN
      DO 3 NN=2,NMAX-2
      AN=AN+ONE
      L1 =LA1(MM,NN)
      L1P=LA1(MM,NN+1)
      L0P=LA0(MM,NN+1)
      L0M=LA0(MM,NN-1)
      QDPHI(1,L1)=(AN+TWO)*EPS(L1P)*QLNP(1,L0P)
     1           +(ONE-AN)*EPS(L1 )*QLNP(1,L0M)
      QDPHI(2,L1)=(AN+TWO)*EPS(L1P)*QLNP(2,L0P)
     1           +(ONE-AN)*EPS(L1 )*QLNP(2,L0M)
    3 CONTINUE
      END IF
C
      IF(NMAX.GE.3) THEN
      NN=NMAX-1
      AN=AN+ONE
      L1 =LA1(MM,NN)
      L0M=LA0(MM,NN-1)
      QDPHI(1,L1)=(ONE-AN)*EPS(L1 )*QLNP(1,L0M)
      QDPHI(2,L1)=(ONE-AN)*EPS(L1 )*QLNP(2,L0M)
      END IF
C
      IF(NMAX.GE.2) THEN
      NN=NMAX
      AN=AN+ONE
      L1 =LA1(MM,NN)
      L0M=LA0(MM,NN-1)
      QDPHI(1,L1)=(ONE-AN)*EPS(L1 )*QLNP(1,L0M)
      QDPHI(2,L1)=(ONE-AN)*EPS(L1 )*QLNP(2,L0M)
      END IF
    4 CONTINUE
C
      ERIV =ONE/ER
      DO 5 MN=1,2*MNWV0
      QDLAM(MN,1)=ERIV*QDLAM(MN,1)
    5 CONTINUE
      DO 6 MN=1,2*MNWV1
      QDPHI(MN,1)=ERIV*QDPHI(MN,1)
    6 CONTINUE
C
      RETURN
      END
