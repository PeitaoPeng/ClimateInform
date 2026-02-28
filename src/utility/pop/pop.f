C==== BEGIN POPMAIN ( M01 ) ===================================================
C
      PROGRAM POPMAIN
C
C**** *POPPRO*   PROGRAM FOR CALCULATION OF POPS AND/OR CEOFS
C     VERSION 2.0   2. AUGUST 1988
C     VERSION 2.1   7. AUGUST 1988 HANS VON STORCH
C                   SUBROUTINE *STD* IMPROVED
C                   SUBROUTINE *READDAT* - REDUCTION OF TIME SERIES
C                   LENGTH BY REMOVING THE FIRST INSTEAD OF THE LAST
C                   DATA.
C                   MINOR CHANGES IN EXPLAINING COMMENTS
C
C     I. FISCHER-BRUNS             01/10/87
C     MODIFIED BY F.G.GALLAGHER    04/11/87  - MODIFICATIONS FOR USER
C                                              FRIENDLY INTERFACE.
C
C     PURPOSE.
C     --------
C
C     *POPMAIN* sets up user parameters and dimensions for dynamical field
C     lengths without declaring any adjustable arrays.
C
C     AND/OR THE COMPLEX EOFS (CEOFS) FOR THE GIVEN DATA SET.
C
C**   INTERFACE.
C     ----------
C
C     MAIN PROGRAM - REQUIRES NAMELIST FOR INPUT AND OUTPUT FILES
C                    (see Parameter statement in 'scalars.i').
C
C
C     EXTERNALS.
C     ----------
C
C     *PARSIN*          - Subroutine to import user parameters
C                         and set up dimensions
C     *POPPRO*          - Subroutine to start the computing routines
C
C
C     No arrays with symbolic field lengths to be included here!
C
      include 'scalars.i'
C
C     ------------------------------------------------------------------
C
C*    1. INPUT AND TEST VALIDITY OF PARAMETERS, define array dimensions.
C
      CALL PARSIN
C
C     ------------------------------------------------------------------
C
C*    2. Start *POPPRO*
C
      CALL POPPRO

      STOP
      END
C
C==== END POPMAIN==============================================================
C
C
C==== BEGIN POPPRO ( M01O1 ) ==================================================
C
      SUBROUTINE POPPRO
C
C**** *POPPRO*   MAIN SUBROUTINE FOR CALCULATION OF POPS AND/OR CEOFS
C
C     PURPOSE.
C     --------
C
C     *POPPRO* CALLS UP CALCULATION OF POPS
C     AND/OR THE COMPLEX EOFS (CEOFS) FOR THE GIVEN DATA SET.
C
C**   INTERFACE.
C     ----------
C
C
C
C     EXTERNALS.
C     ----------
C
C     *READDAT*           - SUBROUTINE TO READ DATA.
C     *FILTTS*            - SUBROUTINE TO PRE-FILTER TIME SERIES.
C     *POPAN*             - SUBROUTINE TO PERFORM POP ANALYSIS.
C     *CEOFAN*            - SUBROUTINE TO PERFORM CEOF ANALYSIS.
C
      include 'scalars.i'
      include 'arrays.i'
C
C     ------------------------------------------------------------
C
C*    1. Read input data
C
      CALL READDAT( DAT, LGAP, LHOLE, MDATE )
C
C     -------------------------------------------------------------
C
C*    2 PRE-PROCESS DATA. (FILTERING ETC)
C
      CALL FILTTS( DAT, LGAP, MDATE, VAR )
C
C     ------------------------------------------------------------
C
C*    3. POP ANALYSIS.
C        (IF LEOFS=.TRUE. POPAN RETURNS AFTER EOF ANALYSIS)
C
      IF (LPOPS .OR. LEOFS)  CALL POPAN( DAT, LGAP, LHOLE, VAR )
C
C     ------------------------------------------------------------
C
C*    4. CEOF ANALYSIS.
C
      IF (LCEOF)  CALL CEOFAN( DAT, LGAP, VAR )

C
C*    5. END OF PROGRAM RUN
C

 9999 PRINT*, 'POPPRO SUCCESSFUL'
      RETURN
      END
C
C==== END POPPRO ==============================================================
C
C
C==== BEGIN READDAT ( M010101 ) ===============================================
C
      SUBROUTINE READDAT( DAT, LGAP, LHOLE, MDATE )
C
C**** *READDAT* - SUBROUTINE TO READ INPUT DATA
c                 AND TO SCALE DATA BY THE FACTOR GIVEN BY THE USER
C
C     G. HANNOSCHOECK     26/11/90
C
C
      include 'scalars.i'
      include 'arrays.i'

      LOGICAL GAP
C
C*    1. Read one time series, not more than *NTS* values
C        (no rewind here, see *PREREAD*).
C
      CALL ZERO( DAT, NTSDIM*NSER )

      NUMGAP = 0
      DMAX = 0.
      DO 1017 JTIME=1,NTO
        READ( JPUNIR ) MDATE( JTIME ), IVAR, ILEV, ILENG
        ILE = MIN0( ILENG, NTS )
        READ( JPUNIR ) ( DAT( JSPACE, JTIME ), JSPACE=1,ILE )
C
C*    1.1 Look for data gaps, add up gap counters and zero data there
C
        DO 1012 JSPACE = 1,NTS
          IF( DAT( JSPACE, JTIME ) .EQ. PPGAP .OR.
     *        JSPACE .GT. ILENG )                    THEN
            LGAP( JSPACE, JTIME ) = .TRUE.
            NUMGAP = NUMGAP + 1
            IF ( LEVPRI )        PRINT 1900, JSPACE, JTIME
          ELSE
            LGAP( JSPACE, JTIME ) = .FALSE.
            DMAX = AMAX1( DMAX, ABS(DAT( JSPACE, JTIME ) ) )
          ENDIF
 1012   CONTINUE

 1017 CONTINUE

C
C*    2. Look for points in space where no observation is available.
C
      NUMHOLE = 0
      DO 1018 JSPACE=1,NTS
         GAP = .TRUE.
         DO 1019 JTIME=1,NTO
            IF (.NOT.LGAP(JSPACE,JTIME) ) GAP = .FALSE.
 1019    CONTINUE
         IF (GAP) THEN
            LHOLE(JSPACE) = .TRUE.
            NUMHOLE = NUMHOLE + 1
         ELSE
            LHOLE(JSPACE) = .FALSE.
         END IF
 1018 CONTINUE
            
      PRINT 1902, NUMGAP
      PRINT 1903, NUMHOLE
      PRINT 1901, DMAX
      PRINT *

 1900 FORMAT( ' DATA GAP AT SPACE POINT NO.', I10,
     *        '      AT TIME NO.',I10 )
 1901 FORMAT( ' MAX. ABS. VALUE OF NON-GAP DATA: ', E14.3 )
 1902 FORMAT( ' TOTAL NUMBER OF GAPPY DATA: ',I10)
 1903 FORMAT( ' NUMBER OF SPACE POINTS WITH NO OBSERVATIONS',
     *        ' AVAILABLE: ',I10)
C
C*    2. SCALE DATA BY *FACT*
C
      DO 2200 JTIME = 1,NTO
         DO 2201 JSPACE = 1,NTS
            IF ( .NOT. LGAP(JSPACE,JTIME) )
     *            DAT(JSPACE,JTIME) = DAT(JSPACE,JTIME) * FACT
 2201    CONTINUE
 2200 CONTINUE

      RETURN
      END
C
C==== END READDAT =============================================================

C==== BEGIN PARSIN ( U01 ) ====================================================
C
      SUBROUTINE PARSIN
C
C**** *PARSIN* - ROUTINE TO READ IN PARAMETERS.
C
C     G. HANNOSCHOECK,   MPIFM      26/11/90
C
C     PURPOSE.
C     --------
C
C     *PARSIN* EVALUATES PARAMETERS FROM THE COMMAND LINE,
C     TESTS THEM FOR CORRECT VALUES,
C     READS IN DATA FROM TAPE,
C     AND PRINTS CERTAIN DATA FOR REFERENCE
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *PARSIN*
C
C
C     EXTERNALS.
C     ----------
C
C     *HELP*            - Subroutine giving general advice
C     *HELPAR*          - Subroutine for command line error handling
C     *ICONV*           - Function converting string -> integer
C     *RCONV*           - Function converting string -> real
C     *BOXIT*           - Subroutine, printing routine
C     *SETDIM*          - Subroutine to set dynamic field lengths (CRAY-2)
c     *PREREAD*         - Subroutine for finding *NTO* from the input file
C
      include 'scalars.i'
      include 'arrays.i'

      PARAMETER(       JPLNAM = 30 )
      CHARACTER*70     YNAMO( NFILES )
      CHARACTER*60     YNAMU,      YNAMI, YNAMOB
      CHARACTER        YOPARM*121, CH,    CHOPT, YOPT,  YOSTR*60
      CHARACTER*70     YWORK
      LOGICAL          LOOPT,      LOOARG,LOARG, LINT

C
C     Define all system file names.
C
      DATA YNAMU   /'POP.PAR'/
      DATA YNAMI   /'POP.IN'/
      DATA YNAMOB  /'POP'/
      DATA YNAMO   /'.filt',  '.var',   '.eof',   '.eofc',
     *              '.eofsp', '.pop',   '.pope',  '.popc',
     *              '.popsp', '.apop',  '.apope', '.ceof'/
C
C*    1. Default values ( blank lines for *ITEXT* ).
C
      WRITE( TITLE, '(80X)' )
      DO 1010 J=1,10
 1010 WRITE( ITEXT( J ), 1019 )
 1019 FORMAT( 80X )
      DATA ITEXT               /10*'                              '/
      DATA LTURN                    /.FALSE./
      DATA NTS, NTO, NEOF, NCEOF    /0, 0, 20, 20/
      DATA LTFILT,LNORM,LTREND      /3* .FALSE. /
      DATA NC,FACT                  /10,1./
      DATA LFILT,LEVPRI,LSPPRI     /.FALSE.,.FALSE.,.FALSE./
      DATA LFLIP,LLSF              /.FALSE.,.FALSE./
      DATA ITAU,DT                  /1,1./
      DATA PMIN,P1,P2,PMAX          /4*-1./
      DATA ITEXT  /10*'                              '/
      LPOPS=.TRUE.
      LEOFS=.FALSE.
      LCEOF=.FALSE.

C
C*    2. Parameter input
C*    2.1. Read parameter line
C
      WRITE( YOPARM, '(121X)' )
      IF( LPSTDIN ) THEN
        READ '(A)', YOPARM
      ELSE
C         OPEN( JPUNIU,IOSTAT=IOS, ERR=1100, FILE= YNAMU,
         OPEN( JPUNIU,IOSTAT=IOS, ERR=1100,
     *                STATUS='OLD' )
 1100    IF( IOS .NE. 0 ) THEN
            CALL HELP( 6, 1, 0, LEVPRI )
            PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
            STOP
         ENDIF
         READ( JPUNIU, '(A)' )  YOPARM
      ENDIF
C
C*    2.2 Begin of string scan
C
      IC = 0
      LOOPT = .FALSE.
      LOOARG = .FALSE.
      LOARG = .FALSE.
      JARG = 0

 1200 CONTINUE
      IC = IC + 1
      LINT = .TRUE.
      IF( IC .GT. 121 )   GOTO 1600
      CH = YOPARM( IC:IC )
C
C*    2.3 Location of allowed blank separators (then jump back)
C
      IF( CH .EQ. ' ' ) THEN
        LOOPT = .FALSE.
        GOTO 1200
      ENDIF
C
C*    2.4 Jump to special scanning if flag is set.
C         These IFs are in a sophisticated order!
C         *LOARG*:  Non-option argument beginning (right of -- ).
C         *LOOARG*: Argument to option letter beginning.
C         *LOOPT*:  Option letter following option letter expected.
C
      IF( LOARG )         GOTO 1400
      IF( LOOARG )        GOTO 1300
      IF( LOOPT )         GOTO 1250
      IF( CH .EQ. '-' ) THEN
        IC = IC + 1
        IF( IC .GT. 121 )   GOTO 1600
        CH = YOPARM( IC:IC )
      ELSE
        CALL HELPAR( 1, YOPARM, IC )
      ENDIF

 1250 CONTINUE
      IF( CH .EQ. '-' ) THEN
C
C       Double minus found.
C
        LOARG = .TRUE.
        GOTO 1200
      ENDIF
C
C*    2.5 Option letter expected
C
      LOOPT = .TRUE.
      CHOPT = CH
      IF(     CHOPT .EQ. 'E' ) THEN
        LEOFS = .TRUE.
        LPOPS = .FALSE.
      ELSEIF( CHOPT .EQ. 'C' ) THEN
        LCEOF = .TRUE.
        LPOPS = .FALSE.
      ELSEIF( CHOPT .EQ. 'T' ) THEN
        LTFILT = .TRUE.
      ELSEIF( CHOPT .EQ. 'd' ) THEN
        LTREND = .TRUE.
      ELSEIF( CHOPT .EQ. 'r' ) THEN
        LNORM = .TRUE.
      ELSEIF( CHOPT .EQ. 'u' ) THEN
        LTURN = .TRUE.
      ELSEIF( CHOPT .EQ. 'p' ) THEN
        LEVPRI = .TRUE.
      ELSEIF( CHOPT .EQ. 'f' ) THEN
        LFLIP = .TRUE.
      ELSEIF( CHOPT .EQ. 'l' ) THEN
        LLSF = .TRUE.
      ELSEIF( CHOPT .EQ. 'n' .OR.
     *        CHOPT .EQ. 't' .OR.
     *        CHOPT .EQ. 'c' .OR.
     *        CHOPT .EQ. 's' .OR.
     *        CHOPT .EQ. 'm' .OR.
     *        CHOPT .EQ. 'e' .OR.
     *        CHOPT .EQ. 'i' .OR.
     *        CHOPT .EQ. 'o'          ) THEN
                                      LOOARG = .TRUE.
      ELSE
        CALL HELPAR( 9, YOPARM, IC )
      ENDIF
      GOTO 1200
C
C*    2.6 Option argument expected because of *LOOARG*
C         (one unseperated string). First write into auxiliary string.
C
 1300 CONTINUE
      ISTR = 0
      WRITE( YOSTR, '(60X)' )

 1310 CONTINUE
      CH = YOPARM( IC:IC )
      IF( CH .EQ. ' ' )  THEN
        IC = IC - 1
        GOTO 1330
      ENDIF
      ISTR = ISTR + 1
      IF ( ISTR .GT. 60 )  CALL HELPAR( 2, YOPARM, IC )
      YOSTR( ISTR:ISTR ) = CH
      IC = IC + 1
      IF( IC .GT. 121 )   GOTO 1600
      GOTO 1310

 1330 CONTINUE
      IERR = 0
      IF(     CHOPT .EQ. 'n' ) THEN
        NTS = ICONV( YOSTR, ISTR, IERR )
      ELSEIF( CHOPT .EQ. 't' ) THEN
        NTO = ICONV( YOSTR, ISTR, IERR )
      ELSEIF( CHOPT .EQ. 'c' ) THEN
        NC = ICONV( YOSTR, ISTR, IERR )
      ELSEIF( CHOPT .EQ. 's' ) THEN
        DT = RCONV( YOSTR, ISTR, IERR )
      ELSEIF( CHOPT .EQ. 'm' ) THEN
        FACT = RCONV( YOSTR, ISTR, IERR )
      ELSEIF( CHOPT .EQ. 'e' ) THEN
        NEOF = ICONV( YOSTR, ISTR, IERR )
        NCEOF = ICONV( YOSTR, ISTR, IERR )
      ELSEIF( CHOPT .EQ. 'i' ) THEN
        YNAMI = YOSTR
      ELSEIF( CHOPT .EQ. 'o' ) THEN
        YNAMOB = YOSTR
      ENDIF
      IF( IERR .NE. 0 )   CALL HELPAR( 3, YOPARM, IC )

      LOOARG = .FALSE.
      GOTO 1200
C
C*    2.7 Non-option arguments expected (up to 4 strings seperated by
C*        blank(s)):
C*
C*    Filter parameters (real or integer)
C
 1400 CONTINUE
      JARG = JARG + 1
      ISTR = 0
      WRITE( YOSTR, '(60X)' )

 1410 CONTINUE
      IF( IC .GT. 121 )   GOTO 1600
      CH = YOPARM( IC:IC )
      IF (CH .EQ. '.') LINT=.FALSE.
      IF( CH .EQ. ' ' )  THEN
        IC = IC - 1
        GOTO 1430
      ENDIF
      ISTR = ISTR + 1
      IF ( ISTR .GT. 60 )  CALL HELPAR( 5, YOPARM, IC )
      YOSTR( ISTR:ISTR ) = CH
      IC = IC + 1
      IF( IC .GT. 121 )   GOTO 1600
      GOTO 1410

 1430 CONTINUE
      IF    ( JARG .EQ. 1 ) THEN
         IF (LINT) THEN
            PMIN = ICONV( YOSTR, ISTR, IERR )
         ELSE
            PMIN = RCONV( YOSTR, ISTR, IERR )
         END IF
      ELSEIF( JARG .EQ. 2 ) THEN
         IF (LINT) THEN
            P2 = ICONV( YOSTR, ISTR, IERR )
         ELSE
            P2 = RCONV( YOSTR, ISTR, IERR )
         END IF
      ELSEIF( JARG .EQ. 3 ) THEN
         IF (LINT) THEN
            P1 = ICONV( YOSTR, ISTR, IERR )
         ELSE
            P1 = RCONV( YOSTR, ISTR, IERR )
         END IF
      ELSEIF( JARG .EQ. 4 ) THEN
         IF (LINT) THEN
            PMAX = ICONV( YOSTR, ISTR, IERR )
         ELSE
            PMAX = RCONV( YOSTR, ISTR, IERR )
         END IF
      ELSE
         CALL HELPAR( 4, YOPARM, IC )
      ENDIF
      IF( IERR .NE. 0 )   CALL HELPAR( 6, YOPARM, IC )

      GOTO 1200
C
C*    2.8 End of parameter string scanning
C
 1600 CONTINUE
C
C*    2.9 Open input file and pre-read (which might alter *NTS*, *NTO*)
C
      OPEN( JPUNIR, IOSTAT=IOS, ERR=3030, FILE=YNAMI,
C      OPEN( JPUNIR, IOSTAT=IOS, ERR=3030,
     *              FORM='UNFORMATTED', STATUS='OLD' )
 3030 IF( IOS .NE. 0 ) THEN
        CALL HELP( 6, 2, 0, LEVPRI )
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF

      CALL PREREAD( IERR )
      IF( IERR .NE. 0 ) THEN
        CALL HELP( 5, 0, 0, LEVPRI )
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF
C
C*    3. Print out parameters for reference.
C        (They may be referenced for finding input errors, too.)
C
      CALL BOXIT(TITLE,1,80)
      PRINT 4127
 4127 FORMAT(1H0,40('*'),/,
     * 1X,11('*'),' INPUT PARAMETERS ',11('*'),/,1X,40('*'))
 4128 FORMAT(1X,40(1H*))
 4201 FORMAT(3H * ,A36,2H *)
 4202 FORMAT(3H * ,A27,1E9.4,2H *)
 4203 FORMAT(3H * ,A29,1I7,2H *)
 4204 FORMAT(19H *         ------> ,1A4,10X,F6.1,2H *)
 4205 FORMAT(3H * ,A21,A15,2H *)

      PRINT 4203,'NUMBER OF TIME SERIES        ',NTS
      PRINT 4203,'LENGTH OF TIME SERIES        ',NTO
      PRINT 4203,'NUMBER OF CHUNKS             ',NC
      PRINT 4202,'MULTIPLICATION FACTOR      '  ,FACT
      IF(LEVPRI)THEN
            PRINT 4201,'PRINTER OUTPUT                  HIGH'
         ELSE
            PRINT 4201,'PRINTER OUTPUT                   LOW'
            ENDIF
      IF(LNORM) THEN
            PRINT 4201,'NORMALISATION                     ON'
         ELSE
            PRINT 4201,'NORMALISATION                    OFF'
            ENDIF
      IF(LTREND)THEN
            PRINT 4201,'TREND FILTERING                   ON'
         ELSE
            PRINT 4201,'TREND FILTERING                  OFF'
            ENDIF
      IF(LTFILT )THEN
            PRINT 4201,'TIME FILTERING                    ON'
            PRINT 4204,'PMIN',PMIN
            PRINT 4204,'P2  ',P2
            PRINT 4204,'P1  ',P1
            PRINT 4204,'PMAX',PMAX
         ELSE
            PRINT 4201,'TIME FILTERING                   OFF'
            ENDIF
      IF(LPOPS)THEN
            IF(LTURN)THEN
               PRINT 4201,'STATISTICALLY ORTHOGONAL TURNING  ON'
            ELSE
               PRINT 4201,'STATISTICALLY ORTHOGONAL TURNING OFF'
            ENDIF
      END IF
      IF (LPOPS .OR. LEOFS) THEN
            PRINT 4203,'NUMBER OF EOFS               ',NEOF
      END IF
      IF(LCEOF)THEN
            IF(LTURN)THEN
                 PRINT 4201,'TURNING OF CEOFS                  ON'
               ELSE
                 PRINT 4201,'TURNING OF CEOFS                 OFF'
                 ENDIF
            PRINT 4203,'NUMBER OF COMPLEX EOFS       ',NCEOF
            ENDIF
      PRINT 4128
      PRINT*
C
C*    4. Set dimensions and variables, check validity and output them
C
      LFILT = LTFILT .OR. LNORM .OR. LTREND
C     IF ( NEOF .EQ. 0  .OR.  NEOF .GT. MIN0( NTS, NTO )  )
C    *     NEOF = MIN0( NTS, NTO )
      IF ( NEOF .GT. MIN0( NTS, NTO) ) NEOF = MIN0( NTS, NTO )
C     IF ( NCEOF .EQ. 0  .OR.  NCEOF .GT. MIN0( NTS, NTO )  )
C    *     NCEOF = MIN0( NTS, NTO )
      IF ( NCEOF .EQ. 0  .OR.  NCEOF .GT. MIN0( NTS, NTO )  )
     *     NCEOF = MIN0( NTS, NTO )

      IF( MIN0( NTS, NTO, NC, NCEOF ) .LE. 0 .OR. NEOF .LT. 0 ) THEN
        CALL HELP( 4, 0, 0, LEVPRI )
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF

      CALL SETDIM
C
C*    4.1 Dimension checks (necessary for static field lengths only)
C
      IF( NTS .GT. NTSDIM )  THEN
        CALL HELP(1,NTSDIM,NTS,LEVPRI)
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF
      IF( MAX0( NEOF, NCEOF) .GT. NEODIM ) THEN
        CALL HELP(2,NEODIM,0,LEVPRI)
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF
      IF (NTO .GT. NSER)  THEN
        CALL HELP( 3, NSER, NTO, LEVPRI)
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF
C
C*    5. Open output files.
C
      PRINT 5902, YNAMI
      DO 5050 JUN = 1,NFILES
        IF( JUN .EQ. 12  .AND.  .NOT. LCEOF )   GOTO 5050
C
C       Complete *JUN*-th filename by shifting *YNAMO(JUN)*
C       to the right while inserting the user-defined name base
C       from the left. Delete leading blanks afterwards.
C
        DO 5035 J=1,JPLNAM
          IF( YNAMOB(J:J) .EQ. ' ' )   GOTO 5036
          YWORK(1:JPLNAM-J+1) = YNAMO(JUN)(J:JPLNAM)
          YNAMO(JUN)(J+1:JPLNAM) = YWORK(1:JPLNAM-J+1)
C          YNAMO(JUN)(J+1:JPLNAM) = YNAMO(JUN)(J:JPLNAM)
          YNAMO(JUN)(J:J) = YNAMOB(J:J)
 5035   CONTINUE
 5036   CONTINUE

        PRINT 5901, 30+JUN, YNAMO(JUN)(1:INDEX(YNAMO(JUN),' ')-1)

        OPEN( 30+JUN, IOSTAT=IOS, ERR=5100, FILE=YNAMO(JUN),
C        OPEN( 30+JUN, IOSTAT=IOS, ERR=5100,
     *                FORM='UNFORMATTED', STATUS=YPSTAT )
 5050 CONTINUE

 5100 IF( IOS .NE. 0 ) THEN
        CALL HELP( 6, 3, 0, LEVPRI )
        PRINT*, 'FATAL ERROR IN SUBROUTINE PARSIN - SEE OUTPUT'
        STOP
      ENDIF

 5901 FORMAT(3H * ,'LOGICAL UNIT NO.',I3,' - SYSTEM NAME:  ', A)
 5902 FORMAT(3H * ,'INPUT NAME: ',A )

      RETURN
      END
C
C==== END PARSIN ==============================================================
C
C
C==== BEGIN HELPAR( U0101 ) ===================================================
C
      SUBROUTINE HELPAR( KH, YAP, KC )

      CHARACTER    YAP*121,   YOHAT*121

      WRITE( YOHAT, '(121X)' )
      IF( KC .GE. 1 .AND. KC .LE. 121 )   YOHAT( KC:KC ) = '^'
      PRINT *, YAP
      PRINT *, YOHAT( 1:KC )

      GOTO( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ), KH
 1    PRINT *, ' HELPAR(1): Minus sign expected'
      GOTO 9000
 2    PRINT *, ' HELPAR(2): Word too long (60 characters max.)'
      GOTO 9000
 3    PRINT *, ' HELPAR(3): Error in converting string to number'
      GOTO 9000
 4    PRINT *, ' HELPAR(4): Only 4 filter parameters are allowed'
      GOTO 9000
 5    PRINT *, ' HELPAR(5): Argument too long (60 characters max.)'
      GOTO 9000
 6    PRINT *, ' HELPAR(6): Error in converting string to real ',
     *            'number '
      GOTO 9000
 7    GOTO 9000
 8    GOTO 9000
 9    PRINT *, ' HELPAR(9): Illegal option letter'
      GOTO 9000
 10   GOTO 9000

 9000 CONTINUE
      STOP 'HELPAR'
      END
C
C==== END HELPAR ==============================================================
C
C
C==== BEGIN SETDIM ( U0102 ) =================================================
C
      SUBROUTINE SETDIM
C
C**** *SETDIM* - ROUTINE TO DEFINE DIMENSION VARIABLES
C 
C     G. HANNOSCHOECK,    20/11/90
C
C     This procedure is designed for defining dimensions on systems allowing
C     dynamical field lengths like CRAY 2.
C
C     If you want to run the program on systems requiring the standard FORTRAN
C     dimensioning, you have to make *SETDIM* an empty procedure. Look
C     also for the changes in the include file "scalars.i".
C
C     Don't include 'arrays.i' here!
C
C      include 'scalars.i'

C      NTSDIM = NTS
C      NSER = NTO

C      IF (NEOF .GT. 0) THEN
C         NEODIM = NEOF
C      ELSE
C         NEODIM = NTS
C      END IF

      RETURN

      END

C
C==== END SETDIM =============================================================
C
C
C==== BEGIN PREREAD ( U0103 ) =================================================
C
      SUBROUTINE PREREAD( IERR )
C
C**** *PREREAD* - SUBROUTINE TO PRE-READ DATA FOR DETERMINING
C                 NO. OF TIME STEPS AND NO. OF SPACE POINTS
C
C     G. HANNOSCHOECK      26/11/90
C
C     The number of time steps, *NTO* is found by reading the data file until
C     bumping against its end. *NTO* might be reduced if it does not fit into
C     the NAG library routines. If so, *PREREAD* reads the first time steps
C     away rather than the last ones being better for predictive purposes
C     (Hans von Storch, comment in an earlier version).
C
C     *NTS* is found as the maximum of record lengths *ILEN* over all
C     record headers.
C
C     *NTO* and *NTS* are reduced here if the user has chosen smaller values!
C
C     PARAMETER:
C
C     *IERR*     If not zero on output, an error or inconsistency has occurred.
C
      include 'scalars.i'
C
C     Read data file to count its records (in T21, two records for one date)
C
C     TIME SERIES LENGTH *NTO* IS SET TO NUMBER OF RECORDS FOUND
C
      IERR = 0
      REWIND JPUNIR
      INTO = 0
      INTS = 0

 1010 CONTINUE
      READ( JPUNIR, END=1017, ERR=1013 ) IDATE, IVAR, ILEV, ILEN
      READ( JPUNIR, END=1017, ERR=1013 )
      INTO = INTO + 1
      INTS = MAX0( INTS, ILEN )
      GOTO 1010

 1013 CONTINUE
      IERR = 1

 1017 CONTINUE
      IF( IERR .NE. 0 .OR. MIN0( INTO, INTS ) .EQ. 0 ) THEN
        IERR = 1
        RETURN
      ENDIF
      REWIND JPUNIR

      CALL BOXIT(TITLE,1,80)
      PRINT '(A,I7,/)', '0NUMBER OF TIME SERIES IN FILE: ', INTS
      PRINT '(A,I7,/)', '0LENGTH OF TIME SERIES IN FILE: ', INTO
      PRINT *
C
C     Adjust empirically found parameters to user input.
C
      IF( NTO .EQ. 0 )  NTO = INTO
      IF( NTS .EQ. 0 )  NTS = INTS
      NTO = MIN0( NTO, INTO )
      NTS = MIN0( NTS, INTS )
C
C     IF MAXIMUM PRIME FACTOR IS LARGER THAN 19 (AS REQUIRED BY *NAGLIB*
C     *C06FBF*) *NTO* IS ITERATIVELY REDUCED BY 1, UNTIL MPF OF NEW
C     *NTO* IS LESS THAN 20.
C     For each reduction, a set of data is read in advance.
C
      IREC = 0
 1120 CONTINUE
         IF ( MAXPRI( NTO ) .LE. 19 ) GOTO 1130
         IREC=IREC+1
C
C        IF FIRST TIME NTO REDUCED, GIVE HELP TEXT.
C
         READ( JPUNIR, END=1130 )
         READ( JPUNIR, END=1130 )
         IF (IREC.EQ.1) THEN
           CALL HELP( 51, 0, 0, LEVPRI )
         ENDIF
         NTO = NTO - 1
         PRINT '(A,I4)', ' TIME SERIES LENGTH REDUCED; NEW =',NTO
         GOTO 1120

 1130 CONTINUE

      RETURN
      END
C
C==== END PREREAD =============================================================
C
C


C==== BEGIN FILTTS ( U02 ) ====================================================
C
      SUBROUTINE FILTTS( DAT, LGAP, MDATE, VAR )
C
C**** *FILTTS* - FILTER TIME SERIES.
C
C     MODIFIED BY F.G. GALLAGHER 23/7/87 - MOVED FROM *POPRO* TO SUBROUTINE.
C
C     PURPOSE.
C     --------
C
C     *FILTTS* FILTERS THE TIME SERIES AND NORMALIZES IT,
C     IF LOGICAL SWITCH *LNORM* IS TRUE.
C
C     The data matrix *DAT* has no gap codes any more after subtracting
C     means. But the gaps are re-written on the output file.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *FILTTS*      (NORMALLY FROM *POPRO*).
C
C     METHOD.
C     -------
C
C     CALCULATES THE FINITE FOURIER TRANSFORM OF THE DATA AND REMOVES
C     UNWANTED FREQUENCIES BY MULTIPLICATION WITH A FILTER WINDOW
C     CALCULATED FROM THE GIVEN PARAMETERS.
C
C
C     EXTERNALS.
C     ----------
C
C     *FILGEW*  - SUBROUTINE TO CALCULATE FILTER WEIGHTS.
C     *DTREND* - SUBROUTINE TO REMOVE TREND

      include 'scalars.i'
      include 'arrays.i'
C
      IF(LEVPRI) THEN
            CALL BOXIT(TITLE,1,80)
            WRITE(TTXT,'(A80)') 'FILTERING'
            CALL BOXIT(TTXT,0,40)
            ENDIF
C
C
C     ------------------------------------------------------------
C
C          1. CALCULATION OF FILTER WEIGHTS.
C             ----------- -- ------ --------
C
      IF (LTFILT) THEN
          CALL FILGEW(FILT,NTO,PMAX,P1,P2,PMIN,NF,X,TS2,LEVPRI,NLAG)
      ENDIF
C
C     ------------------------------------------------------------
C
C*         2. FILTERING TIME SERIES.
C             --------- ---- -------
C

C
C*         2.2 REPEAT FOR ALL GRIDPOINTS.
C


      DO 2200 I = 1,NTS

C          2.2.1 MAKE A WORKING COPY OF *DAT*.

            DO 2201 J = 1,NTO
              TS1( J ) = DAT(I,J)
 2201       CONTINUE

C
C*         2.2.2 CALCULATE MEAN AND SUBTRACT FROM TIME SERIES.
C
            RMEAN = 0.
            NSUM = 0
            DO 2210 J=1,NTO
              IF( .NOT. LGAP( I, J ) ) THEN
                RMEAN = RMEAN + TS1( J )
                NSUM = NSUM + 1
              ENDIF
 2210       CONTINUE

            IF( NSUM .GT. 0 ) THEN
              RMEAN = RMEAN / NSUM
            ELSE
              RMEAN = 0.0
            ENDIF

            DO 2215 J=1,NTO
              IF( LGAP( I, J ) )   THEN
                TS1( J ) = 0.0
              ELSE   
                TS1(J) = TS1(J) - RMEAN
              ENDIF
 2215       CONTINUE

C
C*          2.2.3 TREND-FILTERING
C
            IF(LTREND) CALL DTREND(TS1,NTO)
C
C*          2.2.4 FILTERING
C

C
C           FILT(1)  MEAN VALUE
C           FILT(2)  FUNDAMENTAL FREQUENCY
C           FILT(NF) NYQUISTFREQUENCY  (NF=N/2+1)

C
C           IF FILTERING HAS BEEN SELECTED,
C
            IF (LTFILT) THEN
C
C           C06FAF CALCULATES THE DISCRETE FOURIER TRANSFORM OF A HERMITIAN
C           SEQUENCE OF N REAL DATA VALUES
C
              IFAIL=0
              CALL C06FAF(TS1,NTO,TS2,IFAIL)
              TS1(1) =TS1(1) *FILT(1)
              TS1(NF)=TS1(NF)*FILT(NF)
              IF(MOD(NTO,2).NE.0) TS1(NF+1)=TS1(NF+1)*FILT(NF)
              DO 2230 II=2,NF-1
                   TS1(II) =TS1(II) *FILT(II)
                   J=NTO+2-II
                   TS1(J) =TS1(J) *FILT(II)
 2230         CONTINUE
C
C             C06GBF FORMS THE COMPLEX CONJUGATE OF A HERMITIAN SEQUENCE
C             OF N DATA VALUES
C
              CALL C06GBF(TS1,NTO,TS2)
C
C             C06FBF CALCULATES THE DISCRETE FOURIER TRANSFORM OF A        AN
C             HERMITIAN SEQUENCE OF N COMPLEX DATA VALUES
C
              CALL C06FBF(TS1,NTO,TS2,IFAIL)
            ENDIF
C
C*          2.2.5 COPY *TS1* TO *DAT* (now zeroes in gap positions).
C
            DO 2250 J = 1,NTO
                  DAT(I,J) = TS1(J)
 2250       CONTINUE

 2200 CONTINUE
C
C*           2.2.3.1 CALCULATE VARIANCES/NORMALISE OF DATA
C
            CALL VARIAN( DAT, VAR )
C
C*          2.2.4 Write to tape data matrix as prepared for analysis.
C
            IUNIT = 1
            CALL OUTMAT( IUNIT, LGAP, MDATE, NSER,
     *                   -9999, 0, 0, NTS, WORK1,
     *                   DAT, NTSDIM, NSER, NTO, .TRUE. )

      RETURN
      END
C
C==== END FILTTS ==============================================================
C
C
C==== BEGIN FILGEW ( U0201 ) ==================================================
C
      SUBROUTINE FILGEW(FILT,N,PMAX,P1,P2,PMIN,NF,X,TS2,LEVPRI,NLAG)
C
C**** *FILGEW* - ROUTINE TO CALCULATE FILTER WEIGHTS FOR *FILTER*.
C
C     T. BRUNS, MPIFM             01/02/87
C     MODIFIED BY F.G. GALLAGHER  20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *FILGEW* CALCULATES THE FILTER WEIGHTS FOR GIVEN 'FILTER PARAMETERS'
*     AS REQUIRED BY SUBROUTINE *FILTTS*.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *FILGEW(FILT,N,PMAX,P1,P2,PMIN,NF,X,TS2)*
C
C            *FILT*    - FILTER WEIGHTS.
C            *N*       - DIMENSION FOR ARRAYS.
C            *PMAX*    - )
C            *P1*      - )
C            *P2*      - ) FILTER CHARACTERISTICS.
C            *PMIN*    - )
C            *NF*      - NYQUIST FREQUENCY.
C            *X*       - WORKING COPY OF *FILT*.
C            *TS2*    - WORKSPACE
C
C     METHOD.
C     -------
C
C     FILT(TIME SCALE) = 0  IF TIME SCALE > PMAX
C                           OR TIME SCALE < PMIN
C                      = 1  IF P2 < TIME SCALE < P1
C            = COSINE DECAY IF P2 < TIME SCALE < PMIN
C            = COSINE DECAY IF P1 < TIME SCALE < PMAX
C                      = 0  IF TIME SCALE = OO
C     SPECIAL CASE: RECTANGULAR FILTER
C                         -->  P2 = PMIN
C                         -->  P1 = PMAX
C     SPECIAL CASE: NO FILTER
C                         -->  P2 = PMIN = 1.
C                         -->  P1 = PMAX = 2.*N
C
C     EXTERNALS.
C     ----------
C
C     *C06FBF* - *NAG* ROUTINE TO FORM THE COMPLEX CONJUGATE
C                OF A HERMITIAN SEQUENCE.
C     *C06GBF* - *NAG* ROUTINE TO CALCULATE THE DISCRETE FOURIER
C                TRANSFORM OF A HERMITIAN SEQUENCE.
C
C
C     REFERENCE.
C     ----------
C
C     NONE.
C
      REAL FILT(N),X(N),TS2(N)
      LOGICAL LPR,LEVPRI
