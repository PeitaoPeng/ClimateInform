      SUBROUTINE GFIDI
     |(GE,GDIV,GTMP,GROT,GU,GV,GDOT,GPLAM,GPPHI,GLNP  ,
     | GBDIV ,GBTMP ,GBROT ,GBU   ,GBV   ,GBPLAM,GBPPHI,GBLNP ,
     | GTSA,COLRAD,RCL   ,IMX   )
C
      save
      include "ptrunk"
      include "pimax"
      include "pjmax"
      include "pkmax"
C
      DIMENSION GE(IMX,KMAX),
     |          GDIV (IMX,KMAX ),GTMP (IMX, KMAX),GROT(IMX,KMAX),
     2          GU   (IMX,KMAX ),GV   (IMX, KMAX),GDOT(IMX,KMAX),
     3          GPLAM(IMX)      ,GPPHI(IMX)      ,GLNP(IMX)
      DIMENSION GBDIV(IMX,KMAX ),GBTMP(IMX, KMAX),GBROT(IMX,KMAX),
     2          GBU  (IMX,KMAX ),GBV  (IMX, KMAX),
     3          GBPLAM(IMX),GBPPHI(IMX),GBLNP(IMX)
      DIMENSION COLRAD(JMAX)
      DIMENSION GTSA(IMX)
      DIMENSION UTEND(IMAX,KMAX ),VTEND(IMAX, KMAX),TTEND(IMAX,KMAX)
C....
      PARAMETER(MDIM1=MEND1,NDIM1=NEND1,JDIM1=JEND1,IDIM=IMAX,JDIM=JMAX,
     S          KDIM =KMAX,
     1          NDIM2=NDIM1+1,IDIMP=IDIM+1,
     2          MNDM2=JDIM1*(JDIM1+1)-(JDIM1-NDIM1)*(JDIM1-NDIM1+1)
     3               -(JDIM1-MDIM1)*(JDIM1-MDIM1+1),
     4          MNDM3=MNDM2+2*MDIM1,
     5          IDIMT=IDIM*3/2,
     6          KDIMP=KDIM+1,KDIMM=KDIM-1)
      COMMON /SCRTCH/   QWORK(MNDM3,3)  ,
     1 GKE(IDIMP,KDIM ),
     2 GYV(IDIMP,KDIM ),GTD(IDIMP,KDIM ),GYU(IDIMP,KDIM ),
     3 GTU(IDIMP,KDIM ),GTV(IDIMP,KDIM ),
     4 CG (IDIMP,KDIM ),DG (IDIMP,KDIM ),CB (IDIMP,KDIM ),
     5 DB (IDIMP,KDIM ),DOT(IDIMP,KDIM )
      DIMENSION CGB(IDIMP,KDIM),DOTB(IDIMP,KDIM),GTUB(IDIMP,KDIM),
     | GTVB(IDIMP,KDIM)
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
      DIMENSION CDRAG(KDIM), CCOOL(KDIM)
C...
      include "comctl"
      include "comphc"
      include "commnt"
      include "comtim"
      include "comnum"
      DATA IFP/1/
C
      IF(IFP.EQ.1) THEN
c     TDAY=1.5/86400.
c     TDAY=4.0/86400.
c     TDAY=3.0/86400.
      TDAY=1.0/86400.
      DO 2 K=1,KDIM
c        CDRAG(K) = TDAY/(20.-19.8*SL(K))
c        CCOOL(K) = TDAY/(15-14.8*SL(K))
         CDRAG(K) = TDAY/10.
         CCOOL(K) = TDAY/10.
 2    CONTINUE
         CDRAG(1) = TDAY/2.   
         CDRAG(2) = TDAY/5.
         CCOOL(1) = TDAY/2.
         CCOOL(2) = TDAY/5.
      PAI12 =PAI/FLOAT(12)
      FIMXIV=FLOAT(24)/FLOAT(IMAX)
      IFP   =0
      IF(KMAX.NE.KDIM  .OR.
     2    IMX.NE.IDIMP)     THEN
      WRITE(6,99)
   99 FORMAT(1H ,'PARAMETER SETTING IS WRONG IN SUBR. GFIDI')
      STOP 9999
      END IF
