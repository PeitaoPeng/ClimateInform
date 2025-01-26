      SUBROUTINE GETBS(N,QLNP,QTMP,QDIV,QROT,TSA,qq,LA0,
     1   MNWV0)
C    1   MNWV0,KMAX,MEND1,NEND1,jend1)
C
      save
      include "comnum"
      include "comphc"
      include "ptrunk"
      include "pkmax"
      DIMENSION QLNP(2,MNWV0),TSA(2,MNWV0),
     1      QTMP(2,MNWV0,KMAX),QDIV(2,MNWV0,KMAX),QROT(2,MNWV0,KMAX),
     |      qq(2,mnwv0)
      DIMENSION LA0(MEND1,NEND1),idate(4)
      COMMON / TGLB / TGLOB(KMAX)
      LOGICAL INREAD,izsm,lvbar
      DATA INREAD/.true./,izsm/.false./,lvbar/.true./
c     DATA INREAD/.true./,izsm/.true./,lvbar/.true./
      DATA T0/280.0E0/, U0/10.0E0/, P0/1.0E2/
C...
C  READ IN BASIC STATE FROM EXTERNAL FILE
c   format is assumed to be same as model output data format
c   (e.g. same as format expected by postprocessing)
C
      IF(INREAD) THEN
       nharm = 2*mnwv0
c      read(n) thour,idate
c      write(6,*) ' input data label thour =',thour,' idate = ',idate
       call rdfld(n,qlnp,nharm)
       call transp(qlnp,nharm,mend1,nend1,jend1,1,la0,qq,-1)
       if(izsm) call znlsym(qlnp,mend1,nend1)
       DO 400 K=1, KMAX
       call rdfld(n,qdiv(1,1,k),nharm)
       call transp(qdiv(1,1,k),nharm,mend1,nend1,jend1,1,la0,qq,-1)
       if(izsm) call znlsym(qdiv(1,1,k),mend1,nend1)
       if(izsm.and..not.lvbar) then
       do 351 jj=1,mnwv0
       do 351 ii=1,2
       qdiv(ii,jj,k) = 0.0
 351   continue
       endif
 400   CONTINUE
       DO 401 K=1, KMAX
       call rdfld(n,qrot(1,1,k),nharm)
       call transp(qrot(1,1,k),nharm,mend1,nend1,jend1,1,la0,qq,-1)
       if(izsm) call znlsym(qrot(1,1,k),mend1,nend1)
 401   CONTINUE
       do 402 k=1,kmax
       call rdfld(n,qq,nharm)
 402   continue
       DO 403 K=1, KMAX
       call rdfld(n,qtmp(1,1,k),nharm)
       call transp(qtmp(1,1,k),nharm,mend1,nend1,jend1,1,la0,qq,-1)
       if(izsm) call znlsym(qtmp(1,1,k),mend1,nend1)
 403   CONTINUE
C......tsa: sfc t anomaly
       call rdfld(n,TSA,nharm)
       call transp(TSA,nharm,mend1,nend1,jend1,1,la0,qq,-1)
C      if(izsm) call znlsym(tsa,mend1,nend1)
       WRITE(6,*) ' BASIC STATE READ IN FROM UNIT ',N
       if(izsm) write(6,*) '   zonally symmetric basic state '
       if(izsm.and..not.lvbar) write(6,*) ' nondivergent zsbs '
C...
C  OTHERWISE SPECIFY THE BASIC STATE
C   THIS SECTION IS FOR SOLID BODY ROTATION
C
      ELSE
       CALL RESET( QROT,2*MNWV0*(3*KMAX+1) )
C        TEMPERATURE
       DO 501 K=1,KMAX
       QTMP(1,LA0(1,1),K) = T0*SQRT(TWO)
 501   CONTINUE
C        VORTICITY
       Z0 = TWO*U0/ER  * SQRT(TWO/THREE)
       DO 502 K=1,KMAX
       QROT(1,LA0(1,2),K) = Z0
 502   CONTINUE
C        LOG SURFACE PRESSURE (CENTIBARS, NO TOPOGRAPHY)
       q0 = log(p0)
       Q1 = (ER/(FOUR*GASR*T0))*(TWOMG+U0/ER)*U0
       QLNP(1,LA0(1,1)) = SQRT(TWO)*( Q0 + Q1/THREE )
       QLNP(1,LA0(1,3)) = -(FOUR*SQRT(TWO)/(THREE*SQRT(FIVE)))*Q1
C
       WRITE(6,*) ' BASIC STATE CALCULATED INTERNALLY '
       WRITE(6,*) '  SOLID BODY ROTATION BASIC STATE '
      ENDIF
C
      DO 505 K=1,KMAX
      TGLOB(K) = QTMP(1,1,K)/SQRT(2.)
 505  CONTINUE
      write(6,*) 'TGLOB=',TGLOB
      RETURN
      END