C
C*    Set default values if not explicitly defined by the user.
C
      IF( PMIN .EQ. -1. )   PMIN = 2.
      IF( P2   .EQ. -1. )   P2   = PMIN
      IF( PMAX .EQ. -1. )   PMAX = 2.*N
      IF( P1   .EQ. -1. )   P1   = PMAX

      IF(LEVPRI)
     *PRINT 100, '0TIME FILTER CHARACTERISTICS:',
     *             ' TIME SCALES > ',PMAX,' AND < ',PMIN,
     *             ' FILTERED OUT'
      NF  = N/2 + 1
      PI  =4.*ATAN(1.)
      FMIN=1./PMIN
      FMAX=1./PMAX
      F1  =1./P1
      F2  =1./P2
      DO 1010 I = 0,NF-1
            F=FLOAT(I)/FLOAT(N)
            IF(I.EQ.0) THEN
                  P=2.*N
               ELSE
                  P=1./F
               ENDIF
            FILT(I+1) = 1.
            IF(P.LT.PMIN .OR.P.GT.PMAX) FILT(I+1) = 0.
            IF(P.GE.PMIN.AND.P.LT.P2)
     *            FILT(I+1) = (1.+COS(PI*(F-F2)/(FMIN-F2))) / 2.
            IF(P.LE.PMAX.AND.P.GT.P1)
     *            FILT(I+1) = (1.-COS(PI*(F-FMAX)/(F1-FMAX))) / 2.
 1010       CONTINUE

C
C     PRINT OUT RESULTS
C
      IF(LEVPRI) THEN
      LPR = .TRUE.
      DO 1015 I=0,NF-1
            F=FLOAT(I)/FLOAT(N)
            IF(I.EQ.0) THEN
                  P=2.*N
               ELSE
                  P=1./F
               ENDIF
            IF(FILT(I+1).GT.0.) THEN
                  IF (I .GE. 1) THEN
                        IF (FILT(I) .EQ. 1.0000) LPR=.FALSE.
                        ENDIF
                  IF (I .LT. NF-1) THEN
                        IF (FILT(I+2) .NE. 1.0000) THEN
                            IF(.NOT.LPR) PRINT *, 'REPEAT UNTIL'
                            LPR = .TRUE.
                            ENDIF
                        ELSE
                            IF(.NOT.LPR) PRINT *, 'REPEAT UNTIL'
                            LPR = .TRUE.
                            ENDIF
                  IF (LPR) PRINT 200, I, F ,P, FILT(I+1)
                  ENDIF
 1015       CONTINUE

      PRINT '(34H1EQUIVALENT DIGITAL FILTER WEIGHTS,//)'
      ENDIF

      DO 1050 I = 1,N
            X(I)=0
 1050       CONTINUE

      X(1) = FILT(1)
      X(NF)= FILT(NF)
      DO 2000 I=2,NF-1
            X(I) = FILT(I)
 2000       CONTINUE
C
C C06GBF FORMS THE COMPLEX CONJUGATE OF A HERMITIAN SEQUENCE
C OF N DATA VALUES
C
      IFAIL=0
      CALL C06GBF(X,N,TS2)
C
C C06FBF CALCULATES THE DISCRETE FOURIER TRANSFORM OF A HERMITIAN
C SEQUENCE OF N COMPLEX DATA VALUES
C
      IFAIL = 0
      CALL C06FBF(X,N,TS2,IFAIL)

      IF(IFAIL.EQ.1) PRINT 300
      IF(IFAIL.EQ.2) PRINT 400
      IF(IFAIL.EQ.3) PRINT 500
      IF (IFAIL.GT.2) THEN
	 PRINT*, 'SEE OUTPUT'
	 STOP
      END IF
      SQN  = SQRT(1.*N)
      NLAG = MIN0(51,NF+1)

      IF(LEVPRI) THEN
      DO 3000 LAG=1,NLAG
      X(LAG)=X(LAG)/SQN
            PRINT '(I5,F8.4)', LAG-1,X(LAG)
 3000       CONTINUE
            ENDIF
C
C     EDFW
C


  100 FORMAT(A,/,A,F6.1,A,F6.1,A,//,' FILTER CHARACTERISTICS',/,
     *  ' COMPT',T13,'FREQ',T25,'PERIOD',T33,'WEIGHT',/)
  200 FORMAT(1X,I5,F12.3,F12.1, F8.4)
  300 FORMAT(3X,'ONE OF THE PRIME FACTORS OF N IS > 19')
  400 FORMAT(3X,'N HAS MORE THAN 20 PRIME FACTORS     ')
  500 FORMAT(3X,'N IS LESS OR EQUAL 1                 ')
      RETURN
      END
C
C==== END FILGEW ==============================================================
C
C
C==== BEGIN DTREND ( U0202 ) ==================================================
C
      SUBROUTINE DTREND(X,N)
C
C**** *DTREND* -  TREND-FILTER TIME SERIES.
C
C     I. FISCHER-BRUNS, MPIFM      24/06/87
C     MODIFIED BY F.G. GALLAGHER   23/07/87  - REORGANISATION AND COSMETIC
C                                                                 CHANGES
C
C     PURPOSE.
C     --------
C
C     TREND-FILTER A TIME SERIES *X(N)*.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *DTREND(X,N)*
C
C            *X(N)*  - TIME SERIES.
C
C     METHOD.
C     -------
C
C     COMPUTES THE GRADIENT OF TREND LINE BY LEAST SQUARES METHOD
C        AND SUBTRACTS FROM GIVEN TIME SERIES,.
C

      REAL X(N)
C
C     GRADIENT OF TREND LINE
C
      ZEIMI = 0.5 * N
      ANEN = 0.
      ZAE  = 0.
      DO 1010 I = 1,N
            ANEN = ANEN + (I-ZEIMI)**2
            ZAE = ZAE + (I-ZEIMI) * X(I)
 1010       CONTINUE
      STEI = ZAE / ANEN
C
C     TREND REMOVED FROM TIME SERIES
C
      DO 2010 I=1,N
            X(I) = X(I) -  (I-ZEIMI)*STEI
 2010       CONTINUE

      RETURN
      END
C
C==== END DTREND ==============================================================
C
C
C==== BEGIN VARIAN ( U0203 ) ==================================================
C
      SUBROUTINE VARIAN( DAT, VAR )
C
C**** *VARIAN* - COMPUTES VARIANCE AND MEAN FROM TIME SERIES
C
C     I. FISCHER-BRUNS, MPIFM      01/02/87
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *VARIAN* COMPUTES THE MEAN AND VARIANCE OF TIME SERIES AND SUBTRACTS THE
C     MEAN FROM THE TIME SERIES.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *VARIAN*
C
      include 'scalars.i'
      include 'arrays.i'

C
C
C     SET  ELEMENTS OF *VAR* AND *XM* TO ZERO.
C

      IF(LEVPRI) THEN
        CALL BOXIT(TITLE,1,80)
        PRINT 100
      ENDIF

      CALL ZERO(VAR,NTSDIM)
      CALL ZERO(XM ,NTSDIM)

      DO 1010 ITS=1,NTS
            DO 1100 IT=1,NTO
                  XM(ITS)  = XM(ITS)  + DAT(ITS,IT)
                  VAR(ITS) = VAR(ITS) + DAT(ITS,IT)**2
 1100             CONTINUE

            XM(ITS)  = XM(ITS) /NTO
            VAR(ITS) = VAR(ITS)/NTO - XM(ITS)*XM(ITS)
            DO 1200 IT=1,NTO
                  DAT(ITS,IT) = DAT(ITS,IT) - XM(ITS)
 1200             CONTINUE

            IF (LNORM) THEN
                  SQ=SQRT(VAR(ITS))
                  IF(SQ.GT.0.) THEN
                        DO 1310 JTIME=1,NTO
                              DAT(ITS,JTIME)=DAT(ITS,JTIME)/SQ
 1310                         CONTINUE
                        ENDIF
                  ENDIF

            IF(LEVPRI)
     *            PRINT 200, ITS, XM(ITS), VAR(ITS)
 1010 CONTINUE

C
C     OUTPUT OF VARIANCES (with *KDATE* = -1 for identification on file)
C
      IUNIT = 2
      CALL OUTDAT( IUNIT, -1, 0, 0, NTS, VAR )

      RETURN


  100 FORMAT('0SUBROUTINE VARIAN: ',
     *       'COMPUTES VARIANCE OF FILTERED DATA ',
     *       '(BEFORE ANY NORMALISATION)',//,
     *    //,' ESTIMATION OF 1ST AND 2ND MOMENT:',//,
     *       ' COMPONENT        MEAN',
     *       '        VARIANCE')
  200 FORMAT(I10,3X,2(E13.6,3X))
      END
C
C==== END VARIAN ==============================================================
C
C


C==== BEGIN POPAN ( U03 ) =====================================================
C
      SUBROUTINE POPAN( DAT, LGAP, LHOLE, VAR )
