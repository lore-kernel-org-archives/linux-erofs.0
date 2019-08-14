From: lkp@intel.com (kbuild test robot)
Date: Wed, 14 Aug 2019 13:57:30 +0800
Subject: [PATCH v2] Add flags option to get xattr method paired to
 __vfs_getxattr
In-Reply-To: <20190813145527.26289-1-salyzyn@android.com>
References: <20190813145527.26289-1-salyzyn@android.com>
Message-ID: <201908141340.zUiNVpi0%lkp@intel.com>

Hi Mark,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[cannot apply to v5.3-rc4 next-20190813]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mark-Salyzyn/Add-flags-option-to-get-xattr-method-paired-to-__vfs_getxattr/20190814-124805
config: sh-allmodconfig (attached as .config)
compiler: sh4-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=sh 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp at intel.com>

All errors (new ones prefixed by >>):

>> fs/ubifs/xattr.c:326:9: error: conflicting types for 'ubifs_xattr_get'
    ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
            ^~~~~~~~~~~~~~~
   In file included from fs/ubifs/xattr.c:46:0:
   fs/ubifs/ubifs.h:2006:9: note: previous declaration of 'ubifs_xattr_get' was here
    ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
            ^~~~~~~~~~~~~~~
   fs/ubifs/xattr.c: In function 'xattr_get':
>> fs/ubifs/xattr.c:678:9: error: too few arguments to function 'ubifs_xattr_get'
     return ubifs_xattr_get(inode, name, buffer, size);
            ^~~~~~~~~~~~~~~
   fs/ubifs/xattr.c:326:9: note: declared here
    ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
            ^~~~~~~~~~~~~~~
   fs/ubifs/xattr.c: At top level:
   fs/ubifs/xattr.c:699:9: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     .get = xattr_get,
            ^~~~~~~~~
   fs/ubifs/xattr.c:699:9: note: (near initialization for 'ubifs_user_xattr_handler.get')
   fs/ubifs/xattr.c:705:9: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     .get = xattr_get,
            ^~~~~~~~~
   fs/ubifs/xattr.c:705:9: note: (near initialization for 'ubifs_trusted_xattr_handler.get')
   fs/ubifs/xattr.c:712:9: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     .get = xattr_get,
            ^~~~~~~~~
   fs/ubifs/xattr.c:712:9: note: (near initialization for 'ubifs_security_xattr_handler.get')
   fs/ubifs/xattr.c: In function 'xattr_get':
   fs/ubifs/xattr.c:679:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   cc1: some warnings being treated as errors

vim +/ubifs_xattr_get +326 fs/ubifs/xattr.c

1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  325  
ade46c3a6029de Richard Weinberger  2016-09-19 @326  ssize_t ubifs_xattr_get(struct inode *host, const char *name, void *buf,
ac76fdcb4aadfd Mark Salyzyn        2019-08-13  327  			size_t size, int flags)
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  328  {
ce23e640133484 Al Viro             2016-04-11  329  	struct inode *inode;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  330  	struct ubifs_info *c = host->i_sb->s_fs_info;
f4f61d2cc6d878 Richard Weinberger  2016-11-11  331  	struct fscrypt_name nm = { .disk_name = FSTR_INIT((char *)name, strlen(name))};
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  332  	struct ubifs_inode *ui;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  333  	struct ubifs_dent_node *xent;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  334  	union ubifs_key key;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  335  	int err;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  336  
f4f61d2cc6d878 Richard Weinberger  2016-11-11  337  	if (fname_len(&nm) > UBIFS_MAX_NLEN)
2b88fc21cae91e Andreas Gruenbacher 2016-04-22  338  		return -ENAMETOOLONG;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  339  
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  340  	xent = kmalloc(UBIFS_MAX_XENT_NODE_SZ, GFP_NOFS);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  341  	if (!xent)
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  342  		return -ENOMEM;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  343  
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  344  	xent_key_init(c, &key, host->i_ino, &nm);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  345  	err = ubifs_tnc_lookup_nm(c, &key, xent, &nm);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  346  	if (err) {
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  347  		if (err == -ENOENT)
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  348  			err = -ENODATA;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  349  		goto out_unlock;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  350  	}
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  351  
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  352  	inode = iget_xattr(c, le64_to_cpu(xent->inum));
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  353  	if (IS_ERR(inode)) {
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  354  		err = PTR_ERR(inode);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  355  		goto out_unlock;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  356  	}
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  357  
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  358  	ui = ubifs_inode(inode);
6eb61d587f4515 Richard Weinberger  2018-07-12  359  	ubifs_assert(c, inode->i_size == ui->data_len);
6eb61d587f4515 Richard Weinberger  2018-07-12  360  	ubifs_assert(c, ubifs_inode(host)->xattr_size > ui->data_len);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  361  
ab92a20bce3b4c Dongsheng Yang      2015-08-18  362  	mutex_lock(&ui->ui_mutex);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  363  	if (buf) {
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  364  		/* If @buf is %NULL we are supposed to return the length */
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  365  		if (ui->data_len > size) {
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  366  			err = -ERANGE;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  367  			goto out_iput;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  368  		}
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  369  
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  370  		memcpy(buf, ui->data, ui->data_len);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  371  	}
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  372  	err = ui->data_len;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  373  
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  374  out_iput:
ab92a20bce3b4c Dongsheng Yang      2015-08-18  375  	mutex_unlock(&ui->ui_mutex);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  376  	iput(inode);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  377  out_unlock:
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  378  	kfree(xent);
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  379  	return err;
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  380  }
1e51764a3c2ac0 Artem Bityutskiy    2008-07-14  381  

:::::: The code at line 326 was first introduced by commit
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
Size: 51784 bytes
Desc: not available
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190814/cda1b35f/attachment.gz>
