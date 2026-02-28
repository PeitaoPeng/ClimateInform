      SUBROUTINE FILL(A,B,N)
      DIMENSION A(N),B(N)
      DO 10 I=1,N
      B(I) = A(I)
  10  CONTINUE
      RETURN
      END