C
C**** *POPAN* - PRINCIPAL OSCILLATION PATTERN ANALYSIS,
C               STATIONARY CASE.
C
C     H. V.STORCH,      MPIFM      15/09/86
C     MODIFIED BY I. FISCHER-BRUNS 01/02/87
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *POPAN* CALCULATES POP'S FOR THE STATIONARY CASE.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *POPAN*
C
C     METHOD.
C     -------
C
C     CALCULATES THE EIGENVECTORS (POP'S) OF A MATRIX DESCRIBED BY THE
C     PRODUCT OF THE LAG-1-COVARIANCE MATRIX AND THE INVERSE OF THE
C     LAG-0-COVARIANCE MATRIX
C
C     EXTERNALS.
C     ----------
C
C     *POPS*    - SUBROUTINE TO COMPUTE POPS.
C     *PRCOMP*  - SUBROUTINE TO COMPUTE PRINCIPAL COMPONENTS.
C     *TSEOFS*  - SUBROUTINE TO COMPUTE EOFS.
C
C     REFERENCE.
C     ----------
C     HASSELMANN, K., 1984: PRINCIPAL OSCILLATION PATTERNS.
C         MPI INTERNAL NOTES, 21 APRIL 1984.
C
C     V.STORCH, H. ET AL., 1987: PRINCIPAL OSCILLATION PATTERN ANALYSIS
C         OF THE 30-60 DAY OSCILLATION IN A GCM EQUATORIAL TROPOSHPERE.
C         SUBM. TO JGR
C
C     JENKINS, G.M. AND WATTS, D.G., 1968: SPECTRAL ANALYSIS AND ITS
C         APPLICATIONS. HOLDEN-DAY, SAN FRANCISCO.
C
C

      include 'scalars.i'
      include 'arrays.i'
C
C     ------------------------------------------------------------
C
C*    1. COMPUTE EOFS.
C
      IF (NUMGAP .GT. 0.) THEN
         CALL TSEOFS( DAT, LGAP, LHOLE, VAR, DVECT, EOFS )
      ELSE
         CALL TSEOFS0(DAT, LGAP, LHOLE, VAR, DVECT, EOFS )
      END IF
C
C*    2. COMPUTE PRINCIPAL COMPONENTS and their spectra.
C
      CALL PRCOMP( DAT, LGAP, VAR, DVECT, EOFS, PC )
      IF (NEOF .GT. 0) THEN
         CALL SPEC( 1, DVECT, PC, POPC, POPPER, TEFOLD )
      END IF
C
      IF (LEOFS) RETURN
C     ------------------------------------------------------------
C
C*    3. COMPUTE POPS.
C
      CALL POPS( DAT, LGAP, LHOLE, VAR, DVECT, EOFS, PC,
     *           POP, POPC, POPPER, TEFOLD )
C
C     ------------------------------------------------------------
C
C*    4. COMPUTE STATISTICS FOR POPS.
C
      CALL STATS( PC, POP, POPC, POPPER )
C
C     -------------------------------------------------------------
C
C*    5. COMPUTE (CROSS) SPECTRUM OF POP COEFFICIENT TIME SERIES.
C
      CALL SPEC( 2, DVECT, PC, POPC, POPPER, TEFOLD )
C
C     --------------------------------------------------------------
C
      RETURN
      END
C
C==== END POPAN ===============================================================
C
C
C==== BEGIN TSEOFS ( U0301 ) ==================================================
C
      SUBROUTINE TSEOFS( DAT, LGAP, LHOLE, VAR, DVECT, EOFS )

C
C**** *TSEOFS* - COMPUTES *EOF'S* AND ASSOCIATED EIGENVALUES.
C
C     H. V.STORCH,      MPIFM      15/09/86
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *TSEOFS* COMPUTES EOF'S AND ASSOCIATED EIGENVALUES FROM TIME
C     SERIES. If there are less time instants than space points,
C     the eigenvectors are computed from the smaller matrix,
C     cf. v. Storch and Hannosch”ck, 1984: Bull. Amer. Meteor. Soc., No. 65,
C     p. 162.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *TSEOFS*
C
C     METHOD.
C     -------
C
C     IF NEOF <= 0   NO EOF ANALYSIS, I.E. EOFS = UNITY VECTORS
C
C     EXTERNALS.
C     ----------
C
C     *F02ABF*  - *NAGLIB* ROUTINE TO COMPUTE E'VECTORS AND E'VALUES.
C     TAPE 1    - OUTPUT, FIRST THREE EIGENVALUES AND EOFS FOR PLOT
C                 (SAME FILE IS USED BY *POPS*).
C
C
      include 'scalars.i'
      include 'arrays.i'

      REAL ROOTS( NTSDIM ), PLANTS( NTSDIM ), A1(NTSDIM,NTSDIM)

      IF(LEVPRI) THEN
        CALL BOXIT(TITLE,1,80)
        PRINT 100
      ENDIF
      CALL ZERO( DVECT, NTSDIM )
      CALL ZERO( EOFS, NTSDIM*NTSDIM )

C
C*    0. If NEOF <= 0 no EOF analysis is performed. The EOFs are set to the
C        unit vectors and the computation of eigenvalues/vectors is skipped.
C        Set those components of all EOFs to zero for which no observation
C        was available at all. 
C
      IF (NEOF .LE. 0 ) THEN
         DO 102 I=1,NTS
            IF (.NOT. LHOLE(I)) EOFS(I,I) = 1.
 102     CONTINUE
         PRINT*,'     ---------------------------------------    '
         PRINT*,' ... ATTENTION: NO EOF ANALYSIS IS PERFORMED !!!'
         PRINT*,'     ---------------------------------------    '
         RETURN
      END IF
C
C*    1. Compute matrix of which we'll get the eigenvectors.
C
      IF( NTO .GE. NTS                                .OR. 
     *    NUMGAP .GT. 0 .AND. .NOT. LFLIP ) THEN
C
C*    1.1 Normal flow of operation:
C         divide by *NTS* minus number of gaps in index pair.
C         If there remains nothing but gaps, set matrix element to zero.
C
        IRANK = NTS
        DO 1100 ITS1=1,IRANK

          DO 1105 IT=1,NTO
            TS1(IT) = DAT(ITS1,IT)
 1105     CONTINUE

          DO 1109 ITS2=1,IRANK
            IDIV = NTO
            DO 1108 IT = 1,NTO
              TS2(IT) = DAT(ITS2,IT)
              IF( LGAP(ITS1,IT) .OR. LGAP(ITS2,IT) )  IDIV = IDIV - 1
 1108       CONTINUE
            IF( IDIV .GT. 0 ) THEN
              A1(ITS1,ITS2) = RCCV(TS1,TS2,NTO,0) * NTO / IDIV
            ELSE
              A1(ITS1,ITS2) = 0.0
            ENDIF
 1109     CONTINUE
 1100   CONTINUE
C
C*    1.1.1 FIND EIGENVECTORS/VALUES.
C

C
C     *F02ABF*  - *NAGLIB* ROUTINE FOR FINDING E'VECTORS/VALUES OF
C                 A REAL SYMMETRIC MATRIX.

        IFAIL = 0

        CALL F02ABF( A1, NTSDIM, IRANK, DVECT, EOFS, NTSDIM, WORK1,
     *               IFAIL )

      ELSE
C
C*    1.2 The time series length *NTO* being less than *NTS*,
C         the smaller matrix with tilted *DAT* is rather used.
C         See the manual for further details.
C         Note that there will be no index overflow in *A1*/*EOFS* because of
C         *NTO* < *NTS* <= *NTSDIM*
C
        PRINT 101
        IRANK = NTO
        DO 1220 KS=1,NTS
          PLANTS(KS) = NTO
          DO 1210 KTIME=1,NTO
            IF( LGAP(KS,KTIME) )   PLANTS(KS) = PLANTS(KS) - 1.0
 1210     CONTINUE
C
C         As in 1.1, if there are no data at a space point, set contribution
C         to zero. This is done by huge numbers in denominators.
C
          IF( PLANTS(KS) .LT. 0.5 )   PLANTS(KS) = 1.E99
          ROOTS(KS) = SQRT( PLANTS( KS ) )
 1220   CONTINUE

        DO 1250 KTIME1=1,IRANK
          DO 1225 KS=1,NTS
C
C           Divide by *PLANTS* here rather than in inner loop.
C
            WORK1( KS ) = DAT( KS, KTIME1 ) / PLANTS( KS )
 1225     CONTINUE

          DO 1240 KTIME2=1,IRANK
            DO 1230 KS=1,NTS
              WORK5( KS ) = DAT( KS, KTIME2 )
 1230       CONTINUE
            A1( KTIME1, KTIME2 ) = RCCV( WORK1, WORK5, NTS, 0 ) * NTS
 1240     CONTINUE

 1250   CONTINUE
C
C*    1.2.1 Find eigenvectors and eigenvalues of alternate matrix.
C
        IFAIL = 0
        CALL F02ABF( A1, NTSDIM, IRANK, DVECT, EOFS, NTSDIM, WORK1,
     *               IFAIL)
C
C*    1.2.2 Construct space-based EOFs by multiplication with *DAT*
C           divided by the elements of *ROOTS*.
C           In the following, *TS1* stores the eigenvectors delivered
C           by *F02ABF* as workspace (indexed by time).
C
        DO 1280 KEV=1,NTO

          DO 1270 KTIME=1,IRANK
            TS1( KTIME ) = EOFS( KTIME, KEV )
 1270     CONTINUE

          DO 1275 KSPACE=1,NTS
            WORK1( KSPACE ) = 0.
            DO 1273 KTIME=1,IRANK
              WORK1( KSPACE ) = WORK1( KSPACE ) +
     *          DAT( KSPACE, KTIME ) / ROOTS(KSPACE) * TS1(KTIME)
 1273       CONTINUE
 1275     CONTINUE
C
C*      Normalise EOF to unit length
C
        SQ = SQRT( NTS * RCCV( WORK1, WORK1, NTS, 0 ) )
        DO 1279 KSPACE=1,NTS
          EOFS( KSPACE, KEV ) = WORK1( KSPACE ) / SQ
 1279   CONTINUE
 1280   CONTINUE
C
C*    1.2.3 Done! We're at the same state as reached in branch 1.1.
C           (Neglected are the effects of the covariance estimation
C           with the "roots" being only used in case 1.2.)
C
      ENDIF

C
C*    1.2.4 Set those components of all EOFs to zero for which no observation
C           was available at all. This is done here in order to count for
C           small errors in F02ABF which can occur because of a
C           singular cross covariance matrix and machine precision.

      DO 1290 IEOF=1,NTS
         DO 1290 JSPACE=1,NTS
            IF (LHOLE(JSPACE)) EOFS(JSPACE,IEOF) = 0.0
 1290 CONTINUE

C
C*    2. CHANGE ORDER OF EIGENVALUES TO DESCENDING VALUES.
c           (There are *IRANK* eigenvalues coming from the NAG routine.)
C
      DO 1300 ITS=1,NTS
         DO 1310 IEV = 1, IRANK
            WORK1(IEV) = EOFS(ITS, IRANK+1 - IEV)
 1310    CONTINUE
         DO 1320 IEV = 1, IRANK
            EOFS(ITS,IEV) = WORK1(IEV)
 1320    CONTINUE
 1300 CONTINUE

      CALL TROS( DVECT, IRANK )
C
C*    3. EIGENVALUE DIAGNOSIS
C
      CALL EVDIA( DVECT, NTS, NTS )

C
C
C*    4. OUTPUT TO TAPE
C
 4000 CONTINUE
C
C     OUTPUT OF EIGENVALUES AND EOFS
C
      IUNIT = 3
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, DVECT )

C
C     For EOFs in Euclidian space insert PPGAP for space points where
C     no observation was available (contents of EOFS is not changed).
      DO 4010 ISPACE=1,NTS
         IF (LHOLE(ISPACE)) THEN
            DO 4011 IEOF=1,NTS
               A1(ISPACE,IEOF) = PPGAP
 4011       CONTINUE
         ELSE
            DO 4012 IEOF=1,NTS
               A1(ISPACE,IEOF) = EOFS(ISPACE,IEOF)
 4012       CONTINUE
         END IF
 4010 CONTINUE
      CALL OUTMAT( IUNIT, LGAP, MDATE, NSER,
     *             0, 0, 0, NTS,  WORK1,
     *             A1, NTSDIM, NTSDIM, NEOF, .TRUE. )
C------------------------------------------------------------------------------

  100 FORMAT('0SUBROUTINE TSEOFS: TRANSFORM TIME SERIES IN EOF SPACE.')
  101 FORMAT(' SMALLER MATRIX IS USED FOR COMPUTING EIGENVECTORS!' /)
  140 FORMAT('0NO. OF EIGENVALUE',I4,' MAX. ERROR',E10.2)

      END
      SUBROUTINE TSEOFS0( DAT, LGAP, LHOLE, VAR, DVECT, EOFS )

C!!!! THIS IS SIMPLY A COPY OF TSEOFS BUT FOR THE CASE OF NO DATA GAPS !!!!!!!!
C     (Avoiding many of if's in the loops saves a huge amount of cpu time)
C
C**** *TSEOFS* - COMPUTES *EOF'S* AND ASSOCIATED EIGENVALUES.
C
C     H. V.STORCH,      MPIFM      15/09/86
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *TSEOFS* COMPUTES EOF'S AND ASSOCIATED EIGENVALUES FROM TIME
C     SERIES. If there are less time instants than space points,
C     the eigenvectors are computed from the smaller matrix,
C     cf. v. Storch and Hannoschoeck, 1984: Bull. Amer. Meteor. Soc., No. 65,
C     p. 162.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *TSEOFS*
C
C     METHOD.
C     -------
C
C     IF NEOF <= 0   NO EOF ANALYSIS, I.E. EOFS = UNITY VECTORS
C
C     EXTERNALS.
C     ----------
C
C     *F02ABF*  - *NAGLIB* ROUTINE TO COMPUTE E'VECTORS AND E'VALUES.
C     TAPE 1    - OUTPUT, FIRST THREE EIGENVALUES AND EOFS FOR PLOT
C                 (SAME FILE IS USED BY *POPS*).
C
C
      include 'scalars.i'
      include 'arrays.i'

      REAL PLANTSS, ROOTSS, A1(NTSDIM,NTSDIM)

      IF(LEVPRI) THEN
        CALL BOXIT(TITLE,1,80)
        PRINT 100
      ENDIF
      CALL ZERO( DVECT, NTSDIM )
      CALL ZERO( EOFS, NTSDIM*NTSDIM )
C
C*    0. If NEOF <= 0 no EOF analysis is performed. The EOFs are set to the
C        unit vectors and the computation of eigenvalues/vectors is skipped.
C
      IF (NEOF .LE. 0 ) THEN
         DO 99102 I=1,NTS
            EOFS(I,I) = 1.
99102    CONTINUE
         RETURN
      END IF

C
C*    1. Compute matrix of which we'll get the eigenvectors.
C
      IF( NTO .GE. NTS ) THEN
C
C*    1.1 Normal flow of operation:
C         divide by *NTS* minus number of gaps in index pair.
C         If there remains nothing but gaps, set matrix element to zero.
C
        IRANK = NTS
        DO 91100 ITS1=1,IRANK

          DO 91105 IT=1,NTO
            TS1(IT) = DAT(ITS1,IT)
91105    CONTINUE

          DO 91109 ITS2=1,IRANK
             DO 91108 IT = 1,NTO
                TS2(IT) = DAT(ITS2,IT)
91108        CONTINUE
             A1(ITS1,ITS2) = RCCV(TS1,TS2,NTO,0)
91109     CONTINUE
91100  CONTINUE
C
C*    1.1.1 FIND EIGENVECTORS/VALUES.
C

C
C     *F02ABF*  - *NAGLIB* ROUTINE FOR FINDING E'VECTORS/VALUES OF
C                 A REAL SYMMETRIC MATRIX.

        IFAIL = 0

        CALL F02ABF( A1, NTSDIM, IRANK, DVECT, EOFS, NTSDIM, WORK1,
     *               IFAIL )

      ELSE
C
C*    1.2 The time series length *NTO* being less than *NTS*,
C         the smaller matrix with tilted *DAT* is rather used.
C         See the manual for further details.
C         Note that there will be no index overflow in *A1*/*EOFS* because of
C         *NTO* < *NTS* <= *NTSDIM*
C
        PRINT 101
        IRANK = NTO
        PLANTSS = FLOAT(NTO)
C
C         As in 1.1, if there are no data at a space point, set contribution
C         to zero. This is done by huge numbers in denominators.
C
        ROOTSS = SQRT( FLOAT(NTO) )

        DO 91250 KTIME1=1,IRANK
           DO 91225 KS=1,NTS
C
C           Divide by *PLANTS* here rather than in inner loop.
C
              WORK1( KS ) = DAT( KS, KTIME1 ) / NTO
91225      CONTINUE

           DO 91240 KTIME2=1,IRANK
            DO 91230 KS=1,NTS
              WORK5( KS ) = DAT( KS, KTIME2 )
91230       CONTINUE
            A1( KTIME1, KTIME2 ) = RCCV( WORK1, WORK5, NTS, 0 ) * NTS
91240     CONTINUE

91250   CONTINUE
C
C*    1.2.1 Find eigenvectors and eigenvalues of alternate matrix.
C
        IFAIL = 0
        CALL F02ABF( A1, NTSDIM, IRANK, DVECT, EOFS, NTSDIM, WORK1,
     *               IFAIL)
C
C*    1.2.2 Construct space-based EOFs by multiplication with *DAT*
C           divided by the elements of *ROOTS*.
C           In the following, *TS1* stores the eigenvectors delivered
C           by *F02ABF* as workspace (indexed by time).
C
        DO 91280 KEV=1,NTO

          DO 91270 KTIME=1,IRANK
            TS1( KTIME ) = EOFS( KTIME, KEV )
91270     CONTINUE

          DO 91275 KSPACE=1,NTS
            WORK1( KSPACE ) = 0.
            DO 91273 KTIME=1,IRANK
              WORK1( KSPACE ) = WORK1( KSPACE ) +
     *          DAT( KSPACE, KTIME ) / ROOTSS * TS1(KTIME)
91273       CONTINUE
91275     CONTINUE
C
C*      Normalise EOF to unit length
C
        SQ = SQRT( NTS * RCCV( WORK1, WORK1, NTS, 0 ) )
        DO 91279 KSPACE=1,NTS
          EOFS( KSPACE, KEV ) = WORK1( KSPACE ) / SQ
91279   CONTINUE
91280   CONTINUE
C
C*    1.2.3 Done! We're at the same state as reached in branch 1.1.
C           (Neglected are the effects of the covariance estimation
C           with the "roots" being only used in case 1.2.)
C
      ENDIF

C
C*    2. CHANGE ORDER OF EIGENVALUES TO DESCENDING VALUES.
c           (There are *IRANK* eigenvalues coming from the NAG routine.)
C
      DO 91300 ITS=1,NTS
         DO 91310 IEV = 1, IRANK
            WORK1(IEV) = EOFS(ITS, IRANK+1 - IEV)
91310    CONTINUE
         DO 91320 IEV = 1, IRANK
            EOFS(ITS,IEV) = WORK1(IEV)
91320    CONTINUE
91300 CONTINUE

      CALL TROS( DVECT, IRANK )
C
C*    3. EIGENVALUE DIAGNOSIS
C
      CALL EVDIA( DVECT, NTS, NTS )

C
C
C*    4. OUTPUT TO TAPE
C
94000 CONTINUE
C
C     OUTPUT OF EIGENVALUES AND EOFS
C
      IUNIT = 3
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, DVECT )
      CALL OUTMAT( IUNIT, LGAP, MDATE, NSER,
     *             0, 0, 0, NTS,  WORK1,
     *             EOFS, NTSDIM, NTSDIM, NEOF, .TRUE. )
C------------------------------------------------------------------------------
  100 FORMAT('0SUBROUTINE TSEOFS: TRANSFORM TIME SERIES IN EOF SPACE.')
  101 FORMAT(' SMALLER MATRIX IS USED FOR COMPUTING EIGENVECTORS!' /)
  140 FORMAT('0NO. OF EIGENVALUE',I4,' MAX. ERROR',E10.2)

       END
C
C==== END TSEOFS ==============================================================
C
C
C==== BEGIN PRCOMP ( U0302 ) ==================================================
C
      SUBROUTINE PRCOMP( DAT, LGAP, VAR, DVECT, EOFS, PC )
C
C**** *PRCOMP* - CALCULATES PRINCIPAL COMPONENTS.
C
C     H. V.STORCH,      MPIFM      15/09/86
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C     MODIFIED BY R. SCHNUR  10/03/91 - INTRODUCTION OF DIVISOR *DIV* FOR THE
C                  CASE OF GAPPY OBSERVATIONS (SEE COMMENT BELOW).
C
C     PURPOSE.
C     --------
C
C     *PRCOMP* COMPUTES PRINCIPAL COMPONENTS OF A TIME SERIES.
C     IF NO EOF ANALYSIS WAS PERFORMED, I.E. THE EOFS ARE THE UNIT VECTORS
C     THESE ARE JUST THE COMPONENTS OF THE ORIGINAL DATA TIME SERIES.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *PRCOMP*
C
      include 'scalars.i'
      include 'arrays.i'

      IF (NUMGAP .GT. 0.) THEN

         DO 1010 IT=1,NTO
            DO 1110 ITS=1,NTS
               WORK1(ITS) = DAT(ITS,IT)
 1110       CONTINUE

C
C     *DIV* is the sum of squares of those components of an EOF *EOFS*(.,IEOF)
C     for which an observation is available. The projection of the 
C     observation onto the EOFs has to be divided by this value to get the
C     proper principal components.
C     Note: If there is an observation available for all spatial indices 
C           *DIV* is just the square of the norm of an eof, and this is 1.
C
            DO 2010 IEOF=1,NTS
               SUM = 0.0
               DIV = 0.0
               DO 2110 IZR=1,NTS
                  IF (.NOT. LGAP(IZR,IT) ) THEN
                     SUM = SUM + WORK1(IZR)*EOFS(IZR,IEOF)
                     DIV = DIV + EOFS(IZR,IEOF)*EOFS(IZR,IEOF)
                  END IF 
 2110          CONTINUE
C
C        If *DIV* is 0. then *SUM* is also 0. because the IEOF'th
C        EOF is identical to zero.
C     
               IF (ABS(DIV).GT.THRESHOLD) SUM = SUM / DIV
               
               PC(IEOF,IT) = SUM 
         
 2010       CONTINUE
         

 1010    CONTINUE

      ELSE

         DO 10100 IT=1,NTO
            DO 11100 ITS=1,NTS
               WORK1(ITS) = DAT(ITS,IT)
11100       CONTINUE

C
            DO 20100 IEOF=1,NTS
               SUM = 0.0
               DO 21100 IZR=1,NTS
                  SUM = SUM + WORK1(IZR)*EOFS(IZR,IEOF)
21100          CONTINUE
C
               PC(IEOF,IT) = SUM 
 
20100       CONTINUE

10100    CONTINUE
      END IF

      XVM = 0.
      DO 11010 K=1,NEOF
         DO 11110 I = 1,NTO
            TS1(I) = PC(K,I)
11110    CONTINUE
         CALL STD(TS1,NTO,XM(K),XV(K))
         IF (XV(K) .GT. XVM) XVM = XV(K)
11010 CONTINUE
      XVM=3.*XVM
C
C*    Output of eigenvalues and principal components time series
C     (if EOF analysis has been performed)
C
      IF (NEOF .GT. 0) THEN
         IUNIT = 4
         CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, DVECT )
         CALL OUTMAT( IUNIT, LGAP, MDATE, NSER,
     *             0, 0, 0, NTO, TS1,
     *             PC, NTSDIM, NSER, NEOF, .FALSE. )
      ELSE
         CLOSE(4)
      END IF

      RETURN
      END
C
C==== END PRCOMP ==============================================================
C
C
C==== BEGIN SPEC ( U0303 ) ====================================================
C
      subroutine spec( ktype, dvect, pc, popc, popper, tefold )

C**** *SPEC* - Routine to calculate spectra for one or two time series.
C
C     Reiner Schnur     MPI/Met  HH     23-Aug-1989.
C     G. Hannoschoeck   MPI/Met  HH     27-Nov-1990: CEOF handling removed
C                                                    (no call from *CEOFAN*)
C
C     PURPOSE.
C     --------
C          *SPEC* calculates the spectra of the principal component,
C     pop coefficient time series (Bartlett's
C     procedure) and outputs them to *TAPE1* .
C
C**   INTERFACE.
C     ----------
C          *call* *spec(ktype)*
C
C               *ktype* - Selects which kind of spectral analysis has
C                         to be performed:
C                         1 - principal components (variance spectra)
C                         2 - pop coefficient time series (cross spectra)
C                         3 - ceof amplitudes time series (cross spectra)
C                             (not used)
C     METHOD.
C     -------
C          Bartlett's procedure.
C
C     EXTERNALS.
C     ----------
C
C          *C06FCF*  - NAG ROUTINE TO CALCULATE THE DISCRETE FOURIER
C                      OF A SEQUENCE OF COMPLEX DATA VALUES.
C          *BOXIT*   - SUBROUTINE TO PRINT STRING IN A BOX.
C          *ZERO*    - SUBROUTINE TO SET AN ARRAY TO ZERO.
C
C     REFERENCE.
C     ----------
C          Jenkins, G.M. and Watts, D.G., 1968: Spectral Analysis and
C               its Applications. Holden - Day, San Francisco.
C
      include 'scalars.i'
      include 'arrays.i'
C
C*    *COMMON* *CEOFCOM* - removed (no call from *CEOFAN*).
C
      REAL xx(nser), y(nser), ax(nser), bx(nser), ay(nser),
     r     by(nser), xom(nser/2+1), specx(nser/2+1), specy(nser/2+1),
     r     phase(nser/2+1), cohsq(nser/2+1), wk(nser/2+1), co, bw

      integer ktype, lc, nom, ndgf

      character text*80, ktext(4)*30

      data text,ktext /5*' '/

C*    VARIABLE     TYPE     PURPOSE.
C     --------     ----     --------
C
C      *XX*,*Y*   REAL  )   WORKING ARRAYS FOR FIRST, resp.
C      *AX*,*AY*  REAL  )      SECOND TIME SERIES OR THEIR
C      *BX*,*BY*  REAL  )      FOURIER COEFFICIENTS.
C      *XOM*      REAL      ARRAY OF FREQUENCIES.
C      *SPECX*    REAL  )   REAL AND IMAGINARY PART OF THE
C      *SPECY*    REAL  )                VARIANCE SPECTRUM.
C      *PHASE*    REAL      PHASE SPECTRUM.
C      *COHSQ*    REAL      SQUARED COHERENCE SPECTRUM.
C      *WK*,*CO*  REAL      WORKING SPACE.
C
C      *KTYPE*    INTEGER   KIND OF SPECTRAL ANALYSIS.
C      *LC*       INTEGER   CHUNK LENGTH.
C      *NOM*      INTEGER   NUMBER OF FREQUENCIES.
C      *NDGF*     INTEGER   NUMBER OF DEGREES OF FREEDOM.
C      *BW*       INTEGER   BANDWIDTH.
C
C      *TEXT*     CHARAC    HEADER TEXT.
C      *KTEXT*    CHARAC    TEXT FOR EVERY ITERATION.
C
C     ------------------------------------------------------------------
C
C*         1.      PREPARATIONS.
C                  -------------
C
  100 continue
C
C*         1.1     COMPUTE PARAMETERS AND FREQUENCIES.
  110 continue
      lc = nto/nc
      nom = lc/2+1
      ndgf = 2*nc
C*                 CHUNK LENGTH,NUMBER OF FREQUENCIES AND NUMBER OF
C*                    DEGREES OF FREEDOM.

      dom = 0.5/float(nom-1)/dt
      do 112 iom=1,nom
         xom(iom) = dom*float(iom-1)
  112 continue
C*                 FREQUENCIES.

      bw = xom(2)
C*                 BANDWIDTH.
C
C*         1.2     SET TAPE UNIT NUMBER AND WRITE EIGENVALUES
c                  (E-FOLDING TIMES, PERIODS) AND FREQUENCIES TO TAPE.
  120 continue

      if (ktype.eq.1) then
	 iunit = 5
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, DVECT )
      IDATE = -2
	 nof = neof

      else if (ktype.eq.2) then
	 iunit = 9
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, TEFOLD )
      CALL OUTDAT( IUNIT, -2, 0, 0, NEOF, POPPER )
      IDATE = -3
	 nof = neof

      else
	 print*, 'FATAL ERROR in subroutine *SPEC* : Invalid argument.'
	 return
      end if

      CALL OUTDAT( IUNIT, IDATE, 0, ndgf, NOM, XOM )
C
C*         1.3     PRINTER OUTPUT.
C
  122 continue
      if (levpri .and. lsppri) then
         call boxit(title,1,80)
C*                 PRINT TITLE STRING IN BOX.

	 if (ktype.eq.1) then
            text = 'SPECTRAL ANALYSIS: EOF COMPONENTS       '
	 else if (ktype.eq.2) then
	    text = 'SPECTRAL ANALYSIS: POP COEFFICIENTS     '
         end if
	 call boxit(text,0,40)
C*                 PRINT HEADER IN BOX.

C     No filter characteristics written here (G. Hannoschoeck)

	 ktext(3) = itext(3)
C*                 WRITE EXPERIMENT TITLE TO TEXT STRING.
      end if
C
C     -------------------------------------------------------------
C
C*         2.      CONTROL THE PROCESS.
C                  ------- --- --------
  200 continue
      jeof = 0
      jj = 0
      jpop = 0
C
C*                 BEGIN OF ITERATION LOOP:
C*                 SET ITERATION INDICES TO ZERO.
C
  202 continue
      goto (210,220) ktype
C*                 BRANCH TO 2.1, 2.2 ACCORDING TO *KTYPE* TO
C*                    DO THE NEXT ITERATION.

C
C*         2.1     PRINCIPAL COMPONENT TIME SERIES.
C          ----------------------------------------
C
  210 continue
      if (jeof.lt.neof) then
         jeof = jeof+1
      else
	 goto 400
      end if
C*                 SET ITERATION INDEX TO NEXT EOF OR TERMINATE.

      do 212 i=1,nto
         xx(i) = pc(jeof,i)
  212 continue
C*                 COPY TIME SERIES FROM *PC* TO *XX*.

      write(ktext(2),214) jeof
  214 format('EOF ',I2,' COEFFICIENT TIME SERIES')
C*                 WRITE NUMBER OF CURRENT EOF TO TEXT STRING.

      goto 310
C*                 BRANCH TO 3.1 TO COMPUTE VARIANCE SPECTRUM OF ONE
C*                    TIME SERIES.

C
C*         2.2     POP COEFFICIENT TIME SERIES.
C          ------------------------------------
C
  220 continue
      if (jpop.lt.neof) then
         jpop = jpop+1
         jj = jj+1
      else
	 goto 400
      end if
