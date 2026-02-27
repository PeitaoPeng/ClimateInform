c utility for neighbour search
c see  H. Kantz, T. Schreiber, Nonlinear Time Series Analysis, Cambridge
c      University Press (1997)
c Copyright (C) T. Schreiber (1997)

      subroutine base(nmax,y,id,m,jh,jpntr,eps)
      parameter(im=100,ii=100000000) 
      dimension y(nmax),jh(0:im*im),jpntr(nmax)

      do 10 i=0,im*im
 10     jh(i)=0
      do 20 n=(m-1)*id+1,nmax                                  ! make histogram
        i=im*mod(int(y(n)/eps)+ii,im)+mod(int(y(n-(m-1)*id)/eps)+ii,im)
 20     jh(i)=jh(i)+1
      do 30 i=1,im*im                                           ! accumulate it
 30     jh(i)=jh(i)+jh(i-1)
      do 40 n=(m-1)*id+1,nmax                           ! fill list of pointers
        i=im*mod(int(y(n)/eps)+ii,im)+mod(int(y(n-(m-1)*id)/eps)+ii,im)
        jpntr(jh(i))=n
 40     jh(i)=jh(i)-1
      end