C
      IKMAX =IMX*KMAX
      IF     (IFFT.EQ.'JMA ') THEN
      INC=1
      ELSE IF(IFFT.EQ.'CYB ') THEN
      INC=MDIM1
      END IF
      JUMP=IMX
      JMXHF=(JJMAX+1)/2
      IFP=0
      END IF
C
C...  PERFORM FAST FOURIER TRANSFORM FOR VARIABLES
C                  STARTING FROM GDIV TO GQM
      ISIGN=1
      LOT=6*KMAX+3
      CALL FFT991(GDIV,GKE,TRIGS,IFAX,INC,JUMP,IMAX,LOT,ISIGN)
      LOT=5*KMAX+3
      CALL FFT991(GBDIV,GKE,TRIGS,IFAX,INC,JUMP,IMAX,LOT,ISIGN)
C-----------------------------------------------------------------------
C      HORIZONTAL AND VERTICAL ADVECTION TERMS
C-----------------------------------------------------------------------
      DO  80 K=1, KMAX
      DO  80 I=1, IMAX
      GYU(I,K)=GROT(I,K)*GBU(I,K)+GBROT(I,K)*GU(I,K) 
     | +GASR*(GBTMP(I,K)*GPPHI(I)+GTMP(I,K)*GBPPHI(I))
      GYV(I,K)=GROT(I,K)*GBV(I,K)+GBROT(I,K)*GV(I,K)
     | -GASR*(GBTMP(I,K)*GPLAM(I)+GTMP(I,K)*GBPLAM(I))
80    CONTINUE
C     COMPUTE C=V(TRUE)*DEL(LN(PS)).DIVIDE BY COS FOR DEL, COS FOR V
      DO 100 I=1, IMAX
      GPPHI(I)=GPPHI(I)*RCL
      GPLAM(I)=GPLAM(I)*RCL
      GBPPHI(I)=GBPPHI(I)*RCL
      GBPLAM(I)=GBPLAM(I)*RCL
100   CONTINUE
C ...  PERTURBATION HORIZONTAL ADVECTION OF LN SURFACE PRESSURE
C      AND CALCULATION OF BASIC STATE SIGMADOT
      DO 120 K=1,KMAX
      DO 120 I=1,IMAX
      CG(I,K)=GBU(I,K)*GPLAM(I)+GU(I,K)*GBPLAM(I)
     |   +GBV(I,K)*GPPHI(I)+GV(I,K)*GBPPHI(I)
      CGB(I,K)=GBU(I,K)*GBPLAM(I)+GBV(I,K)*GBPPHI(I)
120   CONTINUE
      RK= GASR/CP
      DO 140 I=1, IMAX
      DB(I,1)=DEL(1)*GBDIV(I,1)
      CB(I,1)=DEL(1)*CGB (I,1)
140   CONTINUE
      DO 160 K=1, KMAX-1
      DO 160 I=1, IMAX
      DB(I,K+1)=DB(I,K)+DEL(K+1)*GBDIV(I,K+1)
      CB(I,K+1)=CB(I,K)+DEL(K+1)*CGB (I,K+1)
160   CONTINUE
C
      DO 200 I=1, IMAX
      DOTB(I,1)=ZERO
200   CONTINUE
      DO 220 K=1,KMAX-1
      DO 220 I=1, IMAX
      DOTB(I,K+1)=DOTB(I,K)+DEL(K)*(DB(I,KMAX)+CB(I,KMAX)
     1          -GBDIV(I,K)-CGB(I,K))
