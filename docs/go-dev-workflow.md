# What is Go

Three foundations:

1. Go Language
2. Go Libraries
3. Go Tools

# Google pattner workflow for Go Lang

https://golang.org/doc/code.html

# About Go Tools

Go tools are packages and tools that support the Go programming language.
Some of the tools are included in binary Go distributions.  Others can be 
fetched with "go get".

Go also comes with the go tool, a sophisticated but simple-to-use command
for managing workspaces of Go packages (download, build, and run programs).

Go command-line interface uses the ‘‘Swiss army knife’’ style, with over a
dozen subcommands. 

# Go Workspace

Go programs must be kept in a directory hierarchy called a workspace, which is
simply a root directory of the Go programs.  A workspace contains three 
subdirectories at its root:

1. root src: This directory contains Go source files organized into packages.
   (all the Go source code organized by import path).
2. packages pkg: This directory contains Go package objects (contains the
   compiled versions of the available libraries so the compiler can link against
   them without recompiling them.)
3. objects bin: This directory contains executable commands (executable
programs).

Go source files are organized into directories called packages, in which 
a single directory is used for a single package. You can write two types 
of packages in Go:

1. Go Packages resulting in executable programs
2. programs Packages resulting in a shared library

The Go tool builds Go packages and installs the resulting binaries into the pkg
directory if it is a shared library, and into the bin directory if it is an 
executable program.

When starting a new program or library, it is recommended to do so inside
the src folder, using a fully qualified path (for instance: github.com/<your
username>/<project name>)

The Go tool understands the layout of a workspace. You don't need a Makefile. 
The file layout is everything. Change the file layout, change the build.
```
$GOPATH/
    src/
        github.com/user/repo/
            mypkg/
                mysrc1.go
                mysrc2.go
            cmd/mycmd/
                main.go
    bin/
        mycmd
```

# GOPATH

You write Go programs in the workspace, which you should manually specify so
that Go runtime knows the workspace location. You can set the workspace 
location by using the GOPATH environment variable. So the only configuration 
most users ever need is the GOPATH environment variable, which specifies 
the root of the workspace. When switching to a different workspace, 
users update the value of GOPATH.

You write Go programs as packages into the GOPATH src directory. A single
directory is used for a single package. Go is designed to easily work with 
remote repositories such as GitHub and Google Code. When you maintain your 
programs in a remote source repository, use the root of that source repository 
as your base path.  

Note: For example, if you have a GitHub account at github.com/user, it should
be your base path. Let’s say you write a package named "mypackage" at 
github.com/user; your code organization path will be at 
${GOPATH}/src/github.com/user/mypackage. When you import this package to other
programs, the path for importing the package will be github.com/user/mypackage. 
If you maintain the source in your local system, you can directly write programs 
under the GOPATH src directory. Suppose that you write a package named mypackage 
on a local system; your code organization path will be at ${GOPATH}/src/mypackage, 
and the path for importing the package will be mypackage.

Notes about GOPATH and GOROOT:
https://dave.cheney.net/2013/06/14/you-dont-need-to-set-goroot-really

GOROOT is the second most important environment variable: specifies the root
directory of the Go distribution, which provides all the packages of the 
standard library. The director y structure beneath GOROOT resembles that of 
GOPATH , so, for example, the source files of the fmt package reside in
the $GOROOT/src/fmt directory. Users never need to set GOROOT since, by default,
the go tool will use the location where it was installed.

The "go env" command prints the effective values of the environment variables
relevant to the toolchain, including the default values for the missing ones. 
GOOS specifies the target operating system (for example, android , linux , 
darwin , or windows ) and GOARCH specifies the target processor architecture, 
such as amd64 , 386 , or arm . Although GOPATH is the only variable you must set.

# Go Version Manager - GVM

GVM provides an interface to manage Go versions.

https://github.com/moovweb/gvm

## GVM Installation
```
$ bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
$ source ~/.gvm/scripts/gvm
$ gvm version
Go Version Manager v1.0.22 installed at ...
```

```
$ gvm
Usage: gvm [command]

Description:
  GVM is the Go Version Manager

Commands:
  version    - print the gvm version number
  get        - gets the latest code (for debugging)
  use        - select a go version to use (--default to set permanently)
  diff       - view changes to Go root
  help       - display this usage text
  implode    - completely remove gvm
  install    - install go versions
  uninstall  - uninstall go versions
  cross      - install go cross compilers
  linkthis   - link this directory into GOPATH
  list       - list installed go versions
  listall    - list available versions
  alias      - manage go version aliases
  pkgset     - manage go packages sets
  pkgenv     - edit the environment for a package set
```

## GVM Installing Go versions
```
$ gvm listall
$ gvm install go1.7.3 -B
Installing go1.7.3 from binary source
```

```
$ gvm list
gvm gos (installed)
   go1.7.3
   system
```

```
$ gvm use go1.7.3
Now using version go1.7.3
```

```
$ which go
~/.gvm/gos/go1.7.3/bin/go
```

```
$ gvm use system
Now using version system
```

```
$ which go
/usr/lib/golang/bin/go
$ go env
...
GOPATH="${HOME}/.gvm/pkgsets/go1.7.3/global"
...
```

```
$ gvm use go1.7.3 --default
Now using version go1.7.3
```

```
$ gvm list
gvm gos (installed)
=> go1.7.3
   system
```

## GVM Configure Your Golang Workspace

So now we have a local version of go installed, our GOPATH and PATH are setup,
and we have access to the go executable. Now what? One of the neat things about
gvm is the notion of pkgsets, basically allowing you to define separate
"workspaces" and group a set of go projects using the same go version.

A package set is a dedicated $GOPATH, nothing much more.

Let's create a pkgset called "example".

```
$ gvm pkgset create example
$ gvm pkgset list
gvm go package sets (go1.7.3)
    example
=>  global

$ gvm pkgset use example
$ gvm pkgset use example --default
```
If we inspect our GOPATH and PATH, we can see that they have been updated to
reflect our pkgset location: ~/..gvm/pkgsets/go1.7.3/example

However, let's setup another location for our code, for example $HOME/src/go.

```
$ mkdir -p ~/src/go/{bin,pkg,src}
```

Now that we have the proper folder structure for go, we'll need to update our
environment. We could manually set GOPATH and PATH to be prefixed with our new
src directory, but there's a better way. We'll use the gvm pkgenv command with
our fresh work pkgset so that our new workspace will always be found in GOPATH.

Example:
```
# original line
export GOPATH; GOPATH="/Users/james/.gvm/pkgsets/go1.2/ottemo:$GOPATH"
# ---> new edited line
export GOPATH; GOPATH="/Users/james/.gvm/pkgsets/go1.2/ottemo:$HOME/go:$GOPATH"
# original line
export PATH; PATH="/Users/james/.gvm/pkgsets/go1.2/ottemo/bin:${GVM_OVERLAY_PREFIX}/bin:${PATH}"
# ---> new edited line
export PATH; PATH="/Users/james/.gvm/pkgsets/go1.2/ottemo/bin:${GVM_OVERLAY_PREFIX}/bin:$HOME/go/bin:${PATH}"
```

```
$ gvm pkgenv work
```

# Go Vendoring

Take a look to this good explanation:

https://blog.gopheracademy.com/advent-2015/vendor-folder/

# Go Code Organization

https://talks.golang.org/2014/organizeio.slide#1





