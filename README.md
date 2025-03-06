# [libcalcpi_juliac](https://github.com/terasakisatoshi/libcalcpi_juliac)

## Description

[This repository libcalcpi_juliac](https://github.com/terasakisatoshi/libcalcpi_juliac) provides an example of how to use `juliac` that offers a more traditional, gcc-like command-line interface for compiling Julia programs. See JuliaHub's blog post [New Ways to Compile Julia
](https://info.juliahub.com/blog/new-ways-to-compile-julia-blog) for more information about `juliac`.

This repository tries to compile the following Julia function named `jlcalcpi` which returns the approximate number of `π = 3.1415926535897...`.

```julia
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
```

## TL;DR

```sh
make && ./a.out
```

## Usage

### Install Julia

Install Julia using [juliaup](https://github.com/JuliaLang/juliaup)

```sh
$ curl -fsSL https://install.julialang.org | sh -- --yes
```

### Download files related to `juliac`

Run `make setup` to add nightly channel, download `juliac.jl`, `juliac-buildscript.jl`, and `julia-config.jl`.

```sh
$ ls
LICENSE      README.md    libcalcpi.jl
Makefile     docker       main.c
$ make setup
```

Then we will get:

```sh
$ ls
LICENSE               docker                juliac.jl
Makefile              julia-config.jl       libcalcpi.jl
README.md             juliac-buildscript.jl main.c
```

### Build shared library and executable

```sh
$ make
Building... shared library
julia +nightly juliac.jl --output-lib libcalcpi.dylib --compile-ccallable --trim libcalcpi.jl
ld: warning: ignoring duplicate libraries: '-ljulia'
ld: warning: reexported library with install name '@rpath/libunwind.1.dylib' found at '/Users/terasakisatoshi/.julia/juliaup/julia-nightly/lib/julia/libunwind.1.0.dylib' couldn't be matched with any parent library and will be linked directly
Done
Building entrypoint
gcc -L./ -lcalcpi main.c -o a.out
```

We can use the `calcpi` function from C. This function corresponds to the following implementation in `libcalcpi.jl`:

```julia
Base.@ccallable function calcpi(N::Cint)::Cdouble
    jlcalcpi(N)
end
```

### Run `./a.out`

```sh
$ ./a.out 10
3.0860669992418384
$ ./a.out 100
3.1395974980055170
$ ./a.out 1000
3.1404153403809061
$ ./a.out 10000 # default value
3.1415342390166292
$ ./a.out
3.1415342390166292
```

## Acknowledgment

[This comment by @jbytecode in the Julia Discourse thread 'Where is Juliac developed?'](https://discourse.julialang.org/t/where-is-juliac-developed/113004/32) was very helpful.
