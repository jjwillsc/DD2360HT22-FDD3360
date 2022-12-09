#ifndef TIMING_H
#define TIMING_H

#if defined(__linux)
#include <sys/time.h>
#else if defined(_WIN32)

#endif

// return time in second
double cpuSecond();

#endif
