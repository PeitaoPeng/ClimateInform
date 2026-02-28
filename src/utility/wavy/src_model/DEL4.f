      SUBROUTINE DEL4(DK,TK,S,W,QDIVT,QDIVM,QTMPT,QTMPM,QROTT,
     1                QROTM,QLNPM,MEND1,NEND1,JEND1,MNWV2,
     2                KMAX,CT,CQ,LA0im)
C
      save
      DIMENSION
     2 QDIVT(MNWV2,KMAX ),QDIVM(MNWV2,KMAX ),
     3 QTMPT(MNWV2,KMAX ),QTMPM(MNWV2,KMAX ),
     4 QROTT(MNWV2,KMAX ),QROTM(MNWV2,KMAX ),QLNPM(MNWV2)
      DIMENSION S (MNWV2),W (MNWV2)
      DIMENSION CT(KMAX)   ,CQ(KMAX)
      dimension LA0im(nend1)
      include "comphc"
      include "comctl"
      include "comnum"
C
      RDK=-DK/(ER*ER)
      RDK=RDK/(ER*ER)
      DO 10 MN=1,MNWV2
      W(MN)=RDK*S(MN)*S(MN)
10    CONTINUE
      do 11 nn=1,nend1
      w(LA0im(nn)*2)=0.
11    continue
      DO 20 K=1,KMAX
      DO 20 MN=1,MNWV2
      QDIVT(MN,K)=QDIVT(MN,K)+W(MN)*QDIVM(MN,K)
20    CONTINUE
C...  FIN DIV DAMPING WITH COEF. DK*DEL**2
C
      RTK=-TK/(ER*ER)
      RTK=RTK/(ER*ER)
      DO 30 MN=1,MNWV2
      W(MN)=RTK*S(MN)*S(MN)
   30 CONTINUE
      do 31 nn=1,nend1
      w(LA0im(nn)*2)=0.
31    continue
C...  DAMP TEMP AND VORTICITY TENDENCIES
      DO 50 K=1,KMAX
      DO 50 MN=1,MNWV2
      QTMPT(MN,K)=QTMPT(MN,K)+W(MN)*(QTMPM(MN,K)-CT(K)*QLNPM(MN))
      QROTT(MN,K)=QROTT(MN,K)+W(MN)* QROTM(MN,K)
50    CONTINUE
      RETURN
      END
