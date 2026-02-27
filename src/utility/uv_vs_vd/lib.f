      SUBROUTINE FFT99(A,WORK,TRIGS,IFAX,INC,JUMP,N,LOT,NW,ISIGN)       FFT00010
C                                                                       FFT00020
C PURPOSE      PERFORMS MULTIPLE FAST FOURIER TRANSFORMS.  THIS PACKAGE FFT00030
C              WILL PERFORM A NUMBER OF SIMULTANEOUS REAL/HALF-COMPLEX  FFT00040
C              PERIODIC FOURIER TRANSFORMS OR CORRESPONDING INVERSE     FFT00050
C              TRANSFORMS, I.E.  GIVEN A SET OF REAL DATA VECTORS, THE  FFT00060
C              PACKAGE RETURNS A SET OF 'HALF-COMPLEX' FOURIER          FFT00070
C              COEFFICIENT VECTORS, OR VICE VERSA.  THE LENGTH OF THE   FFT00080
C              TRANSFORMS MUST BE AN EVEN NUMBER GREATER THAN 4 THAT HASFFT00090
C              NO OTHER FACTORS EXCEPT POSSIBLY POWERS OF 2, 3, AND 5.  FFT00100
C              THIS IS AN ALL FORTRAN VERSION OF THE CRAYLIB PACKAGE    FFT00110
C              THAT IS MOSTLY WRITTEN IN CAL.                           FFT00120
C                                                                       FFT00130
C              THE PACKAGE FFT99F CONTAINS SEVERAL USER-LEVEL ROUTINES: FFT00140
C                                                                       FFT00150
C            SUBROUTINE FFTFAX                                          FFT00160
C                AN INITIALIZATION ROUTINE THAT MUST BE CALLED ONCE     FFT00170
C                BEFORE A SEQUENCE OF CALLS TO THE FFT ROUTINES         FFT00180
C                (PROVIDED THAT N IS NOT CHANGED).                      FFT00190
C                                                                       FFT00200
C            SUBROUTINES FFT99 AND FFT991                               FFT00210
C                TWO FFT ROUTINES THAT RETURN SLIGHTLY DIFFERENT        FFT00220
C                ARRANGEMENTS OF THE DATA IN GRIDPOINT SPACE.           FFT00230
C                                                                       FFT00240
C                                                                       FFT00250
C ACCESS       THIS FORTRAN VERSION MAY BE ACCESSED WITH                FFT00260
C                                                                       FFT00270
C                   *FORTRAN,P=XLIB,SN=FFT99F                           FFT00280
C                                                                       FFT00290
C              TO ACCESS THE CRAY OBJECT CODE, CALLING THE USER ENTRY   FFT00300
C              POINTS FROM A CRAY PROGRAM IS SUFFICIENT.  THE SOURCE    FFT00310
C              FORTRAN AND CAL CODE FOR THE CRAYLIB VERSION MAY BE      FFT00320
C              ACCESSED USING                                           FFT00330
C                                                                       FFT00340
C                   FETCH P=CRAYLIB,SN=FFT99                            FFT00350
C                   FETCH P=CRAYLIB,SN=CAL99                            FFT00360
C                                                                       FFT00370
C USAGE        LET N BE OF THE FORM 2**P * 3**Q * 5**R, WHERE P .GE. 1, FFT00380
C              Q .GE. 0, AND R .GE. 0.  THEN A TYPICAL SEQUENCE OF      FFT00390
C              CALLS TO TRANSFORM A GIVEN SET OF REAL VECTORS OF LENGTH FFT00400
C              N TO A SET OF 'HALF-COMPLEX' FOURIER COEFFICIENT VECTORS FFT00410
C              OF LENGTH N IS                                           FFT00420
C                                                                       FFT00430
C                   DIMENSION IFAX(13),TRIGS((N+2)/4*6),A(M*(N+2)),     FFT00440
C                  +          WORK(M*N)                                 FFT00450
C                                                                       FFT00460
C                   CALL FFTFAX (N, IFAX, TRIGS)                        FFT00470
C                   CALL FFT99 (A,WORK,TRIGS,IFAX,INC,JUMP,N,M,ISIGN)   FFT00480
C                                                                       FFT00490
C              SEE THE INDIVIDUAL WRITE-UPS FOR FFTFAX, FFT99, AND      FFT00500
C              FFT991 BELOW, FOR A DETAILED DESCRIPTION OF THE          FFT00510
C              ARGUMENTS.                                               FFT00520
C                                                                       FFT00530
C HISTORY      THE PACKAGE WAS WRITTEN BY CLIVE TEMPERTON AT ECMWF IN   FFT00540
C              NOVEMBER, 1978.  IT WAS MODIFIED, DOCUMENTED, AND TESTED FFT00550
C              FOR NCAR BY RUSS REW IN SEPTEMBER, 1980.  NOW IT WAS     FFT00560
C              FURTHER MODIFIED BY LU XIANCHI IN FEBRUARY, 1989.        FFT00570
C                                                                       FFT00580
C-----------------------------------------------------------------------FFT00590
C                                                                       FFT00600
C SUBROUTINE FFTFAX (N,IFAX,TRIGS)                                      FFT00610
C                                                                       FFT00620
C PURPOSE      A SET-UP ROUTINE FOR FFT99 AND FFT991.  IT NEED ONLY BE  FFT00630
C              CALLED ONCE BEFORE A SEQUENCE OF CALLS TO THE FFT        FFT00640
C              ROUTINES (PROVIDED THAT N IS NOT CHANGED).               FFT00650
C                                                                       FFT00660
C ARGUMENT     IFAX(13),TRIGS((N+2)/4*6)                                FFT00670
C DIMENSIONS                                                            FFT00680
C                                                                       FFT00690
C ARGUMENTS                                                             FFT00700
C                                                                       FFT00710
C ON INPUT     N                                                        FFT00720
C               AN EVEN NUMBER GREATER THAN 4 THAT HAS NO PRIME FACTOR  FFT00730
C               GREATER THAN 5.  N IS THE LENGTH OF THE TRANSFORMS (SEE FFT00740
C               THE DOCUMENTATION FOR FFT99 AND FFT991 FOR THE          FFT00750
C               DEFINITIONS OF THE TRANSFORMS).                         FFT00760
C                                                                       FFT00770
C              IFAX                                                     FFT00780
C               AN INTEGER ARRAY.  THE NUMBER OF ELEMENTS ACTUALLY USED FFT00790
C               WILL DEPEND ON THE FACTORIZATION OF N.  DIMENSIONING    FFT00800
C               IFAX FOR K SUFFICES FOR ALL N LESS THAN 2**(K+1).       FFT00810
C  ???          IFAX FOR 13 SUFFICES FOR ALL N LESS THAN A MILLION. ??? FFT00820
C                                                                       FFT00830
C              TRIGS                                                    FFT00840
C               A FLOATING POINT ARRAY OF DIMENSION (N+2)/4*6           FFT00850
C                                                                       FFT00860
C ON OUTPUT    IFAX                                                     FFT00870
C               CONTAINS THE FACTORIZATION OF N/2.  IFAX(1) IS THE      FFT00880
C               NUMBER OF FACTORS, AND THE FACTORS THEMSELVES ARE STOREDFFT00890
C               IN IFAX(2),IFAX(3),...  IF FFTFAX IS CALLED WITH N ODD, FFT00900
C               OR IF N HAS ANY PRIME FACTORS GREATER THAN 5, IFAX(1)   FFT00910
C               IS SET TO -99.                                          FFT00920
C                                                                       FFT00930
C              TRIGS                                                    FFT00940
C               AN ARRAY OF TRIGNOMENTRIC FUNCTION VALUES SUBSEQUENTLY  FFT00950
C               USED BY THE FFT ROUTINES.                               FFT00960
C                                                                       FFT00970
C-----------------------------------------------------------------------FFT00980
C                                                                       FFT00990
C SUBROUTINE FFT991 (A,WORK,TRIGS,IFAX,INC,JUMP,N,M,NW,ISIGN)           FFT01000
C                       AND                                             FFT01010
C SUBROUTINE FFT99 (A,WORK,TRIGS,IFAX,INC,JUMP,N,M,NW,ISIGN)            FFT01020
C                                                                       FFT01030
C PURPOSE      PERFORM A NUMBER OF SIMULTANEOUS REAL/HALF-COMPLEX       FFT01040
C              PERIODIC FOURIER TRANSFORMS OR CORRESPONDING INVERSE     FFT01050
C              TRANSFORMS, USING ORDINARY SPATIAL ORDER OF GRIDPOINT    FFT01060
C              VALUES (FFT991) OR EXPLICIT CYCLIC CONTINUITY IN THE     FFT01070
C              GRIDPOINT VALUES (FFT99).  GIVEN A SET                   FFT01080
C              OF REAL DATA VECTORS, THE PACKAGE RETURNS A SET OF       FFT01090
C              'HALF-COMPLEX' FOURIER COEFFICIENT VECTORS, OR VICE      FFT01100
C              VERSA.  THE LENGTH OF THE TRANSFORMS MUST BE AN EVEN     FFT01110
C              NUMBER THAT HAS NO OTHER FACTORS EXCEPT POSSIBLY POWERS  FFT01120
C              OF 2, 3, AND 5.  THESE VERSION OF FFT991 AND FFT99 ARE   FFT01130
C              OPTIMIZED FOR USE ON THE CRAY-1.                         FFT01140
C                                                                       FFT01150
C ARGUMENT     A(>=M*(N+2)) FOR FFT99, OR A(>=M*N) FOR FFT991;          FFT01160
C DIMENSIONS   WORK(M*N); TRIGS((N+2)/4*6); IFAX(13)                    FFT01170
C                                                                       FFT01180
C ARGUMENTS                                                             FFT01190
C                                                                       FFT01200
C ON INPUT     A                                                        FFT01210
C               AN ARRAY OF LENGTH AT LEAST M*(N+2) FOR FFT99 OR M*N    FFT01220
C               FOR FFT991 CONTAINING THE INPUT DATA OR COEFFICIENT     FFT01230
C               VECTORS, IN WHICH EITHER THE INCREMENT BETWEEN          FFT01240
C               SUCCESSIVE VECTOR ELEMENTS OR THAT BETWEEN SUCCESSIVE   FFT01250
C               VECTORS IS INVARIABLE.  THIS ARRAY IS OVERWRITTEN BY    FFT01260
C               THE RESULTS.                                            FFT01270
C                                                                       FFT01280
C              WORK                                                     FFT01290
C               A WORK ARRAY OF DIMENSION M*N                           FFT01300
C                                                                       FFT01310
C              TRIGS                                                    FFT01320
C               AN ARRAY SET UP BY FFTFAX, WHICH MUST BE CALLED FIRST.  FFT01330
C                                                                       FFT01340
C              IFAX                                                     FFT01350
C               AN ARRAY SET UP BY FFTFAX, WHICH MUST BE CALLED FIRST.  FFT01360
C                                                                       FFT01370
C              INC                                                      FFT01380
C               THE INCREMENT (IN WORDS) BETWEEN SUCCESSIVE ELEMENTS OF FFT01390
C               EACH DATA OR COEFFICIENT VECTOR (E.G.  INC=1 FOR        FFT01400
C               CONSECUTIVELY STORED DATA).                             FFT01410
C                                                                       FFT01420
C              JUMP                                                     FFT01430
C               THE INCREMENT (IN WORDS) BETWEEN THE FIRST ELEMENTS OF  FFT01440
C               SUCCESSIVE DATA OR COEFFICIENT VECTORS.  ON THE CRAY-1, FFT01450
C               TRY TO ARRANGE DATA SO THAT JUMP IS NOT A MULTIPLE OF 8 FFT01460
C               (TO AVOID MEMORY BANK CONFLICTS).  FOR CLARIFICATION OF FFT01470
C               INC AND JUMP, SEE THE EXAMPLES BELOW.                   FFT01480
C                                                                       FFT01490
C              N                                                        FFT01500
C               THE LENGTH OF EACH TRANSFORM (SEE DEFINITION OF         FFT01510
C               TRANSFORMS, BELOW).                                     FFT01520
C                                                                       FFT01530
C              M                                                        FFT01540
C               THE NUMBER OF TRANSFORMS TO BE DONE SIMULTANEOUSLY.     FFT01550
C                                                                       FFT01560
C              NW                                                       FFT01570
C               = 0 FOR FILTERING OFF WAVENUMBER N/2                    FFT01580
C               = 1 FOR RESERVING WAVENUMBER N/2                        FFT01590
C                                                                       FFT01600
C              ISIGN                                                    FFT01610
C               = +1 FOR A TRANSFORM FROM FOURIER COEFFICIENTS TO       FFT01620
C                    GRIDPOINT VALUES.                                  FFT01630
C               = -1 FOR A TRANSFORM FROM GRIDPOINT VALUES TO FOURIER   FFT01640
C                    COEFFICIENTS.                                      FFT01650
C                                                                       FFT01660
C ON OUTPUT    A                                                        FFT01670
C               IF ISIGN = +1, AND M COEFFICIENT VECTORS ARE SUPPLIED   FFT01680
C               EACH CONTAINING THE SEQUENCE:                           FFT01690
C                                                                       FFT01700
C               FOR FFT991 A(0),A(N/2),A(1),B(1),...,                   FFT01710
C                         A(N/2-1),B(N/2-1)         (N VALUES)          FFT01720
C               FOR FFT99 XX,A(0),A(N/2),A(1),B(1),...,                 FFT01730
C                         A(N/2-1),B(N/2-1),XX      (N+2 VALUES)        FFT01740
C                                                                       FFT01750
C               THEN THE RESULT CONSISTS OF M DATA VECTORS EACH         FFT01760
C               CONTAINING THE CORRESPONDING GRIDPOINT VALUES:          FFT01770
C                                                                       FFT01780
C               FOR FFT991, X(0), X(1), X(2),...,X(N-1).  (N VALUES)    FFT01790
C               FOR FFT99, X(N-1),X(0),X(1),X(2),...,X(N-1),X(0).       FFT01800
C                   (EXPLICIT CYCLIC CONTINUITY, N+2 VALUES)            FFT01810
C                                                                       FFT01820
C               WHEN ISIGN = +1, THE TRANSFORM IS DEFINED BY:           FFT01830
C                 X(J)=SUM(K=0,...,N-1)(C(K)*EXP(2*I*J*K*PI/N))         FFT01840
C                 WHERE C(K)=A(K)+I*B(K) AND C(N-K)=A(K)-I*B(K)         FFT01850
C                 AND I=SQRT (-1)                                       FFT01860
C                                                                       FFT01870
C               IF ISIGN = -1, AND M DATA VECTORS ARE SUPPLIED EACH     FFT01880
C               CONTAINING A SEQUENCE OF GRIDPOINT VALUES X(J) AS       FFT01890
C               DEFINED ABOVE, THEN THE RESULT CONSISTS OF M VECTORS    FFT01900
C               EACH CONTAINING THE CORRESPONDING FOURIER COFFICIENTS   FFT01910
C               A(K), B(K), 0 .LE. K .LE N/2.                           FFT01920
C                                                                       FFT01930
C               WHEN ISIGN = -1, THE INVERSE TRANSFORM IS DEFINED BY:   FFT01940
C                 C(K)=(1/N)*SUM(J=0,...,N-1)(X(J)*EXP(-2*I*J*K*PI/N))  FFT01950
C                 WHERE C(K)=A(K)+I*B(K) AND I=SQRT(-1)                 FFT01960
C                                                                       FFT01970
C               A CALL WITH ISIGN=+1 FOLLOWED BY A CALL WITH ISIGN=-1   FFT01980
C               (OR VICE VERSA) RETURNS THE ORIGINAL DATA.              FFT01990
C                                                                       FFT02000
C               NOTE: THE FACT THAT THE GRIDPOINT VALUES X(J) ARE REAL  FFT02010
C               IMPLIES THAT B(0)=B(N/2)=0.  FOR A CALL WITH ISIGN=+1,  FFT02020
C               IT IS NOT ACTUALLY NECESSARY TO SUPPLY THESE ZEROS.     FFT02030
C                                                                       FFT02040
C EXAMPLES      GIVEN 19 DATA VECTORS EACH OF LENGTH 64 (+2 FOR EXPLICITFFT02050
C               CYCLIC CONTINUITY), COMPUTE THE CORRESPONDING VECTORS OFFFT02060
C               FOURIER COEFFICIENTS.  THE DATA MAY, FOR EXAMPLE, BE    FFT02070
C               ARRANGED LIKE THIS:                                     FFT02080
C                                                                       FFT02090
C FIRST DATA   A(1)=    . . .                A(66)=             A(70)   FFT02100
C VECTOR       X(63) X(0) X(1) X(2) ... X(63) X(0)  (4 EMPTY LOCATIONS) FFT02110
C                                                                       FFT02120
C SECOND DATA  A(71)=   . . .                                  A(140)   FFT02130
C VECTOR       X(63) X(0) X(1) X(2) ... X(63) X(0)  (4 EMPTY LOCATIONS) FFT02140
C                                                                       FFT02150
C               AND SO ON.  HERE INC=1, JUMP=70, N=64, M=19, ISIGN=-1,  FFT02160
C               AND FFT99 SHOULD BE USED (BECAUSE OF THE EXPLICIT CYCLICFFT02170
C               CONTINUITY).                                            FFT02180
C                                                                       FFT02190
C               ALTERNATIVELY THE DATA MAY BE ARRANGED LIKE THIS:       FFT02200
C                                                                       FFT02210
C                FIRST         SECOND                       LAST        FFT02220
C                DATA          DATA                         DATA        FFT02230
C                VECTOR        VECTOR                       VECTOR      FFT02240
C                                                                       FFT02250
C              A(1 )= X(63)  A(2 )= X(63)       . . .     A(19)= X(63)  FFT02260
C              A(20)= X(0)   A(21)= X(0)        . . .     A(38)= X(0)   FFT02270
C              A(39)= X(1)   A(40)= X(1)        . . .     A(57)= X(1)   FFT02280
C                  .             .                             .        FFT02290
C                  .             .                             .        FFT02300
C                  .             .                             .        FFT02310
C                                                                       FFT02320
C               IN WHICH CASE WE HAVE INC=19, JUMP=1, AND THE REMAINING FFT02330
C               PARAMETERS ARE THE SAME AS BEFORE.  IN EITHER CASE, EACHFFT02340
C               COEFFICIENT VECTOR OVERWRITES THE CORRESPONDING INPUT   FFT02350
C               DATA VECTOR.                                            FFT02360
C                                                                       FFT02370
C-----------------------------------------------------------------------FFT02380
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT02390
      DIMENSION A(*),WORK(*),TRIGS(*),IFAX(*)                           FFT02400
