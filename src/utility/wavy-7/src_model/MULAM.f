      SUBROUTINE MULAM(A, B, C, N, NW, CON)
      DIMENSION A(N,N),B(N,N),C(N,N)
      DATA J0/0/
      JJ = N
      I0 = 0
      II = 2*NW
      K0 = 0
      KK = 2*NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON )
      I0 = 2*NW
      II = NW
      K0 = 2*NW
      KK = NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON )
      I0 = 0
      II = 3*NW
      K0 = 4*NW
      KK = NW
      CALL MTM (A, B, C, N, I0, II, J0, JJ, K0, KK, CON )
      I0 = 3*NW
      II = NW
      K0 = 2*NW
      CALL DMTM (A, B, C, N, I0, II, J0, JJ, K0, CON )
      I0 = 3*NW
      II = NW
      K0 = 3*NW
      CALL DMTM (A, B, C, N, I0, II, J0, JJ, K0, CON )
      I0 = 4*NW
      II = NW
      K0 = 4*NW
      CALL DMTM (A, B, C, N, I0, II, J0, JJ, K0, CON )
      RETURN
      END
