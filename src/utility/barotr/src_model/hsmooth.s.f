      subroutine hsmooth(fin,fout,ir)
      complex fin(ir+2,ir+1),fout(ir+2,ir+1)
      xk=0.0000064
c     xk=0.0       
      do 100 m1=1,ir+1
         m=m1-1
      do 100 n1=1,ir+2
         n=m+n1-1
        if(n.le.24) then
         xx=-xk*(n*(n+1))**2
         fout(n1,m1)=exp(xx)*fin(n1,m1)
        else
         fout(n1,m1)=(0.,0.)
        endif
100   continue
      return
      end
