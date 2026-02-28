CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC:
      SUBROUTINE GEOMEA(TM,H0,GEOHAT)
C........CALCULATE DIMENSIONAL GEOPOTENTIAL
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     input has RN cutoff, calculation is on R20 & LZ
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
*CALL NLCOM
      PARAMETER(NW=20,NLV=18)
      PARAMETER ( NW1=NW+1, NDM=5*NW1 )
      PARAMETER (NHARM = 2*NW1*NW1)
C
      COMPLEX  TE(NW1,NLV),GEO(NW1,NLV),GH0(NW1)
      COMPLEX GEOHAT(NW1,NW1,NLV),TM(NW1,NW1,NLV),H0(NW1,NW1)
      LOGICAL LTRAN
C
      TWOME = 2.*7.292E-5
      RGAS = 287.05
      CP = 1005.
      RAD = 6370.E3
      CAPPA = RGAS / CP
      GRAV = 9.8
      ZCON = GRAV/(TWOME**2*RAD**2)
C
      NZE=0
      NDI=NW1
      NTE=2*NW1
      NGE=3*NW1
      NQ =4*NW1
      NDOT=NQ
C
C  SOLVE HYDROSTATIC EQN THROUGH ZONAL WAVENUMBERS
      DO 100 M=1,NW1
C     WRITE(6,*) ' M=',M
C
      DO 210 J=1,NW1
      GH0(J) = H0(M,J)
      DO 210 K=1,NLV
      TE(J,K) = TM(M,J,K)
 210  CONTINUE
C
C  NONDIMENSIONALIZE FIELDS
      DO 10 I=1,NW1
       GH0(I) = GH0(I) * ZCON
      DO 10 K=1,NLV
       TE(I,K) = TE(I,K) *RGAS / (TWOME*RAD)**2
  10  CONTINUE
C
C  SOLVE FOR GEOPOTENTIAL
      CALL GETGEO(GEO,TE,GH0)
C
C  SAVE BASIC STATE SOLUTION IN F
      DO 1 K=1,NLV
      DO 1 J=1,NW1
      GEOHAT(M,J,K) = GEO(J,K) * TWOME**2 * RAD**2
  1   CONTINUE
C
 100  CONTINUE
C
      return
      END
*DECK GETGEO
      SUBROUTINE GETGEO(GEO,TE,H0)
C........DIRECT SCALAR SOLUTION
C
*CALL NLCOM
      PARAMETER(NW=20,NLV=18,NLV1=NLV+1)
      PARAMETER ( NW1=NW+1)
C
      COMPLEX GEO(NW1,NLV),TE(NW1,NLV),H0(NW1)
      COMPLEX A,B,C,F
      COMPLEX ALPHA(NLV),BETA(NLV),TCI,SCRA,
     & TC
      DIMENSION DELSIG(NLV),DEL(NLV),CI(NLV1),SI(NLV1),SL(NLV),CL(NLV),
     & RPI(NLV-1)
c     DATA DELSIG/ .052, .213, .285, .15, .15, .15/
      DATA DELSIG/  .01, .017, .025, .055, .073, .085,
     1             .093, .096, .096,  .05,  .05,  .05,
     2              .05,  .05,  .05,  .05,  .05,  .05/
C
      RGAS = 287.05
      CP = 1005.
      N = NW1
C
C  VERTICAL GRID COEFFICIENTS
      NL = NLV
      WRITE(6,*) ' uneven SIGMA LEVELS'
      DO 11 K=1,NL
   11 DEL(K)=DELSIG(K)
      CI(1) = 0.
      DO 12 K=1, NL
   12 CI(K+1)=CI(K)+DEL(K)
      RK =  287.05  /  1005.
      RK1 = RK + 1.
      LEVS= NL
      DO 15 LI=1, NL+1
   15 SI(LI) = 1. - CI(LI)
      DO 17 LE=1, NL
        if(LE.eq.NL) then
      DIF = SI(LE)**RK1 - 0.             
        else
      DIF = SI(LE)**RK1 - SI(LE+1)**RK1
        end if
      DIF = DIF / (RK1*(SI(LE)-SI(LE+1)))
      SL(LE) = DIF**(1./RK)
      CL(LE) = 1.- SL(LE)
   17 CONTINUE
      DO 19 LE=1, NL-1
   19 RPI(LE) = (SL(LE+1)/SL(LE))**RK
C
      write(6,*) 'after calculating SI SL CI CL'
      DO 555 I=1,NW1
C  LEVEL 1 ALPHA=0, BETA=H0
      K=1
      ALPHA(1) = 0.
  20  BETA(1) = H0(I)
C
C  LEVELS 2 TO NLV-1
      DO 1 K=2,NLV-1
      KM1 = K - 1
      KP1 = K + 1
         GWM = SI(KM1)/(SI(K)-SI(KM1))
         TWM = CP/(2.*RGAS)*(RPI(KM1)-1.) - 1.
         GW = -SI(K)/(SI(K)-SI(KM1)) - SI(K)/(SI(KP1)-SI(K))
         TW = CP/(2.*RGAS)*(1.-1./RPI(KM1)) + 1.
         GWP = SI(KP1)/(SI(KP1)-SI(K))
C
       A = GWM
       B = GW
       C = GWP
       F =  -TWM * TE(I,KM1)  -  TW * TE(I,K)
C
      ALPHA(K) = -C/(A*ALPHA(K-1)+B)
      BETA(K) = (F-A*BETA(K-1))/(A*ALPHA(K-1)+B)
   1  CONTINUE
C
C  SOLUTION TOP LEVEL
      K = NLV
      KM1 = K - 1
      KP1 = K + 1
         GWM = SI(KM1)/(SI(K)-SI(KM1))
         TWM = CP/(2.*RGAS)*(RPI(KM1)-1.) - 1.
         GW = -SI(K)/(SI(K)-SI(KM1)) - SI(K)/(SI(KP1)-SI(K))
         TW = CP/(2.*RGAS)*(1.-1./RPI(KM1)) + 1.
C
       A = GWM
       B = GW
       F =  -TWM * TE(I,KM1)  -  TW * TE(I,K)
C
      F = (F-A*BETA(K-1))/(A*ALPHA(K-1)+B)
      GEO(I,NLV) = F
C
C  DOWNSWEEP
      DO 7 K=NLV-1,1,-1
      F = BETA(K) + ALPHA(K)*F
      GEO(I,K) = F
  7   CONTINUE
 555  CONTINUE
      RETURN
      END