C                                                                       FFT02410
C     SUBROUTINE "FFT99" - MULTIPLE FAST REAL PERIODIC TRANSFORM        FFT02420
C     CORRESPONDING TO OLD SCALAR ROUTINE FFT9                          FFT02430
C     PROCEDURE USED TO CONVERT TO HALF-LENGTH COMPLEX TRANSFORM        FFT02440
C     IS GIVEN BY COOLEY, LEWIS AND WELCH (J. SOUND VIB., VOL. 12       FFT02450
C     (1970), 315-337)                                                  FFT02460
C                                                                       FFT02470
C     A IS THE ARRAY CONTAINING INPUT AND OUTPUT DATA                   FFT02480
C     WORK IS AN AREA OF SIZE N*LOT                                     FFT02490
C     TRIGS IS A PREVIOUSLY PREPARED LIST OF TRIG FUNCTION VALUES       FFT02500
C     IFAX IS A PREVIOUSLY PREPARED LIST OF FACTORS OF N/2              FFT02510
C     INC IS THE INCREMENT WITHIN EACH DATA 'VECTOR'                    FFT02520
C         (E.G. INC=1 FOR CONSECUTIVELY STORED DATA)                    FFT02530
C     JUMP IS THE INCREMENT BETWEEN THE START OF EACH DATA VECTOR       FFT02540
C     N IS THE LENGTH OF THE DATA VECTORS                               FFT02550
C     LOT IS THE NUMBER OF DATA VECTORS                                 FFT02560
C     NW = 0 FOR FILTERING OFF WAVENUMBER N/2                           FFT02570
C        = 1 FOR RESERVING WAVENUMBER N/2                               FFT02580
C     ISIGN = +1 FOR TRANSFORM FROM SPECTRAL TO GRIDPOINT               FFT02590
C           = -1 FOR TRANSFORM FROM GRIDPOINT TO SPECTRAL               FFT02600
C                                                                       FFT02610
C     ORDERING OF COEFFICIENTS:                                         FFT02620
C         XX,A(0),A(N/2),A(1),B(1),A(2),B(2),...,A(N/2-1),B(N/2-1),XX   FFT02630
C         BECAUSE B(0)=B(N/2)=0; (N+2) LOCATIONS REQUIRED               FFT02640
C                                                                       FFT02650
C     ORDERING OF DATA:                                                 FFT02660
C         X(N-1),X(0),X(1),X(2),...,X(N),X(0)                           FFT02670
C         I.E. EXPLICIT CYCLIC CONTINUITY; (N+2) LOCATIONS REQUIRED     FFT02680
C                                                                       FFT02690
C     VECTORIZATION IS ACHIEVED ON CRAY BY DOING THE TRANSFORMS IN      FFT02700
C     PARALLEL                                                          FFT02710
C                                                                       FFT02720
C     *** N.B. N IS ASSUMED TO BE AN EVEN NUMBER                        FFT02730
C                                                                       FFT02740
C     DEFINITION OF TRANSFORMS:                                         FFT02750
C     -------------------------                                         FFT02760
C                                                                       FFT02770
C     ISIGN=+1: X(J)=SUM(K=0,...,N-1)(C(K)*EXP(2*I*J*K*PI/N))           FFT02780
C         WHERE C(K)=A(K)+I*B(K) AND C(N-K)=A(K)-I*B(K)                 FFT02790
C                                                                       FFT02800
C     ISIGN=-1: A(K)=(1/N)*SUM(J=0,...,N-1)(X(J)*COS(2*J*K*PI/N))       FFT02810
C               B(K)=-(1/N)*SUM(J=0,...,N-1)(X(J)*SIN(2*J*K*PI/N))      FFT02820
C                                                                       FFT02830
C                                                                       FFT02840
C THE FOLLOWING CALL IS FOR MONITORING LIBRARY USE AT NCAR              FFT02850
C     CALL Q8QST4 ( 4HXLIB, 6HFFT99F, 5HFFT99, 10HVERSION 01)           FFT02860
      NFAX=IFAX(1)                                                      FFT02870
      NH=N/2                                                            FFT02880
      INK=INC+INC                                                       FFT02890
      IF (ISIGN.EQ.+1) GO TO 30                                         FFT02900
C                                                                       FFT02910
C     IF NECESSARY, TRANSFER DATA TO WORK AREA                          FFT02920
      IGO=50                                                            FFT02930
      IF (MOD(NFAX,2).EQ.1) GOTO 40                                     FFT02940
      IBASE=INC+1                                                       FFT02950
      JBASE=1                                                           FFT02960
      DO 20 L=1,LOT                                                     FFT02970
      I=IBASE                                                           FFT02980
      J=JBASE                                                           FFT02990
CDIR$ IVDEP                                                             FFT03000
      DO 10 M=1,N                                                       FFT03010
      WORK(J)=A(I)                                                      FFT03020
      I=I+INC                                                           FFT03030
      J=J+1                                                             FFT03040
   10 CONTINUE                                                          FFT03050
      IBASE=IBASE+JUMP                                                  FFT03060
      JBASE=JBASE+N                                                     FFT03070
   20 CONTINUE                                                          FFT03080
C                                                                       FFT03090
      IGO=60                                                            FFT03100
      GO TO 40                                                          FFT03110
C                                                                       FFT03120
C     PREPROCESSING (ISIGN=+1)                                          FFT03130
C     ------------------------                                          FFT03140
C                                                                       FFT03150
   30 CONTINUE                                                          FFT03160
      IA=INC+1                                                          FFT03170
      CALL FFT99A(A(IA),WORK,TRIGS,INC,JUMP,N,LOT,NW)                   FFT03180
      IGO=60                                                            FFT03190
