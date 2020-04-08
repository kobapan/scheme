# General info
SHELL       = /bin/sh
prefix      = /usr/local
exec_prefix = ${prefix}
bindir      = ${exec_prefix}/bin
libdir      = ${exec_prefix}/lib
datadir     = ${datarootdir}
datarootdir = ${prefix}/share
srcdir      = .
VPATH       = $(srcdir)

# These may be overridden by make invocators
DESTDIR        =
GOSH           = "/usr/local/bin/gosh"
GAUCHE_CONFIG  = "@GAUCHE_CONFIG@"
GAUCHE_PACKAGE = "@GAUCHE_PACKAGE@"
INSTALL        = "/usr/local/bin/gauche-install" -C

# Other parameters
LOCAL_PATHS = ""

# Module-specific stuff
PACKAGE   = Gauche-htmlprag
SCMFILES  = $(srcdir)/htmlprag.scm

GENERATED =
CONFIG_GENERATED = Makefile config.cache config.log config.status \
		   configure.lineno autom4te*.cache $(PACKAGE).gpd

GAUCHE_PKGLIBDIR  = "$(DESTDIR)${datadir}/gauche-0.9/site/lib"

all : $(TARGET)

check : all
	@rm -f test.log
	$(GOSH) -I. -I$(srcdir) $(srcdir)/test.scm > test.log

install : all
	$(INSTALL) -m 444 -T $(GAUCHE_PKGLIBDIR) $(SCMFILES)
	$(INSTALL) -m 444 -T $(GAUCHE_PKGLIBDIR)/.packages $(PACKAGE).gpd

uninstall :
	$(INSTALL) -U $(GAUCHE_PKGLIBDIR) $(SCMFILES)
	$(INSTALL) -U $(GAUCHE_PKGLIBDIR)/.packages $(PACKAGE).gpd

clean :
	rm -rf core $(TARGET) $(GENERATED) *~ test.log so_locations

distclean : clean
	rm -rf $(CONFIG_GENERATED)

maintainer-clean : clean
	rm -rf $(CONFIG_GENERATED) configure VERSION

