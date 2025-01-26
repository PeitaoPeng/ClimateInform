      PROGRAM WAVY
C
C      SOLVE WAVY BASIC STATE STEADY LINEAR EQUATIONS
C
      save
C
C     include "data.h"
C
      include "ptrunk"
      include "pkmax"
      include "pimax"
      include "pjmax"
      PARAMETER(MNWV2=JEND1*(JEND1+1)-(JEND1-NEND1)*(JEND1-NEND1+1) 
     2               -(JEND1-MEND1)*(JEND1-MEND1+1),
     3          MNWV3=MNWV2+2*MEND1,
     4          MNWV0=MNWV2/2,MNWV1=MNWV3/2,IMAXT=IMAX*3/2)
      include "comcon"
      include "comphc"
      PARAMETER( NSAV=10 )
      PARAMETER( NBIG = 5*MNWV2 )
      PARAMETER( NEND2=NEND1+1 )
      DIMENSION   A(NBIG,NBIG), B(NBIG,NBIG), C(NBIG,NBIG),
     |            D(NBIG,NBIG), FRC(NBIG)
      dimension ip(nbig,2)
      dimension bdiag(NBIG),FRCOUT(NBIG,KMAX)
      dimension QWORK(MNWV3,3),VEC(NBIG,4)
      COMMON/COMBIT/TRIGS(IMAXT),SNNP1(MNWV2),IFAX(10),LAB(4),
     |              LA0(MEND1,NEND1),LA1(MEND1,NEND2)
      COMMON / UPSWP / ALPHA(NBIG,NBIG,2), BETA(NBIG,2),
     |                GAMA(NBIG,NBIG,2)
      COMMON / RSLT / SOLN(NBIG,KMAX)
      COMMON/BSCST/           QZEBAR(MNWV2,KMAX), QDIBAR(MNWV2,KMAX),
     1   QTMBAR(MNWV2,KMAX),  QPSBAR(MNWV2), QUBAR(MNWV3,KMAX),
     2   QVBAR(MNWV3,KMAX),   QPHBAR(MNWV3), QPLBAR(MNWV2)
      COMMON/TSFCA/ TSA(MNWV2)
      COMMON/COMSCL/ZEVAL,DIVAL,TVAL
      real      work(NBIG,NBIG),INDX(NBIG)
C==========================================================
      LOGICAL READMAT,INTFRC
c
c     open(unit=49,form='unformatted',recl=4*NBIG*NBIG)
c     open(unit=50,form='unformatted',recl=4*NBIG*NBIG)
c     open(unit=49,form='unformatted',status='old')
c     open(unit=50,form='unformatted',status='old')
      open(unit=18,form='unformatted',recl=4*MNWV2) !basic state
      open(unit=28,form='unformatted',recl=4*MNWV2) !OBS or GCM anom
      open(unit=39,form='unformatted',recl=4*NBIG)  !frc
      open(unit=49,form='unformatted')
      open(unit=50,form='unformatted')
c
c     DATA READMAT/.true./,INTFRC/.false./,ISAVMAT/49/,      
      DATA INTFRC/.false./,ISAVMAT/49/,      
     |     ISAVMAT2/50/
     |     nfrc/39/
C==========================================================
C     INITIALIZE
      N2  = NBIG
      NSOL= NBIG*KMAX
      CALL ACOFIL(ALPHA,N2*N2,0.0)
      CALL ACOFIL(GAMA ,N2*N2,0.0)
      CALL ACOFIL(BETA ,N2 ,0.0)
C
C     FIRST LEVEL
C
      KLEV = 1
      write(6,*) ' level ',klev
      ICUR = 1
      IPREV = 2
C
      if(.not.READMAT) then
        CALL GETMAT(A,B,C,D,FRC,KLEV)
	write(ISAVMAT) A,B,C,D
      else
C========================================================
C.......read in basic state
         L=0
	 DO 1 NN=1,NEND1
	 IF(NN.LE.JEND1-MEND1+1) THEN
	 MMAX=MEND1
	 ELSE
         MMAX=JEND1-NN+1
	 END IF
	 DO 1 MM=1,MMAX
	 L=L+1
          LA0(MM,NN)=L
  1   CONTINUE
      call GETBS(NFIN0,QPSBAR,QTMBAR,QDIBAR,QZEBAR,TSA,
     |             qwork,LA0,MNWV0)
