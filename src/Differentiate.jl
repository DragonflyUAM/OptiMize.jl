diff_forward(f, x; h=sqrt(eps(Float64))) = (f(x .+ h) - f(x)) / h

diff_central(f, x; h=cbrt(eps(Float64))) = (f(x .+ h/2) - f(x .- h/2)) / h

diff_backward(f, x; h=sqrt(eps(Float64))) = (f(x) .- f(x .- h)) / h

complex_step(f, x; h=1e-20) = imag(f(x .+ im*h)) / h