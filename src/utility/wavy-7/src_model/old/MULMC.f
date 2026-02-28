      SUBROUTINE MULMC(A, B, C, N, NW, CON)
      DIMENSION  A(N,N),B(N,N),C(N,N)
      DATA I0/0/
      II = N
      J0 = 0
      JJ = 2*NW
      K0 = 0
      KK = 2*NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      J0 = 2*NW
      JJ = NW
      K0 = 2*NW
      KK = NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      K0 = NW
      J0 = 3*NW
      JJ = NW
      CALL MTDM (A, B, C, N, I0, II, J0, JJ, K0, CON)
      K0 = 3*NW
      J0 = 3*NW
      JJ = NW
      CALL MTDM (A, B, C, N, I0, II, J0, JJ, K0, CON)
      RETURN
      END