C                                                                       FFT03200
C     COMPLEX TRANSFORM                                                 FFT03210
C     -----------------                                                 FFT03220
C                                                                       FFT03230
   40 CONTINUE                                                          FFT03240
      IA=INC+1                                                          FFT03250
      LA=1                                                              FFT03260
      DO 80 K=1,NFAX                                                    FFT03270
      IF (IGO.EQ.60) GO TO 60                                           FFT03280
   50 CONTINUE                                                          FFT03290
      CALL VPASSM(A(IA),A(IA+INC),WORK(1),WORK(2),TRIGS,                FFT03300
     *   INK,2,JUMP,N,LOT,NH,IFAX(K+1),LA)                              FFT03310
      IGO=60                                                            FFT03320
      GO TO 70                                                          FFT03330
   60 CONTINUE                                                          FFT03340
      CALL VPASSM(WORK(1),WORK(2),A(IA),A(IA+INC),TRIGS,                FFT03350
     *    2,INK,N,JUMP,LOT,NH,IFAX(K+1),LA)                             FFT03360
      IGO=50                                                            FFT03370
   70 CONTINUE                                                          FFT03380
      LA=LA*IFAX(K+1)                                                   FFT03390
   80 CONTINUE                                                          FFT03400
C                                                                       FFT03410
      IF (ISIGN.EQ.-1) GO TO 130                                        FFT03420
C                                                                       FFT03430
C     IF NECESSARY, TRANSFER DATA FROM WORK AREA                        FFT03440
      IF (MOD(NFAX,2).EQ.1) GO TO 110                                   FFT03450
      IBASE=1                                                           FFT03460
      JBASE=IA                                                          FFT03470
      DO 100 L=1,LOT                                                    FFT03480
      I=IBASE                                                           FFT03490
      J=JBASE                                                           FFT03500
CDIR$ IVDEP                                                             FFT03510
      DO 90 M=1,N                                                       FFT03520
      A(J)=WORK(I)                                                      FFT03530
      I=I+1                                                             FFT03540
      J=J+INC                                                           FFT03550
   90 CONTINUE                                                          FFT03560
      IBASE=IBASE+N                                                     FFT03570
      JBASE=JBASE+JUMP                                                  FFT03580
  100 CONTINUE                                                          FFT03590
C                                                                       FFT03600
C     FILL IN CYCLIC BOUNDARY POINTS                                    FFT03610
  110 CONTINUE                                                          FFT03620
      IA=1                                                              FFT03630
      IB=N*INC+1                                                        FFT03640
CDIR$ IVDEP                                                             FFT03650
      DO 120 L=1,LOT                                                    FFT03660
      A(IA)=A(IB)                                                       FFT03670
      A(IB+INC)=A(IA+INC)                                               FFT03680
      IA=IA+JUMP                                                        FFT03690
      IB=IB+JUMP                                                        FFT03700
  120 CONTINUE                                                          FFT03710
      GO TO 140                                                         FFT03720
C                                                                       FFT03730
C     POSTPROCESSING (ISIGN=-1):                                        FFT03740
C     --------------------------                                        FFT03750
C                                                                       FFT03760
  130 CONTINUE                                                          FFT03770
      IA=INC+1                                                          FFT03780
      CALL FFT99B(WORK,A(IA),TRIGS,INC,JUMP,N,LOT,NW)                   FFT03790
C                                                                       FFT03800
  140 CONTINUE                                                          FFT03810
      RETURN                                                            FFT03820
      END                                                               FFT03830
C                                                                       FFT03840
      SUBROUTINE FFT99A(A,WORK,TRIGS,INC,JUMP,N,LOT,NW)                 FFT03850
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT03860
      DIMENSION A(*),WORK(*),TRIGS(*)                                   FFT03870
C                                                                       FFT03880
C     SUBROUTINE FFT99A - PREPROCESSING STEP FOR FFT99, ISIGN=+1        FFT03890
C     (SPECTRAL TO GRIDPOINT TRANSFORM)                                 FFT03900
C                                                                       FFT03910
      NH=N/2                                                            FFT03920
      INK=INC+INC                                                       FFT03930
C                                                                       FFT03940
C     A(0) AND A(N/2)                                                   FFT03950
      IA=1                                                              FFT03960
      JA=1                                                              FFT03970
      JB=2                                                              FFT03980
      IF(NW.EQ.0) GO TO 20                                              FFT03990
C     IF WAVENUMBER N/2 IS RESERVED                                     FFT04000
CDIR$ IVDEP                                                             FFT04010
      DO 10 L=1,LOT                                                     FFT04020
      WORK(JA)=A(IA)+A(IA+INC)                                          FFT04030
      WORK(JB)=A(IA)-A(IA+INC)                                          FFT04040
      IA=IA+JUMP                                                        FFT04050
      JA=JA+N                                                           FFT04060
      JB=JB+N                                                           FFT04070
   10 CONTINUE                                                          FFT04080
      GO TO 40                                                          FFT04090
C                                                                       FFT04100
   20 CONTINUE                                                          FFT04110
C     IF WAVENUMBER N/2 HAS BEEN FILTERED OFF                           FFT04120
CDIR$ IVDEP                                                             FFT04130
      DO 30 L=1,LOT                                                     FFT04140
      WORK(JA)=A(IA)                                                    FFT04150
      WORK(JB)=A(IA)                                                    FFT04160
      IA=IA+JUMP                                                        FFT04170
      JA=JA+N                                                           FFT04180
      JB=JB+N                                                           FFT04190
   30 CONTINUE                                                          FFT04200
C                                                                       FFT04210
C     REMAINING WAVENUMBERS                                             FFT04220
   40 CONTINUE                                                          FFT04230
      IABASE=2*INC+1                                                    FFT04240
      IBBASE=(N-2)*INC+1                                                FFT04250
      JABASE=3                                                          FFT04260
      JBBASE=N-1                                                        FFT04270
C                                                                       FFT04280
      DO 60 K=3,NH,2                                                    FFT04290
      IA=IABASE                                                         FFT04300
      IB=IBBASE                                                         FFT04310
      JA=JABASE                                                         FFT04320
      JB=JBBASE                                                         FFT04330
      C=TRIGS(N+K)                                                      FFT04340
      S=TRIGS(N+K+1)                                                    FFT04350
CDIR$ IVDEP                                                             FFT04360
      DO 50 L=1,LOT                                                     FFT04370
      WORK(JA)=(A(IA)+A(IB))-                                           FFT04380
     *    (S*(A(IA)-A(IB))+C*(A(IA+INC)+A(IB+INC)))                     FFT04390
      WORK(JB)=(A(IA)+A(IB))+                                           FFT04400
     *    (S*(A(IA)-A(IB))+C*(A(IA+INC)+A(IB+INC)))                     FFT04410
      WORK(JA+1)=(C*(A(IA)-A(IB))-S*(A(IA+INC)+A(IB+INC)))+             FFT04420
     *    (A(IA+INC)-A(IB+INC))                                         FFT04430
      WORK(JB+1)=(C*(A(IA)-A(IB))-S*(A(IA+INC)+A(IB+INC)))-             FFT04440
     *    (A(IA+INC)-A(IB+INC))                                         FFT04450
      IA=IA+JUMP                                                        FFT04460
      IB=IB+JUMP                                                        FFT04470
      JA=JA+N                                                           FFT04480
      JB=JB+N                                                           FFT04490
   50 CONTINUE                                                          FFT04500
      IABASE=IABASE+INK                                                 FFT04510
      IBBASE=IBBASE-INK                                                 FFT04520
      JABASE=JABASE+2                                                   FFT04530
      JBBASE=JBBASE-2                                                   FFT04540
   60 CONTINUE                                                          FFT04550
C                                                                       FFT04560
      IF (IABASE.NE.IBBASE) GO TO 80                                    FFT04570
C     WAVENUMBER N/4 (IF IT EXISTS)                                     FFT04580
      IA=IABASE                                                         FFT04590
      JA=JABASE                                                         FFT04600
CDIR$ IVDEP                                                             FFT04610
      DO 70 L=1,LOT                                                     FFT04620
      WORK(JA)=2.0D0*A(IA)                                              FFT04630
      WORK(JA+1)=-2.0D0*A(IA+INC)                                       FFT04640
      IA=IA+JUMP                                                        FFT04650
      JA=JA+N                                                           FFT04660
   70 CONTINUE                                                          FFT04670
C                                                                       FFT04680
   80 CONTINUE                                                          FFT04690
      RETURN                                                            FFT04700
      END                                                               FFT04710
C                                                                       FFT04720
      SUBROUTINE FFT99B(WORK,A,TRIGS,INC,JUMP,N,LOT,NW)                 FFT04730
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT04740
      DIMENSION WORK(*),A(*),TRIGS(*)                                   FFT04750
C                                                                       FFT04760
C     SUBROUTINE FFT99B - POSTPROCESSING STEP FOR FFT99, ISIGN=-1       FFT04770
C     (GRIDPOINT TO SPECTRAL TRANSFORM)                                 FFT04780
C                                                                       FFT04790
      NH=N/2                                                            FFT04800
      INK=INC+INC                                                       FFT04810
C                                                                       FFT04820
C     A(0) AND A(N/2)                                                   FFT04830
      SCALE=1.0D0/DFLOAT(N)                                             FFT04840
      IA=1                                                              FFT04850
      IB=2                                                              FFT04860
      JA=1                                                              FFT04870
      IF(NW.EQ.0) GO TO 20                                              FFT04880
C     IF WAVENUMBER N/2 HAS TO BE RESERVED                              FFT04890
CDIR$ IVDEP                                                             FFT04900
      DO 10 L=1,LOT                                                     FFT04910
      A(JA)=SCALE*(WORK(IA)+WORK(IB))                                   FFT04920
      A(JA+INC)=SCALE*(WORK(IA)-WORK(IB))                               FFT04930
      IA=IA+N                                                           FFT04940
      IB=IB+N                                                           FFT04950
      JA=JA+JUMP                                                        FFT04960
   10 CONTINUE                                                          FFT04970
      GO TO 40                                                          FFT04980
                                                                        FFT04990
   20 CONTINUE                                                          FFT05000
C     IF WAVENUMBER N/2 HAS TO BE FILTERED OFF                          FFT05010
CDIR$ IVDEP                                                             FFT05020
      DO 30 L=1,LOT                                                     FFT05030
      A(JA)=SCALE*(WORK(IA)+WORK(IB))                                   FFT05040
      A(JA+INC)=0.0D0                                                   FFT05050
      IA=IA+N                                                           FFT05060
      IB=IB+N                                                           FFT05070
      JA=JA+JUMP                                                        FFT05080
   30 CONTINUE                                                          FFT05090
C                                                                       FFT05100
C     REMAINING WAVENUMBERS                                             FFT05110
   40 CONTINUE                                                          FFT05120
      SCALE=0.5D0*SCALE                                                 FFT05130
      IABASE=3                                                          FFT05140
      IBBASE=N-1                                                        FFT05150
      JABASE=2*INC+1                                                    FFT05160
      JBBASE=(N-2)*INC+1                                                FFT05170
C                                                                       FFT05180
      DO 60 K=3,NH,2                                                    FFT05190
      IA=IABASE                                                         FFT05200
      IB=IBBASE                                                         FFT05210
      JA=JABASE                                                         FFT05220
      JB=JBBASE                                                         FFT05230
      C=TRIGS(N+K)                                                      FFT05240
      S=TRIGS(N+K+1)                                                    FFT05250
CDIR$ IVDEP                                                             FFT05260
      DO 50 L=1,LOT                                                     FFT05270
      A(JA)=SCALE*((WORK(IA)+WORK(IB))                                  FFT05280
     *   +(C*(WORK(IA+1)+WORK(IB+1))+S*(WORK(IA)-WORK(IB))))            FFT05290
      A(JB)=SCALE*((WORK(IA)+WORK(IB))                                  FFT05300
     *   -(C*(WORK(IA+1)+WORK(IB+1))+S*(WORK(IA)-WORK(IB))))            FFT05310
      A(JA+INC)=SCALE*((C*(WORK(IA)-WORK(IB))-S*(WORK(IA+1)+WORK(IB+1)))FFT05320
     *    +(WORK(IB+1)-WORK(IA+1)))                                     FFT05330
      A(JB+INC)=SCALE*((C*(WORK(IA)-WORK(IB))-S*(WORK(IA+1)+WORK(IB+1)))FFT05340
     *    -(WORK(IB+1)-WORK(IA+1)))                                     FFT05350
      IA=IA+N                                                           FFT05360
      IB=IB+N                                                           FFT05370
      JA=JA+JUMP                                                        FFT05380
      JB=JB+JUMP                                                        FFT05390
   50 CONTINUE                                                          FFT05400
      IABASE=IABASE+2                                                   FFT05410
      IBBASE=IBBASE-2                                                   FFT05420
      JABASE=JABASE+INK                                                 FFT05430
      JBBASE=JBBASE-INK                                                 FFT05440
   60 CONTINUE                                                          FFT05450
