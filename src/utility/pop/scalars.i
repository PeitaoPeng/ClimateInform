C
C****** "include" - file scalars.i
C
C     Look at the statements on the following lines and make the 
C     appropriate changes to any parameters as indicated!
C

      IMPLICIT COMPLEX( C )
C
C*    Logical constant for UNIX or non-UNIX operating system:
C
C     UNIX:
C     =====
C
C     If *LPSTDIN* is set to *TRUE*, the command line parameters
C     are expected from standard input with some syntax rules like
C     in shell commands. The output from the command 'getopt' is a
C     standard form of command parameters which is fully accepted
C     by this program. Use 'getopt' in the shell script to gain
C     all UNIX shell syntax features including syntax check.
C
C     Other system:
C     =============
C
C     If *LPSTDIN* is set to *FALSE*, the command line parameters
C     are read from file "POP.PAR". This file consists of one line
C     containing the parameters in a simplified UNIX shell syntax (without the
C     shell script name). Don't forget the delimiter -- before the
C     filter parameters and don't exceed 80 characters.
C
C     Note that you may use *LPSTDIN* = *.TRUE.* on all operating
C     systems letting the parameters be read from standard input instead of
C     a file.
C
      LOGICAL    LPSTDIN
      PARAMETER( LPSTDIN = .TRUE. )
C
C*    Specify here the threshold for setting floating points to zero 
C     (machine precision).
C
      PARAMETER( THRESHOLD = 1.E-12 )
C
C*	  Specify here the value which indicates missing values in the data
C     (usually a very big number. The value 9.E+99 is reasonable if you
C      compile the program for 64-bit floating points, e.g. for single 
C      precision on a CRAY-2S computer, or for double precision on a Sun
C      sparc workstation. For single precision on a 32-bit machine you 
C      should use e.g. 9.E+37 because 9.E+99 is larger than the maximum
C      floting point number in single precision! 9.E+37 is slightly below
C      the maximum single precision floating point)
C
      PARAMETER( PPGAP = 9.E+99)

