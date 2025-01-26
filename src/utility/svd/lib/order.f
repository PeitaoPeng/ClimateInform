      SUBROUTINE ORDER(A,KK,N)
      DIMENSION A(N),KK(N)
      DO 100 IDX=2,N
      NN=IDX-1
      DO 90 JDX=1,NN
      KDX=NN-JDX+1
      IF (A(KDX).GT.A(IDX)) GO TO 95
   90 CONTINUE
   95 STORE=A(IDX)
      ISTORE=KK(IDX)
      MDX=IDX
      MM=KDX+1
   80 A(MDX)=A(MDX-1)
      KK(MDX)=KK(MDX-1)
      MDX=MDX-1
      IF (MDX.GT.MM) GO TO 80
      A(MM)=STORE
      KK(MM)=ISTORE
      IF (A(1).GT.STORE) GO TO 100
      A(2)=A(1)
      A(1)=STORE
      KK(2)=KK(1)
      KK(1)=ISTORE
  100 CONTINUE
      RETURN
      END
