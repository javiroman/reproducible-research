#!/usr/bin/env python
"""
setup_vim.py - Utility for setting up my personal vim settings.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
version 3 as published by the Free Software Foundation.

(c) 2015 Javi Roman <jroman.espinar@gmail.com>
"""
import optparse
import sys
import os
import urllib
import select
import traceback
import subprocess
import errno

__version__ = "0.0.1"

# Python sanity check: program tested for: 2.5.2,
if sys.hexversion < 0x020400F0:
    print "Sorry, python 2.4 or later is required " \
        "for this version of personal vim installer"
    sys.exit(1)

# minimal tools sanity check
minimal_tools = ("git", "svn", "wget")


def which(path, exefile):
    """
    Locate a file in a PATH
    """
    for p in (path or "").split(':'):
        next = os.path.join(p, exefile)
        if os.path.exists(next):
            return next

    return ""


def rmdir(d):
    """
    Recursively remove a top directory
    """
    for path in (os.path.join(d, f) for f in os.listdir(d)):
        if os.path.isdir(path):
            rmdir(path)
        else:
            os.unlink(path)

    os.rmdir(d)


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError, exc:
        if exc.errno == errno.EEXIST:
            pass
        else:
            raise


def symlink_f(src, dest):
    try:
        os.symlink(src, dest)
    except OSError, exc:
        if exc.errno == errno.EEXIST:
            pass
        else:
            raise


def printColored(type):
    CSI = "\x1B["
    colors = {"OK": "31;92m", "ERROR": "31;40m", "WARNING": "31;93m",
              "INFO": "31;92m"}
    sys.stdout.write(CSI + colors[type] + "[" + type + "] " + CSI + "0m")

# strings
BSPTXT = "http://amebasystems.googlecode.com/svn/asBSP/bsp.txt"

AMEBA_VERSION = "http://amebasystems.googlecode.com/svn/asBSP/%s\
/trunk/local_overlay/recipes/ameba-version/files/ameba_version"

BB_GIT_URL = "git://git.openembedded.net/bitbake bitbake"
OE_GIT_URL = "git://git.openembedded.net/openembedded openembedded"
AS_SVN_URL = "http://amebasystems.googlecode.com/svn/asBSP/%s/trunk" \
             "/local_overlay"

BANNER = """
__     ___
\ \   / (_)_ __ ___
 \ \ / /| | '_ ` _ \ Personal
  \ V / | | | | | | |
   \_/  |_|_| |_| |_|
"""


