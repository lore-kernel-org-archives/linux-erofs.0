Return-Path: <linux-erofs+bounces-4002-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C575EC531FA
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Jul 2026 15:53:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6CG51S7Wz2yYf;
	Sat, 25 Jul 2026 01:53:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784908429;
	cv=none; b=Y1oMkLK87E1MzrXJbwkjybt08YmxlNO00QfqnpD3OxGe1VlA7xKZR2xXXABUt7PiOfFMepryfTgzarIdEVsWcwnzYOcxw/a/BPoRbi3QqjNOaFy6HldXy7Jbp8MKZWLYZpyTfjqnqLMR1CtX3s1BSVE14PK0P3VBVoDw0i3K5wTLxD1IUd5xZu4lFl7PlZxypQc27KjTByre42pEVP7xyvA6/hUEvfyfq2fYDiqyiA+vnwcYWFhNMYTtSVN5UfgWavTr2+7B6cpzborDSBXyX4yXyl65EZSCQhoNIxYvCr6vFtb6cl2Q6bQmuvoxdMsf9N8XNcpCEqye663doiojIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784908429; c=relaxed/relaxed;
	bh=ZnqR5gKjEk3onHIHqUsBiKsnooxZDGmPujYmSJLEUME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XulVSCujSRCmsyRCrw1zs5Ixkv44pOvCqICO2i+gbkH/WL8VWxTih+tL7FXAU5BtZB1v+omjbFWJzq0O6rWEwgN15LPYnW1u6ePQ1eEoJql2oTk2yVXB1qt7bEC4YW8EGxEKUN0AWY4Hplevlp6WPKsioiYIZGQpWLSJp9WOdI4MlarRtI+A9jesIq8G96YCuuC0Z+L7MTCatlu4N9Myf4zp4o0/pxQxngTvntqTn/UZH0j8d7CJj+AOF29MKZydtWpRmoVww95tynFEroR4ENPR6JbuNH6mJGZD8Ut14LPQmyNljGhFqdGJZDcGZrZLlSWx2vwdoqA4m6vk1/womw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ldEces5k; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ldEces5k;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6CG42Gqvz2yFg
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 01:53:48 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44AEA600DA;
	Fri, 24 Jul 2026 15:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2941F000E9;
	Fri, 24 Jul 2026 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784908426;
	bh=ZnqR5gKjEk3onHIHqUsBiKsnooxZDGmPujYmSJLEUME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ldEces5k5cxZbb37bXdoWNpleDJLDzMp6JMfaas2bE0OxFBn7gS9R98iXCnp9oTuE
	 AChxgpRQXAQvmnSq1UCBae/netCuVzetF4PeBcefmzuUbbOyUxQQj5fmd6QEkmfqo7
	 984tchlDV1G+1Z6O8yI2ob7kuQMzOnIjZkdfDGiNk18U5QKgaFnXO4Hf8m4LTC9q/+
	 VhGZfc8MKR488Gpdk+gIH5fhMMHNitGzCGJeesehNCeoGPw6e6PkLTeRFbQkD3Py4L
	 u8/on3EBok1/l9lC57QOgHWfqXWvYfEJVz2uKpL8x2WilTMUt67zUkyhZywmS+kPJ1
	 24LUhp9D5vp7g==
Date: Fri, 24 Jul 2026 23:53:40 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH v2 2/2] fsck.erofs: implement concurrent directory
 traversal
Message-ID: <amOKhDBV7eXUlsui@debian>
Mail-Followup-To: Nithurshen <nithurshen.dev@gmail.com>,
	hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
References: <20260621120121.73114-3-nithurshen.dev@gmail.com>
 <20260724143556.80914-1-nithurshen.dev@gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260724143556.80914-1-nithurshen.dev@gmail.com>