c     dotb(i,k+1)=dotb(i,k)+del(k)*(db(i,kmax)-gbdiv(i,k))
220   CONTINUE
C
c    Add in surface pressure advection terms
c    The commented line is the original formulation
c    which is replaced by formulation as in zonally symmetric basic
c    state linear model.  
      DO 240 K=1, KMAX
      DO 240 I=1, IMAX
      if(k.eq.1) then
      dotpp=gdot(i,k)
      dotmm=0.
      dotbp=dotb(i,k+1)
      dotbm=dotb(i,k)
      endif
      if(k.eq.kmax) then
      dotpp=0.
      dotmm=gdot(i,k-1)
      dotbp=0.
      dotbm=dotb(i,k)
      endif
      if(k.gt.1.and.k.lt.kmax) then
      dotpp=gdot(i,k)
      dotmm=gdot(i,k-1)
      dotbp=dotb(i,k+1)
      dotbm=dotb(i,k)
      endif
      GTD(I,K) = GBTMP(I,K)*GDIV(I,K) + GTMP(I,K)*GBDIV(I,K)
c    |  +RK*GBTMP(I,K)*CG(I,K)+RK*GTMP(I,K)*CGB(I,K)
c    | +rk*gtmp(i,k)*cgb(i,k)
     | -rk*gtmp(i,k)*gbdiv(i,k)
     | -rk*gtmp(i,k)*(dotbp-dotbm)/del(k)
     | -rk*gbtmp(i,k)*gdiv(i,k)
     | -rk*gbtmp(i,k)*(dotpp-dotmm)/del(k)
240   CONTINUE
C
      DO 260 K=1,KMAX-1
      DO 260 I=1, IMAX
      GTV(I,K)=GV(I,K+1)-GV(I,K)
      GTU(I,K)=GU(I,K+1)-GU(I,K)
      GTVB(I,K)=GBV(I,K+1)-GBV(I,K)
      GTUB(I,K)=GBU(I,K+1)-GBU(I,K)
260   CONTINUE
      K=1
      DO 280 I=1, IMAX
      GYU(I,K)=GYU(I,K)+RDEL2(K)*(DOTB(I,K+1)*GTV(I,K)+
     |                           GDOT(I,K)*GTVB(I,K))
      GYV(I,K)=GYV(I,K)-RDEL2(K)*(DOTB(I,K+1)*GTU(I,K)+
     |                           GDOT(I,K)*GTUB(I,K))
280   CONTINUE
      K=KMAX
      DO 300 I=1,IMAX
      GYU(I,K)=GYU(I,K)+RDEL2(K)*(DOTB(I,K)*GTV(I,K-1)+
     |                           GDOT(I,K-1)*GTVB(I,K-1))
      GYV(I,K)=GYV(I,K)-RDEL2(K)*(DOTB(I,K)*GTU(I,K-1)+
     |                           GDOT(I,K-1)*GTUB(I,K-1))
300   CONTINUE
      IF(KMAX.GE.3) THEN
      DO 320 K=2,KMAX-1
      DO 320 I=1,IMAX
      GYU(I,K)=GYU(I,K)+RDEL2(K)*(DOTB(I,K+1)*GTV(I,K)
     | +DOTB(I,K)*GTV(I,K-1)
     | +GDOT(I,K)*GTVB(I,K)+GDOT(I,K-1)*GTVB(I,K-1))
      GYV(I,K)=GYV(I,K)-RDEL2(K)*(DOTB(I,K+1)*GTU(I,K)
     | +DOTB(I,K)*GTU(I,K-1)
     | +GDOT(I,K)*GTUB(I,K)+GDOT(I,K-1)*GTUB(I,K-1))
320   CONTINUE
      END IF
C
      DO 340 K=1,KMAX-1
      DO 340 I=1,IMAX
      GTU(I,K  )=P1(K)*GTMP(I,K+1)-GTMP(I,K)
      GTV(I,K+1)=GTMP(I,K+1)-P2(K+1)*GTMP(I,K)
      CB(I,K)   =P1(K)*GBTMP(I,K+1)-GBTMP(I,K)
      DB(I,K+1) =GBTMP(I,K+1)-P2(K+1)*GBTMP(I,K)
340   CONTINUE
      K=1
      DO 360 I=1, IMAX
      GTD(I,K)=GTD(I,K)-RDEL2(K)*(DOTB(I,K+1)*GTU(I,K)+
     | GDOT(I,K)*CB(I,K))
