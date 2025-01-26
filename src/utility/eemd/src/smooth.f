      SUBROUTINE SMOOTH(X,LXY,N)
c
c  a subroutine that smooth X using N point running mean.
c  N should be a odds number. LXY is the length of X
c
      DIMENSION Y(LXY), X(LXY)
c
      N2=N/2
      NS=N2+1
      NE=LXY-N2

      AVE=0
      DO I=1,LXY
        AVE=AVE+X(I)
      ENDDO
      AVE=AVE/FLOAT(LXY)

      DO I=1,LXY
        IF(X(I).LT.0.0) X(I)=AVE
      ENDDO

      DO I=NS,NE
        TEMP=0
        DO J=1,N
          TEMP=TEMP+X(I-NS+J)
        ENDDO
        Y(I)=TEMP/FLOAT(N)
      ENDDO

      DO I=1,N2
        TEMP=0
        NL=2*I-1
        DO J=1,NL
          TEMP=TEMP+X(J)
        ENDDO
        Y(I)=TEMP/FLOAT(I)
      ENDDO

      DO I=NE+1,LXY
        TEMP=0
        NL=(LXY-I)*2+1
        NP=LXY-NL+1
        DO J=NP,LXY
          TEMP=TEMP+X(J)
        ENDDO
        Y(I)=TEMP/FLOAT(NL)
      ENDDO

      RETURN
      END