On Fri, Jul 24, 2026 at 08:05:56PM +0530, Nithurshen wrote:
> Currently, fsck.erofs traverses the filesystem tree and verifies
> inodes synchronously on the main thread. While data decompression is
> offloaded, the main thread remains a bottleneck during the I/O-heavy
> directory walk.
> 
> This patch parallelizes the directory traversal and inode extraction
> processes. To achieve this safely, globally shared states such as
> fsckcfg.extract_path and fsckcfg.dirstack are decoupled and localized
> into individual struct erofsfsck_inode_task payloads. These payloads
> are dispatched to a dedicated traversal worker pool.
> 
> Global statistics and hardlink tables are now secured using native
> erofs_mutex_t primitives. By isolating the traversal producers from
> the pcluster decompression consumers, the pipeline scales across
> directories without thread pool starvation.
> 
> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>

Checkpatch reports:

WARNING: line length of 123 exceeds 100 columns
#56: FILE: fsck/main.c:28:
+static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid, const char *path, struct erofsfsck_dirstack *dirstack);

ERROR: do not initialise statics to NULL
#73: FILE: fsck/main.c:45:
+static struct erofsfsck_inode_task *traverse_head = NULL;

ERROR: do not initialise statics to NULL
#74: FILE: fsck/main.c:46:
+static struct erofsfsck_inode_task *traverse_tail = NULL;

ERROR: do not initialise statics to 0
#75: FILE: fsck/main.c:47:
+static int traverse_pending_tasks = 0;

ERROR: do not initialise statics to false
#76: FILE: fsck/main.c:48:
+static bool traverse_shutdown = false;

ERROR: do not initialise statics to 0
#79: FILE: fsck/main.c:51:
+static int traverse_final_err = 0;

WARNING: static char array declaration should probably be static const char
#82: FILE: fsck/main.c:54:
+static char erofsfsck_nullstr[] = "";

WARNING: line length of 123 exceeds 100 columns
#205: FILE: fsck/main.c:747:
+static int erofsfsck_enqueue_task(erofs_nid_t pnid, erofs_nid_t nid, const char *path, struct erofsfsck_dirstack *dirstack)

WARNING: Missing a blank line after declarations
#210: FILE: fsck/main.c:752:
+		struct erofsfsck_inode_task *task = malloc(sizeof(*task));
+		if (!task) return -ENOMEM;

ERROR: trailing statements should be on next line
#210: FILE: fsck/main.c:752:
+		if (!task) return -ENOMEM;

ERROR: trailing whitespace
#211: FILE: fsck/main.c:753:
+^I^I$

ERROR: trailing statements should be on next line
#221: FILE: fsck/main.c:763:
+			if (task->path) free(task->path);

ERROR: trailing whitespace
#225: FILE: fsck/main.c:767:
+^I^I$

ERROR: trailing statements should be on next line
#226: FILE: fsck/main.c:768:
+		if (!traverse_tail) traverse_head = traverse_tail = task;

ERROR: trailing statements should be on next line
#239: FILE: fsck/main.c:781:
+	if (err && !traverse_final_err) traverse_final_err = err;

ERROR: trailing whitespace
#249: FILE: fsck/main.c:791:
+^I^I$

ERROR: trailing whitespace
#258: FILE: fsck/main.c:800:
+^I^I$

ERROR: trailing statements should be on next line
#261: FILE: fsck/main.c:803:
+		if (!traverse_head) traverse_tail = NULL;

ERROR: trailing statements should be on next line
#267: FILE: fsck/main.c:809:
+		if (err && !traverse_final_err) traverse_final_err = err;

ERROR: trailing statements should be on next line
#273: FILE: fsck/main.c:815:
+		if (task->path) free(task->path);

ERROR: trailing statements should be on next line
#290: FILE: fsck/main.c:832:
+	if (traverse_num_workers <= 1) return 0;

ERROR: trailing whitespace
#291: FILE: fsck/main.c:833:
+^I$

ERROR: trailing statements should be on next line
#293: FILE: fsck/main.c:835:
+	if (!traverse_workers) return -ENOMEM;

