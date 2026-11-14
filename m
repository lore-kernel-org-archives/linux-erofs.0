Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1845E606A895
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfkXAKnv
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRbGw2dt7z3cfY;
	Sun, 15 Nov 2026 00:55:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794664504;
	cv=none; b=gOFUoVNIx6HeJ+Etr8Af1dVpPHrpUH6CGGP2RDIFmLKtKr2AUcaFkN6AmMjbchB1+J7csPwv2vBNVlhCYXt6ESr5ubVjOE3XWMqAvBEBJEbLa1Epe63Znh58t0EAS/aPwm4anpBHIbkB/VY050nv1t7CZRXjmMskvylo3M4okAv5CoRiyIETZSXhKygfEhqrpNFiCIdUUJxkzALFB8CKcm40wP2KBjuHbzkQaqDaAwMqQGpNTJTlDFh4+j8TVooPd6D09Xm/ICUxwBmjHPYbWPleRuA+1h0Ss/l3LUVhP7Hy145jhFDtwMYaop2mBChfRI2A5zrNrjf7AMSKW4zUJw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794664504; c=relaxed/relaxed;
	bh=Xi+Jp34UVw8n6rWUcn3QcZPlSKYiPMqX7yCNJrzL8oU=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=Vhb9f7mlvrEFFk3QZNSVILMfWvxLm4RKi6iO3SJMcltb0DrzDSTerc3aiwtCRFv1pYe2HktRCMV+pbOoTqNaxWoR5IVXXLOkJXpYb9ArGHPOFBWGhvESMbcHgbqhRI7NQv66wzSwl+P4Vxx3HIJS8SvK4bhEfOlMuEDIXJhOfWElcX7L+VmffF3RAAdonSwVIqomPhkSrL2pScf96hdNK6lamjxfHDqk2mjjvl1SzZMRECOs29FF086Ngt8SsZg1+HXYi5KF5slzDzjSqx+y2KQH4tQOs6/s+z/cJSWOl8UFbBxGKYbdM9IWIt3PacxJRITxki/+pxgekyQePnFMnQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfkXAKnv; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfkXAKnv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=bot+bpf-ci@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRbGv26GXz3bY7;
	Sun, 15 Nov 2026 00:55:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EE0E448C9;
	Sat, 14 Nov 2026 13:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36F01F000C6;
	Sat, 14 Nov 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664501;
	bh=Xi+Jp34UVw8n6rWUcn3QcZPlSKYiPMqX7yCNJrzL8oU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=bfkXAKnvyN3NrzfYhrVigeGIKvr/8evEe0tQ8KwSyEafhDf3+AXVoqojleCZ7/Qdh
	 2b013ZilynaxVntPTxgtS9Fyq3b+7yXhPeXkFfQ9ONM2J9MEOM/JQ3B/znTjkCUpqc
	 r0tlhXctgE98kfAt1ITbmi9H0tApXPCL2XTcrVOM5qnz/NrX0rxwji+SmXMUOe8YHy
	 kRbhgqC/kLnhpgS61Qu7Lfu7BuXDWJsHjF+zOY5u5KKN5rR5uvcX/zOV7QTiz8dq9Z
	 GTd5PKapaf6tpFoOvo6qdgngRWS5W1FIZVvnJWAJ8F5DAYQTkJUN/Wbu5kFv6IHajV
	 XPu1vrQEYpCgg==
Content-Type: multipart/mixed; boundary="===============1687560790659556623=="
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
Message-Id: <df03e637354be695652a787563af21ac77b4c61f813ae4491a3397a91df7688e@mail.kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,alex@amutable.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 13:54:57 +0000 (UTC)
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============1687560790659556623==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> securityfs: use fc_init_pseudo()

TL;DR: Setting SB_I_NODEV on securityfs may make reopening AppArmor's
inherited .null fd (e.g. open("/dev/stderr")) fail with -EACCES, which used to
work; the commit message may also be inaccurate about device nodes.

> diff --git a/security/inode.c b/security/inode.c
> --- a/security/inode.c
> +++ b/security/inode.c

[ ... ]

> @@ -64,6 +65,7 @@ static const struct fs_context_operations securityfs_context_ops = {
>
>  static int securityfs_init_fs_context(struct fs_context *fc)
>  {
> +	fc_init_pseudo(fc);
>  	fc->ops = &securityfs_context_ops;
>  	return 0;
>  }

The commit message says "AppArmor puts a .null device node into securityfs
but only ever opens it via dentry_open() which doesn't care about
SB_I_NODEV."  Is that the whole picture?

aa_inherit_files() installs that dentry_open()ed file into the task's fd
table:

    devnull = dentry_open(&aa_null, O_RDWR, cred);
    ...
    replace_fd(n - 1, devnull, 0);

The fd is not O_CLOEXEC, and its f_path.mnt is the internal mount from
simple_pin_fs() in aa_mk_null_file(), which never has MNT_NODEV.

Opening /proc/<pid>/fd/N, or /dev/stdout or /dev/stderr, resolves to that
same path and goes through the normal open path:

    do_open() -> may_open()
        case S_IFCHR:
            if (!may_open_dev(path))
                return -EACCES;

may_open_dev() checks path->mnt->mnt_sb->s_iflags & SB_I_NODEV.  That bit
was clear on the securityfs superblock before this patch and is set now.

Can this make open("/dev/stderr") fail with -EACCES for an unconfined task
that inherited the .null fd, for example a helper exec'd through a ux/Ux
transition from a confined task?  That open used to succeed.

Should the commit message say that this reopen path is intended to fail, or
does .null need separate handling?  The statement that "securityfs never
holds ... device nodes" also seems to conflict with the .null node described
in the next paragraph.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43599461726
--===============1687560790659556623==--

