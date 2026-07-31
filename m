Return-Path: <linux-erofs+bounces-4069-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1966FC55171
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 23:55:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBjd31Mmsz2ySN;
	Sat, 01 Aug 2026 09:55:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785542151;
	cv=none; b=K+jLG0uWh4FMW3lV2gCgNe2EyNbZYThx2gohUOazeSKoiz36ZyXc+5o6aKdCvcRPD2Za6WVETHFEhy9v/5QhLCO3iF/0Fzt7BnmpQReKwh4CU6gj4usCOM7TQOXbek7z8XtIoSsy+isomukCTXG77YPi84WBFNqpl1D0JotEnmUyHXz/7ywqBBUfyf/uMP77XBpCLmOFr6MAQ0WICiXcN4Js1+4hOUsCBxrfkJBvebva6PXMDBzln0vF9CEh9Q2xzL/RgiX+Bm6B9UM82Qj4M4BG1ET1lHWEwtU33TpWRcJqO1u+ETnsMTI/FVPXIt0hEZa6805AjbXNjIVtIV7mew==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785542151; c=relaxed/relaxed;
	bh=KPIAGymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GBpfVIRXfWc0+kuZ+5CuHzN6W0uvktp9WHeNEhQB2nWXDnw163wsoGCIuoqJig34UBx0MxjW5RB9suilEs6JE3QxaH2RNN/rz3efy6JLXFGP+tRLGLujJljcvMzO4g4sSqWfiHABOoPD096Ye5eqXsTysLMmPExbnNDfaSdQM7W+YUg1vbGdYJrjVzsuNIu6q7ZFutafcty45Bby7wexR0Nf4GufjqtJXXP2lXmi5NDGktnJxwRsIOd5Dfb2XEsOwdmTq4dkP9m2EjgJNCHQhfd2HfcsBZf1auanZo6zq3c78Ew6++rlAVZ276OCaxfnyuw10PgXxw34DHQ+Kum6dA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Uo15toe0; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Uo15toe0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBjcz5Z1Nz2xyh
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 09:55:44 +1000 (AEST)
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VMZpGW3080704
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 19:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KPIA
	GymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=; b=Uo15toe0rPDAPWwZwVeJ
	n4E2aKPhzCtlbJaIPoOEk9oRKi29yWUd6bKSiKw2/UEDTT8IEoVnM0DWGZyllyTD
	40GpyfJ7ynehv56/EO+/jPUwA4CByxejxRy47r6xIde4zro2qbznQsk1f3dywHQu
	wWe/OeeuDrb/CAZQvA482658TGeu20X/PI6Kw1A+xglVLpQoL80+fmUhRsCQSdex
	hBfukncjUKNjTuWp4rZ1AdX9RDFeDZK1825QXT+td5WsnXaq10PJ+COGZwtnliH8
	5iqQ8kshUmIgCn4Ssedi1QZ6CFkegXN0zS0YJNWRRYNyK7IbH/AyMNUtzTFSMG47
	Gg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fs3590sye-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 19:55:41 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1a9764f0so16003251cf.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 16:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785542140; x=1786146940;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPIAGymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=;
        b=FnME4FdbPoC3MUyvrpazSbLimYxiTmG1jlR6G4zBJm4PEcWbq0SoygV6I3GYfdLg9A
         9g2YUBkRD0erjlKDlIzN1/otis5EeYaw9demfGVz8a3dxVRsd7T48FWJ/hUK54Sqctlg
         sQj/svl/U9wFhX5JnUUyLwGAIeKgRJYD+6h08fpG8lXd1Omc7rpIpTG/eDfdjEQkNEvS
         cXX5W5qrVBeBppBs4L69QIq/9eOuDGBV0KeV++C3RiOTCAKRZNmohAyxNqd57k2YF0OL
         pXmsOLC/BcPEjpfC+1pZ0SfscYRd8AHl0iW9pK7/+QFXaekoLgCh9V3hEJPAoqAkJrCI
         djrQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPaGyFAxgm6QnRjADKMKIWiAT4f3rX59AZN389j0LWAGtdPr/U65Lphg5U3eT24vDCM8qTBHMZ6HE2NA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwAUORSDG+1V+qB1xS6twoCRTv+yImwmmFgPkI6T6j2RDvyxF4C
	Qcdp8ri9MAkUbP3ieIV4MQi76gAGofv+2Z1KbR1kx/w2HXpfzGMJ75yETJR/Cn9PxMVq4wTk3+6
	v79+6J5wCkkWIkQVAKg7PfTmJNaffdTC0xhgq/J2jBC0lFVuZ8ZC6j8rQbXOMcA==
