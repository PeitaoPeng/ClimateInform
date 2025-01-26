      SUBROUTINE RESET (DATA,N)
      include "comnum"
      DIMENSION DATA(N)
      DO 100 I=1,N
      DATA(I)=ZERO
  100 CONTINUE
      RETURN
      END
