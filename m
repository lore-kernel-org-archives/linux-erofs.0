From: lkp@intel.com (kbuild test robot)
Date: Fri, 16 Aug 2019 21:27:42 +0800
Subject: [PATCH v4] Add flags option to get xattr method paired to
 __vfs_getxattr
In-Reply-To: <20190815155019.229988-1-salyzyn@android.com>
References: <20190815155019.229988-1-salyzyn@android.com>
Message-ID: <201908162141.9dc5Bnb4%lkp@intel.com>

Hi Mark,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[cannot apply to v5.3-rc4 next-20190814]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mark-Salyzyn/Add-flags-option-to-get-xattr-method-paired-to-__vfs_getxattr/20190816-155049
config: x86_64-lkp (attached as .config)
compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp at intel.com>

All errors (new ones prefixed by >>):

>> fs/ext2/xattr_security.c:56:9: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     .get = ext2_xattr_security_get,
            ^~~~~~~~~~~~~~~~~~~~~~~
   fs/ext2/xattr_security.c:56:9: note: (near initialization for 'ext2_xattr_security_handler.get')
   cc1: some warnings being treated as errors

vim +56 fs/ext2/xattr_security.c

9d8f13ba3f4833 Mimi Zohar        2011-06-06  53  
749c72efa4bd91 Stephen Hemminger 2010-05-13  54  const struct xattr_handler ext2_xattr_security_handler = {
^1da177e4c3f41 Linus Torvalds    2005-04-16  55  	.prefix	= XATTR_SECURITY_PREFIX,
^1da177e4c3f41 Linus Torvalds    2005-04-16 @56  	.get	= ext2_xattr_security_get,

:::::: The code at line 56 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds at ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds at ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 27569 bytes
Desc: not available
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190816/04d96d85/attachment.gz>
