      subroutine tstzer(a,n)
      dimension a(n,n)
      do 10 i=1,n
      do 20 j=1,n
      if(abs(a(i,j)).gt.0.0) go to 10
      if(j.eq.n) then
      a(i,i) = 1.
C     write(6,*) ' diagonal element 1 inserted for index i ',i
      endif
 20   continue
 10   continue
      do 30 j=1,n
      do 40 i=1,n
      if(abs(a(i,j)).gt.0.0) go to 30
      if(i.eq.n) then
      a(j,j) = 1.
C     write(6,*) ' diagonal element 1 inserted for index j ',j
      endif
 40   continue
 30   continue
      return
      end
