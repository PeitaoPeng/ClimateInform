***********************************************************
      SUBROUTINE TRANSF(N,M,F,AVF,DF,KS)
      DIMENSION F(N,M),AVF(N),DF(N)
      DO 5 I=1,N
      AVF(I)=0.0
 5    DF(I)=0.0
c     IF(KS)  30,10,10
      IF (KS.lt.0) go to 30
      IF (KS.eq.0) go to 10
      IF (KS.gt.0) go to 10
 10   DO 14 I=1,N
      DO 12 J=1,M
 12   AVF(I)=AVF(I)+F(I,J)
      AVF(I)=AVF(I)/M
      DO 14 J=1,M
      F(I,J)=F(I,J)-AVF(I)
 14   CONTINUE
      IF(KS.EQ.0)  THEN
      RETURN
      ELSE
      DO 24 I=1,N
      DO 22 J=1,M
 22   DF(I)=DF(I)+F(I,J)*F(I,J)
      DF(I)=SQRT(DF(I)/M)
      DO 24 J=1,M
      F(I,J)=F(I,J)/DF(I)
 24   CONTINUE
      ENDIF
 30   CONTINUE
      RETURN
      END
***********************************************************
**                                                       **
***********************************************************
      SUBROUTINE FORMA(N,M,MNH,F,A)
      DIMENSION F(N,M),A(MNH,MNH)
c     IF(M-N) 40,50,50
      LMN=M-N
      IF (LMN.lt.0) go to 40
      IF (LMN.eq.0) go to 50
      IF (LMN.gt.0) go to 50
 40   DO 44 I=1,MNH
      DO 44 J=1,MNH
      A(I,J)=0.0
      DO 42 IS=1,N
 42   A(I,J)=A(I,J)+F(IS,I)*F(IS,J)
      A(J,I)=A(I,J)
 44   CONTINUE
      write(6,*) I,J
      RETURN
 50   DO 54 I=1,MNH
      DO 54 J=1,MNH
      A(I,J)=0.0
      DO 52 JS=1,M
 52   A(I,J)=A(I,J)+F(I,JS)*F(J,JS)
      A(J,I)=A(I,J)
      write(6,*) I,J
 54   CONTINUE
      RETURN
      END
**********************************************************
**                                                      **
**********************************************************
      SUBROUTINE JCB(N,A,S,EPS)
      DIMENSION A(N,N),S(N,N)
      DO 30 I=1,N
      DO 30 J=1,I
c     IF(I-J)  20,10,20
      LIJ=I-J
      IF (LIJ.lt.0) go to 20
      IF (LIJ.eq.0) go to 10
      IF (LIJ.gt.0) go to 20
 10   S(I,J)=1.
      GO TO 30
 20   S(I,J)=0.0
      S(J,I)=0.0
 30   CONTINUE
      G=0.
      DO 40 I=2,N
      I1=I-1
      DO 40 J=1,I1
 40   G=G+2.*A(I,J)*A(I,J)
      S1=SQRT(G)
      S2=EPS/FLOAT(N)*S1
      S3=S1
      L=0
 50   S3=S3/FLOAT(N)
 60   DO 130 IQ=2,N
      IQ1=IQ-1
      DO 130 IP=1,IQ1
      IF(ABS(A(IP,IQ)).LT.S3) GO TO 130
      L=1
      V1=A(IP,IP)
      V2=A(IP,IQ)
      V3=A(IQ,IQ)
      U=0.5*(V1-V3)
      IF(U.EQ.0.0)G=1.
      IF(ABS(U).GE.1E-10)G=-SIGN(1.,U)*V2/SQRT(V2*V2+U*U)
      ST=G/SQRT(2.*(1.+SQRT(1.-G*G)))
      CT=SQRT(1.-ST*ST)
      DO 110 I=1,N
      G=A(I,IP)*CT-A(I,IQ)*ST
      A(I,IQ)=A(I,IP)*ST+A(I,IQ)*CT
      A(I,IP)=G
      G=S(I,IP)*CT-S(I,IQ)*ST
      S(I,IQ)=S(I,IP)*ST+S(I,IQ)*CT
 110  S(I,IP)=G
      DO 120 I=1,N
      A(IP,I)=A(I,IP)
 120  A(IQ,I)=A(I,IQ)
      G=2.*V2*ST*CT
      A(IP,IP)=V1*CT*CT+V3*ST*ST-G
      A(IQ,IQ)=V1*ST*ST+V3*CT*CT+G
      A(IP,IQ)=(V1-V3)*ST*CT+V2*(CT*CT-ST*ST)
      A(IQ,IP)=A(IP,IQ)
 130  CONTINUE
c     IF(L-1)  150,140,150
      LL=L-1
      IF (LL.lt.0) go to 150
      IF (LL.eq.0) go to 140
      IF (LL.gt.0) go to 150
 140  L=0
      GO TO 60
 150  IF(S3.GT.S2) GO TO 50
      RETURN
      END
****************************************************************
**                                                            **
****************************************************************
      SUBROUTINE ARRANG(KV,MNH,A,ER,S)
      DIMENSION A(MNH,MNH),ER(KV,4),S(MNH,MNH)
      TR=0.0
      DO 200 I=1,MNH
