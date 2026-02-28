
      program bootstrap_ensemble
  implicit none
  integer, parameter :: n = 5, max_months = 12, n_boot = 1000
  real :: forecasts(n, max_months)
  real :: boot_means(n_boot, max_months)
  real :: p10(max_months), p50(max_months), p90(max_months)
  integer :: i, j, b, idx(n)
  real :: temp_mean
  call random_seed()

  ! Example forecasts from 5 models
  forecasts = reshape([ &
       10.1, 10.5, 11.0, 12.2, 13.0, 14.1, 15.0, 14.8, 13.5, 12.0, 11.2, 10.5, &
       9.8, 10.3, 10.9, 12.0, 13.1, 14.0, 15.2, 14.9, 13.6, 12.1, 11.0, 10.3,  &
       10.0, 10.4, 11.1, 12.1, 13.2, 14.2, 15.1, 14.7, 13.4, 12.2, 11.1, 10.4, &
       9.9, 10.2, 11.2, 12.3, 13.3, 14.3, 15.3, 14.6, 13.3, 12.3, 11.3, 10.2, &
       10.2, 10.6, 11.3, 12.4, 13.4, 14.4, 15.4, 14.5, 13.2, 12.4, 11.4, 10.1  &
     ], shape(forecasts))

  ! Bootstrap loop
  do b = 1, n_boot
     do j = 1, max_months
        temp_mean = 0.0
        do i = 1, n
           call random_number(temp_mean)  ! reuse temp_mean as random number
           idx(i) = 1 + int(temp_mean * n)  ! random index from 1 to n
           temp_mean = temp_mean + forecasts(idx(i), j)
        end do
        boot_means(b, j) = temp_mean / n
     end do
  end do

  ! Compute percentiles for each month
  do j = 1, max_months
     call sort_array(boot_means(:, j), n_boot)
     p10(j) = boot_means(int(0.10 * n_boot), j)
     p50(j) = boot_means(int(0.50 * n_boot), j)
     p90(j) = boot_means(int(0.90 * n_boot), j)
  end do

  ! Output
  print *, "Bootstrapped Probabilistic Forecast (°C):"
  print *, "Month | 10th %ile | Median | 90th %ile"
  do j = 1, max_months
     print "(I5,3F12.2)", j, p10(j), p50(j), p90(j)
  end do

contains

  ! Simple insertion sort for small arrays
  subroutine sort_array(arr, n)
    real, intent(inout) :: arr(n)
    integer, intent(in) :: n
    integer :: i, j
    real :: key
    do i = 2, n
       key = arr(i)
       j = i - 1
       do while (j > 0 .and. arr(j) > key)
          arr(j+1) = arr(j)
          j = j - 1
       end do
       arr(j+1) = key
    end do
  end subroutine sort_array

end program bootstrap_ensemble
