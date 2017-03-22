/*                                                                -*- C -*-
   +----------------------------------------------------------------------+
   | PHP Version 5                                                        |
   +----------------------------------------------------------------------+
   | Copyright (c) 1997-2007 The PHP Group                                |
   +----------------------------------------------------------------------+
   | This source file is subject to version 3.01 of the PHP license,      |
   | that is bundled with this package in the file LICENSE, and is        |
   | available through the world-wide-web at the following url:           |
   | http://www.php.net/license/3_01.txt                                  |
   | If you did not receive a copy of the PHP license and are unable to   |
   | obtain it through the world-wide-web, please send a note to          |
   | license@php.net so we can mail you a copy immediately.               |
   +----------------------------------------------------------------------+
   | Author: Stig Sæther Bakken <ssb@php.net>                             |
   +----------------------------------------------------------------------+
*/

/* $Id$ */

#define CONFIGURE_COMMAND " './configure'  '--prefix=/home/admin/php' '--exec-prefix=/home/admin/php' '--datadir=/home/admin/php/share' '--with-config-file-scan-dir=/home/admin/php/etc/php/conf.d' '--with-libdir=/home/admin/php/lib/php/' '--localstatedir=/var' '--disable-debug' '--with-regex=php' '--disable-rpath' '--disable-static' '--disable-posix' '--enable-calendar' '--enable-sysvsem' '--enable-sysvshm' '--enable-sysvmsg' '--enable-bcmath' '--enable-ctype' '--enable-exif' '--enable-ftp' '--enable-cli' '--enable-mbstring' '--enable-shmop' '--enable-sockets' '--enable-wddx' '--enable-soap' '--enable-zip' '--enable-opcache' '--enable-pdo' '--enable-ipv6' '--enable-fpm' '--enable-intl' '--without-gdbm' '--without-mm' '--without-pdo-dblib' '--with-readline' '--with-enchant' '--with-pic' '--with-layout=GNU' '--with-pear' '--with-bz2' '--with-db4' '--with-iconv' '--with-gettext' '--with-zlib' '--with-pcre-regex=/usr' '--with-libxml-dir=/usr' '--with-kerberos=/usr' '--with-openssl=/usr' '--with-mhash' '--with-curl' '--with-zlib-dir=/usr' '--with-gmp' '--with-jpeg-dir' '--with-xpm-dir' '--with-png-dir' '--with-freetype-dir' '--with-t1lib' '--with-ldap' '--with-gd' '--with-mysql' '--with-mysqli=mysqlnd' '--with-pgsql' '--with-pspell' '--with-xsl' '--with-snmp' '--with-tidy' '--with-xmlrpc' '--with-pdo-mysql' '--with-pdo-pgsql' '--with-pdo-dblib' '--with-libdir=/lib/x86_64-linux-gnu' '--with-pdo-sqlite' '--with-mcrypt' '--with-imap-ssl'"
#define PHP_ADA_INCLUDE		""
#define PHP_ADA_LFLAGS		""
#define PHP_ADA_LIBS		""
#define PHP_APACHE_INCLUDE	""
#define PHP_APACHE_TARGET	""
#define PHP_FHTTPD_INCLUDE      ""
#define PHP_FHTTPD_LIB          ""
#define PHP_FHTTPD_TARGET       ""
#define PHP_CFLAGS		"$(CFLAGS_CLEAN) -prefer-non-pic -static"
#define PHP_DBASE_LIB		""
#define PHP_BUILD_DEBUG		""
#define PHP_GDBM_INCLUDE	""
#define PHP_IBASE_INCLUDE	""
#define PHP_IBASE_LFLAGS	""
#define PHP_IBASE_LIBS		""
#define PHP_IFX_INCLUDE		""
#define PHP_IFX_LFLAGS		""
#define PHP_IFX_LIBS		""
#define PHP_INSTALL_IT		""
#define PHP_IODBC_INCLUDE	""
#define PHP_IODBC_LFLAGS	""
#define PHP_IODBC_LIBS		""
#define PHP_MSQL_INCLUDE	""
#define PHP_MSQL_LFLAGS		""
#define PHP_MSQL_LIBS		""
#define PHP_MYSQL_INCLUDE	""
#define PHP_MYSQL_LIBS		""
#define PHP_MYSQL_TYPE		""
#define PHP_ODBC_INCLUDE	""
#define PHP_ODBC_LFLAGS		""
#define PHP_ODBC_LIBS		""
#define PHP_ODBC_TYPE		""
#define PHP_OCI8_SHARED_LIBADD 	""
#define PHP_OCI8_DIR			""
#define PHP_OCI8_ORACLE_VERSION		""
#define PHP_ORACLE_SHARED_LIBADD 	"@ORACLE_SHARED_LIBADD@"
#define PHP_ORACLE_DIR				"@ORACLE_DIR@"
#define PHP_ORACLE_VERSION			"@ORACLE_VERSION@"
#define PHP_PGSQL_INCLUDE	""
#define PHP_PGSQL_LFLAGS	""
#define PHP_PGSQL_LIBS		""
#define PHP_PROG_SENDMAIL	""
#define PHP_SOLID_INCLUDE	""
#define PHP_SOLID_LIBS		""
#define PHP_EMPRESS_INCLUDE	""
#define PHP_EMPRESS_LIBS	""
#define PHP_SYBASE_INCLUDE	""
#define PHP_SYBASE_LFLAGS	""
#define PHP_SYBASE_LIBS		""
#define PHP_DBM_TYPE		""
#define PHP_DBM_LIB		""
#define PHP_LDAP_LFLAGS		""
#define PHP_LDAP_INCLUDE	""
#define PHP_LDAP_LIBS		""
#define PHP_BIRDSTEP_INCLUDE     ""
#define PHP_BIRDSTEP_LIBS        ""
#define PEAR_INSTALLDIR         "/home/admin/php/share/pear"
#define PHP_INCLUDE_PATH	".:/home/admin/php/share/pear"
#define PHP_EXTENSION_DIR       "/home/admin/php/lib/php/20121212"
#define PHP_PREFIX              "/home/admin/php"
#define PHP_BINDIR              "/home/admin/php/bin"
#define PHP_SBINDIR             "/home/admin/php/sbin"
#define PHP_MANDIR              "/home/admin/php/share/man"
#define PHP_LIBDIR              "/home/admin/php/lib/php"
#define PHP_DATADIR             "/home/admin/php/share"
#define PHP_SYSCONFDIR          "/home/admin/php/etc"
#define PHP_LOCALSTATEDIR       "/var"
#define PHP_CONFIG_FILE_PATH    "/home/admin/php/etc"
#define PHP_CONFIG_FILE_SCAN_DIR    "/home/admin/php/etc/php/conf.d"
#define PHP_SHLIB_SUFFIX        "so"
