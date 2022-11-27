#!/bin/sh

module purge
module load git
module load gcc
module load cmake
module load cuda

export PATH=/usr/local/cuda/bin:$PATH
