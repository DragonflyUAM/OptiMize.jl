using Plots

function plot_min_of_f(f, x, pts)
    y = f.(x)
    plot(x, y)
    
    rows, cols = size(pts)
    c = distinguishable_colors(rows)
    for i in 1:rows
        l = Char(Int('a') + i - 1)
        scatter!([pts[i, 1]], [pts[i, 2]], c=c[i], label=l)
    end
end

function plot_min_of_f(f, x, y, pts)
    z = @. f(x', y)
    contour(x, y, z)
    
    rows, cols = size(pts)
    c = distinguishable_colors(rows)
    for i in 1:rows
        l = Char(Int('a') + i - 1)
        scatter!([pts[i, 1]], [pts[i, 2]], c=c[i], label=l)
    end
end