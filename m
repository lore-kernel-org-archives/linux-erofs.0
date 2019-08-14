From: lkp@intel.com (kbuild test robot)
Date: Wed, 14 Aug 2019 19:59:57 +0800
Subject: [PATCH v2] Add flags option to get xattr method paired to
 __vfs_getxattr
In-Reply-To: <20190813145527.26289-1-salyzyn@android.com>
References: <20190813145527.26289-1-salyzyn@android.com>
Message-ID: <201908141935.iswsiyzF%lkp@intel.com>

Hi Mark,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[cannot apply to v5.3-rc4 next-20190813]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mark-Salyzyn/Add-flags-option-to-get-xattr-method-paired-to-__vfs_getxattr/20190814-124805
config: nds32-allmodconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 8.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=8.1.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp at intel.com>

All errors (new ones prefixed by >>):

   fs/ubifs/xattr.c:326:9: error: conflicting types for 'ubifs_xattr_get'
    ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
            ^~~~~~~~~~~~~~~
   In file included from fs/ubifs/xattr.c:46:
   fs/ubifs/ubifs.h:2006:9: note: previous declaration of 'ubifs_xattr_get' was here
    ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
            ^~~~~~~~~~~~~~~
   fs/ubifs/xattr.c: In function 'xattr_get':
   fs/ubifs/xattr.c:678:9: error: too few arguments to function 'ubifs_xattr_get'
     return ubifs_xattr_get(inode, name, buffer, size);
            ^~~~~~~~~~~~~~~
   fs/ubifs/xattr.c:326:9: note: declared here
    ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
            ^~~~~~~~~~~~~~~
   fs/ubifs/xattr.c: At top level:
>> fs/ubifs/xattr.c:699:9: error: initialization of 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)' {aka 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, unsigned int,  int)'} from incompatible pointer type 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)' {aka 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, unsigned int)'} [-Werror=incompatible-pointer-types]
     .get = xattr_get,
            ^~~~~~~~~
   fs/ubifs/xattr.c:699:9: note: (near initialization for 'ubifs_user_xattr_handler.get')
   fs/ubifs/xattr.c:705:9: error: initialization of 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)' {aka 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, unsigned int,  int)'} from incompatible pointer type 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)' {aka 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, unsigned int)'} [-Werror=incompatible-pointer-types]
     .get = xattr_get,
            ^~~~~~~~~
   fs/ubifs/xattr.c:705:9: note: (near initialization for 'ubifs_trusted_xattr_handler.get')
   fs/ubifs/xattr.c:712:9: error: initialization of 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t,  int)' {aka 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, unsigned int,  int)'} from incompatible pointer type 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, size_t)' {aka 'int (*)(const struct xattr_handler *, struct dentry *, struct inode *, const char *, void *, unsigned int)'} [-Werror=incompatible-pointer-types]
     .get = xattr_get,
            ^~~~~~~~~
   fs/ubifs/xattr.c:712:9: note: (near initialization for 'ubifs_security_xattr_handler.get')
   fs/ubifs/xattr.c: In function 'xattr_get':
   fs/ubifs/xattr.c:679:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   cc1: some warnings being treated as errors

vim +699 fs/ubifs/xattr.c

2b88fc21cae91e Andreas Gruenbacher 2016-04-22  669  
ade46c3a6029de Richard Weinberger  2016-09-19  670  static int xattr_get(const struct xattr_handler *handler,
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  671  			   struct dentry *dentry, struct inode *inode,
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  672  			   const char *name, void *buffer, size_t size)
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  673  {
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  674  	dbg_gen("xattr '%s', ino %lu ('%pd'), buf size %zd", name,
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  675  		inode->i_ino, dentry, size);
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  676  
17ce1eb0b64eb2 Richard Weinberger  2016-07-31  677  	name = xattr_full_name(handler, name);
ade46c3a6029de Richard Weinberger  2016-09-19 @678  	return ubifs_xattr_get(inode, name, buffer, size);
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  679  }
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  680  
ade46c3a6029de Richard Weinberger  2016-09-19  681  static int xattr_set(const struct xattr_handler *handler,
5930122683dff5 Al Viro             2016-05-27  682  			   struct dentry *dentry, struct inode *inode,
5930122683dff5 Al Viro             2016-05-27  683  			   const char *name, const void *value,
5930122683dff5 Al Viro             2016-05-27  684  			   size_t size, int flags)
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  685  {
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  686  	dbg_gen("xattr '%s', host ino %lu ('%pd'), size %zd",
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  687  		name, inode->i_ino, dentry, size);
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  688  
17ce1eb0b64eb2 Richard Weinberger  2016-07-31  689  	name = xattr_full_name(handler, name);
17ce1eb0b64eb2 Richard Weinberger  2016-07-31  690  
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  691  	if (value)
d8db5b1ca9d4c5 Xiaolei Li          2017-06-23  692  		return ubifs_xattr_set(inode, name, value, size, flags, true);
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  693  	else
ade46c3a6029de Richard Weinberger  2016-09-19  694  		return ubifs_xattr_remove(inode, name);
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  695  }
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  696  
dfaf8d2aeca482 Ben Dooks           2016-06-21  697  static const struct xattr_handler ubifs_user_xattr_handler = {
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  698  	.prefix = XATTR_USER_PREFIX,
ade46c3a6029de Richard Weinberger  2016-09-19 @699  	.get = xattr_get,
ade46c3a6029de Richard Weinberger  2016-09-19  700  	.set = xattr_set,
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  701  };
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  702  

:::::: The code at line 699 was first introduced by commit
:::::: ade46c3a6029dea49dbc6c7734b0f6a78d3f104c ubifs: Export xattr get and set functions

:::::: TO: Richard Weinberger <richard at nod.at>
:::::: CC: Richard Weinberger <richard at nod.at>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 52543 bytes
Desc: not available
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190814/1bb36b14/attachment.gz>