C*                 SET ITERATION INDEX TO NEXT POP OR TERMINATE.

      write(ktext(2),222) jj
  222 format('POP ',I2,' COEFFICIENT TIME SERIES')
C*                 WRITE NUMBER OF CURRENT POP TO TEXT STRING.

      ktext(4) = '                              '
      if (popper(jpop).ne.0) write(ktext(4),224) 1./popper(jpop)
  224 format('POP FREQUENCY ',F5.3)
C*                 WRITE POP FREQUENCY OF CURRENT POP TO TEXT STRING
C*                    (IF PERIOD NOT EQUAL TO ZERO).

      do 226 i=1,nto
	 xx(i) = popc(jpop,i)
  226 continue
C*                 COPY REAL PART OF TIME SERIES FROM *POPC* TO *XX* .

      if (popper(jpop).ne.0) then
	 jpop = jpop+1
	 do 228 i=1,nto
	    y(i) = popc(jpop,i)
  228    continue
C*                 IF THE POP IS COMPLEX COPY IMAGINARY PART OF TIMe
C*                    SERIES FROM *POPC* TO *Y* .
	 goto 320
C*                 IF POP IS COMPLEX BRANCH TO 3.2 TO COMPUTE CROSS
C*                    SPECTRUM OF THE CURRENT POP COEFFICIENT TIME SERIES.
      else
	 goto 310
C*                 IF POP IS REAL BRANCH TO 3.1 TO COMPUTE VARIANCE
C*                    SPECTRUM OF THE CURRENT TIME SERIES.
      end if
C
C     -----------------------------------------------------------------
C
C*         3.      PERFORM SPECTRAL ANALYSIS.
C                  ------- -------- ---------
  300 continue
C
C*         3.1     CASE: ONE TIME SERIES (PRINCIPAL COMPONENTS OR POPS)
C          ------------------------------
C
  310 continue
      if (levpri .and. lsppri) print 312, nto, ktext
  312 format(//,' TIME SERIES LENGTH = ',I4,4X,A,/,3(30X,A,/))
C*                 PRINT TEXT STRING TO OUTPUT IF PRINTER LEVEL HIGH.

C
C*         3.1.1   COMPUTE VARIANCE SPECTRUM.
 3110 continue
      xn = float(lc*lc*nc)/2.
      xq = 0
      do 3111 i=1,nto
	 xq = xq+xx(i)
 3111 continue
      xq = xq/nto
C*                 COMPUTE MEAN OF TIME SERIES.

      call zero(specx,nom)
      do 3112 i=1,nc
C*                 LOOP OVER THE CHUNKS.

         do 3113 j=1,lc
            ax(j) = xx(j+(i-1)*lc) - xq
C*                 COPY TIME SERIES FOR CURRENT CHUNK TO WORK ARRAY.
            bx(j) = 0.
 3113    continue

	 ifail = 0
	 call C06FCF(ax,bx,lc,wk,ifail)
	 if (ifail.ne.0) goto 410
         sqn = sqrt(1.*lc)
	 do 3114 l=1,lc
	    ax(l) = ax(l)*sqn
	    bx(l) = bx(l)*sqn
 3114    continue
C*                 FAST FOURIER TRANSFORM OF TIME SERIES.

	 do 3115 iom=1,nom
	    specx(iom) = specx(iom)+ax(iom)*ax(iom)+bx(iom)*bx(iom)
 3115    continue

 3112 continue

      do 3116 iom=1,nom
	 specx(iom) = specx(iom)/xn
 3116 continue
C*                 CALCULATION OF VARIANCE.
C
C*         3.1.2   PRINTER OUTPUT OF SPECTRUM.
 3120 continue
      if ((.not.levpri).or.(.not.lsppri).or.
     &                     (ktype.eq.1).and.(jeof.ge.4)) goto 3130
C*                 IF PRINTER LEVEL LOW OR NUMBER OF EOF GE 4:NO OUTPUT.

      print 3122, lc, bw, ndgf
 3122 format(' SMOOTHED AUTO SPECTRAL ESTIMATE:',/,
     &       ' BARTLETT PROCEDURE    CHUNK LENGTH    :',I7,/,
     &       '                       BANDWIDTH       :',F7.4,/,
     &       '                       DEG OF FREEDOM  :',I7,//,
     &       '   PERIOD     FREQUENCY      VARIANCE',/)

      do 3124 iom=1,nom
	 period = 0.
	 if (iom.ne.1) period = 1./xom(iom)
	 print 3126, period, xom(iom), specx(iom)
 3124 continue
 3126 format(1X,F8.1,3X,F11.4,3X,E11.4)
C
C*         3.1.3.   OUTPUT OF SPECTRUM TO *TAPE1*
 3130 continue

        IDATE = MAX0( JEOF, JJ )
        call outdat( iunit, IDATE, 0, 1, nom, specx )


C
C*         3.1.4   END OF ONE ITERATION.
C                  ---------------------
      goto 202

C*                 BRANCH BACK TO 2. TO DO NEXT ITERATION OR TO TERMINATE.
C
C
C*         3.2     CASE: TWO TIME SERIES (APPLIES FOR POPS ONLY)
C          ------------------------------
C
  320 continue
      if (levpri .and. lsppri) print 322, nto, ktext
  322 format(//,' TIME SERIES LENGTH = ',I4,4X,A,/,3(30X,A,/))
C*                 PRINT TEXT STRING TO OUTPUT IF PRINTER LEVEL HIGH.
C
C*         3.2.1   COMPUTE VARIANCE, PHASE AND COHERENCE.
 3210 continue
      factor = 45./atan(1.)
      xn = float(lc*lc*nc)/2.
      xq = 0
      yq = 0

      do 3211 i=1,nto
	 xq = xq+xx(i)
	 yq = yq+y(i)
 3211 continue
      xq = xq/nto
      yq = yq/nto
C*                 COMPUTE MEANS OF TIME SERIES.

      call zero(specx,nom)
      call zero(specy,nom)
      call zero(phase,nom)
      call zero(cohsq,nom)
C*                 SET ARRAYS TO ZERO.

      do 3212 i=1,nc
C*                 LOOP OVER THE CHUNKS.

         do 3213 j=1,lc
            ax(j) = xx(j+(i-1)*lc) - xq
C*                 COPY FIRST TIME SERIES FOR CURRENT CHUNK TO WORK ARRAY.
            bx(j) = 0.
 3213    continue

	 ifail = 0
	 call C06FCF(ax,bx,lc,wk,ifail)
	 if (ifail.ne.0) goto 410
         sqn = sqrt(1.*lc)
	 do 3214 l=1,lc
	    ax(l) = ax(l)*sqn
	    bx(l) = bx(l)*sqn
 3214    continue
C*                 FAST FOURIER TRANSFORM OF FIRST TIME SERIES.

         do 3215 j=1,lc
            ay(j) = y(j+(i-1)*lc) - yq
C*                 COPY SECOND TIME SERIES FOR CURRENT CHUNK TO WORK ARRAY.
            by(j) = 0.
 3215    continue

	 ifail = 0
	 call C06FCF(ay,by,lc,wk,ifail)
	 if (ifail.ne.0) goto 410
         sqn = sqrt(1.*lc)
	 do 3216 l=1,lc
	    ay(l) = ay(l)*sqn
	    by(l) = by(l)*sqn
 3216    continue
C*                 FAST FOURIER TRANSFORM OF SECOND TIME SERIES.

	 do 3217 iom=1,nom
	    specx(iom) = specx(iom)+ax(iom)*ax(iom)+bx(iom)*bx(iom)
	    specy(iom) = specy(iom)+ay(iom)*ay(iom)+by(iom)*by(iom)
	    cohsq(iom) = cohsq(iom)+ax(iom)*ay(iom)+bx(iom)*by(iom)
	    phase(iom) = phase(iom)-ay(iom)*bx(iom)+ax(iom)*by(iom)
 3217    continue

 3212 continue

      do 3218 iom=1,nom
	 co         = cohsq(iom)
	 quad       = phase(iom)
      if( co .ne. 0. ) then
	   phase(iom) = factor * atan2(-quad,co)
      else
        phase(iom) = 2.*atan(1.)
      endif
      if( specx(iom) .ne. 0. .and. specy(iom) .ne. 0)
     *   cohsq(iom) = (co*co + quad*quad) / specx(iom) / specy(iom)
	 specx(iom) = specx(iom) / xn
	 specy(iom) = specy(iom) / xn
 3218 continue
C*                 CALCULATION OF VARIANCE, PHASE AND COHERENCE.

C
C*         3.2.2   PRINTER OUTPUT OF CROSS SPECTRUM.
 3220 continue
      if (.not.levpri .or. .not.lsppri) goto 3230
C*                 ONLY IF PRINTER LEVEL HIGH.

      print 3222, lc, bw, ndgf
 3222 format(' SMOOTHED AUTO AND CROSS SPECTRAL ESTIMATES:',/,
     &       ' BARTLETT PROCEDURE    CHUNK LENGTH    :',I7,/,
     &       '                       BANDWIDTH       :',F7.4,/,
     &       '                       DEG OF FREEDOM  :',I7,//,
     &       '   PERIOD     FREQUENCY    VARIANCE-X',3X,
     &       ' VARIANCE-Y         PHASE     SQ.COHER.',/)

      do 3224 iom=1,nom
	 period = 0.
	 if (iom.ne.1) period = 1./xom(iom)
	 print 3226, period, xom(iom), specx(iom),specy(iom),
     &               phase(iom),cohsq(iom)
 3224 continue
 3226 format(1X,F8.1,3X,F11.4,3X,E11.4,3X,E11.4,3X,F11.2,3X,F11.2)
C
C*         3.2.3.  OUTPUT OF CROSS SPECTRUM TO *TAPE1*.
 3230 continue
             call outdat( iunit, jj, 0, 1, nom, specx )
             call outdat( iunit, jj, 0, 2, nom, specy )
             call outdat( iunit, jj, 0, 3, nom, phase  )
             call outdat( iunit, jj, 0, 4, nom, cohsq )
C
C*         3.2.4   END OF ONE ITERATION.
      goto 202
C*                 BRANCH BACK TO 2. FOR NEXT ITERATION OR TO TERMINATE.
C
C ------------------------------------------------------------------
C
C*         4.      END OF SUBROUTINE.
C                  --- -- -----------
  400 continue
      return
C*                 NORMAL TERMINATION.

  410 continue
      if (ifail.eq.1) print 412, ifail,
     &    ' AT LEAST ONE THE PRIME FACTORS ON N IS GREATER THAN 19.'
      if (ifail.eq.2) print 412, ifail,
     &    'N HAS MORE THAN 20 PRIME FACTORS.'
      if (ifail.eq.3) print 412, ifail, 'N <= 1 .'
  412 format(' ERROR IN NAG-ROUTINE *C06FCF* . IFAIL = ',I3,':',/,5X,A)
      return
C*                 ERROR IN NAG ROUTINE.
      end
C
C==== END SPEC ================================================================
C
C
C==== BEGIN POPS ( U0304 ) ====================================================
C
      SUBROUTINE POPS( DAT, LGAP, LHOLE, VAR, DVECT, EOFS, PC,
     *                 POP, POPC, POPPER, TEFOLD )
C
C**** *POPS* - CALCULATES PRINCIPAL OSCILLATION PATTERNS, STATIONARY CASE.
C
C     H. V.STORCH,      MPIFM      15/09/86
C     MODIFIED BY I. FISCHER-BRUNS 01/02/87
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *POPS* CALCULATES POP'S FOR THE STATIONARY CASE.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *POPS*
C
C     METHOD.
C     -------
C
C     CALCULATES THE EIGENVECTORS (POP'S) OF A MATRIX DESCRIBED BY THE
C     PRODUCT OF THE LAG-1-COVARIANCE MATRIX AND THE INVERSE OF THE
C     LAG-0-COVARIANCE MATRIX
C
C     EXTERNALS.
C     ----------
C
C     *EOFREC*  - SUBROUTINE TO RECONSTRUCT VECTOR IN PHYSICAL SPACE.
C     *F01AAF*  - *NAG* ROUTINE TO FIND APPROX INVERSE OF REAL MATRIX.
C     *F02AGF*  - *NAG* ROUTINE TO FIND E'VALUES AND E'VECTORS.
C     *F04AEF*  - *NAG* ROUTINE TO solve a set of real linear equations.
C     *PRIMAT*  - SUBROUTINE TO OUTPUT MATRIX.
C     *NOISE* - SUBROUTINE TO CALCULATE 2D NOISE VECTOR.
C     *STAT*    - SUBROUTINE TO CALCULATE 1ST & 2ND MOMENTS OF TIME
C                 SERIES.
C     *TURN*    - SUBROUTINE TO ROTATE (COMPLEX) EIGENVECTOR.
C
C     TAPE 6   PRINTER OUTPUT
C
C     REFERENCE.
C     ----------
C
C     V.STORCH, H. ET AL., 1987: PRINCIPAL OSCILLATION PATTERN ANALYSIS
C         OF THE 30-60 DAY OSCILLATION IN A GCM EQUATORIAL TROPOSHPERE.
C         SUBM. TO JGR
C

      include 'scalars.i'
      include 'arrays.i'
C
C     *AA* *BB* - DUMMY REQUIRED BY *NAGLIB* *F04AEF*.
C     *NUMPOP*  - Number of pop if complex eigenvectors are counted
C                 as one pop.
C
      DIMENSION AA(NEODIM,NEODIM),BB(NEODIM,NSER),A1(NEODIM,NEODIM),
     *          EVR(NEODIM,NEODIM),EVI(NEODIM,NEODIM),
     *          XPV(NEODIM),XPVP(NEODIM),XPVQ(NEODIM),
     *          NUMPOP(NEODIM)
      CHARACTER YS*132
C
C     -----------------------------------------------------------
C
C     0. IF NO EOF ANALYSIS HAS BEEN PERFORMED (NEOF <= 0) SET NEOF = NTS
C
      IF (NEOF .LE. 0) NEOF = NTS

C
C     1. COMPUTE MATRIX "R".
C
 1000 CONTINUE

      PI = 4.*ATAN(1.)

      IF(LEVPRI) THEN
            CALL BOXIT(TITLE,1,80)
            WRITE(TTXT,'(A80)') ' CALCULATION OF POPS '
            CALL BOXIT(TTXT,0,40)
            ENDIF
C
C     COMPUTE MATRIX "R" OF AUTOREGRESSIVE MULTIVARIATE PROCESS
C     AS VX(ITAU)/VX(0)   (CF. JENKINS & WATTS P.474)
C

      DO 1010 ITS1=1,NEOF
            DO 1110 ITS2=1,NEOF
C
C     TS1, TS2 : PRINCIPAL COMPONENTS
C
                  DO 1020 I = 1,NTO
                        TS1(I) = PC(ITS1,I)
                        TS2(I) = PC(ITS2,I)
 1020                   CONTINUE
                  RC1(ITS1,ITS2) = RCCV(TS1,TS2,NTO,ITAU)
                  RC0(ITS1,ITS2) = RCCV(TS1,TS2,NTO,0)
 1110             CONTINUE
 1010       CONTINUE
      IF (LEVPRI) THEN
            PRINT 190, '0LAG-0 COVARIANCE MATRIX (C0)'
            CALL PRIMAT(NEOF,NEODIM,RC0)

            PRINT 190, '0LAG-1 COVARIANCE MATRIX (C1)'
            CALL PRIMAT(NEOF,NEODIM,RC1)
            ENDIF
C
C     -----------------------------------------------------------
C
C*    2. INVERSION OF *RC0*, RESULT IS *A1*,  AND MULTIPLICATION WITH *RC1*.
C
C                                            RESULT IS *STRUMA*
C

C
C     ALAMR : EIGENVALUES
C
      IFAIL = 0
C
C      F01AAF COMPUTES THE APPROXIMATE INVERSE OF A REAL MATRIX
C
      CALL F01AAF(RC0, NEODIM, NEOF, A1, NEODIM, TS1, IFAIL)
      IF (IFAIL.EQ.1) THEN
         CALL HELP(11,0,0,LEVPRI)
         PRINT*, 'NAGLIB F01AAF ERROR IN SUBROUTINE POPS '
         PRINT*, '           (INVERSION OF LAG-0 COVARIANCE MATRIX)'
         PRINT*, '   - SEE OUTPUT'
         STOP
      ENDIF

      DO 2210 I1 = 1,NEOF
            ALAMR(I1) = 0.
            ALAMI(I1) = 0.
            DO 2220 I2 = 1,NEOF
                  STRUMA(I1,I2) = 0.
                  DO 2230 J = 1,NEOF
                         STRUMA(I1,I2) = STRUMA(I1,I2) +
     *                                   RC1(I1,J)*A1(J,I2)
 2230                    CONTINUE
 2220             CONTINUE
 2210       CONTINUE

      IF(LEVPRI) THEN
      PRINT 190, '1ESTIMATED SYSTEM MATRIX (STRUMA)'
      CALL PRIMAT( NEOF, NEODIM, STRUMA )
      ENDIF

C
C     -----------------------------------------------------------
C
C*    3. CALCULATE EIGENVECTORS AND EIGENVALUES OF R
C
 3000 CONTINUE
C
C     MAKE COPY OF *STRUMA* - OVERWRITTEN BY *NAGLIB*.
C

      DO 2310 I = 1,NEOF
            DO 2320 J = 1,NEOF
                  A1(I,J) = STRUMA(I,J)
 2320             CONTINUE
 2310       CONTINUE

      IFAIL = 0
C
C     F02AGF COMPUTES EIGENVALUES AND -VECTORS  OF A REAL, UNSYMMETRIC
C     MATRIX.
C     ALAMR, ALAMI : REAL, IMAG. EIGENVALUE
C     EVR,EVI       : REAL, IMAG. EIGENVECTOR
C
      CALL F02AGF(A1,NEODIM,NEOF,ALAMR,ALAMI,EVR,NEODIM,EVI,NEODIM,
     *            INTGER, IFAIL)
      IF(IFAIL.NE.0) PRINT 150, IFAIL
C
C     -------------------------------------------------------------
C
C*    4. CHECK EIGENVECTORS AND EIGENVALUES
C
C
 4000 CONTINUE

      DO 4010 IEVD=1,NEOF
            CLAM = CMPLX(ALAMR(IEVD),ALAMI(IEVD))
            EMAX = 0.
            DO 4110 I=1,NEOF
                  CXZ = (0.,0.)
                  DO 4120 J=1,NEOF
                        C = CMPLX(EVR(J,IEVD),EVI(J,IEVD))
                        CXZ = CXZ + STRUMA(I,J)*C
 4120                   CONTINUE
                  C = CMPLX(EVR(I,IEVD),EVI(I,IEVD))
                  EMAX = AMAX1(EMAX , CABS(CXZ - CLAM*C))
 4110             CONTINUE
            IF(EMAX.GT. 1.E-10) PRINT 140, IEVD,EMAX
 4010       CONTINUE
C
C     ------------------------------------------------------------
C
C*    5. DRAW REAL POPS OUT OF EIGENVECTORS, ROTATE THEM AND
C        NORMALISE TO LENGTH**2 = NTS.
C        PERIODS *P* AND e-FOLDING TIMES *T* ARE DEFINED HERE, TOO.
C
 5000 CONTINUE

      IF(LEVPRI) THEN
        PRINT 190, '1COMPLEX EIGENVALUES OF MATRIX STRUMA'
        PRINT 180, (ALAMR(IEVD),ALAMI(IEVD),IEVD=1,NEOF)
      ENDIF

C
C*    5.1 Define unrotated pops
C
      JPOP = 0
 5010 DO 5200 JEV = 1,NEOF
        ALR = ALAMR(JEV)
        ALI = ALAMI(JEV)
C
C           Skip from a conjugate complex pair of eigenvalues
C           that one with different signs in real and imaginary part.
C
            IF( ALI .NE. 0.  .AND.
     *          SIGN( 1., ALR ) .NE. SIGN( 1., ALI ) )   GOTO 5200

            JPOP = JPOP + 1
            TEFOLD(JPOP) = -ITAU*DT / ALOG (SQRT(ALR*ALR+ALI*ALI))

            IF( ALI .NE. 0.0 ) THEN
C
C                 Define two pops out of non-real eigenvector.
C
                  TEFOLD(JPOP + 1) = TEFOLD(JPOP)
                  DO 5110 ITS=1,NEOF
                        PHIRE(ITS) = EVR(ITS,JEV)
                        PHIIM(ITS) = EVI(ITS,JEV)
 5110             CONTINUE
                  POPPER(JPOP) = 2.*PI*ITAU*DT
     *                           / ATAN2( ABS(ALI) ,ABS(ALR) )
                  POPPER(JPOP + 1) = POPPER(JPOP)
C
C                 Turning the pair to be an orthogonal pair.
C
                  CALL TURN (PHIRE, PHIIM, NEOF, ALPHA, BETA,LEVPRI,
     *                       PV,PVP,PVQ)

                  DO 5020 ITS = 1,NEOF
                        POP( JPOP,     ITS ) = PHIRE( ITS )
                        POP( JPOP + 1, ITS ) = PHIIM( ITS )
 5020             CONTINUE
                  JPOP = JPOP + 1

            ELSE
C
C                 Define one pop out of real eigenvector.
c                 Period is set to zero for convenience.
C
                  POPPER( JPOP ) = 0.
                  DO 5030 ITS = 1,NEOF
                        POP( JPOP, ITS ) = EVR( ITS, JEV )
 5030                   CONTINUE
            END IF

 5200 CONTINUE

C
C     NORMALISE POPS SO THAT (POP,POP) = NTS
C          (NORMALISED =1 OTHERWISE)
C
      FAC=SQRT(FLOAT(NTS))
      DO 3210 JPOP=1,NEOF
            DO 3220 JEOF=1,NEOF
                  POP(JPOP,JEOF)=FAC*POP(JPOP,JEOF)
 3220             CONTINUE
 3210       CONTINUE
C
C     ----------------------------------------------------------
C
C*    6. PRINTOUT AND INVERSION OF POP MATRIX:
C        Pop coefficient time series are computed.
C
 6000 CONTINUE

      IF(LEVPRI) THEN
         PRINT 190,'0POP MATRIX IN EOF SPACE',
     *        '0COMP.     NR. OF POP      '
         J=0
         JJ=0
         WRITE(YS,'(132X)')
 6001    CONTINUE
         JJ=JJ+1
         J=J+1
         IF(POPPER(J).NE.0.) THEN
            WRITE(YS(6*J+1:6*J+3),'(I2,1HR)') JJ
            WRITE(YS(6*J+9:7*J+9),'(1HI)')
            J =J +1
         ELSE
            WRITE(YS(6*J+1:6*J+2),'(I2)') JJ
         ENDIF
         IF(J.LT.NEOF) GOTO 6001
         PRINT'(1X,A)',YS
      ENDIF

      IF (LLSF) THEN

C        6.1 For each POP the coefficient time series is computed as
C            least squares fit to the principal components.
C
C        Variables: p1s=<p1,p1>, p2s=<p2,p2>, p1p2=<p1,p2>
C                   yp1=<y,p1>,  yp2=<y,p2>
C        where the complex,resp. real POP is (p1,p2),resp. p1 and
C        y=y(t) is the data time series.
C        The coefficient time series (z1,z2) ,resp. z1 is computed as solution
C        of       
C                 || y(t) - z1(t) p1 - z2(t) p2 || = Min!   ,
C        i.e.       
C                 z1 = (yp1 p2s - yp2 p1p2) / (p1s p2s - p1p2**2)
C                 z2 = (yp2 p1s - yp1 p1p2) / (p1s p2s - p1p2**2)
C        resp. for the real case
C                 z1 = yp1 / p1s**2  .
C
         PRINT*,'     -------------------------------------------'//
     >               '----------------    '
         PRINT*,' ... NOTE: USING LEAST SQUARES FIT TO DETERMINE '//
     >               'POP COEFFICIENTS !!!'
         PRINT*,'     -------------------------------------------'//
     >               '----------------    '

         J=0
 6020    CONTINUE
         J=J+1
         IF (POPPER(J).NE.0.) JJ=J+1

C        Computation of some inner products and norms.
         P1P2 = 0.
         P1S = 0.
         P2S = 0.
         DET = 0.
         DO 6022 JEOF=1,NEOF
            U = POP(J,JEOF)
            P1S = P1S + U**2
            IF(POPPER(J).NE.0.) THEN
               V = POP(JJ,JEOF)
               P2S = P2S + V**2
               P1P2 = P1P2 + U*V
            END IF
 6022    CONTINUE
         IF (POPPER(J).NE.0.) 
     >        DET = 1./(P1S*P2S - P1P2**2)

C        Computation of coefficients for each time step.
         DO 6024 I=1,NTO
            YP1 = 0.
            YP2 = 0.
            DO 6026 JEOF=1,NEOF
               YP1 = YP1 + PC(JEOF,I)*POP(J,JEOF)
               IF (POPPER(J).NE.0.) YP2 = YP2 + PC(JEOF,I)*POP(JJ,JEOF)
 6026       CONTINUE
            IF (POPPER(J).NE.0.) THEN
               POPC(J,I) = DET * (YP1*P2S - YP2*P1P2)
               POPC(JJ,I)   = DET * (YP2*P1S - YP1*P1P2)
            ELSE
               POPC(J,I) = YP1 / P1S
            END IF
 6024    CONTINUE

         IF(POPPER(J).NE.0.) J = J+1

         IF(J.LT.NEOF) GOTO 6020

      ELSE               
               
C        6.2 The POP coefficients are computed as projection of the
C            principal components onto the adjoint POPs. This is 
C            equivalent to the solution of the system of equations
C                      T
C                   POP  * POPC = PC :

         PRINT*
         PRINT*,' NOTE: USING ADJOINT POPs TO DETERMINE POP '//
     >          'COEFFICIENTS!'
         PRINT*

C        COPY TRANSPOSE OF *POP* TO *XCOVM* - REQUIRED BY DEFINITION
C        OF *POP*.

         DO 6010 I = 1,NEOF
            IF(LEVPRI) PRINT 210, I, (POP(K,I),K=1,NEOF)
            DO 6110 K = 1,NEOF
               XCOVM(I,K) = POP(K,I)
 6110       CONTINUE
 6010    CONTINUE

C
C            *F04AEF* - SOLVES SIMULTANEOUS EQUATIONS AX=B FOR MULTIPLE RHS.
C
         IFAIL = 0
         CALL F04AEF(XCOVM,NEODIM,PC,NTSDIM,NEOF,NTO,POPC,NEODIM,W2,
     *              AA,NEODIM,BB,NEODIM,IFAIL)

         IF (IFAIL.NE.0) PRINT 200, IFAIL

      END IF
C
C     -----------------------------------------------------------
C
C     7. ROTATION OF POPS TO STATISTICALLY ORTHOGONAL FORCING.
C
 8000 CONTINUE

C
C        THE COMPLEX POPS ARE ROTATED SUCH THAT THE FORCING
C        IS ORTHOGONAL IF <LTURN>=.TRUE.  (LTURN IS DEFINED IN *PARSIN*).
C        THE FIRST OF A PAIR OF POPS IS LINKED TO THE DOMINANT FORCING.
C        <POP(.,.)>  : POPS IN IN EOF SPACE
C        <POPC(.,.)> : POP COEFFICIENTS
C
C     The meaning of *LTURN* was flipflopped on Dec. 31, 1990
C     according to printer output in *PARSIN*, G. Hannoschoeck.
C
      IF( LTURN ) THEN
            IF(LEVPRI) PRINT '(1H1,2A)', 'POPS ARE ROTATED SO ',
     *                         'THAT FORCING IS ORTHOGONAL'
            K = 0
 8010       K = K+1
            IF(POPPER(K).EQ.0.) GOTO 8020
            DO 8110 I = 1,NTO
                  TS2(I)  = POPC(K,I)
                  TS1(I)  = POPC(K+1,I)
 8110             CONTINUE
            CALL NOISE(TS2,TS1,NTO,ALAMR(K),ALAMI(K),ALPHA,RR2,RI2,
     *                   WHITE, UD, VD)
            IF(LEVPRI)
     *        PRINT 120, K, RR2, RI2, ALPHA, UD,VD,VD,UD
            DO 8210 I = 1,NTO
                  XHH = POPC(K,I)
                  POPC(K,I)   =  UD*XHH + VD*POPC(K+1,I)
                  POPC(K+1,I) = -VD*XHH + UD*POPC(K+1,I)
 8210             CONTINUE
            DO 8310 I = 1,NEOF
                  XHH = POP(K,I)
                  POP(K,I)   =  UD*XHH + VD*POP(K+1,I)
                  POP(K+1,I) = -VD*XHH + UD*POP(K+1,I)
 8310             CONTINUE
            K = K+1
 8020       IF(K.LT.NEOF) GOTO 8010
      ENDIF
C
C------------------------------------------------------------------
C     8. CALCULATE APOPS AND PRINT OUT
C
 7000 CONTINUE
C
C     COPY TRANSPOSE OF *POP* TO *XCOVM* - REQUIRED BY DEFINITION
C     OF *POP*.
C
      DO 7010 I = 1,NEOF
            DO 7110 K = 1,NEOF
                  XCOVM(I,K) = POP(K,I)
 7110             CONTINUE
 7010       CONTINUE
C
C     F01AAF CALCULATES INVERSE OF A REAL MATRIX
C
      IFAIL = 0
      CALL F01AAF(XCOVM,NEODIM,NEOF,APOP,NEODIM,TS1,IFAIL)
      IF (IFAIL.EQ.1) THEN
         CALL HELP(11,0,0,LEVPRI)
         PRINT*, 'NAGLIB F01AAF ERROR IN SUBROUTINE POPS '
         PRINT*, '           (INVERSION OF POP MATRIX TO COMPUTE PAPs)'
         PRINT*,'   - SEE OUTPUT'
         STOP
      ENDIF


      IF(LEVPRI) THEN
      PRINT 190,'0APOP MATRIX IN EOF SPACE',
     *         '0COMP.     NR. OF APOP      '
      J=0
      JJ=0
      WRITE(YS,'(132X)')
 7001 CONTINUE
      JJ=JJ+1
      J=J+1
      IF(POPPER(J).NE.0.) THEN
          WRITE(YS(6*J+1:6*J+3),'(I2,1HR)') JJ
          WRITE(YS(6*J+9:7*J+9),'(1HI)')
          J =J +1
         ELSE
          WRITE(YS(6*J+1:6*J+2),'(I2)') JJ
        ENDIF
      IF(J.LT.NEOF) GOTO 7001
      PRINT'(1X,A)',YS
      ENDIF
      DO 7710 I = 1,NEOF
            IF(LEVPRI) PRINT 210, I, (APOP(K,I),K=1,NEOF)
 7710       CONTINUE
C
C     CHECK FOR ORTHOGONALITY
C
      IO1=0
 7801 IF(IO1.GE.NEOF) GO TO 7803
      IO1=IO1+1
      DO 7802 IO2=1,NEOF
      W1(IO2)=POP(IO1,IO2)
 7802 W2(IO2)=APOP(IO1,IO2)
      CALL WINK1(W1,W2,NEOF,ALPH,IO1,LEVPRI)
      GO TO 7801

 7803   CONTINUE
C
C     -----------------------------------------------------------
C
C*    9. RECONSTRUCTION OF POPS AND APOPS IN EUCLIDEAN SPACE.
C     -----------------------------------------------------------
C
 9000 CONTINUE
C
C*    9.1. Output of e-folding times and periods for some files.
C     --------------------------------------------------------------------
C
      IUNIT = 6
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, TEFOLD )
      CALL OUTDAT( IUNIT, -2, 0, 0, NEOF, POPPER )
      IUNIT = 10
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, TEFOLD )
      CALL OUTDAT( IUNIT, -2, 0, 0, NEOF, POPPER )
      IUNIT = 7
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, TEFOLD )
      CALL OUTDAT( IUNIT, -2, 0, 0, NEOF, POPPER )
      IUNIT = 11
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, TEFOLD )
      CALL OUTDAT( IUNIT, -2, 0, 0, NEOF, POPPER )