C.......calculate COMSCL
        ZEVAL = TWOMG
	DIVAL = TWOMG
	TVAL  = TWOMG**2 * ER**2 / GASR
C=========================================================   
	read(ISAVMAT) A,B,C,D
	if(.NOT.INTFRC) then
	call GETFRC(nfrc,FRC,MNWV2,KLEV)
	else
	rewind (NFIN0)
	call COMINT ( 1, 1, VEC, FRC, INTFRC,  KLEV )
	endif
      endif
C
      call FILL(FRC,FRCOUT(1,KLEV),N2)
      call tstzer(b,n2)
C     call linrg(nbig,b,nbig,alpha(1,1,iprev),nbig)
      do i=1,nbig
        do j=1,nbig
          alpha(i,j,iprev)=0.0
          work(i,j)=b(i,j)
        end do
        alpha(i,i,iprev)=1.
c       write(6,*) 'a,b,c&d=',a(i,i),b(i,i),c(i,i),d(i,i)
      end do
      CALL LUDCMP(work, nbig, nbig, INDX, DOUT)
      do j=1,nbig
        call LUBKSB(work, nbig, nbig, INDX, alpha(1,j,iprev))
      end do
C
      CALL MULMc(ALPHA(1,1,IPREV),C,ALPHA(1,1,ICUR),N2,MNWV2,-1.)
      CALL MTV(ALPHA(1,1,IPREV),FRC,BETA(1,ICUR),N2,1.)
      CALL MULMD(ALPHA(1,1,IPREV),D,GAMA(1,1,ICUR),N2,MNWV2,-1.)
      CALL SAVABG(NSAV,ALPHA(1,1,ICUR),BETA(1,ICUR),
     |       GAMA(1,1,ICUR),N2,KLEV)
C
C     LEVELS 2 TO KMAX-2
C
      DO 1000 KLEV = 2, KMAX-1
      write(6,*) ' level ',klev
      IF(ICUR.EQ.1) THEN
       ICUR = 2
       IPREV = 1
        ELSE
       ICUR = 1
       IPREV = 2
      ENDIF
C
      if(.not.READMAT) then
        CALL GETMAT(A,B,C,D,FRC,KLEV)
        if(KLEV.le.5) then
        write(ISAVMAT) A,B,C,D
        else
        write(ISAVMAT2) A,B,C,D
        endif
      else
        if(KLEV.le.5) then
        read(ISAVMAT) A,B,C,D
        else
        read(ISAVMAT2) A,B,C,D
        end if
	if(.NOT.INTFRC) then
	call GETFRC(nfrc,FRC,MNWV2,KLEV)
	else
	call COMINT ( 1, 1, VEC, FRC, INTFRC,  KLEV )
	endif
      endif
C
      call FILL(FRC,FRCOUT(1,KLEV),N2)
      call tstzer(b,n2)
      CALL FILL (B,ALPHA(1,1,ICUR),N2*N2)
      CALL FILL (FRC,BETA(1,ICUR) ,N2 )
      CALL MULAM(A,ALPHA(1,1,IPREV),ALPHA(1,1,ICUR),N2,MNWV2,1.0)
C     call linrg(nbig,alpha(1,1,icur),nbig,alpha(1,1,iprev),nbig)
      do i=1,nbig
        do j=1,nbig
          alpha(i,j,iprev)=0.0
          work(i,j)=alpha(i,j,icur)
        end do
        alpha(i,i,iprev)=1.
c       write(6,*) 'a,b,c&d=',a(i,i),b(i,i),c(i,i),d(i,i)
      end do
      CALL LUDCMP(work, nbig, nbig, INDX, DOUT)
      do j=1,nbig
        call LUBKSB(work, nbig, nbig, INDX, alpha(1,j,iprev))
      end do
C
      CALL MTV(A,BETA(1,IPREV),BETA(1,ICUR),N2,-1.)
      CALL ACOFIL(BETA(1,IPREV),N2,0.0)
      CALL MTV(ALPHA(1,1,IPREV),BETA(1,ICUR),BETA(1,IPREV),N2,1.)
      CALL FILL (BETA(1,IPREV),BETA(1,ICUR),N2)
