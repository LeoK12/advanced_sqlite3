#!/usr/make
#
# Makefile for SQLITE
#
# This makefile is suppose to be configured automatically using the
# autoconf.  But if that does not work for you, you can configure
# the makefile manually.  Just set the parameters below to values that
# work well for your system.
#
# If the configure script does not work out-of-the-box, you might
# be able to get it to work by giving it some hints.  See the comment
# at the beginning of configure.in for additional information.
#

# The toplevel directory of the source tree.  This is the directory
# that contains this "Makefile.in" and the "configure.in" script.
#
TOP = .

# C Compiler and options for use in building executables that
# will run on the platform that is doing the build.
#
BCC = gcc  -g -O2

# TCC is the C Compile and options for use in building executables that 
# will run on the target platform.  (BCC and TCC are usually the
# same unless your are cross-compiling.)  Separate CC and CFLAGS macros
# are provide so that these aspects of the build process can be changed
# on the "make" command-line.  Ex:  "make CC=clang CFLAGS=-fsanitize=undefined"
#
CC = gcc
CFLAGS =   -g -O2 -DSQLITE_OS_UNIX=1
TCC = $(CC) $(CFLAGS) -I. -I${TOP}/src -I${TOP}/ext/rtree -I${TOP}/ext/fts3

# Define this for the autoconf-based build, so that the code knows it can
# include the generated config.h
# 
TCC += -D_HAVE_SQLITE_CONFIG_H -DBUILD_sqlite -DSQLITE_ENABLE_ATOMIC_WRITE -DSQLITE_ENABLE_WAL_CHECKPOINT_OPTIMIZATION


# Define -DNDEBUG to compile without debugging (i.e., for production usage)
# Omitting the define will cause extra debugging code to be inserted and
# includes extra comments when "EXPLAIN stmt" is used.
#
TCC += -DNDEBUG

# Compiler options needed for programs that use the TCL library.
#
TCC += -I/usr/local/include

# The library that programs using TCL must link against.
#
LIBTCL = -L/usr/local/lib -ltcl8.6

# Compiler options needed for programs that use the readline() library.
#
READLINE_FLAGS = -DHAVE_READLINE=0 

# The library that programs using readline() must link against.
#
LIBREADLINE = 

# Should the database engine be compiled threadsafe
#
TCC += -DSQLITE_THREADSAFE=1

# Any target libraries which libsqlite must be linked against
# 
TLIBS = -ldl -lpthread 

# Flags controlling use of the in memory btree implementation
#
# SQLITE_TEMP_STORE is 0 to force temporary tables to be in a file, 1 to
# default to file, 2 to default to memory, and 3 to force temporary
# tables to always be in memory.
#
TEMP_STORE = -DSQLITE_TEMP_STORE=1

# Enable/disable loadable extensions, and other optional features
# based on configuration. (-DSQLITE_OMIT*, -DSQLITE_ENABLE*).  
# The same set of OMIT and ENABLE flags should be passed to the 
# LEMON parser generator and the mkkeywordhash tool as well.
OPT_FEATURE_FLAGS = 

TCC += $(OPT_FEATURE_FLAGS)

# Add in any optional parameters specified on the make commane line
# ie.  make "OPTS=-DSQLITE_ENABLE_FOO=1 -DSQLITE_OMIT_FOO=1".
TCC += $(OPTS)

# Version numbers and release number for the SQLite being compiled.
#
VERSION = 3.8
VERSION_NUMBER = 3008009
RELEASE = 3.8.9

# Filename extensions
#
BEXE = 
TEXE = 

# The following variable is "1" if the configure script was able to locate
# the tclConfig.sh file.  It is an empty string otherwise.  When this
# variable is "1", the TCL extension library (libtclsqlite3.so) is built
# and installed.
#
HAVE_TCL = 1

# This is the command to use for tclsh - normally just "tclsh", but we may
# know the specific version we want to use
#
TCLSH_CMD = tclsh8.6

# Where do we want to install the tcl plugin
#
TCLLIBDIR = /usr/local/lib/tcl8.6/sqlite3

# The suffix used on shared libraries.  Ex:  ".dll", ".so", ".dylib"
#
SHLIB_SUFFIX = .so

