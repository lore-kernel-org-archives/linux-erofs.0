Return-Path: <linux-erofs+bounces-3637-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C950CD98E4
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 14:08:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfpkV6lf2z3c3v;
	Wed, 17 Jun 2026 00:08:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781618930;
	cv=none; b=SzHVyPMLS9KTvAu3KWKbECQO/VTlydKBzv55ZoRoD0B3JG7Ai2ftflYnFDG6uh+ZPqBGxL6nl9X0TfRWXuOJxXPJnJGHxEB7o6gi/RwyoUCHatH+tFU+ZgUefdvBOBjhZzo4ebOfZ5N4nCtREjUMYg4WpC0NX7w8Y6cDsPKX4+Aoz98lQ+79LWpdUEdeA1o3LFR2kzvr2izMRcUdVNo6mhzLh6k4cTnyeiXw+6t7G7p3fpgP59UgeX+A/tNC+q82UJ+hWiXsjBHcAY8UZi054djr+ZRuRzRyqzNtEK/HRv58GBUmlX7gFrR8+AM+ewomxoYLgDCc90Vgmm3tn10aSg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781618930; c=relaxed/relaxed;
	bh=BDwvgPs41b9NomLfrf+TZ2/uwsHPCsvN55JM7hxVyiE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ejSsM82t5K+jxWX7ftTztd3G4k/5Y2X9KuxOfGjmtSQx1XtLChwr3szQ1ekLBt6tgvni6W3Zp9Ob02BoLV94QdNno5n/nhc1JiWgRaIribTbghZSl1QDm5fT1PLnoeR4zt4Dx8Tn9xmK0i7C204vmzy0YoxKbtQkISBkyMjsUCngi+8ielZPAXW/uD276cd6ajxiisCYZNQQyX6/DDxAVwx9I/kxug/LRzSWUiRTzYSvQkl6r35Gz4sLObmI4F/LuN9zgDQWvVcAuo/3Xtb7q5ZebRM2jZtKzdeGvqhqIzS4SpQhO2c5z3reJZonAY2zopt88iKFRWWsiygdbZtbAw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=STD2m7/1; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=STD2m7/1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfpkP025Lz2yv0
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 00:08:44 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2349C60103;
	Tue, 16 Jun 2026 14:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B93C1F000E9;
	Tue, 16 Jun 2026 14:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618922;
	bh=BDwvgPs41b9NomLfrf+TZ2/uwsHPCsvN55JM7hxVyiE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=STD2m7/1c8lDu75kKhiuRlo1RmsBXm4p17Ot3rye3G5/Dju7RyT42Vk98jczhmP9z
	 pSXy32SnuoVMmFW22GQlnSzHN+SZmVpxtm9rnTnd8q2l4D12/xzZZZPo1ab0kF2NhB
	 R+RmwVHOWT3UXlzp+m7RT2RyM0j/hu4nk++gx22L1cXR+VdYBZl4wFhUd65+vkTJm/
	 c77GwnVi0uE84XN0JD9Pd0km7DUDlYs1Mk0yZPm9XqB/hevSsKL2bi9LLqdWRn1/gP
	 Phxj7/7zUodIOYoZgtW2psNux1EIjp/S3n4Cn8QaKy4cURQhXoSL2UmlF6RLRuAyPi
	 /c57jWaPBj6Dw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:18 +0200
Subject: [PATCH RFC v2 02/18] super: convert s_count to refcount_t
 s_passive
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-2-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4567; i=brauner@kernel.org;
 h=from:subject:message-id; bh=y54UXAJRPaUH3JPt09MKqM3AXvuTz0c3R1gVHeRUQ3I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzbu6L88yErjpcyu+yyM06eKZGvXtfXuyklteNt0
 ELLT+e8O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZy5yrDLyYXzyU9r05a/gxW
 eSi0ueSC65yY7ae//AxWSrdrkbW8z8/wPyJ8l+K+H6YGc4sLr5tJ3NjnHvnZ6472iXMFXurSKx5
 c5QcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The superblock carries two counters: s_active, the active reference
