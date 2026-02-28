      subroutine hsmooth(fin,fout,ir,icut,ie,sset)
      real fin(2,ir+1,ir+1),fout(2,ir+1,ir+1)
      LOGICAL sset 
      if (sset) then
      xcut=float(icut)
      xn0=1./(xcut*(xcut+1.))
      xk=xn0**ie
      do 100 m1=1,ir+1
         m=m1-1
      do 100 n1=1,ir+1
         n=m+n1-1
c       if(n.le.icut) then
         xx=-xk*(n*(n+1))**ie
         fout(1,n1,m1)=exp(xx)*fin(1,n1,m1)
         fout(2,n1,m1)=exp(xx)*fin(2,n1,m1)
c       else
c        fout(1,n1,m1)=0.
c        fout(2,n1,m1)=0.
c       endif
100   continue
      else
       do i=1,ir+1
       do j=1,ir+1
         fout(1,i,j)=fin(1,i,j)
         fout(2,i,j)=fin(2,i,j)
       end do
       end do
      endif
      return
      end
