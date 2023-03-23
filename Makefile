

CC := gcc-4.8
CPP := g++-4.8
CFLAGS := -g -O3

CPPFLAGS := $(CFLAGS)

TEST_OBJS := daxpy.o

TEST_PROGS := $(TEST_OBJS:.o=)


# ==== Rules ==================================================================

.PHONY: default clean

default: $(TEST_PROGS)

clean:
        $(RM)  $(TEST_OBJS) $(TEST_PROGS) $(TEST_OBJS:.o=_p)

$(TEST_PROGS): $(TEST_OBJS)
        $(CPP)  -static -o $@  $@.o ../m5threads/pthread.o

%.o: %.cpp
        $(CPP) $(CPPFLAGS)  -c -o $@ $*.cpp


