From: chao@kernel.org (Chao Yu)
Date: Sun, 1 Jul 2018 11:56:27 +0800
Subject: [PATCH v5] erofs: introduce error injection infrastructure
In-Reply-To: <20180630183916.4201-1-hsiangkao@aol.com>
References: <20180622020131.65525-10-yuchao0@huawei.com>
 <20180630183916.4201-1-hsiangkao@aol.com>
Message-ID: <0fcc82f1-863f-64e9-ae4e-12de33fb51fa@kernel.org>

On 2018/7/1 2:39, Gao Xiang via Linux-erofs wrote:
> From: Chao Yu <yuchao0 at huawei.com>
> 
> This patch introduces error injection infrastructure, with it, we can
> inject error in any kernel exported common functions which erofs used,
> so that it can force erofs running into error paths, it turns out that
> tests can cover real rare paths more easily to find bugs.
> 
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
> ---
> v5 Gao Xiang <gaoxiang25 at huawei.com>:
> - fix implicit declaration of "kmalloc" by moving
>   <linux/slab.h> to internal.h
>   Reported-by: kbuild test robot <lkp at intel.com>
>   https://lists.01.org/pipermail/kbuild-all/2018-June/049644.html
> 
> v4 Gao Xiang <gaoxiang25 at huawei.com>:
> - avoid the global variable 'fault_name' to pollute symbol space.
>   Reported-by: kbuild test robot <lkp at intel.com>
>   https://lists.01.org/pipermail/kbuild-all/2018-June/049660.html

Thanks for fixing these issues.

Thanks,

