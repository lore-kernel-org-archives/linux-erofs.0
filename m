Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD49606A880
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhEMPzkS
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSpQj2Cn0z2y7r;
	Tue, 17 Nov 2026 00:21:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794835261;
	cv=none; b=aIlGg4yrmNURI1bN1HpnAOx47PpPazJI1939Sk3IHWBskifTROoabx20Zyu2guFrzQEPriOiNoKIuzyts2vJcaXlZKKWNsB3Mvlm5kfxSPRskShxX3OOSceFxUUUcH11tWI0xoPnjEAYpiIuKKqohiMICuedQwwi50VtRLEL9CfddOgvttrOJUHva8BcWdLAWMpHyQ8+Es7SD0z0sVfXuwJfhAhJKn3vZtEMoyrqtHPRVuFcM/vK4uI3c6DpyUWTIaumJ9i8hl9sJMk9qxkTyck91PMpJzhgPupjQ9AsfO5aw/BsdvnWiyTS4Kf+x4DlXrmClXl6tGddNn4VfrIK2A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794835261; c=relaxed/relaxed;
	bh=Zwp/b2OseRP/BP0MRnYEMv10Xx5652k/ysAi77DyTUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxY5lQyPaicX42id3fTrF3MBK7xQNXiAoLWpLwlV1AgfpKYhIpLAPnsvAk5n/FEh32s8orpXQHVBiQkX2irnPOeysxS57IIVGTDa0VkxJrhagoJFN88ZrjgnNzkDeATQ62WSpAGpxxzRBN3qGlZ4dr71VFg1EYY4PfU4ZIV4c1mDOKbt56htIZa2r8Aq1BMdU34AsyH7cybjWYpuwVFUZCov7jZeP61U7ZCqZjHhfiwA5QpS8PTXnil0Lf+ki8dTxUWBdPrywZ9ljIlMa4FKgSM3xyCgHp/a4pCcnn4X6iXjnBkUThjOQSh4oArws5EbDp7hTuhmxD7J9FBRYeT6ng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhEMPzkS; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhEMPzkS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSpQh2KYjz2xnW;
	Tue, 17 Nov 2026 00:20:59 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06B4A62A16;
	Mon, 16 Nov 2026 13:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287C11F000C4;
	Mon, 16 Nov 2026 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835256;
	bh=Zwp/b2OseRP/BP0MRnYEMv10Xx5652k/ysAi77DyTUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MhEMPzkS8ELyUuZJvWfSoeeWuf7By4IL/aj2kb/a2OV4l4EgVqKXjiioyUz2RieNk
	 XgpnwYQk+l7IQUQIb2TJG9rqwlNZZd2t4tSSz2FIOFgSK4qv3MUw+KnfbEysg8x4iS
	 RMX98jFDrMhGiTX7izqJwsUslncHgd0fLN7Yyo0X4gX89YKFy614i608nuofc5428F
	 SfK4Vb1AO45G7cvMjjgv1ixrvwKqD7DXpAnyYbrMZDnbnAmpR0a9mRVyF+s9eImB9m
	 jgQn4Dmx1KWjFDTc0G8bS5OCGFot8PkE1fqYZHJngkkRDFtxZNJw9/svWtFGNRWRiW
	 sc42i9H1mtjtg==
Date: Mon, 16 Nov 2026 14:20:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org
Cc: jannh@google.com, mason@kernel.org, josef@toxicpanda.com, hch@lst.de, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
	ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, amir73il@gmail.com, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org, chris@chrisdown.name, ast@kernel.org, andrii@kernel.org, 
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com, 
	yonghong.song@linux.dev, ihor.solodrai@linux.dev
Subject: Re: [PATCH RFC v3 38/44] nvmet: refuse files on pseudo filesystems
 as namespace backing files
Message-ID: <20261116-geplagt-gemein-zufrieden-72c3817de2c6@brauner>
References: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
 <cb28f09c85a473a23f14c9bd6ef135950197c9fbf966c1f7055d791977d29286@mail.kernel.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cb28f09c85a473a23f14c9bd6ef135950197c9fbf966c1f7055d791977d29286@mail.kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:00:14PM +0000, bot+bpf-ci@kernel.org wrote:
> Is a prerequisite patch adding d_real_data_inode() missing from the series?

No. d_real_data_inode() comes from "fs: let d_real() fail" which is in
the base-commit of this series (vfs-7.5.lookup). This was applied to
bpf-next instead.

