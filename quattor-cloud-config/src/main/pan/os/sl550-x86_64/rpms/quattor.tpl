#
# Packages provided by the OS needed for a quattor client.
# Included by quattor/rpms.
#
template rpms/quattor;

"/software/packages"=pkg_repl("perl-Compress-Zlib","1.42-1.fc6",PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("perl-DBI","1.52-2.el5",PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("perl-Proc-ProcessTable","0.41-1.el5.rf",PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("perl-Crypt-SSLeay","0.51-11.el5",PKG_ARCH_DEFAULT);
"/software/packages"=pkg_repl("perl-IO-String","1.08-1.1.1","noarch");
"/software/packages"=pkg_repl("perl-XML-Simple","2.14-4.fc6","noarch");
