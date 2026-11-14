Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A587606A8AE
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GlyL6zOy
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZGk2bH1z3dvx;
	Sun, 15 Nov 2026 00:09:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661790;
	cv=none; b=RLW0Jen/YAc3jIyE9ajjV/Q14iXfk9mU/4J8DyGBGvXreL/P81GiH0B++qBM6PehlpbtlskxQTAuCcbNN4zVmBL/ujyaMltIH3a+5rpOGWn91n6NbiSrfh+zxgKbwAzsRrtCmoSyfbRDpWS7CYoubnm3Xr/RXc3bvnr1b+4Oz0473kbh1RUhs4bZwsvNtx4Y4ZzJKnYnNkH3Kw6o8HS8brkCp05+d70lndSBNZiJgPoowtQzAYu0Ky3o+KsnhH+uTuaN+mPcEaCIVygXOXlfDrF9H1/AC0dtiFVQGecjP28hYBn1YCUCJlhn+KUXxj/kSyPAItG5iduQka6i3jDiFw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661790; c=relaxed/relaxed;
	bh=TzlH4lJ7ZSZIblRm06H21pfwXJAWDZmkD7RxeUrwAwo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JJKJaNdW1i3Ukfi1xaT6u71WkzEp04b902n+4CziNEBwyGUSlfUTZ4jDdWsP/kCtsF0A72kHYXNy0Cq1zyFM4ubNxUP+l1UhVyD9WkzA5+PYjD/8WXHNsGoUzABQlM9rB3tZzjjCy2SXT2tUHlPhsvgCLA8XU6uohU9Pwi7Ek8od75nv9VWyGpVUPvMurJusknSMs+dfq2B+S+1t80Gu9DWqjN6trjnZOpGlo6z39DxzgKr/xGI1EtKZnPzxhOOJDt+zByriOeJEyKBTycRivyFP0vNuQagXJR00PSqxxP85jvhf6E119/Sdr/jQxTjdPtXJE54rggM8iq0F2a4kPg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GlyL6zOy; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GlyL6zOy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZGj4FDdz3dh2;
	Sun, 15 Nov 2026 00:09:49 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A060465D8;
	Sat, 14 Nov 2026 13:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF37C1F000C5;
	Sat, 14 Nov 2026 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661788;
	bh=TzlH4lJ7ZSZIblRm06H21pfwXJAWDZmkD7RxeUrwAwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GlyL6zOy3U34aQUy3eHEQO1vIyJXeAiTdOGtABLlkjbMnvKHjyhKDScl3Hk7rbn/i
	 bUN/hnUMxKho/1WWAiF8JiculAXTejCCuJ3FonfhnSNp937ufCy4qoRmfbGVvZHsH7
	 9rlf5d2C3SdZVqBTg4J8yIIUsxC5D98LB2FsGhf59wAx6+iIV/zNQO/IKTaGaMPHTI
	 VX46CiB8pXPS+hXzwpsFz2BDETD3xysRH8Rj/RJaz/eTFDnVWydJvu5JEiwzj8rnWQ
	 EWDXUNsiasluJEgOXK7yZCzr+ogHhW+EDBwb4kKVBL61Tujac2yGBy06BywSGLd7Mo
	 Pny//KWEyQopg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:17 +0100
Subject: [PATCH RFC v2 36/42] nvmet: refuse files on pseudo filesystems as
 namespace backing files
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
Message-Id: <20261114-work-loop-pseudo-v2-36-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1428; i=brauner@kernel.org;
 h=from:subject:message-id; bh=T+p95LnTvG69fzj91gxDjYpoYRzamfjNk16RgT8U7v8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOn/sX7W5ofcrzdtZCmXtdsrsyZy06+ylnkxnetWq
 G9bLL97VkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBElN4x/E+qPMN83LkkV8+9
 6emz+TtUM58mNc28vP//+pR517bGGTYz/NOw1Z5h9eBm2/zf+wUFPT6nLXtx+IKQe7yGYPaa6P/
 27ZwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend takes any file that can be opened for reading and
writing. With buffered_io=1 that includes files on procfs or sysfs which
then get read and written by a kernel worker on behalf of the host.
Refuse files on pseudo filesystems just like loop does by switching to
file_check_backing().

Note that the helper only accepts regular files and block devices. A
block device ends up in the file backend when buffered_io is set. But
so far the file backend also took anything else with ->read_iter() and
->write_iter() such as character devices and FIFOs. The size of the
namespace is the size of the inode which is zero for all of them. So
such a namespace was unusable anyway. Refuse them.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index dfa8aa46188c8..2249ad3bb46d8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,10 +47,9 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
-	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
-		ret = -EINVAL;
+	ret = file_check_backing(ns->file, FMODE_READ | FMODE_WRITE, S_IFBLK);
+	if (ret)
 		goto err;
-	}
 
 	nvmet_file_ns_revalidate(ns);
 

-- 
2.53.0


