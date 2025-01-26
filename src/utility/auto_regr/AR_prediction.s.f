      subroutine auto_regr_pred(nmax,s,nsize,m,pred)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  s(n+1) = a1*s(n)+a2*s(n-1)+...+am*s(n-m+1)
C  nmax : the max length of the data
C  nsize: the length of the data used to do regression
C  s    : array of the data used to do regression
C  m    : rank of the AR
C  a    : array of the AR coef
C  pred : prediction output
C===========================================================
      real s(nmax)
      real wout(71),wk1(2000),wk2(30,2000)
      real a(10),xmean
c
c have delayed time series
c
      do i=1,m
      do j=m+1-i,nsize-i
        wk2(i,j-m+i)=s(j)
      end do
      end do
c
      do i=1,m
      do k=1,nmax
       wout(k)=wk2(i,k)
      end do
c     write(6,*) 'i=',i
c     write(6,666)wout
      end do
 666  format(10f7.2)
c
c have s(n+1)
c
      do j=m+1,nsize
        wk1(j-m)=s(j)
      end do
      do k=1,nmax
       wout(k)=wk1(k)
      end do
c     write(6,666)wout

         call mul_regression(wk1,wk2,a,xmean,1,nsize-m,m)

c     write(6,666) a
C=== make prediction
      pred=0
      do i=1,m
        pred=pred+a(i)*s(nsize+1-i)
      end do

      return
      end



!ROUTINE NAME:   mul_regression.f

!ABSTRACT:   Subroutine to calculate the coefficients by using the 
C            least square method.

C       ================================================================
        subroutine mul_regression( V, R, C, mean, nchan,nsamp, npc )
C       ================================================================
C-----------------------------------------------------------------------
C      Perform the matrix calculations involved in solving a general 
C      least squares regression.  The Equation is as follows:
C 
C      (1)   V = C * R
C
C      where V has dimensions of [nchannel x nprofle] and contains the
C      the predictants;  R has dimensions of [numpc_use x nprofle]
C      and contains the principal componenets calculated from the 
C      training sample;  C is the coefficient matrix to be solved for 
C      and has dimensions [nchannel x numpc_use].
C
C      The solution for C from equation (1) is:
C
C      (2)   C = V * Rt * [R * Rt](inv)
C
C      [X](inv) indicates the inverse of matrix X
C      Xt indicates the transpose of matrix X
C-----------------------------------------------------------------------        


	implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
        parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

	integer		nchan, nsamp, npc
	real		V(nchan,2000)
	real		R(30, 2000)
	real		C(nchan,10)
	real		mean(nchan)

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer        icol
        integer        irow
        integer        jj

	real*8		RRT(max_npc,max_npc)
	real*8		RRTinv(max_npc,max_npc)
	real*8		VRT(max_nchan,max_npc)
	real*8 		sum

C-----------------------------------------------------------------------
c     Subtract training mean from V
C-----------------------------------------------------------------------

      do irow = 1, nchan
	mean(irow) = 0.0
	do icol = 1, nsamp
		mean(irow) = mean(irow) + V(irow,icol)
	enddo
	mean(irow) = mean(irow)/nsamp
      enddo


      do irow = 1, nchan
	do icol = 1, nsamp
		V(irow,icol) = V(irow,icol) - mean(irow)
	enddo
      enddo


C-----------------------------------------------------------------------
C     Calculate the matrix product R*RT
C-----------------------------------------------------------------------

      do irow = 1, npc

         do icol = 1, npc

                RRT( irow, icol ) = 0.0

           do jj = 1, nsamp

                RRT( irow, icol ) = RRT( irow, icol ) + 
     $                    R( irow, jj ) * R( icol, jj )

           enddo

         enddo
	
	enddo


C-------------------
C  ridging the matrix
C------------------
      do irow=1,npc
         RRT(irow,irow)=(1.+ 0.0)*RRT(irow,irow)
      end do
C-----------------------------------------------------------------------
c     Calculate the inverse of the matrix RRt = [RRt](inv) 
C-----------------------------------------------------------------------

             call mtrx_inv ( RRT, RRTinv, npc )

C-----------------------------------------------------------------------
c     Calculate V * Rt
C-----------------------------------------------------------------------


      do irow = 1, nchan

         do icol = 1, npc

             VRT(irow,icol)= 0.0

           do jj = 1, nsamp

             VRT( irow, icol )= VRT( irow, icol ) + 
     $                  V( irow, jj ) * R( icol, jj )

           enddo

         enddo

      enddo


C-----------------------------------------------------------------------
c     Calculate VRt * [RRt](inv) = Coefficient Matrix
C-----------------------------------------------------------------------


      do irow = 1, nchan

         do icol = 1, npc

             sum = 0.0

           do jj = 1, npc

             sum = sum + VRT( irow, jj ) * RRTinv( jj, icol )

           enddo
             C( irow, icol ) = sngl(sum)
         enddo

      enddo

      return
      end

