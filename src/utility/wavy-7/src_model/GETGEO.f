      SUBROUTINE GETGEO(A,B,C,KLEV)
C...    ADDS IN SOME OF THE LINEAR TERMS IN THE EQUATIONS OF MOTION
      save
      include "pimax"
      include "pjmax"
      include "pkmax"
      include "ptrunk"
      include "comcom"
      include "comphc"
      include "comnum"
      PARAMETER( NBIG = 5*MNWV2 )
      DIMENSION   A(NBIG,NBIG), B(NBIG,NBIG), C(NBIG,NBIG)
      KT = 2*MNWV2
      KH = 3*MNWV2
      KM1 = KLEV-1
C
C...   HYDROSTATIC EQUATION
C
      IF(KLEV.EQ.1) THEN
      DO 10 I=1,MNWV2
      B(KH+I,KH+I) = ONE
  10  CONTINUE
      RETURN
      ENDIF
C
      DO 20 I=1,MNWV2
      A(KH+I,KT+I) = ONE+(CP/(TWO*GASR))*(ONE-RPI(KM1))
      B(KH+I,KT+I) = -ONE-(CP/(TWO*GASR))*(ONE-ONE/RPI(KM1))
      A(KH+I,KH+I) = Si(KM1)/DEL(KM1)
      B(KH+I,KH+I) = -Si(KLEV)*(ONE/DEL(KLEV)+ONE/DEL(KM1))
  20  CONTINUE
C
      IF(KLEV.LT.KMAX) THEN
      do 30 i=1,mnwv2
      C(KH+I,KH+I) = Si(KLEV+1)/DEL(KLEV)
  30  continue
      ENDIF
C
      RETURN
      END