> v3:
> - code rebase.
> v2:
> - add missing Kconfig entry.
> - fix double prefix 'erofs:' in erofs_show_injection_info macro.
> 
>  fs/erofs/Kconfig    |  6 +++++
>  fs/erofs/inode.c    |  4 ++--
>  fs/erofs/internal.h | 58 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/erofs/super.c    | 41 ++++++++++++++++++++++++++++++--
>  fs/erofs/xattr.c    |  1 -
>  5 files changed, 105 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index 752f0e08d0b8..e9bab0f5600c 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -86,3 +86,9 @@ config EROFS_FS_ZIP
>  
>  	  If you don't want to use compression, say N.
>  
> +config EROFS_FAULT_INJECTION
> +	bool "EROFS fault injection facility"
> +	depends on EROFS_FS
> +	help
> +	  Test EROFS to inject faults such as ENOMEM, EIO, and so on.
> +	  If unsure, say N.
> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> index 3dbce0cf41ff..844b999649f0 100644
> --- a/fs/erofs/inode.c
> +++ b/fs/erofs/inode.c
> @@ -11,7 +11,6 @@
>   * distribution for more details.
>   */
>  #include "internal.h"
> -#include <linux/slab.h>
>  #include "xattr.h"
>  
>  /* no locking */
> @@ -100,6 +99,7 @@ static int read_inode(struct inode *inode, void *data)
>  int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
>  {
>  	struct erofs_vnode *vi = EROFS_V(inode);
> +	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
>  	int mode = vi->data_mapping_mode;
>  
>  	BUG_ON(mode >= EROFS_INODE_LAYOUT_MAX);
> @@ -110,7 +110,7 @@ int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
>  
>  	/* fast symlink (following ext4) */
>  	if (S_ISLNK(inode->i_mode) && inode->i_size < PAGE_SIZE) {
> -		char *lnk = kmalloc(inode->i_size + 1, GFP_KERNEL);
> +		char *lnk = erofs_kmalloc(sbi, inode->i_size + 1, GFP_KERNEL);
>  
>  		if (unlikely(lnk == NULL))
>  			return -ENOMEM;
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 43620c07044d..2567fb83b5f6 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -23,6 +23,7 @@
>  #ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
>  #include <linux/swap.h>
>  #endif
> +#include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include "erofs_fs.h"
>  
> @@ -45,6 +46,22 @@
>  #define DBG_BUGON(...)  ((void)0)
>  #endif
>  
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +enum {
> +	FAULT_KMALLOC,
> +	FAULT_MAX,
> +};
> +
> +extern char *erofs_fault_name[FAULT_MAX];
> +#define IS_FAULT_SET(fi, type) ((fi)->inject_type & (1 << (type)))
> +
> +struct erofs_fault_info {
> +	atomic_t inject_ops;
> +	unsigned int inject_rate;
> +	unsigned int inject_type;
> +};
> +#endif
> +
>  /* EROFS_SUPER_MAGIC_V1 to represent the whole file system */
>  #define EROFS_SUPER_MAGIC   EROFS_SUPER_MAGIC_V1
>  
> @@ -81,14 +98,55 @@ struct erofs_sb_info {
>  	char *dev_name;
>  
>  	unsigned int mount_opt;
> +
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +	struct erofs_fault_info fault_info;	/* For fault injection */
> +#endif
>  };
>  
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +#define erofs_show_injection_info(type)					\
> +	infoln("inject %s in %s of %pS", erofs_fault_name[type],        \
> +		__func__, __builtin_return_address(0))
> +
> +static inline bool time_to_inject(struct erofs_sb_info *sbi, int type)
> +{
> +	struct erofs_fault_info *ffi = &sbi->fault_info;
> +
> +	if (!ffi->inject_rate)
> +		return false;
> +
> +	if (!IS_FAULT_SET(ffi, type))
> +		return false;
> +
> +	atomic_inc(&ffi->inject_ops);
> +	if (atomic_read(&ffi->inject_ops) >= ffi->inject_rate) {
> +		atomic_set(&ffi->inject_ops, 0);
> +		return true;
> +	}
> +	return false;
> +}
> +#endif
> +
> +static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
> +					size_t size, gfp_t flags)
> +{
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +	if (time_to_inject(sbi, FAULT_KMALLOC)) {
> +		erofs_show_injection_info(FAULT_KMALLOC);
> +		return NULL;
> +	}
> +#endif
> +	return kmalloc(size, flags);
> +}
> +
>  #define EROFS_SB(sb) ((struct erofs_sb_info *)(sb)->s_fs_info)
>  #define EROFS_I_SB(inode) ((struct erofs_sb_info *)(inode)->i_sb->s_fs_info)
>  
>  /* Mount flags set via mount options or defaults */
>  #define EROFS_MOUNT_XATTR_USER		0x00000010
>  #define EROFS_MOUNT_POSIX_ACL		0x00000020
> +#define EROFS_MOUNT_FAULT_INJECTION	0x00000040
>  
>  #define clear_opt(sbi, option)	((sbi)->mount_opt &= ~EROFS_MOUNT_##option)
>  #define set_opt(sbi, option)	((sbi)->mount_opt |= EROFS_MOUNT_##option)
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 390a5217bbcc..d6046d4d787b 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -12,7 +12,6 @@
>   */
>  #include <linux/module.h>
>  #include <linux/buffer_head.h>
> -#include <linux/slab.h>
>  #include <linux/statfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/parser.h>
> @@ -135,6 +134,26 @@ static int superblock_read(struct super_block *sb)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +char *erofs_fault_name[FAULT_MAX] = {
> +	[FAULT_KMALLOC]		= "kmalloc",
> +};
> +
> +static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
> +						unsigned int rate)
> +{
> +	struct erofs_fault_info *ffi = &sbi->fault_info;
> +
> +	if (rate) {
> +		atomic_set(&ffi->inject_ops, 0);
> +		ffi->inject_rate = rate;
> +		ffi->inject_type = (1 << FAULT_MAX) - 1;
> +	} else {
> +		memset(ffi, 0, sizeof(struct erofs_fault_info));
> +	}
> +}
> +#endif
> +
>  static void default_options(struct erofs_sb_info *sbi)
>  {
>  #ifdef CONFIG_EROFS_FS_XATTR
> @@ -148,18 +167,21 @@ static void default_options(struct erofs_sb_info *sbi)
>  
>  enum {
>  	Opt_user_xattr,
> -	Opt_acl
> +	Opt_acl,
> +	Opt_fault_injection
>  };
>  
>  static match_table_t erofs_tokens = {
>  	{Opt_user_xattr, "user_xattr"},
>  	{Opt_acl, "acl"},
> +	{Opt_fault_injection, "fault_injection=%u"},
>  };
>  
>  static int parse_options(struct super_block *sb, char *options)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *p;
> +	int arg = 0;
>  
>  	if (!options)
>  		return 0;
> @@ -192,6 +214,16 @@ static int parse_options(struct super_block *sb, char *options)
>  			infoln("acl options not supported");
>  			break;
>  #endif
> +		case Opt_fault_injection:
> +			if (args->from && match_int(args, &arg))
> +				return -EINVAL;
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +			erofs_build_fault_attr(EROFS_SB(sb), arg);
> +			set_opt(EROFS_SB(sb), FAULT_INJECTION);
> +#else
> +			infoln("FAULT_INJECTION was not selected");
> +#endif
> +			break;
>  		default:
>  			infoln("Unrecognized mount option \"%s\" "
>  					"or missing value", p);
> @@ -451,6 +483,11 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
>  		seq_puts(seq, ",acl");
>  	else
>  		seq_puts(seq, ",noacl");
> +#endif
> +#ifdef CONFIG_EROFS_FAULT_INJECTION
> +	if (test_opt(sbi, FAULT_INJECTION))
> +		seq_printf(seq, ",fault_injection=%u",
> +				sbi->fault_info.inject_rate);
>  #endif
>  	return 0;
>  }
> diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
> index fb8f3f1b3aab..aa0231768643 100644
> --- a/fs/erofs/xattr.c
> +++ b/fs/erofs/xattr.c
> @@ -10,7 +10,6 @@
>   * License.  See the file COPYING in the main directory of the Linux
>   * distribution for more details.
>   */
> -#include <linux/slab.h>
>  #include <linux/security.h>
>  #include "xattr.h"
>  #include <linux/version.h>
> 
