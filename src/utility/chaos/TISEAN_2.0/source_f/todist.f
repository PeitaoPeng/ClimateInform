c Rank order to distribution given in dist
C Copyright (C) Thomas Schreiber (1999)

      subroutine todist(nmax,dist,x,y)
      parameter(nx=1000000)
      dimension x(nmax), dist(nmax), y(nmax), list(nx)

      if(nmax.gt.nx) stop "todist: make nx larger."
      call rank(nmax,x,list)
      do 10 n=1,nmax
 10      y(n)=dist(list(n))
      end