C                                                                       FFT05460
      IF (IABASE.NE.IBBASE) GO TO 80                                    FFT05470
C     WAVENUMBER N/4 (IF IT EXISTS)                                     FFT05480
      IA=IABASE                                                         FFT05490
      JA=JABASE                                                         FFT05500
      SCALE=2.0D0*SCALE                                                 FFT05510
CDIR$ IVDEP                                                             FFT05520
      DO 70 L=1,LOT                                                     FFT05530
      A(JA)=SCALE*WORK(IA)                                              FFT05540
      A(JA+INC)=-SCALE*WORK(IA+1)                                       FFT05550
      IA=IA+N                                                           FFT05560
      JA=JA+JUMP                                                        FFT05570
   70 CONTINUE                                                          FFT05580
C                                                                       FFT05590
   80 CONTINUE                                                          FFT05600
      RETURN                                                            FFT05610
      END                                                               FFT05620
C                                                                       FFT05630
      SUBROUTINE FFT991(A,WORK,TRIGS,IFAX,INC,JUMP,N,LOT,NW,ISIGN)      FFT05640
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT05650
      DIMENSION A(*),WORK(*),TRIGS(*),IFAX(*)                           FFT05660
C                                                                       FFT05670
C     SUBROUTINE "FFT991" - MULTIPLE REAL/HALF-COMPLEX PERIODIC         FFT05680
C     FAST FOURIER TRANSFORM                                            FFT05690
C                                                                       FFT05700
C     SAME AS FFT99 EXCEPT THAT ORDERING OF DATA CORRESPONDS TO         FFT05710
C     THAT IN MRFFT2                                                    FFT05720
C                                                                       FFT05730
C     PROCEDURE USED TO CONVERT TO HALF-LENGTH COMPLEX TRANSFORM        FFT05740
C     IS GIVEN BY COOLEY, LEWIS AND WELCH (J. SOUND VIB., VOL. 12       FFT05750
C     (1970), 315-337)                                                  FFT05760
C                                                                       FFT05770
C     A IS THE ARRAY CONTAINING INPUT AND OUTPUT DATA                   FFT05780
C     WORK IS AN AREA OF SIZE N*LOT                                     FFT05790
C     TRIGS IS A PREVIOUSLY PREPARED LIST OF TRIG FUNCTION VALUES       FFT05800
C     IFAX IS A PREVIOUSLY PREPARED LIST OF FACTORS OF N/2              FFT05810
C     INC IS THE INCREMENT WITHIN EACH DATA 'VECTOR'                    FFT05820
C         (E.G. INC=1 FOR CONSECUTIVELY STORED DATA)                    FFT05830
C     JUMP IS THE INCREMENT BETWEEN THE START OF EACH DATA VECTOR       FFT05840
C     N IS THE LENGTH OF THE DATA VECTORS                               FFT05850
C     LOT IS THE NUMBER OF DATA VECTORS                                 FFT05860
C     NW = 0 FOR FILTERING OFF WAVENUMBER N/2                           FFT05870
C        = 1 FOR RESERVING WAVENUMBER N/2                               FFT05880
C     ISIGN = +1 FOR TRANSFORM FROM SPECTRAL TO GRIDPOINT               FFT05890
C           = -1 FOR TRANSFORM FROM GRIDPOINT TO SPECTRAL               FFT05900
C                                                                       FFT05910
C     ORDERING OF COEFFICIENTS:                                         FFT05920
C         A(0),A(N/2),A(1),B(1),A(2),B(2),...,A(N/2-1),B(N/2-1)         FFT05930
C         BECAUSE B(0)=B(N/2)=0; N LOCATIONS REQUIRED                   FFT05940
C                                                                       FFT05950
C     ORDERING OF DATA:                                                 FFT05960
C         X(0),X(1),X(2),...,X(N-1)                                     FFT05970
C                                                                       FFT05980
C     VECTORIZATION IS ACHIEVED ON CRAY BY DOING THE TRANSFORMS IN      FFT05990
C     PARALLEL                                                          FFT06000
C                                                                       FFT06010
C     *** N.B. N IS ASSUMED TO BE AN EVEN NUMBER                        FFT06020
C                                                                       FFT06030
C     DEFINITION OF TRANSFORMS:                                         FFT06040
C     -------------------------                                         FFT06050
C                                                                       FFT06060
C     ISIGN=+1: X(J)=SUM(K=0,...,N-1)(C(K)*EXP(2*I*J*K*PI/N))           FFT06070
C         WHERE C(K)=A(K)+I*B(K) AND C(N-K)=A(K)-I*B(K)                 FFT06080
C                                                                       FFT06090
C     ISIGN=-1: A(K)=(1/N)*SUM(J=0,...,N-1)(X(J)*COS(2*J*K*PI/N))       FFT06100
C               B(K)=-(1/N)*SUM(J=0,...,N-1)(X(J)*SIN(2*J*K*PI/N))      FFT06110
C                                                                       FFT06120
C THE FOLLOWING CALL IS FOR MONITORING LIBRARY USE AT NCAR              FFT06130
C     CALL Q8QST4 ( 4HXLIB, 6HFFT99F, 6HFFT991, 10HVERSION 01)          FFT06140
      NFAX=IFAX(1)                                                      FFT06150
      NH=N/2                                                            FFT06160
      INK=INC+INC                                                       FFT06170
      IF (ISIGN.EQ.+1) GO TO 30                                         FFT06180
C                                                                       FFT06190
C     IF NECESSARY, TRANSFER DATA TO WORK AREA                          FFT06200
      IGO=50                                                            FFT06210
      IF (MOD(NFAX,2).EQ.1) GOTO 40                                     FFT06220
      IBASE=1                                                           FFT06230
      JBASE=1                                                           FFT06240
      DO 20 L=1,LOT                                                     FFT06250
      I=IBASE                                                           FFT06260
      J=JBASE                                                           FFT06270
CDIR$ IVDEP                                                             FFT06280
      DO 10 M=1,N                                                       FFT06290
      WORK(J)=A(I)                                                      FFT06300
      I=I+INC                                                           FFT06310
      J=J+1                                                             FFT06320
   10 CONTINUE                                                          FFT06330
      IBASE=IBASE+JUMP                                                  FFT06340
      JBASE=JBASE+N                                                     FFT06350
   20 CONTINUE                                                          FFT06360
C                                                                       FFT06370
      IGO=60                                                            FFT06380
      GO TO 40                                                          FFT06390
C                                                                       FFT06400
C     PREPROCESSING (ISIGN=+1)                                          FFT06410
C     ------------------------                                          FFT06420
C                                                                       FFT06430
   30 CONTINUE                                                          FFT06440
      CALL FFT99A(A,WORK,TRIGS,INC,JUMP,N,LOT,NW)                       FFT06450
      IGO=60                                                            FFT06460
C                                                                       FFT06470
C     COMPLEX TRANSFORM                                                 FFT06480
C     -----------------                                                 FFT06490
C                                                                       FFT06500
   40 CONTINUE                                                          FFT06510
      IA=1                                                              FFT06520
      LA=1                                                              FFT06530
      DO 80 K=1,NFAX                                                    FFT06540
      IF (IGO.EQ.60) GO TO 60                                           FFT06550
   50 CONTINUE                                                          FFT06560
      CALL VPASSM(A(IA),A(IA+INC),WORK(1),WORK(2),TRIGS,                FFT06570
     *   INK,2,JUMP,N,LOT,NH,IFAX(K+1),LA)                              FFT06580
      IGO=60                                                            FFT06590
      GO TO 70                                                          FFT06600
   60 CONTINUE                                                          FFT06610
      CALL VPASSM(WORK(1),WORK(2),A(IA),A(IA+INC),TRIGS,                FFT06620
     *    2,INK,N,JUMP,LOT,NH,IFAX(K+1),LA)                             FFT06630
      IGO=50                                                            FFT06640
   70 CONTINUE                                                          FFT06650
      LA=LA*IFAX(K+1)                                                   FFT06660
   80 CONTINUE                                                          FFT06670
C                                                                       FFT06680
      IF (ISIGN.EQ.-1) GO TO 110                                        FFT06690
C                                                                       FFT06700
C     IF NECESSARY, TRANSFER DATA FROM WORK AREA                        FFT06710
      IF (MOD(NFAX,2).EQ.1) GO TO 120                                   FFT06720
      IBASE=1                                                           FFT06730
      JBASE=1                                                           FFT06740
      DO 100 L=1,LOT                                                    FFT06750
      I=IBASE                                                           FFT06760
      J=JBASE                                                           FFT06770
CDIR$ IVDEP                                                             FFT06780
      DO 90 M=1,N                                                       FFT06790
      A(J)=WORK(I)                                                      FFT06800
      I=I+1                                                             FFT06810
      J=J+INC                                                           FFT06820
   90 CONTINUE                                                          FFT06830
      IBASE=IBASE+N                                                     FFT06840
      JBASE=JBASE+JUMP                                                  FFT06850
  100 CONTINUE                                                          FFT06860
      RETURN                                                            FFT06870
C                                                                       FFT06880
C     POSTPROCESSING (ISIGN=-1):                                        FFT06890
C     --------------------------                                        FFT06900
C                                                                       FFT06910
  110 CONTINUE                                                          FFT06920
      CALL FFT99B(WORK,A,TRIGS,INC,JUMP,N,LOT,NW)                       FFT06930
C                                                                       FFT06940
  120 CONTINUE                                                          FFT06950
      RETURN                                                            FFT06960
      END                                                               FFT06970
C                                                                       FFT06980
      SUBROUTINE FFTFAX(N,IFAX,TRIGS)                                   FFT06990
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT07000
      DIMENSION IFAX(*),TRIGS(*)                                        FFT07010
C                                                                       FFT07020
C MODE 3 IS USED FOR REAL/HALF-COMPLEX TRANSFORMS.  IT IS POSSIBLE      FFT07030
C TO DO COMPLEX/COMPLEX TRANSFORMS WITH OTHER VALUES OF MODE, BUT       FFT07040
C DOCUMENTATION OF THE DETAILS WERE NOT AVAILABLE WHEN THIS ROUTINE     FFT07050
C WAS WRITTEN.                                                          FFT07060
C                                                                       FFT07070
      DATA MODE /3/                                                     FFT07080
      CALL FAX (IFAX, N, MODE)                                          FFT07090
      M = IFAX(1)                                                       FFT07100
      IF (IFAX(M+1) .GT. 5 .OR. N .LE. 4) IFAX(1) = -99                 FFT07110
      IF (IFAX(1) .LE. 0 ) STOP 
      CALL FFTRIG (TRIGS, N, MODE)                                      FFT07130
      RETURN                                                            FFT07140
      END                                                               FFT07150
C                                                                       FFT07160
      SUBROUTINE FAX(IFAX,N,MODE)                                       FFT07170
      DIMENSION IFAX(*)                                                 FFT07180
      NN=N                                                              FFT07190
      IF (IABS(MODE).EQ.1) GO TO 10                                     FFT07200
      IF (IABS(MODE).EQ.8) GO TO 10                                     FFT07210
      NN=N/2                                                            FFT07220
      IF ((NN+NN).EQ.N) GO TO 10                                        FFT07230
      IFAX(1)=-99                                                       FFT07240
      RETURN                                                            FFT07250
   10 K=2                                                               FFT07260
C     TEST FOR FACTORS OF 4                                             FFT07270
   20 IF (NN.EQ.4) GO TO 100                                            FFT07280
      IF (MOD(NN,4).NE.0) GO TO 30                                      FFT07290
      IFAX(K)=4                                                         FFT07300
      NN=NN/4                                                           FFT07310
      K=K+1                                                             FFT07320
      GO TO 20                                                          FFT07330
C     TEST FOR EXTRA FACTOR OF 2                                        FFT07340
   30 IF (NN.EQ.2) GO TO 100                                            FFT07350
      IF (MOD(NN,2).NE.0) GO TO 40                                      FFT07360
      IFAX(K)=2                                                         FFT07370
      NN=NN/2                                                           FFT07380
      K=K+1                                                             FFT07390
C     TEST FOR FACTORS OF 3                                             FFT07400
   40 IF (NN.EQ.3) GO TO 100                                            FFT07410
      IF (MOD(NN,3).NE.0) GO TO 50                                      FFT07420
      IFAX(K)=3                                                         FFT07430
      NN=NN/3                                                           FFT07440
      K=K+1                                                             FFT07450
      GO TO 40                                                          FFT07460
