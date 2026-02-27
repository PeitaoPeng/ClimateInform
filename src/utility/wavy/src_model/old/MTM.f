      SUBROUTINE MTM(A,B,C,N,I0,IINT,J0,JINT,K0,KINT,CON)
      DIMENSION  A(N,N),B(N,N),C(N,N)
       DO 1 I=I0+1,I0+IINT
       DO 1 J=J0+1,J0+JINT
       DO 1 K=K0+1,K0+KINT
        C(I,J) = C(I,J) + CON * A(I,K) * B(K,J)
    1  CONTINUE
      RETURN
      END
