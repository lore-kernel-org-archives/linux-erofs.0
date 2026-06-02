Return-Path: <linux-erofs+bounces-3507-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9367CD6E57
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Jun 2026 16:13:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gVG8C0Z6hz2yFK;
	Wed, 03 Jun 2026 02:12:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780416779;
	cv=none; b=asnxwaJTy0dDpKsO7MOyFa2OMg1VLbk7KQJgd+PREvj+UJkPppz1cRLThHAqC35tARdh0+8oLePvaiY5va99sxRju2ekOJPY/J4mSJk/J5fk78p66kS4jcPSJJxCHM2Z020e7sQRTh8ZgHWH7lVsZumv1wkz2TyVstLjVphEVCF9QO6CWgYZLGTCjVa8HLu3rjnHhgUM9vftL1XYYEVsssSM/FdeiuSpS/VE/Z01HZQIReW6VS58iLr4CYrLzqU4DLErbVgThpHGL3zfmvGwv/vLOqBmzCwVNE/Fkfjmip4djaBsWKlnbDN9ieZwHhqn6TXZxQugyKtoQ4MSrSKeuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780416779; c=relaxed/relaxed;
	bh=r2DLEhHvftTZsuQQxGIaoWAcXKXdd8orYCWsS474SJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCPzb10PKrwRhY87Zt3Lxy3TNMrV4C2W9gVAHpxDbSGu+MdKqCzWB3Y7v08EEFuwP8quJ9TJZibAh+LITGzzQnWzIBk+FMKzHxPAEot8aEL9g61uf+fhj6mESFq9m5tUb0EOTRGddtjCZHvQo5KL2if1XdBXmR38jwOJ5cBfFClzqbU5W4wISHQhElDmAH7m6aEa8LwfjuBFYWaEXpvBaq6xjoUGpbF1PdyGxO//2sHeP89PXnB+2j7jFsuUW1kFE0Q+JFCD9yEw/J5ZZO1M7cJyDl2uiGPWs45aAxGxcZAecQP0sEOsXBTCeZOuup+no1Rv6FHCZvtq6+jXFtOT0A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CZtJ50Tk; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CZtJ50Tk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gVG886Y0sz2xy3
	for <linux-erofs@lists.ozlabs.org>; Wed, 03 Jun 2026 02:12:54 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780416770; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r2DLEhHvftTZsuQQxGIaoWAcXKXdd8orYCWsS474SJI=;
	b=CZtJ50Tk6/gDYxVjcaB3wqvZcIXBjGjLP2Jh+qumRHWo6QcKC00zEOsePniMKk2AZ9N6httS72CIAM8SWVytui/5Lm7HVQjVNSW7WHGd9LwjD6B+NNmIlDtrcZYY3iAWouFOoGoC6Uuk+TA141b+8/IyImJcjuWzWhQSbq3alW8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X44pbVD_1780416767;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X44pbVD_1780416767 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 00:12:48 +0800
Message-ID: <a4ec82fa-458a-4043-a8d7-0e76af2fc1d4@linux.alibaba.com>
Date: Wed, 3 Jun 2026 00:12:47 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] fs: support freeze/thaw/mark_dead/sync with
 shared devices
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2026/6/2 18:10, Christian Brauner wrote:
> Note, this is on the border between RFC/POC and so I haven't pushed this
> through testing yet. But I don't want to waste more time on this before
> showing it.
> 
> I surveyed various fs implementations because I want the ability to
> extend userspace the ability to manage what devices can be onlined in a
> centralized way without having to force every fs to care about this.
> 
> I realized that erofs allows sharing block devices with multiple
> superblocks. Any freeze, thaw, removal, or sync on those devices will
> not be communicated to the superblocks using it and our current
> infrastructure is unable to deal with this.
> 
> This attempts to add the ability to go from device number to all the
> superblock using that device, iterate through them one-by-one and
> perform actions on them. For most fses this is a 1:1 mapping but for
> erofs its a 1:many mapping.
> 
> This is not unreasonable infastructure to support in my opinion. I
> played around with some ideas for this and I want to send out an RFC to
> gather some early input.

Yes, just a side note: On the erofs side, since we apply immutable
model to each filesystems rather than writable filesystem approaches
so inode data (in devices or files) can be shared among multiple
different filesystems without any reference count needs for example
(in the similar models: any write needs to be COWed using overlayfs
for example.), so blob devices are 1:many shared mapping by design.

One typical example is that we could convert each OCI tar layer
into an erofs blob, and use a metadata-only erofs to index these
converted erofs blobs so there is only one filesystem instead of
per-layer filesystems (it's called fsmerge in the containerd
implementation.), but each converted erofs blob can be shared
among different filesystems.

Another example is incremental diff updates, the primary device
can only contain incremental data and refer to the base image for
the remaining data; and base image can be shared too.

Thanks,
Gao Xiang