C     NOW FIND REMAINING FACTORS                                        FFT07470
   50 L=5                                                               FFT07480
      INC=2                                                             FFT07490
C     INC ALTERNATELY TAKES ON VALUES 2 AND 4                           FFT07500
   60 IF (NN.EQ.L) GO TO 100                                            FFT07510
C     IF L LESS THAN SQRT(NN), CONTINUE TO FIND REMAINING FACTORS,      FFT07520
C     IF L EQUAL TO SQRT(NN), THEN LAST TWO FACTORS ARE BOTH L,         FFT07530
C     OTHERWISE NN IS A PRIME, I.E. LAST FACTOR.                        FFT07540
      IF (L*L-NN) 70,90,100                                             FFT07550
   70 IF (MOD(NN,L).NE.0) GO TO 80                                      FFT07560
      IFAX(K)=L                                                         FFT07570
      NN=NN/L                                                           FFT07580
      K=K+1                                                             FFT07590
      GO TO 60                                                          FFT07600
   80 L=L+INC                                                           FFT07610
      INC=6-INC                                                         FFT07620
      GO TO 60                                                          FFT07630
   90 IFAX(K)=L                                                         FFT07640
      NN=L                                                              FFT07650
      K=K+1                                                             FFT07660
C     LAST FACTOR                                                       FFT07670
  100 IFAX(K)=NN                                                        FFT07680
      IFAX(1)=K-1                                                       FFT07690
C     IFAX(1) CONTAINS NUMBER OF FACTORS                                FFT07700
      NFAX=IFAX(1)                                                      FFT07710
C     SORT FACTORS INTO ASCENDING ORDER                                 FFT07720
      IF (NFAX.EQ.1) GO TO 130                                          FFT07730
      DO 120 II=2,NFAX                                                  FFT07740
      ISTOP=NFAX+2-II                                                   FFT07750
      DO 110 I=2,ISTOP                                                  FFT07760
      IF (IFAX(I+1).GE.IFAX(I)) GO TO 110                               FFT07770
      ITEM=IFAX(I)                                                      FFT07780
      IFAX(I)=IFAX(I+1)                                                 FFT07790
      IFAX(I+1)=ITEM                                                    FFT07800
  110 CONTINUE                                                          FFT07810
  120 CONTINUE                                                          FFT07820
  130 CONTINUE                                                          FFT07830
      RETURN                                                            FFT07840
      END                                                               FFT07850
C                                                                       FFT07860
      SUBROUTINE FFTRIG(TRIGS,N,MODE)                                   FFT07870
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT07880
      DIMENSION TRIGS(*)                                                FFT07890
      PI=2.0D0*DASIN(1.0D0)                                             FFT07900
      IMODE=IABS(MODE)                                                  FFT07910
      NN=N                                                              FFT07920
      IF (IMODE.GT.1.AND.IMODE.LT.6) NN=N/2                             FFT07930
      DEL=PI/FLOAT(NN)                                                  FFT07940
      L=NN+NN                                                           FFT07950
      DO 10 I=1,L,2                                                     FFT07960
      ANGLE=DFLOAT(I-1)*DEL                                             FFT07970
      TRIGS(I)=COS(ANGLE)                                               FFT07980
      TRIGS(I+1)=SIN(ANGLE)                                             FFT07990
   10 CONTINUE                                                          FFT08000
      IF (IMODE.EQ.1) RETURN                                            FFT08010
      IF (IMODE.EQ.8) RETURN                                            FFT08020
      DEL=0.5D0*DEL                                                     FFT08030
      NH=(NN+1)/2                                                       FFT08040
      L=NH+NH                                                           FFT08050
      LA=NN+NN                                                          FFT08060
      DO 20 I=1,L,2                                                     FFT08070
      ANGLE=DFLOAT(I-1)*DEL                                             FFT08080
      TRIGS(LA+I)=COS(ANGLE)                                            FFT08090
      TRIGS(LA+I+1)=SIN(ANGLE)                                          FFT08100
   20 CONTINUE                                                          FFT08110
      IF (IMODE.LE.3) RETURN                                            FFT08120
      LA=LA+NN                                                          FFT08130
      IF (MODE.EQ.5) GO TO 40                                           FFT08140
      DO 30 I=2,NN                                                      FFT08150
      ANGLE=DFLOAT(I-1)*DEL                                             FFT08160
      TRIGS(LA+I)=2.00*SIN(ANGLE)                                       FFT08170
   30 CONTINUE                                                          FFT08180
      RETURN                                                            FFT08190
   40 CONTINUE                                                          FFT08200
      DEL=0.5D0*DEL                                                     FFT08210
      DO 50 I=2,N                                                       FFT08220
      ANGLE=DFLOAT(I-1)*DEL                                             FFT08230
      TRIGS(LA+I)=SIN(ANGLE)                                            FFT08240
   50 CONTINUE                                                          FFT08250
      RETURN                                                            FFT08260
      END                                                               FFT08270
C                                                                       FFT08280
      SUBROUTINE VPASSM(A,B,C,D,TRIGS,INC1,INC2,INC3,INC4,LOT,N,IFAC,LA)FFT08290
C     IMPLICIT REAL*8(A-H,O-Z)                                          FFT08300
      DIMENSION A(*),B(*),C(*),D(*),TRIGS(*)                            FFT08310
C                                                                       FFT08320
C     SUBROUTINE "VPASSM" - MULTIPLE VERSION OF "VPASSA"                FFT08330
C     PERFORMS ONE PASS THROUGH DATA                                    FFT08340
C     AS PART OF MULTIPLE COMPLEX FFT ROUTINE                           FFT08350
C     A IS FIRST REAL INPUT VECTOR                                      FFT08360
C     B IS FIRST IMAGINARY INPUT VECTOR                                 FFT08370
C     C IS FIRST REAL OUTPUT VECTOR                                     FFT08380
C     D IS FIRST IMAGINARY OUTPUT VECTOR                                FFT08390
C     TRIGS IS PRECALCULATED TABLE OF SINES & COSINES                   FFT08400
C     INC1 IS ADDRESSING INCREMENT FOR A AND B                          FFT08410
C     INC2 IS ADDRESSING INCREMENT FOR C AND D                          FFT08420
C     INC3 IS ADDRESSING INCREMENT BETWEEN A'S & BETWEEN B'S            FFT08430
C     INC4 IS ADDRESSING INCREMENT BETWEEN C'S & BETWEEN D'S            FFT08440
C     LOT IS THE NUMBER OF VECTORS                                      FFT08450
C     N IS LENGTH OF VECTORS                                            FFT08460
C     IFAC IS CURRENT FACTOR OF N                                       FFT08470
C     LA IS PRODUCT OF PREVIOUS FACTORS                                 FFT08480
C                                                                       FFT08490
      DATA SIN36/0.587785252292473D0/,COS36/0.809016994374947D0/,       FFT08500
     *     SIN72/0.951056516295154D0/,COS72/0.309016994374947D0/,       FFT08510
     *     SIN60/0.866025403784439D0/                                   FFT08520
C                                                                       FFT08530
      IGO=IFAC-1                                                        FFT08540
      M=N/IFAC                                                          FFT08550
      IINK=M*INC1                                                       FFT08560
      JINK=LA*INC2                                                      FFT08570
      JUMP=IGO*JINK                                                     FFT08580
      IBASE=0                                                           FFT08590
      JBASE=0                                                           FFT08600
      IA=1                                                              FFT08610
      JA=1                                                              FFT08620
      IF (IGO.GT.4) GO TO 500                                           FFT08630
      GO TO (100,200,300,400),IGO                                       FFT08640
C                                                                       FFT08650
C     CODING FOR FACTOR 2                                               FFT08660
C                                                                       FFT08670
  100 CONTINUE                                                          FFT08680
      IB=IA+IINK                                                        FFT08690
      JB=JA+JINK                                                        FFT08700
      DO 120 L=1,LA                                                     FFT08710
      I=IBASE                                                           FFT08720
      J=JBASE                                                           FFT08730
CDIR$ IVDEP                                                             FFT08740
      DO 110 IJK=1,LOT                                                  FFT08750
      C(JA+J)=A(IA+I)+A(IB+I)                                           FFT08760
      D(JA+J)=B(IA+I)+B(IB+I)                                           FFT08770
      C(JB+J)=A(IA+I)-A(IB+I)                                           FFT08780
      D(JB+J)=B(IA+I)-B(IB+I)                                           FFT08790
      I=I+INC3                                                          FFT08800
      J=J+INC4                                                          FFT08810
  110 CONTINUE                                                          FFT08820
      IBASE=IBASE+INC1                                                  FFT08830
      JBASE=JBASE+INC2                                                  FFT08840
  120 CONTINUE                                                          FFT08850
      IF (LA.EQ.M) RETURN                                               FFT08860
      LA1=LA+1                                                          FFT08870
      DO 150 K=LA1,M,LA                                                 FFT08880
      JBASE=JBASE+JUMP                                                  FFT08890
      KB=K+K-2                                                          FFT08900
      C1=TRIGS(KB+1)                                                    FFT08910
      S1=TRIGS(KB+2)                                                    FFT08920
      DO 140 L=1,LA                                                     FFT08930
      I=IBASE                                                           FFT08940
      J=JBASE                                                           FFT08950
CDIR$ IVDEP                                                             FFT08960
      DO 130 IJK=1,LOT                                                  FFT08970
      C(JA+J)=A(IA+I)+A(IB+I)                                           FFT08980
      D(JA+J)=B(IA+I)+B(IB+I)                                           FFT08990
      C(JB+J)=C1*(A(IA+I)-A(IB+I))-S1*(B(IA+I)-B(IB+I))                 FFT09000
      D(JB+J)=S1*(A(IA+I)-A(IB+I))+C1*(B(IA+I)-B(IB+I))                 FFT09010
      I=I+INC3                                                          FFT09020
      J=J+INC4                                                          FFT09030
  130 CONTINUE                                                          FFT09040
      IBASE=IBASE+INC1                                                  FFT09050
      JBASE=JBASE+INC2                                                  FFT09060
  140 CONTINUE                                                          FFT09070
  150 CONTINUE                                                          FFT09080
      RETURN                                                            FFT09090
C                                                                       FFT09100
C     CODING FOR FACTOR 3                                               FFT09110
C                                                                       FFT09120
  200 CONTINUE                                                          FFT09130
      IB=IA+IINK                                                        FFT09140
      JB=JA+JINK                                                        FFT09150
      IC=IB+IINK                                                        FFT09160
      JC=JB+JINK                                                        FFT09170
      DO 220 L=1,LA                                                     FFT09180
      I=IBASE                                                           FFT09190
      J=JBASE                                                           FFT09200
CDIR$ IVDEP                                                             FFT09210
      DO 210 IJK=1,LOT                                                  FFT09220
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IC+I))                                 FFT09230
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IC+I))                                 FFT09240
      C(JB+J)=(A(IA+I)-0.5D0*(A(IB+I)+A(IC+I)))                         FFT09250
     *   -(SIN60*(B(IB+I)-B(IC+I)))                                     FFT09260
      C(JC+J)=(A(IA+I)-0.5D0*(A(IB+I)+A(IC+I)))                         FFT09270
     *   +(SIN60*(B(IB+I)-B(IC+I)))                                     FFT09280
      D(JB+J)=(B(IA+I)-0.5D0*(B(IB+I)+B(IC+I)))                         FFT09290
     *   +(SIN60*(A(IB+I)-A(IC+I)))                                     FFT09300
      D(JC+J)=(B(IA+I)-0.5D0*(B(IB+I)+B(IC+I)))                         FFT09310
     *   -(SIN60*(A(IB+I)-A(IC+I)))                                     FFT09320
      I=I+INC3                                                          FFT09330
      J=J+INC4                                                          FFT09340
  210 CONTINUE                                                          FFT09350
      IBASE=IBASE+INC1                                                  FFT09360
      JBASE=JBASE+INC2                                                  FFT09370
  220 CONTINUE                                                          FFT09380
      IF (LA.EQ.M) RETURN                                               FFT09390
      LA1=LA+1                                                          FFT09400
      DO 250 K=LA1,M,LA                                                 FFT09410
      JBASE=JBASE+JUMP                                                  FFT09420
      KB=K+K-2                                                          FFT09430
      KC=KB+KB                                                          FFT09440
      C1=TRIGS(KB+1)                                                    FFT09450
      S1=TRIGS(KB+2)                                                    FFT09460
      C2=TRIGS(KC+1)                                                    FFT09470
      S2=TRIGS(KC+2)                                                    FFT09480
      DO 240 L=1,LA                                                     FFT09490
      I=IBASE                                                           FFT09500
      J=JBASE                                                           FFT09510
