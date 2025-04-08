#pragma once

#include <cstdlib>
#include <malloc.h>

#define aligned_alloc(alignment, size) _aligned_malloc(size, alignment)
#define free _aligned_free
