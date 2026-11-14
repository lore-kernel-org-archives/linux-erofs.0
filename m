Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FB8606A329
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lC1rRmz7
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRbH038Ymz3fCw;
	Sun, 15 Nov 2026 00:55:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794664508;
	cv=none; b=h26lx9xxkVk5c3QSMH12DPm+u6PjfZoSJ41m9Qv/iZkMwOVVRgOG8R9lr6hHaFxAck/2RHQtTkata1MwJhC/EtuW76sSUvZO8ORnmWyRaIBDQojreRkfnTZuKj61L0focr7Dsyo+qg+7Xe3q9eQD8aTMhq7vsqFqBnlCzoD7e0suFuX+lL2ISRh9VrPqC1qSBTWXvbvM4UspTrw448IFAlqxyKzXgOo1Crn6edfX7JluYn4CMCp784XMfvAPAtB7KFjqmsTu5D9cQgOsRPkLbmpOAH/xoG+ML7tQUstRBHAjlcnlJOxxmKgDglGNVua0gHbpSyO7SD3LABEYY2UGgA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794664508; c=relaxed/relaxed;
	bh=gZCOg3PYW5/XzYktPPO7fZbRJ9jC/nh9/3WC5LHdP9k=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=E6aH3pu3VnDLuhP2HzBTvlwUsY3xr6PpUSQxMGB6ijHhSd3OKGvndVaQ+c515q/x8v+cYBlA7uMFxikZ+Zn5W91llZAQ9mzRBtksJAJrA+uIXdg8zNoN3q7Cvzg5HsTzw6TtfkOvGPxelFoqiDi2n2b1WxMB3uj1d/2eCiqaICkEUNrhEou+uzeRwdqIyEhWa79TFiTxJbbR3CKkskqWkOHZSPneDMzjyq/DNgvyEUMqolxvSi7Kkgw9e08WLBDe547Qt6LvYw3P0laabulzdyncL80xLw6Jn9F4Q1McXevM7dnPFw0mSxSuWYaRh/NvFIhGX23pz8Vc5qTbHbudxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lC1rRmz7; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lC1rRmz7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRbGz5FjXz3bY7;
	Sun, 15 Nov 2026 00:55:07 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B2EF45800;
	Sat, 14 Nov 2026 13:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73891F000C5;
	Sat, 14 Nov 2026 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664506;
	bh=gZCOg3PYW5/XzYktPPO7fZbRJ9jC/nh9/3WC5LHdP9k=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=lC1rRmz7ahj/srEYA2ijCYwgAqxvBpBEiZzJTz1BT/wrTEWhRCAJRjIQUg90ualPp
	 8fNiGIog6yGBq7jcPWwPg3KTZ4hhP7wzOgQinag8fVT+8JrN/YD10tUBIHBk4t50YO
	 lVbRqj+kObH/VFAULApyIEa7KJo13ikHhn4sjSYyAVLzN15VB21GTINJSJZ5zSjoJ2
	 SqbEpuE67Y8c73FjyTC9QAtGI69lnMt18W/xx4/7c8YFqB+lo9IQTij1vjYC2G1yJC
	 gbXcz8wGq7FFvOpMP/hQpyy359bbb1860T3yz8/mr3WEBUyRt+SVvwAJEu6hB8hDoE
	 Jru9mkTF+Jtaw==
Content-Type: multipart/mixed; boundary="===============0802335019258284520=="
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
Message-Id: <91e245da9f3df6d6e61808e72a4ad0213a9a6b838f594d0be74dd70ab228422f@mail.kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 13:55:02 +0000 (UTC)
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0802335019258284520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: add file_check_backing()

TL;DR: file_check_backing() may call d_real_inode() on O_PATH overlayfs files,
which could hit WARN in ovl_d_real() (panic with panic_on_warn) and let the
pseudo-fs check pass wrongly; reachable via fuse backing open, needs
CAP_SYS_ADMIN.

> diff --git a/fs/read_write.c b/fs/read_write.c
> --- a/fs/read_write.c
> +++ b/fs/read_write.c

[ ... ]

> +int file_check_backing(const struct file *file, fmode_t mode, umode_t type)
> +{

[ ... ]

> +	/* Look through stacking filesystems at the inode with the data. */
> +	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;

With FMODE_PATH accepted, can d_real_inode() be reached for an O_PATH file
here?  No ->open() has run on such a file.

For an overlayfs metacopy file whose data is in a data-only lower layer,
the lowerdata redirect is only resolved lazily, by ovl_open() via
ovl_verify_lowerdata() or by ovl_d_real().  For an O_PATH file this means
d_real_inode() goes into ovl_d_real(), which does the lookup and verity
check itself:

    err = ovl_verify_lowerdata(dentry);
    if (err)
        goto bug;
    ...
bug:
    WARN(1, "%s(%pd4, %d): real dentry not found\n", __func__, dentry, type);
    return dentry;

ovl_maybe_lookup_lowerdata() treats a failed lookup as a normal runtime
event (pr_warn_ratelimited("lazy lowerdata lookup failed ...")).  It can
also return -EINTR from ovl_inode_lock_interruptible(), and
ovl_maybe_validate_verity() returns -EIO for a missing or wrong digest with
verity=require.  Each of these would hit WARN(1) when reached through this
helper, which panics with panic_on_warn.

In that case ovl_d_real() returns the overlayfs dentry, so the SB_I_PSEUDO
test looks at the overlayfs superblock and passes.  Does the check fail
open there?

Nothing calls the helper in this commit, but later in the series
f79b9e79484f ("fuse: refuse files on pseudo filesystems as passthrough
backing files") adds file_check_backing(file, FMODE_PATH, 0) to
fuse_backing_open_file().  That gets its fd via CLASS(fd_raw), which
accepts O_PATH:

FUSE_DEV_IOC_BACKING_OPEN
  fuse_backing_new()
    fuse_backing_open_file()
      file_check_backing()
        d_real_inode()
          ovl_d_real()
            ovl_verify_lowerdata() fails -> WARN

This needs CAP_SYS_ADMIN and an overlayfs with data-only layers where the
data file is missing, the digest check fails, or the inode lock is
contended while a signal is pending.  No fix for this was found later in
the series.

Could the pseudo filesystem check avoid forcing the lazy lowerdata lookup
on O_PATH files, or should ovl_d_real() stop warning on lookup failures now
that it has callers besides trace_uprobe?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43599461726
--===============0802335019258284520==--