*      write(6,*) I
      TR=TR+A(I,I)
 200  ER(I,1)=A(I,I)
      write(6,*) I,MNH
      MNH1=MNH-1
      write(6,*) MNH1
      DO 210 K1=MNH1,1,-1
      DO 210 K2=K1,MNH1
*      write(6,*) k1,k2
      IF(ER(K2,1).LT.ER(K2+1,1)) THEN
      C=ER(K2+1,1)
      ER(K2+1,1)=ER(K2,1)
      ER(K2,1)=C
      DO 205 I=1,MNH
      C=S(I,K2+1)
      S(I,K2+1)=S(I,K2)
      S(I,K2)=C
 205  CONTINUE
      END IF
 210  CONTINUE
      write(6,*) 1.2
      ER(1,2)=ER(1,1)
      DO 220 I=2,KV
      ER(I,2)=ER(I-1,2)+ER(I,1)
 220  CONTINUE
      DO 230 I=1,KV
      ER(I,3)=ER(I,1)/TR
      ER(I,4)=ER(I,2)/TR
 230  CONTINUE
      WRITE(16,222)
      WRITE(6,222)
C222  FORMAT(1X,'This is the results of EOF to wind field(u-component)')
C222  FORMAT(1X,'This is the results of EOF to wind field(v-component)')
 222  FORMAT(1X,'This is the results of EOF to ssta field.')
      WRITE(16,250) TR
 250  FORMAT(//2X,'The total square error is',F15.5,'.'/)
      RETURN
      END
***********************************************************
**                                                       **
***********************************************************
      SUBROUTINE TCOEFF(KVT,KV,N,M,MNH,S,F,V,ER)
      DIMENSION S(MNH,MNH),F(N,M),V(MNH),ER(KV,4)
      DO 360 J=1,KVT
      C=0.0
      DO 350 I=1,MNH
 350  C=C+S(I,J)*S(I,J)
      C=SQRT(C)
      DO 160 I=1,MNH
 160  S(I,J)=S(I,J)/C
 360  CONTINUE
      IF(N.LE.M) THEN
      DO 390 J=1,M
      DO 370 I=1,N
      V(I)=F(I,J)
      F(I,J)=0.0
 370  CONTINUE
      DO 380 IS=1,KVT
      DO 380 I=1,N
 380  F(IS,J)=F(IS,J)+V(I)*S(I,IS)
 390  CONTINUE
      ELSE
      DO 410 I=1,N
      DO 400 J=1,M
      V(J)=F(I,J)
      F(I,J)=0.0
 400  CONTINUE
      DO 410 JS=1,KVT
      DO 410 J=1,M
      F(I,JS)=F(I,JS)+V(J)*S(J,JS)
 410  CONTINUE
      DO 430 JS=1,KVT
      DO 420 J=1,M
      S(J,JS)=S(J,JS)*SQRT(ER(JS,1))
 420  CONTINUE
      DO 430 I=1,N
      F(I,JS)=F(I,JS)/SQRT(ER(JS,1))
 430  CONTINUE
      END IF
      RETURN
      END
**************************************************************
**                                                          **
**************************************************************
      SUBROUTINE OUTER(KV,ER)
      DIMENSION ER(KV,4)
      WRITE(16,510)
 510  FORMAT(/02X,'Here are the eigenvalues and analysis errors:'//)
      WRITE(16,520)
 520  FORMAT(/10X,1Hn,8X,5Hlamda,8X,6Hlamdas,12X,5Hratio,10X,6Hratios)
      WRITE(16,530)(IS,(ER(IS,J),J=1,4),IS=1,KV)
 530  FORMAT(1X,I10,4F15.5)
      WRITE(16,540)
 540  FORMAT(//)
      RETURN
      END
****************************************************************
**                                                            **
****************************************************************
      SUBROUTINE OUTVT(KVT,N,M,MNH,S,F)
      DIMENSION F(N,M),S(MNH,MNH)
      WRITE(16,560)
 560  FORMAT(02X,'The following are the standard eigenvectors:',//)
      WRITE(16,570)(IS,IS=1,KVT)
 570  FORMAT(15X,5I12)
      DO 550 I=1,N
      IF(M.GE.N) THEN
      WRITE(16,580) I,(S(I,JS),JS=1,KVT)
c     WRITE(40,580) I,(S(I,JS),JS=1,KVT)
 580  FORMAT(13X,I4,5F12.4)
      ELSE
c      WRITE(16,590) I,(F(I,JS),JS=1,KVT)
 590  FORMAT(13X,I4,5F12.4)
      END IF
 550  CONTINUE
      WRITE(16,720)
 720  FORMAT(//)
      WRITE(16,610)
c610  FORMAT(02X,'Here are the time-coefficent series to its wind field
c    *s(u850-component):'/)
 610  FORMAT(02X,'Here are the time-coefficent series to its ssta. field
     *s:'/)
      WRITE(16,620)(IS,IS=1,KVT)
 620  FORMAT(15X,5I12)
      DO 600 J=1,M
      IF(M.GE.N)THEN
      WRITE(16,630)J,(F(IS,J),IS=1,KVT)
c     WRITE(50,630)J,(F(IS,J),IS=1,KVT)
 630  FORMAT(13X,I3,5F12.1)
      ELSE
      WRITE(16,640)J,(S(J,IS),IS=1,KVT)
 640  FORMAT(13X,I3,5F12.3)
      END IF
 600  CONTINUE
      RETURN
      END
