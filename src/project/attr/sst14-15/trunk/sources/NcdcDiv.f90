MODULE NcdcDiv
     USE ControlConstants, ONLY: ndcd,jprint,rmiss ,ndm,ndfd,ncdcconus,jyncdc1,   &
           jyak1   
IMPLICIT NONE
SAVE
! ***********************************************************************
!    MODULE NcdcDiv                                                     *
!    This is a utility to work with NCDC data, It includes Reading,     *
!    writing and conversion routines.  Also dictionaries.   This module *
!    deals with division data itself.  For Division-to-grid see module  *
!    Fdops.f90                                                          *
!    UNGER 2014                                                         *
!-----------------------------------------------------------------------*
!   GLOBAL VARIABLES                                                    *
!     FROM MODULE ControlConstants                                      *
!      ncdc,ncfd = Climate and Forecast division array dimensions       *
!      rmiss = Missing value indicator.                                 *
!     frmtcd = format strings for the NCDC temp and precip .txt files   *
!    rlogzero -  Value given to trace or zero precip amounts in         *
!                logarithmic transformations                            *
!     rmisst, rmissp - Missing value indicators for T and P             *
!-----------------------------------------------------------------------*
!    CONTAINS SUBROUTINES                                               *
!    ADJCD, ADJCDP,CHANGEMISSING, CPYCDDATA,FCCONVERT,FDCD, RDCDDATA,   *
!    RDCALIBQ, RDCDFDTRAN,WRTCDDATA                                     *
! ***********************************************************************
     CHARACTER(len=8), DIMENSION(2) :: frmtcd
     INTEGER,DIMENSION(ndcd) :: ireg
     REAL,DIMENSION(ndcd) :: frak
     REAL,DIMENSION(2,ndcd,12,2) :: tccd1,tccd2,breg
     REAL,DIMENSION(ndcd,12,2) :: rccd
     REAL, DIMENSION(2) :: rmiscd
     CHARACTER(len=5) :: chhead
     REAL, DIMENSION(:,:,:), ALLOCATABLE :: vncdc
 REAL :: rlogzero
CONTAINS
! -----------------------------------------------------------------------------*   
!* **********************************************************************
!*    SUBROUTINE  ALLOCATENCDCV: Dynamically allocates the arrays needed*
!       for programs that read NCDC by-division historic data.          *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Dynamic allocation call                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!*     VARIABLES FROM CALL                                              * 
!*       jy1,jy2 = first and last years to include in a local array     *
!*     VARIABLES FROM ControlConstants                                  *
!*       ndcd = Number of NDCD climate divisions                        *
!*       ndm  = Number of months  = 12                                  *
!* ---------------------------------------------------------------------*
 
      SUBROUTINE ALLOCATENCDCV(jy1,jy2)
      INTEGER :: jy1,jy2,ndimy
      ndimy=jy2-jy1+1
!      I would prefer vncdc(ndcd,ndm,jy1:jy2) but dynamic allocation 
!         doesn't seem to work with that construct
      ALLOCATE ( vncdc(ndcd,ndm,ndimy))
      RETURN
      END SUBROUTINE ALLOCATENCDCV
! -----------------------------------------------------------------------------*   
      SUBROUTINE ASSIGNNCDC
!* **********************************************************************
!*    SUBROUTINE  ASSIGNNCDC: Assigns constants needed by the module    *
!       for programs that read NCDC by-division historic data.          *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Assigns constants                                        *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES:                                                          *
!*     VARIABLES FROM LOCAL MODULE                                      *
!*      frmtcd = holds the formats for the cpc formatted data, t and p  *
!*      rlogzero = holds the log transformation value used for zero amts*
!*      rmisscd = holds missing value indicators on cpc archive         *
!* ---------------------------------------------------------------------*
     frmtcd(1)='(12F6.1)'
     frmtcd(2)='(12F6.2)'
     rlogzero = -4.5
     rmiscd(1) = -99.9
     rmiscd(2)=-9.99
      END SUBROUTINE ASSIGNNCDC
! -----------------------------------------------------------------------------*       
      SUBROUTINE ADJCD(cd,rcd,jm,ivar)
      USE ControlConstants
