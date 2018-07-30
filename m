From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 30 Jul 2018 11:34:54 +0800
Subject: [FOR INTERNAL REVIEW] [PATCH RESEND 3/3] staging: erofs: fix
 conditional uninitialized `pcn' in z_erofs_map_blocks_iter
In-Reply-To: <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>
References: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
 <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532921694-23526-3-git-send-email-gaoxiang25@huawei.com>

From: Gao Xiang <hsiangkao@aol.com>

This patch adds error handling code for
z_erofs_map_blocks_iter to fix the compiler blame.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 0e410a2..bd2d7a8 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1532,13 +1532,14 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	unsigned long long ofs, end;
 	struct z_erofs_vle_decompressed_index *di;
 	erofs_blk_t e_blkaddr, pcn;
-	unsigned lcn, logical_cluster_ofs;
+	unsigned lcn, logical_cluster_ofs, cluster_type;
 	u32 ofs_rem;
 	struct page *mpage = *mpage_ret;
 	void *kaddr;
 	bool initial;
 	const unsigned int clusterbits = EROFS_SB(inode->i_sb)->clusterbits;
 	const unsigned int clustersize = 1 << clusterbits;
+	int err = 0;
 
 	/* if both m_(l,p)len are 0, regularize l_lblk, l_lofs, etc... */
 	initial = !map->m_llen;
@@ -1592,7 +1593,9 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 
 	end = (u64)(lcn + 1) * clustersize;
 
-	switch (vle_cluster_type(di)) {
+	cluster_type = vle_cluster_type(di);
+
+	switch (cluster_type) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		if (ofs_rem >= logical_cluster_ofs)
 			map->m_flags ^= EROFS_MAP_ZIPPED;
@@ -1608,13 +1611,24 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 			break;
 		}
 
-		BUG_ON(!lcn);	/* logical cluster number >= 1 */
+		/* logical cluster number should be >= 1 */
+		if (unlikely(!lcn)) {
+			errln("invalid logical cluster 0 at nid %llu",
+				EROFS_V(inode)->nid);
+			err = -EIO;
+			goto unmap_out;
+		}
 		end = (lcn-- * clustersize) | logical_cluster_ofs;
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		/* get the correspoinding first chunk */
 		ofs = vle_get_logical_extent_head(inode, mpage_ret,
 			&kaddr, lcn, &pcn, &map->m_flags);
 		mpage = *mpage_ret;
+	default:
+		errln("unknown cluster type %u at offset %llu of nid %llu",
+			cluster_type, ofs, EROFS_V(inode)->nid);
+		err = -EIO;
+		goto unmap_out;
 	}
 
 	map->m_la = ofs;
@@ -1630,6 +1644,9 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	debugln("%s, m_la %llu m_pa %llu m_llen %llu m_plen %llu m_flags 0%o",
 		__func__, map->m_la, map->m_pa,
 		map->m_llen, map->m_plen, map->m_flags);
-	return 0;
+
+	/* aggressively BUG_ON iff CONFIG_EROFS_FS_DEBUG is on */
+	DBG_BUGON(err < 0);
+	return err;
 }
 
-- 
1.9.1
