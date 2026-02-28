*DECK AFFSFS
      SUBROUTINE AFFSFS  (A,W,MFS,LONG,NFF,JCAP)
      DIMENSION A(LONG,MFS), W(NFF)
      I1 = 2 * (JCAP+1)
      I2 = 2 * JCAP + 1
      DO 500 J = 1 , MFS
      DO 100 I = 2 , I2
      A(I,J) = A(I+1,J)
  100 CONTINUE
      DO 200 I = I1 ,LONG
      A(I,J) = 0.0
  200 CONTINUE
      CALL RFFTB (LONG,A(1,J),W)
  500 CONTINUE
      RETURN
      END
*DECK APLN2
      SUBROUTINE APLN2 (SLN,COLRAD,NLT2,LAT,EPS,JCAP,X,Y,PLN)
      REAL*4  SLN,COLRAD,EPS
      DIMENSION SLN(JCAP+1,JCAP+2),COLRAD(NLT2),EPS(JCAP+1,JCAP+2)
      DIMENSION X(JCAP+1), Y(JCAP+1), PLN(JCAP+1,JCAP+2)
      JCAP1 = JCAP + 1
      JCAP2 = JCAP + 2
      COLR=COLRAD(LAT)
      SINLAT = COS(COLR)
      COS2 = 1.0E+00 - SINLAT * SINLAT
      PROD = 1.0E+00
      A = 1.0E+00
      B = 0.0E+00
      DO 5 LL=1,JCAP1
      X(LL)=FLOAT(2*LL+1)
      Y(LL)=X(LL)/(X(LL)-1.0E+00)
    5 CONTINUE
      DO 10 LL=1,JCAP1
      PLN(LL,1)=0.5E+00*PROD
      FRAC=Y(LL)
      IF(PROD.LT.1.0E-40)PROD=0.0E+00
      PROD=PROD*COS2*FRAC
   10 CONTINUE
      DO 15 LL=1,JCAP1
      PLN(LL,1)= SQRT(PLN(LL,1))
      PLN(LL,2)= SQRT(X(LL)) *SINLAT*PLN(LL,1)
   15 CONTINUE
      DO 20 N=3,JCAP2
      DO 20 LL=1,JCAP1
      PLN(LL,N) = (SINLAT*PLN(LL,N-1)
     1                - EPS(LL,N-1)*PLN(LL,N-2)) / EPS(LL,N)
   20 CONTINUE
      DO 30 N=1,JCAP2
      DO 30 LL=1,JCAP1
      SLN(LL,N)= PLN(LL,N)
   30 CONTINUE
      RETURN
      END
*DECK ADZTUV
      SUBROUTINE ADZTUV (D,Z,U,V,E,JCAP)
      DIMENSION D(2,JCAP+1,JCAP+1), Z(2,JCAP+1,JCAP+1),
     1          U(2,JCAP+1,JCAP+2), V(2,JCAP+1,JCAP+2), E(JCAP+1,JCAP+2)
      JCAP1 = JCAP + 1
      JCAP2 = JCAP + 2
C       COMPLEX CIL
C       L=0
      XN = 0.0
C.......  U(X,1,1) =  E(2,1)*Z(Y,2,1)
        U(1,1,1) =  E(1,2)*Z(1,1,2)
        U(2,1,1) =  E(1,2)*Z(2,1,2)
C.......  V(X,1,1) = -E(2,1)*D(Y,2,1)
        V(1,1,1) = -E(1,2)*D(1,1,2)
        V(2,1,1) = -E(1,2)*D(2,1,2)
      DO 1 I=2, JCAP
      XN = XN + 1.0
      R = 1.0/XN
      R1 = 1.0/(XN+1.0)
