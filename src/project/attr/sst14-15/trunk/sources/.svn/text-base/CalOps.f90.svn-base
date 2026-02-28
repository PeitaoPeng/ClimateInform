MODULE Calops
PRIVATE
PUBLIC ADDYR,CALNDR,GETDAYS,MONTHLOOP
!***********************************************************************
!  MODULE Calops                                                       *
!                                                                      *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!   This module contains Calander related subroutines                  *
!    It is set to private because it has a lot of variable names that  *
!    may clash with other programs when "USE" statements used          * 
!***********************************************************************
CONTAINS
!--------------------------------------------------------------------------------
      SUBROUTINE ADDYR(ky,km,nm,kyp,kmp)
!***********************************************************************
!        SUBROUTINE ADDYR                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            * 
!      ADDS NM MONTHS TO DATE KY,KM TO GET THE MONTH KYP,KMP.          *
!        NM CAN BE POSITIVE OR NEGATIVE                                *
!----------------------------------------------------------------------*
!        LOCAL VARIABLES FROM CALL                                     *
!          INPUT   KY,KM = YEAR AND MONTH                              *
!                  NM = NUMBER OF MONTHS TO ADD.                       *
!          OUTPUT  KYP,KMP = YEAR AND MONTH OF TARGET                  *
!***********************************************************************
      kmp=km+nm
      kyp=ky
      DO WHILE (kmp .LE. 0 .OR. kmp .GT. 12)
      IF(kmp .LE. 0) THEN
        kmp=kmp+12
        kyp=kyp-1
      ELSEIF(kmp .GT. 12) THEN
        kmp=kmp-12
        kyp=kyp+1
      ENDIF
      ENDDO
      RETURN
      END SUBROUTINE ADDYR
!--------------------------------------------------------------------------------
      SUBROUTINE CALNDR (ioptn, iday, month, iyear, idayct)
!    
!***********************************************************************
!        SUBROUTINE CALNDR                                             *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            * 
!      PERFORMS BASIC CALANDER FUNCTIONS                               *
!----------------------------------------------------------------------*
!   This code was copied by permission from link provided by a BAMS    *
!    article.                                                          * 
!       This code  c Copyright (C) 1999 Jon Ahlquist.                  *
!  Issued under the second GNU General Public License.                 *
!  See www.gnu.org for details.                                        * 
!  This program is distributed in the hope that it will be useful,     *
!  but WITHOUT ANY WARRANTY; without even the implied warranty of      *
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                * 
!  If you find any errors, please notify:                              *
!  Jon Ahlquist <ahlquist@met.fsu.edu>                                 *
!  Dept of Meteorology                                                 *
!  Florida State University                                            *
!  Tallahassee, FL 32306-4520                                          *
!  15 March 1999.                                                      *
!                                                                      *
!    Full documentation in "calendar.f:                                *
!        ioptn=3  Inputs iday,month,iyear and returns idayct           *
!        ioptn=4  Inputs idayct and returns Iday,month,iyear.          *
!***********************************************************************
      INTEGER :: iday, month, iyear, idayct,jdref,  jmonth, jyear, leap, &
              n1yr, n4yr, n100yr, n400yr,ndays, ndy400, ndy100, nyrs,yr400, yrref
      IF (ABS(ioptn) .LE. 3) THEN
         IF (iyear .GT. 0) THEN
            jyear = iyear
         ELSEIF (iyear .EQ. 0) THEN
            write(*,*)'For calndr(), you specified the nonexistent year 0'
            STOP
         ELSE
            jyear = iyear + 1
         ENDIF
         leap = 0
         IF ((jyear/4)*4 .EQ. jyear) THEN
            leap = 1
         ENDIF
         IF ((ioptn .GT. 0) .AND.  ((jyear/100)*100 .EQ. jyear) .AND. ((jyear/400)*400 .ne. jyear)) THEN
               leap = 0
         ENDIF
      ENDIF
      IF (ABS(ioptn) .GE. 3) THEN
         yrref  =    1600
         jdref  = 2305518
         ndy400 = 400*365 + 100
         ndy100 = 100*365 +  25
         IF (ioptn .GT. 0) THEN
            jdref  = jdref  - 10
            ndy400 = ndy400 -  3
            ndy100 = ndy100 -  1
         ENDIF
      ENDIF
      IF (ABS(ioptn) .EQ. 1) THEN
      IF (month .LE. 2) THEN
         idayct = iday + (month-1)*31
      ELSE
         idayct = iday + int(30.6001 * (month+1)) - 63 + leap
      ENDIF
      ELSEIF (ABS(ioptn) .EQ. 2) THEN
      IF (idayct .LT. 60+leap) THEN
         month  = (idayct-1)/31
         iday   = idayct - month*31
         month  = month + 1
      ELSE
         ndays  = idayct - (60+leap)
         jmonth = (10*(ndays+31))/306 + 3
         iday   = (ndays+123) - int(30.6001*jmonth) 
         month  = jmonth - 1
      ENDIF
      ELSEIF (ABS(ioptn) .eq. 3) THEN
      IF (month .le. 2) THEN
        jyear  = jyear -  1
        jmonth = month + 13
      ELSE
        jmonth = month +  1
      ENDIF
      yr400 = (jyear/400)*400
      IF (jyear .LT. yr400) THEN
         yr400 = yr400 - 400
      ENDIF
      n400yr = (yr400 - yrref)/400
      nyrs   = jyear - yr400
      idayct = iday + INT(30.6001*jmonth) - 123 + 365*nyrs + nyrs/4 + jdref + n400yr*ndy400
      IF (ioptn .GT. 0) THEN
         idayct = idayct - nyrs/100
      ENDIF
      ELSE
      ndays  = idayct - jdref
      n400yr = ndays / ndy400
      jdref  = jdref + n400yr*ndy400
      IF (jdref .GT. idayct) THEN
         n400yr = n400yr - 1
         jdref  = jdref  - ndy400
      ENDIF
      ndays  = idayct - jdref
      n100yr = min(ndays/ndy100, 3)
      ndays  = ndays - n100yr*ndy100
      n4yr   = ndays / 1461
      ndays  = ndays - n4yr*1461
      n1yr   = min(ndays/365, 3)
      ndays  = ndays - 365*n1yr
      iyear  = n1yr + 4*n4yr + 100*n100yr + 400*n400yr + yrref 
      IF (ABS(ioptn) .EQ. 4) THEN
         jmonth = (10*(ndays+31))/306 + 3
         iday   = (ndays+123) - int(30.6001*jmonth)
         IF (jmonth .LE. 13) THEN
            month = jmonth - 1
         ELSE
            month = jmonth - 13
            iyear = iyear + 1
         ENDIF
      ELSE
         month = 1
         leap = 0
         IF ((jyear/4)*4 .EQ. jyear) THEN
            leap = 1
         ENDIF
         IF ((ioptn .GT. 0) .AND.  ((jyear/100)*100 .EQ. jyear) .AND. ((jyear/400)*400 .EQ. jyear)      ) THEN
               leap = 0
         ENDIF
         IF (ndays .LE. 305) THEN
            iday  = ndays + 60 + leap
         ELSE
            iday  = ndays - 305
            iyear = iyear + 1
         ENDIF
      ENDIF
      IF (iyear .LE. 0) THEN
         iyear = iyear - 1
      ENDIF
      ENDIF
      RETURN
      END SUBROUTINE CALNDR