C
C*    9.2 POPS
C     --------
C
      IEVD = 0
      JEVD = 0
 9010 IEVD = IEVD + 1
      JEVD=JEVD+1
      NUMPOP( IEVD ) = JEVD
            DO 9110 ITS = 1,NEOF
                  PHIRE(ITS) = POP(IEVD,ITS)
 9110             CONTINUE
            IF(LEVPRI) PRINT 160,
     *                 JEVD,IEVD,TEFOLD(IEVD),POPPER(IEVD)
            CALL EOFREC ( EOFS, PHIRE, PHIPHR )

      IF(LEVPRI) THEN
            PRINT 170, ' REAL PART IN EOF-SPACE',(PHIRE(ITS),ITS=1,NEOF)
            PRINT 170, '           IN EUCLIDEAN SPACE',
     *                              (PHIPHR(ITS),ITS=1,NTS)
      ENDIF

C     For POPs in Euclidian space insert PPGAP for space points where
C     no observation was available (contents of PHIPHR is not changed).
      DO 9111 ISPACE=1,NTS
         IF (LHOLE(ISPACE)) THEN
            WORK1(ISPACE) = PPGAP
         ELSE
            WORK1(ISPACE) = PHIPHR(ISPACE)
         END IF
 9111 CONTINUE
      CALL OUTDAT( 6, JEVD, 0, 1, NTS, WORK1 )
      CALL OUTDAT( 7, JEVD, 0, 1, NEOF, PHIRE )

      IF( ALAMI( IEVD ) .NE. 0. ) THEN

         IEVD = IEVD+1
         NUMPOP( IEVD ) = JEVD
         DO 9210 ITS = 1,NEOF
            PHIIM(ITS) = POP(IEVD,ITS)
 9210    CONTINUE
         CALL EOFREC( EOFS, PHIIM, PHIPHI )
         IF( LEVPRI ) THEN
            PRINT 170,' IMAGINARY PART IN EOF-SPACE',
     *                              (PHIIM(ITS),ITS=1,NEOF)
            PRINT 170,'                IN EUCLIDEAN SPACE',
     *                              (PHIPHI(ITS),ITS=1,NTS)
         ENDIF

C     For POPs in Euclidian space insert PPGAP for space points where
C     no observation was available (contents of PHIPHI is not changed).
         DO 9112 ISPACE=1,NTS
            IF (LHOLE(ISPACE)) THEN
               WORK1(ISPACE) = PPGAP
            ELSE
               WORK1(ISPACE) = PHIPHI(ISPACE)
            END IF
 9112    CONTINUE
         CALL OUTDAT( 6, JEVD, 0, 2, NTS, WORK1 )
         CALL OUTDAT( 7, JEVD, 0, 2, NEOF, PHIIM )
         
      ENDIF
C
C*    9.3 Jump back to process the next POP
C     -------------------------------------
C
      IF(IEVD.LT.NEOF)   GOTO 9010
C
C*    9.4 APOPS
C     ---------
C
      IEVD = 0
      JEVD = 0
 9019 IEVD = IEVD + 1
      JEVD=JEVD+1
      DO 9119 ITS = 1,NEOF
         AHIRE(ITS) = APOP(IEVD,ITS)
 9119 CONTINUE
      IF(LEVPRI) PRINT 161,
     *     JEVD,IEVD,TEFOLD(IEVD),POPPER(IEVD)
      CALL EOFREC ( EOFS, AHIRE, AHIPHR )

      IF(LEVPRI) THEN
         PRINT 170, ' REAL APOP IN EOF-SPACE',(AHIRE(ITS),ITS=1,NEOF)
         PRINT 170, '           IN EUCLIDEAN SPACE',
     *                              (AHIPHR(ITS),ITS=1,NTS)
      ENDIF
C
C     First APOPs in euclidean, then in EOF space.
C

C     For APOPs in Euclidian space insert PPGAP for space points where
C     no observation was available (contents of AHIPHR is not changed).
      DO 9211 ISPACE=1,NTS
         IF (LHOLE(ISPACE)) THEN
            WORK1(ISPACE) = PPGAP
         ELSE
            WORK1(ISPACE) = AHIPHR(ISPACE)
         END IF
 9211 CONTINUE
      CALL OUTDAT( 10, JEVD, 0, 1, NTS, WORK1 )
      CALL OUTDAT( 11, JEVD, 0, 1, NEOF, AHIRE )

      IF( ALAMI( IEVD ) .NE. 0. ) THEN

         IEVD = IEVD+1
         DO 9219 ITS = 1,NEOF
            AHIIM(ITS) = APOP(IEVD,ITS)
 9219    CONTINUE
         CALL EOFREC( EOFS, AHIIM, AHIPHI )
         IF(LEVPRI) THEN
            PRINT 170,' IMAGINARY APOP IN EOF-SPACE',
     *              (AHIIM(ITS),ITS=1,NEOF)
            PRINT 170,'                IN EUCLIDEAN SPACE',
     *              (AHIPHI(ITS),ITS=1,NTS)
         ENDIF

C     For APOPs in Euclidian space insert PPGAP for space points where
C     no observation was available (contents of PHIPHI is not changed).
         DO 9212 ISPACE=1,NTS
            IF (LHOLE(ISPACE)) THEN
               WORK1(ISPACE) = PPGAP
            ELSE
               WORK1(ISPACE) = AHIPHI(ISPACE)
            END IF
 9212    CONTINUE
         CALL OUTDAT( 10, JEVD, 0, 2, NTS, WORK1 )
         CALL OUTDAT( 11, JEVD, 0, 2, NEOF, AHIIM )

      ENDIF

C
C*    9.5 Jump back to process the next APOP.
C     ---------------------------------------
C
      IF(IEVD.LT.NEOF)   GOTO 9019

C
C     ------------------------------------------------------------
C
C*    10. CALCULATION OF POP'S DOT PRODUCTS
C              (GEOMETRIC ORTHOGONALITY).
C
      CALL BOXIT(TITLE,1,80)
      PRINT 190, '0CHECK OF GEOMETRIC ORTHOGONALITY'
      DO 10105 I=1,NEOF
            DO 10110 J = 1,I
                  XCOVM(I,J) = 0.
                  DO 10120 L = 1,NEOF
                         XCOVM(I,J) = XCOVM(I,J) +
     *                                   POP(I,L)*POP(J,L)
10120                    CONTINUE
10110             CONTINUE
10105       CONTINUE
      CALL PRIMAT2( XCOVM, POPPER )
C
C     -----------------------------------------------------------
C
C*    11. CALCULATION OF MOMENTS XM(NEOF), XV(NEOF)
C            AND OF EOFS OF COMPLEX POPS' FORCING.
C
      WRITE(TTXT,'(1A80)') '1TIME SERIES STATISTICS '
      CALL BOXIT (TTXT,1,40)
      PRINT190,
     *'0POP  E-FOLDING TIME OSC.PERIOD STD.DEV.   ACF(1) TAU    ANGLE
     * NOISE VARIANCE ',
     *' NR.   POP      EST.    POP      ESTIM.    EST.   EST.    DEG.
     *   EOF1  EOF2'
      XVM = 0.
      KK=0
      K = 0
11010 K = K+1
      KK=KK+1
            DO 11110 I = 1,NTO
                  TS1(I) = POPC(K,I)
11110             CONTINUE
            CALL STAT(TS1,NTO,XM(K),XV(K),ACF,TAU)
            IF (XV(K) .GT. XVM) XVM = XV(K)
            IF(POPPER(K).NE.0.) THEN
                  DO 11210 I = 1,NTO
                      TS2(I) = POPC(K+1,I)
11210                 CONTINUE
                  CALL STAT(TS2,NTO,XM(K+1),XV(K+1),ACF,TAU)
                  CALL NOISE(TS1,TS2,NTO,ALAMR(K),ALAMI(K),ALPHA,RR2,
     *                           RI2,WHITE, UD, VD)
                  PRINT 240,
     *                  KK, TEFOLD(K),POPPER(K),XV(K),  WHITE(1)
                  PRINT 241,
     *                      TEFOLD(K),POPPER(K),XV(K+1),WHITE(2),
     *                                               ALPHA,RR2,RI2
                  K = K+1
                  IF (XV(K) .GT. XVM) XVM = XV(K)
            ELSE
                  PRINT 230,
     *                  KK, TEFOLD(K), 1./(1.-ACF), XV(K),ACF,TAU
            ENDIF
      IF(K.LT.NEOF) GOTO 11010

C
C     -----------------------------------------------------------
C
C     12. CALCULATION OF CORRELATION MATRIX OF POP COEFFICIENT
C         TIME SERIES.
C
12000 CONTINUE
      PRINT 190, '0CORRELATION MATRIX'
      DO 12005 K=1,NEOF
      DO 12010 J = 1,K
             XCOVM(K,J) = 0.

             DO 12110 I = 1,NTO
                   XCOVM(K,J) = XCOVM(K,J) +
     *                         (POPC(K,I)-XM(K))*(POPC(J,I)-XM(J))
12110              CONTINUE
             XCOVM(K,J) = XCOVM(K,J)/(NTO*XV(K)*XV(J))
12010        CONTINUE
12005        CONTINUE
      CALL PRIMAT2( XCOVM, POPPER )
C
C     -----------------------------------------------------------
C
C     13. Calculation and output of explained local variance.
C
13000 CONTINUE
      IF(LEVPRI) PRINT '(1H1,2A)', 'EXPLAINED LOCAL VARIANCE IS ',
     *                 'CALCULATED FOR EACH SINGLE POP'

      DO 13800 K = 1, NEOF
        IF( K .GT. 1  .AND.  NUMPOP(K) .EQ. NUMPOP(K-1) )
     *    GOTO 13800

        DO 13110 JSPACE = 1, NTS
C
C*        Compute time series of errors for this space location.
C
          DO 13105 JTIME = 1, NTO
            TSDAT  = DAT( JSPACE, JTIME )
C
C           Two cases: pop complex or pop real.
C
            IF( K .LT. NEOF .AND. NUMPOP(K) .EQ. NUMPOP(K+1) ) THEN
              DO 13102 JEOF = 1,NEOF
                TSDAT = TSDAT - ( POPC(K,JTIME) *   POP(K,JEOF) +
     *                            POPC(K+1,JTIME) * POP(K+1,JEOF) ) *
     *                          EOFS(JSPACE,JEOF)
13102         CONTINUE
            ELSE
              DO 13103 JEOF = 1,NEOF
                TSDAT = TSDAT - POPC(K,JTIME) * POP(K,JEOF) *
     *                          EOFS(JSPACE,JEOF)
13103         CONTINUE
            ENDIF

            TS1( JTIME ) = TSDAT
13105     CONTINUE

          VARERR = RCCV( TS1, TS1, NTO, 0 )
          IF( LNORM ) THEN
            VARDAT = 1.0
          ELSE
            VARDAT = VAR( JSPACE )
          ENDIF
          IF( VARDAT .NE. 0 ) THEN
            WORK1( JSPACE ) = 1.0 - VARERR / VARDAT
          ELSE
            WORK1( JSPACE ) = 0.
          ENDIF
13110   CONTINUE

        IUNIT = 2
        CALL OUTDAT( IUNIT, NUMPOP(K), 0, 0, NTS, WORK1 )
C
C*    End of real-pop number *K* loop.
C
13800 CONTINUE
C
C------------------------------------------------------------------

C
C*    14. Output of e-folding times, periods and pop coefficients time series
C
      IUNIT = 8
      CALL OUTDAT( IUNIT, -1, 0, 0, NEOF, TEFOLD )
      CALL OUTDAT( IUNIT, -2, 0, 0, NEOF, POPPER )
      JEVD = 1
      DO 14500 IEVD = 1, NEOF
        IF( ALAMI( IEVD ) .NE. 0. ) THEN
        ENDIF

14500 CONTINUE
      CALL OUTMAT( IUNIT, LGAP, NUMPOP, NEODIM,
     *             -1, 0, 0, NTO, TS1,
     *             POPC, NEODIM, NSER, NEOF, .FALSE. )

      RETURN

  120 FORMAT(/' POP PAIR ',I2,' IS ROTATED SO THAT FORCING IS ',
     *        ' ORTHOGONAL ',/,' EOFS OF NOISE: '/,
     *         ' VARIANCE OF DOMINANT PATTERN: ', E10.3,/,
     *         ' VARIANCE OF SECOND PATTERN:   ', E10.3,/,
     *         ' ANGLE BETWEEN DOMINANT PATTERN AND P-POP :', F4.0,/,
     *         ' DOMINANT PATTERN:   ',F6.2,'*P + ',F6.2,'*Q',/,
     *         ' SECOND   PATTERN:  -',F6.2,'*P + ',F6.2,'*Q')
  140 FORMAT('0NO. OF EIGENVALUE',I4,' MAX. ERROR',E10.2)
  150 FORMAT(1X,'F02AGF, ERROR NO. (IFAIL = )',I3)
  160 FORMAT(/,'0POP GROUP NUMBER',I5,/,
     *      '0EIGENVALUE NO.',I5,3X,'E-FOLDING TIME',
     *      E12.4,3X,'OSCILLATION PERIOD',E12.4/)
  161 FORMAT(/,'0APOP GROUP NUMBER',I5,/,
     *      '0EIGENVALUE NO.',I5,3X,'E-FOLDING TIME',
     *      E12.4,3X,'OSCILLATION PERIOD',E12.4/)
  170 FORMAT(A,/,(4X,6E12.4))
  180 FORMAT(16(3(' (',E12.4,';',E12.4,')' ),/))
  190 FORMAT(A)
  200 FORMAT(' IFAIL = ',I4)
  210 FORMAT(I4,1X,20F6.2,/,(5X,20F6.2))
  230 FORMAT(I3,1H ,F10.2,F7.2,10X,F9.2,F8.1,4F7.1)
  240 FORMAT(I3,1HR,F10.2,7X,F8.2,F11.2,A,15X,3F8.1)
  241 FORMAT(3X,1HI,F10.2,7X,F8.2,F11.2,A,15X,3F8.1)
      END
C
C==== END POPS ================================================================
C
C
C==== BEGIN STATS ( U0305 ) ===================================================
C
      SUBROUTINE STATS( PC, POP, POPC, POPPER )
C**** *STATS*- ROUTINE TO ASSESS STATISTICAL SIGNIFICANCE OF A PREDICTOR.
C
C     F.G.GALLAGHER       MPIFM    4/12/87
C
C     PURPOSE.
C     --------
C
C     *STATS* PRINTS TABLES OF STATISTICS AS DEFINED IN HASSELMANN'S
C     NOTE (BELOW).
C
C**   INTERFACE.
C     ----------
C
C         *CALL* *STATS*
C
C     METHOD.
C     -------
C
C        Y       =        X         +             R
C     PREDICTAND       PREDICTOR              ERROR
C
C        DEFINE EPSILON = SQRT(E(R**2) / E(Y**2))
C                       - RELATIVE ERROR
C
C               XI      = E(X*Y) / E(Y**2)
C
C     ----------------------------------------------
C
C       TWO CASES ARE CONSIDERED:
C
C          A) Y = DATA INPUT TO PROGRAM (*DAT*)
C             X = POP FIELD (POPS*(POPC))
C
C          B) Y = RATE OF CHANGE OF DATA (DAT(T+1)-DAT(T))
C             X = RATE OF CHANGE OF POP FIELD (POP *(POPC(T+1)-POPC(T)) )
C
C ---------------------------------------------------------------
C
C     EPSILON AND XI MAY BE COMPUTED FOR DIFFERENT CASES OF THE POP FIELD.
C
C     LET POPS = P1 + P2 + ....+ PN
C
C     1) INDEPENDENT SINGLE PREDICTION ASSESSMENT VARIABLES.
C        ---------------------------------------------------
C        EPSIN                XIIN
C
C        FOR EACH POP SEPARATELY.
C
C     2) SEQUENTIAL INCREMENTAL PREDICTION ASSESSMENT VARIABLES.
C        -------------------------------------------------------
C        EPSSN                XISN
C
C        PREDICTAND = DATA - (SUM OF POP FIELDS TO K-1)
C
C     3) COMPLEMENTARY INCREMENTAL PREDICTION ASSESSMENT VARIABLES.
C        ----------------------------------------------------------
C        EPSCN                XICN
C
C        PREDICTAND = DATA - (SUM OF ALL POP FIELDS EXCEPT K)
C
C     4) TOTAL PREDICTION ASSESSMENT VARIABLES.
C        --------------------------------------
C        EPST                  XIT
C
C        PREDICTOR = ALL POP FIELDS
C
C     EXTERNALS.
C     ----------
C
C     NONE.
C
C     REFERENCES.
C     -----------
C
C     HASSELMANN, K - INTERNAL MEMORANDUM.
C           "STATISTICAL ANALYSIS OF 'EXPLAINED VARIANCE'; APPROPRIATE
C                                             FORMALISM FOR POPS PACKAGE"
C
C
      include 'scalars.i'
      include 'arrays.i'

      DIMENSION XX(NEODIM,NEODIM,NSER),XXX(NEODIM,NEODIM)
      DIMENSION YX(NEODIM),EV(NEODIM),EVC(NEODIM)
      DIMENSION EPSIN(NEODIM),EPSSN(NEODIM),EPSCN(NEODIM)
      DIMENSION XIIN(NEODIM),XISN(NEODIM),XICN(NEODIM)
      DIMENSION IORD(NEODIM)
      LOGICAL LP(NEODIM)
      PRINT 7002
 7002 FORMAT(1H1,60('*'),/,1X,20('*'),' STATISTICS PACKAGE ',20('*'),
     *         /,1X,60('*'),//,T20,'- PLEASE SEE MANUAL FOR '
     *         ,'EXPLANATION OF QUANTITIES',//)
      PRINT 7003
 7003 FORMAT(1X,'EPS - RELATIVE ERROR',/,' XI - BIAS FACTOR',/,
     *         ' EV - EXPLAINED VARIANCE',/,
     *         ' CEV - CUMULATIVE EXPLAINED VARIANCE')
      PRINT 7004
 7004 FORMAT(/,' 3 CASES :==',/,
     *       ' *1* - INDEPENTENT SINGLE PREDICTION ASSESSMENT',/,
     *       ' *2* - SEQUENTIAL INCREMENTAL PREDICTION ASSESSMENT',/,
     *       ' *3* - COMPLEMENTARY INCREMENTAL PREDICTION ASSESSMENT')
C
C     LOOP FOR CASES A) AND B)
C
      DO 1010 JCASE=1,2
      IF(JCASE.EQ.1) THEN
C
C     CALCULATE Y2=E(Y**2)
C
      Y2=0.
      DO 1110 JTIME=1,NTO
            DO 1120 JSPACE=1,NTS
                  Y2 = Y2+PC(JSPACE,JTIME)**2
 1120             CONTINUE
 1110       CONTINUE
      Y2=Y2/NTO
C
C     IPOP = POP PAIR COUNTER
C     JPOP = POP COUNTER
C
      JPOP=0
      IPOP=0
 1210 CONTINUE
      IF (JPOP.GE.NEOF) GOTO 1299
      JPOP=JPOP+1
      IPOP=IPOP+1
      DO 1220 JTIME=1,NTO
         DO 1223 JEOF=1,NEOF
              XX(IPOP,JEOF,JTIME) = POP(JPOP,JEOF)
     *                       *POPC(JPOP,JTIME)
 1223       CONTINUE
 1220    CONTINUE

      IF (POPPER(JPOP).NE.0.) THEN
         JPOP=JPOP+1
         DO 1230 JTIME=1,NTO
            DO 1233 JEOF=1,NEOF
                 XX(IPOP,JEOF,JTIME) =XX(IPOP,JEOF,JTIME)+
     *                   POP(JPOP,JEOF) *POPC(JPOP,JTIME)
 1233          CONTINUE
 1230       CONTINUE
         ENDIF
      GOTO 1210
 1299 CONTINUE
      NPOP=IPOP

      DO 1310 JPOP=1,NPOP
         YX(JPOP)=0.
         DO 1320 JSPACE=1,NEOF
            DO 1330 JTIME=1,NTO
               YX(JPOP)=YX(JPOP)+XX(JPOP,JSPACE,JTIME)*
     *                           PC(JSPACE,JTIME)
 1330          CONTINUE
 1320       CONTINUE
         YX(JPOP)=YX(JPOP)/NTO
 1310    CONTINUE

      DO 1400 JPOP=1,NPOP
         DO 1410 IPOP=1,NPOP
            XXX(IPOP,JPOP) = 0.
            DO 1420 JTIME=1,NTO
               DO 1430 JSPACE=1,NEOF
                  XXX(IPOP,JPOP) = XXX(IPOP,JPOP) +
     *                XX(IPOP,JSPACE,JTIME)*XX(JPOP,JSPACE,JTIME)
 1430             CONTINUE
 1420          CONTINUE
            XXX(IPOP,JPOP)=XXX(IPOP,JPOP)/NTO
 1410       CONTINUE
 1400    CONTINUE
       ELSE
