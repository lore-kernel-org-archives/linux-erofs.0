From: arshad.super@gmail.com (Arshad Hussain)
Date: Sat, 16 Mar 2019 11:46:28 +0530
Subject: [PATCH] staging: erofs: Add function comment for erofs/inode.c
Message-ID: <20190316061628.1734-1-arshad.super@gmail.com>

This patch adds functions comment for file erofs/inode.c in
sphinx format.

Signed-off-by: Arshad Hussain <arshad.super at gmail.com>
---
 drivers/staging/erofs/inode.c | 67 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 924b8dfc7a8f..c68f280ba849 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -14,7 +14,15 @@
 
 #include <trace/events/erofs.h>
 
-/* no locking */
+/**
+ * read_inode(): Get physical Inode from disk.This is with
+ * 		 No locking.
+ *
+ * @inode: VFS inode structure
+ * @data: Page address where inode will be read
+ *
+ * Return: 0 on Success, Error number on failure
+ */
 static int read_inode(struct inode *inode, void *data)
 {
 	struct erofs_vnode *vi = EROFS_V(inode);
@@ -102,7 +110,13 @@ static int read_inode(struct inode *inode, void *data)
 	return 0;
 }
 
-/*
+/**
+ * fill_inline_data(): Fill last page if inline data is available
+ *
+ * @inode: VFS inode structure
+ * @data: TRUE if directory
+ * @m_pofs: Position to correct inode
+ *
  * try_lock can be required since locking order is:
  *   file data(fs_inode)
  *        meta(bd_inode)
@@ -111,6 +125,8 @@ static int read_inode(struct inode *inode, void *data)
  * no data operations exist. However I tend to
  * try_lock since it takes no much overhead and
  * will success immediately.
+ *
+ * Return: 0 on Success, Error number on failure
  */
 static int fill_inline_data(struct inode *inode, void *data,
 			    unsigned int m_pofs)
@@ -151,6 +167,15 @@ static int fill_inline_data(struct inode *inode, void *data,
 	return -EAGAIN;
 }
 
+/**
+ * fill_inode(): Fill in the inode
+ *
+ * @inode: VFS inode structure
+ * @isdir: TRUE if directory
+ *
+ * return: 0 on success, else error code on error
+ */
+
 static int fill_inode(struct inode *inode, int isdir)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
@@ -224,9 +249,16 @@ static int fill_inode(struct inode *inode, int isdir)
 	return err;
 }
 
-/*
+/**
+ * erofs_ilookup_test_actor(): Obtain inode from mounted FS
+ *
+ * @inode: VFS inode structure
+ * @opaque: Data pointer passed to test/set
+ *
  * erofs nid is 64bits, but i_ino is 'unsigned long', therefore
  * we should do more for 32-bit platform to find the right inode.
+ *
+ * Return: NID on Success
  */
 #if BITS_PER_LONG == 32
 static int erofs_ilookup_test_actor(struct inode *inode, void *opaque)
@@ -236,6 +268,14 @@ static int erofs_ilookup_test_actor(struct inode *inode, void *opaque)
 	return EROFS_V(inode)->nid == nid;
 }
 
+/*
+ * erofs_iget_set_actor(): Obtain inode from mounted FS
+ *
+ * @inode: VFS inode structure
+ * @opaque: Data pointer passed to test/set
+ *
+ * Return: 0 on success
+ */
 static int erofs_iget_set_actor(struct inode *inode, void *opaque)
 {
 	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
@@ -245,6 +285,14 @@ static int erofs_iget_set_actor(struct inode *inode, void *opaque)
 }
 #endif
 
+/**
+ * erofs_iget_locked(): Get the VFS inode from mounted FS
+ *
+ * @sb: VFS superblock structure of mounted FS
+ * @nid: Node ID to get
+ *
+ * Return: Pointer to inode
+ */
 static inline struct inode *erofs_iget_locked(struct super_block *sb,
 					      erofs_nid_t nid)
 {
@@ -259,6 +307,19 @@ static inline struct inode *erofs_iget_locked(struct super_block *sb,
 #endif
 }
 
+/**
+ * erofs_iget(): Get the VFS inode from the inode cache.
+ *
+ * @sb: VFS superblock structure
+ * @nid: Node ID
+ * @isdir: TRUE if directory.
+ *
+ * Get inode from inode cache. If not in cache, get it from disk
+ * and fill the cache.
+ *
+ * return: Pointer to the inode on success, else error code on error
+ */
+
 struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool isdir)
 {
-- 
2.14.5
