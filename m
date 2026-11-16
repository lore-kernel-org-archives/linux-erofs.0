Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F30606A32A
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 12:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnZy2toz
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSmdc2SkXz3byT;
	Mon, 16 Nov 2026 23:00:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794830420;
	cv=none; b=YLFkPVcP3Jxwn1c8SnXUwXL0VyQRPNF0sa0YGVEr0aDvP4df2LjwyeQaTULnDQGpZvxk0FDrjRIIdZiyE0nqbjVIUeCIOvyy9QPJKGWZXPXktBYlF2LY5NSsG7lPmxV/xQnyLzqC2G6GkkCo1O7OJTdH4i3TFs+NqrQgc/zCXiFJpiZ0PFT5l/xDiDUy28dgpoiqVlBWvfzRITfYQaW5ue+9luAsDMeO4/40CNEiCqcxHChw+Epup3oh4c/FYnKFUC08++n6wBTvU0QWTptLsVSahXwq0ad0jSt23rpmmfAsAH5UZX2Y8ITkm/kfbDyBR8YldEcqpfHeWZOXN+fGcg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794830420; c=relaxed/relaxed;
	bh=gm216H5g8yPIS0hPFinwHy6mVVrhGulY+53WmPc6rN0=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=d4HVWUKv05QGNbyZxKRdcAEmC/vs7FzYEFNvTnkDvikvbS0lk1nYp4mv7goiyuvmUbXsy04cxdaWFeEiA8C8gWk05AvAS6zwOjIcSeMxhalsXRv2W8TBD+9cRkXpX3nBfoZtxbFLfSDh+dtd/378P+gJlx1iz+jmtv3+z8MN9aK2HinqiHnYK1HHjCeB15/S0W2EfsuvMjPltBTx7m3nrX2s72WCfDkhZGau0yI1piCMJYstHK7AOFrRIwi8/sZnEA4U8y+bCcSJ/o03m4hBMae6dXyaK7uhvhvo1psgp5cfFSm6wVITzb9d4CvU88d8ZiHIy/bnEk4ZL+hz92GERw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnZy2toz; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnZy2toz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSmdb17pRz3byF;
	Mon, 16 Nov 2026 23:00:19 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86E6662928;
	Mon, 16 Nov 2026 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FD1F000C4;
	Mon, 16 Nov 2026 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830416;
	bh=gm216H5g8yPIS0hPFinwHy6mVVrhGulY+53WmPc6rN0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hnZy2tozWrqXpWLl+o5+qP9GJB7maIdtKambAdlwVeTUYSiv1MRn2/JyDHmnbWh9z
	 9WDgZMPWzEFJyZJLu9/wsHqC4IslySPV7y2m6l1l6Pr8NgVibCFxmyKogUiorVMDDs
	 oSUXCyKp79VfkW+5dB+6SUIEC6UIXRKMD5lFDe0TpDOweWXRS/8hWTozfLGQIQW1P3
	 PpqAtsruCxsT/ZGQgn4L2ujm+ycdGpwnf6KZ9ATazwCNfMJ3LvW1RLCzk2tHDAf+iS
	 l45B1JKOto718M05wX+oTkpRye0x56eTuMcf1pJlfnKjWSS9tECKCjPVeZoo9oaT6o
	 l+RQ5GFUaEe7w==
Content-Type: multipart/mixed; boundary="===============5220694122544816000=="
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
Message-Id: <cb28f09c85a473a23f14c9bd6ef135950197c9fbf966c1f7055d791977d29286@mail.kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
Subject: Re: [PATCH RFC v3 38/44] nvmet: refuse files on pseudo filesystems as namespace backing files
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,chris@chrisdown.name,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 16 Nov 2026 12:00:14 +0000 (UTC)
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5220694122544816000==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> nvmet: refuse files on pseudo filesystems as namespace backing files

TL;DR: The series may not build: file_check_backing() in fs/read_write.c calls
d_real_data_inode(), which seems undefined anywhere in the tree, so a
prerequisite patch may be missing.

> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,10 +47,9 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		return ret;
>  	}
>  
> -	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
> -		ret = -EINVAL;
> +	ret = file_check_backing(ns->file, FMODE_READ | FMODE_WRITE, S_IFBLK);
> +	if (ret)
>  		goto err;
> -	}

Can this be built?  nvmet_file_ns_enable() now depends on
file_check_backing() from f66083ed0be9, which does:

fs/read_write.c:file_check_backing() {
    ...
	/* Look through stacking filesystems at the inode with the data. */
	real_inode = d_real_data_inode(file->f_path.dentry);
	if (IS_ERR(real_inode))
    ...
}

d_real_data_inode() is not defined or declared anywhere in the tree, and
no commit up to the end of the series adds it.  Only d_real_inode() exists
in include/linux/dcache.h, so fs/read_write.c looks like it fails with an
implicit function declaration.

If d_real_inode() was intended, it does d_inode(d_real(...)) without any
ERR_PTR handling, so the IS_ERR() check would never trigger the error path
the f66083ed0be9 commit message describes.

Is a prerequisite patch adding d_real_data_inode() missing from the series?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43858134663
--===============5220694122544816000==--