C==============================================================================
C==============================================================================
C
C    ORGANIZATION:   NOAA/NESDIS 
C
C    PROJECT:        AIRS Core Algorithm Development 
C
C    SUBSYSTEM:      NASRS (NOAA Advanced Sounder Retrieval System)
C
!F77==========================================================================


!ROUTINE NAME:   mtrx_inv.f

!ABSTRACT:   Calculates the inverse of a double precision symmetric 
C            matrix. 


!CALL PROTOCOL:

C          mtrx_inv( x, xinv, n )



!INPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------
C    real*8     x              matrix to be inverted
C    integer    n              dimension of x

!OUTPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------
C    real*8     xinv           inverted matrix 

!INPUT/OUTPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------


!RETURN VALUES:

C   [Include the values of the return status from this routine.]


!PARENT(S):  General Purpose



!ROUTINES CALLED:  None 



!FILES ACCESSED: None


!COMMON BLOCKS:  None



!DESCRIPTION:

C   [This section should describe the state of the program and
C    arguments on entry (including any assumptions about previous
C    processing, file positioning, and so on) and on return.  Exception
C    handling, return values and limitations should also be discussed.]

!ALGORITHM REFERENCES:

C      The method is described in J. H. Wilkinson and C. Reinsch,
c       'Handbook for Automatic Compuation, Vol. II - Linear Algebra',
c        Springer-Verlag, under 'Symmetric Decomposition of a Positive
c        Definite Matrix', p. 9.


!KNOWN BUGS AND LIMITATIONS:

C   [Include all the possible limitations or bugs that are currently
C    associated with this code.]


!ROUTINE HISTORY:

C        Date        Programmer        Comments
C   --------------------------------------------------------------------
C        03/22/84    Mitch Goldberg    


!END  ==================================================================



C       ================================================================
        subroutine  mtrx_inv( x, xinv, n )
C       ================================================================

        implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include  "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
        parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

        real*8    x ( max_npc, max_npc )
        real*8    xinv ( max_npc, max_npc )
        integer   n

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer   i
        integer   ii
        integer   im
        integer   ip
        integer   j
        integer   jm
        integer   jp
        integer   k
        integer   l
        integer   nm
        real*8    s ( max_npc, max_npc )
        real*8    a ( max_npc, max_npc )
        real*8    sum

C***********************************************************************
C***********************************************************************
C                            EXECUTABLE CODE
C***********************************************************************
C***********************************************************************

C-----------------------------------------------------------------------
C     [ Major comment blocks set off by rows of dashes. ]
C-----------------------------------------------------------------------

C
C    CONVERT 'X' TO A DOUBLE PRECISION WORK ARRAY.
      do 10 i=1,n
      do 10 j=1,n
cx      a(i,j)=dble(x(i,j))
      a(i,j)=x(i,j)
   10 continue
      s(1,1)=1.0/a(1,1)
c    just inverting a scalar if n=1.
      if(n-1)20,180,30
   20 return
   30 do 40 j=2,n
      s(1,j)=a(1,j)
   40 continue
      do 70 i=2,n
      im=i-1
      do 60 j=i,n
      sum=0.0
      do 50 l=1,im
      sum=sum+s(l,i)*s(l,j)*s(l,l)
   50 continue
      s(i,j)=a(i,j)-sum
   60 continue
      s(i,i)=1.0/s(i,i)
   70 continue
      do 80 i=2,n
      im=i-1
      do 80 j=1,im
   80 s(i,j)=0.0
      nm=n-1
      do 90 ii=1,nm
      im=n-ii
      i=im+1
      do 90 j=1,im
      sum=s(j,i)*s(j,j)
      do 90 k=i,n
      s(k,j)=s(k,j)-s(k,i)*sum
   90 continue
      do 120 j=2,n
      jm=j-1
      jp=j+1
      do 120 i=1,jm
      s(i,j)=s(j,i)
      if(jp-n)100,100,120
  100 do 110 k=jp,n
      s(i,j)=s(i,j)+s(k,i)*s(k,j)/s(k,k)
  110 continue
  120 continue
      do 160 i=1,n
      ip=i+1
      sum=s(i,i)
      if(ip-n)130,130,150
  130 do 140 k=ip,n
      sum=sum+s(k,i)*s(k,i)/s(k,k)
  140 continue
  150 s(i,i)=sum
  160 continue
      do 170 i=1,n
      do 170 j=i,n
      s(j,i)=s(i,j)
  170 continue
c    retrieve output array 'xinv' from the double precession work array.
  180 do 190 i=1,n
      do 190 j=1,n
cx      xinv(i,j)=sngl(s(i,j))
      xinv(i,j)=s(i,j)
  190 continue
      return
      end
