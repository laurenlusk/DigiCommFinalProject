function input_checking(REDUCE, TOL)

    if (TOL < 0)
        error("TOL must be a non-negative number.")
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    if (REDUCE.N <= 0)
        error("REDUCE.N must be a positive number.")
    end
    if (REDUCE.S <= 0)
        error("REDUCE.S must be a non-negative number.")
    end
    if (REDUCE.W <= 0)
        error("REDUCE.N must be a positive number.")
    end
    if (REDUCE.E <= 0)
        error("REDUCE.S must be a non-negative number.")
    end
end