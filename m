From: zbestahu@gmail.com (Yue Hu)
Date: Thu, 30 May 2019 17:58:50 +0800
Subject: [PATCH] erofs-utils: remove AC_FUNC_MALLOC check
Message-ID: <20190530095850.5260-1-zbestahu@gmail.com>

From: Yue Hu <huyue2@yulong.com>

Below erros happened when building for ARM64, rpl_malloc is not
supplied in that case, remove AC_FUNC_MALLOC can fix the errors.

mkfs_file.c: In function 'erofs_compress_file':
mkfs_file.c:600:2: error: implicit declaration of function 'rpl_malloc' [-Werror=implicit-function-declaration]
  inode->i_inline_data = malloc(EROFS_BLKSIZE);
  ^
mkfs_file.c:600:23: error: assignment makes pointer from integer without a cast [-Werror]
  inode->i_inline_data = malloc(EROFS_BLKSIZE);
                       ^
mkfs_file.c: In function 'erofs_init_compress_context':
mkfs_file.c:874:17: error: assignment makes pointer from integer without a cast [-Werror]
  ctx->cc_srcbuf = malloc(erofs_cfg.c_compr_maxsz);
                 ^
mkfs_file.c:875:17: error: assignment makes pointer from integer without a cast [-Werror]
  ctx->cc_dstbuf = malloc(erofs_cfg.c_compr_maxsz * 2);
                 ^
cc1: all warnings being treated as errors
make[2]: *** [mkfs_erofs-mkfs_file.o] Error 1

Signed-off-by: Yue Hu <huyue2 at yulong.com>
---
 configure.ac | 1 -
 1 file changed, 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 8e3f703..40ee765 100644
--- a/configure.ac
+++ b/configure.ac
@@ -98,7 +98,6 @@ AC_CHECK_MEMBERS([struct stat.st_rdev])
 AC_TYPE_UINT64_T
 
 # Checks for library functions.
-AC_FUNC_MALLOC
 AC_CHECK_FUNCS([ftruncate getcwd gettimeofday memset realpath strdup strerror strrchr strtoull])
 
 # Configure lz4.
-- 
1.9.1
