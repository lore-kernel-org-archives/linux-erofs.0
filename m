Return-Path: <linux-erofs+bounces-4060-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AA6C5516D
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 20:39:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hB1Jm4h9Qz2yH4;
	Fri, 31 Jul 2026 06:39:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785443960;
	cv=none; b=cAQJHTykQtAsUkTE9EJ2H1U6vkJRxwmnzLem6eXVU+IjNGgdDTcgdePj89fxzuEip6yf/9EsjkssMPsupi8SLUcoLEz4eb6Dz1izY0lsMELDUg4C9d55X10aTQASHe3ayTawAfEikctgAq+M3zby9+Gdp2948LD65kjsbkSOpMq5p8lY1VCVLTm60A/JomcesSbdAr/EQrrSRKlabVsnQhhXZ7GVm5I/huwefzltTuhkDFUNahYD1L//eTLtXf86FcZwgBVwHQ4bNRcYEYAtGCZpQXcWQhKnKz8g9uoHsKnoChXy6AzBUlZ/FujbENV1PJ9KexiJSeo+cyUcpY3cOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785443960; c=relaxed/relaxed;
	bh=T8e8k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aMRh0bkZpxVjJ6pgiu2GVmor8jMbS4mDGDOuO82+L8i57ed5VyF3rcsGeDJ9z6o1+du4Kc2NrFD9LXmsIbL6+UvAmSj8mt61QWtw8mVJF4aLcjuyLCzfCGfsMhPkKEbVsMWIpVkE16oEZL5w3DZKxvIVLAhS2tIaEsi7gZx1A5Z460YSaPd7CKLQ8vFMLi8vyZK7P8IKx34jEQQRMHtruL3N41NN+JrZUwZ8TaSHk4+TZra0nFQXi9ukJPPzu9xYKXC8WI0RZrEtOf2p+fMA6De1B4ipS55RbStIQ7iDaq2/H81khGaAKwa6ohHSpuVS6RtWhBKZd2HoZVE09DqeUA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=WQ7HnPHx; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=WQ7HnPHx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hB1Jh3zclz2y8c
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 06:39:08 +1000 (AEST)
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UKY2eT3319730
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 16:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=T8e8
	k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=; b=WQ7HnPHxqZL+jR81XllF
	JTKnzPju6U39UyyWhhTcphUfZ+xAg2wqUa791ebQ1v5NhvW0IuF//dLqtiOJvHMi
	fmyKW7M+TGXkdSy8yhCZpU5HL/IpFm8hExjB6Zd8ZTnCZBp0FfiM/4VmQMN3Nyjj
	wy9qKWJdLe5TFEiS34dauGmL0aNhbdETHjmjDl6ehafIPC0BA5I6nCfjcLjVALJk
	9EAViui9QVuK3SVhaPP15FKa4Vxbk1NUe/8NEuykcAZ7ZyTVvPKKcmrPB5R0nGP7
	1xqHFPEmX+ojBlGjFW+JqGfOPxg4M0VGW9uE0F4ziDhKljsql7UvZhC9GapkEQy5
	vw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4frbkhh43v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 16:39:06 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51a8db414c7so2965581cf.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 13:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785443945; x=1786048745;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T8e8k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=;
        b=T9BbX769Z9GnLcF/JkoFh428P9drkry3KQZTR3pulvjPUiAZzMhgM01Ukq66BdlgnW
         j3oj0xewcKhIudvU2U6goAU69aIjn4GLJw+60aazdm16lr3gOVHw7zSDBxsDjaUDsm9Y
         MV+6xFfVQcX1gHrHTPySVbc67hG/Zkxu3dvMTomW1PDGUnVyYH4SA7t/hg2cNFkDEVi3
         /NAUhqY9ee/EPDpRBAp1Q8rX//rqs04v3iySw94zC2jRElleLREKLSh2zUOYIlAKEj8f
         tbwZlXxTnAkSiHfvxFl37jJYSgq+VLQWa6MjjhQINdjzDAgs37tQCtYm+wU+ri8lm0eZ
         dy4A==
X-Forwarded-Encrypted: i=1; AHgh+Rpad9wM1yRVZSDvUIQe9XfZCKyof/1rrD5n4l72hTdpX/NbyOhJ1YnCtt6Syxix0E63UqTHlJ391+9eKA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwuxhSrTDmkYsl9fwY7iq5CEFyvyniio+myFfpdUyFjcCPKWyWI
	OM/y6f1ynABJ5YxN529UTcjDhaLqffo13ZEIatDjOtgMQypwZYacXzY/uCnCZLPSbaDIZmyTK+8
	FaWhMgdg+TzJlTcMb4vn1r/XamjY/1fqy+6ojaLcz2BfcxxsYy2umYQLhIsi2ZQ==
