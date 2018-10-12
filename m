From: hsiangkao@aol.com (Gao Xiang)
Date: Sat, 13 Oct 2018 01:59:49 +0800
Subject: [PATCH RESEND] staging: erofs: clean erofs_lookup()
In-Reply-To: <a267e4b0-887e-6de9-38db-7ca9a5518b72@aol.com>
References: <a267e4b0-887e-6de9-38db-7ca9a5518b72@aol.com>
Message-ID: <1539367189-20186-1-git-send-email-hsiangkao@aol.com>

From: Al Viro <viro@ZenIV.linux.org.uk>

	d_splice_alias() does the right thing when given
ERR_PTR(-E...) for inode.  No need for gotos, multiple
returns, etc. in there.

Signed-off-by: Al Viro <viro at zeniv.linux.org.uk>
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
Hi,

Frankly, I think it is a straight-forward cleanup by Al enough
to be submitted to Linux 4.20 in constant to other pending fixes
found in the process of EROFS productization these days, which
I need more time to think over and fix formally to the community.

p.s. I have no idea whether this patch has been already queued up
in Al's fs tree for 4.20... :'( +Cc Greg / the staging mailing
list as well. Or please ignore this email...

Thanks,
Gao Xiang

 drivers/staging/erofs/namei.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 0039b76..5596c52 100644
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
 
-- 
2.7.4
