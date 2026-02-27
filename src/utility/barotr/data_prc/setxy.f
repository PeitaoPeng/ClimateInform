      SUBROUTINE SETXY(X,NX,Y,NY,XMN,DLX,YMN,DLY)                       00000010
      DIMENSION X(NX),Y(NY)                                             00000020
      DO 10 I = 1,NX                                                    00000030
   10   X(I) = XMN + DLX*FLOAT(I-1)                                     00000040
      IF (NY.EQ.0) RETURN
      DO 20 J = 1,NY                                                    00000050
   20   Y(J) = YMN + DLY*FLOAT(J-1)                                     00000060
      RETURN                                                            00000070
      END                                                               00000080