ERROR: trailing whitespace
#294: FILE: fsck/main.c:836:
+^I$

ERROR: trailing whitespace
#309: FILE: fsck/main.c:851:
+^I^I$

ERROR: trailing whitespace
#312: FILE: fsck/main.c:854:
+^I^I$

ERROR: trailing statements should be on next line
#327: FILE: fsck/main.c:869:
+	if (traverse_num_workers <= 1) return traverse_final_err;

WARNING: Missing a blank line after declarations
#333: FILE: fsck/main.c:875:
+	int err = traverse_final_err;
+	erofs_mutex_unlock(&traverse_mtx);

ERROR: "foo* bar" should be "foo *bar"
#345: FILE: fsck/main.c:887:
+	char* path = NULL;

WARNING: line length of 101 exceeds 100 columns
#414: FILE: fsck/main.c:1025:
+					erofs_err("failed to remove: %s (%s)",path, strerror(errno));

ERROR: space required after that ',' (ctx:VxV)
#414: FILE: fsck/main.c:1025:
+					erofs_err("failed to remove: %s (%s)",path, strerror(errno));
 					                                     ^

WARNING: line length of 103 exceeds 100 columns
#422: FILE: fsck/main.c:1030:
+				erofs_err("failed to set permissions: %s (%s)", path, strerror(errno));

WARNING: suspect code indent for conditional statements (0, 16)
#548: FILE: fsck/main.c:1164:
+if (fctx->path) {
+		size_t prev_len = strlen(fctx->path);

WARNING: Missing a blank line after declarations
#551: FILE: fsck/main.c:1167:
+		size_t curr_len = prev_len + ctx->de_namelen + 1;
+		if (curr_len >= PATH_MAX) {

WARNING: line length of 116 exceeds 100 columns
#552: FILE: fsck/main.c:1168:
+			erofs_err("unable to fsck since the path is too long (%llu)", (unsigned long long)curr_len);

ERROR: trailing statements should be on next line
#556: FILE: fsck/main.c:1172:
+		if (!newpath) return -ENOMEM;

WARNING: braces {} are not necessary for single statement blocks
#575: FILE: fsck/main.c:1178:
+		if (!is_root) {
+			newpath[offset++] = '/';
+		}

ERROR: trailing statements should be on next line
#589: FILE: fsck/main.c:1187:
+	if (newpath) free(newpath);

WARNING: line length of 122 exceeds 100 columns
#645: FILE: fsck/main.c:1242:
+static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid, const char *path, struct erofsfsck_dirstack *dirstack)

ERROR: trailing statements should be on next line
#701: FILE: fsck/main.c:1297:
+		if (ret == -ECANCELED) ret = 0;

ERROR: trailing whitespace
#753: FILE: fsck/main.c:1421:
+^I^I^Ierr = erofsfsck_enqueue_task(g_sbi.packed_nid, g_sbi.packed_nid, $

WARNING: Missing a blank line after declarations
#753: FILE: fsck/main.c:1421:
+			struct erofsfsck_dirstack empty_dirstack = {0};
+			err = erofsfsck_enqueue_task(g_sbi.packed_nid, g_sbi.packed_nid, 

WARNING: line length of 103 exceeds 100 columns
#772: FILE: fsck/main.c:1449:
+		err = erofsfsck_enqueue_task(pnid, fsckcfg.nid, fsckcfg.extract_path, &empty_dirstack);

WARNING: Missing a blank line after declarations
#772: FILE: fsck/main.c:1449:
+		struct erofsfsck_dirstack empty_dirstack = {0};
+		err = erofsfsck_enqueue_task(pnid, fsckcfg.nid, fsckcfg.extract_path, &empty_dirstack);

WARNING: Missing a blank line after declarations
#774: FILE: fsck/main.c:1451:
+		int wait_err = erofsfsck_traverse_mt_wait();
+		if (wait_err && !err)

WARNING: adding a line without newline at end of file
#824: FILE: include/erofs/cond.h:31:
+#endif




