      SUBROUTINE SPLINT(YA,LEX,N)
c
c  This is a program of cubic spline interpolation. The imported
c  series, YA have a length of LEX, with N numbers of value
c  not equal to 1.0E31. The program is to use the cubic line to
c  interpolate the values for the points other thatn these N
c  numbers.
c
      DIMENSION YA(LEX)
      DIMENSION LX(N),Y(N),Y2(N)
c
c  The following code is to realocate the series of X(N), Y(N)
c
      IF(N.EQ.0) RETURN

      J=1
      DO I=1, LEX
        IF( YA(I).LT.1.0E30 ) THEN
          LX(J)=I
          Y(J)=YA(I)
          J=J+1
        ENDIF
      ENDDO
c
c  The following code is used to calculate the second order
c  derivative, set the derivatives at both ends.
c
c     YP1=(Y(2)-Y(1))/float(LX(2)-LX(1))
c     YPN=(Y(N)-Y(N-1))/float(LX(N)-LX(N-1))
      YP1=1.0E31
      YPN=1.0E31

      CALL SPLINE(LX,Y,N,YP1,YPN,Y2)

c  calculate the cubic spline
c
      DO I=2,N
        KLO=LX(I-1)
        KHI=LX(I)
        H=FLOAT(KHI-KLO)
        DO J=KLO+1,KHI-1
          A=FLOAT(KHI-J)/H
          B=FLOAT(J-KLO)/H
          YA(J)=A*Y(I-1)+B*Y(I)+
     |         ((A*A*A-A)*Y2(I-1)+(B*B*B-B)*Y2(I))*(H*H)/6.0
        ENDDO
      ENDDO

      RETURN
      END

