      Program main
C     parameter(LXY=11252,Nm=10)
      parameter(LXY=11187,Nm=10)
c
      real data1(LXY),data2(LXY),data(LXY)
      real rslt(LXY,Nm+2), stdd(20,20)
      real refL(20),refR(20)
c
      do i=1,LXY
        read(33,200) data(i)
      enddo
 200  format(e16.7)

      anoise=1.0
c     anoise=0.2

      call standev(LXY,data,std)
      An=std*0.2

      call eemd(LXY,data,An,1000,Nm,rslt,idum,10)
      
      do i=1,LXY
        rslt(i,1)=data(i)
      enddo
      do i=66,LXY
        write(102,100) (rslt(i,j),j=1,12)
      enddo

 100  format(12f9.4)

      stop
      end


c=============================================================
      function std(LXY,Nm,rslt,data)
      real rslt(LXY,Nm),std,data(LXY)
      
      std=0.0
      do i=1,LXY
        std=std+ (data(i)-rslt(i,Nm))*(data(i)-rslt(i,Nm))
      enddo
      std=sqrt(std/float(LXY))

      return
      end
c=============================================================
