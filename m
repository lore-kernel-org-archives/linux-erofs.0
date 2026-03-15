Return-Path: <linux-erofs+bounces-2699-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8876ED58B17
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Mar 2026 10:39:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYZVB67Nvz2yYy;
	Sun, 15 Mar 2026 21:39:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773571186;
	cv=none; b=b4ttiELUO70rRDNMwMTQy5WX8BKOFDcx6XgvzQD2q8o0YSadTyUexCFGP2cIcc5BwNnhnZBW59UXuuxtSmY5IjqOUliXoUeGqKEu4SamN4OVO2XQqSyzcG+Ek6TW/9OKIWradAjFP/Lh6HbqO7fpuIj4+FchQyqwkXomuxggvSMgBuh14ZgbPFS283+azOfco1tOu2L8Oa+rLKdBWPi6CQpGXQR8l5Kiy71GFt1iswhHzCvBlqmLZiQ4poGUCxJxZcDa9/peVAVCGzmljMuXkFqNn0m3elVXo/mquiUPGTM8K2+sFiDPAqIsKixS6qAaok0WwTWHRzPrcvOorN91bg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773571186; c=relaxed/relaxed;
	bh=7f5ZqoKWp2l6iZ5osR6KUzi9WsBDtj1ZAa5ZZpfX+x8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RJSnXN5cY6Zgpqxzawtckq+BWmD0khqkMOM/5TA0JCTxFy815Lo2NTGn8s4G2U5kJdTUavcT82y1/b2/DwKOJOh6GmKOMC106bgwlND2A+YRiLZrM/srLms6i+m7JxEXd0tyrFD22eLZ2/df4DwpKsR6SW4wsHNDUA2O7jfzzPRSXGpHCQWQT+/UHd3tNPKORcGUv2byF8yLbYkBMZSEboZCWWSZXwmH5o0zP9as0X4aTDpIr1bGrOtv4FqnqSXCnl9fPEldo698o+KerKyWCvfaqpsbtUGkiyUooZbBEBPAtELFj+r5SYMDYmExxQyZG0HM2RTPlCmHeYtO88As2w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Kckn0DIG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Kckn0DIG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYZV762x3z2xlM
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 21:39:41 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773571176; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7f5ZqoKWp2l6iZ5osR6KUzi9WsBDtj1ZAa5ZZpfX+x8=;
	b=Kckn0DIGZnOswJ+AfUETJpMDroFAO5wwiEytui07gE8C/zHLp/i8csRO+wVnVp3m835AspC4IUtMvx3p8eOx/DmT7+E1ncty/gu1idtgnQk3jK0HM9Ik3dFElkIq8c5dIQByRn+l48AcsAeOuEgIdStqnzj20G/KRl6JvWxQhRw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X-yYcUq_1773571174;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-yYcUq_1773571174 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 15 Mar 2026 18:39:34 +0800
Message-ID: <99d8f308-35f3-42bc-8950-daa22b654e63@linux.alibaba.com>
Date: Sun, 15 Mar 2026 18:39:34 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: validate algorithm format before use in
 z_erofs_map_blocks_ext
To: Utkal Singh <singhutkal015@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
References: <20260315072806.17504-1-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260315072806.17504-1-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/15 15:28, Utkal Singh wrote:
> The fmt field read from the on-disk extent is used directly as an index
> without bounds checking.  A crafted image could set fmt to a value
> exceeding Z_EROFS_COMPRESSION_MAX, causing out-of-bounds access.
> 
> Add a bounds check before using fmt-1 as algorithm format index,
> returning -EOPNOTSUPP for unknown algorithm formats.
> 
> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>

The following commit should be backported instead:

commit 131897c65e2b
Author: Gao Xiang <xiang@kernel.org>
Date:   Sun Aug 24 23:11:57 2025 +0800

     erofs: fix invalid algorithm for encoded extents

     The current algorithm sanity checks do not properly apply to new
     encoded extents.

     Unify the algorithm check with Z_EROFS_COMPRESSION(_RUNTIME)_MAX
     and ensure consistency with sbi->available_compr_algs.

     Reported-and-tested-by: syzbot+5a398eb460ddaa6f242f@syzkaller.appspotmail.com
     Closes: https://lore.kernel.org/r/68a8bd20.050a0220.37038e.005a.GAE@google.com
     Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
     Thanks-to: Edward Adam Davis <eadavis@qq.com>
     Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

