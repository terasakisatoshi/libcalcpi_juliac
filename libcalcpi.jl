function jlcalcpi(N)
    cnt = 0
    for a = 1:N, b = 1:N
        cnt += ifelse(gcd(a, b) == 1, 1, 0)
    end
    prob = cnt / N / N
    return √(6 / prob)
end

Base.@ccallable function calcpi(N::Cint)::Cdouble
    jlcalcpi(N)
end
