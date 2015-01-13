function diff = functionCheck(h)
    diff = gradientCheck(h.f,h.df,rand);
end
