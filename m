From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 May 2019 08:50:45 +0800
Subject: [PATCH 11/13] erofs-utils: propagate compressed size to its callers
In-Reply-To: <20190531005047.22093-1-hsiangkao@aol.com>
References: <20190531005047.22093-1-hsiangkao@aol.com>
Message-ID: <20190531005047.22093-12-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

It will be later used for marking whether it can
decompress in-place.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 lib/compress.c         | 2 +-
 lib/compressor.c       | 4 ++--
 lib/compressor_lz4.c   | 2 +-
 lib/compressor_lz4hc.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 205a4f2..7bfb8ce 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -131,7 +131,7 @@ static int vle_compress_one(struct erofs_inode *inode,
 		ret = erofs_compress_destsize(h, compressionlevel,
 					      ctx->queue + ctx->head,
 					      &count, dst, EROFS_BLKSIZ);
-		if (ret) {
+		if (ret <= 0) {
 			if (ret != -EAGAIN) {
 				erofs_err("failed to compress %s: %s",
 					  inode->i_srcpath,
diff --git a/lib/compressor.c b/lib/compressor.c
index a6138c6..570db14 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -26,13 +26,13 @@ int erofs_compress_destsize(struct erofs_compress *c,
 
 	ret = c->alg->compress_destsize(c, compression_level,
 					src, srcsize, dst, dstsize);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	/* check if there is enough gains to compress */
 	if (*srcsize <= dstsize * c->compress_threshold / 100)
 		return -EAGAIN;
-	return 0;
+	return ret;
 }
 
 int erofs_compressor_init(struct erofs_compress *c,
diff --git a/lib/compressor_lz4.c b/lib/compressor_lz4.c
index eacd21c..0d33223 100644
--- a/lib/compressor_lz4.c
+++ b/lib/compressor_lz4.c
@@ -21,7 +21,7 @@ static int lz4_compress_destsize(struct erofs_compress *c,
 	if (!rc)
 		return -EFAULT;
 	*srcsize = srcSize;
-	return 0;
+	return rc;
 }
 
 static int compressor_lz4_exit(struct erofs_compress *c)
diff --git a/lib/compressor_lz4hc.c b/lib/compressor_lz4hc.c
index 3bbb754..d9413e2 100644
--- a/lib/compressor_lz4hc.c
+++ b/lib/compressor_lz4hc.c
@@ -25,7 +25,7 @@ static int lz4hc_compress_destsize(struct erofs_compress *c,
 	if (!rc)
 		return -EFAULT;
 	*srcsize = srcSize;
-	return 0;
+	return rc;
 }
 
 static int compressor_lz4hc_exit(struct erofs_compress *c)
-- 
2.17.1