C.......  U(X,I,1)=-E(I,1)*Z(Y,I-1,1)*R+E(I+1,1)*Z(Y,I+1,1)*R1
      U(1,1,I)=-E(1,I)*Z(1,1,I-1)*R+E(1,I+1)*Z(1,1,I+1)*R1
      U(2,1,I)=-E(1,I)*Z(2,1,I-1)*R+E(1,I+1)*Z(2,1,I+1)*R1
C.......  V(X,I,1)= E(I,1)*D(Y,I-1,1)*R-E(I+1,1)*D(Y,I+1,1)*R1
      V(1,1,I)= E(1,I)*D(1,1,I-1)*R-E(1,I+1)*D(1,1,I+1)*R1
      V(2,1,I)= E(1,I)*D(2,1,I-1)*R-E(1,I+1)*D(2,1,I+1)*R1
    1 CONTINUE
      XN = XN + 1.0
      R = 1.0/XN
C.......  U(X, JCAP1 ,1) = -E( JCAP1 ,1)*Z(Y, JCAP ,1)*R
        U(1,1, JCAP1 ) = -E(1, JCAP1 )*Z(1,1, JCAP )*R
        U(2,1, JCAP1 ) = -E(1, JCAP1 )*Z(2,1, JCAP )*R
C.......  V(X, JCAP1 ,1) =  E( JCAP1 ,1)*D(Y, JCAP ,1)*R
        V(1,1, JCAP1 ) =  E(1, JCAP1 )*D(1,1, JCAP )*R
        V(2,1, JCAP1 ) =  E(1, JCAP1 )*D(2,1, JCAP )*R
      XN = XN + 1.0
      R = 1.0/XN
C........  U(X, JCAP2 ,1) = -E( JCAP2 ,1)*Z(Y, JCAP1 )*R
        U(1,1, JCAP2 ) = -E(1, JCAP2 )*Z(1,1, JCAP1 )*R
        U(2,1, JCAP2 ) = -E(1, JCAP2 )*Z(2,1, JCAP1 )*R
C .......  V(X, JCAP2 ,1) =  E( JCAP2 ,1)*D(Y, JCAP1 )*R
        V(1,1, JCAP2 ) =  E(1, JCAP2 )*D(1,1, JCAP1 )*R
        V(2,1, JCAP2 ) =  E(1, JCAP2 )*D(2,1, JCAP1 )*R
C         FIN L=0
      DO 1000 L=2, JCAP1
      XL = L
      XN = XL-1.0
      XLL = XN
      R = 1.0/XN
      R1 = 1.0/XL
C........  CIL=CMPLX(0.,1.)*(L-1)
C........  U(X,1,L)=-CIL*D(Y,1,L)*R*R1 + E(2,L)*Z(Y,2,L)*R1
        U(1,L,1)= D(2,L,1)*R*R1*XLL+E(L,2)*Z(1,L,2)*R1
        U(2,L,1)=-D(1,L,1)*R*R1*XLL+E(L,2)*Z(2,L,2)*R1
C........  V(X,1,L)=-CIL*Z(Y,1,L)*R*R1 - E(2,L)*D(Y,2,L)*R1
        V(1,L,1)= Z(2,L,1)*R*R1*XLL-E(L,2)*D(1,L,2)*R1
        V(2,L,1)=-Z(1,L,1)*R*R1*XLL-E(L,2)*D(2,L,2)*R1
      DO 2 I=2, JCAP
      XN = XN+1.0
      R = 1.0/XN
      R1 = 1.0/(XN+1.0)
      R2 = R*R1
      RL = R2*XLL
C........  U(X,I,L)=-E(I,L)*Z(Y,I-1,L)*R-CIL*D(Y,I,L)*R2
C........                      + E(I+1,L)*Z(Y,I+1,L)*R1
      U(1,L,I)=-E(L,I)*Z(1,L,I-1)*R+D(2,L,I)*RL+E(L,I+1)*Z(1,L,I+1)*R1
      U(2,L,I)=-E(L,I)*Z(2,L,I-1)*R-D(1,L,I)*RL+E(L,I+1)*Z(2,L,I+1)*R1
