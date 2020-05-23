# Parsec Benchmark with Clang Support

The default parsec-3.0 downloaded from the official parsec site causes a lot of errors while building on ubuntu 18. 
But this repository already solves most of the problems and make parsec run on ubuntu with gcc without any problem
https://github.com/cirosantilli/parsec-benchmark.  
I wanted to use clang compiler so that I can use flag `-f-ftrivial-auto-var-init` which was not available on gcc.

## Downloading Inputs
Suppose you are in project directory  
Download the native input file
```bash
$ wget "http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-input-native.tar.gz"
```
Extract the downloaded file into current directory
```bash
$ 7z x -so parsec-3.0-input-native.tar.gz | tar xf - -C ./
```
Now you will have `parsec-3.0` folder with sub folder `pkgs`,`apps`
Either you can manually move `pkgs`, `apps` to the project directory. i.e move from `pkgs`, `apps` from `parsec-3.0` to one directory above
or
```bash
$ rsync -a parsec-3.0/ ./
```

## Required Installation

Use the package manager [apt-get](https://linux.die.net/man/8/apt-get/) to install required packages.

To compile **mesa** which will also be required by raytrace
```bash
$ sudo apt-get install xorg-dev
```

For building **raytrace** you need these packages
```bash
$ sudo apt-get install libxext-dev
$ sudo apt-get install libx11-dev
$ sudo apt-get install libxt-dev
$ sudo apt-get install libxmu-headers
$ sudo apt-get install libxi-dev

$ locate libXmu
# then link the latest version to /usr/lib/libXmu.so
$ sudo ln -s /usr/lib/x86_64-linux-gnu/libXmu.so.6 /usr/lib/libXmu.soFor 
```

building **vips** you also need this package
```bash
$ sudo apt-get install -y pkg-config
```

## Usage
- Building and running, check below to see what values `[PACKAGE]` and `[BUILDCONF]` can take. `[INPUT]` can take `simsmall`*(1s)* and `native`*(15min)*
```bash
$ ./bin/prebuild.sh -p [PACKAGE] -c [BUILDCONF] # required to compile some required libs or tools (by package) with gcc and rename them so that clang building can use them
$ ./bin/parsecmgmt -a build -p [PACKAGE] -c [BUILDCONF]
$ ./bin/parsecmgmt -a run -i [INPUT] -p [PACKAGE] -c [BUILDCONF]
```

- Set PATH of bin. After that you can just use `parsecmgmt` instead of `./bin/parsecmgmt` and also see `man parsecmgmt`
```bash
$ source ./env.sh
```

- Show available installation
```bash
$ parsecmgmt -a status –p all
```

- Cleanup
```bash
parsecmgmt -a fullclean -p all # Remove all temporary directories (used e.g. for building)
```
```bash
parsecmgmt -a uninstall -p [PACKAGE] -c [BUILDCONF] # Uninstall a specific installation
```
```bash
parsecmgmt -a fulluninstall -p all # Uninstall everything
```
## Exaples Usage of Building and Running

- Building and Running **blackscholes**
```bash
$ ./bin/prebuild.sh -p raytrace -c clang-pattern # does nothing in this case
$ ./bin/parsecmgmt -a build -p blackscholes -c clang-pattern
$ ./bin/parsecmgmt -a run -i native -p blackscholes -c clang-pattern
```

- Building and Running **raytrace**. 
    | It uses `lib.mesa` and `tools.cmake`, cmake can be compiled using clang but mesa is compiled using gcc and then its binaries are used.
```bash
$ ./bin/prebuild.sh -p raytrace -c clang # compile mesa using gcc and name it clang
$ ./bin/parsecmgmt -a build -p raytrace -c clang
$ ./bin/parsecmgmt -a run -i native -p raytrace -c clang
```
## Packages
`[PACKAGE]` can take following values
Package | Description | Support for Clang |
---------- | -------------------- | --- |
blackscholes | Option pricing with Black-Scholes Partial Differential Equation (PDE) | yes
bodytrack | Body tracking of a person | yes
canneal | Simulated cache-aware annealing to optimize routing cost of a chip design | yes
dedup | Next-generation compression with data deduplication | no
facesim | Simulates the motions of a human face | no
ferret | Content similarity search server | yes
fluidanimate | Fluid dynamics for animation purposes with Smoothed Particle Hydrodynamics (SPH) method | yes
freqmine | Frequent itemset mining | yes
raytrace | Real-time raytracing | yes
streamcluster | Online clustering of an input stream | yes
swaptions | Pricing of a portfolio of swaptions | yes
vips | Image processing (Project Website) | yes
x264 | H.264 video encoding (Project Website) | yes

## Build Configurations
`[BUILDCONF]` can take following values
Build Configuration | Description |
---------- | -------------------- |
*New* | |
**clang** | Build parallel version of suite with clang |
**clang-pattern** | Build parallel version of suite with clang with pattern initialization | 
**clang-zeroing** | Build parallel version of suite with clang with zero initialization | 
*Default* | |
**gcc** | Build parallel version of suite with gcc | 
**gcc-serial** | Build serial version of suite with gcc | 
**gcc-hooks** | Build parallel version of suite with PARSEC hooks enabled with gcc | 
**icc** | Build parallel version of suite with Intel compiler | 
**gcc-pthreads** | Build with pthreads parallelization (if supported) | 
**gcc-openmp** | Build with OpenMP parallelization (if supported) | 
**gcc-tbb** | Build with TBB parallelization (if supported) | 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
All rights belong to *Princeton University (Copyright (c) 2006-2012)*
See License file for info
