      SUBROUTINE GFRC(GFORC,CRAD,IMX,KLEV)
C
      save
      include "ptrunk"
      include "pimax"
      include "pjmax"
      include "pkmax"
C
C     DIMENSION GFORC(IMX),COLRAD(JMAX)
      DIMENSION GFORC(IMX)
C
      PARAMETER(MDIM1=MEND1,NDIM1=NEND1,JDIM1=JEND1,IDIM=IMAX,JDIM=JMAX,
     S          KDIM =KMAX,
     1          NDIM2=NDIM1+1,IDIMP=IDIM+1,
     2          MNDM2=JDIM1*(JDIM1+1)-(JDIM1-NDIM1)*(JDIM1-NDIM1+1)
     3               -(JDIM1-MDIM1)*(JDIM1-MDIM1+1),
     4          MNDM3=MNDM2+2*MDIM1,
     5          IDIMT=IDIM*3/2,
     6          KDIMP=KDIM+1,KDIMM=KDIM-1)
C....
      COMMON /SCRTCH/   QWORK(MNDM3,3)  ,
     1 GK1(IDIMP )     ,GK2(IDIMP,KDIMM),
     2 GYV(IDIMP,KDIM ),GTD(IDIMP,KDIM ),GYU(IDIMP,KDIM ),
     3 GTU(IDIMP,KDIM ),GTV(IDIMP,KDIM ),
     4 CG (IDIMP,KDIM ),DG (IDIMP,KDIM ),CB (IDIMP,KDIM ),
     5 DB (IDIMP,KDIM ),DOT(IDIMP,KDIM )
      COMMON/COMBIT/TRIGS(IDIMT),SNNP1(MNDM2),IFAX(10),LAB(4),
     1              LA0(MDIM1,NDIM1),LA1(MDIM1,NDIM2)
C....
      COMMON/VERCOM/AM(KDIM,KDIM),HM(KDIM,KDIM),TM(KDIM,KDIM),
     O              BM(KDIM,KDIM),CM(KDIM,KDIM),EKIN(KDIM),
     1 SI(KDIMP),SL(KDIM),DEL(KDIM),RDEL2(KDIM),RMSGKE(KDIMM),
     2 CI(KDIMP),CL(KDIM),TOV(KDIM),SV(KDIM),   RPI(KDIMM),
     3 P1(KDIM ),P2(KDIM), H1(KDIM),H2(KDIM),RPIREC(KDIMM),
     4 ROTSIN,ROTCOS,SEADRY,SL1KAP,C1,C2,RLRV,SL100K,
     5 DM(KDIM,KDIM,JDIM1)
C...
      include "comctl"
      include "comphc"
      include "commnt"
      include "comtim"
      include "comnum"
      DIMENSION RLONG(IMAX)
C
      DATA IFP/1/
C
      IF(IFP.EQ.1) THEN
       PAI12 =PAI/FLOAT(12)
       IFP   =0
       IF(KMAX.NE.KDIM  .OR.
     2     IMX.NE.IDIMP)     THEN
       WRITE(6,99)
   99  FORMAT(1H ,'PARAMETER SETTING IS WRONG IN SUBR. GFRC')
       STOP 9599
      END IF
C
       DELLON = 360./FLOAT(IMAX)
       RLONG(1) = ZERO
       DO 10 I=2,IMAX
       RLONG(I) = RLONG(I-1) + DELLON
  10   CONTINUE
C
      END IF
C
      IF     (IFFT.EQ.'JMA ') THEN
      INC=1
      ELSE IF(IFFT.EQ.'CYB ') THEN
      INC=MDIM1
      END IF
      JUMP=IMX
      JMXHF=(JJMAX+1)/2
      IFP=0
C
      AMPHT = 10./86400.
      IF(SL(KLEV).GT..85.OR.SL(KLEV).LT..2) THEN
       DO 80 I=1,IMX
       GK1(I) = 0.
  80   CONTINUE
       RETURN
      ELSE
C
       CLAT=CRAD*180/3.14159
       DO  90 I=1, IMAX
       IF(180..LE.RLONG(I).AND.RLONG(I).LE.200.
     +    .and.80..lt.CLAT.and.CLAT.lt.100.) THEN
        GK1(I) = 4.*AMPHT*SL(KLEV)*(ONE-SL(KLEV))
       ELSE
        GK1(I) = ZERO
       ENDIF
  90   CONTINUE
C
      AMPHTC = 20./86400.
       DO  95 I=1, IMAX
       IF(120..LE.RLONG(I).AND.RLONG(I).LE.130.
     +    .and.55..lt.CLAT.and.CLAT.lt.65.) THEN
        GK1(I) = -4.*AMPHTC*SL(KLEV)*(ONE-SL(KLEV))
c      ELSE
c       GK1(I) = ZERO
       ENDIF
  95   CONTINUE
C
      ENDIF
C
      ISIGN=-1
      LOT=1
C
      CALL FFT991(GK1,GFORC,TRIGS,IFAX,INC,JUMP,IMAX,LOT,ISIGN)
C
      DO 800 IK=1,IMX*LOT
      GFORC(IK)=GK1(IK)
  800 CONTINUE
C
      RETURN
      END
