
      program probabilistic_ensemble
  implicit none
  integer, parameter :: n = 5, max_months = 12
  real :: forecasts(n, max_months)
  real :: weights(n), norm_weights(n)
  real :: consolidated(max_months)
  real :: spread(max_months)
  real :: p10(max_months), p50(max_months), p90(max_months)
  integer :: i, j
  real :: weight_sum, mean, variance

  ! Example input: forecasts for 12 months from 5 models
  forecasts = reshape([ &
       10.1, 10.5, 11.0, 12.2, 13.0, 14.1, 15.0, 14.8, 13.5, 12.0, 11.2, 10.5, &
       9.8, 10.3, 10.9, 12.0, 13.1, 14.0, 15.2, 14.9, 13.6, 12.1, 11.0, 10.3,  &
       10.0, 10.4, 11.1, 12.1, 13.2, 14.2, 15.1, 14.7, 13.4, 12.2, 11.1, 10.4, &
       9.9, 10.2, 11.2, 12.3, 13.3, 14.3, 15.3, 14.6, 13.3, 12.3, 11.3, 10.2, &
       10.2, 10.6, 11.3, 12.4, 13.4, 14.4, 15.4, 14.5, 13.2, 12.4, 11.4, 10.1  &
     ], shape(forecasts))

  ! Example weights based on historical skill
  weights = [0.25, 0.20, 0.15, 0.30, 0.10]
  weight_sum = sum(weights)
  norm_weights = weights / weight_sum

  ! Compute consolidated forecast and spread
  do j = 1, max_months
     mean = 0.0
     do i = 1, n
        mean = mean + norm_weights(i) * forecasts(i, j)
     end do
     consolidated(j) = mean

     ! Compute weighted variance
     variance = 0.0
     do i = 1, n
        variance = variance + norm_weights(i) * (forecasts(i, j) - mean)**2
     end do
     spread(j) = sqrt(variance)

     ! Assuming normal distribution, compute percentiles
     p50(j) = mean
     p10(j) = mean - 1.2816 * spread(j)
     p90(j) = mean + 1.2816 * spread(j)
  end do

  ! Output probabilistic forecast
  print *, "Probabilistic Seasonal Forecast (°C):"
  print *, "Month | 10th %ile | Median | 90th %ile"
  do j = 1, max_months
     print "(I5,3F12.2)", j, p10(j), p50(j), p90(j)
  end do

end program probabilistic_ensemble


