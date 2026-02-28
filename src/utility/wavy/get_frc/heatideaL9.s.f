CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC C
C     set idealized heating field  
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE heatidea(WORK15)
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
      DIMENSION WK(NLONG,NLATG),OLRFRC(NLONG,NLATG)
      DIMENSION OLRFRC1(NLONG,NLATG),OLRFRC2(NLONG,NLATG)
      DIMENSION FLDSPC(2,NLEG,NMP)
      real      FLDSIN(2,NLEG,NMP),PROF(NLV)
      real      WORK15(2,NLEG,NMP,NLV)
C
      LOGICAL hpres
      open(unit=60,form='unformatted',access='direct',recl=4*64*40)
C.....hpres: prescribed idealized heating
c     DATA hpres /.true./
      DATA hpres /.false./
C.....have heating profile
      CALL PROFILE2 (PROF)
C.....read in olr or cams/msu heating for nth year      
C.....they are grads data (i.e., from south to north)                   
c     do 10 i=12,12  !i=34 for djfm of 2014
      do 10 i=1,1  !i=1 for past season
      read(60,rec=i) out
  10  continue
      write(6,*) 'out=',WK(32,20),out(32,20)
      do 20 i=1,nlong
      do 20 j=1,nlatg
      out(i,j)=0.25*out(i,j)/86400.
  20  CONTINUE
      do 30 i=1,nlong
      do 30 j=1,nlatg
c     if(j.lt.10.or.j.gt.30) out(i,j)=0.
c     if(j.lt.15.or.j.gt.25) out(i,j)=0>    !24.4S-24.4N
c     if(j.lt.16.or.j.gt.25) out(i,j)=0.    !20S-20N
      if(j.lt.17.or.j.gt.24) out(i,j)=0.    !15S-15N
c     if(i.lt.25) out(i,j)=0.    !110E -> 360
c     if(i.gt.32.and.i.lt.45) then          !remove >0 heating
c     if(out(i,j).gt.0) out(i,j)=0.
c     endif
c     if(j.lt.15.or.j.gt.25) out(i,j)=0.    !25S-25N
c     if(i.lt.25.or.i.gt.49) out(i,j)=0.
c     if(out(i,j).lt.0.0) out(i,j)=0.
c     if(i.lt.28) out(i,j)=0.
c     if(i.lt.15) out(i,j)=0.
  30  CONTINUE
      call norsou(out,OLRFRC,NLONG,NLATG)
C
      IF( hpres ) THEN
c=== for having RADG
      CALL TRNSFM15(FIELDG,FLDSPC)
      do 50 i=1,nlong
      do 50 j=1,nlatg
      OLRFRC1(i,j)=0.
      OLRFRC2(i,j)=0.
  50  CONTINUE
      call IDEADH(OLRFRC1,130., 0.,   -4.)
      call IDEADH(OLRFRC2,190., 0.,   4.)
      do i=1,nlong
      do j=1,nlatg
      OLRFRC(i,j)=OLRFRC1(i,j)+OLRFRC2(i,j)
      enddo
      enddo
      END IF
C
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
 
 
 
      SUBROUTINE PROFILE(PROF)
      PARAMETER(KMAX=10)
      DIMENSION  DELSIG(KMAX), PROF(KMAX)
      DIMENSION  TPR(KMAX)
C
      DATA DELSIG/10*0.1/
C
      DATA TPR/0.2, 0.5, 1.2, 
     *         2.2, 3.0, 3.5,3.8,
     *         3.5, 2.0,  0.5/
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


      SUBROUTINE PROFILE2(PROF)
      PARAMETER(KMAX=10)
      DIMENSION  SL(KMAX), PROF(KMAX)
C
C     DATA SL    /0.95,0.9,0.85,0.785,0.71,0.625,
C    *            0.50,0.30,0.15,0.025/
      DATA SL    /0.95,0.85,0.75,0.65,0.55,0.45,
     *            0.35,0.25,0.15,0.05/
c     DATA SL    /0.940,0.825,0.714,0.604,0.494,0.384,0.274,
c    *            0.163,0.046/
C
C.......CALCULATE the weighting function
      PI=3.14159
      do 10 k=1,KMAX
      PROF(k)=PI*SIN(PI*SL(k))/2.
  10  continue
C
      RETURN
      END


      SUBROUTINE IDEADH(F,XCENT,YCENT,AM)
      parameter(IX=64, IY=40)
      COMMON/GAUSS/RADG(IY),GWGT(IY)
      REAL    F(IX,IY)
      PI=4.*ATAN(1.)
      XWID=10.
      YWID=5.
c     YWID=1.
c     XWID=15.
c     YWID=10.
      unit=1./86400.
      do 1 I=1,IX
      do 1 J=1,IY
      ALAT=RADG(J)*180./PI
      ALONG=360.*FLOAT(I-1)/FLOAT(IX)
      XX=(ALONG-XCENT)/XWID
      YY=(ALAT-YCENT)/YWID
        X=-XX**2-YY**2
        F(I,J)=AM*unit*EXP(X)
c       F(I,J)=AM*EXP(X)
   1  CONTINUE
      RETURN
      END

      SUBROUTINE SHIFTING(FIN,FOT,IX,IY,ISHIFT)
      REAL    FIN(IX,IY),FOT(IX,IY)
      DO J=1,IY
      DO I=1,IX-ISHIFT
        FOT(I+ISHIFT,J)=FIN(I,J)
      ENDDO
      ENDDO

      DO J=1,IY
      DO I=1,ISHIFT
        FOT(I,J)=FIN(IX-ISHIFT+I,J)
      ENDDO
      ENDDO

      RETURN
      END