!* **********************************************************************
!*    SUBROUTINE ADJCD:  Regression based bias correction               *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Performs bias correction of ncdc fds                     *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES                                                    *
!       cd() = input array of original values                           *
!       ivar = Variable for element , 1 = T 2= P                        *
!     VARIABLES FROM MODULE ControlConstants                            *
!     ndcd  = dimension of climate divisions (usually 344)              *
!     rmiss = Missing Value indicator                                   *
!*   OUTPUT VARIABLES IN CALL                                           *
!     rcd - Regression output of climate divisions                      *
!    VARIABLES FROM LOCAL MODULE                                        *
!      breg(var,cd,month) = Array of regression coefficients.           *
!    INTERNAL VARIABLES                                                 *
!    jd = loop                                                          *
!  ireg(i) = holds the forecast (102) division number for Clim. div. i  *
!  frak(i) = holds the weight for division number ireg for Clim div i   *
!   nerr    = 0 good read, 1 end of file 2 read error                   *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2014                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      IMPLICIT NONE
      INTEGER :: jd,ivar,jm
      REAL, DIMENSION(ndcd) :: rcd,cd
      DO jd=1,ncdcconus
        IF(cd(jd) .GT. rmiscd(ivar)) THEN
            IF(jprint > 3) print *,' adjustment coeff. ',jd,jm,ivar,cd(jd),breg(1,jd,jm,ivar),breg(2,jd,jm,ivar)
           rcd(jd)=breg(1,jd,jm,ivar)+breg(2,jd,jm,ivar)*cd(jd)
           IF(ivar == 2) THEN
               IF(rcd(jd) < 0.) rcd(jd)=0.
           ENDIF
        ELSE
           rcd(jd)=rmiscd(ivar)
        ENDIF
     END DO
     RETURN
     END SUBROUTINE ADJCD
      SUBROUTINE ADJCDP(cd,rcd,jm,ivar)
      USE ControlConstants
!* **********************************************************************
!*    SUBROUTINE ADJCD:  Regression based bias correction               *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Performs bias correction of ncdc fds  Log Transformation *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES                                                    *
!       cd() = input array of original values                           *
!       ivar = Variable for element , 1 = T 2= P                        *
!     VARIABLES FROM MODULE ControlConstants                            *
!     ndcd  = dimension of climate divisions (usually 344)              *
!     rmiss = Missing Value indicator                                   *
!*   OUTPUT VARIABLES IN CALL                                           *
!     rcd - Regression output of climate divisions                      *
!    VARIABLES FROM LOCAL MODULE                                        *
!      breg(var,cd,month) = Array of regression coefficients.           *
!     rlogzero = log value to substute for zero or trace amounts        *
!    INTERNAL VARIABLES                                                 *
!    jd = loop                                                          *
!    gcd = Log of variable, zero accounted for                          *
!    grcd = Regression corrected log                                    *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2014                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      IMPLICIT NONE
      INTEGER :: jd,ivar,jm
      REAL, DIMENSION(ndcd) :: rcd,cd
      REAL ::gcd,grcd
      DO jd=1,ncdcconus         
        IF(cd(jd) .GT. rmiscd(ivar)) THEN
           IF(cd(jd) == 0.) THEN
              gcd=rlogzero
           ELSE
              gcd=LOG(cd(jd))
           ENDIF
           grcd=breg(1,jd,jm,ivar)+breg(2,jd,jm,ivar)*gcd
           IF(grcd .LT. rlogzero) THEN
              rcd(jd)=0.
           ELSE
              rcd(jd)=EXP(grcd)
           END IF
        ELSE
           rcd(jd)=rmiscd(ivar)
        ENDIF
     END DO
     RETURN
     END SUBROUTINE ADJCDP
! -----------------------------------------------------------------------------*       
      SUBROUTINE CHANGEMISSING(x,rmis1,ndsta)
!* **********************************************************************
!*    SUBROUTINE CHANGEMISSING                                          *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 95                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE: CHANGES MISSING VALUE INDICATOR FROM RMIS1 TO RMIS2        *
!*   all are large magnitude negative numbers                           *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!* FROM CALL                                                            *
!*  INPUT                                                               *
!*    x() = input array (and OUTPUT)                                    *
!*   rmis1 = Missing indicator on input array (Large negative)          *
!*   rmis2 = Missing indicator on output array (Large negative)         *
!*   ndsta = Dimension of x                                             *
!*                                                                      *
!*  INTERNAL VARIABLES                                                  *
!    js  - loop for stations (divisions)                                *
!*                                                                      *
!   VARIABLES FROM MODULE ControlConstants                              *
!    rmiss = Missing indicator used in program unit using ControlCon.   *
!* **********************************************************************
      IMPLICIT NONE
      INTEGER :: ndsta,js
      REAL, DIMENSION(ndsta) :: x
      REAL :: rmis1
      DO js=1,ndsta
        IF (x(js) < rmis1+.1) x(js)=rmiss
      END DO
      RETURN
      END SUBROUTINE CHANGEMISSING
! -----------------------------------------------------------------------------*       
      SUBROUTINE CHANGEMISSINGBACK(x,rmis1,ndsta)
