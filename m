Return-Path: <linux-erofs+bounces-3242-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6066EA3C4E
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Apr 2026 13:22:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fs0ww0Km7z2ygf;
	Thu, 09 Apr 2026 23:22:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775740975;
	cv=none; b=M45p5Cn3FsMog/rebnijJEd1xULUhQu/iuNf0UtbqSf27nc3VNwPFyYAyB5wGlx6yOi2sIEeIQzJuorrAq0nhDNwcUp+BK0cuw1cBJULtYoGgnl+tgjazwM4gfBME8yE8phVbtoKL5r70OX4QJEaGD9JW6uTZOlvL180gRYAJU6qkgqvd4E2r7M0QUJEISBwOaRSCsNwWENYaT6m5Ov6Sw0ssyyvPkO2E+Sq+5jythoOS/27S6efPGJLfuiwnZ9hWZCd7j6u+MqUMqqZmc7jN4zS8CpjwHqokPloVUUo/OmP9q4QzqwmxvrJCsVl/5G4/7Cq6izEtLHSHUpJ8uwkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775740975; c=relaxed/relaxed;
	bh=1IJi7Kgt9MzT0qPxwcgishVD95LZU8u0hTGKrYKuTA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=glVZph2R9g9TfGB9+uNVSXa4qyZ9GAxt255kSDu7DphvT2p4QwVTldnlKj+k1qMbVDITm8oyQsI7TKbOqz6yWF45b1sOhlX9PJ31rGzW13c7lJM4M9fbCtaxoyep6bv2Qan4HlHEu/dxC8oiOivAHDL5JJB3RjAapgzeWFRoNArTR0pZy2Knsx0Jz20sSJwL/mAQPLxSiEVd72pO9BXpXdclali2Jx81F7hvO9KowiJb7xXYIxOy6Gk28lyc9Fqfo+qd0tFfDN7nIoO9BYYNvZomVpUZjHuw+v7f7n2uGj3l8ZkfecO76R0IlZZQHa9Fik8Tr/gH704DXoE0VhZUOQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Q2UtYV3t; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Q2UtYV3t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fs0ws656Kz2yfS
	for <linux-erofs@lists.ozlabs.org>; Thu, 09 Apr 2026 23:22:51 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775740966; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1IJi7Kgt9MzT0qPxwcgishVD95LZU8u0hTGKrYKuTA0=;
	b=Q2UtYV3tkzXUI5OC8wdSMy+fExmBOFm1ldwTyhwWKZJXcHTPapvNzlDR2XE6ttIIvoQVbgqrVTKxMQPl3LNBQEb5uTN94S7b30x7H/lJvADa3P4Y8Olbwg3nb7Euv3CTRjYk5QTnCpSPXW8+DwKwwodEilmpU9bHLsEyS86w7oo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0iPoRL_1775740964;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0iPoRL_1775740964 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 21:22:45 +0800
Message-ID: <49dd4ae7-f703-4d39-8145-bf38f840b444@linux.alibaba.com>
Date: Thu, 9 Apr 2026 21:22:43 +0800
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
Subject: Re: [PATCH] erofs: fix unsigned underflow in
 z_erofs_lz4_handle_overlap()
To: Junrui Luo <moonafterrain@outlook.com>, Gao Xiang <xiang@kernel.org>,
 Yuhao Jiang <danisjiang@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <SYBPR01MB78811E3B3E935EFCD5D63334AF582@SYBPR01MB7881.ausprd01.prod.outlook.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <SYBPR01MB78811E3B3E935EFCD5D63334AF582@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Junrui,

On 2026/4/9 14:57, Junrui Luo wrote:
> In z_erofs_lz4_handle_overlap(), the index expression
> "rq->outpages - rq->inpages + i" is computed in unsigned arithmetic.
> If outpages < inpages, the subtraction wraps to a large value and
> the subsequent rq->out[] access reads past the decompressed_pages
> array.
> 
> z_erofs_map_sanity_check() does not enforce m_plen <= m_llen, so a
> crafted image declaring m_plen > m_llen can produce outpages < inpages.
> 
> The in-place branch is currently unreachable: it requires both
> partial_decoding == false and omargin > 0, but these are mutually
> exclusive. partial_decoding == false requires pcl->length == m_llen,
> which in turn requires (offset + end == m_la + m_llen) where
> offset + end is page-aligned from folio boundaries. This forces
> m_la + m_llen to be page-aligned, making oend page-aligned and
> omargin zero.
> 
> Nonetheless, guard the branch with an explicit outpages >= inpages
> check so the underflow cannot occur if future changes break this
> alignment invariant.
> 
> Fixes: 598162d05080 ("erofs: support decompress big pcluster for lz4 backend")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

After the second thinking, I think this patch is better for
easy stable backporting since other algorithms can already
handle such case (although we should return earilier in
z_erofs_map_sanity_check() formally), and I will submit a
follow-up patch to revise the related code, but it's not
for backporting.

How about refine the commit message as below:

==============

erofs: fix unsigned underflow in z_erofs_lz4_handle_overlap()

Some crafted images can have illegal (!partial_decoding &&
m_llen < m_plen) extents, and the LZ4 inplace decompression path
can be wrongly hit, but it cannot handle (outpages < inpages)
properly: "outpages - inpages" wraps to a large value and
the subsequent rq->out[] access reads past the decompressed_pages
array.

However, such crafted cases can correctly result in a corruption
report in the normal LZ4 non-inplace path.

Let's add an additional check to fix this for backporting.

Reproducible image (base64-encoded gzipped blob):

H4sIAJGR12kCA+3SPUoDQRgG4MkmkkZk8QRbRFIIi9hbpEjrHQI5ghfwCN5BLCzTGtLbBI+g
dilSJo1CnIm7GEXFxhT6PDDwfrs73/ywIQD/1ePD4r7Ou6ETsrq4mu7XcWfj++Pb58nJU/9i
PNtbjhan04/9GtX4qVYc814WDqt6FaX5s+ZwXXeq52lndT6IuVvlblytLMvh4Gzwaf90nsvz
2DF/21+20T/ldgp5s1jXRaN4t/8izsy/OUB6e/Qa79r+JwAAAAAAAL52vQVuGQAAAP6+my1w
ywAAAAAAAADwu14ATsEYtgBQAAA=

$ mount -t erofs -o cache_strategy=disabled foo.erofs /mnt
$ dd if=/mnt/data of=/dev/null bs=4096 count=1

Fixes: 598162d05080 ("erofs: support decompress big pcluster for lz4 backend")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

==============

Could you send a quick v2 for this so I can apply?

Thanks,
Gao Xiang

