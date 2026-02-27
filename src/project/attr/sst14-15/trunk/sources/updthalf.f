!***********************************************************************
!  PROGRAM UPDTHALF.F                                                  *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Reads the updates between the preliminary CPC data and the final  *
!     NCDC data for the full month values, and applies an adjustment   *
!     to the CPC half-month data to keep the two datasets consistent.  *
!----------------------------------------------------------------------*
! USAGE:  Update forecast archive once per month                       *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
!  FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)               *
!  FT 12     CPC HALF-MONTH TEMP. OBSERVATIONS IN BY-MONTH FORMAT      *
!  FT 14     CPC HALF-MONTH PRECIP. OBSERVATIONS IN BY-MONTH FORMAT    *
!  FT 16     CPC/NCDC OLD ESTIMATE OF THE FULL MONTH TEMPS             *            
!  FT 17     REVISED NCDC ESTIMATES OF FULL MONTH MONTH  TEMP          *            
!  FT 18     CPC/NCDC OLD ESTIMATE OF THE FULL MONTH PRECIP            *            
!  FT 19     REVISED NCDC ESTIMATES OF FULL MONTH MONTH PRECIP         *            
!----------------------------------------------------------------------*
! OUTPUT FILES:                                                        *
!  FT 13    OUTPUT CPC TEMP. HALF-MONTH OBSERVATIONS IN BY-MONTH FORMAT*            
!  FT 15    OUTPUT CPC PRECIP.HALF-MONTH PRECIP IN BY-MONTH FORMAT     *
!----------------------------------------------------------------------*
!      MODULES                                                         *
!    ControlConstantsMkcdprelim.f90  - Named ControlConstants          *
!         Contains program driver info                                 *
!     NcdcDiv - NCDC Climate Division Operations.                      *
!     FileOps - File operations                                        *
!    CalOps  - Calander operations                                     *
!----------------------------------------------------------------------*
!   SUBROUTINES USED                                                   *
!   FROM MODULE FileOps                                                *
!    GETFILES                                                          *
!    OPENFILES                                                         *
!   FROM MODULE CalOps                                                 *
!    ADDYR                                                             *
!   FROM MODULE NcdcDiv                                                *
!     CPYCDDATA                                                        *
!     RDCPCGRID                                                        *
!     WTCDDATA                                                         *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (344)                *
!   jyncdc1 = First year on the NCDC data archive                      *
!  FROM LOCAL MODULE                                                   *
!      kvn = Flag for number of output fields per month (one).         *
!      ndaymin = minimum number of days in input obs to use            *
!       nu = Unit Numbers for input files                              *
!      nut,nup = Unit numbers for temp and precip.  Nut=input,         *
!                 nut+1=output long                                    *
!      nfile = number of files to open                                 *
!      nerr= Error Flag                                                *
!     kh = monthly partition flag  3 for complete months               *
!     jflagt,jflagp = Data Flags for temp and precip                   *
!      jmncdc1 =First year and month on half-month NCDC archive        *
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jym1,jmm1 = Last Archive data prior to append, = jmc-2           *
!     jyr, jm = loop variables for year and month                      *
!    cdt,cdp  = Data for the most recent full month (Temp and precip)  *
!    cdt1,cdp1 = New data for the first half of the month              *
!    cdt2,cdp2 = Computed data for the Second half of the month        *
!***********************************************************************
USE ControlConstants
USE NcdcDiv
USE FileOps
USE CalOps
IMPLICIT NONE
     REAL, DIMENSION(ndfd) :: cdt,cdp,cdtn,cdpn,cdt1,cdt2,cdp1,cdp2,bc
     INTEGER :: nu,jmncdc1,jys,jms,jyc,jmc,jdc,jycm,jmcm,jmmx, &
            jym1,jmm1,jmx1,jmx2,jflag,kyymm,jh,jyr,jm,nerr,jm1,js,kvn,nfile
      INTEGER :: jnumsta12,jnumsta14,jnumsta16,jnumsta17,jnumsta18,jnumsta19
     REAL :: rmissp
      nu=10
!       GET INFORMATION FROM CONTROL FILE, OPEN FILES AND READ CONTROL INFO.
      CALL GETFILES(nu,nfile)
      kvn=1
      jh=1
      rmiss=-9999.
      rmissp=rmiss+.01
      PRINT * ,' open the files ',nu
      nu=11
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
      READ(10,91) jprint
      READ(10,91) jyncdc1,jmncdc1
      READ(10,91) jys,jms
      READ(11,92) jyc,jmc,jdc
 91   FORMAT(2I5)
 92   FORMAT(I5,I3,I3)
      jm1=1
!       Assign constants
      CALL ASSIGNNCDC
!     set the date of the last month of data, and the month before that
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
!     Sets defaults.  jys = 0 indicates that a single month of new data
!     will be examined.
!              jys < 0 produces a revision for the most recent -jys
!               years, and jys> 0 process all data from jys,jms to 
!               jycm,jmcm.  
!              Usually, the last 1 year is examined for NCDC updates.
!             jys=-1
      IF(jys == 0) THEN 
         jys=jycm
         jms=jmcm
      ELSEIF (jys < 0 ) THEN
         jmmx=jys*12
         CALL ADDYR(jyc,jmc,jmmx,jys,jms)
      ENDIF
