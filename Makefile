# This is a bit of a mess.  Work with Makefile.std instead.

CFLAGS=-Wall -O2
BLASFLAGS=-L/usr/lib64/atlas -llapack -lcblas -latlas
BLASFLAGS64=-L/usr/lib64/atlas -llapack -lcblas -latlas
LINKFLAGS=-lm -lpthread
ZLIB=zlib-1.2.8/libz.so.1.2.8
ARCH64=-arch x86_64

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
BLASFLAGS=-framework Accelerate
BLASFLAGS64=-framework Accelerate
LINKFLAGS=
ZLIB=zlib-1.2.8/libz.a
ZLIB64=zlib-1.2.8/libz-64.a
else
ifeq ($(UNAME), MINGW32_NT-6.2)
ARCH64=
BLASFLAGS=-Wl,-Bstatic -L. lapack/liblapack.a -L. lapack/librefblas.a
BLASFLAGS64=-Wl,-Bstatic -L. lapack/liblapack-64.a -L. lapack/librefblas-64.a
LINKFLAGS=-lm -static-libgcc
ZLIB=zlib-1.2.8/libz.a
ZLIB64=zlib-1.2.8/libz-64.a
endif
endif

SRC = wdist.c wdist_assoc.c wdist_calc.c wdist_cluster.c wdist_cnv.c wdist_common.c wdist_data.c wdist_dosage.c wdist_help.c wdist_homozyg.c wdist_lasso.c wdist_matrix.c wdist_stats.c SFMT.c dcdflib.c pigz.c yarn.c

OBJ = $(SRC:.c=.o)

%.o: %.c
	g++ -c $(CFLAGS) $(ARCH64) -o $@ $<

wdist: $(SRC)
	g++ $(CFLAGS) $(SRC) -o wdist $(BLASFLAGS) $(LINKFLAGS) -L. $(ZLIB)

wdistw: $(SRC)
	g++ $(CFLAGS) $(SRC) -c
	gfortran -O2 $(OBJ) -o wdist $(BLASFLAGS) $(LINKFLAGS) -L. $(ZLIB)

wdistc: $(SRC)
	gcc $(CFLAGS) $(SRC) -o wdist $(BLASFLAGS) $(LINKFLAGS) -L. $(ZLIB)

wdists: $(SRC)
	g++ $(CFLAGS) $(SRC) -o wdist_linux_s -Wl,-Bstatic $(BLASFLAGS) -Wl,-Bdynamic $(LINKFLAGS) -L. $(ZLIB)

wdistd: $(SRC)
	g++ $(CFLAGS) $(SRC) -o wdist_linux $(BLASFLAGS) -Wl,-Bdynamic $(LINKFLAGS) -L. $(ZLIB)

wdistnl: $(SRC)
	g++ $(CFLAGS) $(SRC) -o wdist $(LINKFLAGS) -Wl,-Bstatic -L. $(ZLIB)

wdist64: $(OBJ)
	g++ $(CFLAGS) $(ARCH64) $(OBJ) -o wdist $(BLASFLAGS64) $(LINKFLAGS) -L. $(ZLIB64)
# for clean build, "make clobber" first

wdist64w: $(SRC)
	g++ $(CFLAGS) $(ARCH64) $(SRC) -c
	gfortran -O2 $(OBJ) -o wdist64 $(BLASFLAGS64) $(LINKFLAGS) -L. $(ZLIB64)

wdist64c: $(SRC)
	gcc $(CFLAGS) $(ARCH64) $(SRC) -o wdist $(BLASFLAGS64) $(LINKFLAGS) -L. $(ZLIB64)

wdist64nl: $(SRC)
	g++ $(CFLAGS) $(ARCH64) $(SRC) -o wdist $(LINKFLAGS) -L. $(ZLIB64)

pigz_test: pigz_test.c pigz.c yarn.c
	g++ -Wall -arch x86_64 -O2 pigz_test.c pigz.c yarn.c -o pigz_test -L. $(ZLIB64)

prettify: prettify.c
	gcc -Wall -arch x86_64 -O2 prettify.c -o prettify

prettifyw: prettify.c
	gcc -Wall -O2 prettify.c -o prettify

prettify64w: prettify.c
	gcc -Wall -O2 prettify.c -o prettify64

clobber:
	rm -f *.o