C........  V(X,I,L)= E(I,L)*D(Y,I-1,L)*R-CIL*Z(Y,I,L)*R2
C........                      - E(I+1,L)*D(Y,I+1,L)*R1
      V(1,L,I)= E(L,I)*D(1,L,I-1)*R+Z(2,L,I)*RL-E(L,I+1)*D(1,L,I+1)*R1
      V(2,L,I)= E(L,I)*D(2,L,I-1)*R-Z(1,L,I)*RL-E(L,I+1)*D(2,L,I+1)*R1
    2 CONTINUE
      XN = XN +1.0
      R = 1.0/XN
      R1 = R/(XN+1.0)
C........  U(X, JCAP1 ,L)=-E( JCAP1 ,L)*Z(Y, JCAP ,L)*R
C........                      -CIL*D(Y, JCAP1 ,L)*R1
      U(1,L, JCAP1 )=-E(L, JCAP1 )*Z(1,L, JCAP )*R+D(2,L, JCAP1 )*R1*XLL
      U(2,L, JCAP1 )=-E(L, JCAP1 )*Z(2,L, JCAP )*R-D(1,L, JCAP1 )*R1*XLL
C........  V(X, JCAP1 ,L)= E( JCAP1 ,L)*D(Y, JCAP ,L)*R
C........                      -CIL*Z(Y, JCAP1 ,L)*R1
      V(1,L, JCAP1 )= E(L, JCAP1 )*D(1,L, JCAP )*R+Z(2,L, JCAP1 )*R1*XLL
      V(2,L, JCAP1 )= E(L, JCAP1 )*D(2,L, JCAP )*R-Z(1,L, JCAP1 )*R1*XLL
      XN = XN + 1.0
      R = 1.0/XN
C........  U(X, JCAP2 ,L) = -E( JCAP2 ,L)*Z(Y, JCAP1 ,L)*R
        U(1,L, JCAP2 ) = -E(L, JCAP2 )*Z(1,L, JCAP1 )*R
        U(2,L, JCAP2 ) = -E(L, JCAP2 )*Z(2,L, JCAP1 )*R
C........  V(X, JCAP2 ,L) =  E( JCAP2 ,L)*D(Y, JCAP1 ,L)*R
        V(1,L, JCAP2 ) =  E(L, JCAP2 )*D(1,L, JCAP1 )*R
        V(2,L, JCAP2 ) =  E(L, JCAP2 )*D(2,L, JCAP1 )*R
 1000 CONTINUE
C....
      DO 2000 IND=1, JCAP2
      DO 2000 LL=1, JCAP1
      U(1,LL,IND)=U(1,LL,IND)* 6370000.0
      U(2,LL,IND)=U(2,LL,IND)* 6370000.0
      V(1,LL,IND)=V(1,LL,IND)* 6370000.0
      V(2,LL,IND)=V(2,LL,IND)* 6370000.0
 2000 CONTINUE
      RETURN
      END
*DECK AEPS
      SUBROUTINE AEPS (EPS,JCAP)
      DIMENSION EPS(JCAP+1,JCAP+2)
      JCAP1 = JCAP + 1
      JCAP2 = JCAP + 2
      DO 1 LL=1,JCAP1
      L = LL - 1
      DO 1 INDE=2,JCAP2
      N = L + INDE - 1
      A = FLOAT(N*N - L*L) / (4. * FLOAT(N*N) - 1.)
      EPS(LL,INDE)= SQRT (A)
    1 CONTINUE
      DO 2 LL=1,JCAP1
      EPS(LL,1) = 0.
    2 CONTINUE
      RETURN
      END
*DECK ACOFIL
        SUBROUTINE ACOFIL (ARRAY,IDIM,CONST)
        DIMENSION ARRAY(IDIM)
        DO I = 1, IDIM
        ARRAY(I) = CONST
        ENDDO
        RETURN
        END
