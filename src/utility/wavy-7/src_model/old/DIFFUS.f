      SUBROUTINE DIFFUS(TG,TSFC,VDTEM,DEL,SI,SL,NLOGG,NLV,IT,val)
c      calculates -d**2( )/dz**2
      save
      DIMENSION TG(NLOGG,NLV), TSFC(NLOGG), VDTEM(NLOGG,NLV),
     *          DEL( NLV ),      SI( NLV+1 ),    SL( NLV )
C
      include "pkmax"
C
      PARAMETER(KMAXM=KMAX-1,KMAXP=KMAX+1)
      COMMON / TGLB / TGLOB(KMAX)
      DIMENSION  DELTA(KMAXP), GAMMA(KMAXP), VKDIFF(KMAXM)
      DIMENSION  SLKAP(KMAX)
      DATA IFIRST / 1 /
C       UNITS OF VKDIFF ARE M**2/SEC
c     DATA VKDIFF / 22., 9., 3.0, 0.9, 0.6, 0.8, 1.2, 1.5, 1.2/
c     DATA VKDIFF / 0.2, 0.3, 0.5, 0.8, 1.7, 2.1, 7, 20, 25/
      DATA VKDIFF / 25, 20, 7, 2.1, 1.7, 0.8, 0.5, 0.3, 0.2/
C
C     UNITS OF SURFACE DRAG COEFF 1/SEC
c     DATA BETA / 1.E-5 /
      DATA BETA / 0.0 /
C
      IF(IFIRST.NE.1) GO TO 100
       IFIRST = 0
      GRAV = 9.8
      RGAS = 287.05
      CP = 1005.
      CAPPA = RGAS / CP
      DO 5 K=1,NLV
      SLKAP(K) = 1./SL(K) ** CAPPA
   5  CONTINUE
      do k=1,kmaxm
c       VKDIFF(k)=0.6/SL(k)**2
      end do
      write(6,*) 'VKDIFF= ',VKDIFF
      DO 10 KLEV=1,NLV
      IF(KLEV.EQ.NLV) GO TO 20
C.......CALCULATE DELTAS
      TK =  (TGLOB(KLEV+1) + TGLOB(KLEV)) /  2.
      CON1 = ( GRAV /(RGAS*TK) )**2
      DELTA(KLEV) = CON1 * SI(KLEV+1)**2 /
     *              (DEL(KLEV)*(SL(KLEV)-SL(KLEV+1)))
  20  CONTINUE
      IF(KLEV.EQ.1) GO TO 30
C.......CALCULATE GAMMAS
      TKM1 = (TGLOB(KLEV) + TGLOB(KLEV-1)) / 2.
      CON2 = ( GRAV /(RGAS*TKM1) )**2
      GAMMA(KLEV-1) = CON2 * SI(KLEV)**2 /
     *              (DEL(KLEV)*(SL(KLEV-1)-SL(KLEV)))
  30  CONTINUE
  10  CONTINUE
c...    scale beta by mrf86 value
      BETA = BETA*(.01/DELTA(1))*(SL(1)/.995)
 100  CONTINUE
C
c     write(6,*)'TSFC= ', TSFC 
c     write(6,*)'gamma=', GAMMA
c     write(6,*)'tglobm=', TGLOB
C.......IT=1: Temperature; IT=0: Vorticity or Divergence.
      DO 200 I=1,NLOGG
C
      IF(IT.EQ.1) then
      VDTEM(I,1) = vdtem(i,1)+val*(DELTA(1)*VKDIFF(1)
     *             *(TG(I,2)*SLKAP(2)-TG(I,1)*SLKAP(1))
     *             - BETA * (TG(I,1)*SLKAP(1)-0*TSFC(I)))
      else
      VDTEM(I,1) = vdtem(i,1) + val*
     *              (DELTA(1)*VKDIFF(1)*(TG(I,2)-TG(I,1))
     *             - BETA * TG(I,1))
      endif
C
      DO 210 K=2,NLV-1
      IF(IT.EQ.1) then
      VDTEM(I,K) = vdtem(i,k)+val*(DELTA(K)*VKDIFF(K)
     *             *(TG(I,K+1)*SLKAP(K+1)-TG(I,K)*SLKAP(K))
     *             -GAMMA(K-1)*VKDIFF(K-1)
     *             *(TG(I,K)*SLKAP(K)-TG(I,K-1)*SLKAP(K-1)))
      else
      VDTEM(I,K) = vdtem(i,k)+ val*
     *             (+DELTA(K)*VKDIFF(K)*(TG(I,K+1)-TG(I,K))
     *             -GAMMA(K-1)*VKDIFF(K-1)*(TG(I,K)-TG(I,K-1)))
      endif
 210  CONTINUE
C
      IF(IT.EQ.1) then
      VDTEM(I,NLV) = vdtem(i,nlv) +
     *    val*(-GAMMA(NLV-1)*VKDIFF(NLV-1)
     *    *(TG(I,NLV)*SLKAP(NLV)-TG(I,NLV-1)*SLKAP(NLV-1)))
      else
      VDTEM(I,NLV) = vdtem(i,nlv) + val*
     *    (-GAMMA(NLV-1)*VKDIFF(NLV-1)*(TG(I,NLV)-TG(I,NLV-1)))
      endif
C
 200  CONTINUE
C
      RETURN
      END
