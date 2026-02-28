###############################################################################
# File:                  Makefile
# Process Name:          makencdc
# Functionality:         Sets up required directories and compiles source code
# Author:                David Unger
# Date Makefile created: 2014-06-02
#  All routines compiled together here.
###############################################################################

#------------------------------------------------------------------------------
# Variables
#
PGM1 = mkcdprelim
PGM2 = mkcdlong
PGM3 = transcdfd
PGM4 = appendhalf
PGM5 = adjncdc
PGM6 = updthalf
PGM7 = updtncdcstats
PGM8 = makencdc
BUILDDIR    = ./build
INPUTDIR    = ./input
LOGSDIR     = ./logs 
WORKDIR     = ./work 
SOURCEDIR   = ./sources
#  Modules and routines, order matters, Modules first, in order of /use
#   NOTE  ORDER MATTERS! Modules must be compiled before they are used by other modules
SOURCEFILES = $(SOURCEDIR)/ControlConstants.f90  \
              $(SOURCEDIR)/CalOps.f90 \
              $(SOURCEDIR)/NcdcDiv.f90 \
              $(SOURCEDIR)/Fileops.f90 \
              $(SOURCEDIR)/EwmaBc.f90 \
              $(SOURCEDIR)/AlaskaEst.f90 \
#------------------------------------------------------------------------------ls
# Compiler Settings  The -ffree-form option removes FORTRAN column dependency
#                    The -J option directs the compiler to put the module instructions in 
#                     another directory.
#
COMPILER      = f95
COMPILERFLAGS = -ffree-form -J${BUILDDIR}

# Make required directories
mkdirs:
	mkdir -p $(BUILDDIR) $(INPUTDIR) $(LOGSDIR) $(WORKDIR)
# Clean (will delete directories created by mkdirs rule!)
clean:
	rm -rf $(BUILDDIR) $(INPUTDIR) $(LOGSDIR) $(WORKDIR)
#------------------------------------------------------------------------------
compile:
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM1}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM1}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM2}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM2}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM3}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM3}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM4}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM4}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM5}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM5}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM6}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM6}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM7}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM7}.x
	${COMPILER} ${COMPILERFLAGS} ${SOURCEFILES} ${SOURCEDIR}/${PGM8}.f -I ${BUILDDIR} -o $(BUILDDIR)/${PGM8}.x