c
*DECK APOLY
      SUBROUTINE APOLY (N,RAD,P)
      IMPLICIT REAL*8 (A-H,O-Z)
      X = COS(RAD)
      Y1 = 1.0e+00
      Y2=X
      DO 1 I=2,N
      G=X*Y2
      Y3=G-Y1+G-(G-Y1)/FLOAT(I)
      Y1=Y2
      Y2=Y3
1     CONTINUE
      P=Y3
      RETURN
      END
*DECI AFFAFA
      SUBROUTINE AFFAFA  (G,A,W,MFS,LONG,NFF,JCAP)
      DIMENSION G(LONG,MFS), A(LONG,MFS), W(NFF)
      ONELON = 1.0 / FLOAT(LONG)
      I1 = 2*(JCAP+1)
      DO 500 J = 1 , MFS
      DO 50 I = 1 , LONG
      A(I,J) = G(I,J)
   50 CONTINUE
      CALL RFFTF (LONG,A(1,J),W)
      DO 100 I = I1 , 3 , -1
      A(I,J) = ONELON * A(I-1,J)
  100 CONTINUE
      A(1,J) = ONELON * A(1,J)
      A(2,J) = 0.0
  500 CONTINUE
      RETURN
      END
*DECK ASTSIG
      SUBROUTINE ASTSIG (CI, SI, DEL, SL, CL, RPI, LEV)
      DIMENSION CI(LEV+1), SI(LEV+1),
     1          DEL(LEV), SL(LEV), CL(LEV), RPI(LEV-1)
      DIMENSION DELSIG(10)
c     DATA DELSIG/.052, .213, .285, .15, .15, .15/    
      DATA DELSIG/10*0.1/
      LEVP1 = LEV + 1
      LEVM1 = LEV - 1
c     WRITE(6,*) ' ASTSIG IN AFLS SET FOR MRF85'
c     IF(LEV.NE.18) STOP 4000
c     RECDEL = 1./FLOAT(LEV)
c     DO 10 K=1,LEV
c 10  DEL(K) = RECDEL
      DO 9889 K=1,LEV
9889  DEL(K)=DELSIG(K)
      CI(1) = 0.0
      DO 54 K=1,LEV
54    CI(K+1)=CI(K)+DEL(K)
      CI(LEVP1)=1.0
      RK =  287.05 /  1005.0
      RK1 = RK + 1.0
      DO 1 LI=1,LEVP1
      SI(LI) = 1.0 - CI(LI)
c     write(6,*) 'SI=',SI(LI)
1     CONTINUE
      DO 3 LE=1,LEV
        if(LE.eq.LEV) then
      DIF = SI(LE)**RK1 - 0.
        else
      DIF = SI(LE)**RK1 - SI(LE+1)**RK1
        end if
      DIF = DIF / (RK1*(SI(LE)-SI(LE+1)))
      SL(LE) = DIF**(1.0/RK)
c     write(6,*) 'SL=',SL(LE)
      CL(LE) = 1.0 - SL(LE)
3     CONTINUE
C     COMPUTE PI RATIOS FOR TEMP. MATRIX.
      DO 4 LE=1,LEVM1
4     RPI(LE) = (SL(LE+1)/SL(LE))**RK
      RETURN
      END
*DECK AGLATF
      SUBROUTINE AGLATF (KFULL,COLRAD,WGT,WGTCS,RCS2)
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION COLRAD(KFULL), WGT(KFULL), WGTCS(KFULL), RCS2(KFULL)
      KHALF = KFULL / 2
      EPS=1.0e-12
c     PRINT 101
 101  FORMAT ('0 I   COLAT   COLRAD     WGT', 12X, 'WGTCS',
     1 10X, 'ITER  RES')
      SI = 1.0e+00
      K2=2*KHALF
      RK2=K2
      SCALE = 2.0e+00/(RK2**2)
      K1=K2-1
      PI = ATAN(SI)*4.0e+00
      DRADZ = PI / 360.0e+00
      RAD = 0.0e+00
      DO 1000 K=1,KHALF
      ITER=0
      DRAD=DRADZ
