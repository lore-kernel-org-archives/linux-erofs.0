Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDFE606A33D
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 12:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGs9hgRo
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSmdf4DD6z3c52;
	Mon, 16 Nov 2026 23:00:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794830422;
	cv=none; b=nLK4lI9961ABge9BStbnp3LG44BmFAdzX8n9k/AuZcYW5NNJ1tgMjd31kHBbXowZYmND9mYT3qAlAtqthiJJo2BZ0h1oar2KvR5nj3EBf1OgiKlCFtIY861WTEKG9jrkHZr1yFclht9ixMI5uSiigIcm5MnDtSnuCqXIUi27UqtY0hl+zDLSRH4lAQnTSSbXNc9IL/Dfguu1Qp4cnwJ5bJOSNF5kpCQyrty1gh6Eps5egWAI6gxhltYbNlh8JJ/PpXNjDEbRFI65gsKWYxQLsO/FNMWlf2d9FtDdOY+UqMN+rBaf5o6ZgRlziOcyitbF4epIkb6zWSvOH3rJI99/sg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794830422; c=relaxed/relaxed;
	bh=ewJeUaksgXnSPjHwujvoiDsCY2620AwnIo92RczcOPg=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=f0UokKDcI5yGs1y6TEPAushAxk7Xg/FOUyt88pPB3eMMgx2lv9IFr25eEO3qc+w1xZcDHso1EuvrJLEsEeXBvkNUgt62DPKlEjsAGveG7ZzQ3jttr5/Uhnzh9oqwRMr75pGAnjzmYRIMEggDmWU/I8C8V08Ky3YgbdS9gE0EEfcccNMtXUqWe+9qFTW4ExG9+QtPpXgi1S+59seGwZ0qHtuXzIhEoIUYLNgH6UcOnaS+OTL34h4yOXyVWG32ThBsB4UyuHH0uCaWjlBCO+D4HkTXlDpfjTX5tw2U9m9BX+yK34nv/LTqUxCTscYyn7H5Iy0QEgwflFZjgDLjFeMVgQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGs9hgRo; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGs9hgRo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSmdd5kq0z3byF;
	Mon, 16 Nov 2026 23:00:21 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9956A62984;
	Mon, 16 Nov 2026 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1241F000C4;
	Mon, 16 Nov 2026 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830419;
	bh=ewJeUaksgXnSPjHwujvoiDsCY2620AwnIo92RczcOPg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=NGs9hgRo8Pm53dwqOowj804JfWGt9pNSxyXsA5ZbufV3wNEO1pXrEV/P2nYSJ6s0h
	 RkTVtrJGGRLTAc/i5stGgdH7MoEG/RRlQzCp8xsSKAlYN1LFViwB+sXdk4YoAbt7yZ
	 PR7EK3GRWabIulVC1l0sYiPb/s/WJh1GIS+NuEi9fxzz0zXVvfrqLfrCezMd74ZtjC
	 IEP94sDVVDwuNz+mWo090jAlScdWhDl8h+8NtgR+BEvWRcqbaBD+sHm90zfAZDrFLE
	 Ium0YC6BRRHbiChOy1fGM3bxcnzkJeY8LsKxgOeIXXUZU9bjQC0KNhILzz6Uz/yD+e
	 WluvUktyVhSBw==
Content-Type: multipart/mixed; boundary="===============1962703051549190966=="
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
Message-Id: <56b5bed0bd75b5b0c7368009493734cda89f1ca37c0fc29c81ed65048cbfeca4@mail.kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-44-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-44-8cbbea1cf34f@kernel.org>
Subject: Re: [PATCH RFC v3 44/44] selftests/filesystems: add backing file tests for pseudo files
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,alex@amutable.com,chris@chrisdown.name,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 16 Nov 2026 12:00:17 +0000 (UTC)
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============1962703051549190966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/filesystems: add backing file tests for pseudo files

TL;DR:
- Selftest: fuse tests may fail instead of skip without
  CONFIG_FUSE_PASSTHROUGH (-EOPNOTSUPP, not -EPERM)
- Metacopy test may fail without CONFIG_TMPFS_XATTR
- Minor duplicated setup code

> diff --git a/tools/testing/selftests/filesystems/config b/tools/testing/selftests/filesystems/config
> --- a/tools/testing/selftests/filesystems/config
> +++ b/tools/testing/selftests/filesystems/config
> @@ -6,3 +6,19 @@ CONFIG_NET=y
>  CONFIG_NET_NS=y
>  CONFIG_INET=y
>  CONFIG_SYSFS=y
> +CONFIG_BLK_DEV_LOOP=y
> +CONFIG_OVERLAY_FS=y
> +CONFIG_TMPFS=y
> +CONFIG_CONFIGFS_FS=y
[ ... ]

Should CONFIG_TMPFS_XATTR=y be added here as well?

TEST(fuse_passthrough_overlayfs_metacopy_file) mounts a private tmpfs
through setup_tmp() and then does:

    ASSERT_EQ(setxattr("/tmp/lower/file", "trusted.overlay.metacopy",
                       "", 0, 0), 0);

