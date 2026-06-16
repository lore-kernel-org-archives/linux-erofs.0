Return-Path: <linux-erofs+bounces-3653-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CAECD98E4
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 15:00:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfqsZ1Kszz3c3l;
	Wed, 17 Jun 2026 01:00:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781622002;
	cv=none; b=N1VYT2M6hKpN+oV+pRtRAgPxGs0T3SJEmaLYcCLVZbZ/iggJtzgHL8zAusMYfhGSo5rZwhHLn+0k2LxRaQ77ePebyc4O7X68XfD0hj9OcldRG/Cac572FDxzVQosHoPMMoQFEY1y54Ad/Ag8XV30nTI9cd6uf7VxL9hNTuDHlOy2YH/0e7jV7Or3Ip1kwfa8+bg+r1GP3S7r3G/IePQl6zDMbD6/H7W3io6cAMA+u4HQ4FMS3zhfw9ygR+guvW32xkobuifAAEPQyRjePjHekcgEC2RR0Hrr0Lfm+LBXjwYQmQoPZXfnO3UoTGfPRY4u+5u3Y8DNBgOA0eMTkoY1hA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781622002; c=relaxed/relaxed;
	bh=54nrZd56QlDOLjrnGUMxikC0RJz3adz3i0y4la/F30Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjHsdIfDnE2mfyeWl8Vinc34JsVAG6KeDh1DEUcOQP7djBQmBEEDR3lRt1c2J+THFbJc8ytwcuwo0K+FEf6WjSOCRXo/Dx537U33OPcetrj9TeKJgA92pKCBgoymv+I/IKHU9NMQi7Zvh0s2ZOX4MCz43qknxFcHdL8rImkfnbwXdNB+/vNhlkuaVEjSa5bWaMEeK7gJUljIzVEDZquZQf4x5NW0wpi7sYo2HO95Cl0FZjPDzahMLZ7i/RFqxkhmwMzQyRMkCsTvu75lZ2pPzeAfEen6AvOHEQAwDGx9NJ7JlG7GAMbmV5wC6EkMeH5gIazZuq+dCMh9oNnW/Xwnuw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jA2q0c4E; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jA2q0c4E;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfqsY11nZz3c2L
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 01:00:01 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC09F432CE;
	Tue, 16 Jun 2026 14:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5AC1F000E9;
	Tue, 16 Jun 2026 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781621998;
	bh=54nrZd56QlDOLjrnGUMxikC0RJz3adz3i0y4la/F30Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jA2q0c4Ee6LVq3wsrXzEp9N7Su9CbMmoI6RP4rBSzy7r8wEReuDOvyko1gR0PEBZq
	 bg9x1Q83U6bfJVi8MI1KRXQHZSlLKfTldHay7P4JnrGnDygtoE8Uyr1SZXXq6iopy+
	 1uiksflRJgCiH46ewjX97OHYoJUczZNbraNTb5w472Yzug6sY9EulbLUSfhDKPqy2P
	 fXQQ0U37sAQtSAUQVyf1H6jtse9vqf7bUdWGz5uvC+yB+YxD4JAWUp9yh5ga+TP8bC
	 P3YC8LvGv2tE0gC7aIeruXedVTLx5LPurEO7KW1M1oaYJSRkYmGAKiLdMI2ZflI/gv
	 Ek4hr9EandhYQ==
Date: Tue, 16 Jun 2026 16:59:53 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
Message-ID: <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
 <20260616123443.GA21024@lst.de>
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
In-Reply-To: <20260616123443.GA21024@lst.de>

On Tue, Jun 16, 2026 at 02:34:43PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 02, 2026 at 12:10:08PM +0200, Christian Brauner wrote:
> > fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> > forces the holder to be exactly one superblock and prevents several
> > superblocks from sharing one block device. That's what erofs is doing.
> > 
> > Introduce a global dev_t-keyed rhltable mapping each block device to the
> > superblock(s) using it. The holder argument becomes purely the block
> > layer's exclusivity token (a superblock, or a file_system_type for
> > shared devices) and is no longer needed by the fs specific callbacks.
> 
> Err, no.  block devices need to have a specific owner.  If erofs wants
> to share a device between superblock it needs to come up with an entity
> that owns the block devices which is not a superblock.

It already did.

> IMHO sharing devices between superblocks is a bad idea, but that ship
> has sailed, but please keep it contained inside of erofs.

We need a simple device number to superblock mapping anyway and that can
simply be centralized in the vfs. And it can work with anon device
numbers and block device numbers uniformly.

