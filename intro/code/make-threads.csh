#!/usr/bin/env bash

# MAC OS X:
# Don't unroll loops and turn off optimization for
# easiest to explain version of this
gcc -o threads.v0 threads.v0.c -Wall -pthread -O0 -m32 -fno-unroll-loops
gcc -o threads.v1 threads.v1.c -Wall -pthread -O0 -m32 -fno-unroll-loops