shmem_fill_super() only sets sb->s_xattr under CONFIG_TMPFS_XATTR, which
defaults to n, and CONFIG_TMPFS does not select it.  Without it
setxattr() fails with EOPNOTSUPP, the ASSERT_EQ() aborts, and the run
reports a failure rather than a skip.  tools/testing/selftests/landlock/config
lists CONFIG_TMPFS_XATTR=y next to CONFIG_TMPFS=y.

Alternatively the test could SKIP when setxattr() returns EOPNOTSUPP.

> diff --git a/tools/testing/selftests/filesystems/pseudo_backing_test.c b/tools/testing/selftests/filesystems/pseudo_backing_test.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/pseudo_backing_test.c

[ ... ]

> +TEST(overlayfs_on_sysfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
> +	ASSERT_EQ(mount("tmpfs", "/tmp", "tmpfs", 0, NULL), 0);

this isn't a bug, but could overlayfs_on_sysfs_backing_file() call
ASSERT_EQ(setup_tmp(), 0) like the other tests, instead of repeating its
three steps?  Similarly, usb_mass_storage_backing_file() repeats the
statfs()/CONFIGFS_MAGIC/mount() logic of setup_configfs(), and the comment
"Mounting configfs on top of itself fails with EBUSY." appears twice.

[ ... ]

> +TEST(fuse_passthrough_backing_file)
> +{
> +	int fuse_fd, ret;
> +
[ ... ]
> +	ASSERT_EQ(create_file("/tmp/file"), 0);
> +	ret = fuse_backing_path(fuse_fd, "/tmp/file", O_PATH);
> +	if (ret == -EPERM)
> +		SKIP(return, "no fuse passthrough");
> +	EXPECT_EQ(ret, 0);

Is -EPERM the right errno to key the skip on?  On a kernel with
CONFIG_FUSE_FS=y and CONFIG_FUSE_PASSTHROUGH=n the test filesystem mounts
fine, and then fuse_dev_ioctl_backing_open() returns before any
permission check:

    if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
        return -EOPNOTSUPP;

-EPERM only comes from fuse_backing_open_file() when fc->passthrough is
clear or CAP_SYS_ADMIN is missing.  So here EXPECT_EQ(ret, 0) and the
later -EINVAL checks see -EOPNOTSUPP and fail, and the harness records
"not ok" for a feature that is not configured.  Kernels that predate
FUSE_DEV_IOC_BACKING_OPEN return -ENOTTY and fail the same way.

Should -EOPNOTSUPP (and possibly -ENOTTY) also lead to the SKIP?

[ ... ]

> +TEST(fuse_passthrough_overlayfs_metacopy_file)
[ ... ]
> +	ASSERT_EQ(create_file("/tmp/lower/file"), 0);
> +	ASSERT_EQ(setxattr("/tmp/lower/file", "trusted.overlay.metacopy",
> +			   "", 0, 0), 0);
> +	ASSERT_EQ(setxattr("/tmp/lower/file", "trusted.overlay.redirect",
> +			   "/missing", strlen("/missing"), 0), 0);

Can these setxattr() calls fail on a kernel without CONFIG_TMPFS_XATTR?

The private tmpfs from setup_tmp() has no xattr handlers in that case, so
setxattr() returns EOPNOTSUPP, the ASSERT_EQ() aborts, and the program
exits with a failure instead of KSFT_SKIP.  The mount of overlayfs just
below already has a SKIP for missing support.  Would a SKIP on
EOPNOTSUPP here, or CONFIG_TMPFS_XATTR=y in the config fragment, avoid
this?

> +	ret = fuse_backing_path(fuse_fd, "/tmp/file", O_PATH);
> +	if (ret == -EPERM)
> +		SKIP(return, "no fuse passthrough");
> +	ASSERT_EQ(ret, 0);

The same -EPERM check as in fuse_passthrough_backing_file() is used here,
so ASSERT_EQ(ret, 0) fails with -EOPNOTSUPP when CONFIG_FUSE_PASSTHROUGH
is off.

[ ... ]

> +TEST(fuse_passthrough_io)
[ ... ]
> +		srv.backing_ids[i] = fuse_backing_open(srv.fd, fd);
> +		EXPECT_EQ(close(fd), 0);
> +		if (srv.backing_ids[i] == -EPERM)
> +			SKIP(return, "no fuse passthrough");
> +		ASSERT_GT(srv.backing_ids[i], 0);

Does this skip also miss the unconfigured case?  With
CONFIG_FUSE_PASSTHROUGH=n, fuse_backing_open() gets -EOPNOTSUPP from the
ioctl, which is not -EPERM, so ASSERT_GT(srv.backing_ids[i], 0) fails and
run_one() records "not ok" for the whole pseudo_backing_test.  No fuse
server has been started at this point, so nothing hangs.  The config
fragment does list CONFIG_FUSE_PASSTHROUGH=y, but should -EOPNOTSUPP and
-ENOTTY also lead to SKIP(return, "no fuse passthrough") in all three fuse
tests?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43858134663
--===============1962703051549190966==--