class AppAmebaInstaller():
    def __init__(self):
        self.options = None
        self.revisions = {}
        self._parse_args()

    def _parse_args(self):
        usage = "usage: %prog [options]"
        version = "Ameba Installer version %s" % __version__

        parser = optparse.OptionParser(usage=usage, version=version)
        parser.add_option("-b", "--bsp",
                          dest="as_bsp",
                          help="AmebaSystems BSP to install, list with -l")
        parser.add_option("-f", "--force",
                          dest="force",
                          help="overwrite working copies [all | bb | oe | as]")
        parser.add_option("-v", "--verbose",
                          action="store_true",
                          dest="verbose",
                          help="set verbosity output")
        parser.add_option("--list-targets", "-l",
                          action="callback",
                          callback=self._list_targets,
                          help="display availables AmebaSystems BSP targets")

        (self.options, args) = parser.parse_args()

        if (self.options.verbose or self.options.force) \
                and not self.options.as_bsp:
            parser.error("Verbosity must be enable with -b option")

        if self.options.verbose:
            print "Verbose output enabled"

        if len(sys.argv) == 1:
            print BANNER
            parser.print_help()
            sys.exit(1)

    def _get_urlfile(self, urlfile):
        p = select.poll()
        fd_obj = urllib.urlopen(urlfile)
        p.register(fd_obj, select.POLLIN |
                   select.POLLERR |
                   select.POLLHUP |
                   select.POLLNVAL)
        result = p.poll(10)
        for fd, event in result:
            if event == select.POLLIN:
                return fd_obj.readlines()

    def _list_targets(self, option, opt_str, vale, parser):
        usual_targets = ["asv1-alix6b2", "asv1-beagleboard",
                         "asv1-epiam10000",
                         "asv1-freerunner"]
        try:
            print "Available targets:\n"
            for i in self._get_urlfile(BSPTXT):
                print i.split()
            print "\n"
        except:
            traceback.print_exc(file=sys.stdout)
            printColored("ERROR")
            print "Transitory network problem, hmm!"
            print "Anyway, a list of usual targets:\n"
            for i in usual_targets:
                print i
            print "\n"

        print "Example:"
        print "\t./ameba_installer.py -b asv1-beagleboard"
        sys.exit(1)

    def _force_folder(self, folder, forced_type):
        if os.path.exists(folder):
            printColored("WARNING")
            print "%s woking copy exists" % folder
            if self.options.force == "all" or self.options.force == forced_type:
                print "forced overwriting %s copy ..." % folder
                rmdir(folder)
                return 1
            else:
                print "you can force overwriting with --force"
                print "jumping to the next step\n"
                return 0
        else:
            return 1

    def _set_local_conf(self):
        """FIME: this conditional is not elegant
           we have to refactoring this snip of code
        """
        BUILD_ARCH = "BUILD_ARCH = \"%s\"" % os.uname()[-1]
        MACHINE = self.revisions["AS_BSP"].split("-")[1]
        if MACHINE == "beetlepos":
            FINAL_MACHINE = "MACHINE = beetlepos"
            DISTRO = "DISTRO = beetlepos-distro"
        else:
            FINAL_MACHINE = "MACHINE = \"ameba-%s\"" % self.\
                revisions["AS_BSP"].split("-")[1]
            DISTRO = "DISTRO = ameba-distro"

        local_conf = [FINAL_MACHINE,
                      DISTRO,
                      BUILD_ARCH,
                      '#PARALLEL_MAKE = "-j 8"',
                      'IMAGE_KEEPROOTFS = "1"',
                      '#BB_NUMBER_THREADS = "8"',
                      '#INHERIT += "rm_work"']

        return local_conf

    def getRevisions(self):
        print BANNER

        urlfile = (AMEBA_VERSION) % self.options.as_bsp
        if self.options.verbose:
            print "Varibles from:"
            print urlfile
        try:
            ret = self._get_urlfile(urlfile)
            self.revisions["OE_HEAD"] = ret[0].split('=')[1].strip()
            self.revisions["BB_HEAD"] = ret[1].split('=')[1].strip()
            self.revisions["AS_BSP"] = ret[2].split('=')[1].strip()
            self.revisions["AS_REV"] = ret[3].split('=')[1].strip()
            if self.options.verbose:
                print self.revisions

        except:
            traceback.print_exc(file=sys.stdout)

    def setupBitbake(self):
        printColored("INFO")
        print "Setting up of bitbake version -> %s\n" % self.\
            revisions["BB_HEAD"]

        if not self._force_folder("bitbake", "bb"):
            return

        cmd = "git clone %s" % BB_GIT_URL
        print "raising command: [%s]" % cmd

        while True:
            pipe = subprocess.Popen(cmd, shell=True)
            pipe.wait()
            if not pipe.returncode:
                break
            printColored("WARNING")
            print "... trying again"

        cmd = "git checkout -b branch-%s %s" % \
            (self.revisions["BB_HEAD"], self.revisions["BB_HEAD"])

        print "raising command: [%s]" % cmd
        pipe = subprocess.Popen(cmd, shell=True, cwd="bitbake")
        pipe.wait()

        print "Bitbake setting up done with success.\n"

    def setupOpenEmbedded(self):
        printColored("INFO")
        print "Setting up of OE version -> %s\n" % self.revisions["OE_HEAD"]

        if not self._force_folder("openembedded", "oe"):
            return

        cmd = "git clone -n %s" % OE_GIT_URL
        print "raising command: [%s]" % cmd

        while True:
            pipe = subprocess.Popen(cmd, shell=True)
            pipe.wait()
            if not pipe.returncode:
                break
            printColored("WARNING")
            print "... trying again"

        # TODO: this command fails with git version 1.6.0.3
        cmd = "git checkout %s" % self.revisions["OE_HEAD"]
        print "raising command: [%s]" % cmd
        pipe = subprocess.Popen(cmd, shell=True, cwd="openembedded")
        pipe.wait()

        print "Openembedded setting up done with success.\n"

    def setupBSP(self):
        printColored("INFO")
        print "Setting up of Ameba BSP (%s) version -> %s\n" % \
              (self.revisions["AS_BSP"], self.revisions["AS_REV"])

        if not self._force_folder(self.revisions["AS_BSP"], "as"):
            return

        os.mkdir(self.revisions["AS_BSP"])

        url_repo = AS_SVN_URL % self.revisions["AS_BSP"]
        cmd = "svn co -r %s %s" % \
              (self.revisions["AS_REV"], url_repo)
        print "raising command: [%s]" % cmd

        while True:
            pipe = subprocess.Popen(cmd, shell=True,
                                    cwd=self.revisions["AS_BSP"])
            pipe.wait()
            if not pipe.returncode:
                break
            printColored("WARNING")
            print "... trying again"

    def setupEnv(self):
        printColored("INFO")
        print "Setting up setup-env file"

        ASDIR = "export ASDIR=\"%s\"" % os.getcwd()
        setup_env = ['export BB_ENV_EXTRAWHITE="ASDIR TERMCMD"',
                     ASDIR,
                     'export BBPATH="${ASDIR}/local:${ASDIR}/build:\
                     ${ASDIR}/openembedded"',
                     'export PYTHONPATH="${ASDIR}/bitbake/libbitbake"',
                     'export PATH="${ASDIR}/bitbake/bin:${PATH}"',
                     'export TERMCMD="xterm"']

        if self.options.verbose:
            print setup_env

        file = open("setup-env", 'w')
        for i in setup_env:
            file.write(i + "\n")

        file.close()

    def setupSiteConf(self):
        printColored("INFO")
        print "Setting up site.conf file"

        mkdir_p("build/conf")

        local_conf = self._set_local_conf()

        if self.options.verbose:
            print local_conf

        file = open("build/conf/local.conf", 'w')
        for i in local_conf:
            file.write(i + "\n")

        file.close()

        src = "../../%s/local_overlay/conf/site.conf" % self.revisions["AS_BSP"]
        symlink_f(src, "build/conf/site.conf")

        src = "%s/local_overlay/" % self.revisions["AS_BSP"]
        symlink_f(src, "local")


def main():
    # tools sanity check
    for exefile in minimal_tools:
        if not which(os.getenv("PATH"), exefile):
            print "sorry, you have to install %s utility" % exefile
            sys.exit(1)

    inst = AppAmebaInstaller()

    inst.getRevisions()
    inst.setupBitbake()
    inst.setupOpenEmbedded()
    inst.setupBSP()
    inst.setupEnv()
    inst.setupSiteConf()

    print "AmebaSystems OE based distro was set with success!"

if __name__ == "__main__":
        sys.exit(main())

# vim: ts=4:sw=4:et:sts=4:ai:tw=80
