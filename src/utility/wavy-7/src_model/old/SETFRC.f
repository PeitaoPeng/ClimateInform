      SUBROUTINE SETFRC(FRC,KLEV)
C
      save
      include "ptrunk"
      include "pimax"
      include "pjmax"
      include "pkmax"
      include "comcom"
C-----------------------------------------------------------------------
      COMMON/SCRTCH/QWORK(MNWV3,3),GWORK(IMX,KGMAX)
      include "comnum"
      include "commnt"
      include "comtim"
      include "comphc"
      DIMENSION FRC(MNWV2,5)
C
      COMMON/FRCNS/
     | GFRCN(IMX),
C
     2 GFRCS(IMX)
C
      DATA IFP/1/
      IF(IFP.EQ.1) THEN
       MEND2 =MEND1*2
       JEND2 =JEND1+1
      ENDIF
C
C=======================================================================
C=========  LAT LOOP ===================================================
C=======================================================================
C
      DO 1000 LAT = 1, JMAXHF
      LOT=1
      CALL RESET(GFRCN,IMX*LOT)
      CALL RESET(GFRCS,IMX*LOT)
C
      CALL PLN2(PLN,DCOLRA,LAT,DEPS,MEND1,NEND2,JEND2,MNWV1,JMAXHF,LA1)
C
      LATCO=LAT
C.....
      CALL GFRC(GFRCN,COLRAD(LATCO),IMX,KLEV)
      write(6,*) 'COLRAD= ',COLRAD(LATCO)
C
      LATCO= JMAX +1-LAT
      write(6,*) 'COLRAD= ',COLRAD(LATCO)
      CALL GFRC(GFRCS,COLRAD(LATCO),IMX,KLEV)
C.....
      KKMAX=1
      CALL SYMASY(GFRCN ,GFRCS ,GWORK,IMX,KKMAX)
C...
      DO 400 MN=1,MNWV1
      QLN(2*MN-1)=PLN(MN)*WGT(LAT)
      QLN(2*MN  )=PLN(MN)*WGT(LAT)
400   CONTINUE
C
      CALL FL22(GFRCN ,GFRCS ,FRC(1,3), QLN,
     1          IMX,MEND1,NEND1,JEND1,MNWV2, 1 ,QWORK)
1000   CONTINUE
C
      RETURN
      END