C
      IF(KLEV.LT.KMAX-1) THEN
       CALL FILL (D,ALPHA(1,1,ICUR),N2*N2)
       CALL MULAM(A,GAMA(1,1,IPREV),ALPHA(1,1,ICUR),N2,MNWV2,1.0)
       CALL ACOFIL(GAMA(1,1,ICUR),N2*N2,0.0)
       CALL MTM(ALPHA(1,1,IPREV),ALPHA(1,1,ICUR),GAMA(1,1,ICUR),
     |    N2,0,N2,0,N2,0,N2,-1.)
       CALL ACOFIL(ALPHA(1,1,ICUR),N2*N2,0.0)
       CALL MULMC(ALPHA(1,1,IPREV),C,ALPHA(1,1,ICUR),N2,MNWV2,-1.0)
       CALL SAVABG(NSAV,ALPHA(1,1,ICUR),BETA(1,ICUR),
     |    GAMA(1,1,ICUR),N2,KLEV)
      ENDIF
C
      IF(KLEV.EQ.KMAX-1) THEN
       CALL FILL (C,GAMA(1,1,ICUR),N2*N2)
       CALL MULAM(A,GAMA(1,1,IPREV),GAMA(1,1,ICUR),N2,MNWV2,1.0)
       CALL ACOFIL(ALPHA(1,1,ICUR),N2*N2,0.0)
       CALL MTM(ALPHA(1,1,IPREV),GAMA(1,1,ICUR),ALPHA(1,1,ICUR),
     |    N2,0,N2,0,N2,0,N2,-1.)
      ENDIF
C
 1000 CONTINUE
C
C     TOP LEVEL
C
      KLEV = KMAX
      write(6,*) ' level ',klev
      IF(ICUR.EQ.1) THEN
       ICUR = 2
       IPREV = 1
        ELSE
       ICUR = 1
       IPREV = 2
      ENDIF
C
      if(.not.READMAT) then
        CALL GETMAT(A,B,C,D,FRC,KLEV)
	write(ISAVMAT2) A,B,C,D
      else
	read(ISAVMAT2) A,B,C,D
	if(.NOT.INTFRC) then
	call GETFRC(nfrc,FRC,MNWV2,KLEV)
	else
	call COMINT ( 1, 1, VEC, FRC, INTFRC,  KLEV )
	endif
      endif
C
      call tstzer(b,n2)
      call FILL(FRC,FRCOUT(1,KLEV),N2)
      CALL FILL (FRC,BETA(1,ICUR),N2)
      CALL MTV(A,BETA(1,IPREV),BETA(1,ICUR),N2,-1.)
      CALL FILL (B,GAMA(1,1,ICUR),N2*N2)
      CALL MULAM(A,ALPHA(1,1,IPREV),GAMA(1,1,ICUR),N2,MNWV2,1.0)
C     call linrg(nbig,gama(1,1,icur),nbig,gama(1,1,iprev),nbig)
      do i=1,nbig
        do j=1,nbig
          gama(i,j,iprev)=0.0
          work(i,j)=gama(i,j,icur)
        end do
        gama(i,i,iprev)=1.
      end do
      CALL LUDCMP(work, nbig, nbig, INDX, DOUT)
      do j=1,nbig
        call LUBKSB(work, nbig, nbig, INDX, gama(1,j,iprev))
      end do
C
C
C     DOWNSWEEP
C     TOP LEVEL
C
      CALL ACOFIL(SOLN(1,KMAX) ,N2,0.0)
      CALL MTV(GAMA(1,1,IPREV),BETA(1,ICUR),SOLN(1,KMAX),N2,1.)
C
C     LEVEL KMAX-1
C
      CALL FILL(BETA(1,IPREV),SOLN(1,KMAX-1),N2)
      CALL MTV(ALPHA(1,1,IPREV),SOLN(1,KMAX),SOLN(1,KMAX-1),N2,1.)
C
C     LEVELS KMAX-2 TO 1
C
      DO 2000 KLEV=KMAX-2,1,-1
      CALL GETABG(NSAV,ALPHA,BETA,GAMA,N2,KLEV)
      CALL FILL(BETA,SOLN(1,KLEV),N2)
      CALL MTV(ALPHA,SOLN(1,KLEV+1),SOLN(1,KLEV),N2,1.)
      CALL MTV(GAMA ,SOLN(1,KMAX)  ,SOLN(1,KLEV),N2,1.)
 2000 CONTINUE
C
      CALL SLNOUT(SOLN,FRCOUT)
C
      STOP
      END
