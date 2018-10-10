From: viro@ZenIV.linux.org.uk (Al Viro)
Date: Wed, 10 Oct 2018 20:01:16 +0100
Subject: [PATCH] clean erofs_lookup()
Message-ID: <20181010190116.GG32577@ZenIV.linux.org.uk>

	d_splice_alias() does the right thing when given
ERR_PTR(-E...) for inode.  No need for gotos, multiple
returns, etc. in there.

Signed-off-by: Al Viro <viro at zeniv.linux.org.uk>
---
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 546a47156101..8cf0617d4ea0 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -223,18 +223,13 @@ static struct dentry *erofs_lookup(struct inode *dir,
 	if (err == -ENOENT) {
 		/* negative dentry */
 		inode = NULL;
-		goto negative_out;
-	} else if (unlikely(err))
-		return ERR_PTR(err);
-
-	debugln("%s, %s (nid %llu) found, d_type %u", __func__,
-		dentry->d_name.name, nid, d_type);
-
-	inode = erofs_iget(dir->i_sb, nid, d_type == EROFS_FT_DIR);
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
-
-negative_out:
+	} else if (unlikely(err)) {
+		inode = ERR_PTR(err);
+	} else {
+		debugln("%s, %s (nid %llu) found, d_type %u", __func__,
+			dentry->d_name.name, nid, d_type);
+		inode = erofs_iget(dir->i_sb, nid, d_type == EROFS_FT_DIR);
+	}
 	return d_splice_alias(inode, dentry);
 }
 
