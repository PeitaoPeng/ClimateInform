program write_netcdf
  use netcdf
  implicit none

  ! Variable declarations
  integer :: ncid, varid, dimid, retval
  integer, parameter :: NX = 10
  real :: data(NX)
  character(len=*), parameter :: filename = 'example.nc'

  ! Fill the array with some values
  data = [(real(i), i = 1, NX)]

  ! Create the NetCDF file
  retval = nf90_create(filename, NF90_CLOBBER, ncid)
  if (retval /= nf90_noerr) stop 'Error creating file'

  ! Define the dimension
  retval = nf90_def_dim(ncid, 'x', NX, dimid)
  if (retval /= nf90_noerr) stop 'Error defining dimension'

  ! Define the variable
  retval = nf90_def_var(ncid, 'data', NF90_REAL, dimid, varid)
  if (retval /= nf90_noerr) stop 'Error defining variable'

  ! End definitions
  retval = nf90_enddef(ncid)
  if (retval /= nf90_noerr) stop 'Error ending define mode'

  ! Write the data
  retval = nf90_put_var(ncid, varid, data)
  if (retval /= nf90_noerr) stop 'Error writing data'

  ! Close the file
  retval = nf90_close(ncid)
  if (retval /= nf90_noerr) stop 'Error closing file'

  print *, 'NetCDF file written successfully!'
end program write_netcdf

