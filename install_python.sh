#!/bin/bash

yum -y groupinstall "Development Tools"

yum install wget zlib-devel bzip2-devel openssl-devel sqlite-devel readline-devel libffi-devel -y 

wget ftp://10.36.145.100/Packages/Python-3.7.4.tar.xz 

tar xf Python-3.7.4.tar.xz -C /opt && rm -rf Python-3.7.4.tar.xz

cd /opt/Python-3.7.4

cat<<-EOF >/opt/Python-3.7.4/Modules/Setup.dist
DESTLIB=$(LIBDEST)
MACHDESTLIB=$(BINLIBDEST)
DESTPATH=
SITEPATH=
TESTPATH=
COREPYTHONPATH=$(DESTPATH)$(SITEPATH)$(TESTPATH)
PYTHONPATH=$(COREPYTHONPATH)
posix -DPy_BUILD_CORE posixmodule.c     # posix (UNIX) system calls
errno errnomodule.c                     # posix (UNIX) errno values
pwd pwdmodule.c                         # this is needed to find out the user's home dir
                                        # if $HOME is not set
_sre _sre.c                             # Fredrik Lundh's new regular expressions
_codecs _codecsmodule.c                 # access to the builtin codecs and codec registry
_weakref _weakref.c                     # weak references
_functools -DPy_BUILD_CORE _functoolsmodule.c   # Tools for working with functions and callable objects
_operator _operator.c                   # operator.add() and similar goodies
_collections _collectionsmodule.c       # Container types
_abc _abc.c                             # Abstract base classes
itertools itertoolsmodule.c             # Functions creating iterators for efficient looping
atexit atexitmodule.c                   # Register functions to be run at interpreter-shutdown
_signal -DPy_BUILD_CORE signalmodule.c
_stat _stat.c                           # stat.h interface
time -DPy_BUILD_CORE timemodule.c       # -lm # time operations and variables
_thread -DPy_BUILD_CORE _threadmodule.c # low-level threading interfac
_locale _localemodule.c  # -lintl
_io -DPy_BUILD_CORE -I$(srcdir)/Modules/_io _io/_iomodule.c _io/iobase.c _io/fileio.c _io/bytesio.c _io/bufferedio.c _io/textio.c _io/stringio.c
zipimport -DPy_BUILD_CORE zipimport.c
faulthandler faulthandler.c
_tracemalloc _tracemalloc.c hashtable.c
_symtable symtablemodule.c
SSL=/usr/local/ssl
_ssl _ssl.c \
        -DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
        -L$(SSL)/lib -lssl -lcrypto
xxsubtype xxsubtype.c
EOF

./configure --enable-shared

wait
echo '预编译成功'

make 
wait
echo '编译成功'

make install
wait
echo '安装成功'

echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib">>/etc/profile

echo "export /usr/local/lib">/etc/ld.so.conf.d/python3.conf

source /etc/profile

ldconfig
