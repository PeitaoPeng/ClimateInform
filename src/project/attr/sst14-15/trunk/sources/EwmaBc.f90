MODULE EWMABC
      USE ControlConstants
      SAVE
! ***********************************************************************
!    MODULE EwmaNc                                                      *
!    This is a utility for a simple bias correction based on Exponential*
!     Weighted Moving Averages.  The routine uses a grid of ndx,ndy, and*
!     12  monthly partitions.                                           *
!    UNGER 2014                                                         *
!-----------------------------------------------------------------------*
!   GLOBAL VARIABLES                                                    *
!     FROM MODULE ControlConstants                                      *
!      ndx,ndy,ndm = x and y dimensions and (usually) ndm = 12 for 12   *
!                   months   per year.                                  *
!      FROM LOCAL MODULE                                                *
!          bcr = Bias Correction Constant = Simple EWMA of errors       *
!          rnc,nc = Effective Member count on the EWMA filter.          *
!                 Frequently this is jumpstarted using a EWMA running   *
!                mean estimate to begin the series, stored as real,     *
!                changed to integer values (nc)                         *
!          ncmin = minimum cases                                        *
!-----------------------------------------------------------------------*
!     SUBROUTINES CONTAINED                                             *
!       ASSIGNEWMABC - Assigns initial values to arrays.                *
!       RDEWMABC - Reading routine for bias correction and member counts*
!       ADJCOEF - Updates coefficient values using recent observations  *
!      JUMPSTART - Duplicated routine for jumpstarting an EWMA          *
!       NCDCBIASC - Specialized coefficient application routine to bias *
!          correct NCDC data.  Uses a faux grid for 344 or 102 divisions*
!-----------------------------------------------------------------------*
      REAL, DIMENSION(ndx,ndy,ndm,2):: b
      REAL, DIMENSION(ndx,ndy) :: rnc
      INTEGER,DIMENSION(ndx,ndy,ndm,2):: nc
      INTEGER :: ncmin
      CONTAINS
! -----------------------------------------------------------------------------*   
      SUBROUTINE ASSIGNEWMABC(bias0,case0,kcmin)
!* **********************************************************************
!*    SUBROUTINE  ASSIGNEWMABC: Initializes the arrays needed for EWMA  *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Initialization of array                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!*     VARIABLES FROM CALL                                              *
!*       bias0= Inital bias values                                      *
!*       kcmin = Initial minimum cases.                                 *
!*      case0 = Initial number of effective cases for bias0             *
!*     VARIABLES FROM ControlConstants                                  *
!*       ndcd = Number of NDCD climate divisions                        *
!*       ndm  = Number of months  = 12                                  *
!* ---------------------------------------------------------------------*
      bcr=bias0
      rnc=case0
      nc=INT(case0)
      ncmin=kcmin
      RETURN
      END SUBROUTINE ASSIGNEWMABC
! -----------------------------------------------------------------------------*   
      SUBROUTINE RDEWMABC(nu,nerr)
!* **********************************************************************
!*    SUBROUTINE  RDEWMABC: Reads the coefficient arrays needed for EWMA*
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Initialization of array                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!*     VARIABLES FROM CALL                                              *
!*       bias0= Inital bias values                                      *
!*       kcmin = Initial minimum cases.                                 *
!*      case0 = Initial number of effective cases for bias0             *
!*     VARIABLES FROM MODULE                                            *
!*       b = Bias correction coefficient                                *
!         rnc,nc = Count variable read in  (transferred to integer)     *
!*       LOCAL VARIABLES                                                *
!         jm,  month loop                                               *
!         jf = 1 for temp 2 for precip
!          jrec = record number counter                                 *
!* ---------------------------------------------------------------------*
      DO jf=1,2
          nup=nu+jf-1
          DO jm=1,12
            jrec=jm*2-1
            READ (nup,rec=jrec,iostat=nerr) b(:,:,jm,jf)
            jrec=jrec+1
            READ (nup,rec=jrec,iostat=nerr) rnc(:,:)
            nc(:,:,jm,jf)=rnc(:,:)
          END DO
      END DO
      RETURN
      END SUBROUTINE RDEWMABC
! -----------------------------------------------------------------------------*   
      SUBROUTINE ADJEWMA(jm,jma,f,v,bmax,jelm,rstep,kmin,alpf)
