Return-Path: <linux-erofs+bounces-3655-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A07BCD98EE
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 16:36:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gft0J4PDfz3c4Y;
	Wed, 17 Jun 2026 02:36:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781627760;
	cv=none; b=YIvWNpJszfthWlcTAPxEcO+3shrWPhSkipmByxY1gyoqBXubM7psB//5AAWYrKcgmj4RgoIEtuIOhKoWWar6P4iMT/Vx+owQOIPAzhuaxDb62FyAu2ckWUCEh1ljVTyUapfdoq5C+Ws0+/rlVwoHREf3SLcsfFTo/bTIq6v8qfounLaDud888F4GD+zyTrdkj0qXSDGtyEQuHigjvlKxndr5Atp/ZGcrbtdkWsk5e0TcQbfQvK8QuhMza//XTOsGvoSWDdkXSthrgHudsfDpTVnQz70E/d2yRcbyU5lS5o/cH/HuXX6pmGKdTrtSwDzQAYNPhllbsCe9BqNT4eUBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781627760; c=relaxed/relaxed;
	bh=B4jBFIdFiNtDsmQMyWWPd+1DnLb23kwsj3MeQY91MXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/5XqIalgCedrhGSjrLMj0dbibJJC8z3CjRMho3SppcHv6awmBcypAeAaJXU16F+5wHnqdZW0AVgTOzDa2B/2rWHDHtTLVSvL1KOqptwFpqyH9z3A3lsVOMqfQvipjngDLOqjmxDKC5NvlIU3yHyjF0LsN0j28vp88Zc0g0WAx2ZJLuNw9KVzbwOMEJy6LYHAeFXfu4IQGQTYsPN4DaEXvnIXAouO1C5L7mcwMZDJVBZvU3jcPxOWpQobzUyrl435OCGlNJjaBJs0tJvrUQ+m1LlDQIX0y1RSeBbInFZrOzpVDXvor9ejmC68ReeCelAx7/eTkoZWPv3rbpiDt5t1Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oSkzNAr/; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oSkzNAr/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gft0G3cgcz3c3v
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 02:35:56 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781627752; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=B4jBFIdFiNtDsmQMyWWPd+1DnLb23kwsj3MeQY91MXI=;
	b=oSkzNAr/27e92aKNerb+qZa44Z+sXt2zjnAe8/cVBq6IRDAtWKDeS3YSG5QeN9uTKVl1yhTAvRyvpxMavXVXKU220fKkSaWt4WMbC4LZ4x6mdnQuzfD6WVWvQWCD0WweXJAbGwUQGGaGqjzoMx8HKgmMTmjWN38FnJ5EQmMbEsI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X5.qxzD_1781627749;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5.qxzD_1781627749 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Jun 2026 00:35:50 +0800
Message-ID: <8f1c032b-b951-4d0d-93fa-229248993f2c@linux.alibaba.com>
Date: Wed, 17 Jun 2026 00:35:48 +0800
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
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 linux-erofs@lists.ozlabs.org
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
 <20260616123443.GA21024@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260616123443.GA21024@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/16 20:34, Christoph Hellwig wrote:

> IMHO sharing devices between superblocks is a bad idea, but that ship
> has sailed, but please keep it contained inside of erofs.

I'm not sure why it's a bad idea, for example,
the immutable layer model is already applied to layered virtual
block formats (such as qcow2) and layered fs like overlayfs.

and I think device mappers may have some similar immutable
approaches as shared layers but works in a slight different
way.

The principle is that each instance uses shared blobs in a
read-only way, and that is almost a simple and safest way
to share data among filesystem instances.

Yet I don't want to argue with that since it's pretty common
for years and I've seen no practical risk using this model.

Thanks,
Gao Xiang

