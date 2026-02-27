       subroutine znlsym(a,m,n)
       dimension a(2,m,n)
       do 10 j=1,n
       do 10 i=2,m
       a(1,i,j) = 0.
       a(2,i,j) = 0.
  10   continue
       return
       end
