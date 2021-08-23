# Compile Tools

`compile_tools` are a series of make scripts that allow some fundamental tools to be built from source code on a linux system without access to the sudo privileges.

The use of make file allows the flow to run on a dependency tracked flow.  If one tool needs another tool or library installed, this will also be downloaded, compiled and installed to allow its dependency to be available for the main build.

# Basic operation

Using make you can compile tools just using a make command and the tool in question:

    make python
    make iverilog
    make verible
    make verilator
    make pandoc

This will compile a verison of the tool, usually a hard coded version in the respective make file.  If one wants to build a different version of the tool, you can change the version in the file or pass it as a make argument.

    make python PYTHON_REV=v3.10.8
    
(in the case if python the rev used it the release tag string from the github repo)

# Make clean

Most tool build have a clean option.  If you have already installed a tool and want to recompile it, the install directory has to be removed that that the make flow will rebuild.

    make python_clean
    
This command deletes the install directory for the current version of python on the system.

# System version of tools

By default, the scripts use the system development tools (that which is install with the base operation system). Rocky8.5, for example has a default GCC install of 8.5.0.  As of the time of this writing, that is quite old, with is currently up to 12.1.0.  If one wants to compile and used a newer version of GCC, there is a make file to build GCC present.  However use it, via the make flow, one needs to make sure that the system variable SYSTEM_GCC is set to 0:

    make python PYTHON_REV=v3.10.8 SYSTEM_GCC=0 GCC_REV=12.1.0

or set it explictly in the makefile.

This will first check to see if that version of GCC has already been installed, if not it will compile and install it, before moving onto the python compile. (warning a GCC compile can take the guts of 4 hours).

Other tools that can be system and recompiled localy are, `make, git, bash, curl, perl` and `python` and they can be set by the command line argument (as above) or explictly set in the make file:

    SYSTEM_GCC     ?= 1
    SYSTEM_MAKE    ?= 1
    SYSTEM_GIT     ?= 1
    SYSTEM_BASH    ?= 1
    SYSTEM_CURL    ?= 1
    SYSTEM_PERL    ?= 1
    SYSTEM_PYTHON  ?= 1