C
C     CALCULATE Y2=E(Y**2)
C
      Y2=0.
      DO 1510 JTIME=2,NTO
            DO 1520 JSPACE=1,NTS
                  Y2 = Y2+(PC(JSPACE,JTIME)-PC(JSPACE,JTIME-1))**2
 1520             CONTINUE
 1510       CONTINUE
      Y2=Y2/NTO

      DO 1710 JPOP=1,NPOP
         YX(JPOP)=0.
         DO 1720 JSPACE=1,NEOF
            DO 1730 JTIME=2,NTO
               YX(JPOP)=YX(JPOP)+
     *            (XX(JPOP,JSPACE,JTIME)-XX(JPOP,JSPACE,JTIME-1))*
     *                      (PC(JSPACE,JTIME)-PC(JSPACE,JTIME-1))
 1730          CONTINUE
 1720       CONTINUE
         YX(JPOP)=YX(JPOP)/NTO
 1710    CONTINUE

      DO 1800 JPOP=1,NPOP
         DO 1810 IPOP=1,NPOP
            XXX(IPOP,JPOP) = 0.
            DO 1820 JTIME=2,NTO
               DO 1830 JSPACE=1,NEOF
                  XXX(IPOP,JPOP) = XXX(IPOP,JPOP) +
     *               (XX(IPOP,JSPACE,JTIME)-XX(IPOP,JSPACE,JTIME-1))
     *            *(XX(JPOP,JSPACE,JTIME)-XX(JPOP,JSPACE,JTIME-1))
 1830             CONTINUE
 1820          CONTINUE
            XXX(IPOP,JPOP)=XXX(IPOP,JPOP)/NTO
 1810       CONTINUE
 1800    CONTINUE
         ENDIF
C
C        ORDER POPS WRT SEQUENTIAL INCREMENTAL
C
            DO 300 IPOP=1,NPOP
            LP(IPOP)=.FALSE.
 300        CONTINUE
            DO 310 IPOP=1,NPOP
            EPSOLD=9999.9
            DO 315 JPOP=1,NPOP
             IF (LP(JPOP))GOTO 315
               XYP=0.
               YP=Y2
               XYP=YX(JPOP)
                    DO 320 IIPOP=1,NPOP
                       DO 330 JJPOP=1,NPOP
                          IF((LP(JJPOP).AND.LP(IIPOP))) THEN
                          YP=YP+XXX(JJPOP,IIPOP)
                          ENDIF
 330                     CONTINUE
                       IF (LP(IIPOP)) THEN
                       XYP=XYP-XXX(JPOP,IIPOP)
                       YP=YP-2.*YX(IIPOP)
                       ENDIF
 320                  CONTINUE
               XI=XYP/YP
               EPSNEW=EPS(XI,XXX(JPOP,JPOP),YP)
               IF (EPSNEW.LT.EPSOLD)THEN
                  INDEX=JPOP
                  EPSOLD=EPSNEW
                  ENDIF
 315           CONTINUE
               LP(INDEX)=.TRUE.
               IORD(IPOP)=INDEX
 310           CONTINUE
C
C     2.1 INDEPENDENT SINGLE PREDICTION ASSESSMENT VARIABLES.
C         ---------------------------------------------------
C
            DO 2010 IPOP=1,NPOP
                  XP=XXX(IORD(IPOP),IORD(IPOP))
                  YP=Y2
                  XIIN(IORD(IPOP))=YX(IORD(IPOP))/Y2
                  EPSIN(IORD(IPOP))=EPS(XIIN(IORD(IPOP)),XP,YP)
                  EV(IORD(IPOP))=1-EPSIN(IORD(IPOP))**2
 2010             CONTINUE

C
C     2.2 TOTAL PREDICTION ASSESSMENT VARIABLES.
C         --------------------------------------
C

            XP = 0.
            YP=Y2
            XYP=0.
            DO 2210 IPOP=1,NPOP
                DO 2220 JPOP=1,NPOP
                   XP=XP+XXX(IORD(IPOP),IORD(JPOP))
 2220              CONTINUE
                XYP=XYP+YX(IORD(IPOP))
 2210           CONTINUE
            XIT=XYP/YP
            EPST=EPS(XIT,XP,YP)

C
C     2.3 SEQUENTIAL INCREMENTAL PREDICTION ASSESSMENT VARIABLES.
C         -------------------------------------------------------
C
            DO 2310 IPOP=1,NPOP
               XP=0.
               XPP=0.
               XYP=0.
               YP=Y2
               XYP=YX(IORD(IPOP))
                  DO 2312 IIPOP=1,IPOP
                     DO 2314 JJPOP=1,IPOP
                        XP=XP+XXX(IORD(JJPOP),IORD(IIPOP))
 2314                   CONTINUE
                     XPP=XPP+YX(IORD(IIPOP))
 2312                CONTINUE
                  IF(IPOP.GT.1) THEN
                    DO 2320 IIPOP=1,IPOP-1
                       DO 2330 JJPOP=1,IPOP-1
                          YP=YP+XXX(IORD(JJPOP),IORD(IIPOP))
 2330                     CONTINUE
                       XYP=XYP-XXX(IORD(IPOP),IORD(IIPOP))
                       YP=YP-2.*YX(IORD(IIPOP))
 2320                  CONTINUE
                    ENDIF
               EVC(IORD(IPOP))=(2*XPP-XP)/Y2
               XISN(IORD(IPOP))=XYP/YP
               EPSSN(IORD(IPOP))=EPS(XISN(IORD(IPOP)),
     *                      XXX(IORD(IPOP),IORD(IPOP)),YP)
 2310          CONTINUE