count that keeps the filesystem usable, and s_count, the passive
reference count that merely keeps the structure itself alive. Turn the
passive count into a refcount_t and rename it to s_passive to make the
pairing with s_active obvious.

Everything is still serialized by sb_lock, so there is no functional
change; the conversion buys the usual refcount_t saturation and
underflow checking. The following patches start dropping passive
references without holding sb_lock and make the device-to-superblock
table hold one passive reference per registered entry, which a plain
integer cannot support.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c                     | 18 +++++++++---------
 include/linux/fs/super_types.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a8fd61136aaf..25dd72b550e0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -102,7 +102,7 @@ static bool super_flags(const struct super_block *sb, unsigned int flags)
  * creation will succeed and SB_BORN is set by vfs_get_tree() or we're
  * woken and we'll see SB_DYING.
  *
- * The caller must have acquired a temporary reference on @sb->s_count.
+ * The caller must have acquired a temporary reference on @sb->s_passive.
  *
  * Return: The function returns true if SB_BORN was set and with
  *         s_umount held. The function returns false if SB_DYING was
@@ -367,7 +367,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	spin_lock_init(&s->s_inode_wblist_lock);
 	fserror_mount(s);
 
-	s->s_count = 1;
+	refcount_set(&s->s_passive, 1);
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
@@ -407,7 +407,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
  */
 static void __put_super(struct super_block *s)
 {
-	if (!--s->s_count) {
+	if (refcount_dec_and_test(&s->s_passive)) {
 		list_del_init(&s->s_list);
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
@@ -529,7 +529,7 @@ static bool grab_super(struct super_block *sb)
 {
 	bool locked;
 
-	sb->s_count++;
+	refcount_inc(&sb->s_passive);
 	spin_unlock(&sb_lock);
 	locked = super_lock_excl(sb);
 	if (locked) {
@@ -556,7 +556,7 @@ static bool grab_super(struct super_block *sb)
  *	lock held in read mode in case of success. On successful return,
  *	the caller must drop the s_umount lock when done.
  *
- *	Note that unlike get_super() et.al. this one does *not* bump ->s_count.
+ *	Note that unlike get_super() et.al. this one does *not* bump ->s_passive.
  *	The reason why it's safe is that we are OK with doing trylock instead
  *	of down_read().  There's a couple of places that are OK with that, but
  *	it's very much not a general-purpose interface.
@@ -858,7 +858,7 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
-		sb->s_count++;
+		refcount_inc(&sb->s_passive);
 		spin_unlock(&sb_lock);
 
 		if (flags & SUPER_ITER_UNLOCKED) {
@@ -903,7 +903,7 @@ void iterate_supers_type(struct file_system_type *type,
 		if (super_flags(sb, SB_DYING))
 			continue;
 
-		sb->s_count++;
+		refcount_inc(&sb->s_passive);
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
@@ -935,7 +935,7 @@ struct super_block *user_get_super(dev_t dev, bool excl)
 		if (sb->s_dev != dev)
 			continue;
 
-		sb->s_count++;
+		refcount_inc(&sb->s_passive);
 		spin_unlock(&sb_lock);
 
 		locked = super_lock(sb, excl);
@@ -1369,7 +1369,7 @@ static struct super_block *bdev_super_lock(struct block_device *bdev, bool excl)
 
 	/* Make sure sb doesn't go away from under us */
 	spin_lock(&sb_lock);
-	sb->s_count++;
+	refcount_inc(&sb->s_passive);
 	spin_unlock(&sb_lock);
 
 	mutex_unlock(&bdev->bd_holder_lock);
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ef7941e9dc79..68747182abf9 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -145,7 +145,7 @@ struct super_block {
 	unsigned long				s_magic;
 	struct dentry				*s_root;
 	struct rw_semaphore			s_umount;
-	int					s_count;
+	refcount_t				s_passive;
 	atomic_t				s_active;
 #ifdef CONFIG_SECURITY
 	void					*s_security;

-- 
2.47.3


