# Template to update Subversion client to 1.6.x

template config/os/svn_client-1.6;

variable SUBVERSION_PKG_VERSION = '1.6.16-1';
variable APR_VERSION ?= '1.3.9-3.el6';
variable APR_UTIL_VERSION ?= '1.3.9-3.el6';
variable NEON_VERSION ?= '0.29.3-1.2.el6';
variable SQLITE_VERSION ?= '3.6.20-1.el6';
#variable PYSVN_VERSION ?= '';


# SVN dependencies provided by the OS
"/software/packages"=pkg_repl("apr",APR_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("apr-util",APR_UTIL_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("apr-devel",APR_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("apr-util-devel",APR_UTIL_VERSION,PKG_ARCH_DEFAULT);

"/software/packages"=pkg_repl('db4-devel','4.7.25-16.el6','x86_64');
"/software/packages"=pkg_repl('expat-devel','2.0.1-9.1.el6','x86_64');
"/software/packages"=pkg_repl('openldap-devel','2.4.19-15.el6','x86_64');
"/software/packages"=pkg_repl('gnutls-devel','2.8.5-4.el6','x86_64');

"/software/packages"=pkg_repl('db4-cxx','4.7.25-16.el6','x86_64');
"/software/packages"=pkg_repl('libgcrypt-devel','1.4.5-3.el6','x86_64');
"/software/packages"=pkg_repl('libgpg-error-devel','1.7-3.el6','x86_64');
"/software/packages"=pkg_repl('cyrus-sasl-devel','2.1.23-8.el6','x86_64');

# Remove conflicting packages from old versions
"/software/packages"=pkg_del('cadaver');
"/software/packages"=pkg_del('subversion-javahl');
"/software/packages"=pkg_del('py24_pysvn_svn142');

# Reapply OS RPM updates.
# Be sure to do it before adding SVN-specific versions of some
# dependencies and the specific SVN version added here.
include { 'config/os/updates' };

# SVN dependencies with non standard versions.
# Ensure this is done after applying the OS updates.
"/software/packages"=pkg_repl("neon",NEON_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("neon-devel",NEON_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("sqlite",SQLITE_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("sqlite-devel",SQLITE_VERSION,PKG_ARCH_DEFAULT);

# Add PySVN (Python SVN API)
#"/software/packages"=pkg_repl("py24_pysvn_svn165","1.7.0-0","x86_64");

# Add SVN client.
# Ensure this is done after applying the OS updates.
"/software/packages"=pkg_repl("subversion",SUBVERSION_PKG_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("subversion-devel",SUBVERSION_PKG_VERSION,PKG_ARCH_DEFAULT);
#"/software/packages"=pkg_repl("subversion-python",SUBVERSION_PKG_VERSION,PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("subversion-perl",SUBVERSION_PKG_VERSION,PKG_ARCH_DEFAULT);
#"/software/packages"=pkg_repl("subversion-tools",SUBVERSION_PKG_VERSION,PKG_ARCH_DEFAULT);

"/software/packages"=pkg_ronly("mod_dav_svn",SUBVERSION_PKG_VERSION,PKG_ARCH_DEFAULT);
