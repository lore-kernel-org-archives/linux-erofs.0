Return-Path: <linux-erofs+bounces-3726-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F554CDB46B
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jun 2026 02:52:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkqPH3xKqz2xwP;
	Tue, 23 Jun 2026 12:52:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782183171;
	cv=none; b=Y1hWpBCPQD7GfGH1giR+DRMhDgmCNZjmHqdTiQ9+CtucgN9dxU3Y9fNjTJoIsLWsbrM7Zcs5FtsQiVBFKlPSFKY/Fr0UOgbeBz8CAJAszYKzVIzRE1YbuSrGbzZj7iGTXRyuyE8UoeupgYAbZxt3Hh3e0RE2Bxdk2hb5ImyuBktRa/6AvcXJinKamGZ9/UzhTI56hiMgI+XDSNS4wRtdL8ZdFQV/z4rp0GgGvQb1h8cI2uhCfkaBFfvbRanFSG9T1vXrGxxH9OleQlfLC4NZyP214Q9pBLtSew9OOdjOjJDSd0t6zeAuQDKrfB07NUhlfF/EoB11Nd/oAwMploXfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782183171; c=relaxed/relaxed;
	bh=R/lOLE+r2XE/sSINR6Cj61K9HooeubIu3bU4meTa6cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1NKJOMrYT677YDgdJiyQt8lxYpQDXIW7H83idbxPk92JGC9TaLEs42ckJ5qBxdfI4WHDLP5Y626K1pNIyM61fPK6CgxkUCH5w9lBv6eX9N0nd4AgC8Yfu3DpAYjx4Le13iZTznjuuweKwQ7CZ5pSCK+tMFPB9Vg8i3DB98Zh6/qNHOjJNsKtg9MoRwupP/PbglYa8mhYBwgNuPp/x3w56j/7Cd6nj19offf/JvBdPDoxU4NHTV2z4tmJQTNkaGtYGe/JZ5BgssFY9DCVlWchlYZJuMQG1SvucHz2HhcttxIEE8dDCptn86ZeGkJnS8pa0zZiaRNJAh7au0t9UDrxA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CxkGuarb; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CxkGuarb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkqPF3Kg6z2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 12:52:48 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782183163; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R/lOLE+r2XE/sSINR6Cj61K9HooeubIu3bU4meTa6cw=;
	b=CxkGuarbRJd9fSmjO/M3jDAbJtPle7tn5uaybDSm/GX8NIjUG/8Z3u0m4wDDM7gf97Bs0oLdqqUc8jr81OJgDPNz49buYhrzpKpv9yl+XWNl0er005m156ngjHAb0ahWVuDX3onV+i0OH91MJ/Ij5aCoU69YaAvuLEfjJ/azIfI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X5SS8yb_1782183161;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5SS8yb_1782183161 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 10:52:41 +0800
Message-ID: <0e2df016-dc1a-4dc5-8461-5a778f029247@linux.alibaba.com>
Date: Tue, 23 Jun 2026 10:52:40 +0800
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
Subject: Re: erofs: is z_erofs_put_pcluster()'s sbi access in the same UAF
 window as 1aee05e814d2?
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Jianan Huang <jnhuang95@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <20260623024946.3420476-1-zhanxusheng@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260623024946.3420476-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/23 10:49, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng1024@gmail.com>
> 
> Hi Xiang,
> 
> Following the race model established by commit 1aee05e814d2 ("erofs: fix
> use-after-free on sbi->sync_decompress") -- i.e. unmount does not drain
> the async decompress kworker, and unlocking the output folios lets inode
> eviction (truncate_inode_pages waits on the locked folios) and thus the
> unmount path proceed to kfree(sbi) -- I'd like to ask about another sbi
> access that also happens after the unlock, in the same kworker.
> 
> In z_erofs_decompress_pcluster():
> 
> 	erofs_onlinefolio_end(page_folio(page), err, true);  /* unlock */
> 	...
> 	z_erofs_put_pcluster(sbi, pcl, try_free);
> 
> and in z_erofs_put_pcluster():
> 
> 	if (try_free && xa_trylock(&sbi->managed_pslots)) {
> 		free = __erofs_try_to_release_pcluster(sbi, pcl);
> 		xa_unlock(&sbi->managed_pslots);
> 	}
> 
> So in the try_free path it dereferences sbi->managed_pslots after the
> output folios have been unlocked, which on control-flow alone looks
> similar to the UAF fixed by 1aee05e814d2.
> 
> What makes me unsure, though, is a difference from the sync_decompress
> case: sync_decompress is just a plain sbi member, whereas here
> z_erofs_put_pcluster() is still operating on a live pcluster that is
> registered in sbi->managed_pslots / the managed cache. So it's not clear
> to me whether the pcluster / managed-cache lifetime rules implicitly pin
> the filesystem instance and keep sbi valid across this window.
> 
> This also seems much harder to hit than the sync_decompress case: it is
> conditional (try_free, i.e. non-managed compressed pages, plus the
> pcluster refcount reaching zero), the window between the unlock and
> put_pcluster is narrow, and unmount still has evict_inodes/put_super work
> to do before kfree(sbi) -- which may be why syzbot didn't reach it.
> 
> Is there any guarantee that sbi stays valid here after the output folios
> are unlocked (e.g. via pcluster / managed-cache lifetime or RCU), or
> could unmount race with this path similarly to 1aee05e814d2? I'm asking
> rather than sending a patch since I couldn't convince myself either way.

No, this is totally false-positive.

> 
> Thanks,
>    Zhan Xusheng