1     CALL APOLY(K2,RAD,P2)
2     P1 =P2
      ITER=ITER+1
      RAD=RAD+DRAD
      CALL APOLY(K2,RAD,P2)
      IF(SIGN(SI,P1).EQ.SIGN(SI,P2)) GO TO 2
      IF(DRAD.LT.EPS)GO TO 3
      RAD=RAD-DRAD
      DRAD = DRAD * 0.25e+00
      GO TO 1
3     CONTINUE
      COLRAD(K)= RAD
      COLRAD(KFULL-K+1)= PI - RAD
      PHI = RAD * 180e+00 / PI
      CALL APOLY(K1,RAD,P1)
      X = COS(RAD)
      W = SCALE * (1.0e+00 - X*X)/ (P1*P1)
      WGT(K) = W
      WGT(KFULL-K+1) = W
      SN = SIN(RAD)
      W=W/(SN*SN)
      WGTCS(K) = W
      WGTCS(KFULL-K+1) = W
      RC=1.0e+00/(SN*SN)
      RCS2(K) = RC
      RCS2(KFULL-K+1) = RC
      CALL APOLY(K2,RAD,P1)
c     PRINT 102,K,PHI,COLRAD(K),WGT(K),WGTCS(K),ITER,P1
 102  FORMAT(1H ,I2,2X,F6.2,2X,F10.7,2X,E13.7,2X,E13.7,2X,I4,2X,D13.7)
1000  CONTINUE
c     PRINT 100,KHALF
100   FORMAT(1H ,'SHALOM FROM 0.0 S 0 GLATS FOR ',I3)
      RETURN
      END
*DECK RIT6
      SUBROUTINE RIT6(A,M,N,K,NW1,NW2,NLV)
      COMPLEX A(NW1,NW2,NLV)
      WRITE(6,*) A(M+1,N,K)
      RETURN
      END
*DECK ZONM
      SUBROUTINE ZONM(A,B,NWP1,NWP2,NLV)
      COMPLEX A(NWP1,NWP2,NLV),B(NWP1,NWP2,NLV)
      DO 1 K=1,NLV
      DO 1 N=1,NWP2
      B(1,N,K)=A(1,N,K)
      DO 1 M=2,NWP1
      B(M,N,K)=CMPLX(0.,0.)
   1  CONTINUE
      RETURN
      END
*DECK GGRTOS
      SUBROUTINE GGRTOS(X,F,WGT,PLN,NWP1)
      COMPLEX X(NWP1),F(NWP1,NWP1)
      DIMENSION PLN(NWP1,NWP1)
      DO 1 M=1,NWP1
      DO 1 N=1,NWP1
      F(M,N) = F(M,N) + WGT * PLN(M,N) * X(M)
  1   CONTINUE
      RETURN
      END
*DECK STOYGR
      SUBROUTINE STOYGR(T,TG,NW1,NW2,PLN)
      DIMENSION PLN(NW1,NW2)
      COMPLEX T(NW1,NW2),TG(NW1)
      CALL ACOFIL(TG,2*NW1,0.0)
      DO 1 M=1,NW1
      DO 2 N=1,NW2
      TG(M) = TG(M) + T(M,N)*PLN(M,N)
  2   CONTINUE
  1   CONTINUE
      RETURN
      END
*DECK REDMOD
      SUBROUTINE REDMOD (NSFILE,BUFR,NHARM,LEV,FIELD,NW1,LTRAN)
      DIMENSION BUFR(NHARM,LEV)
      LOGICAL LTRAN
      COMPLEX FIELD(NW1,NW1,LEV)
      DO 10 K=1,LEV
      READ(NSFILE,100) (BUFR(I,K),I=1,NHARM)
  10  CONTINUE
 100  FORMAT(8E10.4)
      CALL TRANIN (BUFR,LEV,FIELD,NW1,LTRAN)
      RETURN
      END