360   CONTINUE
      K=KMAX
      DO 380 I=1, IMAX
      GTD(I,K)=GTD(I,K)-RDEL2(K)*(DOTB(I,K)*GTV(I,K)+
     | GDOT(I,K-1)*DB(I,K))
380   CONTINUE
      IF(KMAX.GE.3) THEN
      DO 400 K=2, KMAX-1
      DO 400 I=1, IMAX
      GTD(I,K)=GTD(I,K)-RDEL2(K)*(DOTB(I,K+1)*GTU(I,K)
     1        +DOTB(I,K)*GTV(I,K)
     |        +GDOT(I,K)*CB(I,K)+GDOT(I,K-1)*DB(I,K))
400   CONTINUE
      END IF
C
      DO 520 IK=1,IKMAX
      GTU(IK,1)=GBTMP(IK,1)*GU(IK,1)+GTMP(IK,1)*GBU(IK,1)
      GTV(IK,1)=GBTMP(IK,1)*GV(IK,1)+GTMP(IK,1)*GBV(IK,1)
      GKE(IK,1)=(GU(IK,1)*GBU(IK,1)+GV(IK,1)*GBV(IK,1))*RCL
     |          +GASR*GTMP(Ik,1) 
  520 CONTINUE
C
C  ADD LINEAR TERMS TO SURFACE PRESSURE TENDENCY EQUATION
      DO 620 K=1,KMAX
      DO 620 I=1,IMAX
      IF(K.EQ.1) THEN
       DOTPLS = GDOT(I,K)
       DOTMIN = ZERO
      ENDIF
      IF(K.EQ.KMAX) THEN
       DOTPLS = 0.
       DOTMIN = GDOT(I,K-1)
      ENDIF
      IF(K.GT.1.AND.K.LT.KMAX) THEN
       DOTPLS = GDOT(I,K)
       DOTMIN = GDOT(I,K-1)
      ENDIF
      CG(I,K) = CG(I,K) + GDIV(I,K) +(DOTPLS-DOTMIN)/DEL(K) 
c     cg(i,k) = GDIV(I,K) +(DOTPLS-DOTMIN)/DEL(K)
      cg(i,k) = -cg(i,k)
c     cg(i,k) = 0.
c  for ln ps = 0 soln.
c     if(k.eq.kmax) cg(i,k) = 0.
 620  CONTINUE
C
C-----------------------------------------------------------------------
C... SURFACE EXCHANGE AND VETICAL DIFFUSION OF
C            HEAT,MOISTURE AND MOMENTUM
C-----------------------------------------------------------------------
C
C..  RALEIGH DAMPING FOR VORTICITY AND DIVERGENCE EQUATIONS
C
C
      DO 402 K=1,KMAX
      DO 402 I=1,IMAX
      GYU(I,K) = GYU(I,K) + CDRAG(K)*GV(I,K)
      GYV(I,K) = GYV(I,K) - CDRAG(K)*GU(I,K)
      GTD(I,K) = GTD(I,K) - CCOOL(K)*GTMP(I,K)
 402  CONTINUE
C
C...    plus the tendency due to vertical diffussion
c     write(6,*) 'before calling DIFFUS'
      CALL DIFFUS(GTMP,GTSA,gtd,DEL,SI,SL,IMX,KMAX,1, 1.)
      CALL DIFFUS(GU,GTSA,gyv,DEL,SI,SL,IMX,KMAX,  0, 1.)
      CALL DIFFUS(GV,GTSA,gyu,DEL,SI,SL,IMX,KMAX,  0,-1.)
C     
      ISIGN=-1
      LOT=7*KMAX
C
      CALL FFT991(GKE,GE,TRIGS,IFAX,INC,JUMP,IMAX,LOT,ISIGN)
C
      DO 800 IK=1,IMX*LOT
      GE(IK,1)=GKE(IK,1)
  800 CONTINUE
C
      RETURN
      END
