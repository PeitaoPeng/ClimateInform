      SUBROUTINE GSSTCD(Z00,SATCRI,ISST)
C
      save
      include "ptrunk"
      include "pimax"
      include "pjmax"
      include "pkmax"
      include "comcom"
C-----------------------------------------------------------------------
      include "comctl"
      include "comphc"
      include "comtim"
      include "comnum"
      include "commnt"
C-----------------------------------------------------------------------
C
CVD$L NOVECTOR
      DO 1 K=1,KMAXM
      RPIREC(K) =ONE/RPI(K)
1     CONTINUE
CVD$L NOVECTOR
      DO 2 K=1,KMAX
      RDEL2(K)=HALF/DEL(K)
2     CONTINUE
C...
      L=0
      DO 4 NN=1,NEND1
      IF(NN.LE.JEND1-MEND1+1) THEN
      MMAX=MEND1
      ELSE
      MMAX=JEND1+1-NN
      END IF
      DO 4 MM=1,MMAX
      L=L+1
      AN=MM+NN-2
      SNNP1(2*L-1)=AN*(AN+1)
      SNNP1(2*L  )=AN*(AN+1)
4     CONTINUE
C...
      Z00=ZERO
C     Z00=QGZS(1)
      GA2= GRAV/(ER*ER)
C     DO 3 MN=1,MNWV2
C     QGZS(MN)=QGZS(MN)*SNNP1(MN)*GA2
C   3 CONTINUE
C...
      T0=TBASE
      RLRV=-HL/(RMWMDI*GASR)
      CONST=E0C*EXP(-RLRV/T0)*TENTH
      C1=CONST*RMWMD
      C2=CONST*(RMWMD-ONE)
C...
      TS=280.0 E0
      HBOUND=GASR*TS*DEL(1)/(GRAV*SL(1))
      SEADRY=(TWO*F07*F10M3)/HBOUND
      RK= GASR/CP
      SL1KAP=ONE/SL(1)**RK
      SL100K = (SL(1)/HUNDRD)**RK
C... 20.0        :
C... 57.295799   :
      ROTSIN= SIN (20.0 E0/57.295779 E0)
      ROTCOS= COS (20.0 E0/57.295779 E0)
      SQ2BYH=SQRT(TWO)/HBOUND
CVD$L CLAPSE
      JJMAX=JMAX
C
      RETURN
      END