!* **********************************************************************
!*    SUBROUTINE CHANGEMISSING                                          *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 95                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE: CHANGES MISSING VALUE INDICATOR FROM RMIS1 TO RMIS2        *
!*   all are large magnitude negative numbers                           *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!* FROM CALL                                                            *
!*  INPUT                                                               *
!*    x() = input array (and OUTPUT)                                    *
!*   rmis1 = Missing indicator on input array (Large negative)          *
!*   rmis2 = Missing indicator on output array (Large negative)         *
!*   ndsta = Dimension of x                                             *
!*                                                                      *
!*  INTERNAL VARIABLES                                                  *
!    js  - loop for stations (divisions)                                *
!*                                                                      *
!   VARIABLES FROM MODULE ControlConstants                              *
!    rmiss = Missing indicator used in program unit using ControlCon.   *
!* **********************************************************************
      IMPLICIT NONE
      INTEGER :: ndsta,js
      REAL, DIMENSION(ndsta) :: x
      REAL :: rmis1
      DO js=1,ndsta
        IF (x(js) < rmiss+.001) x(js)=rmis1
      END DO
      RETURN
      END SUBROUTINE CHANGEMISSINGBACK
! -----------------------------------------------------------------------------*       
      SUBROUTINE CPYCDDATA(nu,ky1,km1,ky2,km2,jsta,kvar,nerr,ndsta)
      USE Calops
!* **********************************************************************
!*    SUBROUTINE CPYCDDATA(nu,ky1,km1,ky2,km2,nvar,nerr,ndsta)          *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 95                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE: Copies temperature or precip field to an ASCII dataset     *
!*       (usually the NCDC 102 or 344 Division data)                    *
!* ---------------------------------------------------------------------*
!*  FILES USED  FD or CD files are opened elsewhere and passed into the *
!*       routine.  see description of climate division ASCII datasets   *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES  nu = unit number assigned to data file.           *
!*            ky1 km1 = First year and month (1=jan etc) of data to copy*
!*            ky1 km1 =  Last year and month (1=jan etc) of data to copy*
!*                kvar  = 1 temperature, 2 for precipitation            *
!*               ndsta = dimensions of x (x can be overdimensioned)     *
!*   OUTPUT VARIABLES  nerr = Error code returned.                      *
!*                jsta = Actual number of stations on files being       *
!*                       coppied, may be lower than ndsta               *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2005                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      INTEGER :: nu,ky1,km1,ky2,km2,kvar,nerr,ndsta,jhx,nup,kyy2mm
      INTEGER :: jyr1,jm1,jcount,jy,jm,jh,jsta,jflag,js,jyymm,kyymm,jyr,jmm,jmf,jml, &
         kflag,jyr2,jm2,jvar,jhalf,kyymm2,jsta2
      REAL,DIMENSION(ndsta) :: x
      REAL :: rmiss
      nerr=0
      kyymm=ky1*100+km1
      kyymm2=ky2*100+km2
      print *,'ky1 ',ky1
      IF(ky1== 0) THEN
!          There is nothing to copy so return This is typically used for
!          a single-month output perhaps with a dummy dataset for input
         RETURN
      END IF
      IF(kyymm2 < kyymm ) THEN
!         The new data begins before the first date on the old dataset
!         so dont copy.  This typically happens when the first date to
!         process is the first date on the output file, so the entire 
!         output file is created from scratch.
          RETURN
      END IF
       
      jyr1=ky1
      jm1=km1
      nup=nu+1
      jvar=kvar
      jhalf=1
      IF(jvar > 2) THEN
        jvar=kvar-2
        jhalf=2
      ENDIF
      IF(jprint > 2) PRINT *,'Copy data from ',ky1,km1,' To ',ky2,km2
      DO jcount=1,10000
