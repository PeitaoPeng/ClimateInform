c
      subroutine standev(nsize, data, std)
c
c  This is a program to obtain standard deviation of the linearly
c  detrended data
c  
c  nsize :    data size
c  a     :    slope
c  std    :    standard deviation
c
      real data(nsize), trend(nsize)

      sigamX = 0.0
      sigmaY = 0.0
      do i = 1, nsize
        sigmaX = sigmaX + float(i)
        sigmaY = sigmaY + data(i)
      enddo

      fn=float(nsize)

      Xbar=sigmaX/fn
      Ybar=sigmaY/fn

      sigmaX2 = 0.0
      sigmaXY = 0.0
      do i = 1, nsize
        sigmaX2 = sigmaX2+(float(i)-xbar)*(float(i)-xbar)
        sigmaXY = sigmaXY+(float(i)-xbar)*(data(i)-ybar)
      enddo

      b=sigmaXY/sigmaX2
      a=ybar-b*xbar

      do i=1, nsize
        trend(i)=a+b*float(i)
      enddo
      
      do i=1, nsize
c       write(*,*) data(i), trend(i)
      enddo


      std=0

      do i=1,nsize
        std=std+(data(i)-trend(i))*(data(i)-trend(i))
      enddo
      std=std/float(nsize)
      std=sqrt(std)

      return
      end

