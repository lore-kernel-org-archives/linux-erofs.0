Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B44760A3809
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 20:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzRYE13j
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPJb46Pbmz2xyj;
	Wed, 11 Nov 2026 07:46:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794343568;
	cv=none; b=fCcd/CXpcko4OThMigyastEmHam/AiJKe+9VCsxHg5Fb4zjKT/8pY61ut4FNSFcSrcDoAg9n8l85jy7qkeGMc1IgQn8vub6k8imDTAE5vn7JH7Sj/UycIUk740e7zUVM35H0g5lb9Sar3UnZX7rIqC2H50OF3Ymx3cNapg8msenR30v+kTzpNbcOfTAPnFhWl3qF13Wm4AcsaUBy2zlkS4ji3jCp3zBVQsdRxzR4zzWSJzFowlqoQTptqLns38WCVrSV7nbl+TUeKIT5avE18EWzVSzAtbF1cs1dmNC0RxOb8vfuOXFUOq/V8XumbED48coJpM9vSnmSR7BPcrQtDw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794343568; c=relaxed/relaxed;
	bh=rMRPONQOYjAF9HKKBayLjA2YuezRW4mL6HNg3dL1nlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgNWh/PtS/I/GMcoEqDmMtOr+w6bFvWge34aLznBbfCuu0xcSebUB9M6nc4w8P5+4v3925E78nd30zBztIldKWqzb4UhuvjBmSuRX9/NBcz3xAuh8I/dujt6zBxgbqKTcoRp1oWO/rBhUOtzE16b0VKsp3lh/7KKVASlHbGfAN6JbbaFkIJqFbANGTb4CjYrcxzNjmkHgz2mAet4TjlqldM/UAkOVhz2TE3jcOkCLuBwkbdC3Mf+pDYjL7tD/eMjc7jqB/h3Cq2z8pGGIfXQonT+USX110xmgKqjfkrVp7NciBmb52sgA9RP+YPMqjdkmMVYEjc50QijQnA5fnoc8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzRYE13j; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzRYE13j;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPJb403s2z2xNC;
	Wed, 11 Nov 2026 07:46:07 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3045618CA;
	Tue, 10 Nov 2026 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D441F008AB;
	Tue, 10 Nov 2026 20:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343564;
	bh=rMRPONQOYjAF9HKKBayLjA2YuezRW4mL6HNg3dL1nlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HzRYE13jB8RdQv3aSy711gVTQF5aN3kmny3Bm+Tqd6DGpMnW/UdmBhwvuV3tDKwWA
	 qBQkdAe99fCfyY4HwhHW6vpWLb11tiX1rqZm0gqSH24JDOLS4Qw49hrn6RKPLTZ5tX
	 8yK911/kTi5YKMv0Zeg0t9hinxeSS095ez81rveTvDj3lhZIp5MNrpZ0TzLVXjAROD
	 H+8sIgKlcwqIAFUbaPlcIA/mKF9hJXlPwet/3tzJzqABID/FKMqpm7AOyUBYjWme3C
	 0bNu78jINjA9S3ckBH6UNePnv8GkZJATc2s+TTg1AYJLjtNo7jNr7qgY8y7Qdi6pm5
	 ugUx9cOxV5vJQ==
Date: Tue, 10 Nov 2026 21:45:52 +0100
From: Gao Xiang <xiang@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
Message-ID: <avOCgJPOwRdsIxgd@MacBookPro.fritz.box>
Mail-Followup-To: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:56AM +0100, Christian Brauner wrote:
> File-backed mounts take any regular file as the image and the same goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

