Return-Path: <linux-erofs+bounces-2939-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7112BD58CBE
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 03:36:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffJk800pwz2ySb;
	Mon, 23 Mar 2026 14:36:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774236991;
	cv=none; b=EmLSigYgB0xRZ7H4wJjn4uX/FjIeNhB0/SkVB1bE8I0RMpw0x2IT0CrdJlu5ZHZxhF87tRP8QwNkRnDSiaDoIC++8Sc833zDBz0BV1XiWpHj/mdg0R4k/Dvaqr1fFa+lmdOKt8+smvoNtMLeWe44O0h5UgGJJl1EHTyTWL4zpneY8oSTLPlBL0kj2isXv71qIBLieLPjx5AfntvlEaZx+2FnbSvcHkI/SZjCb5Lnym+uA5qZ5heBKlKhCuZKFyX0qsnDVKHqzkYZyRW+FgIvT3zwADJBV2JeBdAx9P5eIuUpGr6RiTPsqlgjMlm+Q5aSsgRpUC4bHhkwRE72d62jsA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774236991; c=relaxed/relaxed;
	bh=hA6C3jQd4m0QVLC+JxyRoTwUaXIqYK4Fk66F34NoccE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k95HBVtYM/O84EH5eidrmhkOlWaBE2P9Qa1xlNvpoKUon3kp4SybmiB9XReRqDbxTRxWnrh9oGW9xA7w7iSgZx/qDGcXCMWiSz4eBkjhomH3YLDihySMqcC7xBxEtl/K/Iff5uvFX03LKVSe3+qRsYYYxXCYqgiW7XmaT94MAI4x1q4jQzqEBYYvCzFWIUMh8YAPGzFS5kRYl+nmo+lhnyS84xfYBBCZBvJ5eh2ahbawqIfqFyTko7Tbf+vltsH8IctMuFyzDZeasamePMyuBIbWGhzDXcbO+IcFOh9DzkuM++wfYk/INZ4EcG0FS1F4RYUIygGUlxYlyz4PcPQoGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fwU/dV57; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fwU/dV57;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffJk42vkDz2xd6
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 14:36:27 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774236982; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hA6C3jQd4m0QVLC+JxyRoTwUaXIqYK4Fk66F34NoccE=;
	b=fwU/dV57iJa6ORazpLaaIuugTW/HRYWqNYgoBz5dLjjSuZ0ewWf5J/zDuxjrgrJ1JS3rqhiwy9tCV+dZnCPiM5AfmC028Ow1O8UtXdKKiFeoM9OI3jJYDkI3i0N4iPd/2LsbC0liywkz2r6vYNO2LBA+mY2RMI7M11QPYgEvlio=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.SGmXh_1774236979;
Received: from 30.221.131.200(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.SGmXh_1774236979 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Mar 2026 11:36:20 +0800
Message-ID: <491c421e-90a5-488a-b0ba-9ee0e9be4ec6@linux.alibaba.com>
Date: Mon, 23 Mar 2026 11:36:19 +0800
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
Subject: Re: [PATCH] erofs-utils: fsck: check symlink size before allocation
To: Nithurshen <nithurshen.dev@gmail.com>, ch@vnsh.in
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260321183638.43353-1-ch@vnsh.in>
 <20260323033204.97472-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260323033204.97472-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/23 11:32, Nithurshen wrote:
> Hi Xiang,
> 
> This patch LGTM.
> 
> I manually verified this by compiling with `-O0 -g` on macOS (arm64)
> and using lldb for fault injection. I stepped through
> erofs_extract_symlink() and allowed erofs_verify_inode_data() to pass
> with normal metadata. Right before the buffer allocation, I artificially
> inflated inode->i_size to 0xffffffffffffffff (SIZE_MAX).
> 
> Without the patch, bypassing the OS read limits with this size causes
> a predictable heap buffer overflow and an EXC_BAD_ACCESS crash. With
> the patch applied, the bounds check successfully catches the malformed
> size, gracefully bails out with -EOVERFLOW, and prevents the memory
> corruption.

This patch doesn't look good to me.
I will submit another patch instead.

> 
> Tested-by: Nithurshen <nithurshen.dev@gmail.com>
> Reviewed-by: Nithurshen <nithurshen.dev@gmail.com>


