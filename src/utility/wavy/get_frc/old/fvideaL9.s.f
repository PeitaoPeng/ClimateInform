CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC C
C     set idealized heating field  
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE fvidea(WORK15)  
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER(NLV=10)
      PARAMETER(NW=15)
      PARAMETER(NLEG=NW+1)
      PARAMETER(NM=NW)
      PARAMETER(NMP=NW+1)
      PARAMETER(NLONG=64)
      PARAMETER(NLATG=40)
CC
      COMMON/GAUSS/RADG(NLATG),GWGT(NLATG)
      DIMENSION FIELDG(NLONG,NLATG),out(NLONG,NLATG)
      DIMENSION OLRFRC(NLONG,NLATG)
      DIMENSION FLDSPC(2,NLEG,NMP)
      real      FLDSIN(2,NLEG,NMP),PROF(NLV)
      real      WORK15(2,NLEG,NMP,NLV)
C
C.....hpres: prescribed idealized heating
C.....have heating profile
      CALL FVPROFILE(PROF)
C
c=== for having RADG
      CALL TRNSFM15(FIELDG,FLDSPC)
      do 50 i=1,nlong
      do 50 j=1,nlatg
      OLRFRC(i,j)=0.
  50  CONTINUE
      call IDEAFV(OLRFRC,210.,13., 5.)
      do 1000 LL = 1,NLV
      do 100 i=1,nlong
      do 100 j=1,nlatg
      FIELDG(i,j)=PROF(LL)*OLRFRC(i,j)
  100 CONTINUE
      CALL TRNSFM15(FIELDG,FLDSPC)
        do 60 j=1,NLEG
        do 60 i=1,NMP 
        WORK15(1,i,j,LL)=FLDSPC(1,j,i)
        WORK15(2,i,j,LL)=FLDSPC(2,j,i)
 60     continue
      IWRITE=IWRITE+1
      write(6,*) 'IWRITE=',IWRITE
 1000 CONTINUE
C
 
      RETURN
      END
 
 
 
      SUBROUTINE FVPROFILE(PROF)
      PARAMETER(KMAX=10)
      DIMENSION  DELSIG(KMAX), PROF(KMAX)
      DIMENSION  TPR(KMAX)
C
      DATA DELSIG/10*0.10/
C
      DATA TPR/0.0, 0.18, 0.45, 
     *         1.0, 2.5, 3.3, 3.5,
     *         3.6, 2.0, 0.5/
C.......CALCULATE the nomalized weighting function
      ss=0.
      do 10 k=1,KMAX
      ss=ss+TPR(k)*DELSIG(k)
  10  continue
      do 20 k=1,KMAX
      PROF(k)=TPR(k)/ss
  20  continue
C
      RETURN
      END



      SUBROUTINE IDEAFV(F,XCENT,YCENT,AM)
      parameter(IX=64, IY=40)
      COMMON/GAUSS/RADG(IY),GWGT(IY)
      REAL    F(IX,IY)
      PI=4.*ATAN(1.)
      XWID=10.
      YWID=5.
      unit=1.e-11 
      do 1 I=1,IX
      do 1 J=1,IY
      ALAT=RADG(J)*180./PI
      ALONG=360.*FLOAT(I-1)/FLOAT(IX)
      XX=(ALONG-XCENT)/XWID
      YY=(ALAT-YCENT)/YWID
        X=-XX**2-YY**2
        F(I,J)=AM*unit*EXP(X)
   1  CONTINUE
      RETURN
      END