# If gcov support was enabled by the configure script, add the appropriate
# flags here.  It's not always as easy as just having the user add the right
# CFLAGS / LDFLAGS, because libtool wants to use CFLAGS when linking, which
# causes build errors with -fprofile-arcs -ftest-coverage with some GCCs.  
# Supposedly GCC does the right thing if you use --coverage, but in 
# practice it still fails.  See:
#
# http://www.mail-archive.com/debian-gcc@lists.debian.org/msg26197.html
#
# for more info.
#
GCOV_CFLAGS1 = -DSQLITE_COVERAGE_TEST=1 -fprofile-arcs -ftest-coverage
GCOV_LDFLAGS1 = -lgcov
USE_GCOV = 0
LTCOMPILE_EXTRAS += $(GCOV_CFLAGS$(USE_GCOV))
LTLINK_EXTRAS += $(GCOV_LDFLAGS$(USE_GCOV))


# The directory into which to store package information for

# Some standard variables and programs
#
prefix = /usr/local
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib
pkgconfigdir = $(libdir)/pkgconfig
bindir = ${exec_prefix}/bin
includedir = ${prefix}/include
INSTALL = /usr/bin/install -c
LIBTOOL = ./libtool
ALLOWRELEASE = 

# libtool compile/link/install
LTCOMPILE = $(LIBTOOL) --mode=compile --tag=CC $(TCC) $(LTCOMPILE_EXTRAS)
LTLINK = $(LIBTOOL) --mode=link $(TCC) $(LTCOMPILE_EXTRAS)  $(LTLINK_EXTRAS)
LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)

# nawk compatible awk.
NAWK = gawk

# You should not have to change anything below this line
###############################################################################

USE_AMALGAMATION = 1

# Object files for the amalgamation.
#
LIBOBJS1 = sqlite3.lo

# Determine the real value of LIBOBJ based on the 'configure' script
#
LIBOBJ = $(LIBOBJS$(USE_AMALGAMATION))


# Source code to the test files.
#
TESTSRC = \
  $(TOP)/src/test1.c \
  $(TOP)/src/test2.c \
  $(TOP)/src/test3.c \
  $(TOP)/src/test4.c \
  $(TOP)/src/test5.c \
  $(TOP)/src/test6.c \
  $(TOP)/src/test7.c \
  $(TOP)/src/test8.c \
  $(TOP)/src/test9.c \
  $(TOP)/src/test_autoext.c \
  $(TOP)/src/test_async.c \
  $(TOP)/src/test_backup.c \
  $(TOP)/src/test_blob.c \
  $(TOP)/src/test_btree.c \
  $(TOP)/src/test_config.c \
  $(TOP)/src/test_demovfs.c \
  $(TOP)/src/test_devsym.c \
  $(TOP)/src/test_fs.c \
  $(TOP)/src/test_func.c \
  $(TOP)/src/test_hexio.c \
  $(TOP)/src/test_init.c \
  $(TOP)/src/test_intarray.c \
  $(TOP)/src/test_journal.c \
  $(TOP)/src/test_malloc.c \
  $(TOP)/src/test_multiplex.c \
  $(TOP)/src/test_mutex.c \
  $(TOP)/src/test_onefile.c \
  $(TOP)/src/test_osinst.c \
  $(TOP)/src/test_pcache.c \
  $(TOP)/src/test_quota.c \
  $(TOP)/src/test_rtree.c \
  $(TOP)/src/test_schema.c \
  $(TOP)/src/test_server.c \
  $(TOP)/src/test_superlock.c \
  $(TOP)/src/test_syscall.c \
  $(TOP)/src/test_stat.c \
  $(TOP)/src/test_tclvar.c \
  $(TOP)/src/test_thread.c \
  $(TOP)/src/test_vfs.c \
  $(TOP)/src/test_wsd.c       \
  $(TOP)/ext/fts3/fts3_term.c \
  $(TOP)/ext/fts3/fts3_test.c 

# Statically linked extensions
#
TESTSRC += \
  $(TOP)/ext/misc/amatch.c \
  $(TOP)/ext/misc/closure.c \
  $(TOP)/ext/misc/eval.c \
  $(TOP)/ext/misc/fileio.c \
  $(TOP)/ext/misc/fuzzer.c \
  $(TOP)/ext/misc/ieee754.c \
  $(TOP)/ext/misc/nextchar.c \
  $(TOP)/ext/misc/percentile.c \
  $(TOP)/ext/misc/regexp.c \
  $(TOP)/ext/misc/spellfix.c \
  $(TOP)/ext/misc/totype.c \
  $(TOP)/ext/misc/wholenumber.c

