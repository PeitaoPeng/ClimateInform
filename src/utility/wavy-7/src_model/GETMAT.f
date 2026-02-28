      SUBROUTINE GETMAT(A,B,C,D,FRC,KLEV)
      save
      include "ptrunk"
      PARAMETER(MNWV2=JEND1*(JEND1+1)-(JEND1-NEND1)*(JEND1-NEND1+1)
     |               -(JEND1-MEND1)*(JEND1-MEND1+1))
      include "pkmax"
      PARAMETER( NBIG = 5*MNWV2 )
      DIMENSION   A(NBIG,NBIG), B(NBIG,NBIG), C(NBIG,NBIG),
     |                D(NBIG,NBIG), FRC(NBIG)
      DIMENSION VEC(NBIG,4)
      dimension frcsv(mnwv2,kmax)
      LOGICAL INTDAT,savfrc
      DATA INTDAT/.false./,nfrc/39/,savfrc/.false./,nfsav/38/
c     open(unit=38,form='unformated',recl=mnwv2*kmax)
C
C .....OBTAIN MATRIX COLUMNS
C
      write(6,*)'get into GETMAT'
      DO 10 NVAR=1,5
      DO 10 NPOS=1,MNWV2
      CALL COMINT ( NVAR, NPOS, VEC, FRC, INTdat,  KLEV )
      nelt=mnwv2*(nvar-1)+npos
      DO 20 I=1,NBIG
      A(i,nelt) = VEC(I,1)
      B(i,nelt) = VEC(I,2)
      C(i,nelt) = VEC(I,3)
      D(i,nelt) = VEC(I,4)
  20  CONTINUE
  10  CONTINUE
      CALL GETGEO(A,B,C,KLEV)
C
C .....OBTAIN FORCING
C
      IF(.NOT.INTDAT) CALL GETFRC(nfrc,FRC,MNWV2,KLEV)
      write(6,*)'getfrc from GETFRC'
c
c   save forcing for zonally symmetric basic state mode
c    (heating only at present) if requested
c
      if(savfrc) then
      do 11 i=1,mnwv2
      frcsv(i,klev) = frc(2*mnwv2+i)
  11  continue
      if(klev.eq.kmax) write(nfsav) frcsv
      endif
C
      RETURN
      END
