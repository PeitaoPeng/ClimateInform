      SUBROUTINE GETANOM(N,QLNP,QTMP,QDIV,QROT,qq,LA0,
     1   MNWV0,KMAX,MEND1,NEND1,jend1)
C
      DIMENSION QLNP(2,MNWV0),
     1      QTMP(2,MNWV0,KMAX),QDIV(2,MNWV0,KMAX),QROT(2,MNWV0,KMAX),
     |      qq(2,mnwv0)
      DIMENSION LA0(MEND1,NEND1),idate(4)
C...
C  READ IN GCM ANOMALY FROM EXTERNAL FILE
C
       nharm = 2*mnwv0
       call rdfld(n,qlnp,nharm)
       call transp(qlnp,nharm,mend1,nend1,jend1,1,la0,qq,-1)
       DO 400 K=1, KMAX
       call rdfld(n,qdiv(1,1,k),nharm)
       call transp(qdiv(1,1,k),nharm,mend1,nend1,jend1,1,la0,qq,-1)
 400   CONTINUE
       DO 401 K=1, KMAX
       call rdfld(n,qrot(1,1,k),nharm)
       call transp(qrot(1,1,k),nharm,mend1,nend1,jend1,1,la0,qq,-1)
 401   CONTINUE
       do 402 k=1,kmax
       call rdfld(n,qq,nharm)
 402   continue
       DO 403 K=1, KMAX
       call rdfld(n,qtmp(1,1,k),nharm)
       call transp(qtmp(1,1,k),nharm,mend1,nend1,jend1,1,la0,qq,-1)
 403   CONTINUE
       WRITE(6,*) ' GCM ANOMALY READ IN FROM UNIT ',N
C
      RETURN
      END
