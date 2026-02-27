      SUBROUTINE IMINV (A,N,D,L,M)
C
      save
      include "comnum"
      DIMENSION A(1),L(1),M(1)
C
C        SEARCH FOR LARGEST ELEMENT
C
CVD$R NOVECTOR
      D=ONE
      NK=-N
      DO 80 K=1,N
      NK=NK+N
      L(K)=K
      M(K)=K
      KK=NK+K
      BIGA=A(KK)
      DO 20 J=K,N
      IZ=N*(J-1)
      DO 20 I=K,N
      IJ=IZ+I
C  10 IF( ABS (BIGA)- ABS (A(IJ))) 15,20,20
   10 NABS=ABS (BIGA)-ABS (A(IJ))
      IF( NABS.lt.0) go to 15
      IF( NABS.ge.0) go to 20
   15 BIGA=A(IJ)
      L(K)=I
      M(K)=J
   20 CONTINUE
C
C        INTERCHANGE ROWS
C
      J=L(K)
C     IF(J-K) 35,35,25
      JMK=J-K
      IF(JMK.le.0) go to 35
      IF(JMK.gt.0) go to 25
   25 KI=K-N
      DO 30 I=1,N
      KI=KI+N
      HOLD=-A(KI)
      JI=KI-K+J
      A(KI)=A(JI)
   30 A(JI) =HOLD
C
C        INTERCHANGE COLUMNS
C
   35 I=M(K)
C     IF(I-K) 45,45,38
      IMK=I-K
      IF(IMK.le.0) go to 45
      IF(IMK.gt.0) go to 38
   38 JP=N*(I-1)
      DO 40 J=1,N
      JK=NK+J
      JI=JP+J
      HOLD=-A(JK)
      A(JK)=A(JI)
   40 A(JI) =HOLD
C
C        DIVIDE COLUMN BY MINUS PIVOT (VALUE OF PIVOT ELEMENT IS
C        CONTAINED IN BIGA)
C
C  45 IF(BIGA) 48,46,48
   45 IF(BIGA.lt.0) go to 48
      IF(BIGA.eq.0) go to 46
      IF(BIGA.gt.0) go to 48
   46 D=ZERO
      RETURN
   48 DO 55 I=1,N
C     IF(I-K) 50,55,50
      IMK=I-K
      IF(IMK.lt.0) go to 50
      IF(IMK.eq.0) go to 55
      IF(IMK.gt.0) go to 50
   50 IK=NK+I
      A(IK)=A(IK)/(-BIGA)
   55 CONTINUE
C
C        REDUCE MATRIX
C
      DO 65 I=1,N
      IK=NK+I
      IJ=I-N
      DO 65 J=1,N
      IJ=IJ+N
C     IF(I-K) 60,65,60
      IMK=I-K
      IF(IMK.lt.0) go to 60
      IF(IMK.eq.0) go to 65
      IF(IMK.gt.0) go to 60
C  60 IF(J-K) 62,65,62
   60 JMK=J-K
      IF(JMK.lt.0) go to 62
      IF(JMK.eq.0) go to 65
      IF(JMK.gt.0) go to 62
   62 KJ=IJ-I+K
      A(IJ)=A(IK)*A(KJ)+A(IJ)
   65 CONTINUE
C
C        DIVIDE ROW BY PIVOT
C
      KJ=K-N
      DO 75 J=1,N
      KJ=KJ+N
C     IF(J-K) 70,75,70
      JMK=J-K
      IF(JMK.lt.0) go to 70
      IF(JMK.eq.0) go to 75
      IF(JMK.gt.0) go to 70
   70 A(KJ)=A(KJ)/BIGA
   75 CONTINUE
C
C        PRODUCT OF PIVOTS
C
      D=D*BIGA
C
C        REPLACE PIVOT BY RECIPROCAL
C
      A(KK)=ONE/BIGA
   80 CONTINUE
C
C        FINAL ROW AND COLUMN INTERCHANGE
C
      K=N
  100 K=(K-1)
C     IF(K) 150,150,105
      IF(K.le.0) go to 150
      IF(K.gt.0) go to 105
  105 I=L(K)
C     IF(I-K) 120,120,108
      IMK=I-K
      IF(IMK.le.0) go to 120
      IF(IMK.gt.0) go to 108
  108 JQ=N*(K-1)
      JR=N*(I-1)
      DO 110 J=1,N
      JK=JQ+J
      HOLD=A(JK)
      JI=JR+J
      A(JK)=-A(JI)
  110 A(JI) =HOLD
  120 J=M(K)
C     IF(J-K) 100,100,125
      JMK=J-K
      IF(JMK.le.0) go to 100
      IF(JMK.gt.0) go to 125
  125 KI=K-N
      DO 130 I=1,N
      KI=KI+N
      HOLD=A(KI)
      JI=KI-K+J
      A(KI)=-A(JI)
  130 A(JI) =HOLD
      GO TO 100
  150 RETURN
      END