CDIR$ IVDEP                                                             FFT09520
      DO 230 IJK=1,LOT                                                  FFT09530
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IC+I))                                 FFT09540
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IC+I))                                 FFT09550
      C(JB+J)=                                                          FFT09560
     *  C1*((A(IA+I)-0.5D0*(A(IB+I)+A(IC+I)))-(SIN60*(B(IB+I)-B(IC+I))))FFT09570
     * -S1*((B(IA+I)-0.5D0*(B(IB+I)+B(IC+I)))+(SIN60*(A(IB+I)-A(IC+I))))FFT09580
      D(JB+J)=                                                          FFT09590
     *  S1*((A(IA+I)-0.5D0*(A(IB+I)+A(IC+I)))-(SIN60*(B(IB+I)-B(IC+I))))FFT09600
     * +C1*((B(IA+I)-0.5D0*(B(IB+I)+B(IC+I)))+(SIN60*(A(IB+I)-A(IC+I))))FFT09610
      C(JC+J)=                                                          FFT09620
     *  C2*((A(IA+I)-0.5D0*(A(IB+I)+A(IC+I)))+(SIN60*(B(IB+I)-B(IC+I))))FFT09630
     * -S2*((B(IA+I)-0.5D0*(B(IB+I)+B(IC+I)))-(SIN60*(A(IB+I)-A(IC+I))))FFT09640
      D(JC+J)=                                                          FFT09650
     *  S2*((A(IA+I)-0.5D0*(A(IB+I)+A(IC+I)))+(SIN60*(B(IB+I)-B(IC+I))))FFT09660
     * +C2*((B(IA+I)-0.5D0*(B(IB+I)+B(IC+I)))-(SIN60*(A(IB+I)-A(IC+I))))FFT09670
      I=I+INC3                                                          FFT09680
      J=J+INC4                                                          FFT09690
  230 CONTINUE                                                          FFT09700
      IBASE=IBASE+INC1                                                  FFT09710
      JBASE=JBASE+INC2                                                  FFT09720
  240 CONTINUE                                                          FFT09730
  250 CONTINUE                                                          FFT09740
      RETURN                                                            FFT09750
C                                                                       FFT09760
C     CODING FOR FACTOR 4                                               FFT09770
C                                                                       FFT09780
  300 CONTINUE                                                          FFT09790
      IB=IA+IINK                                                        FFT09800
      JB=JA+JINK                                                        FFT09810
      IC=IB+IINK                                                        FFT09820
      JC=JB+JINK                                                        FFT09830
      ID=IC+IINK                                                        FFT09840
      JD=JC+JINK                                                        FFT09850
      DO 320 L=1,LA                                                     FFT09860
      I=IBASE                                                           FFT09870
      J=JBASE                                                           FFT09880
CDIR$ IVDEP                                                             FFT09890
      DO 310 IJK=1,LOT                                                  FFT09900
      C(JA+J)=(A(IA+I)+A(IC+I))+(A(IB+I)+A(ID+I))                       FFT09910
      C(JC+J)=(A(IA+I)+A(IC+I))-(A(IB+I)+A(ID+I))                       FFT09920
      D(JA+J)=(B(IA+I)+B(IC+I))+(B(IB+I)+B(ID+I))                       FFT09930
      D(JC+J)=(B(IA+I)+B(IC+I))-(B(IB+I)+B(ID+I))                       FFT09940
      C(JB+J)=(A(IA+I)-A(IC+I))-(B(IB+I)-B(ID+I))                       FFT09950
      C(JD+J)=(A(IA+I)-A(IC+I))+(B(IB+I)-B(ID+I))                       FFT09960
      D(JB+J)=(B(IA+I)-B(IC+I))+(A(IB+I)-A(ID+I))                       FFT09970
      D(JD+J)=(B(IA+I)-B(IC+I))-(A(IB+I)-A(ID+I))                       FFT09980
      I=I+INC3                                                          FFT09990
      J=J+INC4                                                          FFT10000
  310 CONTINUE                                                          FFT10010
      IBASE=IBASE+INC1                                                  FFT10020
      JBASE=JBASE+INC2                                                  FFT10030
  320 CONTINUE                                                          FFT10040
      IF (LA.EQ.M) RETURN                                               FFT10050
      LA1=LA+1                                                          FFT10060
      DO 350 K=LA1,M,LA                                                 FFT10070
      JBASE=JBASE+JUMP                                                  FFT10080
      KB=K+K-2                                                          FFT10090
      KC=KB+KB                                                          FFT10100
      KD=KC+KB                                                          FFT10110
      C1=TRIGS(KB+1)                                                    FFT10120
      S1=TRIGS(KB+2)                                                    FFT10130
      C2=TRIGS(KC+1)                                                    FFT10140
      S2=TRIGS(KC+2)                                                    FFT10150
      C3=TRIGS(KD+1)                                                    FFT10160
      S3=TRIGS(KD+2)                                                    FFT10170
      DO 340 L=1,LA                                                     FFT10180
      I=IBASE                                                           FFT10190
      J=JBASE                                                           FFT10200
CDIR$ IVDEP                                                             FFT10210
      DO 330 IJK=1,LOT                                                  FFT10220
      C(JA+J)=(A(IA+I)+A(IC+I))+(A(IB+I)+A(ID+I))                       FFT10230
      D(JA+J)=(B(IA+I)+B(IC+I))+(B(IB+I)+B(ID+I))                       FFT10240
      C(JC+J)=                                                          FFT10250
     *    C2*((A(IA+I)+A(IC+I))-(A(IB+I)+A(ID+I)))                      FFT10260
     *   -S2*((B(IA+I)+B(IC+I))-(B(IB+I)+B(ID+I)))                      FFT10270
      D(JC+J)=                                                          FFT10280
     *    S2*((A(IA+I)+A(IC+I))-(A(IB+I)+A(ID+I)))                      FFT10290
     *   +C2*((B(IA+I)+B(IC+I))-(B(IB+I)+B(ID+I)))                      FFT10300
      C(JB+J)=                                                          FFT10310
     *    C1*((A(IA+I)-A(IC+I))-(B(IB+I)-B(ID+I)))                      FFT10320
     *   -S1*((B(IA+I)-B(IC+I))+(A(IB+I)-A(ID+I)))                      FFT10330
      D(JB+J)=                                                          FFT10340
     *    S1*((A(IA+I)-A(IC+I))-(B(IB+I)-B(ID+I)))                      FFT10350
     *   +C1*((B(IA+I)-B(IC+I))+(A(IB+I)-A(ID+I)))                      FFT10360
      C(JD+J)=                                                          FFT10370
     *    C3*((A(IA+I)-A(IC+I))+(B(IB+I)-B(ID+I)))                      FFT10380
     *   -S3*((B(IA+I)-B(IC+I))-(A(IB+I)-A(ID+I)))                      FFT10390
      D(JD+J)=                                                          FFT10400
     *    S3*((A(IA+I)-A(IC+I))+(B(IB+I)-B(ID+I)))                      FFT10410
     *   +C3*((B(IA+I)-B(IC+I))-(A(IB+I)-A(ID+I)))                      FFT10420
      I=I+INC3                                                          FFT10430
      J=J+INC4                                                          FFT10440
  330 CONTINUE                                                          FFT10450
      IBASE=IBASE+INC1                                                  FFT10460
      JBASE=JBASE+INC2                                                  FFT10470
  340 CONTINUE                                                          FFT10480
  350 CONTINUE                                                          FFT10490
      RETURN                                                            FFT10500
C                                                                       FFT10510
C     CODING FOR FACTOR 5                                               FFT10520
C                                                                       FFT10530
  400 CONTINUE                                                          FFT10540
      IB=IA+IINK                                                        FFT10550
      JB=JA+JINK                                                        FFT10560
      IC=IB+IINK                                                        FFT10570
      JC=JB+JINK                                                        FFT10580
      ID=IC+IINK                                                        FFT10590
      JD=JC+JINK                                                        FFT10600
      IE=ID+IINK                                                        FFT10610
      JE=JD+JINK                                                        FFT10620
      DO 420 L=1,LA                                                     FFT10630
      I=IBASE                                                           FFT10640
      J=JBASE                                                           FFT10650
CDIR$ IVDEP                                                             FFT10660
      DO 410 IJK=1,LOT                                                  FFT10670
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IE+I))+(A(IC+I)+A(ID+I))               FFT10680
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IE+I))+(B(IC+I)+B(ID+I))               FFT10690
      C(JB+J)=(A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I))) FFT10700
     *  -(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I)))              FFT10710
      C(JE+J)=(A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I))) FFT10720
     *  +(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I)))              FFT10730
      D(JB+J)=(B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I))) FFT10740
     *  +(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I)))              FFT10750
      D(JE+J)=(B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I))) FFT10760
     *  -(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I)))              FFT10770
      C(JC+J)=(A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I))) FFT10780
     *  -(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I)))              FFT10790
      C(JD+J)=(A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I))) FFT10800
     *  +(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I)))              FFT10810
      D(JC+J)=(B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I))) FFT10820
     *  +(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I)))              FFT10830
      D(JD+J)=(B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I))) FFT10840
     *  -(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I)))              FFT10850
      I=I+INC3                                                          FFT10860
      J=J+INC4                                                          FFT10870
  410 CONTINUE                                                          FFT10880
      IBASE=IBASE+INC1                                                  FFT10890
      JBASE=JBASE+INC2                                                  FFT10900
  420 CONTINUE                                                          FFT10910
      IF (LA.EQ.M) RETURN                                               FFT10920
      LA1=LA+1                                                          FFT10930
      DO 450 K=LA1,M,LA                                                 FFT10940
      JBASE=JBASE+JUMP                                                  FFT10950
      KB=K+K-2                                                          FFT10960
      KC=KB+KB                                                          FFT10970
      KD=KC+KB                                                          FFT10980
      KE=KD+KB                                                          FFT10990
      C1=TRIGS(KB+1)                                                    FFT11000
      S1=TRIGS(KB+2)                                                    FFT11010
      C2=TRIGS(KC+1)                                                    FFT11020
      S2=TRIGS(KC+2)                                                    FFT11030
      C3=TRIGS(KD+1)                                                    FFT11040
      S3=TRIGS(KD+2)                                                    FFT11050
      C4=TRIGS(KE+1)                                                    FFT11060
      S4=TRIGS(KE+2)                                                    FFT11070
      DO 440 L=1,LA                                                     FFT11080
      I=IBASE                                                           FFT11090
      J=JBASE                                                           FFT11100