X-Gm-Gg: AR+sD11G31uFgzB4GK4LwXvI1LOA3Qh1XH9gdXY8wWxi+YGvWQyUVYXc2e0abAeTRmX
	RNm2NIskD51gqrqBQhJ6RduVahMV1NF5xIVL38ERy0/5B17KAkOPP5GhXfztvwytvgm5/O7ePhT
	XqwQ3HozRJYAIwpnWlmdlRALEMisxFTx8fdyRbZ0tyv2W3c5wN3Q6OgYRczoxNv2wmAvzZlxKiR
	a5clotEeDxxFFl3Pl6gxgVVuHd9xeD/ANGrbnjCdWYiK5x9uRqBUk+6R6jpEJzHLBrDBsP+uhHS
	xgnucxRq+FdMtA0brvKKKpztiJkFiSNT21J3gg5qeJghrUXwb92MvolrSCT7S6Wmidh7SqIdZ4S
	gjdGbHjLx8Qe63AU=
X-Received: by 2002:a05:622a:3d0:b0:51c:7b11:41a9 with SMTP id d75a77b69052e-52b38757e60mr44335551cf.86.1785443945531;
        Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
X-Received: by 2002:a05:622a:3d0:b0:51c:7b11:41a9 with SMTP id d75a77b69052e-52b38757e60mr44335011cf.86.1785443945082;
        Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
Received: from [10.206.71.35] ([129.236.231.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529e2d8251asm48127221cf.19.2026.07.30.13.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 13:39:04 -0700 (PDT)
Message-ID: <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
Date: Thu, 30 Jul 2026 16:39:03 -0400
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
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
 <amsHrVCJnuXzeGG1@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <amsHrVCJnuXzeGG1@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Jp/Bas4C c=1 sm=1 tr=0 ts=6a6bb66a cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=Mx06nvryMUGB95QVe9e23A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=qsXxR-sLYAu0WPx4Yu8A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE0OSBTYWx0ZWRfX7HfzrRMxvela
 4zUEtQz7yTpIr5JYQNn5CTCDZTeqd0YgavVO/ZP/N7f/Z9/eaaoGnoH9nkwLm/dkdZpOLcVawku
 MVuaDmRQ6ps7WySrv9Nv6r6qLjtv2AvkGNzIEbGeVtg1x8ukYUYv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE0OSBTYWx0ZWRfX1nDC4+g+qYg6
 OEzT/wf6fzZohXvOS7BJYWDAl0Mwne/Ib4a+nB7ybLc49S2Qc6yVehZKVRk1mOGhB/v18f/2FJd
 rDWvO7HkrrDzrFEAlEAAeQNYhEJlcIFVj6J4bSyjhDSRUR8QdDwkvY/eG23WVHioEwyOAIFdd6h
 FC1R4jGRo8krDmupapcRFuqabIpkAVQtSHpjflepa5rOyYKM1L7NUhA9bX/ZBE3EYGa+MB0BCaI
 KOnA9Y9rTwAMZBji3yebFY+vPUmv6LtUaMdmvw/EO2TpkrT8VUagApT0Nv4zOSrd8RdPhT34Fz5
 HTgp1GYVKGfz9HWla9ggd3sgb2oBveeHERA1sXm8k7bf4RrH/nPX2mW5BoZ78xE+JYshZvjsl/V
 5qHQEg7hUQcW2Ug62iZM55QLhDPQD/B0V4UMCpfZhAQuIXk6TafZbGPd1C0Jjyh3KIhjKfNXgrd
 UvPCzhQSR80gR+ZW0XA==
X-Proofpoint-ORIG-GUID: QQG_WI1EiGymEwOg6wduqhKjCdmfQP9Z
X-Proofpoint-GUID: QQG_WI1EiGymEwOg6wduqhKjCdmfQP9Z
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11860
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 bulkscore=10 clxscore=1015 phishscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 lowpriorityscore=10
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300149

On 7/30/26 4:13 AM, Christoph Hellwig wrote:
> On Thu, Jul 30, 2026 at 02:57:53AM -0400, Tal Zussman wrote:
>> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
>> is added. This ensures that bi_end_io runs in task context, where
>> folio_end_dropbehind() can safely invalidate folios.
>> 
>> With the bio layer now handling task-context deferral generically,
>> IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
>> route DONTCACHE ioends through its completion workqueue. Remove the flag
>> and its NOMERGE entry.
>> 
>> Without the NOMERGE, regular I/Os that get merged with a dropbehind
>> folio will also have their completion deferred to task context.
>> 
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> This seems to be missing the bug fix you identified for the double
> deferral?

Sorry, I misunderstood and assumed you'd take care of it in a follow-up.
I'll adjust it as below and send v8.

> I although thought a bit how that could be done cleaner, see below:
> 
>>  		ioend_flags |= IOMAP_IOEND_SHARED;
>> -	if (folio_test_dropbehind(folio))
>> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;
> 
> I'd keep this flag.
> 
>>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>>  
>> @@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>>  	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
>>  		goto new_ioend;
>>  
>> +	if (folio_test_dropbehind(folio))
>> +		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> And move setting the flag to iomap_ioend_writeback_submit, and only
> for the case where no io_bio.bi_end_io is already assigned.
> 

To confirm, this would only work because XFS provides its own task context
and is the only consumer of iomap that sets its own io_bio.bi_end_io.
If another filesystem set it and didn't provide task context, this would
break, right? I can add a comment about this requirement, but I want to
confirm the intent, as it feels a little fragile as-is.