!--------------------------------------------------------------------------------
      SUBROUTINE GETDAYS(jy,jm,jd)
!***********************************************************************
!        SUBROUTINE GETDAYS                                            *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            * 
!      LOOKS UP THE MONTH LENGTH INCLUDING LEAP YEARS                  *
!----------------------------------------------------------------------*
!      VARIABLES                                                       *
!     INPUT FROM CALL                                                  *
!       jy,jm  = Year and month to find month length for               *
!     OUTPUT                                                           * 
!       jc  = Number of days in the month                              *
!***********************************************************************
      INTEGER,DIMENSION(12) :: nday 
      INTEGER jy,jm,jd
      DATA nday /31,28,31,30,31,30,31,31,30,31,30,31/
      jd=nday(jm)
      IF (jm == 2) THEN
           IF (MOD(jy,4) == 0) THEN 
              jd=jd+1
               IF(MOD(jy,100) == 0 .AND. MOD(jy,400) /= 0) jd=jd-1
           END IF
      END IF
      RETURN
      END  SUBROUTINE GETDAYS
!--------------------------------------------------------------------------------
      SUBROUTINE MONTHLOOP(jyr,jyf,jmf,jye,jme,jm1,jm2)
!***********************************************************************
!       UNGER SEPTEMBER 2008                                           *
!        This really simple routine finds the month limits for year jy * 
!        in a do loop with startmonth jyf,jmf and end time jye,jme.    *
!----------------------------------------------------------------------*
!      VARIABLES                                                       *
!     INPUT FROM CALL                                                  *
!     jyr - Current year                                               *
!      jyf,jmf = First month and year to loop through                  *
!      jye,jme = Last month and year to loop through                   *
!      jm1jm2 = First and last months for jyr to loop                  *
!***********************************************************************
      IF(jyr == jyf) THEN
        jm1=jmf
      ELSE
         jm1=1
      ENDIF
      IF(jyr == jye) THEN
        jm2=jme
      ELSE
         jm2=12
      ENDIF
      RETURN
      END  SUBROUTINE MONTHLOOP      
      
END MODULE Calops