!     Limit to 10000 tries just in case iostat doesnt work for some reason. 
!     the rather strange jsta2 thing below is due to a weird FORTRAN error that 
!     caused jsta to not be read in for some reason that I cant figure out.
!      this statement works, so go with it.  I suspect it is some kind of bug in
!      FORTRAN modules.  I've seen modules do unexplainable things before. 
       READ(nu,91,iostat=nerr)jy,jm,jh,jsta2,jflag
   91   FORMAT(5I4)
         jsta=jsta2
        IF(nerr /= 0) THEN 
            PRINT *,'Reading Problem on unit ',nu,' dates read and wanted ', &
                 jsta,jy,jm, ky1,km1, ' iostat = ',nerr
            RETURN
        ENDIF
        READ(nu,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
        IF(ky1 == 0) THEN
!           there is nothing to copy return.  This is used typically for 
!           a single-month output, perhaps with a dummy dataset for input
!           This and the next test is placed after the first record is read
!           because frequently the number of stations is set by jsta in the 
!           read above...
            PRINT *, ' No Data will be copied. ',nu,jsta,jvar  
            RETURN
        END IF
        IF(kyymm2 <= kyymm ) THEN
!           The new data begins before the first date on the old dataset
!           so dont copy.  This typically happens when the first date to
!           process is the first date on the output file, so the entire 
!           output file is created from scratch.
            RETURN
        END IF
        IF(nerr /= 0) THEN
            PRINT *,'Reading Problem on unit ',nu,' dates read and wanted ', &
                 jy,jm, ky1,km1,jsta, ' iostat = ',nerr
            RETURN
        ENDIF
        jyymm=jy*100+jm
        IF(ky1 < 0) THEN
!   If ky1 < 0 then we are asking the data be copied from the first record
!    onward.   Set loops accordingly
         jyr1=jy
         jm1=jm
         kyymm=jyymm
        END IF
         IF((kyymm - jyymm) > 0 ) THEN
            print *, ' ERROR: date passed when looking for stations ',nu,jyymm,kyymm
            nerr=-1000
            RETURN
         ELSEIF ( (kyymm - jyymm) == 0 ) THEN
            EXIT
         ENDIF
      ENDDO
      WRITE(nup,91,iostat=nerr)jy,jm,jh,jsta,jflag
      IF(nerr /= 0) THEN
                print *, ' ERROR: WRITING  ',nu,jy,jm,jh,jsta,jflag       
      END IF     
      WRITE(nup,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
      IF(nerr /= 0) THEN
                print *, ' ERROR: WRITING  ',nu,jy,jm,jh,jsta,jflag       
      END IF  
      IF(jhalf > 1 ) THEN
!      Finish copy of this month if jhalf>1
            DO jhx=2,jhalf
              READ(nu,91,iostat=nerr)jy,jm,jh,jsta,jflag
              READ(nu,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
              WRITE(nup,91,iostat=nerr)jy,jm,jh,jsta,jflag
              WRITE(nup,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
            END DO
       END IF
!    We copied the first month, so increment month and copy the rest
        CALL ADDYR(jyr1,jm1,1,jyr2,jm2) 
        DO jyr=jyr2,ky2
          CALL MONTHLOOP(jyr,jyr2,jm2,ky2,km2,jmf,jml)
          DO jmm=jmf,jml
            DO jhx=1,jhalf
              READ(nu,91,iostat=nerr)jy,jm,jh,jsta,jflag
        IF(jprint > 3) print *,'COPY',jy,jm,jh,jsta,jflag,jvar
              IF(nerr /= 0) THEN
                 PRINT *,'Reading Problem on unit ',nu,' dates read ', &
                   jy,jm,jy, ' iostat = ',nerr
                 RETURN
              END IF 
              READ(nu,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
              IF(nerr /= 0) THEN
                 PRINT *,'Reading Problem on unit ',nu,' dates read ', jy,jm
                 RETURN
              END IF 
              WRITE(nup,91,iostat=nerr)jy,jm,jh,jsta,jflag
              IF(nerr /= 0) THEN
                  PRINT *,'Write Problem on unit ',nu,' dates read ', &
                    jy,jm,jy, ' iostat = ',nerr
                  RETURN
              END IF  
              WRITE(nup,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
              IF(nerr /= 0) THEN
                 print *, ' ERROR: WRITING  ',nu,jy,jm,jh,jsta,jflag       
                 RETURN
              END IF 
           END DO ! jhx
         END DO ! jmm
      END DO    ! jyr
      RETURN
      END SUBROUTINE CPYCDDATA
! -----------------------------------------------------------------------------*       
      SUBROUTINE FCCONVERT(x,y,rmisg,junit)
!* **********************************************************************
!*    SUBROUTINE FCCONVERT(x,y,rmiss,junit)                             *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   LINEAR CONVERTER FOR COMMON CONVERSIONS                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES   y = variable to convert                          *
!*                     rmiss = Missing value indicator (most negative)  *
!*                     junit = flag  1=DegF to C, 2=Inches to mm        *
!*   OUTPUT VARIABLES  x = converted variable                           *
!*   LOCAL VARIABLES   f(), b(), conversion constants x=yf +b           *
!          LOCAL VARIABLES ARE HARD WIRED CONVERSIONS, CAN BE ADDED TO  *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2008                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
     INTEGER :: JUNIT 
     REAL :: x,y,rmisg
      REAL, DIMENSION(2) :: f,b
      DATA F /.555556,25.4/
      DATA B /-17.777778,0./
      IF(y .GT. rmisg+.01) THEN
	 x=y*f(junit)+b(junit)
      ELSE
	 x=rmisg
      ENDIF
      RETURN
      END SUBROUTINE FCCONVERT
! -----------------------------------------------------------------------------*       
      SUBROUTINE FDCD(fd,cd,ncdcnum)
      USE ControlConstants
!* **********************************************************************
!*    SUBROUTINE FDCD(fd,cd)                                            *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   CALCULATES THE 102 FORECAST DIVISION FROM THE 344 CDS    *
!*      FROM NCDC.  LOOPING IS DONE ON THE OUTSIDE. THIS SIMPLETON      *
!*      SUBROUTINE IS USED TO REDUCE THE CLUTTERING MISSING VALUE CHECK.*
!*    SUM ARRAY MUST BE MANAGED IN CALLING ROUTINE.                     *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES IN CALL:                                           *
!           cd,climate division value                                   *
!           ncdcnum = number of ncdc climate divisions to process       *
!                     344 for conus, 357 for CONUS+Alaska               *    
!*   OUTPUT VARIABLES IN CALL:                                          *
!   fd  = Forecast Division                                             *
!    VARIABLES FROM LOCAL MODULE                                        *
!  ireg(i) = holds the forecast (102) division number for Clim. div. i  *
!  frak(i) = holds the weight for division number ireg for Clim div i   *
!                                                                       *
!!*        frak = The fraction that this cd contributes to the cd, the  *
!*                correct division is passed.                           *
!*          rmiss = missing value (big negative) indicator) if any      *
!*         previous division is missing, the whole thing is.            *
!*   INPUT/OUTPUT VARIABLES  fd forecast division value (accumulatin sum*
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2008                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
     IMPLICIT NONE 
      REAL, DIMENSION(ndcd) :: cd
      REAL, DIMENSION(NDFD) :: fd
      INTEGER :: jfd,js,ncdcnum
      fd=0
      DO js = 1,ncdcnum
        jfd=ireg(js)
        IF(cd(js) .GT. rmiss .OR. fd(jfd) .EQ. rmiss) THEN
	     fd(jfd)=fd(jfd)+cd(js)*frak(js)
             print *,'fdcd',jfd,js,fd(jfd),cd(js),frak(js)
        ELSE
             fd(jfd)=rmiss
        ENDIF
      END DO
      RETURN
      END SUBROUTINE FDCD
! -----------------------------------------------------------------------------*       
      SUBROUTINE RDCALIBQ(nu,nerr)
!* **********************************************************************
!*    SUBROUTINE RDCDFDTRAN:   Reads the bias correction for old and new*
!       ncdc climate division data                                      *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Reading subroutine for bias correction of ncdc fds       *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES                                                    *
!       NU = unit number of input file                                  *
!     ndcd  = dimension of climate divisions (usually 344)              *
!*   OUTPUT VARIABLES                                                   *
!  ireg(i) = holds the forecast (102) division number for Clim. div. i  *
!  frak(i) = holds the weight for division number ireg for Clim div i   *
!   nerr    = 0 good read, 1 end of file 2 read error                   *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2006                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      IMPLICIT NONE 
      INTEGER nu,nerr,jm,jd,km,kd,nup
      nup=nu+1
      READ(nu,91,iostat=nerr)chhead
      READ(nu,91,iostat=nerr)chhead
      READ(nup,91,iostat=nerr)chhead
      READ(nup,91,iostat=nerr)chhead
      IF(nerr /= 0) RETURN
  91  format(A5)
      DO jm=1,12
        DO jd= 1, ncdcconus
           READ(nu,93,iostat=nerr) km,kd,tccd1(1,jd,jm,1),tccd1(2,jd,jm,1),  &
                tccd2(1,jd,jm,1),tccd2(2,jd,jm,1),rccd(jd,jm,1),breg(1,jd,jm,1),breg(2,jd,jm,1)
           IF(nerr /= 0) THEN
               PRINT *,'Error reading unit ,', nu,' nerr= ',nerr
               RETURN
           ENDIF
           READ(nup,93) km,kd,tccd1(1,jd,jm,2),tccd1(2,jd,jm,2),  &
                  tccd2(1,jd,jm,2),tccd2(2,jd,jm,2),rccd(jd,jm,2),breg(1,jd,jm,2),breg(2,jd,jm,2)
           IF(nerr /= 0) THEN
              PRINT *,'Error reading unit ,', nu,' nerr= ',nerr
              RETURN
          ENDIF
  93      FORMAT(2I5,2X,2(2X,F7.2,F7.3),2X,F6.3,2X,2(F8.3))
        END DO
      END DO
      RETURN
      END SUBROUTINE RDCALIBQ
! -----------------------------------------------------------------------------*       
      SUBROUTINE RDCDFDTRAN(nu,nerr)
!* **********************************************************************
!*    SUBROUTINE RDCDFDTRAN:   Reads the translation key to go from ncdc*
!*                    climate division data to CPC forecast divisions   *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 77                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Reading subroutine for translation data                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES                                                    *
!       NU = unit number of input file                                  *
!     ndcd  = dimension of climate divisions (usually 344)              *
!*   OUTPUT VARIABLES                                                   *
!  ireg(i) = holds the forecast (102) division number for Clim. div. i  *
!  frak(i) = holds the weight for division number ireg for Clim div i   *
!   nerr    = 0 good read, 1 end of file 2 read error                   *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2006                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      IMPLICIT NONE 
      INTEGER nu,nerr,i
      READ(nu,91,iostat=nerr)chhead
      IF(nerr /= 0) RETURN
  91  format(A5)
      DO  i= 1, ndcd
        READ (nu,92,iostat=nerr) ireg(i),frak(i)
  92    FORMAT(36X,I6,F7.3)
      END DO
      RETURN
      END SUBROUTINE RDCDFDTRAN
! -----------------------------------------------------------------------------*       
      SUBROUTINE RDCPCGRID(nu,cdt,cdp,ndaymin,nerr)
!* **********************************************************************
!*    SUBROUTINE RDCDFDTRAN:                                            * 
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE: Reads the cpc grid estimate of the NCDC                    *
!*          344 climate division data in the conus                      *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES FROM ARGUMENTS:                                           *
!*   INPUT                                                              *
!       nu = unit number of input file                                  *
!    ndaymin = Minimum number of days to use monthly means.             *
!    VARIABLES FROM MODULE ControlConstants                             *
!     ndcd  = dimension of climate divisions (usually 344)              *
!     jprint = Printing control                                         *
!*   OUTPUT VARIABLES  IN CALL                                          *
!      cdp,cdt = Array of precip and temperature cd obs.                *
!   nerr    = 0 good read, /= 0 indicates  problems                     *
!     LOCAL VARIABLES                                                   *
!     kst,kdv = State and division numbers of NCDC data                 *
!    ndp,ndt,ndh = number of precip, hads, and no hads temp obs         *
!     cdth = Hads data temperatures                                     *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2006                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      IMPLICIT NONE 
      INTEGER :: nu,nerr,jhead,kst,kdv,ndp,ndt,ndh,i,ndaymin
      REAL :: cdth
      REAL, DIMENSION(ndcd) :: cdp,cdt
      IF(jprint > 2) print *, nu,ndcd
      DO jhead=1,5
        READ(nu,91,iostat=nerr)chhead
        IF(nerr /= 0) RETURN
      END DO
  91  format(A5)
      DO  i= 1, ncdcconus
        READ (nu,92,iostat=nerr) kst,kdv,cdp(i),cdth,cdt(i),ndp,ndt,ndh
        IF (jprint > 3) PRINT *,' read estimate ',i,kst,kdv,cdp(i),cdth,cdt(i),ndp,ndt,ndh
        IF(nerr /= 0) THEN
             PRINT *,' Error in RDCPCGRID reading cpc estimates',i,nerr
             RETURN
        END IF
  92    FORMAT(I4,I2,3F10.2,3I7)
      END DO ! i
!      Check one of the days, assuming that if one is bad all are.
        IF( ndp < ndaymin) THEN
           nerr= ndaymin
        ENDIF
      RETURN
      END SUBROUTINE RDCPCGRID
! -----------------------------------------------------------------------------*       
     SUBROUTINE RDCDDATA(nu,x,ky,km,kh,jsta,kyymm,kvar,jflag,nerr,ndsta)
!***********************************************************************
!*   SUBROUTINE RDCDDATA(nu,x,ky,km,kh,kyymm,kvar,jflag,ndsta)         *
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!* PURPOSE: Reads a temperature or precip field from the ASCII datasets*
!*      usually the NCDC 102 or 344 Division data                      *
!*---------------------------------------------------------------------*
!* FILES USED  FD or CD files are opened elsewhere and passed into the *
!*      routine.  see description of climate division ASCII datasets   *
!*---------------------------------------------------------------------*
!* SUBROUTINES USED: NONE                                              *
!*---------------------------------------------------------------------*
!* CALL ARGUMENTS:                                                     *
!*  INPUT VARIABLES  nu = unit number assigned to data file.           *
!*               ky = year requested, if negative grab the next record *
!*               km = Month number  1 JAN, 2 FEB 3=March 12=Dec ETC.   *
!*               kh = 1 FIRST 15 DAYS  2= REMAINDER, 3=FULL MONTH      *
!*               kvar  = 1 temperature, 2 for precipitation            *
!*                   3= Temperature half-month, 4 = Precip half-month  *
!*  OUTPUT VARIABLES  kyymm = Year and month read in YYYYMM format     *
!*                This field contains a negative number for a bad call *
!*            jflag = data flag written on data 0 for ncdc final       *
!                     1 for ncdc prelim, 2 for cpc prelim,             *
!*                    3= grid-based estimates, higher, rough estimates *
!*             jsta = Actual number of stations on files.  May be lower*
!*                    than the dimensions,ndsta.                       *
!*               x  = output data array. (Temps or Precip              *
!*---------------------------------------------------------------------*
!* AUTHOR:   UNGER, 2005                                               *
!*---------------------------------------------------------------------*
!* MODIFICATIONS                                                       *
!*---------------------------------------------------------------------*
      IMPLICIT NONE
      INTEGER :: nu,ky,km,kh,kyymm,kvar,jflag,nerr,ndsta
      INTEGER :: khx,jcount,jy,jm,jh,jsta,js,jyymm,jvar,kgroup
      REAL,DIMENSION(ndsta) :: x
      nerr=0
      kyymm=ky*100+km
      khx=kh
      jvar=kvar
      kgroup=1
      IF(kvar > 2) THEN
         jvar=kvar-2
         kgroup=2
      END IF
      DO jcount=1,10000        
!     Limit to 10000 tries just in case iostat doesnt work for some reason. 
        READ(nu,91,iostat=nerr)jy,jm,jh,jsta,jflag
        IF(jprint > 3) print *,jy,jm,jh,jsta,jflag,kvar,kgroup,kyymm
   91   FORMAT(5I4)
        IF(nerr /= 0) THEN 
            PRINT *,'Header Reading Problem on unit ',nu,' dates read and wanted ', &
                 jy,jm, ky,km,kh, ' iostat = ',nerr
            EXIT
        ENDIF
        READ(nu,frmtcd(jvar),iostat=nerr)(x(js),js=1,jsta)
        IF(nerr /= 0) THEN
            PRINT *,'Data Reading Problem on unit ',nu,' dates read and wanted ', &
                 kvar,frmtcd(jvar), jsta,ndsta,' iostat = ',nerr
            EXIT
        ENDIF
        jyymm=jy*100+jm
        IF(ky .LT. 0) THEN
!   If call asks for next record load test variable to return this one
!     note this used an old computed goto test branching to the 
!     first number if negative, second if zero, and third if positive
             kyymm=jyymm
             khx=jh
         ENDIF
!       IF(kyymm - jyymm) 820,110,100
!  110   IF(khx -jh) 820,120,100
!  These nice, easy to follow statement being replaced for f95 reasons. 
!  Currently in vogue IF..THEN...ELSE , 100 used to be the read statement
         IF((kyymm - jyymm) < 0 ) THEN
            print *, ' ERROR: date passed when looking for stations ',nu,jyymm,kyymm
            nerr=99
            EXIT
         ELSEIF ( (kyymm - jyymm) == 0 ) THEN
             IF(kgroup > 1) THEN
                 IF((kh-jh) < 0 ) THEN
                   print *, ' ERROR: half month passed when looking for stations ',nu,jyymm,kyymm,kh,jh
                   nerr=99
                   EXIT
                 ELSEIF((khx-jh) == 0 ) THEN 
                   EXIT
                 ENDIF
             ELSE
                 EXIT
             ENDIF
         ENDIF
      END DO
      IF(jvar == 1) THEN
       CALL CHANGEMISSING(x,rmiscd(1),jsta)
      ELSE
       CALL CHANGEMISSING(x,rmiscd(2),jsta)
      ENDIF
      RETURN
      END SUBROUTINE RDCDDATA
! -----------------------------------------------------------------------------*  
      SUBROUTINE RDNCDCV(nu,jyncdclst,jy1,jy2,jvar,nerr)
!* **********************************************************************
!*    SUBROUTINE RDNCDCV                                                *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 95                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE: Reads NCDC data as provided by NCDC, all years by ordered  *
!          by division, one line per year                               *
!* ---------------------------------------------------------------------*
!  VARIABLES                                                            *
!    VARIABLES IN CALL                                                  *
!      nu - unit number assigned to input file of ncdc data             *
!     jyncdc1 = First year in the NCDC dataset                          *
!     jyncdclst = Last year on NCDC dataset (allows for back dating     *
!     jy1 = First year to retrieve in local array                       *
!     jy2 = Last year to retrieve into local array                      *
!     jvar = 1 temperature, 2 precip                                    *
!     nerr = Error flag of read.                                        *
!    VARIABLES FROM LOCAL MODULE                                        *
!      vncdc() - dynamically allocated array of values.                 *
!    VARIABLES FROM ControlConstant MODULE                              *
!     ndcd = Number of ndcd climate divisions allocated in dimensions   *
!    ncdcconus = Number of Climate Divisions in the lower 48 (344)      *
!     jyncdc1 = first year on NCDC archive                              *
!    jyak1    = First year of Alaskan data in NCDC archive              *
!    VARIABLES IN LOCAL ROUTINE                                         *
!      js,jy,kstate,kdiv,kqq,kyr,jm                                     *
!* ---------------------------------------------------------------------*
      USE ControlConstants
      INTEGER :: jyncdclst,jy1,jy2,nerr,js,jy,kstate,kdiv,kqq,kyr,jm,nu, jyndx,jvar,jyfirst
      REAL,DIMENSION(12) :: v
      REAL,DIMENSION(2) :: rmis
      rmis(1)=-99.9
      rmis(2)=-9.99
      IF(jprint > 2) THEN 
        PRINT *,' In RDNCDC ',ndcd,ncdcconus,jyak1,jyncdc1,jyncdclst
      END IF
      DO js = 1,ndcd
          IF(js > ncdcconus) THEN
             jyfirst=jyak1
          ELSE
             jyfirst=jyncdc1
          ENDIF
          DO jy=jyncdc1,jyncdclst
              jyndx=jy-jy1+1
              IF(jy >= jyfirst) THEN
                 READ( nu,91,iostat=nerr) kstate,kdiv,kqq,kyr,(v(jm),jm=1,12)
  91             FORMAT(3I2,I4,12(F7.2))
                 IF(nerr /= 0) THEN 
                     print *, ' ERROR: reading NCDC data  ',nu,jy,js  
                     RETURN
                 END IF
                 IF(jy < jy1 .OR. jy > jy2) CYCLE
              ELSE
                 IF(jy < jy1 .OR. jy > jy2) CYCLE
                 vncdc(js,:,jyndx)=rmiss
                 CYCLE
              END IF
              DO jm=1,12
                  IF(v(jm) > rmis(jvar)+.01) THEN
                      vncdc(js,jm,jyndx) = v(jm)
                  ELSE
                      vncdc(js,jm,jyndx)=rmiss
                  END IF
              END DO
        END DO
      END DO
      RETURN
      END SUBROUTINE RDNCDCV 
! -----------------------------------------------------------------------------*  
      SUBROUTINE WRTCDDATA(nu,x,ky,km,kh,kvar,ksta,kflag,nerr,ndsta)
!* **********************************************************************
!*    SUBROUTINE WRTCDDATA(nu,x,ky,km,kh,kyymm,nvar,ksta,kflag,ndsta)   *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 95                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE: Writes temperature or precip field to an ASCII dataset     *
!*       (usually the NCDC 102 or 344 Division data)                    *
!* ---------------------------------------------------------------------*
!*  FILES USED  FD or CD files are opened elsewhere and passed into the *
!*       routine.  see description of climate division ASCII datasets   *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  CALL ARGUMENTS:                                                     *
!*   INPUT VARIABLES  nu = unit number assigned to data file.           *
!*                x  = output data array. (Temps or Precip)             *
!*                ky km = year and month (1=jan etc) of data written    *
!*                kh = 1 FIRST 15 DAYS  2= REMAINDER, 3=FULL MONTH      *
!*                kvar  = 1 temperature, 2 for precipitation            *
!*                ksta = number of stations written                     *
!*               kflag = data flag written on output dataset            *
!*               ndsta = dimensions of x (x can be overdimensioned)     *
!*   OUTPUT VARIABLES  kyymm = Year and month written in YYYYMM format  *
!*                 This field contains a negative number for a bad call *
!* ---------------------------------------------------------------------*
!*  AUTHOR:   UNGER, 2005                                               *
!* ---------------------------------------------------------------------*
!*  MODIFICATIONS                                                       *
!* ---------------------------------------------------------------------*
      IMPLICIT NONE
      INTEGER :: nu,ky,km,kh,kyymm,kvar,kflag,nerr,ndsta,ksta,js,jvar
      REAL,DIMENSION(ndsta) :: x
      REAL :: rmiss
      nerr=0
      jvar=kvar
      IF(kvar > 2) THEN
         jvar=kvar-2
      END IF
      kyymm=ky*100+km
      CALL CHANGEMISSINGBACK(x,rmiscd(jvar),ndsta)
      IF(ky .GT. 9000) THEN
         ky=9999
	 km=99
	 IF(jvar .EQ. 1) THEN
	   rmiss=-99.9
	 ELSE
	   rmiss=-9.99
	 ENDIF
	 x=rmiss
      ENDIF
      WRITE(nu,105,iostat=nerr)ky,km,kh,ksta,kflag
 105  FORMAT(5I4)
      IF(nerr /= 0) THEN
                print *, ' ERROR: WRITING HEADER  ',nu,ky,km,kh,ksta,kflag       
      END IF     
       print *,frmtcd(jvar),ksta,x(1),kvar
      WRITE(nu,frmtcd(jvar),iostat=nerr)(x(js),js=1,ksta)
      IF(nerr /= 0) THEN
                print *, ' ERROR: WRITING DATA ',nu,ky,km,kvar,ksta,kflag ,frmtcd(kvar)      
      ENDIF
      RETURN
      END SUBROUTINE WRTCDDATA
END MODULE NCDCDIV  