CDIR$ IVDEP                                                             FFT11110
      DO 430 IJK=1,LOT                                                  FFT11120
      C(JA+J)=A(IA+I)+(A(IB+I)+A(IE+I))+(A(IC+I)+A(ID+I))               FFT11130
      D(JA+J)=B(IA+I)+(B(IB+I)+B(IE+I))+(B(IC+I)+B(ID+I))               FFT11140
      C(JB+J)=                                                          FFT11150
     *    C1*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I))) FFT11160
     *      -(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))         FFT11170
     *   -S1*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I))) FFT11180
     *      +(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))         FFT11190
      D(JB+J)=                                                          FFT11200
     *    S1*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I))) FFT11210
     *      -(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))         FFT11220
     *   +C1*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I))) FFT11230
     *      +(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))         FFT11240
      C(JE+J)=                                                          FFT11250
     *    C4*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I))) FFT11260
     *      +(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))         FFT11270
     *   -S4*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I))) FFT11280
     *      -(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))         FFT11290
      D(JE+J)=                                                          FFT11300
     *    S4*((A(IA+I)+COS72*(A(IB+I)+A(IE+I))-COS36*(A(IC+I)+A(ID+I))) FFT11310
     *      +(SIN72*(B(IB+I)-B(IE+I))+SIN36*(B(IC+I)-B(ID+I))))         FFT11320
     *   +C4*((B(IA+I)+COS72*(B(IB+I)+B(IE+I))-COS36*(B(IC+I)+B(ID+I))) FFT11330
     *      -(SIN72*(A(IB+I)-A(IE+I))+SIN36*(A(IC+I)-A(ID+I))))         FFT11340
      C(JC+J)=                                                          FFT11350
     *    C2*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I))) FFT11360
     *      -(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))         FFT11370
     *   -S2*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I))) FFT11380
     *      +(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))         FFT11390
      D(JC+J)=                                                          FFT11400
     *    S2*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I))) FFT11410
     *      -(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))         FFT11420
     *   +C2*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I))) FFT11430
     *      +(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))         FFT11440
      C(JD+J)=                                                          FFT11450
     *    C3*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I))) FFT11460
     *      +(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))         FFT11470
     *   -S3*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I))) FFT11480
     *      -(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))         FFT11490
      D(JD+J)=                                                          FFT11500
     *    S3*((A(IA+I)-COS36*(A(IB+I)+A(IE+I))+COS72*(A(IC+I)+A(ID+I))) FFT11510
     *      +(SIN36*(B(IB+I)-B(IE+I))-SIN72*(B(IC+I)-B(ID+I))))         FFT11520
     *   +C3*((B(IA+I)-COS36*(B(IB+I)+B(IE+I))+COS72*(B(IC+I)+B(ID+I))) FFT11530
     *      -(SIN36*(A(IB+I)-A(IE+I))-SIN72*(A(IC+I)-A(ID+I))))         FFT11540
      I=I+INC3                                                          FFT11550
      J=J+INC4                                                          FFT11560
  430 CONTINUE                                                          FFT11570
      IBASE=IBASE+INC1                                                  FFT11580
      JBASE=JBASE+INC2                                                  FFT11590
  440 CONTINUE                                                          FFT11600
  450 CONTINUE                                                          FFT11610
      RETURN                                                            FFT11620
C                                                                       FFT11630
C     CODING FOR FACTORS LARGER THAN 5     (TO BE ADDED)                FFT11640
C                                                                       FFT11650
  500 CONTINUE                                                          FFT11660
      RETURN                                                            FFT11670
      END                                                               FFT11680
      SUBROUTINE GRDCOF(A,AR,P,WK,IFAX,TRIGS,IMAX,JMAX,KMAX,MMAX,    
     +                MP,ITR,GUSW,LROMB)                                    
      COMPLEX A(KMAX)                                                
      REAL   GUSW(JMAX)                                             
      DIMENSION AR(IMAX,JMAX),P(JMAX,KMAX)                         
      DIMENSION WK(IMAX,JMAX)                                     
      DIMENSION IFAX(10),TRIGS(*)                                
c 
      CALL FFT991(AR,WK,TRIGS,IFAX,1,IMAX,IMAX,JMAX,0,-1)       
c
      DO 26 K=1,KMAX                                                    
      A(K)=CMPLX(0.00,0.00)                                            
   26 CONTINUE                                                        
      K=0                                                            
      DO 20 M=1,MP                                                  
      I1=2*M-1                                                     
      I2=2*M                                                      
      LMP=(M-1)*LROMB      !! RHOMBOIDAL
      DO 20 N=M,MP+LMP                                           
      K=K+1                                                     
      TR=0.00                                                  
      TI=0.00                                                 
      DO 22 J=1,JMAX                                         
      TR=TR+AR(I1,J)*(P(J,K)*GUSW(J))                       
      TI=TI+AR(I2,J)*(P(J,K)*GUSW(J))                      
   22 CONTINUE                                            
      A(K)=CMPLX(TR,TI)                                  
   20 CONTINUE                                          
      RETURN                                           
      END                                             
C                                                    
C---------------------------------------------------------------------
      SUBROUTINE COFGRD(A,AP,P,WK,IFAX,TRIGS,IMAX,JMAX,KMAX,MMAX,  
     +                MP,ITR,LROMB)                                    
c
      COMPLEX A(KMAX),AP(MMAX,JMAX)                                    
      DIMENSION P(JMAX,KMAX),WK(IMAX,JMAX)                            
      DIMENSION IFAX(10),TRIGS(*)                                      
      DO 10 M=1,MMAX                                                  
      DO 10 J=1,JMAX                                                 
      AP(M,J)=CMPLX(0.00,0.00)                                      
   10 CONTINUE                                                     
      K=0                                                         
      DO 20 M=1,MP                                               
      LMP=(M-1)*LROMB      !! RHOMBOIDAL
      DO 20 N=M,MP+LMP                                          
      K=K+1                                                    
      DO 20 J=1,JMAX                                          
      AP(M,J)=AP(M,J)+A(K)*CMPLX(P(J,K),0.00)                
   20 CONTINUE                                             
      CALL FFT991(AP,WK,TRIGS,IFAX,1,IMAX,IMAX,JMAX,0,1)  
      RETURN                                             
      END                                               
