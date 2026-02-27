      SUBROUTINE LNDAMP(ZEG,VDVOR,DG ,VDDIV,TG,VDTEM,
     *                 DEL,SI,SL,NLOGG,NLV)
      DIMENSION TG(NLOGG,NLV),   VDTEM(NLOGG,NLV),
     *          ZEG(NLOGG,NLV),   VDVOR(NLOGG,NLV),
     *          DG (NLOGG,NLV),   VDDIV(NLOGG,NLV),
     *          DEL( NLV ),      SI( NLV+1 ),    SL( NLV )
      COMMON / TGLB / TGLOB(18)
      DIMENSION DCOEFV(18),DCOEFT(18)
c     TDAY=1./86400.
      TDAY=0./86400.
      DO 200 K=1,5
c        DCOEFV(K) = TDAY/(12.-11.7*SL(K))
c        DCOEFT(K) = TDAY/(7. -6.7*SL(K))
         DCOEFV(K) = TDAY/float(K)
         DCOEFT(K) = TDAY/float(K)
 200  CONTINUE
      DO 220 K=6,NLV
         DCOEFV(K) = TDAY/7.
         DCOEFT(K) = TDAY/7. 
 220  CONTINUE
      DO 300 I=1,NLOGG
      DO 300 K=1,NLV
	 VDVOR(I,K)=0.
         VDDIV(I,K)=0.
         VDTEM(I,K)=0.
 300  CONTINUE
C
      DO 400 I=1,NLOGG
      DO 400 K=1,NLV
         VDVOR(I,K)=ZEG(I,K)*DCOEFV(K)
         VDDIV(I,K)=DG(I,K)*DCOEFV(K)
         VDTEM(I,K)=TG(I,K)*DCOEFT(K)
 400  CONTINUE
C     
      RETURN
      END