C
C     2.4 COMPLEMENTARY INCREMENTAL PREDICTION ASSESSMENT VARIABLES.
C         ----------------------------------------------------------
C
            DO 2410 IPOP=1,NPOP
                XYP=0.
                YP=Y2
                XP=XXX(IORD(IPOP),IORD(IPOP))
                XYP=YX(IORD(IPOP))
                DO 2420 IIPOP=1,NPOP
                   DO 2430 JJPOP=1,NPOP
                      IF (IORD(JJPOP).NE.IORD(IPOP) .AND.
     *                    IORD(IIPOP).NE.IORD(IPOP)) THEN
                          YP=YP+XXX(IORD(JJPOP),IORD(IIPOP))
                          ENDIF
 2430                 CONTINUE
                   IF (IORD(IIPOP).NE.IORD(IPOP)) THEN
                      XYP=XYP-XXX(IORD(IPOP),IORD(IIPOP))
                      YP=YP-2.*YX(IORD(IIPOP))
                      ENDIF
 2420              CONTINUE
               XICN(IORD(IPOP))=XYP/YP
               EPSCN(IORD(IPOP))=EPS(XICN(IORD(IPOP)),XP,YP)
 2410          CONTINUE

           IF (JCASE.EQ.1) THEN
              PRINT 9001
 9001         FORMAT(//,'0****STATISTICS FOR POPS PREDICTING DATA****')
             ELSE
              PRINT 9006
 9006         FORMAT(//,'0****STATISTICS FOR POPS PREDICTING RATE',
     *                                    ' OF CHANGE OF DATA****')
              ENDIF
           PRINT 9007
 9007      FORMAT(1X,T16,'*1*',T32,'*2*',T48,'*3*')
           PRINT 9008
 9008      FORMAT(' POP NO',3('   EPS    XI     '),'   EV     CEV',/)
           DO 4010 IPOP=1,NPOP
              PRINT 9002,IORD(IPOP),EPSIN(IORD(IPOP)),XIIN(IORD(IPOP))
     *           ,EPSSN(IORD(IPOP)),XISN(IORD(IPOP)),EPSCN(IORD(IPOP)),
     *           XICN(IORD(IPOP)),EV(IORD(IPOP)),EVC(IORD(IPOP))
 9002         FORMAT(1X,1I6,4(2F7.3,'  !'),/,7X,4(16X,'!'))
 4010         CONTINUE
           PRINT 9003,EPST,XIT
 9003      FORMAT('0TOTAL ',2F9.3)

 1010      CONTINUE
      RETURN
      END
C
C==== END STATS ===============================================================
C
C


C==== BEGIN CEOFAN ( U04 ) ====================================================
C
      SUBROUTINE CEOFAN( DAT, LGAP, VAR )
C
C**** *CEOFAN* - COMPLEX EOF ANALYSIS
C
C     I. FISCHER-BRUNS, MPIFM      01/10/87
C     MODIFIED BY F.G.GALLAGHER    02/03/88
C
C     PURPOSE.
C     --------
C
C     CALCULATES COMPLEX EOFS.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *CEOFAN*      (FROM *POPPRO*).
C
C     METHOD.
C     -------
C
C     CALCULATES THE (COMPLEX) EIGENVECTORS OF THE CROSS SPECTRAL
C     MATRIX AVERAGED OVER A CERTAIN FREQUENCY BAND GIVEN BY THE
C     PARAMETERS P1 AND P2.
C
C     EXTERNALS.
C     ----------
C
C     *C06ADF*  - *NAG* ROUTINE TO CALCULATE THE FINITE FOURIER
C                 TRANSFORM OF ONE VARIABLE WITHIN A MULTIVARIABLE
C                 TRANSFORM OF COMPLEX DATA VALUES (COOLEY-TUKEY
C                 ALGORITHM).
C     *F02AXF*  - *NAG* ROUTINE TO CALCULATE ALL THE EIGENVECTORS
C                 AND EIGENVALUES OF A COMPLEX HERMITIAN MATRIX.
C     *OMEGA*   - SUBROUTINE TO CALCULATE THE FREQUENCIES.
C     *STD*     - SUBROUTINE TO CALCULATE THE STANDARD DEVIATION
C                 OF A TIME SERIES.
C     *TURN*    - SUBROUTINE TO ROTATE (COMPLEX) EIGENVECTOR.
C     *ZERO*    - SUBROUTINE WHICH SETS ALL ELEMENTS OF AN ARRAY
C                 EQUAL TO ZERO.
C

      include 'scalars.i'
      include 'arrays.i'

      DIMENSION AI(NTSDIM,NTSDIM),     AR(NTSDIM,NTSDIM),
     *          AX(NSER/NCMIN),        AXLONG(NSER),
     *          BX(NSER/NCMIN),        BXLONG(NSER),
     *          CX(NSER/(2*NCMIN)+1,NTSDIM),
     *          DACH(NTSDIM,NSER),
     *          HELP1(NTSDIM,NTSDIM),  HELP2(NTSDIM,NTSDIM),
     *          IW(NSER),              R(NTSDIM),
     *          WORK11(NSER),          WORK2(NSER),
     *          WORK3(2*MICEOF,NTSDIM), WORK4(2*MICEOF,NSER),
     *          WK1(NSER),             WK2(NTSDIM),
     *          WK3(NTSDIM),           XCHUNK(NSER/NCMIN,NTSDIM),
     *          XCVM(2*MICEOF,2*MICEOF),
     *          XOM(NSER/(2*NCMIN)+1),
     *          XVC(2*MICEOF)

      DIMENSION AMPR(NTSDIM,NSER), AMPI(NTSDIM,NSER)

C*    VARIABLE     TYPE       PURPOSE.
C     --------     ----       --------
C
C     AMPR,AMPI    REAL       REAL AND IMAG. PART OF COMPLEX AMPLITUDES
C     AR,AI        REAL       REAL AND IMAG. PART OF COMPLEX EOFS
C     AX,BX        REAL       REAL FOURIERCOEFFICIENTS
C     CX           COMPLEX    COMPLEX FOURIERCOEFFICIENTS
C     IW           INTEGER    WORKSPACE
C     LC           INTEGER    LENGTH OF CHUNKS
C     NC           INTEGER    NUMBER OF CHUNKS
C     NOM          INTEGER    NUMBER OF FREQUENCIES
C     P1,P2        REAL       PERIOD INTERVAL FOR AVERAGING THE CSP M
C     R            REAL       EIGENVALUES
C     WK1,WK2,WK3  REAL       WORKSPACES
C     WORK11,2,3,4 REAL       WORKSPACES
C     XCHUNK       REAL       TIME SERIES CHUNKS
C     XCVM         REAL       WORKSPACE
C     XOM          REAL       FREQUENCIES (BETWEEN 0. AND .5)
C     XVC          REAL       WORKSPACE
C
      NIW = NSER
      NW1 = NSER
      NW2 = NSER
      CALL ZERO(XCHUNK,(NSER/NCMIN)*NTSDIM)
      NCEOF=MIN0(NCEOF,NTS)

C
C     -----------------------------------------------------------------
C
C          2.  FREQUENCY DOMAIN
C
C          2.1 CALCULATION OF NUMBER OF CHUNKS AND NUMBER OF FREQUENCIES.
C
      IF(LEVPRI) THEN
            CALL BOXIT(TITLE,1,80)
            WRITE(TTXT,'(A80)') ' CALCULATION OF COMPLEX EOFS '
            CALL BOXIT(TTXT,0,40)
            ENDIF
      LC  = NTO / NC
      NOM = LC/2 + 1
      XN  = SQRT( FLOAT(LC*LC*NC) / 2. )

C
C     ------------------------------------------------------------
C
C*         2.2 CALCULATION OF FREQUENCIES.
C
      IF(P1.GT.LC.OR.P1.LT.2.) THEN
         PRINT*, ' P1 OUT OF RANGE'
	 STOP
      ENDIF
      IF(P2.GT.LC.OR.P2.LT.2.) THEN
         PRINT*, ' P2 OUT OF RANGE'
	 STOP
      ENDIF
      IF(P1.GE.P2) THEN
         F1=1./P1
         F2=1./P2
      ELSE
         F1=1./P2
         F2=1./P1
      ENDIF
      CALL OMEGA(XOM,NOM)
      CALL ZERO(AR,NTSDIM*NTSDIM)
      CALL ZERO(AI,NTSDIM*NTSDIM)
 2000 CONTINUE

C
C     ------------------------------------------------------------
C
C*         3. CALCULATION OF MEAN STANDARD DEVIATION
C*            FOR NORMALISATION OF TIME SERIES.
C
C
      STDEV = 0.
      DO 3110 I=1,NTS
        DO 3120 J=1,NTO
 3120     WORK11(J) = DAT(I,J)
        CALL STD(WORK11,NTO,WM,SD)
        STDEV = STDEV + SD
 3110 CONTINUE
      STDEV = STDEV / NTS

      CALL ZERO(WORK11,NSER)
 3100 CONTINUE

C
C     -----------------------------------------------------------------
C
C*         4. INVERSE TRANSFORMATION FOR HILBERT TRANSFORM OF TIME SERIES
C*            (FOR CALCULATION OF COMPLEX AMPLITUDES)
C

      SQN = NTO
      SQN = SQRT(SQN)

      DO 4300 J=1,NTS

        DO 4310 L=1,NTO
          AXLONG(L) = DAT(J,L) / STDEV
          BXLONG(L) = 0.
 4310   CONTINUE

        IFAIL = 1
C
C     NAG routine *C06FCF*:
C     Discrete Fourier transform of complex data.
C
C     Relevant input:
C     *AXLONG*, *AYLONG*:    Real (imaginary) parts of given data values.
C
C     Relevant output:
C     *AXLONG*, *AYLONG*:    Real (imaginary) parts of Fourier components.
C
        CALL C06FCF(AXLONG,BXLONG,NTO,WORK11,IFAIL)
        IF(IFAIL.NE.0) GOTO 13000
        DO 4320 L=1,NTO
           AXLONG(L)=AXLONG(L)*SQN
           BXLONG(L)=BXLONG(L)*SQN
 4320   CONTINUE
C
        DO 4410 L=1,NTO
           IF(L.LT.NTO/2+2) THEN
             HI       =  AXLONG(L)
             AXLONG(L)=  BXLONG(L)
             BXLONG(L)=  HI
           END IF
           IF(L.GE.NTO/2+2) THEN
             HI       = -AXLONG(L)
             AXLONG(L)= -BXLONG(L)
             BXLONG(L)=  HI
           END IF
 4410   CONTINUE
        DO 4430 L=1,NTO
             BXLONG(L) = -BXLONG(L)
 4430   CONTINUE

        IFAIL = 1
        CALL C06FCF(AXLONG,BXLONG,NTO,WORK11,IFAIL)
        IF(IFAIL.NE.0) GOTO 13000
        DO 4420 L=1,NTO
           AXLONG(L)=AXLONG(L)*SQN
           BXLONG(L)=BXLONG(L)*SQN
 4420   CONTINUE
C
        DO 4400 L=1,NTO
 4400     DACH (J,L) = AXLONG(L) / NTO
C
C     End of loop indexed by *J*
C
 4300 CONTINUE

C
C     ------------------------------------------------------------
C
C*         5. SPLITTING OF TIME SERIES IN NC CHUNKS OF LENGTH LC
C

      DO 5200 N=1,NC

        DO 5210 L=1,LC
        DO 5210 I=1,NTS
 5210   XCHUNK(L,I) = DAT(I,(N-1)*LC+L) / STDEV

C
C     ------------------------------------------------------------
C
C*         6. CALCULATION OF FOURIER COEFFICIENTS.
C
C
C*         6.1 REAL FOURIER COEFFICIENTS
C
        SQN = LC
        SQN = SQRT(SQN)

        DO 6100 J=1,NTS

          DO 6110 L=1,LC
            AX(L) = XCHUNK(L,J)
 6110       BX(L) = 0.

          SQN=LC
          SQN=SQRT(SQN)
          IFAIL = 1
          CALL C06FCF(AX,BX,LC,WORK11,IFAIL)
          IF(IFAIL.NE.0) GOTO 13000
          DO 4450 L=1,LC
            AX(L)=AX(L)*SQN
            BX(L)=BX(L)*SQN
 4450     CONTINUE


C
C*         6.2 COMPLEX FOURIER COEFFICIENTS
C
          DO 6200 I=2,NOM
 6200       CX(I,J) = CMPLX(AX(I),BX(I)) / XN / SQN

C
C       End of loop indexed by *J*
C
 6100   CONTINUE

C
C     ------------------------------------------------------------
C
C*         7. SUMMING UP THE FREQUENCY AVERAGED CROSS SPECTRAL MATRIX.
C

        DO 7000 I=2,NOM
          DO 7100 J=1,NTS
            DO 7100 K=1,NTS
              ARE = REAL(CX(I,J))
              AIM = AIMAG(CX(I,J))
              CCX = CMPLX(ARE,-AIM) * CX(I,K)
              AR(J,K)=AR(J,K)+ REAL(CCX)
 7100         AI(J,K)=AI(J,K)+AIMAG(CCX)
 7000   CONTINUE

C
C     End of loop indexed by *N*
C
 5200 CONTINUE

C
C*         7.1 SETTING THE IMAGINARY DIAGONAL ELEMENTS EQUAL ZERO
C
      DO 7110 II=1,NTS
 7110   AI(II,II) = 0.

C
C     ------------------------------------------------------------
C
C*         8. CALCULATION OF THE COMPLEX EIGENVECTORS
C             AND ROTATION OF THE EIGENVECTORS.
C

C     PRINT 99990, ' CROSS SPECTRAL MATRIX'
C     PRINT 99991
C     DO 8071 J=1,NTS
C8071   PRINT 99993, (AR(L,J),AI(L,J),L=1,NTS)

      IFAIL = 1
C
C     NAG routine *F02AXF*:
C     Eigenvalues/vectors of a complex Hermitian matrix.
C
C     Relevant input:
C     *AR*, *AI*:       (param. 1 and 3)
C                       Real (imaginary) parts of given matrix.
C     Relevant output:
C     *R*:              Eigenvalues in ascending order.
C     *AR*, *AI*        (param. 7 and 9)
C                       Real (imaginary) parts of eigenvectors.
C
      CALL F02AXF(AR,NTSDIM,AI,NTSDIM,NTS,R,
     *               AR,NTSDIM,AI,NTSDIM,WK1,WK2,WK3,IFAIL)

      JJ = 0
      DO 8070 J=NTS,1,-1
        JJ = JJ + 1
        WK3(JJ) = R(J)
        DO 8080 L = 1,NTS
          HELP1(L,JJ) = AR(L,J)
 8080     HELP2(L,JJ) = AI(L,J)
 8070 CONTINUE
      DO 8090 J=1,NTS
        R(J) = WK3(J)
        DO 8091 L=1,NTS
          AR(L,J) = HELP1(L,J)
 8091     AI(L,J) = HELP2(L,J)
 8090 CONTINUE

      SUM   = 0.
      DO 8040 J=1,NTS
 8040   SUM = SUM + R(J)


      DO 8030 J=1,NTS
C
C     Print %-ages of CEOF variance
C
        PRINT 99995, J, 100.*R(J)/SUM
        DO 8010 L=1,NTS
          WK2(L) = AR(L,J)
 8010     WK3(L) = AI(L,J)

        CALL TURN (WK2, WK3, NTS, ALPHA, BETA,PV,PVP,PVQ)

        DO 8020 K=1,NTS
          AR(K,J) = WK2(K)*SQRT(FLOAT(NTS))
 8020     AI(K,J) = WK3(K)*SQRT(FLOAT(NTS))

 8030 CONTINUE

      IF(IFAIL.NE.0) THEN
         PRINT 99997, IFAIL
         PRINT*, ' ERROR IN F02AXF'
C
C        Conditional *STOP*!
C
         STOP
      END IF

      PRINT 99996, P1,P2,NTO,NC,NTS
      PRINT 99990, ' COMPLEX EIGENVECTORS'
      PRINT 99991

      K=0
      DO 8050 J=1,NCEOF
        K = K+1
C
C       Print eigenvalue and its %-age of variance
C       Print complex EOF
C
        PRINT 99994, K, R(J), 100.*R(J)/SUM
        PRINT 99993, (AR(L,J),AI(L,J),L=1,NTS)
        PRINT 99991
 8050 CONTINUE
C
C     Write to output file:
C     First eigenvalue in one record,
C     then all real parts,
C     then all imaginary parts of CEOFs.
C
      IUNIT =12
      CALL OUTDAT( IUNIT, -1, 0, 0, NCEOF, R )
      CALL OUTMAT( IUNIT, LGAP, MDATE, NSER,
     *             0, 0, 0, NTS,  WORK1,
     *             AR, NTSDIM, NTSDIM, NCEOF, .TRUE. )
      CALL OUTMAT( IUNIT, LGAP, MDATE, NSER,
     *             0, 0, 0, NTS,  WORK1,
     *             AI, NTSDIM, NTSDIM, NCEOF, .TRUE. )
C
C     ------------------------------------------------------------
C
C*    9. CALCULATION OF COMPLEX AMPLITUDES
C
      DO 9000 N=1,NTO
         DO 9100 K=1,NTS
           AMPR(K,N) = 0.
           AMPI(K,N) = 0.
           DO 9200 J=1,NTS
             AMPR(K,N) = AMPR(K,N) + DAT(J,N)*AR(K,J) -
     *                   DACH(J,N)*AI(K,J)
             AMPI(K,N) = AMPI(K,N) + DAT(J,N)*AI(K,J) +
     *                   DACH(J,N)*AR(K,J)
 9200      CONTINUE
 9100    CONTINUE
 9000 CONTINUE

C
C     ----------------------------------------------------------------
C
C*    10. CALCULATION OF CEOF'S DOT PRODUCTS (GEOMETRIC ORTHOGONALITY).
C

      J = 0
      MCEOF = 2*NCEOF
      DO 10000 I=1,MCEOF,2
         J = J+1
         DO 10100 L=1,NTS
               WORK3(I,L)   = AR(L,J)
               WORK3(I+1,L) = AI(L,J)
10100    CONTINUE
         DO 10110 N=1,NTO
               WORK4(I,N)   = AMPR(J,N)
               WORK4(I+1,N) = AMPI(J,N)
10110    CONTINUE
10000 CONTINUE

C
      PRINT 99990, ' CHECK OF GEOMETRIC ORTHOGONALITY'
      PRINT 99991
      DO 10200 K = 1,MCEOF
         DO 10300 J = 1,K
           XCVM(K,J) = 0.
           DO 10400 L = 1,NTS
             XCVM(K,J) = XCVM(K,J) + WORK3(K,L)*WORK3(J,L)
10400      CONTINUE
10300    CONTINUE
         PRINT 99992, K, (XCVM(K,J),J=1,K)
10200 CONTINUE


C
C     ----------------------------------------------------------------
C
C*    11. CALCULATION OF CORRELATION MATRIX OF AMPLITUDES
C
      XVM = 0.
      K = 0
11100 K = K+1
      DO 11110 I = 1,NTO
        X(I) = WORK4(K,I)
11110 CONTINUE
      CALL STAT(X,NTO,XM(K),XVC(K),ACF,TAU)
      IF (XVC(K) .GT. XVM)                  XVM = XVC(K)
      IF(K.LT.MCEOF)                        GOTO 11100
      CALL ZERO(X,NSER)
C ???
C ??? *XM* set to zero and used afterwards ??? (Remark by G. Hannoschoeck)
C ???
      CALL ZERO(XM,NTSDIM)

      K = 0
11200 K = K + 1
      DO 11210 J = 1,K
        XCVM(K,J) = 0.
        DO 11220 L = 1,NTO
          XCVM(K,J) = XCVM(K,J) +
     *                 (WORK4(K,L)-XM(K))*(WORK4(J,L)-XM(J))
11220   CONTINUE
        XCVM(K,J) = XCVM(K,J)/(NTO*XVC(K)*XVC(J))
11210 CONTINUE

      IF (K .LT. MCEOF)                      GOTO 11200

      IPLOT = 11
      XVM = 3.*XVM
C----------      WRITE(1,'(I2)') IPLOT
C----------      WRITE(1,'(E13.6)')   XVM
      PRINT 99991
      PRINT 99990, ' CORRELATION MATRIX'
      PRINT 99991

      DO 11230 K = 1,MCEOF
        PRINT 99992, K, (XCVM(K,J),J=1,K)
11230 CONTINUE

C
C     Write CEOF amplitudes (real time series)
C
      DO 11240 K= 1,MCEOF
      CALL OUTMAT( IUNIT, MDATE, 0, 0, 0, NTO, TS1,
     *             WORK4, 2*MICEOF, NSER, MCEOF, .FALSE. )
11240 CONTINUE

      GOTO 12000

13000 PRINT 99998, IFAIL
C     PRINT 99989, (IW(I),I=1,5)

12000 RETURN

99998 FORMAT(' FAILURE IN C06ADF, IFAIL = ',I4)
99997 FORMAT(' FAILURE IN F02AXF, IFAIL = ',I4)
99996 FORMAT ('1COMPLEX EOFS, AVERAGED BETWEEN PERIODDS',
     *  F7.2, 'AND', F7.2,/,
     *   'TIME SERIES LENGTH                 ',I5,/,
     *   'NUMBER OF CHUNKS                  ',I5,/,
     *   'NUMBER OF TIME SERIES              ',I5,///)
99995 FORMAT(/,1X,I2,'. CEOF,   ', F6.2, ' % VARIANCE',/)
99994 FORMAT(' N0.',I3,3X,'EIGENVALUE = ',F6.2,5X,F6.2,' % VARIANCE',/)
99993 FORMAT( 6(3X,'(',F7.4,' , ',F7.4,')') )
99992 FORMAT(I4,1X,20F6.2,/,(5X,20F6.2))
99991 FORMAT(///)
99990 FORMAT(A)
99989 FORMAT (1H ///3X, 18HOPTIMUM VALUES ARE/2X, 6HIW(1)=, I7/2X,
     * 6HIW(2)=, I5/2X, 6HIW(3)=, I6/2X, 6HIW(4)=, I6/2X, 6HIW(5)=,
     * I6///)

      END
C
C==== END CEOFAN ==============================================================
C
C
C==== BEGIN OMEGA ( U0401 ) ===================================================
C
      SUBROUTINE OMEGA(XOM,NOM)
C**** *OMEGA* - SUBROUTINE TO CALCULATE THE FREQUENCIES
C
C     I. FISCHER-BRUNS, MPIFM      01/10/87
C
C     PURPOSE.
C     --------
C
C     *STD* CALCULATES FREQUENCIES
C
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *OMEGA(XOM,NOM)*
C
C            *XOM(NOM)*  - TIME SERIES.
C
C
      DIMENSION XOM(NOM)
      DOM      =  .5 / FLOAT(NOM-1)
      DO 1000 IOM=1,NOM
 1000   XOM(IOM) = DOM * FLOAT(IOM-1)
      RETURN
      END
C
C==== END OMEGA ===============================================================
C
C


C==== BEGIN STD ( S01 ) =======================================================
C
      SUBROUTINE STD(X,N,XM,SD)
C**** *STD* - SUBROUTINE TO CALCULATE THE STANDARD DEVIATION
C             OF A TIME SERIES.
C
C     I. FISCHER-BRUNS, MPIFM      01/10/87
C     MODIFIED BY F.G.GALLAGHER    04/11/87 - CHANGE ALGORITHM
C     MODIFIED BY H. V. STORCH     07/08/88 - SO FAR THE PROGRAM
C                                             CALCULATED THE SQURE ROOT
C                                             OF THE SECOND MOMENT, NOT
C                                             OF THE CENTERED 2ND MOMENT.
C
C     PURPOSE.
C     --------
C
C     *STD* CALCULATES THE MEAN AND THE STANDARD DEVIATION
C
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *STD( X, N, XM, SD)*
C
C            *X(N)*  - TIME SERIES        (input).
C            *N*     - LENGTH             (input).
C            *XM*    - MEAN VALUE         (output).
C            *SD*    - STANDARD DEVIATION (output).
C
C
      DIMENSION X(N)

      XM= 0.
      XMS = 0.
      DO 1110 J=1,N
            XM = XM + X(J)
            XMS = XMS + X(J)*X(J)
 1110       CONTINUE

      XM=XM/N
      VAR = XMS/N - XM**2
      IF(VAR.LT.0.) VAR = 0.
      SD = SQRT(VAR)

 1010 CONTINUE

      RETURN
      END
C
C==== END STD =================================================================
C
C
C==== BEGIN RCCV ( S02 ) ======================================================
C
      FUNCTION RCCV (TS1,TS2,NTO,ITAU)
C
C**** *RCCV* - CALCULATES CROSS COVARIANCE FUNCTION
C
C     T. BRUNS, MPIFM             01/02/87
C     MODIFIED BY F.G. GALLAGHER   15/07/87 .
C
C     PURPOSE.
C     --------
C
C     CROSS COVARIANCE FUNCTION VALUE BEC     TS2 OF LENGTHS NT AT DISCRETE LAG ITAU.
C     THE LAG IS IN TS2 AND ALWAYS ZERO OR POSITIVE
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *RCCV(TS1,TS2,NTO,ITAU)*
C
C          *TS1*   -  FIRST TIME SERIES.
C          *TS2*   -  SECOND TIME SERIES.
C          *NTO*   -  LENGTH OF TIME SERIES.
C          *ITAU*  -  DISCRETE LAG OF TS2 WRT TS1.
C
C     METHOD.
C     -------
C
C     CALCULATES CROSS COVARIANCE FUNCTION BY A DISCRETE "OVERLAP
C     INTEGRAL" TAKING INTO ACCOUNT THE DISCRETE LAG.
C
      DIMENSION TS1(NTO),TS2(NTO)
C

      RCCV = 0.
      NDO = NTO - ITAU
      DO 1 IT=1,NDO
      RCCV = RCCV + TS1(IT+ITAU)*TS2(IT)
    1 CONTINUE
      RCCV = RCCV / NTO
      RETURN
      END
C
C==== END RCCV ================================================================
C
C
C==== BEGIN TURN ( S03 ) ======================================================
C
      SUBROUTINE TURN (P,Q, N, ALPHA, BETA, LEVPRI, PV,PVP,PVQ)
C**** *TURN*  -  ROTATES AND NORMALISES COMPLEX EIGENVECTORS.
C
C     H. V.STORCH, MPIFM            01/07/87
C     MODIFIED BY I. FISCHER-BRUNS  01/10/87
C
C     PURPOSE.
C     --------
C
C     *TURN* ROTATES COMPLEX EIGENVECTORS. THE NEW EIGENVECTOR HAS
C     GEOMETRICALLY ORTHOGONAL REAL AND IMAG PARTS AND UNIT LENGTH.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *TURN(P,Q,N,ALPHA,BETA)*
C
C           *P*            REAL PART OF THE EIGENVECTOR.
C           *Q*            IMAG PART OF THE EIGENVECTOR.
C           *N*            LENGTH OF THE EIGENVECTOR.
C           *ALPHA*        REAL PART OF ..
C           *BETA*         IMAG PART OF ..
C
C     METHOD.
C     -------
C
C     ROTATION OF COMPLEX EIGENVECTOR P+IQ BY (ALPHA + I BETA), SUCH
C     THAT THE NEW EIGENVECTOR P+I Q HAS GEOMETRICALLY ORTHOGONAL
C     REAL AND IMAGINARY PART, I.E. (P,Q) = 0 (and (P,P) + (Q,Q) = 1).
C
C      INPUT: REALPART P AND IMAGINARY PART Q OF UNROTATED EIGENVECTOR
C             OF LENGTH N
C      OUTPUT: REALPART AND IMAGINARY PART P AND Q OF ROTATED EIGENVECTOR
C             REALPART AND IMAGINARY PART, ALPHA AND BETA, OF COMPLEX
C             NUMBER ALPHA + I*BETA
C
C
      DIMENSION P(N), Q(N)
      LOGICAL LEVPRI
C
C   CALCULATION OF SCALAR PRODUCTS P*P, Q*Q AND P*Q
C
      PP = 0.
      QQ = 0.
      PQ = 0.
      DO 1 K = 1,N
            PP = PP + P(K) * P(K)
            QQ = QQ + Q(K) * Q(K)
            PQ = PQ + P(K) * Q(K)
   1        CONTINUE

      IF (PQ.EQ.0.) THEN
            PRINT *, ' VECTOR ARE ALREADY ORTHOGONAL'
            ALPHA = 1
            BETA = 0.
            GOTO 3
            ENDIF
C
C    CALCULATION OF ALPHA AND BETA
C
      XX = (PP - QQ)/(2.*PQ)
      BETA = XX + SQRT( XX*XX + 1.)
      ALPHA = SQRT (1./(1. + BETA*BETA))
      BETA  = BETA*ALPHA
C
      IF(LEVPRI) THEN
      PRINT *, ' LENGTH OF RAW EIGENVECTOR: ', SQRT(PP + QQ)
      PRINT *, ' SCALAR PRODUCTS: PP, QQ, PQ:' , PP,QQ,PQ
      PRINT *, ' NEW VECTORS ARE:'
      PRINT '(A,F5.2,A,F5.2,A)', ' P(NEU) = ', ALPHA,'*P - ',BETA,'*Q'
      PRINT '(A,F5.2,A,F5.2,A)', ' Q(NEU) = ', BETA,'*P + ',ALPHA,'*Q'
      ENDIF
C
C    ROTATION OF INPUT EIGENVECTOR
C
   3  PP = 0.
      QQ = 0.
      PQ = 0.
      DO 2 K = 1,N
            TEMP = P(K)
            P(K) = ALPHA * TEMP - BETA  * Q(K)
            Q(K) = BETA  * TEMP + ALPHA * Q(K)
            PP = PP + P(K) * P(K)
            QQ = QQ + Q(K) * Q(K)
            PQ = PQ + P(K) * Q(K)
    2       CONTINUE
C
C  NORMALISATION OF OUTPUT EIGENVECTOR
C
      PVP=SQRT(PP)
      PVQ=SQRT(QQ)
      PV = SQRT(PP + QQ)
      DO 4 K = 1,N
            P(K) = P(K)/PV
            Q(K) = Q(K)/PV
    4       CONTINUE
      RETURN
      END
C
C==== END TURN ================================================================
C
C
C==== BEGIN NOISE ( S04 ) =====================================================
C
      SUBROUTINE NOISE (AP,AQ,N,ER,EI,ALPHA,RR2,RI2,WHITE,U,V)
C
C**** *NOISE* - CALCULATION OF 2D NOISE VECTOR.
C
C     H. V.STORCH,      MPIFM      30/06/87
C     MODIFIED BY F.G. GALLAGHER   22/07/87 .
C
C
C     PURPOSE.
C     --------
C
C     CALCULATION OF THE TWO-DIMENSIONAL NOISE VECTOR (RR,RI) OF THE POP MODEL.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *NOISE (AP,AQ,N,ER,EI,ALPHA,RR2,RI2,WHITE,U,V)*
C
C     METHOD.
C     -------
C
C     AP(T+1) =  ER*AP(T) - EI*AQ(T) + RR(T+1)
C     AQ(T+1) =  EI*AP(T) + ER*AQ(T) + RI(T+1)
C
C     DERIVATION OF EOFS OF NOISE-VECTOR GIVEN BY ANGLE <ALPHA> SPANNED
C     BY FIRST EOF AND UNIT VECTOR (1,0) (TO BE IDENTIFIED WITH POP P).
C     VARIANCE <RR2> OF FIRST EOF AND <RI2> OF SECOND EOF.
C
C     CALCULATION OF AUTOCOVARIANCES OF LAG 1-100 OF BOTH (UNROTATED)
C     NOISE TIME SERIES; COUNTING OF LAGS LARGER THAN 1.96/SQRT(N)
C
C     FIRST ROTATED POP FORCED BY FIRST NOISE EOF, P^, IS GIVEN BY
C                                                      U*P+V*Q
C     SECOND ROTATED POP FORCED BY FIRST NOISE EOF, Q^, IS GIVEN BY
C                                                     -V*P + U*Q
C     POP COEFFICIENT OF FIRST ROTATED POP, P^ BY  U*AP + V*AQ,
C      "       "       " SECOND  "      " , Q^ BY -V*AP + U*AQ
C
C     (SEE DATA STATEMENT)
C
C     EXTERNALS.
C     ----------
C
C     NONE.
C
      include 'scalars.i'

      DIMENSION AP(N), AQ(N), RR(NSER), RI(NSER), AUTO(100)
      CHARACTER WHITE(2)*1
      IF(N.GT.NSER) THEN
            PRINT *, '0SUBROUTINE NOISE: N = ', N, ' > NSER'
            PRINT*, ' NOISE: N TOO LARGE'
	    STOP
            ENDIF
C
C     -------------------------------------------------------------
C
C*    1. CALCULATION OF NOISE TIME SERIES.
C
C         NOISE COVARIANCE MATRIX IS: ( AA CC )
C                                     ( CC BB )
C         AM AND BM ARE MEANS OF NOISE TIME SERIES
C
 1000 CONTINUE

      AA = 0.
      BB = 0.
      CC = 0.
      AM = 0.
      BM = 0.
      DO 1010 K = 2, N
            RR(K) = AP(K) - ER*AP(K-1) + EI*AQ(K-1)
            RI(K) = AQ(K) - EI*AP(K-1) - ER*AQ(K-1)
            AM = AM + RR(K)
            BM = BM + RI(K)
            AA = AA + RR(K)**2
            BB = BB + RI(K)**2
            CC = CC + RR(K)*RI(K)
 1010       CONTINUE

      AM = AM/(N-1.)
      BM = BM/(N-1.)
      AA = AA/(N-1.) - AM**2
      BB = BB/(N-1.) - BM**2
      CC = CC/(N-1.) - AM*BM
      XX = SQRT ( ((AA-BB)/2.)**2 + CC**2 )
      RR2 = (AA+BB)/2. + XX
      RI2 = (AA+BB)/2. - XX
      U = 1.
C
C     -----------------------------------------------------------
C
C*    2. ????????????
C
 2000 CONTINUE

      IF(ABS(CC).GT.1.E-10) THEN
            V = ( (BB-AA)/2. + XX )/CC
            XX = SQRT(U**2 + V**2)
            U = U/XX
            V = V/XX
         ELSE
            V = 0
            ENDIF
C
C     -----------------------------------------------------------
C
C*    3. ????????????
C
 3000 CONTINUE

      ALPHA = ATAN2(V,U)*180./3.14

      WHITE(1) = ' '
      WHITE(2) = ' '
      IIR = 0.
      III = 0
      XKRIT = 1.96/SQRT(FLOAT(N))

      DO 3010 L = 1,100
            AUTO(L) = 0.
            DO 3110 K = L+2,N
                  AUTO(L) = AUTO(L) + (RR(K)-AM)*(RR(K-L)-AM)
 3110             CONTINUE
            AUTO(L) = AUTO(L)/(AA*N)
            IF(AUTO(L).GT.XKRIT) IIR = IIR + 1
            AUTO(L) = 0.
            DO 3120 K = L+2,N
                  AUTO(L) = AUTO(L) + (RI(K)-BM)*(RI(K-L)-BM)
 3120             CONTINUE
            AUTO(L) = AUTO(L)/(BB*N)
            IF(AUTO(L).GT.XKRIT) III = III + 1
 3010       CONTINUE
      IF (IIR.GT.9) WHITE(1) = '*'
      IF (III.GT.9) WHITE(2) = '*'
C
C     PRINT *, ' WHITE NOISE TEST ;',IIR,' + ',III,'%'
C
      RETURN
      END
C
C==== END NOISE ===============================================================
C
C
C==== BEGIN WINK1 ( S05 ) =====================================================
C
      SUBROUTINE WINK1 (P,Q, N, ALPH, INN, LEVPRI)
C
C**** *WINK1*  -  CALCULATES ANGEL BETWEEN P AND Q
C
C
C     *CALL* *WINK1 (P,Q,N,ALPH,INN,LEVPRI)*
C
C           *P*            REAL POP
C           *Q*            REAL APOP
C           *N*            DIMENSION OF THE EIGENVECTOR.
C           *ALPH*         ANGLE
C           *INN*          NUMBER OF APOP
C
C
      DIMENSION P(N), Q(N)
      LOGICAL LEVPRI
C
C   CALCULATION OF SCALAR PRODUCTS P*P, Q*Q AND P*Q
C
      PP = 0.
      QQ = 0.
      PQ = 0.
      DO 1 K = 1,N
            PP = PP + P(K) * P(K)
            QQ = QQ + Q(K) * Q(K)
            PQ = PQ + P(K) * Q(K)
   1        CONTINUE

      IF (PQ.EQ.0.) THEN
            PRINT *, ' VECTOR NO.',INN, 'ARE ALREADY ORTHOGONAL'
            ENDIF

C
C     ANGLE BETWEEN P ANS Q
C
      PHIX = 4. * ATAN(1.0)
      ALPH = ACOS(PQ/SQRT(PP*QQ))*180. / PHIX

      IF(LEVPRI) THEN
      PRINT *, ' LENGTH OF APOP', INN, ' = ', SQRT(PP + QQ)
      PRINT *, ' SCALAR PRODUCTS: PP, QQ, PQ: ' , PP,QQ,PQ
      PRINT *, ' ANGLE BETWEEN P, Q ', ALPH
      ENDIF

      RETURN
      END
C
C==== END WINK1 ===============================================================
C
C
C==== BEGIN WINK2 ( S06 ) =====================================================
C
      SUBROUTINE WINK2 (P1,Q1,P2,Q2, N, ALPH, INN, LEVPRI)
C
C**** *WINK2*  -  CALCULATES ANGLE BETWEEN POP P AND ADJOINT Q
C
C
C     *CALL* *WINK2 (P,Q,N,ALPH,INN,LEVPRI)*
C
C           *P=P1+IP2*     COMPLEX POP
C           *Q=Q1+IQ2*     COMPLEX APOP
C           *N*            DIMENSION OF THE EIGENVECTOR.
C           *ALPH*         ANGLEL
C           *INN*          NUMBER OF APOP
C
C
      DIMENSION P1(N), Q1(N), P2(N), Q2(N)
      LOGICAL LEVPRI
C
C   CALCULATION OF SCALAR PRODUCTS P*P, Q*Q AND P*Q
C
      PP = 0.
      QQ = 0.
      PQ = 0.
      DO 1 K = 1,N
            PP = PP + P1(K)*P1(K) + P2(K)*P2(K)
            QQ = QQ + Q1(K)*Q1(K) + Q2(K)*Q2(K)
            PQ = PQ + P1(K)*Q1(K) + P2(K)*Q2(K)
   1        CONTINUE

      IF (PQ.EQ.0.) THEN
            PRINT *, ' VECTOR NO.',INN, 'ARE ALREADY ORTHOGONAL'
            ENDIF

C
C    ANGLE  BETWEEN P ANS Q
C
      PHIX = 4. * ATAN(1.0)
      ALPH = ACOS(PQ/SQRT(PP*QQ))*180. / PHIX

      IF(LEVPRI) THEN
      PRINT *, ' LENGTH OF APOP', INN, ' = ', SQRT(PP + QQ)
      PRINT *, ' SCALAR PRODUCTS: PP, QQ, PQ:' , PP,QQ,PQ
      PRINT *, ' ANGLE BETWEEN P, Q ', ALPH
      ENDIF

      RETURN
      END
C
C==== END WINK2 ===============================================================
C
C
C==== BEGIN EOFREC ( S07 ) ====================================================
C
      SUBROUTINE EOFREC( EOFS, EOFVVV, VVV )
C
C**** *EOFREC* RECONSTRUCTS VECTOR IN PHYSICAL SPACE.
C
C     H. V.STORCH, MPIFM           15/09/86
C     MODIFIED BY F.G. GALLAGHER   20/07/87
C
C     PURPOSE.
C     --------
C
C     *EOFREC* RECONSTRUCTS VECTOR IN PHYSICAL SPACE.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *EOFREC(EOFVVV,NTS,NEOF,VVV)*
C
C           *EOFS*         Empirical Orthogonal Functions
C           *VVV*          RECONSTRUCTED NTS-VECTOR.
C           *NTS*          NO OF TIME SERIES.
C           *NDF*          NO OF DEGREES OF FREEDOM.
C           *EOFVVV*       EOF AMPLITUDES.
C
C     METHOD.
C     -------
C
C     RECONSTRUCTS VECTOR IN PHYSICAL SPACE OUT OF EOF-AMPLITUDES.
C     NO. OF DEGREES OF FREEDOM (NEOF) IS LESS THAN OR EQUAL TO TOTAL NO.
C     OF TIME SE DEGREES OF FREEDOM (NEOF) IS LESS THAN OR EQUAL TO TOTAL NO.
C     OF TIME SERIES (NTS). EOFVVV ARE THE GIVEN EOF AMPLITUDES.
C     ON EXIT, VVV CONTAINS THE RECONSTRUCTED NTS-VECTOR IN PHYSICAL
C     SPACE.
C
C     EXTERNALS.
C     ----------
C
C     NONE.
C
      include 'scalars.i'
      include 'arrays.i'

      DIMENSION VVV(NTS),EOFVVV(NEOF)

      DO 1010 IZR=1,NTS
            VVV(IZR) = 0.
            DO 1110 IEOF=1,NEOF
                  VVV(IZR) = VVV(IZR) + EOFVVV(IEOF)*EOFS(IZR,IEOF)
 1110             CONTINUE
 1010       CONTINUE

      RETURN
      END
C
C==== END EOFREC ==============================================================
C
C
C==== BEGIN STAT ( S08 ) ======================================================
C
      SUBROUTINE STAT(X,N,XM,XV,R,DT)
C
C**** *STAT* - .....
C
C     H. V.STORCH,      MPIFM      15/09/86
C
C     INPUT: 1-DIMENSIONAL REAL VECTOR X(N)
C     TEXT:  STRING OF LENGTH 30
C
C     CALCULATION OF 1ST AND 2ND MOMENT OF TIME SERIES X(1)...X(N)
C     OF DECORRELATIONTIME (1+R)/(1-R)   (CF. SCRIPT (8.29))
C
      DIMENSION X(N)
      XM = 0
      XV = 0
      R = 0
      DO 1 I = 1,N
            XM = XM + X(I)
            XV = XV + X(I)*X(I)
    1       CONTINUE

      XM = XM/N
      XV = XV/N - XM*XM

      DO 2 I = 1,N-1
            R = R + (X(I)-XM)*(X(I+1)-XM)
    2       CONTINUE

      R = R/(N*XV)
      IF(R.NE.1.) THEN
      DT = (1+R)/(1-R)
      ELSE
      DT =0.
      END IF
      XV = SQRT(XV)

      RETURN
      END
C
C==== END STAT ================================================================
C
C
C==== BEGIN EPS ( S09 ) =======================================================
C
      FUNCTION EPS(XI,X,Y)
C     EPS=SQRT(1.-2*XI+X/Y)
      EPS=(1.-2*XI+X/Y)
      IF(EPS.GT.0.) EPS=SQRT(EPS)
      RETURN
      END
C
C==== END EPS =================================================================
C
C
C==== BEGIN EVDIA ( S10 ) =====================================================
C
      SUBROUTINE EVDIA(EV,N,NMAX)
C
C**** *EVDIA* - EIGENVALUE DIAGNOSIS.
C
C     H. V.STORCH, MPIFM         15/09/86
C     MODIFIED BY F.G. GALLAGHER 20/7/87
C     G. HANNOSCHOECK            1984, 1991 (Limited output)
C
C     PURPOSE.
C     --------
C
C     *EVDIA* GIVES A DIAGNOSIS OF THE EIGENVALUES - IN PARTICULAR IT
C     GIVES A PRINTOUT OF THEIR VALUES AND THEIR CUMULATIVE VARIANCES.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *EVDIA(EV,N,NMAX)*
C
C            *EV(N)*  - ARRAY OF EIGENVALUES.
C

      include 'scalars.i'
      include 'arrays.i'

      DIMENSION EV(N)

C
C*    VARIABLE     TYPE      PURPOSE.
C     --------     ----      --------
C
C     *N*         INTEGER    DIMENSION OF THE EIGENVALUE ARRAY.
C     *NMAX*      INTEGER    PRINT LIMIT FOR RELEVANT INDICES.
C     *EV*        REAL       ARRAY OF EIGENVALUES.
C     *H*         REAL       CUMULATIVE VARIANCE.
C
      SPUR = 0.
      DO 1010 K=1,N
            SPUR = SPUR + EV(K)
            WORK1(K) = SPUR
 1010       CONTINUE

      PRINT 100, SPUR
      PRINT 200, 'EIGENVALUES', (EV(K),K=1,NMAX)
      PRINT 200, 'CUMULATIVE VARIANCES', (WORK1(K),K=1,NMAX)
      SPUR = SPUR/100.

      DO 2010 K=1,N
            EV(K) = EV(K)/SPUR
            WORK1(K) = WORK1(K)/SPUR
 2010       CONTINUE

      PRINT 300, 'PERCENTAGES OF EIGENVALUES', (EV(K),K=1,NMAX)
      PRINT 300, 'PERCENTAGES OF CUMULATIVE VARIANCES',
     *           (WORK1(K),K=1,NMAX)
      RETURN

  100 FORMAT('0EIGENVALUE DIAGNOSIS',//,' TRACE = ',E20.4)
  200 FORMAT(//,1X,A,/,(1X,6E12.4))
  300 FORMAT(//,1X,A,/,(1X,6F12.1))

      END
C
C==== END EVDIA ===============================================================
C
C


C==== BEGIN BOXIT ( O01 ) =====================================================
C
      SUBROUTINE BOXIT(TITLE,ITYPE,ISIZE)
C**** *BOXIT* - SUBROUTINE TO PRINT TITLE STRING IN A BOX
C
C     F.G.GALLAGHER 18/2/88

      CHARACTER TITLE*80,TT*80
C
C     CENTRE TITLE
C
      IP1=1
   10 CONTINUE
      IF(TITLE(IP1:IP1).EQ.' ') THEN
            IP1=IP1+1
            IF(IP1.EQ.81)THEN
                  IF(ITYPE.EQ.1) PRINT'(1H1)'
                  IF(ITYPE.EQ.0) PRINT'(1H0)'
                  GOTO 99
                  ENDIF
            GOTO 10
            ENDIF
      IP2=80
   20 CONTINUE
      IF(TITLE(IP2:IP2).EQ.' ') THEN
            IP2=IP2-1
            GOTO 20
            ENDIF
      WRITE(TT,'(80(1H*))')
      ILEN=IP2-IP1+1
      IF(ISIZE.EQ.80) THEN
      IST=41-ILEN/2
      IEND=IST+ILEN-1
C     PRINT*,'ILEN ETC',IP1,IP2,ILEN,IST,IEND
      IF(ILEN.LE.78) THEN
            WRITE(TT(IST-1:IEND+1),'(1X,A,1X)') TITLE(IP1:IP2)
          ELSE
            WRITE(TT(IST:IEND),'(A)')           TITLE(IP1:IP2)
            ENDIF
      IF(ITYPE.EQ.1) THEN
            PRINT'(1H1,80(1H*),/,1X,A80,/,1X,80(1H*))',TT
          ELSE
            PRINT'(1H0,80(1H*),/,1X,A80,/,1X,80(1H*))',TT
            ENDIF
         ELSE
      IST=21-ILEN/2
      IEND=IST+ILEN-1
C     PRINT*,'ILEN ETC',IP1,IP2,ILEN,IST,IEND
      IF(ILEN.LE.38) THEN
            WRITE(TT(IST-1:IEND+1),'(1X,A,1X)') TITLE(IP1:IP2)
          ELSE
            WRITE(TT(IST:IEND),'(A)')           TITLE(IP1:IP2)
            ENDIF
      IF(ITYPE.EQ.1) THEN
            PRINT'(1H1,40(1H*),/,1X,A40,/,1X,40(1H*))',TT(1:40)
          ELSE
            PRINT'(1H0,40(1H*),/,1X,A40,/,1X,40(1H*))',TT(1:40)
            ENDIF
            ENDIF
 99   RETURN
      END
C
C==== END BOXIT ===============================================================
C
C
C==== BEGIN PRIMAT2 ( O02 ) ===================================================
C
      SUBROUTINE PRIMAT2( XCOVM, POPPER )
C
C**** *PRIMAT2* - SUBROUTINE TO PRINT OUT A MATRIX
C
C     F.G.GALLAGHER   MPIFM          14/12/87
C     Modification by G.Hannoschoeck 03/01/91:
C       If *NEOF* > 18, then print 18 elements in each line only.
C
C*    PURPOSE
C     -------
C
C     PRINTS OUT LOWER TRIANGLE OF (SYMMETRIC) MATRIC *XCOVM* -
C            USED FOR CORRELATIONS AND ORTHOGONALITY PRINTOUTS.
C      SEPARATES ELEMENTS INTO REAL/COMPLEX GROUPS.
C
      include 'scalars.i'
      include 'arrays.i'
C
      CHARACTER YS*132

      IF( 18 .LT. NEOF )
     *  PRINT *, '*** WARNING: ONLY THE FIRST 18 ELEMENTS ARE',
     *           ' PRINTED IN EACH LINE ***'

      K=0
      KK=0
 1000 CONTINUE
      K=K+1
      KK=KK+1
      JMAX = MIN0( 18, K )
      IF(POPPER(K).NE.0.) THEN
            WRITE(YS,100) KK,(XCOVM(K,J),J=1,JMAX)
      ELSE
            WRITE(YS,101) KK,(XCOVM(K,J),J=1,JMAX)
      ENDIF

      J=0
 1010 CONTINUE
      J=J+1
      IF(POPPER(J).NE.0.)     J=J+1
      IF(J.LT. JMAX )         YS(5+7*J:5+7*J)='!'
      IF(J.LT.K)              GOTO 1010

 100  FORMAT(1X,I2,1HR,18F7.2)
 101  FORMAT(1X,I2,1X,18F7.2)
      PRINT'(A)',YS

      IF (POPPER(K).NE.0) THEN
            K=K+1
            JMAX = MIN0( 18, K )
            WRITE(YS,110) (XCOVM(K,J),J=1,JMAX)
            J=0
 1020       CONTINUE
            J=J+1
            IF(POPPER(J).NE.0.)    J=J+1
C           IF( J .LT. JMAX )      YS(5+7*J:5+7*J)='!'
            IF(J.LT.K)             GOTO 1020
            PRINT'(A)',YS
      ENDIF

 110  FORMAT(3X,1HI,18F7.2)
      PRINT 120,('-------',J=1,K)
 120  FORMAT(4X,18A7)

      IF( K .LT. NEOF )            GOTO 1000

      RETURN
      END
C
C==== END PRIMAT2 =============================================================
C
C
C==== BEGIN PRIMAT ( O03 ) ====================================================
C
      SUBROUTINE PRIMAT(LM,MD,A)
C
C**** *PRIMAT* - PRINT A MATRIX.
C
C     PURPOSE.
C     --------
C
C     *PRIMAT* CALCULATES THE TRACE OF A MATRIX AND PRINTS THE MATRIX.
C
C     INTERFACE.
C     ----------
C
C     *CALL* *PRIMAT(LM,MD,A)*
C
C           *A(MD,MD)* - GIVEN MATRIX.
C           *LM*       - ORDER OF TRACE (TERMS TO A(LM,LM) INCLUDED IN
C                        TRACE).
      DIMENSION A(MD,MD)
      TRACE=0.
      DO 1010 L=1,LM
            TRACE=TRACE+A(L,L)
 1010       CONTINUE
      PRINT 100, TRACE
      DO 1110 L=1,LM
            PRINT 200, (A(L,L1),L1=1,LM)
 1110       CONTINUE
      PRINT'(///)'
      RETURN

  100 FORMAT(//,' PRINTOUT OF MATRIX ',//,' TRACE: ',E12.4)
  200 FORMAT(/,(1X,10E12.4))
      END
C
C==== END PRIMAT ==============================================================
C
C
C==== BEGIN OUTMAT ( O04 ) ====================================================
C
      SUBROUTINE OUTMAT( KUNIT, LGAP,  NUMFLD, NUMDIM,
     *                   KDATE, KVAR,  KLEV,   KLEN,  
     *                   PWORK, PDATA, KDIM1,  KDIM2, KNREC,  LACOL )
C
C**** *OUTMAT* - Subroutine to output data in T21-format on unit *JPUNIW*
C
C     Programmed by     G. Hannoschoeck, HannoConsult       13-dec-1990
C
C     Purpose
C     -------
C     *OUTMAT* handles output of a matrix using the T21-format. It prepares
C     all the columns (or rows) of the matrix into a vector which is given
C     to the standard output procedure *OUTDAT*.
C
C     Interface
C     ---------
C     CALL OUTMAT( KUNIT, LGAP,  NUMFLD, NUMDIM,
C                  KDATE, KVAR,  KLEV,   KLEN,   PWORK,
C                  PDATA, KDIM1, KDIM2,  KNREC,  LACOL )
C
C        *KUNIT*   Logical output unit.
C        *LGAP*    Logical array for indicating gaps in the whole data field.
C                  Used only in case of *LACOL* = true and *KDATE* < 0.
C        *NUMFLD*  Array of calendar dates or other irregular numbers
C                  for *KDATE* < 0.
C        *NUMDIM*  Dimension of *NUMFLD*
C        *KDATE*   Information for the first T21 header field.
C                  If *KDATE* > 0: Transferred to *OUTDAT* unchanged.
C                  If *KDATE* = 0: Key field runs as 1, 2, 3, ...
C                  If *KDATE* < 0:
C                      This procedure will insert into the header
C                      the integer numbers from array *NUMFLD*.
C        *KVAR*    Transferred to *OUTDAT* unchanged.
C        *KLEV*    If *KDATE* < 0: starts at 1 for each new *NUMFLD*
C                                  number and is incremented by 1.
C                  Otherwise transferred to *OUTDAT* unchanged.
C        *KLEN*    Length of ONE data record (column or row) to be written.
C                  (Transferred to *OUTDAT* unchanged.)
C        *PWORK*   Working array of dimension at least *KLEN*
C        *PDATA*   Data matrix
C        *KDIM1*   First dimension of array *PDATA*
C        *KDIM2*   Second dimension of array *PDATA*
C        *KNREC*   Number of records (i.e. of columns or rows)
C                  to be written.
C        *LACOL*   True if columns are written, i.e. first index of *PDATA*
C                      runs in one T21 record.
C                  False if rows are written, i.e. second index runs fast.
C                  E.g., the global data matrix *DAT* is usually written
C                  with *LACOL* true.
C
C     Method
C     ------
C     None.
C
C     Externals
C     ---------
C     *OUTDAT*     (see below).
C
C     Reference
C     ---------
C     None.
C
C------------------------------------------------------------------------------

      include 'scalars.i'
      include 'arrays.i'

      LOGICAL   LACOL
      DIMENSION PDATA( KDIM1, KDIM2 ), PWORK( KLEN ),
     *          NUMFLD( NUMDIM )

      IDATE = 0
      ILEV = KLEV
      DO 50 J=1,KNREC

        IF( LACOL ) THEN
          DO 20 JJ=1,KLEN
            PWORK( JJ ) = PDATA( JJ, J )
 20       CONTINUE
        ELSE
          DO 30 JJ=1,KLEN
            PWORK( JJ ) = PDATA( J, JJ )
 30       CONTINUE
        ENDIF

        IF( LACOL .AND. KDATE .LT. 0 ) THEN
C
C         Reproducing the gap code in the data for tape output
C
          DO 350 JJ=1,KLEN
            IF( LGAP( JJ, J ) )      PWORK( JJ ) = PPGAP
  350     CONTINUE
        ENDIF

        IF( KDATE .GT. 0 ) THEN
          IDATE = KDATE
        ELSEIF( KDATE .EQ. 0 ) THEN
          IDATE = IDATE + 1
        ELSE
          IDATE = NUMFLD( J )
          IF( J .GT. 1  .AND.  NUMFLD(J) .EQ. NUMFLD(J-1) )  THEN
            ILEV = ILEV+ 1
          ELSE
            ILEV = 1
          ENDIF
        ENDIF

        CALL OUTDAT( KUNIT,   IDATE , KVAR, ILEV, KLEN, PWORK )

 50   CONTINUE

      RETURN
      END
C
C==== END OUTMAT ==============================================================
C
C
C==== BEGIN OUTDAT ( O05 ) ====================================================
C
      SUBROUTINE OUTDAT( KUNIT, KDATE, KVAR, KLEV, KLEN, PDATA )
C
C**** *OUTDAT* - Subroutine to output data in T21-format on unit *JPUNIW*
C
C     Programmed by     G. Hannoschoeck, HannoConsult       06-dec-1990
C
C     Purpose
C     -------
C     *OUTDAT* writes all kinds of data using the T21-format.
C     The call parameters contain all four header fields in order to
C     have a standard call. But actually written are only *KDATE*, *KLEV*
C     and *KLEN*. *KVAR* is ignored and replaced by *KUNIT*.
C     This procedure may also be called by *OUTMAT* to write one column
C     (or row) of a matrix in T21-format.
C
C     Interface
C     ---------
C     CALL OUTDAT( KUNIT, KDATE, KVAR, KLEV, KLEN, PDATA )
C
C        *KUNIT*   Logical output unit - will be copied into second variable
C                  of T21 header.
C                  Used as key to identify the kind of data in *PDATA*
C                  (see also *KLEV*).
C        *KDATE*   First header field.
C                  Calendar date in the decimal integer form [YY]YYMMDD
C                  or number of EOF, time series, etc.
C                  Key of record in combination with *KUNIT* and *KLEV*.
C        *KVAR*    Unused for header; (*KUNIT* + 500) is written instead.
C        *KLEV*    Third header field.
C                  Optionally used as additional key identifying the kind of
C                  data (e.g., "1" for real, "2" for imaginary parts).
C        *KLEN*    Fourth header field.
C                  Length of data record to be written
C        *PDATA*   Data (physical record)
C
C     Method
C     ------
C     None.
C
C     Externals
C     ---------
C     None.
C
C     Reference
C     ---------
C     MPI-HH, personal communication.
C------------------------------------------------------------------------------
      DIMENSION PDATA(*)

      WRITE( 30+KUNIT ) KDATE, 500 + KUNIT, KLEV, KLEN
      WRITE( 30+KUNIT ) ( PDATA(J),J=1,KLEN )
      RETURN
      END
C
C==== END OUTDAT ==============================================================
C
C


C==== BEGIN ICONV ( H01 ) =====================================================
C
      FUNCTION ICONV( STR, ILEN, IERR )
C**** *ICONV* - FUNCTION TO CONVERT STRING INTO INTEGER
C
C     F.G. GALLAGHER 18/2/88
C
      CHARACTER STR*20,STR2*20
      ICONV=0
      WRITE(STR2,'(20X)')
      WRITE(STR2(21-ILEN:20),'(A)') STR(1:ILEN)
      READ(STR2,'(I20)',ERR=999) ICONV
      IERR = 0
      RETURN
 999  CONTINUE
      PRINT'(48H ERROR IN FUNCTION ICONV - TRIED TO READ INTEGER,/,
     *                               10X,7HFOUND: ,A20)',STR(1:ILEN)
      PRINT*, ' ERROR IN FUNCTION ICONV; MIS-FORMED INTEGER
     *        - SEE OUTPUT'
      IERR = 1
      RETURN
      END
C
C==== END ICONV ===============================================================
C
C
C==== BEGIN RCONV ( H02 ) =====================================================
C
      FUNCTION RCONV( STR, ILEN, IERR )
C**** *RCONV* - FUNCTION TO CONVERT STRING INTO REAL
C
C     F.G. GALLAGHER 18/2/88
C
      CHARACTER STR*20,STR2*20
      RCONV = 0.
      WRITE(STR2,'(20X)')
      WRITE(STR2(21-ILEN:20),'(A)') STR(1:ILEN)
      READ(STR2,'(E20.2)',ERR=999) RCONV
      IERR = 0
      RETURN
 999  CONTINUE
      PRINT'(48H ERROR IN FUNCTION RCONV - TRIED TO READ REAL   ,/,
     *                               10X,7HFOUND: ,A20)',STR(1:ILEN)
      PRINT*, 'ERROR IN FUNCTION RCONV; MIS-FORMED REAL - SEE OUTPUT'
      IERR = 1
      RETURN
      END
C
C==== END RCONV ===============================================================
C
C
C==== BEGIN MAXPRI ( H03 ) ====================================================
C
      FUNCTION MAXPRI (N)
C
C**** *MAXPRI* - FIND MAX PRIME FACTOR.
C
C     H. V.STORCH, MPIFM      16/07/87
C     G. Hannoschoeck         31/12/90: Parameter check.
C
C     PURPOSE.
C     --------
C
C     DETERMINATION OF MAXIMUM PRIME FACTOR OF *N*
C     IF THIS FACTOR IS >19, THE OUTPUT IS 20.
C     IF *N* < 2, THE OUTPUT IS 0 (to avoid infinite loop for empty file).
C
C**   INTERFACE.
C     ----------
C
C     *MAXPRI(N)* CALLED AS FUNCTION.
C
C     METHOD.
C     -------
C
C     I COUNTS THE 8 PRIME NUMBERS (LESS THEN 20) THAT ARE TESTED.
C

C     READ IN FIRST 8 PRIME NUMBERS.

      INTEGER KF(8)
      DATA KF /2, 3, 5, 7, 11, 13, 17, 19/

      NTS2 = N
      IF( NTS2 .LT. 2 ) THEN
        MAXPRI = 0
        RETURN
      ENDIF

      I = 0
 1010 I=I+1
            IF(I.EQ.9) GOTO 1030
 1020       IF(MOD(NTS2,KF(I)).NE.0) GOTO 1010
                  NTS2 = NTS2/KF(I)
                  IF(NTS2.NE.1) GOTO 1020
      MAXPRI = KF(I)

      RETURN

 1030 MAXPRI = 20

      RETURN
      END
C
C==== END MAXPRI ==============================================================
C
C
C==== BEGIN TROS ( H04 ) ======================================================
C
      SUBROUTINE TROS(VECT,N)
C
C**** *TROS* - REVERSES THE ORDER OF COMPONENTS IN A 1D ARRAY.
C
C     H. V.STORCH,      MPIFM      15/09/86
C     MODIFIED BY F.G. GALLAGHER   20/07/87 .
C
C     PURPOSE.
C     --------
C
C     *TROS* REVERSES THE ORDER OF THE COMPONENTS OF A 1D ARRAY,
C     I.E. A VECTOR.
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *TROS(VECT,N)*
C
C          *VECT*   - VECTOR WHOSE COMPONENTS ARE TO BE REVERSED.
C          *N*      - DIMENSION OF *VECT*.
C

      DIMENSION VECT(N)
C
C*    VARIABLE     TYPE      PURPOSE.
C     --------     ----      --------
C
C     *VECT*       REAL      VECTOR WHOSE COMPONENTS ARE TO BE REVERTED.
C     *N*          INTEGER   DIMENSION OF *VECT*.
C

      N1 = N + 1
      NH = N/2
      DO 1010 I=1,NH
            P = VECT(I)
            VECT(I) = VECT(N1-I)
            VECT(N1-I) = P
 1010       CONTINUE
      RETURN
      END
C
C==== END TROS ================================================================
C
C
C==== BEGIN ZERO ( H05 ) ======================================================
C
      SUBROUTINE ZERO(A,JDIM)
C
C**** *ZERO*    - SUBROUTINE WHICH SETS ALL ELEMENTS OF AN ARRAY
C                 EQUAL TO ZERO.
C
C     I. FISCHER-BRUNS, MPIFM      01/10/87
C
C     PURPOSE.
C     --------
C
C     *ZERO* SETS THE ELEMENTS OF AN ARRAY TO ZERO
C
C
C**   INTERFACE.
C     ----------
C
C     *CALL* *ZERO(A,JDIM)*
C
C            *A(JDIM)*  - TIME SERIES.
C
C     *CALL* *ZERO*(A,IDIM*JDIM*...), IF THE ARRAY IS MULTIDIMENSIONAL
C                                (IDIM,JDIM MUST BE THE DIMENSIONS
C                                OF A AS DEFINED IN CALLING SUBPROGRAM)
C

      DIMENSION A(JDIM)
      DO 1 J=1,JDIM
    1 A(J) = 0.
      RETURN
      END
C
C==== END ZERO ================================================================
C
C
C==== BEGIN HELP ( H06 ) ======================================================
C
      SUBROUTINE HELP(KHELP,IPAR1,IPAR2,LEVPRI)
C**** *HELP* - GENERAL ADVICE
C
C     F.G.GALLAGHER  MPIFM    4/11/87
C
      LOGICAL LEVPRI

      IF (KHELP .LE.  0 .OR.  KHELP .GE. 99 ) GOTO 99
      IF (KHELP .GE. 11 .AND. KHELP .LE. 20 ) GOTO 110
      IF (KHELP .GE. 51 .AND. KHELP .LE. 98 ) GOTO 510

C
C     KHELP = 1..10 **** INPUT PARAMETER ERRORS *****************
C                                            (PARSIN)
C
      IH = KHELP
      GOTO ( 1, 2, 3, 4, 5,
     *       6, 7, 8, 9, 10  ), IH

C KHELP=1         NTS > NTSDIM
C
  1   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE PARSIN    NTS > NTSDIM'
      PRINT*,' ================================'
      PRINT*,' NTS = ',IPAR2,' NTSDIM = ',IPAR1
      PRINT*
      PRINT*,' THE NUMBER OF TIME SERIES (NTS) SPECIFIED BY THE'
      PRINT*,' USER  IS GREATER THAN THE'
      PRINT*,' MAXIMUM ALLOWED VALUE OF ',IPAR1
      PRINT*
      PRINT*,' EITHER REDUCE THE VALUE SPECIFIED ON INPUT'
      PRINT*,' OR CHANGE THE PARAMETER STATEMENT DEFINING THE'
      PRINT*,' MAXIMUM (NTSDIM = XX) TO A LARGER VALUE, BUT BE'
      PRINT*,' PREPARED IN CASE OF MEMORY LIMITATIONS.'
      PRINT*
      RETURN
C
C KHELP=2         NEOF > NEODIM
C
  2   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE PARSIN   NEOF > NEODIM'
      PRINT*,' ================================'
      PRINT*
      PRINT*,' THE NUMBER OF EMPIRICAL ORTHOGONAL FUNTIONS (NEOF)'
      PRINT*,' SPECIFIED IS GREATER THAN THE MAXIMUM NUMBER ALLOWED.'
      PRINT*
      PRINT*,' PLEASE EITHER REDUCE THE VALUE IN THE NAMELIST'
      PRINT*,' TO LESS THAN THE MAXIMUM OF ',IPAR1
      PRINT*,' OR CHANGE THE MAXIMUM ALLOWED VALUE BY CHANGING'
      PRINT*,' THE FORTRAN PARAMETER STATEMENT (NEODIM = XX)'
      PRINT*
      RETURN
C
C KHELP=3         NTO > NSER
C
  3   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE PARSIN    NTO> NSER'
      PRINT*,' ================================'
      PRINT*,' NTO = ',IPAR2,' NSER   = ',IPAR1
      PRINT*
      PRINT*,' THE NUMBER OF TIME STEPS (NTO) SPECIFIED BY THE'
      PRINT*,' USER  IS GREATER THAN THE'
      PRINT*,' MAXIMUM ALLOWED VALUE OF ',IPAR1
      PRINT*
      PRINT*,' EITHER REDUCE THE VALUE SPECIFIED ON INPUT'
      PRINT*,' OR CHANGE THE PARAMETER STATEMENT DEFINING THE'
      PRINT*,' MAXIMUM (NSER   = XX) TO A LARGER VALUE, BUT BE'
      PRINT*,' PREPARED IN CASE OF MEMORY LIMITATIONS.'
      PRINT*
      RETURN
C
C KHELP=4         PARAMETER NOT SUITABLY DEFINED
C
  4   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE PARSIN   INTEGER PARAMETER'
      PRINT*,' ================================     TOO SMALL'
      PRINT*
      PRINT*,' SOME INTEGER PARAMETER IS NOT GREATER THAN ZERO -'
      PRINT*,' SEE PRINTOUT OF PARAMETERS.'
      PRINT*
      RETURN
C
C KHELP=5         INPUT FILE PROBLEM
C
  5   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE PARSIN   INPUT FILE'
      PRINT*,' ================================     NOT GOOD'
      PRINT*
      PRINT*,' PLEASE CHECK THE INPUT DATA FILE.'
      PRINT*,' EITHER IT DOES NOT CONTAIN ANY RECORDS'
      PRINT*,' OR THE T21 HEADERS INDICATE ONLY ZERO LENGHTS'
      PRINT*,' OR A READ ERROR OCURRED.'
      PRINT*
      RETURN
C
C KHELP=6         FILE OPENING ERROR
C
  6   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE PARSIN   FILE OPENING'
      PRINT*,' ================================     ERROR'
      PRINT*
      IF ( IPAR1 .EQ. 1 )  PRINT*,' NON-UNIX PARAMETER FILE.'
      IF ( IPAR1 .EQ. 2 )  PRINT*,' INPUT DATA FILE.'
      IF ( IPAR1 .EQ. 3 )  PRINT*,' OUTPUT DATA FILE.'
      PRINT*
      RETURN

  7   CONTINUE
  8   CONTINUE
  9   CONTINUE
  10  CONTINUE
      RETURN
C
C ****KHELP = 11..20 ******NAGLIB ERRORS***************
C
 110  IH = KHELP - 10
      GOTO ( 11, 99, 99, 99, 99,
     *       99, 99, 99, 99, 99 ), IH
C
C KHELP=11        F01AAF - IFAIL = 1
C
 11   CONTINUE
      PRINT*
      PRINT*,' FATAL ERROR IN SUBROUTINE POPS   F01AAF FAILED'
      PRINT*,' ==============================     IFAIL = 1'
      PRINT*
      PRINT*,' NAGLIB ROUTINE F01AAF ATTEMPTS TO COMPUTE THE'
      PRINT*,' APPROXIMATE INVERSE OF A REAL MATRIX.'
      PRINT*,' HERE IT HAS FAILED BECAUSE THE MATRIX IS SINGULAR'
      PRINT*,' OR ALMOST SO.'
      PRINT*
      RETURN
C
C ****KHELP = 51..98 ****** OTHER ERRORS AND WARNINGS ***********
C
  510 IH = KHELP - 50
      GOTO ( 51, 99, 99 ), IH
C
C KHELP=51         TIME SERIES REDUCTION
C
  51  CONTINUE
      PRINT*
      PRINT*,' WARNING FROM SUBROUTINE READDAT  TIME SERIES'
      PRINT*,' ===============================  LENGTH REDUCED'
      IF( .NOT. LEVPRI ) RETURN
      PRINT*
      PRINT*,' CERTAIN OF THE NAGLIB ROUTINES, IN PARTICULAR'
      PRINT*,' C06FAF/C06FBF/C06FCF FAIL IF THE LENGTH OF THE TIME-'
      PRINT*,' SERIES (NTO) IS SUCH THAT ONE OF ITS PRIME FACTORS IS'
      PRINT*,' GREATER THAN 19.'
      PRINT*,' NTO WILL BE ITERATIVELY REDUCED BY 1 UNTIL THIS IS'
      PRINT*,' NO LONGER THE CASE (FIRST DATA ARE ABANDONNED).'
      PRINT*
      RETURN

 99   RETURN
      END
C
C==== END HELP ================================================================
C
C
