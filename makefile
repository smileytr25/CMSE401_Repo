# Compiler and flags
CC = gcc
CFLAGS = -c
LIBS = -lm -lpng16
OPT_FLAGS = -O2  # Optimization flags for serial optimization
OPENMP_FLAGS = -fopenmp  # OpenMP flag for parallelism

# Source files
SRC_SERIAL = main_process.c png_util.c  # Original serial source files
SRC_OPTIMIZED = main_process_optimized.c png_util.c  # Optimized serial source files
SRC_OPENMP = main_process_parallel.c png_util.c  # OpenMP parallel source files

# Object files
OBJ_SERIAL = $(SRC_SERIAL:.c=.o)
OBJ_OPTIMIZED = $(SRC_OPTIMIZED:.c=.o)
OBJ_OPENMP = $(SRC_OPENMP:.c=.o)

# Target: all
all: serial optimized_serial parallel

# Serial Implementation (Original version)
serial: $(OBJ_SERIAL)
	$(CC) -o serial $(OBJ_SERIAL) $(LIBS)

# Optimized Serial Implementation (Add optimization flags)
optimized_serial: CFLAGS += $(OPT_FLAGS)  # Add optimization flag
optimized_serial: $(OBJ_OPTIMIZED)
	$(CC) -o optimized_serial $(OBJ_OPTIMIZED) $(LIBS)

# Optimized OpenMP Implementation (Parallel version)
parallel: CFLAGS += $(OPENMP_FLAGS)  # Add OpenMP flag for parallelism
parallel: $(OBJ_OPENMP)
	$(CC) -o parallel $(OBJ_OPENMP) $(LIBS)

# Object files for serial
serial_process.o: main_process.c
	$(CC) $(CFLAGS) main_process.c

# Object files for optimized serial
optimized_serial_process.o: main_process_optimized.c
	$(CC) $(CFLAGS) main_process_optimized.c

# Object files for OpenMP parallel
parallel_process.o: main_process_parallel.c
	$(CC) $(CFLAGS) main_process_parallel.c

# Object files for png_util (common to all)
png_util.o: png_util.c
	$(CC) $(CFLAGS) png_util.c

# Test Execution (for all implementations)
test: serial optimized_serial parallel
	./serial ./images/cube.png test_serial.png
	./optimized_serial ./images/cube.png test_optimized_serial.png
	./parallel ./images/cube.png test_parallel.png

# Clean up object files and executables
clean:
	rm -f *.o serial optimized_serial parallel
