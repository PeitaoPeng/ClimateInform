C
C****** "include" - file arrays.i
C
      CHARACTER ITEXT(10)*80
      LOGICAL   LGAP (NTSDIM,NSER), LHOLE(NTSDIM)
      DIMENSION STRUMA (NEODIM,NEODIM)

      DIMENSION
     *        ALAMI (NTSDIM),        ALAMR (NTSDIM),
     *        DAT (NTSDIM,NSER),     DVECT (NTSDIM),
     *        EOFS (NTSDIM,NTSDIM),  FILT (NSER),
     *        POPPER (NEODIM),       PC (NTSDIM,NSER),
     *        PHIRE (NTSDIM),        PHIIM (NTSDIM),
     *        PHIPHR (NTSDIM),       PHIPHI (NTSDIM),
     *        AHIRE (NTSDIM),        AHIIM (NTSDIM),
     *        APOP (NEODIM,NEODIM),
     *        AHIPHR (NTSDIM),       AHIPHI (NTSDIM),
     *        POP (NEODIM,NEODIM),   POPC (NEODIM,NSER),
     *        RC1 (NEODIM,NEODIM),   RC0 (NEODIM,NEODIM),
     *        TEFOLD (NEODIM),       VAR (NTSDIM),
     *        XM (NTSDIM),           XV (NEODIM),
     *        EDFW (NSER),           MDATE(NSER)

C*    VARIABLE     TYPE       PURPOSE.
C     --------     ----       --------
C
C     *LGAP*       LOGICAL      DICTIONARY OF DATA GAPS (.TRUE. IF GAP)
C     *LHOLE*      LOGICAL      DICTIONARY OF SPACE POINTS WITH NO OBSERVATION.
C     *STRUMA*     REAL         SYSTEM MATRIX (RC1*INVERSE(RC0)).
C     *RC1*        REAL         LAG-1 COVARIANCE MATRIX.
C     *RC0*        REAL         LAG-0 COVARIANCE MATRIX.
C     *ALAMI*      REAL         IMAG PART OF EIGENVALUE.
C     *ALAMR*      REAL         REAL PART OF EIGENVALUE.
C     *DAT*        REAL         INPUT DATA.
C     *DVECT*      REAL         EIGENVALUES.
C     *EOFS*       REAL         EOFS.
C     *FILT*       REAL         FILTER WEIGHTS.
C     *POPPER*     REAL         PERIOD OF POPS.
C     *PC*         REAL         PRINCIPAL COMPONENTS.
C     *PHIIM*      REAL         POP IN EOF SPACE, IMAG. PART.
C     *PHIPHR*     REAL         POP IN PHYSICAL SPACE, REAL PART.
C     *PHIPHI*     REAL         POP IN PHYSICAL SPACE, IMAG PART.
C     *PHIRE*      REAL         POP IN EOF SPACE, REAL PART.
C     *POP*        REAL         POPS.
C     *APOP*       REAL         PAPS?
C     *POPC*       REAL         POP COEFFICIENTS.
C     *TEFOLD*     REAL         E-FOLDING TIME OF POPS.
C     *VAR*        REAL         VARIANCES.
C     *XM*         REAL         MEAN OF *X*
C     *XV*         REAL         VARIANCE OF *X*
C     *EDFW*       REAL         ???
C     *MDATE*      INTEGER      CONTAINS DATES FOR THE T21 HEADER

C
C*    WORKSPACE
C     ---------

      CHARACTER WHITE(2)*1

      DIMENSION
     *        INTGER(NTSDIM),
     *        WORK1 (NTSDIM),        WORK5 (NTSDIM),
     *        TS1   (NSER),          TS2   (NSER),
     *        W2    (NEODIM),        W1    (NEODIM),
     *        W3    (NEODIM),        W4    (NEODIM),
     *        X     (NSER),          XCOVM (NEODIM,NEODIM),
     *        WRKOUT(32)

C*    VARIABLE     TYPE       PURPOSE.
C     --------     ----       --------
C
C     *WHITE*      CHARACTER    WORKSPACE.
C     *INTGER*     INTEGER      WORKSPACE.
C     *A1*         REAL         WORKSPACE.
C     *TS1*        REAL         TIME SERIES.
C     *TS2*        REAL         TIME SERIES.
C     *W1*..*W4*   REAL         WORKSPACE.
C     *WORK1*      REAL         WORKSPACE.
C     *WORK5*      REAL         WORKSPACE.
C     *X*          REAL         WORKSPACE.
C     *XCOVM*      REAL         WORKSPACE (STORES COPY OF *POP*)
C     *WRKOUT*     REAL         WORKSPACE FOR *OUTDAT*
