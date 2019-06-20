From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 21 Jun 2019 00:07:17 +0800
Subject: [PATCH v2 6/8] staging: erofs: introduce LZ4 decompression inplace
In-Reply-To: <20190620160719.240682-1-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
Message-ID: <20190620160719.240682-7-gaoxiang25@huawei.com>

compressed data will be usually loaded into last pages of
the extent (the last page for 4k) for in-place decompression
(more specifically, in-place IO), as ilustration below,

         start of compressed logical extent
           |                          end of this logical extent
           |                           |
     ______v___________________________v________
... |  page 6  |  page 7  |  page 8  |  page 9  | ...
    |__________|__________|__________|__________|
           .                         ^ .        ^
           .                         |compressed|
           .                         |   data   |
           .                           .        .
           |<          dstsize        >|<margin>|
                                       oend     iend
           op                        ip

Therefore, it's possible to do decompression inplace (thus no
memcpy at all) if the margin is sufficient and safe enough [1],
and it can be implemented only for fixed-size output compression
compared with fixed-size input compression.

No memcpy for most of in-place IO (about 99% of enwik9) after
decompression inplace is implemented and sequential read will
be improved of course (see the following patches for test results).

[1] https://github.com/lz4/lz4/commit/b17f578a919b7e6b078cede2d52be29dd48c8e8c
    https://github.com/lz4/lz4/commit/5997e139f53169fa3a1c1b4418d2452a90b01602

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/compress.h     |  1 +
 drivers/staging/erofs/decompressor.c | 21 ++++++++++++++++++---
 drivers/staging/erofs/erofs_fs.h     |  3 ++-
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/compress.h b/drivers/staging/erofs/compress.h
index ebeccb1f4eae..c43aa3374d28 100644
--- a/drivers/staging/erofs/compress.h
+++ b/drivers/staging/erofs/compress.h
@@ -17,6 +17,7 @@ enum {
 };
 
 struct z_erofs_decompress_req {
+	struct super_block *sb;
 	struct page **in, **out;
 
 	unsigned short pageofs_out;
diff --git a/drivers/staging/erofs/decompressor.c b/drivers/staging/erofs/decompressor.c
index c68d17b579e0..689fb8ec7032 100644
--- a/drivers/staging/erofs/decompressor.c
+++ b/drivers/staging/erofs/decompressor.c
@@ -14,6 +14,9 @@
 #endif
 
 #define LZ4_MAX_DISTANCE_PAGES	DIV_ROUND_UP(LZ4_DISTANCE_MAX, PAGE_SIZE)
+#ifndef LZ4_DECOMPRESS_INPLACE_MARGIN
+#define LZ4_DECOMPRESS_INPLACE_MARGIN(srcsize)  (((srcsize) >> 8) + 32)
+#endif
 
 struct z_erofs_decompressor {
 	/*
@@ -132,9 +135,21 @@ static int lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out)
 	copied = false;
 	inlen = rq->inputsize - inputmargin;
 	if (rq->inplace_io) {
-		src = generic_copy_inplace_data(rq, src, inputmargin);
-		inputmargin = 0;
-		copied = true;
+		const uint oend = (rq->pageofs_out +
+				   rq->outputsize) & ~PAGE_MASK;
+		const uint nr = PAGE_ALIGN(rq->pageofs_out +
+					   rq->outputsize) >> PAGE_SHIFT;
+
+		if (rq->partial_decoding ||
+		    !(EROFS_SB(rq->sb)->requirements &
+		      EROFS_REQUIREMENT_LZ4_0PADDING) ||
+		    rq->out[nr - 1] != rq->in[0] ||
+		    rq->inputsize - oend <
+		      LZ4_DECOMPRESS_INPLACE_MARGIN(inlen)) {
+			src = generic_copy_inplace_data(rq, src, inputmargin);
+			inputmargin = 0;
+			copied = true;
+		}
 	}
 
 	ret = LZ4_decompress_safe_partial(src + inputmargin, out,
diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index a05139f1df60..353322a3206c 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -21,7 +21,8 @@
  * Any bits that aren't in EROFS_ALL_REQUIREMENTS should be
  * incompatible with this kernel version.
  */
-#define EROFS_ALL_REQUIREMENTS  0
+#define EROFS_REQUIREMENT_LZ4_0PADDING	0x00000001
+#define EROFS_ALL_REQUIREMENTS		EROFS_REQUIREMENT_LZ4_0PADDING
 
 struct erofs_super_block {
 /*  0 */__le32 magic;           /* in the little endian */
-- 
2.17.1
