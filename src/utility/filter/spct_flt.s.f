CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  spectral filters, need subroutines in fft.f
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  band pass filter                                                C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine FILTERBP(n,rin,rout,nfs,nfe,wsave)
      dimension rin(n),rout(n),wsave(2*n+15)
      call RFFTF(n,rin,wsave)
      x=float(n)
      nfss=2*nfs+1
      nfee=2*nfe+1
      do 10 i=1,nfss-1
         rout(i)=0.
10    continue
      do 20 i=nfss,nfee
        rout(i)=rin(i)/x
20    continue
      do 30 i=nfe+1,n
        rout(i)=0.
30    continue
      call RFFTB(n,rout,wsave)
      return
      end
 

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  low pass filter                                                C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine FILTERLP(n,rin,rout,nf,wsave)
      dimension rin(n),rout(n),wsave(2*n+15)
      call RFFTF(n,rin,wsave)
      x=float(n)
      nff=2*nf+1
c     do 20 i=1,nff-2
      do 20 i=1,nff
        rout(i)=rin(i)/x
20    continue
c     do 30 i=nff-1,n
      do 30 i=nff+1,n
        rout(i)=0.
30    continue
      rout(1)=0
      call RFFTB(n,rout,wsave)
      return
      end


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  high pass filter                                                C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine FILTERHP(n,rin,rout,nf,wsave)
      dimension rin(n),rout(n),wsave(2*n+15)
      call RFFTF(n,rin,wsave)
      x=float(n)
      nff=2*nf+1
      write(6,*) 'wsave=',wsave
c     write(6,*) 'rin=',rin
      do 30 i=1,nff
        rout(i)=0.
30    continue
c     do 20 i=nff+1,n
      do 20 i=1,n
        rout(i)=rin(i)
20    continue
      call RFFTB(n,rout,wsave)
      return
      end