!* **********************************************************************
!*    SUBROUTINE  ADJCOEF: Updates coeffiecients for the EWMA           *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Initialization of array                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!*     VARIABLES FROM CALL                                              *
!*       jm = month of observation                                      *
!*       jma =  month of coeffificient being adjusted                   *
!*        f = Estimate (forecast ) of v to in need of bias correction   *
!*        v = Observation corresponding to f                            *
!*       bmax = Maximum error to adjust to.  F-v > bmax is chopped      *
!*       jelm = Element 1= temperature, 2 = precip                      *
!*   rstep,kmin,alpf = Jumpstart parameters  (see subroutine JUMPSTART) *
!*     VARIABLES FROM ControlConstants                                  *
!*      rmiss = Missing value indicator                                 *
!*      ndx,ndy = x,y dimension of arrays                               *
!*     VARIABLES FROM MODULE                                            *
!*    b,nc = Bias and data count                                        *
!*       LOCAL VARIABLES                                                *
!     rmissp = missing value indicator with some leeway for rounding    *
!     ntmin  = local version of ncmin                                   *
!    ncflag = Flag variable                                             *
!     jx,jy = Loopint variables for x and y                             *
!       A   = Gain coefficient for EWMA                                 *
!* ---------------------------------------------------------------------*
!NOTES                                                                  *
!   This subroutine provides provisions for using adjacent periods      *
!    whenever nc < ncmin, and this is an adjacent period coefficient,   *
!    the observations for month jm are used to adjust filters for jma   *
!    if we have enough cases, only adjust the jma when it matches jm.   *
!* ---------------------------------------------------------------------*
      REAL, DIMENSION(ndcd) :: f,v 
      rmissp=rmiss+.1
      ntmin=ncmin
      ncflag=0
      IF(jma  == jm ) ntmin=32767  
!    ncmin is often used to start out a timeseries with adjacent months
!    so when our sample is small, we use offset months.
!    Do not use offset months when nc > ncmin, meaning that there is 
!    a large enough sample to trust an individual month's stats
!    if noffset = 0, we are in a center month, so always increment.
          DO jy=1,ndy
              DO jx=1,ndx
                  jndx=(jy-1)*ndx + jx
                  IF(nc(jx,jy,jma,jelm) > ntmin) CYCLE
                  IF(f(jndx) > rmissp .AND. v(jndx) > rmissp) THEN
                      bc=f(jndx)-v(jndx)
                      IF (ABS(bc)> bmax ) THEN
                          IF (bc > 0) THEN
                              bc=bmax
                          ELSE
                              bc=-bmax
                          ENDIF
                      ENDIF
                      CALL JUMPSTART(nc(jx,jy,jma,jelm),rstep,kmin,alpf,A) 
                      IF(jprint > 3) THEN
                           PRINT *,' ewma ',jx,jy,jma,jelm,rstep,kmin,alpf,a,b(jx,jy,jma,jelm),nc(jx,jy,jma,jelm)
                           PRINT *,jndx,f(jndx),v(jndx),bc
                      ENDIF
                      b(jx,jy,jma,jelm)=(1-A)*b(jx,jy,jma,jelm)+A*bc
                      nc(jx,jy,jma,jelm)=nc(jx,jy,jma,jelm)+1
                  ENDIF
              END DO
           END DO
      END SUBROUTINE ADJEWMA
!------------------------------------------------------------------------------------*
      SUBROUTINE JUMPSTART(kstep,rstep,kmin,alp,talp)
