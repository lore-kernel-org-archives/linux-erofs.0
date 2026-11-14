Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2D7606A337
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHocOdW6
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZGz3yf1z3f1f;
	Sun, 15 Nov 2026 00:10:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661803;
	cv=none; b=Y+duFeXrHyWEVMqeaZXS5+l6mPYL0b911lheyJd/ybFp8cJJ3TDeUZbnyEenwvNNG5VY5XEwQQcrHK1ozWWszPC5+56lI21XjfmE6/AD1ET5m4v4xXMdkMKx5xmt0mxwZkYk5vOrVT8GeSgvdEoohpNM+5E9t5+tQj0lPYTAzv51GfDzSiZF99URgRs/296zQ5F91dX3rD3BfzrML+WQPIpuvNtXWRkpogJi4/pd9ZH/HyE2R4DvIEilnDa+hSkJPqYAk5DmukLiq5aYPLHonijHjInL2rYRnZtApAY/ZfkmzPvbRmnG+crxFFNZbUEXBsgBpzK3M7rGhzHj+pFu/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661803; c=relaxed/relaxed;
	bh=BtdVhasomzr0bfxo27t8Irh0dfW28m0T6GW65uzhTXc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m8xtLilZYR1hmh3gocT9O9ZkC3IHeAGREDQrO/CHouCnoGADZl3071PBJshT4k961eqaEKg0/rVw7u4LIbaoUQsRd3qUWl4lIxDR/66Vl/7sFU2ZgqLEKl8NRCIzQzKVifQSPS0gVFWP0nNbYPMx6TsK/lGMETnFA1M6na5JMT5zTQRfPDOFzyisq6c3hS+VQvI1o7Gdf1zF3wimwXkLFgtnl/+y2zRV5J1GusBS9FPe5rl3brVuTW4hxZ1twJttDfeDQYeQDXawEbFtSswTT2FZ+NdfBuQ1THzHHOaioA7jowQ4+uOwGJ10hVoocYqAR8+uORRF2CeDv3xdX/ye5g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHocOdW6; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHocOdW6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZGy5PwSz3f1c;
	Sun, 15 Nov 2026 00:10:02 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4162140C03;
	Sat, 14 Nov 2026 13:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF01F000C5;
	Sat, 14 Nov 2026 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661801;
	bh=BtdVhasomzr0bfxo27t8Irh0dfW28m0T6GW65uzhTXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RHocOdW6W3FpasM0EYmnFsXgxF36o/JK6WS2DdytW5tVYqJjWMISgUoBOsWmYXoz8
	 8cuAgHtoR3/4JGCuVTBVa6TNJzyWo7Rn8kALoXvU81rS7TBOcX/WeoOhTQDeQjMX1N
	 KTmcoH8tEAJXXnQi+46MgcKsaJ74xkFRIMalxhSu0fRwUdgfRAmprIgYcxclGQpVpv
	 m/OYB5cOGueEYAb6sJxKMVFXTu9cdUT7Nz1FJ5RJGAOqZBnLtSGyEic+ZCGuIFWNTT
	 NyjKBdSXxoQ0RtqgYl2GTfzZ0SkSuzexfL2JtdazdHQZOrpYXI9dQcaGC8BVxNjlwb
	 I3tgtCasNQh1g==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:19 +0100
Subject: [PATCH RFC v2 38/42] fuse: refuse files on pseudo filesystems as
 passthrough backing files
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-38-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1390; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2GPVGdPmuRydfdxygQI1vepom0ppxgkvC8v8Lqvdx8k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJnomXd12pWfUVWTpW7s1uFaJbz65rLkQEZN5j6RF
 KY/m6Jud5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEW4Phr1xIEuNTx1T/Ht6n
 hlVu3fM+HJX4fO0n7+/d4fcSF9yrfcrIcJjh3o3qm9JZX1wXNHfOCRb+0heYGJQ1wecpZ/6UMiF
 XTgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fuse server can register any regular file as a backing file. procfs
and binfmt_misc files are already refused by the stacking depth check as
both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
other pseudo filesystems aren't. Reads and writes of the fuse file would
then be done on the pseudo file with the fuse server's credentials.
Refuse files on pseudo filesystems just like loop does.

Note that the backing file is only registered here and opened again for
every fuse file that uses it. Only its path is used and O_PATH file
descriptors are allowed since commit efad7153bf93 ("fuse: allow O_PATH
fd for FUSE_DEV_IOC_BACKING_OPEN"). So pass FMODE_PATH to
file_check_backing() to keep them working.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/backing.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 8c21a8a74efb9..7527f3ecb90dc 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -147,6 +147,10 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
 		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
 			return -ELOOP;
 
+		err = file_check_backing(file, FMODE_PATH, 0);
+		if (err)
+			return err;
+
 		fb->type = FUSE_BACKING_PATH;
 		fb->path = file->f_path;
 		path_get(&fb->path);

-- 
2.53.0