# Header files used by all library source files.
#
HDR = \
   $(TOP)/src/btree.h \
   $(TOP)/src/btreeInt.h \
   $(TOP)/src/hash.h \
   $(TOP)/src/hwtime.h \
   keywordhash.h \
   $(TOP)/src/msvc.h \
   $(TOP)/src/mutex.h \
   opcodes.h \
   $(TOP)/src/os.h \
   $(TOP)/src/os_common.h \
   $(TOP)/src/os_setup.h \
   $(TOP)/src/os_win.h \
   $(TOP)/src/pager.h \
   $(TOP)/src/pcache.h \
   parse.h  \
   $(TOP)/src/pragma.h \
   sqlite3.h  \
   $(TOP)/src/sqlite3ext.h \
   $(TOP)/src/sqliteInt.h  \
   $(TOP)/src/sqliteLimit.h \
   $(TOP)/src/vdbe.h \
   $(TOP)/src/vdbeInt.h \
   $(TOP)/src/vxworks.h \
   $(TOP)/src/whereInt.h \
   config.h

# Header files used by extensions
#
EXTHDR += \
  $(TOP)/ext/fts1/fts1.h \
  $(TOP)/ext/fts1/fts1_hash.h \
  $(TOP)/ext/fts1/fts1_tokenizer.h
EXTHDR += \
  $(TOP)/ext/fts2/fts2.h \
  $(TOP)/ext/fts2/fts2_hash.h \
  $(TOP)/ext/fts2/fts2_tokenizer.h
EXTHDR += \
  $(TOP)/ext/fts3/fts3.h \
  $(TOP)/ext/fts3/fts3Int.h \
  $(TOP)/ext/fts3/fts3_hash.h \
  $(TOP)/ext/fts3/fts3_tokenizer.h
EXTHDR += \
  $(TOP)/ext/rtree/rtree.h
EXTHDR += \
  $(TOP)/ext/icu/sqliteicu.h
EXTHDR += \
  $(TOP)/ext/rtree/sqlite3rtree.h

# This is the default Makefile target.  The objects listed here
# are what get build when you type just "make" with no arguments.
#
all:	sqlite3$(TEXE)

sqlite3$(TEXE):	$(TOP)/src/shell.c sqlite3.c sqlite3.h
	$(LTLINK) $(READLINE_FLAGS) \
		-o $@ $(TOP)/src/shell.c sqlite3.c \
		$(LIBREADLINE) $(TLIBS) -rpath "$(libdir)"

# Rules to build the 'testfixture' application.
#
# If using the amalgamation, use sqlite3.c directly to build the test
# fixture.  Otherwise link against libsqlite3.la.  (This distinction is
# necessary because the test fixture requires non-API symbols which are
# hidden when the library is built via the amalgamation).
#
TESTFIXTURE_FLAGS  = -DTCLSH=1 -DSQLITE_TEST=1 -DSQLITE_CRASH_TEST=1
TESTFIXTURE_FLAGS += -DSQLITE_SERVER=1 -DSQLITE_PRIVATE="" -DSQLITE_CORE 
TESTFIXTURE_FLAGS += -DBUILD_sqlite

TESTFIXTURE_SRC1 = sqlite3.c
TESTFIXTURE_SRC = $(TESTSRC) $(TOP)/src/tclsqlite.c
TESTFIXTURE_SRC += $(TESTFIXTURE_SRC$(USE_AMALGAMATION))

testfixture$(TEXE):	$(TESTFIXTURE_SRC)
	$(LTLINK) -DSQLITE_NO_SYNC=1 $(TEMP_STORE) $(TESTFIXTURE_FLAGS) \
		-o $@ $(TESTFIXTURE_SRC) $(LIBTCL) $(TLIBS)

clean:	
	rm -f *.lo *.la *.o sqlite3$(TEXE) libsqlite3.la
	rm -rf .libs .deps
	rm -f lemon$(BEXE) lempar.c sqlite*.tar.gz
	rm -f mkkeywordhash$(BEXE)
	rm -f *.da *.bb *.bbg gmon.out
	rm -rf quota2a quota2b quota2c
	rm -rf tsrc .target_source
	rm -f tclsqlite3$(TEXE)
	rm -f testfixture$(TEXE) test.db
	rm -f LogEst$(TEXE) fts3view$(TEXE) rollback-test$(TEXE) showdb$(TEXE)
	rm -f showjournal$(TEXE) showstat4$(TEXE) showwal$(TEXE) speedtest1$(TEXE)
	rm -f wordcount$(TEXE)
	rm -f sqlite3.dll sqlite3.lib sqlite3.exp sqlite3.def
	rm -f sqlite3rc.h
	rm -f shell.c sqlite3ext.h
	rm -f sqlite3_analyzer$(TEXE) sqlite3_analyzer.c
	rm -f sqlite-*-output.vsix
	rm -f mptester mptester.exe
	rm -fr *.db* *.txt *.tcl *.csv A BAR file test.* test1 test2 *.x testdb