C
C*    Switching dynamical field lengths on and off:
C
C     In the Cray version, the array dimensions *NSER*, *NTSDIM* and *NEODIM*
C     are defined dynamically as possible on the Cray 2. This is done in
C     subroutine *SETDIM* (U0101). In this case the following PARAMETER
C     statement must be blinded to comments by the user, and the COMMON
C     statement is read by the compiler.
C
C     This will not work e.g. with the Sun Fortan compiler.
C     Switch to standard FORTRAN with fixed field lengths by de-commenting
C     the following PARAMETER line and hiding the COMMON statement. Also,
C     you have to make *SETDIM* an empty subroutine (e.g. by comment C's).
C     Be careful to insert the proper dimension parameters NSER, NTSDIM and
C     NEODIM for your size of problem. And don't forget to increase these 
C     values and compile the program from scratch whenever necessary.


C      COMMON /DIMS/    NSER,   NTSDIM,  NEODIM

      PARAMETER ( NSER = 1000, NTSDIM = 1000, NEODIM = 18 )

C*    VARIABLE     TYPE       PURPOSE.
C     --------     ----       --------
C
C     NSER        INTEGER    MAXIMAL LENGTH OF TIME SERIES.
C     NTSDIM      INTEGER    MAXIMAL NUMBER OF TIME SERIES (IN EUCLIDEAN
C                            SPACE).
C     NEODIM      INTEGER    MAXIMAL NUMBER OF EOF'S.

C------------------------------------------------------------------------
C
C     There should be no need to change anything below this line!
C
C------------------------------------------------------------------------

      CHARACTER    YPSTAT*(*)
      PARAMETER(   NCMIN =  5,
     *             MICEOF = 6,
     *             JPUNIR = 89,
     *             JPUNIU = 88,
     *             NFILES = 12,
     *             YPSTAT = 'UNKNOWN')
C
C*    Unit numbers *JPUNIR*, *JPUNIU* must be greater than *NFILES*!
C

C*    VARIABLE     TYPE       PURPOSE.
C     --------     ----       --------
C
C     NCMIN       INTEGER    MINIMAL NUMBER OF CHUNKS (IN *CEOFAN*)
C     MICEOF      INTEGER    MAXIMAL NUMBER OF CEOFS TO BE PRINTED
C                            AND PLOTTED (IN *CEOFAN*)
C     PPGAP       REAL       NUMERICAL VALUE OF DATA INDICATING A GAP
C     JPUNIR      INTEGER    LOGICAL UNIT NUMBER FOR DATA INPUT
C     JPUNIU      INTEGER    LOGICAL UNIT NUMBER FOR NON-UNIX PARAMETER INPUT
C     NFILES      INTEGER    NUMBER OF OUTPUT FILES TO BE OPENED.
C                            (The logical unit numbers of the output files
C                            run from 31 to 30+*NFILES*. All file names are defined
C                            in *PARSIN*.)
C     YPSTAT      CHARACTER  OPENING STATUS OF OUTPUT FILES:
C                            'UNKNOWN': OVERWRITE IF FILES ALREADY EXIST,
C                            'NEW':     FILES ARE NEW, OTHERWISE ERROR.

      CHARACTER*80     TITLE,  TTXT

      LOGICAL LNORM,   LPOPS,  LEOFS,  LFILT,  LCEOF,  LTURN,  LTREND,
     *        LTFILT,  LEVPRI, LSPPRI, LFLIP, LLSF

      COMMON /NAMINT/  NTS,    NEOF,   NTO,    ITAU,   NC,     NCEOF,
     *                 NTOEFF, NUMGAP, NUMHOLE

     *       /NAMREAL/ P2,     PMIN,   PMAX,   P1,     FACT,   DT

     *       /NAMLOGL/ LNORM,  LPOPS,  LEOFS,  LTURN,  LTREND, LEVPRI,
     *                 LSPPRI, LCEOF,  LTFILT, LFILT,  LFLIP,  LLSF

     *       /NAMCHAR/ TITLE,  TTXT



C
C*    VARIABLE     TYPE       PURPOSE.
C     --------     ----       --------
C
C     *TITLE*     CHAR*80
C     *YNAMI*     CHAR*20    NAME OF DATA INPUT FILE
C     *YNAMO*     CHAR*20    NAMEs OF DATA OUTPUT FILEs
C     *LEVPRI*    LOGICAL    LEVEL OF PRINT OUTPUT.(.TRUE. = HIGH)
C     *LSPPRI*    LOGICAL    IF *LEVPRI* AND *LSPPRI* ARE .TRUE. SPECTRA ARE
C                            ALSO PRINTED
C     *LPOPS*     LOGICAL    IF .TRUE. THEN A POP ANALYSIS IS PERFORMED
C     *LEOFS*     LOGICAL    IF .TRUE. THEN ONLY AN EOF ANALYSIS IS PERFORMED
C     *LCEOF*     LOGICAL    IF .TRUE. THEN CEOF ANALYSIS IS TO BE PERFORMED
C                                  (NO POP ANALYSIS IN THESE TWO CASES)
C     *LTFILT*    LOGICAL    .TRUE. IF TIME FILTERING REQUIRED
C     *LNORM*     LOGICAL    .TRUE. IF NORMALISATION REQUIRED
C     *LTREND*    LOGICAL    .TRUE. IF TREND FILTERING REQUIRED
C     *LFILT*     LOGICAL    .TRUE. IF ANY SORT OF FILTERING IS REQUIRED
C     *LFLIP*     LOGICAL    IF .TRUE. THEN THE SMALLER MATRIX IS USED IN THE
C                            COMPUTATION OF EOFs EVEN IF THERE ARE DATA GAPS.
C     *LLSF*      LOGICAL    IF .TRUE. THE POP COEFFICIENT TIME SERIES FOR EACH
C                            POP IS DETERMINED FROM A LEAST SQUARES FIT OF THE
C                            POP TO THE DATA, OTHERWISE IT IS THE PROJECTION OF
C                            DATA ONTO THE ADJOINT POPs.
C     *NEOF*      INTEGER    NO OF EOF'S
C     *NTO*       INTEGER    TIME SERIES LENGTH.
C     *NTS*       INTEGER    NO OF TIME SERIES.
C     *NC*        INTEGER    NO OF CHUNKS
C     *NCEOF*     INTEGER    NO OF COMPLEX EOF'S
C     *NUMGAP*    INTEGER    COUNTS NUMBER OF DATA GAPS.
C     *NUMHOLE*   INTEGER    COUNTS NUMBER OF SPACE POINTS WITH NO OBSERVATION.
C     *ITAU*      INTEGER    LAG/COV MATRIX
C     *DT*        REAL       TIME STEP.
C     *FACT*      REAL       FACTOR FOR MULT OF ORIGINAL DATA.
C     *P1*        REAL       )
C     *P2*        REAL       ) FILTER PARAMETERS.
C     *PMAX*      REAL       )
C     *PMIN*      REAL       )
C