!     Copy data from the start of the data to the month prior to jys,jms
      CALL ADDYR(jys,jms,-1,jym1,jmm1)
      CALL CPYCDDATA(12,jyncdc1,jmncdc1,jym1,jmm1,jnumsta12,3,nerr,ndfd)
      CALL CPYCDDATA(14,jyncdc1,jmncdc1,jym1,jmm1,4,jnumsta14,nerr,ndfd)
!    LOOP THROUGH THE REMAINDER OF THE MONTHS, MONTHLOOP CALCULATES THE
!     APPROPRIATE MONTHLY LIMITS FOR YEAR JYR.
      DO jyr=jys,jycm
         CALL MONTHLOOP(jyr,jys,jms,jycm,jmcm,jmx1,jmx2)
         DO jm=jmx1,jmx2
!     Read old cd102 file
            CALL RDCDDATA(16,cdt ,jyr,jm,jh,jnumsta16,kyymm,1,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',jyr,jm,nerr
                 STOP
             ENDIF
!    Read new cd102 file , compute difference, and add to each half-month 
!    Changes in the NCDC monthly means are distributed evenly to each 
!     half-month.
            CALL RDCDDATA(17,cdtn ,jyr,jm,jh,jnumsta17,kyymm,1,jflag,nerr,ndfd)
            bc=cdtn-cdt
            WHERE (cdtn < rmissp) bc=rmiss
            WHERE (cdt  < rmissp) bc=rmiss
         
            CALL RDCDDATA(12,cdt1 ,jyr,jm,1,jnumsta12,kyymm,3,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',jyr,jm,nerr
                 STOP
             ENDIF
            CALL RDCDDATA(12,cdt2 ,jyr,jm,2,jnumsta12,kyymm,3,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',jyr,jm,nerr
                 STOP
             ENDIF
             WHERE (cdt1 > rmissp)  cdt1=cdt1+bc
             WHERE (bc < rmissp) cdt1=rmiss

             WHERE (cdt2 > rmissp)  cdt2=cdt2+bc
             WHERE (bc < rmissp) cdt2=rmiss
!*******************************************************************
! NOW DO PRECIPITATION 
!*****************************************************************
!            Read the old full month estimate
            CALL RDCDDATA(18,cdp ,jyr,jm,1,jnumsta18,kyymm,2,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc half mmonth precip ',jyr,jm,nerr
                 STOP
             ENDIF
!    Read new cd102 file , compute difference, and add to each half-month 
            CALL RDCDDATA(19,cdpn ,jyr,jm,2,jnumsta19,kyymm,2,jflag,nerr,ndfd)
            bc=cdpn-cdp
            WHERE (cdp < rmissp) bc=0.
            WHERE (cdpn < rmissp) bc=rmiss
            CALL RDCDDATA(14,cdp1 ,jyr,jm,1,jnumsta14,kyymm,4,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',jyr,jm,nerr
                 STOP
             ENDIF
            CALL RDCDDATA(14,cdp2 ,jyr,jm,2,jnumsta14,kyymm,4,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',jyr,jm,nerr
                 STOP
             ENDIF
!            Deal with some troublesome rounding to the nearest 100th
             DO js=1,ndfd
                IF(cdp1(js) > rmissp .AND. bc(js) > rmissp) THEN
                  cdp1(js)=cdp1(js)+REAL(INT(50.*bc(js))/100.)
                  IF(cdp1(js) < 0.) cdp1(js)=0.
                  cdp2(js)=cdpn(js)-cdp1(js)
                  IF(cdp2(js) < 0 ) THEN
                    cdp2(js)= 0.
                    cdp1(js)=cdpn(js)
                  ENDIF
                ELSE
                   cdp1(js) = rmissp
                   cdp2(js)=rmissp
                ENDIF
             END DO     
            CALL WRTCDDATA(13,cdt1,jyr,jm,1,3,jnumsta12,jflag,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps 13 ',jyr,jm,nerr
                 STOP
             ENDIF
            CALL WRTCDDATA(13,cdt2,jyr,jm,2,3,jnumsta12,jflag,nerr,ndfd)
              IF(nerr /= 0) THEN
                 PRINT *,'Error writing cpc temps 13 ',jyr,jm,nerr
                 STOP
             ENDIF
            CALL WRTCDDATA(15,cdp1,jyr,jm,1,4,jnumsta14,jflag,nerr,ndfd)
            CALL WRTCDDATA(15,cdp2,jyr,jm,2,4,jnumsta14,jflag,nerr,ndfd)
              IF(nerr /= 0) THEN
                 PRINT *,'Error writing cpc temps ',jyr,jm,nerr
                 STOP
             ENDIF

          END DO ! JM
      END DO ! JYR
      PRINT *, 'PROGRAM COMPLETE, PROGRAM STATUS = 0 '
      STOP
      END      


