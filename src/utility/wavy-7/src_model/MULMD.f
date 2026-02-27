      SUBROUTINE MULMD(A, B, C, N, NW, CON)
      DIMENSION  A(N,N),B(N,N),C(N,N)
      DATA I0/0/
      II = N
      J0 = 4*NW
      JJ = NW
      K0 = 0
      KK = 2*NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      J0 = 4*NW
      JJ = NW
      K0 = 4*NW
      KK = NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      K0 = 2*NW
      KK = NW
      J0 = 4*NW
      JJ = NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      RETURN
      END