C---- THIS SUBROUTINE CALCULATES THE LEGENDER POLYNOMIALS AND THEIR 1ST LEG00010
C     ORDER DERIVATIVES FOR SPECTRAL BVE MODEL.                         LEG00020
C                                                                       LEG00030
C     ARRAY DEFINITION:                                                 LEG00040
C     GLAT(J)  GAUSSIAN LETITUDES, IN RADIANS (J=1,JGMAX S-EQ-N)        LEG00050
C     GW(J)    GAUSSIAN WEIGHTS                                         LEG00060
C     P(J,K)   LEGENDER POLYNOMIALS (K-STACKED IN MERIDIONAL            LEG00070
C              WAVENUMBER INCREASING DIRECTION                          LEG00080
C     DP(J,K)  1ST ORDER DERIVATIVES OF P(J,K)                          LEG00090
C     COA(J)   COSINE OF GAUSSIAN LATITUDES                             LEG00100
C---- SOA(J)   SINE   OF GAUSSIAN LATITUDES                             LEG00110
C                                                                       LEG00120
C                                                                       LEG00130
C---------------------------------------------------------------------- LEG00140
C                                                                       LEG00150
      SUBROUTINE GAUSSL(SIA,COA,GLAT,GW,JGMAX)                          LEG00160
C                                                                       LEG00170
C---- THIS ROUTINE CALCULATES THE GAUSSIAN LATITUDES                    LEG00180
C                                                                       LEG00190
      REAL*8 SIA(JGMAX),COA(JGMAX),GLAT(JGMAX),GW(JGMAX),               LEG00200
     $       PI2,X0,X1,X2,X3,P0,P1,P2,D0,D1,D2,DFN                      LEG00210
      X0=3.1415926535897932D0/FLOAT(4*JGMAX+2)      
      JH=(JGMAX+1)/2                                                    LEG00230
      PI2=ASIN(1.0)                                                 
      DO 30 J=1,JH                                                      LEG00250
      X1=COS(FLOAT(4*J-1)*X0) 
   10 P0=X1                                                             LEG00270
      P1=1.500*P0*P0-0.50                                           
      D0=1.00                                                      
      D1=3.00*P0                      
      DO 20 N=3,JGMAX                                                   LEG00310
      DFN=FLOAT(N)                                
      X2=(2.00*DFN-1.00)*P1          
      P2=(X1*X2-(DFN-1.00)*P0)/DFN  
      D2=X2+D0                                                          LEG00350
      P0=P1                                                             LEG00360
      P1=P2                                                             LEG00370
      D0=D1                                                             LEG00380
      D1=D2                                                             LEG00390
   20 CONTINUE                                                          LEG00400
      X3=P2/D2                                                          LEG00410
      X1=X1-X3                                                          LEG00420
      IF(ABS(X3).GE.1.E-14) GOTO 10  
      COA(J)=X1                                                         LEG00440
      GW(J)=2.000/((1.000-X1*X1)*D2*D2)                                 LEG00450
   30 CONTINUE                                                          LEG00460
      DO 40 J=1,JH                                                      LEG00470
      JJ=JGMAX-J+1                                                      LEG00480
      GLAT(JJ)=PI2-ACOS(COA(J)) 
      GLAT(J)=-GLAT(JJ)                                                 LEG00500
      SIA(JJ)=COA(J)                                                    LEG00510
      SIA(J)=-COA(J)                                                    LEG00520
      COA(J)=SQRT(1.000-COA(J)*COA(J))           
      COA(JJ)=COA(J)                                                    LEG00540
      GW(JJ)=GW(J)                                                      LEG00550
  40  CONTINUE                                                          LEG00560
      RETURN                                                            LEG00570
      END                                                               LEG00580
C                                                                       LEG00590
C-----------------------------------------------------------------------LEG00600
C                                                                       LEG00610
      SUBROUTINE LEGPOL(P,SIA,COA,KMAX,MMAX,NMAX,JGMAX,lromb)           LEG00620
C                                                                       LEG00630
C---- THIS ROUTINE THE NORMALIZED ASSOCIATED LEGENDER POLYNOMIALS AT    LEG00640
C     GAUSSIAN LATITUDES AND STORE INTO ARRAY P(JGMAX,KMAX)             LEG00650
C                                                                       LEG00660
      REAL    P(JGMAX,KMAX)                                             LEG00670
      REAL    SIA(JGMAX),COA(JGMAX),TEMP0,TEMP,FM,FM2,FN,FN2            LEG00680
      JH=(JGMAX+1)/2                                                    LEG00690
C     BAER'S NORMALIZATION INITIAL VALUE                                LEG00700
      DO 50 J=1,JH                                                      LEG00710
      K=0                                                               LEG00720
      DO 40 M=1,MMAX                                                    LEG00730
      K=K+1                                                             LEG00740
      FM=FLOAT(M-1)     
      FM2=FM+FM                                                         LEG00760
      IF (M.EQ.1) THEN                                                  LEG00770
      TEMP=SQRT(0.500)
      P(J,K)=TEMP                                                       LEG00790
      P1=P(J,K)                                                         LEG00800
      ELSE                                                              LEG00810
      TEMP= SQRT(1.000+1.000/FM2)                                       LEG00820
      P(J,K)=TEMP*COA(J)*P1                                             LEG00830
      P1=P(J,K)                                                         LEG00840
      ENDIF                                                             LEG00850
      K=K+1                                                             LEG00860
      TEMP= SQRT(FM2+3.000)                                             LEG00870
      P(J,K)=TEMP*SIA(J)*P(J,K-1)                                       LEG00880
      lmp=(m-1)*lromb
      DO 30 N=M+2,NMAX+lmp
      K=K+1                                                             LEG00900
      FM=FLOAT(M-1)  
      FN=FLOAT(N-1)  
      TEMP0=(2.000*FN+1.000)/(FN+FM)/(FN-FM)                            LEG00930
      TEMP= SQRT(TEMP0*(2.000*FN-1.000))                                LEG00940
      TEMP0=                                                            LEG00950
     $  SQRT(TEMP0*(FN+FM-1.000)*(FN-FM-1.000)/(2.000*FN-3.000))        LEG00960
      P(J,K)=TEMP*SIA(J)*P(J,K-1)-TEMP0*P(J,K-2)                        LEG00970
   30 CONTINUE                                                          LEG00980
   40 CONTINUE                                                          LEG00990
C                                                                       LEG01000
   50 CONTINUE                                                          LEG01010
      K=0                                                               LEG01020
      DO 60 M=1,MMAX                                                    LEG01030
      lmp=(m-1)*lromb
      DO 60 N=M,NMAX+lmp
      K=K+1                                                             LEG01050
      DO 60 J=1,JH                                                      LEG01060
      JJ=JGMAX-J+1                                                      LEG01070
      KMN=M+N                                                           LEG01080
      IF(MOD(KMN,2).EQ.1) P(JJ,K)=-P(J,K)                               LEG01090
      IF(MOD(KMN,2).EQ.0) P(JJ,K)=P(J,K)                                LEG01100
   60 CONTINUE                                                          LEG01110
      RETURN                                                            LEG01120
      END                                                               LEG01130
C                                                                       LEG01140
C---------------------------------------------------------------------  LEG01150
C                                                                       LEG01160
      SUBROUTINE DIFP(SIA,COA,P,DP,KMAX,MMAX,NMAX,JGMAX,lromb)
C                                                                       LEG01180
C---- THIS ROUTINE THE 1ST ORDER DERIVATIVES OF LEGENDER POLYNOMIALS    LEG01190
C     AT GUASSIAN LATITUDES, GIVES DP/COS(J),                           LEG01200
C     AND STORE INTO ARRAY DP(JGMAX,KMAX)                               LEG01210
C                                                                       LEG01220
      REAL   P(JGMAX,KMAX),DP(JGMAX,KMAX),EPSLON(127,127)
      REAL   SIA(JGMAX),COA(JGMAX),FM,FN                                LEG01240
C                                                                       LEG01250
C    EPSLON ARRAY INITIALIZED                                           LEG01260
C                                                                       LEG01270
      DO 10 M=1,MMAX                                                    LEG01280
      lmp=(m-1)*lromb
      DO 10 N=M,NMAX+lmp
      FM=FLOAT(M-1)
      FN=FLOAT(N-1)
      EPSLON(M,N)= SQRT((FN*FN-FM*FM)/(4.000*FN*FN-1.000))              LEG01320
   10 CONTINUE                                                          LEG01330
      DO 40 J=1,JGMAX                                                   LEG01340
      K=0                                                               LEG01350
      DO 30 M=1,MMAX                                                    LEG01360
      K=K+1                                                             LEG01370
      FM=FLOAT(M-1) 
      IF (M.EQ.MMAX) THEN                                               LEG01390
      DP(J,K)=-FM*SIA(J)*P(J,K)/COA(J)/COA(J)                           LEG01400
      ELSE                                                              LEG01410
      DP(J,K)=-FM*EPSLON(M,M+1)*P(J,K+1)/COA(J)/COA(J)                  LEG01420
      ENDIF                                                             LEG01430
      lmp=(m-1)*lromb
      DO 20 N=M+1,NMAX+lmp
      K=K+1                                                             LEG01450
      FN=FLOAT(N-1)  
      IF (N.EQ.NMAX) THEN                                               LEG01470
      DP(J,K)=((2.000*FN+1.000)*EPSLON(M,N)*P(J,K-1)                    LEG01480
     & -FN*SIA(J)*P(J,K))/COA(J)/COA(J)                                 LEG01490
      ELSE                                                              LEG01500
      DP(J,K)=((FN+1.000)*EPSLON(M,N)*P(J,K-1)                          LEG01510
     $   -FN*EPSLON(M,N+1)*P(J,K+1))/COA(J)/COA(J)                      LEG01520
      ENDIF                                                             LEG01530
  20  CONTINUE                                                          LEG01540
  30  CONTINUE                                                          LEG01550
  40  CONTINUE                                                          LEG01560
      RETURN                                                            LEG01570
      END                                                               LEG01580
C
C TWO DIMENSIONAL LINEAR INTERPOLATION.
C MFLG((+/-)1,0) --- INTEGER FLAG OF (USE,NOT.USE) MASK.
c    if mflg.lt.0 ==> do not set default value in array B.
C  SETUP MASK IN CALLER AND PUT INTO COMMON BLOCK /COMASK/DEFLT,MASK
C  MASK(I,J) = (1,0) --- (USE, VOID) DATA POINT (I,J)
C  SET DEFAULT VALUE FOR MASKED OUT POINTS IN DEFLT (R*4)
C  IERR,JERR --- NO. OF XB,YB POINTS OUTSIDE DOMAIN OF XA AND YA.
C
      SUBROUTINE INTP2D(A,IMX,IMY,XA,YA,B,JMX,JMY,XB,YB,MFLG)
      PARAMETER(MAX=361,MAXP=361*181)
      COMMON /COMASK/ DEFLT,MASK(maxp)
      COMMON /COMWRK/ IERR,JERR,DXP(MAX),DYP(MAX),DXM(MAX),DYM(MAX),
     1                IPTR(MAX),JPTR(MAX),WGT(4)
      DIMENSION A(IMX,*),B(JMX,*),XA(*),YA(*),XB(*),YB(*)
      CALL SETPTR(XA,IMX,XB,JMX,IPTR,DXP,DXM,IERR)
      CALL SETPTR(YA,IMY,YB,JMY,JPTR,DYP,DYM,JERR)
      DO 1 I = 1,4
  1   WGT(I) = 1.0
      IF (MFLG.EQ.0) DEFLT = 0.00
      if (mflg.ge.0) then
        DO 2 J = 1,JMY
        DO 2 I = 1,JMX
  2     B(I,J) = DEFLT
      endif
C
      DO 20 J = 1,JMY
        JM = JPTR(J)
        IF (JM.LT.0) GOTO 20
        JP = JM + 1
      DO 10 I = 1,JMX
        IM = IPTR(I)
        IF (IM.LT.0) GOTO 10
        IP = IM + 1
        IF(mflg.ne.0) CALL MSKWGT(MASK,IMX,IMY,IM,IP,JM,JP,WGT,mflg,*10)
        D1 = DXM(I)*DYM(J)*WGT(1)
        D2 = DXM(I)*DYP(J)*WGT(2)
        D3 = DXP(I)*DYM(J)*WGT(3)
        D4 = DXP(I)*DYP(J)*WGT(4)
        DD = D1 + D2 +D3 + D4
        IF (DD.EQ.0.0) GOTO 10
        B(I,J) = (D4*A(IM,JM)+D3*A(IM,JP)+D2*A(IP,JM)+D1*A(IP,JP))/DD
   10 CONTINUE
   20 CONTINUE
      if(yb(1).le.ya(1)) then
      do 30 i=1,jmx
  30  b(i,1)=b(i,2)*0.65+b(i,3)*0.35
      endif
      if(yb(jmy).ge.ya(imy)) then
      do 40 i=1,jmx
  40  b(i,jmy)=b(i,jmy-1)*0.65+b(i,jmy-2)*0.35
      endif
      if(xb(1).le.xa(1)) then
      do 50 j=1,jmy
  50  b(1,j)=b(2,j)*0.65+b(3,j)*0.35
      endif
      if(xb(jmx).ge.xa(imx)) then
      do 60 j=1,jmy
  60  b(jmx,j)=b(jmx-1,j)*0.65+b(jmx-2,j)*0.35
      endif
      RETURN
      END
C
c  id --- flag for extrapolation over land:
c         0 --- interpolate over land points;
c        -1 --- ignore land points.
c
      SUBROUTINE MSKWGT(MASK,IMX,IMY,IM,IP,JM,JP,WGT,id,*)
      INTEGER   MASK(IMX,IMY)
      DIMENSION WGT(4)
      isum = 0
      WGT(1) = MASK(IP,JP)
      WGT(2) = MASK(IP,JM)
      WGT(3) = MASK(IM,JP)
      WGT(4) = MASK(IM,JM)
      isum = mask(ip,jp)+mask(ip,jm)+mask(im,jp)+mask(im,jm)
      if (id.lt.0.and.isum.lt.4) return 1
      RETURN
      END
C
      SUBROUTINE SETPTR(X,M,Y,N,IPTR,DP,DM,IERR)
      DIMENSION X(*),Y(*),IPTR(*),DP(*),DM(*)
      IERR = 0
      DO 10 J = 1,N
        YL = Y(J)
        IF (YL.LT.X(1)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ELSEIF (YL.GT.X(M)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ENDIF
        DO 20 I = 1,M-1
          IF (YL.GT.X(I+1)) GOTO 20
          DM(J) = YL-X(I)
          DP(J) = X(I+1)-YL
          IPTR(J) = I
          GOTO 10
  20    CONTINUE
  10  CONTINUE
      RETURN
      END
      SUBROUTINE INTP1D(A,IMX,IMY,XA,YA,B,JMX,JMY,XB,YB,SPVAL,NSPV,
     $  idx,idy)
C
C---- This is one dimensional intepolation program
C     do x-direction intepolation for each J first, then do y-direction
c     intepolation for each new J 
C     idx=1 intepolate,   idx=0 no intepolation 1st dimension
C     idy=1 intepolate,   idy=0 no intepolation 2nd dimension
c
      PARAMETER(MAX=721,MAXP=362*181)                 
      DIMENSION DXP(MAX),DYP(MAX),DXM(MAX),DYM(MAX),   
     1          IPTR(MAX),JPTR(MAX),WGT(2),WK(361,181)       
      DIMENSION A(IMX,*),B(JMX,*),XA(*),YA(*),XB(*),YB(*)           
C
      CALL SETINT(XA,IMX,XB,JMX,IPTR,DXP,DXM,IERR)                   
      CALL SETINT(YA,IMY,YB,JMY,JPTR,DYP,DYM,JERR)                    

C
      DO 4 J=1,JMY
      DO 4 I=1,JMX
        B(I,J)=0.0
  4   CONTINUE
      do 5 j=1,imy
      do 5 i=1,jmx
        wk(i,j)=0.0
 5    continue
C
      IF (NSPV.NE.0) THEN
      DO 6 J = 1,JMY                                         
      DO 6 I = 1,JMX                                          
  6   B(I,J) = SPVAL                                           
      do 7 j=1,imy
      do 7 i=1,jmx
       wk(i,j)=spval
  7   continue
      ENDIF
c
      if (idx.eq.0) then
        do 11 j=1,imy
        do 11 i=1,jmx
          wk(i,j)=a(i,j)
  11    continue
      endif
C                                         
      if (idx.eq.1) then
      DO 20 J = 1,IMY                    
        DO 10 I = 1,JMX                    
          IM = IPTR(I)                    
          IF (IM.LT.0) GOTO 10           
          IP = IM + 1                 
          WGT(1)=1.0                                                  
          WGT(2)=1.0                                                 
          IF(A(IP,J).EQ.SPVAL)  WGT(1)=0.0  
          IF(A(IM,J).EQ.SPVAL)  WGT(2)=0.0
          D1 = DXM(I)*WGT(1)                                
          D2 = DXP(I)*WGT(2)                               
          DD=D1+D2
          IF (DD.EQ.0.0) GOTO 10                              
          WK(I,J) = (D2*A(IM,J)+D1*A(IP,J))/DD 
 10     CONTINUE
 20   CONTINUE
       endif
c
      if (idy.eq.0) then
        do 21 j=1,jmy
        do 21 i=1,jmx
          b(i,j)=wk(i,j)
  21    continue
      endif
C                                         
      if (idy.eq.1) then
      DO 40 I = 1,JMX                
        DO 30 J = 1,JMY
          JM = JPTR(J)
          IF (JM.LT.0) GOTO 30     
          JP = JM + 1             
          WGT(1)=1.0                                                  
          WGT(2)=1.0                                                 
          IF(WK(I,JP).EQ.SPVAL)  WGT(1)=0.0  
          IF(WK(I,JM).EQ.SPVAL)  WGT(2)=0.0              
          D1 = DYM(J)*WGT(1)                                
          D2 = DYP(J)*WGT(2)                               
          DD = D1 + D2 
          IF (DD.EQ.0.0) GOTO 30                              
          B(I,J) = (D2*WK(I,JM)+D1*WK(I,JP))/DD 
   30   CONTINUE                                                       
   40 CONTINUE                                                      
      endif
      RETURN                                                       
      END                                                         
C
      SUBROUTINE SETINT(X,M,Y,N,IPTR,DP,DM,IERR)
      DIMENSION X(*),Y(*),IPTR(*),DP(*),DM(*)
      IERR = 0
      chk=x(m)-x(1)
      if(chk.lt.0.0) goto 50
      DO 10 J = 1,N
        YL = Y(J)
        IF (YL.LT.X(1)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ELSEIF (YL.GT.X(M)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 10
        ENDIF
        DO 20 I = 1,M-1
          IF (YL.GT.X(I+1)) GOTO 20
          DM(J) = YL-X(I)
          DP(J) = X(I+1)-YL
          IPTR(J) = I
          GOTO 10
  20    CONTINUE
  10    CONTINUE
      return
c
  50  continue
      DO 30 J = 1,N
        YL = Y(J)
        IF (YL.GT.X(1)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 30
        ELSEIF (YL.LT.X(M)) THEN
          IERR = IERR + 1
          IPTR(J) = -1
          GOTO 30
        ENDIF
        DO 40 I = 1,M-1
          IF (YL.LT.X(I+1)) GOTO 40
          DM(J) = YL-X(I)
          DP(J) = X(I+1)-YL
          IPTR(J) = I
          GOTO 30
  40    CONTINUE
  30  CONTINUE
      RETURN
      END
      SUBROUTINE SETXY(X,NX,Y,NY,XMN,DLX,YMN,DLY)                       00000010
      DIMENSION X(NX),Y(NY)                                             00000020
      DO 10 I = 1,NX                                                    00000030
   10   X(I) = XMN + DLX*FLOAT(I-1)                                     00000040
      IF (NY.EQ.0) RETURN
      DO 20 J = 1,NY                                                    00000050
   20   Y(J) = YMN + DLY*FLOAT(J-1)                                     00000060
      RETURN                                                            00000070
      END                                                               00000080
