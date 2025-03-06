# Makefile

# Detect operating system
OS_TYPE := $(shell uname -s)

# Set shared library extension based on OS
ifeq ($(OS_TYPE),Linux)
    SHARED_LIB_EXT := .so
else ifeq ($(OS_TYPE),Darwin)
    SHARED_LIB_EXT := .dylib
else
    $(error Unsupported operating system: $(OS_TYPE))
endif


# Variables
JULIA=julia +nightly
JULIA_SCRIPT=juliac.jl
OUTPUT_LIB=libcalcpi$(SHARED_LIB_EXT)
CC=gcc
CFLAGS=-L./ -lcalcpi
MAIN_C=main.c
OUT=a.out

# Default target
all: $(OUT)

setup:
	juliaup add nightly
	juliaup update nightly
	julia +nightly --version
ifeq ($(wildcard ./juliac.jl),)
	@echo "Downloading juliac.jl..."
	wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/juliac.jl
else
	@echo "juliac.jl already exists"
endif

ifeq ($(wildcard ./juliac-buildscript.jl),)
	@echo "Downloading juliac-buildscript.jl..."
	wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/juliac-buildscript.jl
else
	@echo "juliac-buildscript.jl already exists"
endif

ifeq ($(wildcard ./julia-config.jl),)
	@echo "Downloading julia-config.jl..."
	wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/julia-config.jl
else
	@echo "julia-config.jl already exists"
endif

# Build the shared library
$(OUTPUT_LIB): libcalcpi.jl setup
	@echo "Building... shared library"
	$(JULIA) $(JULIA_SCRIPT) --output-lib $(OUTPUT_LIB) --compile-ccallable libcalcpi.jl
	@echo "Done"

# Compile the C program
$(OUT): $(OUTPUT_LIB) $(MAIN_C)
	@echo "Building entrypoint"
	$(CC) $(MAIN_C) -L./ -lcalcpi -o $(OUT)

# Run the executable
run: $(OUT)
ifeq ($(OS_TYPE),Linux)
	LD_LIBRARY_PATH=. ./$(OUT)
else ifeq ($(OS_TYPE),Darwin)
	./$(OUT)
endif


# Clean up generated files
clean:
	$(RM) $(OUT) $(OUTPUT_LIB)

distcleanall:
	$(MAKE) clean
	$(RM) juliac.jl juliac-buildscript.jl julia-config.jl
# Phony targets
.PHONY: all run clean setup