*DECK TRANIN
      SUBROUTINE TRANIN (A,N,B,NW1,LTRAN)
      COMPLEX  A(NW1,NW1,N) , B(NW1,NW1,N)
      LOGICAL LTRAN
       IF(LTRAN) THEN
      DO 5 K=1,N
      DO 8 J=1,NW1
      DO 8 M=1,NW1
    8 B(M,J,K) = A(J,M,K)
    5 CONTINUE
       ELSE
      DO 50 K=1,N
      DO 80 J=1,NW1
      DO 80 M=1,NW1
  80  B(M,J,K) = A(M,J,K)
  50  CONTINUE
       END IF
      RETURN
      END
*DECK DELLNP
      SUBROUTINE DELLNP(Q,DPDPHI,DPDLAM,EPS,NW)
      COMPLEX Q(NW+1,NW+1),DPDPHI(NW+1,NW+2),
     1  DPDLAM(NW+1,NW+1)
      DIMENSION EPS(NW+1,NW+2)
      COMPLEX SM1
      SM1=CMPLX(0.,1.)
      DO 2 LL=1,NW+1
      FL=LL-1
      DO 2 IND=1,NW+1
      DPDLAM(LL,IND)= Q(LL,IND)*FL*SM1
    2 CONTINUE
      DO 4 LL=1,NW+1
      XL=LL-1
      XN=XL
      DPDPHI(LL,1)= Q(LL,2)*(XL+2.0)*EPS(LL,2)
      DO 3 IND=2,NW
      XN=XN+1.0
      DPDPHI(LL,IND)= (XN+2.0)*EPS(LL,IND+1)*
     1  Q(LL,IND+1)+(1.0-XN)*EPS(LL,IND)*Q(LL,IND-1)
    3 CONTINUE
      DPDPHI(LL,NW+1)=
     1       -(XL+ NW  -1.0)*EPS(LL,NW+1)*Q(LL, NW )
      DPDPHI(LL,NW+2)=
     1       -(XL+ NW  )*EPS(LL,NW+2)*Q(LL,NW+1)
    4 CONTINUE
      AA=1.0/ 6370000.0
      DO 5 IND=1,NW+1
      DO 5 LL=1,NW+1
      DPDLAM(LL,IND)=DPDLAM(LL,IND)*AA
    5 CONTINUE
      DO 6 IND=1,NW+2
      DO 6 LL=1,NW+1
      DPDPHI(LL,IND)=DPDPHI(LL,IND)*AA
    6 CONTINUE
      RETURN
      END
*DECK AQLN
      SUBROUTINE AQLN(PLN,QLN,EPS,NWP1)
      DIMENSION PLN(NWP1,NWP1+1),QLN(NWP1,NWP1+1),EPS(NWP1,NWP1+1)
      DO 1 MM=1,NWP1
      M=MM-1
      N=M
      QLN(MM,1) = -N*EPS(MM,2)*PLN(MM,2)
  1   CONTINUE
      DO 2 MM=1,NWP1
      DO 2 NN=2,NWP1
      M=MM-1
      N=M+NN-1
      QLN(MM,NN) = (N+1.)*EPS(MM,NN)*PLN(MM,NN-1)
     1             -  N*EPS(MM,NN+1)*PLN(MM,NN+1)
  2   CONTINUE
      RETURN
      END
*DECK DDLAM
      SUBROUTINE DDLAM (A,NWP1)
      COMPLEX A(NWP1),SM1
      SM1 = CMPLX(0.,1.)
      DO 1 I=1,NWP1
      A(I) = SM1*(I-1.)*A(I)
  1   CONTINUE
      RETURN
      END