X-Gm-Gg: AR+sD101f4Y/QT96CR8QFOEQ5UUwLlJtzuCjexcKdAIZV7VNHa9Bc8MHncJoRRO2DiD
	N4wZSBwXcE/zSaxFWApNaLfJdTodw3II+Beh/fBJWTLndu0dVJGxPm1/wufC3UEVETMAU7Ja6Zi
	ZLC/jLnkfSftHhywB1ot8hmATCP5e21R8zqpcvroyLXJUkAvHxmO5hiFxcfnkQHHwFYbnx0FeL6
	3Ebl4MC2ZMzfXyaLe7CWqrp9/m292xDkUXXmZ4gBNRhP0vrQmDu0K1AH/luKrgjVxHaHfWFusgw
	lx6vn+fw7ECYBlj2VpW6xvq+PlbN4j7sKZ6pPOEBiIRvn/1QSsH+s/7LrxBfstpn+NFCQjFWvx9
	RpvUqeb8WtBmNlQ==
X-Received: by 2002:a05:622a:2618:b0:51a:8f3a:13b9 with SMTP id d75a77b69052e-52b566b184dmr44464631cf.16.1785542140295;
        Fri, 31 Jul 2026 16:55:40 -0700 (PDT)
X-Received: by 2002:a05:622a:2618:b0:51a:8f3a:13b9 with SMTP id d75a77b69052e-52b566b184dmr44464271cf.16.1785542139795;
        Fri, 31 Jul 2026 16:55:39 -0700 (PDT)
Received: from [10.1.46.221] ([217.192.152.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b8d04fsm6127465e9.3.2026.07.31.16.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 16:55:38 -0700 (PDT)
Message-ID: <adf05cdf-0c73-4cf1-b1f7-9d063c891eaf@columbia.edu>
Date: Sat, 1 Aug 2026 01:55:36 +0200
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
Subject: Re: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale
 <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 2COS2R7npsePoled6WiX-8EZs-XPaUro
X-Authority-Analysis: v=2.4 cv=XMAAjwhE c=1 sm=1 tr=0 ts=6a6d35fd cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=NgQitlhRlW+MZLNskBD3Jw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=c92rfblmAAAA:8 a=jDzJYAX_DjbP0Cb_QUIA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE3NyBTYWx0ZWRfX8MlIk8qK8d4o
 +65WW3SNAEmqYJohPcXQSh+4F5lxbVPbSwiqRKTVxF8QnQKt+iWQUOGbD0UTbc47bNvyT705xQ8
 to4WKe1jgUqpL5wSklQY25qyHTmyl8nm01Yqp2xxSrRKOWYR+brVM35dJa8qxTbr9+I1cpcRaP8
 R1XwrsJ74fuL652cmtw0PMd3iU8TTXyBUVAoL9hxjrhtX8FSf0MCDwfrpXaNW9vSrtKCtCk7NCb
 gs5+ewpaQmqWFojQeqOpz5We+GfhJJiukgFIfh6oJ4sDzATsCIR80Z9sYPTraBTEypJF/zMupOU
 Zrl0fvJg5Yf1Y8o/SD6v4oQ8yN2IVkLW0llcEJCOrdNwF0CqNvROHQuPm3HV7vVgq1i1UGDQ1Ko
 U7dYPsXZ3bGhF0xPrr5dUqpEWY+0H+Wuvvu5eUif/vmvvgHmdau7MRLOvszDHjO095xd2To6vLP
 3uzKy1I1mE3gW+fzskw==
X-Proofpoint-GUID: 2COS2R7npsePoled6WiX-8EZs-XPaUro
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE3NyBTYWx0ZWRfXxtL4b28gJOcH
 Uxysujlg7rebO730c93r9if7pW5QiClvJDn0Aa+rNr1daBl+psw3fOytnDMbmW9/Xy8ji1J3Qcc
 upIyeM6w81F0A/a9t2FQm01MGamMW7e7uFhqWLxZ+PQZfWQlupQZ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11861
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 priorityscore=1501 impostorscore=10
 lowpriorityscore=10 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310177

On 7/30/26 2:57 AM, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
> __bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
> CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
> BIO_COMPLETE_IN_TASK on the ioend bio.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  block/fops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 15783a6180de..8b39c53b6393 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 

It looks like Sashiko found a couple pre-existing issues in this file [1].
I've reproduced the first and looking into the second. Will send patches
once confirmed.

(FWIW the other issues Sashiko reported seem overblown.)

[1]: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5

