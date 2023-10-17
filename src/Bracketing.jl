using Plots

function bracket_univariate_minimum(f, x=0., s=1e-2, k=2.0)
    # bracket upate
    bracket_update(a, s) = [a + s, f(a + s)]
    
    # setup initial interval
    a, ya = bracket_update(x, 0)
    b, yb = bracket_update(a, s)
    
    # if b is greater than a, swap variables, and change sign of step size
    if yb > ya
        a, b = b, a
        ya, yb = yb, ya
        s *= -1
    end
    
    c, yc = 0, 0
    anim = @animate for i in 1:100
        c, yc = bracket_update(b, s)
       
        pts = [a ya; b yb; c yc]
        plot_min_of_f(f, range(-5, 5, 100), pts)
    
        if yc > yb
            break
        end
        a, ya, b, yb = b, yb, c, yc
        s *= k
    end
    return a > c ? (c, a) : (a, c), anim
end

function fibonacci_search(func, a, b, n)
    # Calculate the Fibonacci sequence up to n terms
    fib = [0, 1]
    for i in 3:n
        push!(fib, fib[end] + fib[end-1])
    end
    
    update_x1(a, b, i) = a + (b - a) * (fib[i - 2] / fib[i])
    update_x2(a, b, i) = a + (b - a) * (fib[i - 1] / fib[i])
    
    # Define search points within the interval
    x1 = update_x1(a, b, n)
    x2 = update_x2(a, b, n)
    
    println("Initial ratios ", (fib[n - 2] / fib[n]), " ", (fib[n - 1] / fib[n]))
    
    f1 = func(x1)
    f2 = func(x2)
    
    rng = range(a, b, 100)

    anim = @animate for i in n-1:-1:3
        pts = [x1 f1; x2 f2]
        plot_min_of_f(func, rng, pts)
        
        if f1 < f2
            b, x2, f2 = x2, x1, f1
            x1 = update_x1(a, b, i)
            f1 = func(x1)
        else
            a, x1, f1 = x1, x2, f2
            x2 = update_x2(a, b, i)
            f2 = func(x2)
        end
    end

    # Final step with only two remaining points
    x3 = (a + b) / 2
    f3 = func(x3)

    return f1 < f1 ? (x1, f1) : (x2, f2), anim
end

function golden_search(func, a, b, n; φ = Base.MathConstants.golden)
    ρ = φ - 1 # φ defined as the golden ratio in Julia

    update_bracket(a, b) = ρ * a + (1 - ρ) * b
    
    d = update_bracket(b, a)
    yd = func(d)
    
    rng = range(a, b, 100)
    
    anim = @animate for i in 1:n-1
        c = update_bracket(a, b)
        yc = func(c)
       
        pts = [a yc; b yd]
        plot_min_of_f(func, rng, pts)
        
        if yc < yd
            b, d, yd = d, c, yc
        else
            a, b = b, c
        end
    end
    
    return a < b ? (a, b) : (b, a), anim
end

function quadratic_fit_search(func, a, c, n; φ = Base.MathConstants.golden)
    ρ = φ - 1

    x1, x3 = a, c
    x_min, y_min = 0, 0
    rng = range(a, c, 100)
    
    update_bracket(u, v) = ρ * u + (1 - ρ) * v
    
    anim = @animate for i in 1:n
        x2 = (a + c) / 2
        
        y1, y2, y3 = func(x1), func(x2), func(x3)
        
        A = [1 x1 x1^2; 1 x2 x2^2; 1 x3 x3^2]
        B = [y1; y2; y3]
        
        X = A \ B # inverse divide operation
        
        a, b, c = X
        
        # f = a + bx + cx^2
        # df/dx = 0 -> 0 = b + 2cx 
        # -2cx = b -> x = -b / 2c
        
        x_min = -b / (2*c) # locate vertex describinig minimum
        y_min = func(x_min)
       
        pts = [x_min y_min;]
        plot_min_of_f(func, rng, pts)
        
        # true case:
        # - evaluate output to midpoint, if it's less than midpoint take
        # the lower of the x inputs which drove the midpoint output to be less 
        # than y2
        # false case:
        # - move in the opposite direction since y_min was greater than y2
        if y_min < y2
            if x_min < x2
                x3 = update_bracket(x2, x3) # move left (x3 <- x2)
            else
                x1 = update_bracket(x2, x1) # move right (x1 <- x2)
                #x1 = x2 # move right
            end
        else
            if x_min < x2
                x1 = update_bracket(x_min, x1) # move right (x1 <- x_min)
            else
                x3 = update_bracket(x_min, x3) # move left (x3 <- x_min)
            end
        end
    end
    
    return x_min, y_min, anim
end