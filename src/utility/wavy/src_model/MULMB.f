      SUBROUTINE MULMB(A, B, C, N, NW, CON)
      DIMENSION  A(N,N),B(N,N),C(N,N)
      DATA I0/0/
      II = N
      J0 = 0
      JJ = 3*NW
      K0 = 0
      KK = 3*NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      J0 = 4*NW
      JJ = NW
      K0 = 0
      KK = 3*NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      J0 = 0
      JJ = 2*NW
      K0 = 4*NW
      KK = NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON)
      K0 = NW
      KK = NW
      J0 = 3*NW
      JJ = NW
      CALL MTDM (A, B, C, N, I0, II, J0, JJ, K0, CON)
      K0 = 3*NW
      KK = NW
      J0 = 2*NW
      JJ = NW
      CALL MTDM (A, B, C, N, I0, II, J0, JJ, K0, CON)
      K0 = 3*NW
      KK = 2*NW
      J0 = 3*NW
      JJ = 2*NW
      CALL MTDM (A, B, C, N, I0, II, J0, JJ, K0, CON)
      RETURN
      END
