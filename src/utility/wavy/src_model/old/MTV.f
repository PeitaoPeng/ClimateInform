      SUBROUTINE MTV(RM,VI,VO,N,C)
      DIMENSION RM(N,N),VI(N),VO(N)
      DO 10 J=1,N
      DO 10 I=1,N
      VO(I) = VO(I) + C*RM(I,J)*VI(J)
  10  CONTINUE
      RETURN
      END
