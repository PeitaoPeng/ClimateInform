program bootstrap_forecast
  implicit none
  integer, parameter :: n_residuals = 10, n_samples = 1000
  real :: forecast_value = 120.0 ! deterministic forecast (e.g. 120mm rainfall)
  real :: residuals(n_residuals)
  real :: simulated_forecasts(n_samples)
  integer :: i, idx

  call random_seed()  ! initialize RNG

  ! Historical residuals (errors) based on similar past forecasts
  residuals = (/ -20.0, -15.0, -10.0, -5.0, 0.0, 5.0, 10.0, 15.0, 20.0, 25.0 /)

  ! Bootstrap sampling: simulate new forecasts
  do i = 1, n_samples
     call random_number(idx)
     idx = int(idx * n_residuals) + 1
     if (idx > n_residuals) idx = n_residuals
     simulated_forecasts(i) = forecast_value + residuals(idx)
  end do

  ! Print the first 10 simulated values
  print *, "Sample bootstrap forecasts:"
  do i = 1, 10
     print *, simulated_forecasts(i)
  end do

end program bootstrap_forecast

