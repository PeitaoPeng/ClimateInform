MODULE Fileops
      USE ControlConstants
!***********************************************************************
!  MODULE Fileops                                                      *
!                                                                      *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!   This is file management routine for FORTRAN programs               *
!   It Reads a control file of specified format                        *
!    makes file names.                                                 *
!    does string manipulation                                          *
!----------------------------------------------------------------------*
!   VARIABLES                                                          *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
! VARIABLES IN LOCAL MODULE                                            *
!                                                                      *
!    LOCAL MODULE                                                      *
!      ndim - Total files to hold                                      *
!    kunit - Array holding file unit numbers                           *
!    jftyp - Array holdking file record length (also used for file type*
!   chpath,chfile - Character arrays holding path and file names       *
!    chdsn,chwork,chwork2,chtlf - String variables for temporary use   *
!                                                                      *
!----------------------------------------------------------------------*
!   SUBROUTINES INCLUDED IN THIS MODULE                                *
!     GETFILES,GETFILESL,OPENFILE,EHAND ,MKDSNNUM,MKSTRING             *
!***********************************************************************
      INTEGER, PRIVATE, PARAMETER :: ndim=50
      INTEGER, DIMENSION(ndim) :: kunit,jftyp
      CHARACTER(len=120), DIMENSION(ndim) :: chpath,chfile
      CHARACTER(len=240) :: chdsn
      CHARACTER(len=120) :: chwork,chwork2,chctlf
      CHARACTER(len=1) :: chblank 
      INTEGER :: jchlen,jchlen2
      SAVE
CONTAINS
!---------------------------------------------------------------------------------
      SUBROUTINE GETFILES(nu,nfile)
!***********************************************************************
!*   SUBROUTINE  GETFILES                                              *
!      Get the name of the control file and pass control to the        *
!       control file processing routine                                *
!                                                                      *
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!* PURPOSE:   General input routine for file management                *
!*---------------------------------------------------------------------*
!* FILES USED    An input control file on unit NU   See Unger .ctl doc *
!*---------------------------------------------------------------------*
!* SUBROUTINES USED: NONE                                              *
!*---------------------------------------------------------------------*
!* VARIABLES                                                           *
!*  INPUT VARIABLES FROM CALL                                          *
!    nu - Unit number for control file                                 *
!   OUTPUT VARIABLES IN THE CALL                                       *
!    nfile - Number of files read from the control file                *
!   VARIABLES FROM LOCAL MODULE                                        *
!    chctlf - input name from script                                   *
!   VARIABLES FROM MODULE ControlConstants                             *
!      jprint - Printing control constant                              *
!***********************************************************************
      IMPLICIT NONE
      INTEGER :: nu,jchlen,jchlen2,nerr,nfile      
      jchlen=120
      jchlen2=240
      CALL GETARG(1,chctlf)
      print 91,chctlf
 91   FORMAT(a120)
      OPEN(nu,file=chctlf,iostat=nerr)
      IF (nerr /= 0) CALL EHAND(nu,jprint,nerr)
      CALL GETFILESL(nu,nfile,nerr)
      RETURN
      END SUBROUTINE GETFILES
!---------------------------------------------------------------------------------
      SUBROUTINE GETFILESL(nu,nfile,nerr)
      IMPLICIT NONE
      SAVE
!***********************************************************************
!*   SUBROUTINE  GETFILESL   Reads file information from a control file*
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!* PURPOSE:   General input routine for file management                *
!*---------------------------------------------------------------------*
!* FILES USED    An input control file on unit NU   See Unger .ctl doc *
!*---------------------------------------------------------------------*
!* SUBROUTINES USED: NONE                                              *
!*---------------------------------------------------------------------*
!* CALL ARGUMENTS:                                                     *
!*  INPUT VARIABLES                                                    *
!           nu = input unit number assigned to the control file        *
!       jprint = (Input) 1=print input, 0 dont print                   *
!       ndim = dimension of character datasets                         *
!  OUTPUT VARIABLES                                                    *
!       note that character datasets are up to 120 characters length   *
!        A sequence of nfiles are read each                            *
!        chpath() = holds the path of each of the datasets.            *
!       chfile () = Holds the dataset name of each dataset             *
!      jftyp ()   = Identifies common file types, 0 for sequential     *
!                 = jrecl = the record length of direct access         *
!       nfile= number of input files                                   *
!      nerr = error return 1 end of file 2 read error 3 bad dimension  *
!    INTERNAL VARIABLES                                                *
!       chlabel = Dataset identifier label (internal or printed)       *
!*---------------------------------------------------------------------*
!  SUBROUTINES OUTSIDE OF MODULE USED                                  *
!      NONE                                                            *
!*---------------------------------------------------------------------*
!* AUTHOR:   UNGER, 2008                                               *
!*---------------------------------------------------------------------*
!* MODIFICATIONS                                                       *
!*---------------------------------------------------------------------*
      INTEGER :: jf,nerr,nfile,jend,jread,nu,kf,jft
      CHARACTER*10 :: chlabel
      jf=1
      nerr=0
      nfile=0
      jend=0
      jread=0
      READ(nu,92,iostat=nerr) chlabel
!       This logical structure keeps reading files until a 999 is read
        IF( nerr /= 0 ) CALL EHAND(nu,jread,nerr)
      DO WHILE (jend .NE. 999) 
      jread=jread+1
      READ(nu,91,iostat=nerr) kf,jft,chlabel
 91   FORMAT(I3,I8,A120)
      IF( NERR /= 0 ) CALL EHAND(nu,jread,nerr)
      IF(kf .NE. 999) THEN
         IF(jf .GT. ndim) THEN
            jread=999
            CALL EHAND(nu,jread,nerr)
         ENDIF
         kunit(jf)=kf
         jftyp(jf)=jft
         READ(nu,92,iostat=nerr) chpath(jf)
         IF( nerr /= 0 ) CALL EHAND(nu,jread,nerr)
         jread=jread+1
         READ(nu,92,iostat=nerr)chfile(jf)
         IF( nerr /= 0 ) CALL EHAND(nu,jread,nerr)
 92      FORMAT(A120)
         IF(jf .GT. ndim) THEN
              jread=999
              CALL EHAND(nu,jread,nerr)
         ENDIF
         IF(jprint >  2) THEN
            PRINT 91,kf,jftyp(jf),chlabel
            PRINT 92,chpath(jf)
            PRINT 92,chfile(jf)
         ENDIF
      ENDIF
      jend=kf
      jf=jf+1
      print *,jend
      ENDDO
      nfile=jf-2
      IF(jprint > 0) THEN
        print 106,nfile
 106    FORMAT( '  Number of files read = ',I5)
      ENDIF
      RETURN
      END SUBROUTINE GETFILESL
!---------------------------------------------------------------------------------
      SUBROUTINE OPENFILE(nuf,nf1,nf2,jprint,nerr)
!***********************************************************************
!*   SUBROUTINE  OPENFILE  Opens files using info. from a control file *
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!* PURPOSE:   General file management routine                          *
!*---------------------------------------------------------------------*
!* FILES USED    See input variables                                   *
!*---------------------------------------------------------------------*
!* SUBROUTINES USED: NONE                                              *
!*---------------------------------------------------------------------*
!* CALL ARGUMENTS:                                                     *
!*  INPUT VARIABLES                                                    *
!           nuf = input unit number assigned to the first file to open *
!       note that character datasets are up to 120 characters length   *
!        A sequence of nfiles are read each                            *
!        chpath() = holds the path of each of the datasets.            *
!       chfile () = Holds the dataset name of each dataset             *
!      jftyp ()   = Identifies common file types, 0 for sequential     *
!                 = jrecl = the record length of direct access         *
!      nf1 = array location of chpath,chfile, and jftyp corresponding  *
!             to the first file (nuf) to open                          *
!       nfile= number of input files, nuf is incremented by 1 for      *
!              each new open, as is the array location.                *
!       jprint = (Input) 1=print input, 0 dont print                   *
!       ndim = dimension of character datasets                         *
!  OUTPUT VARIABLES                                                    *
!      nerr = error return 1 end of file 2 read error 3 bad dimension  *
!    INTERNAL VARIABLES                                                *
!       chdsn = Dataset name (Path + File name) to open                *
!*---------------------------------------------------------------------*
!* AUTHOR:   UNGER, 2008                                               *
!*---------------------------------------------------------------------*
!* MODIFICATIONS                                                       *
!*---------------------------------------------------------------------*
      nerr=0
      nff=nf1+nf2-1
      chblank=' '
      jchlen=120
      jchlen2=240
      PRINT 79,nf1,nff,nf2
      DO  jf=nf1,nff
        nunit=kunit(jf)
        IF(jprint > 0) PRINT 79,jf,nf1,nff,nunit
 79     FORMAT(' Opening files,index, first,number, dim  ',4I5)
!        blank out the dsn, remove stray blank space from input and fill
        DO j=1,jchlen2
          IF(j .LE. jchlen) chwork(j:j)=chblank
          chdsn(j:j)=chblank
        END DO
        nl=LEN_TRIM(chpath(jf))
        nlf=LEN_TRIM(chfile(jf))
        chwork=chpath(jf)
        chdsn(1:nl)=chwork(1:nl)
        nlp=nl+1
        nll=nlp+nlf-1
        chwork=chfile(jf)
        chdsn(nlp:nll)=chwork(1:nlf)
        IF(jprint .GT. 1) THEN
           PRINT 91,chpath(jf)
           PRINT 91,chfile(jf)
           PRINT 91,chdsn
 91        FORMAT('file ',A240)
           PRINT 92,jftyp(jf)
 92        FORMAT(' recl=  ',I9)
        ENDIF
!        open sequential or binary (jftyp=0), or direct access (jftyp=recl)
        IF(jftyp(jf) .EQ. 0) THEN
           OPEN(nunit,file=chdsn,iostat=nerr)
           IF(nerr /= 0) THEN
              print *,' failed to open ',nunit,chdsn
              STOP
           ENDIF
           
           IF(jprint .GE. 1)print 93,nunit,chdsn
 93     FORMAT(' opening sequential file unit= ',I4,' ',A120)
        ELSE
           OPEN(nunit,file=chdsn,access='DIRECT',form='UNFORMATTED',recl=jftyp(jf),iostat=nerr)
           IF(nerr /= 0) THEN
              print *,' failed to open ',nunit,chdsn
              STOP
           ENDIF
	   IF(jprint .GE. 1)print 94,nunit,chdsn
 94       FORMAT(' opening direct access file unit= ',I4,' ',A120)
        ENDIF
      END DO
      IF( jprint .GE. 1) print 101
 101  FORMAT(' Finished opening files, returning to main routine')
      RETURN
      END SUBROUTINE OPENFILE
!---------------------------------------------------------------------------------
      SUBROUTINE MKDSNNUM(jf,nchange,jch,jva,nerr,jstatus)
!***********************************************************************
!  SUBROUTINE MKDSNNUM                                                 *
!----------------------------------------------------------------------*
!  LANGUAGE    FORTRAN 90                                              *
!----------------------------------------------------------------------*
!  MACHINE     linux                                                   *
!----------------------------------------------------------------------*
!   PURPOSE                                                            *
!     INSERTS A NUMBER INTO A DATASET PATH OR NAME - FIXED LENGTH      *
!     AND OPENS THAT FILE                                              *
!----------------------------------------------------------------------*
!  FILES USED   none                                                   *
!----------------------------------------------------------------------*
!  SUBROUTINES USED:        MKSTRING                                   *
!----------------------------------------------------------------------*
!  CALL ARGUMENTS:                                                     *
!   INPUT VARIABLES                                                    *
!       jf = POSITION (Not unit number!) of the dataset control values *
!            Explanation.   The program control files holds the data   *
!            set names.  Then typically has some numerical values that *
!            are read in to fill the control variables.                *
!            There can be a series of instruction for run-time dataset *
!            alterations.  These typically are groups of lines with    *
!             nchange = # of changes on this dataset on the first      *
!             jch(j,3) = the three values instructing the program what *
!             to change.                                               *
!           EXAMPLE                                                    *  
!            2                                                         *
!            5   -7    2                                               *
!            5   10    2                                               *
!            1                                                         *
!            6    5    2                                               *
!              There are 2 files with dynamic changes.  The first is   *
!              is the first file on read by GETFILES (Not the unit     *
!              number, ie. the 5th file in the control file), and makes*
!              the changes as instructed in jch.   The second group    *
!              points to the 6th file, and gives instructions.         *
!            jf is the group number, ie 1 for the first (File#5)       *
!             and 2 for the second change set (6th file).              *
!            see writeup for the control files for more information    *
!       nchange = Number of changes to make on this data set           *
!        jch = An array of up to 10 changes                            *
!              jch(I,1)= The file position (not unit number ) on the   *
!              program control file.                                   *
!        jch(2) = position relative to the start of the dataset name   *
!                 to insert number (Negative numbers change the path   *
!        jch(3)  = the number of digits to insert (controls leading    *
!                  zeros.  month 01 = 2 digits.                        *
!        jva()    Value to insert for each of the nchange changes.     *
!            jva is an array.                                          *
!        jstatus = 1 = old 2 - new                                     *
!   OUTPUT VARIABLES                                                   *
!        nerr = 0 Good open, 1 file does not exist and jstatus=1       *
!----------------------------------------------------------------------*
!  AUTHOR:   UNGER, 2012                                               *
!----------------------------------------------------------------------*
!  MODIFICATIONS                                                       *
!----------------------------------------------------------------------*
      LOGICAL :: lopen,lexist
      INTEGER,DIMENSION(10,4) :: jch
      INTEGER,DIMENSION(10) :: jva
      CHARACTER*120 :: chwork
      CHARACTER*3,dimension(2) :: chstat
       chstat(1)='OLD'
       chstat(2)='NEW'
      chblank=' '
      nerr=0     
      DO jc=1,240
        chdsn(jc:jc)=chblank
      ENDDO
      nln=LEN_TRIM(chpath(jf))
      nlndsn=LEN_TRIM(chfile(jf))
      chwork=chpath(jf)
      chwork2=chfile(jf)
      chdsn(1:nln)=chwork(1:nln)
      nlnp=nln+1
      nlnx=nlnp-1+nlndsn
      chdsn(nlnp:nlnx)=chwork2(1:nlndsn)
      DO jchange=1,nchange
        jpos=jch(jchange,2)
        jlen=jch(jchange,3)
        jv=jva(jchange)
        kpos=nln+jpos
        PRINT *,' mkdsn ',jchange,jpos,jlen,jv,kpos
        CALL MKSTRING(3,chdsn,chwork,jv,kpos,jlen,knext,klen)
      END DO
      jfil=jch(1,1)
      nu=kunit(jfil)
      INQUIRE(FILE=chdsn,opened=lopen)
      IF(lopen) THEN
        RETURN
      ELSE
        CLOSE (nu)
        IF(jftyp(jfil) .EQ. 0) THEN
           IF(jstatus == 1) THEN
              INQUIRE(FILE=chdsn,exist=lexist)
              IF(lexist) THEN
                 OPEN(nu,file=chdsn,status=chstat(jstatus))
                  IF(jprint .GE. 1)print 93,nu,chdsn
 93              FORMAT(' opening sequential file unit= ',I4,' ',A120)
              ELSE
                 nerr=1
                 print *,' File not found ',chdsn
              ENDIF
            ELSE
               OPEN(nu,file=chdsn,status=chstat(jstatus))
                IF(jprint .GE. 1)print 93,nunit,chdsn    
            ENDIF
        ELSE
           IF(jstatus == 1) THEN
              INQUIRE(FILE=chdsn,exist=lexist)
              IF(lexist) THEN
                 OPEN(nu,file=chdsn,access='DIRECT',form='UNFORMATTED',recl=jftyp(jf), &
                   status=chstat(jstatus))
	         IF(jprint .GE. 1)print 94,nu,chdsn
 94              FORMAT(' opening direct access file unit= ',I4,' ',A120)
              ELSE
                 print *,' File not found ',chdsn
                 nerr=1
              ENDIF
           ELSE 
              OPEN(nu,file=chdsn,access='DIRECT',form='UNFORMATTED',recl=jftyp(jf), &
                 status=chstat(jstatus))
	      IF(jprint .GE. 1)print 94,nu,chdsn         
           ENDIF
        ENDIF
      ENDIF
      RETURN
      END SUBROUTINE MKDSNNUM      
!---------------------------------------------------------------------------------
      SUBROUTINE MKSTRING(jc,choutput,chinput,jv,kp,np,knext,nlen)
!***********************************************************************
!   SUBROUTINE     MKSTRING                                            *
!----------------------------------------------------------------------*
! LANGUAGE    FORTRAN 90                                               *
!----------------------------------------------------------------------*
! MACHINE     linux                                                    *
!----------------------------------------------------------------------*
! PURPOSE:      A UTILITY FOR STRING MANIPULATION. THIS ROUTINE        *
!      INSERTING OR REPLACING STRING VALUES, OR INSERTS STRING         *
!      EQUIVALENTS OF NUMERICAL VARIABLES                              *
!----------------------------------------------------------------------*
! FILES USED    NONE                                                   *
!----------------------------------------------------------------------*
! SUBROUTINES USED:   NONE                                             *
!----------------------------------------------------------------------*
! CALL ARGUMENTS:                                                      *
!  INPUT VARIABLES                                                     *
!     jc=input instruction flag                                        *
!        1 - REPLACE characters in choutput starting choutput(:kp)     *
!           with np characters from chinput starting at chinput(:1)    *
!        2 - INSERT characters in choutput starting choutput(:kp)      *
!           with np characters from chinput starting at chinput(:1)    * 
!        3 - REPLACE np characters in choutput starting at kp with     *
!            the character representation of the integer value jv      *
!        4 - INSERT np characters in choutput starting at kp with the  *
!           character representation of the integer value given by jv  *
!          chinput = 120 character input string                        *
!             jv   = integer value to insert into chinput              *
!             kp   = First position of replace/insert, if insertion,   *
!                   characters kp and higher are moved right.          *
!            np   = number of positions added/replaced (if known)      *
!          knext  = the next position following insertion/replacement  *
!           nlen = new total length of non-blank characters            *
!                                                                      *      
!  OUTPUT VARIABLES                                                    *
!           choutput = 240 character output string                     *
!                                                                      *
!    NOTES jc=1 and 2 uses BOTH choutput and chinput                   *
!     jc=3 and 4 uses only choutput                                    *
!        if the number of input characters is not known, np=0 will     *
!       count characters excluding trailing (right most) blanks        *
!        left justify input strings.                                   *
!          choutput can be blank on input and loaded with chinput using*
!              jc = 1 and np=0                                         *
!        strings are left justified.                                   *  
!----------------------------------------------------------------------*
! AUTHOR:   UNGER, 2005                                                *
!----------------------------------------------------------------------*
! MODIFICATIONS                                                        *
!----------------------------------------------------------------------*
      CHARACTER*120 chinput,chtemp
      CHARACTER*240 choutput,chtemp2
      CHARACTER*7 chnumber,chntemp
      maxchar=240
      maxinp=120
      npz=np
       kpp=kp+npz-1
       IF(kpp .GT. 240) THEN
         npz=npz-(kpp-maxchar)
         kpp=maxchar
       ENDIF
       IF(jc .EQ. 2 .OR. jc .EQ. 4) chtemp2=choutput
       IF(jc .EQ. 1 .OR. JC .EQ. 2) THEN
        IF(npz == 0) THEN
!    we didn't give count, so trim spaces, then tally length, truncate
!    if necessary
          npn=LEN_TRIM(chinput)
	  kpp=kp+npn-1
         IF(kpp > maxchar) THEN
           npz=npz-(kpp-maxchar)
           kpp=maxchar
         ENDIF
	ELSE
!  if we specify a length, accept it with truncation if necessary.
	  npn=npz
	  IF (npn > maxchar) npn=maxinp
        ENDIF
!     Blank the output string and load it with npn characters from the
!     leading positions of the input string	
        DO  jp=1,maxinp
        chtemp(jp:jp)=' '
        END DO
        chtemp(1:npn)=chinput(1:npn)
          choutput(kp:kpp)=chinput(1:npn)
       IF(jc .EQ. 2 .AND. kpp .LT. maxchar) THEN
!    Copy the rest of the input string into the output string
          kpp=kpp+1
          DO  kpx=kpp,maxchar
             kpy=kp+kpx-kpp
	     IF(kpy < maxchar) THEN	   
                 choutput(kpx:kpx)=chtemp2(kpy:kpy)
	     ENDIF
          END DO
       ENDIF
!   calculate the new string length and the next non-blank position.
       nlen=LEN_TRIM(choutput)
       knext=kpp+1
       RETURN
      ENDIF
      IF(npz .GT. 7) THEN
        PRINT 101,npz
 101    FORMAT(' subroutine mkstring only handles 7 digits ',I5)
        STOP
      ENDIF
!          WRITE THE INTEGER INTO A STRING VARIABLE THEN SELECT THE 
!      RIGHTMOST NP CHARACTERS. INSERT IT INTO CHOUTPUT
       WRITE (chntemp,91) jv
  91   FORMAT(I7.7)
!   np is the string length to fill with leading zeros if necessary
!    the subroutine can handle up to 8 digits. jc1 points to the 
!    character before the first one to copy, jcz is the position 
!    in the output string running from 1-np characters.
       jc1=8-npz
       DO  jcx=jc1,7
         jcz=jcx-jc1+1
         chnumber(jcz:jcz)=chntemp(jcx:jcx)
       END DO
       choutput(kp:kpp)=chnumber(1:npz)
!   the result is stuffed into the output string, then
!    depending on the input option, the remaining part
!     of the input string is copied, (thereby appending) 
       IF(jc .EQ. 4 .AND. kpp .LT. maxchar) THEN
          kpp=kpp+1
          DO  kpx=kpp,maxchar
	    kpy=kp+kpx-kpp 
            choutput(kpx:kpx)=chtemp2(kpy:kpy)
          END DO
       ENDIF
       nlen=LEN_TRIM(choutput)
       knext=kpp+1
      RETURN
      END SUBROUTINE MKSTRING     
!---------------------------------------------------------------------------------
      SUBROUTINE EHAND(nu,jread,nerr)
!***********************************************************************
!   SUBROUTINE     EHAND                                               *
!----------------------------------------------------------------------*
! LANGUAGE    FORTRAN 90                                               *
!----------------------------------------------------------------------*
! MACHINE     linux                                                    *
!----------------------------------------------------------------------*
! PURPOSE:      A SIMPLE ERROR HANDLING ROUTINE THAT STOPS THE         *
!    PROGRAM IF THERE IS A CONTROL CONSTANT PROBLEM.                   *
!***********************************************************************    
      PRINT 91,nu,jread,nerr
  91  FORMAT('Reading problems on unit ',I5,' read# ',I5,' nerr= ',I5)
      PRINT *,'STOP in module getfiles'
      STOP
      END SUBROUTINE EHAND
END MODULE Fileops

