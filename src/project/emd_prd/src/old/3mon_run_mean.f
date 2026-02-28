C*****************************************************************
C  This is a program to do a 3mon_running mean
C*****************************************************************
C
      program main
#include "parm.h"
c
c  The parameter LXY is the length of a original time series.
c  LEX is the length of the extended time series. LEX=3*LXY-2.
c  The LEX is defined for the series that associated with the
c  extended series.
c
      dimension datain(LXY)   ! read-in original time series
      dimension dataout(LXY)     ! out put 
c
      open(10,form="formatted")
c------------------------------------------------------------
      PI=3.1415927
c
c-------------------------------------------------------------
c  Read in the original data
      call read_origin(datain)
c
      do i=2,LXY-1
        dataout(i)=(datain(i-1)+datain(i)+datain(i+1))/3.
      end do
        dataout(1)=(datain(1)+datain(2))/2.
        dataout(LXY)=(datain(LXY)+datain(LXY-1))/2.
 
      call wrt_out(dataout)
c

      stop
      end


c*****************************************************************
C*******************  read_origin  *******************************
c
      subroutine read_origin(tavegl)
#include "parm.h"
c
      dimension tavegl(LXY)      ! read-in original time series
c
      open(10,form="formatted")
c
      do i=1,LXY
        read(10,100) myear,tavegl(i)
      enddo
 100  format(I10,e14.5)
      return
      end
C*******************  wrt out  *******************************
c
      subroutine wrt_out(tavegl)
#include "parm.h"
c
      dimension tavegl(LXY)      ! read-in original time series
c
      open(10,form="formatted")
      open(80,form="formatted")
c
      rewind (10)
      do i=1,LXY
        read(10,100) myear,x
        write(80,100) myear,tavegl(i)
      enddo
 100  format(I10,e14.5)
      return
      end
 

      