!************************************************************************
!*    SUBROUTINE JUMPSTART                                              *
! THIS ROUTINE STARTS AN EXPONENTIAL MOVING AVERAGE TIME SERIES BY      * 
! BOOTSTRAPPING FROM NOTHING.  THE FIRST ESTIMATE=THE FIRST ELEMENT, THE* 
!      NEXT IS .5 THE FIRST+THE SECOND ELEMENT , AND SO ON.             *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Initialization of array                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!        kstep is the number of elements in the time series to date.    *
!        rstep - rstep diminishes the decay rate of alpha, so that an   *
!                rstep of .5 is half the decay rate (takes twice as long*
!                to reduce than a straight running average simulation   *
!                This is used to reduce the influence of chance outliers*
!                on small samples.  Rstep should only be less than 1    *
!                and computations will enforce this limit.              *
!                rstep <= 0 is a constant EWMA gain set to alp          *
!        kmin - The starting point of the rstep application.  kmin must *
!               be greater than 1 to be sensible, and the computation   *
!             will set for an 1/ kstep exponential decay when kstep<kmin*
!               (Simulating a flat average)                             *
!     alp  - the final value of alpha in a exponential moving average.  *
!          X+ = (1-alp)*X + alp(E)   where E is the time series element,*
!          X is the time series EMA.  This is the minimum value of talp.*
!          if the calculated value of talp < alp, it is set equal to alp*
!     talp = returned value.                                            *
!        NOTE:   setting kmin=1 and rstep = 1 is exactly the same as a  *
!      mean of the kstep cases.                                         *
!************************************************************************
!     STEP 1.  Enforce sensible limits on rstep and kmin
      IF(rstep >1 ) THEN
       rs=1
      ELSE
       rs=rstep
      ENDIF
      IF(kmin < 2) THEN
          jmin=2
      ELSE
          jmin=kmin
      ENDIF
!    rs and jmin are the rstep and kmin with correct limits (changing 
!             actual input variables is bad)
      IF(rstep .LE. 0.) THEN
        talp=alp
      ELSE
        IF(rs == 1.) THEN
           rt=kstep+1
        ELSE    
           IF(kstep > jmin) THEN
               rt=(kstep-jmin)*rstep + jmin
            ELSE
               rt=kstep
            ENDIF
        ENDIF
        IF( rt > 0.  ) THEN
          talp=1./rt
        ELSE
          talp = 1.0
        ENDIF
	IF(talp .LT. alp) talp=alp
	IF(talp .GT. 1.0) talp=1.0
      ENDIF
      RETURN
      END SUBROUTINE JUMPSTART       
      SUBROUTINE NCDCBIASC(v,vc,jelm,jm)
!* **********************************************************************
!*    SUBROUTINE  NCDCBIASC: Applies bias correction coeffiecients to   *
!*        NCDC data                                                     *
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Initialization of array                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!*     VARIABLES FROM CALL                                              *
!*       jm = month of observation                                      *
!*        v = Input value to correct                                    *
!*       vc  = output corrected array                                   *
!*      nvar = 1 temperature, 2 precip. Enforces zero limit.            *
!*     VARIABLES FROM ControlConstants                                  *
!*      rmiss = Missing value indicator                                 *
!*      ndx,ndy = x,y dimension of faux arrays                          *
!*            For 344 climate divisions ndx=43, ndy=8                   *
!*     VARIABLES FROM MODULE                                            *
!*    b    = Bias correction coefficients                               *
!*       LOCAL VARIABLES                                                *
!     rmissp = missing value indicator with some leeway for rounding    *
!    jndx = Index to linerize the jx,jy faux grid                       *
!     jx,jy = Loopint variables for x and y                             *
!* ---------------------------------------------------------------------*
      REAL, DIMENSION(ndcd) :: v,vc
      REAL :: rmissp
      INTEGER :: jndx,jy,jx
      rmissp=rmiss+.1
      jndx=0
      DO jy=1,ndy
         DO jx=1,ndx
            jndx=jndx+1
            IF(v(jndx) > rmissp) THEN
                 vc(jndx) = v(jndx)-b(jx,jy,jm,jelm)
                 IF(jprint .GT. 3) THEN
                    PRINT *,'Bias Correction info: ',jndx,jx,jy,jm,v(jndx),  &
                             b(jx,jy,jm,jelm),vc(jndx)
                 ENDIF
                 IF(jelm .EQ. 2) THEN
                    IF(vc(jndx) < 0.) vc(jndx)=0.
                 ENDIF
            ENDIF
         END DO
     ENDDO
     RETURN
     END SUBROUTINE NCDCBIASC
! -----------------------------------------------------------------------------*   
      SUBROUTINE WTEWMABC(nu,nerr)
!* **********************************************************************
!*    SUBROUTINE  RDEWMABC: Reads the coefficient arrays needed for EWMA*
!* ---------------------------------------------------------------------*
!*  LANGUAGE    FORTRAN 90                                              *
!* ---------------------------------------------------------------------*
!*  MACHINE     linux                                                   *
!* ---------------------------------------------------------------------*
!*  PURPOSE:   Initialization of array                                  *
!* ---------------------------------------------------------------------*
!*  FILES USED  NONE                                                    *
!* ---------------------------------------------------------------------*
!*  SUBROUTINES USED: NONE                                              *
!* ---------------------------------------------------------------------*
!*  VARIABLES                                                           *
!*     VARIABLES FROM CALL                                              *
!*       bias0= Inital bias values                                      *
!*       kcmin = Initial minimum cases.                                 *
!*      case0 = Initial number of effective cases for bias0             *
!*     VARIABLES FROM MODULE                                            *
!*       b = Bias correction coefficient                                *
!         rnc,nc = Count variable read in  (transferred to integer)     *
!*       LOCAL VARIABLES                                                *
!         jm,  month loop                                               *
!          jrec = record number counter                                 *
!* ---------------------------------------------------------------------*
      DO jelm=1,2
          nup=nu+jelm-1
          DO jm=1,12
             jrec=jm*2-1
             WRITE (nup,rec=jrec,iostat=nerr) b(:,:,jm,jelm)
             jrec=jrec+1
             rnc(:,:)=nc(:,:,jm,jelm)
             WRITE (nup,rec=jrec,iostat=nerr) rnc(:,:)
          END DO
      END DO
      RETURN
      END SUBROUTINE WTEWMABC
END MODULE EwmaBc
      
      
