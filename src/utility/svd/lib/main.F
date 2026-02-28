      program main
#include "parm.h"
c
c Singular Value Decomposition 
c
c Compute the SVD of a covariance matrix formed by convolving 2 vectors
c   which have been assembled from the LEFT and RIGHT fields (which 
c   may be on different grids.) 
c
c Current code settings assume that you have already extracted the subset
c   of gridpts for the LEFT and RIGHT fields and are reading them in 
c   from units 31 and 32. (See load.F for exact format.) You must also
c   supply the full grid timeseries in units 41 and 42 onto which the
c   coefficients will be projected.
c
c Option:
c   Write and substitute your own code subroutine "load.F" to compute
c   the input LEFT and RIGHT fields. Just be sure that the full grid
c   timeseries are in units 41 and 42 so that they are readable
c   as follows:
c        real b(idl,jdl)    <=== for the left field
c        do 10 iy=1,nyr
c        do 10 im=1,nmon
c        read(41) b
c     10 continue
c
c unit numbers used:
c
c  31 == left field to be used in covariance matrix
c  32 == right field to be used in covariance matrix
c  41 == time series of full grids for left field
c  42 == time series of full grids for right field
c
c OUTPUT:
c  61 == SVD coeffs and results
c        to read:
c  real a(nmon,nyr,nf), b(nmon,nyr,nf)
c  real sv(10),ss(10),ss1(ss1),covab(nf)
c  real valx(nf),vbrx(nf),vblx(nf),varx(nf)
c  read() a     <== temporal expansion coefficients for the left field
c  read() b     <== temporal expansion coefficients for the right field
c  read() sv    <== singular values
c  read() ss    <== squared covariance fraction
c  read() ss1   <== cumulative squared covariance fraction
c  read() covab <== temporal correlation coefficients, timeseries a vs b
c  read() valx  <== fraction of variance of left field explained by a
c  read() vbrx  <== fraction of variance of right field explained by b
c  read() vblx  <== fraction of variance of left field explained by b
c  read() varx  <== fraction of variance of right field explained by a
c  do n=1,nf
c    read() aleft  <== idl x jdl, projection of coeff A on LEFT field
c    read() bright <== idr x jdr, projection of coeff B on RIGHT field
c    read() bleft  <== idl x jdl, projection of coeff B on LEFT field
c    read() aright <== idr x jdr, projection of coeff A on RIGHT field
c  continue
c         
c  71 == Projections of coeff a on Left field
c  72 == Projections of coeff b on Right field
c  73 == Projections of coeff b on Left field
c  74 == Projections of coeff a on Right field
c
c  81 == titles for Projections of coeff a on Left field (ASCII)
c  82 == titles for Projections of coeff b on Right field (ASCII)
c  83 == titles for Projections of coeff b on Left field (ASCII)
c  84 == titles for Projections of coeff a on Right field (ASCII)
c
      common/source/xldata(nmax,nmon,nyr),rdata(nmax,nmon,nyr)
c
      iul=31
      iur=32
      iulf=41
      iurf=42
      nplots=nf
c
c load left field, xldata
c
      call loadl(xldata,nl,iul,iulf)
c
c load right field, rdata
c
      call loadr(rdata,nr,iur,iurf)

      write(*,'(''removing mean for ldata...'')')
      call normal(xldata,nl)
      write(*,'(''removing mean for rdata...'')')
      call normal(rdata,nr)
c
      write(*,'(''NL='',i4,'' NR='',i4)') nl,nr
      call comput(nl,nr,nplots,iulf,iurf)
      stop
      end
