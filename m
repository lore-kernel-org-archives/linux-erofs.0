Return-Path: <linux-erofs+bounces-4184-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF01C5AD7B
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 16:40:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJgTz55hmz2yxN;
	Tue, 11 Aug 2026 02:40:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786380023;
	cv=none; b=hKN6c9/1C3WSCTvaQvPcVGcIFNAORzT25Ph2dBsgJY1kriOETdWBHqvK80V3o2PsPHdQ0V6ZFN2XlIoBAlj7CTcsJXlfWI1F0Hs262MOK/AnIBFYnPRkr2oVKiQFfByS6zWJbGQGegjgXooepenVQ7CKBMvA1ol1BUgngIku9i+scadZWnF4b1pID0ROXDaAdeEW+NX9OASTqYNNCywpZtJ8NaN9Tje++9k1tYlRzdpNELNny/I4lrVdNxOyS6PmKDrQH7vmohPkatJxN2IeKu0c/PHQXFPoBNvTVoqDIN6+BHyXtZ/j0OkEwLIdZZjiNqc+UqzmBvllbElmTKVtVg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786380023; c=relaxed/relaxed;
	bh=f0bZditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i6VlV6qKKi++jZf33zeUJq5ZFDQ3m85G+IMuMQoKIYCvG7sd+irGJtlbzaZgJpInb6C4/o+cnbEXvbd/j9UqonsV7Iv4RoDqJaHTbFUD2M5eaiZsSrNAxCEL6N+hOQhl5UPNemlNjWsyp3qkuU2TNug4QD+tIy5zt9teLdZ3NJKP35SDFlwFlQskQGJty5UGT0x87dHZJjUTBp9gJNSVKCMuIl/OdQgopt3MguZsADBWbfbja6g+KOAOzBCmD+GCbyvkisnmsyn/pKhcysYKh0FfMjeeUPzEhGs+UnP4oZSiiOuKsTK/ULG+F5n3emWsTZdawTimIjEZAakgu5ogtg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=CyN46gAF; dkim-atps=neutral; spf=pass (client-ip=148.163.139.74; helo=mx0b-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=CyN46gAF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.139.74; helo=mx0b-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
X-Greylist: delayed 1792 seconds by postgrey-1.37 at boromir; Tue, 11 Aug 2026 02:40:19 AEST
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJgTv21Pgz2yS6
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 02:40:18 +1000 (AEST)
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AFcj4k3396070
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 12:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=f0bZ
	ditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=; b=CyN46gAFzGTv5sCQAiJ+
	xhJD7DYCrTeiGETf4yox+1+3CDtlrqNvkTFW4J4vobHmLbXUHDE3doFn2xz6glN6
	k3BaKUBMntJiRVVcyGVM+aPSYqFm+iaf0XYNNoNBeRDmY9JppLG3h/hrnHSqxXvv
	vjK8KVgvBMjsQt6iPYPncBt/4wLvSNnFasjiicrFClgJgyo8becIWZAI0ulxYnrR
	6gWJbEIwkZVX0gc0uqUhLZ6UiI8xM4a2dmU0T4jB029Z7GGdBlXVd/OkAW3bqRIn
	Cc8m/OyKwiMnlPkQ7RPRQxLQ1PMxJu4vRWd97Of20SU/QcoKr4fq6yE9zIqHq0a3
	1Q==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fy0rmmd5f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 12:10:22 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5276aa86d00so20750021cf.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 09:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786378222; x=1786983022;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f0bZditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=;
        b=ZudXI1ON6OY/blPffFYKPuhOiFvLSM7QFdVUan7flJHMvFrhHZ8t1TkB6DaGnlQzg6
         BaZHlqP8LaGUgm6vKeK4d4Q2x9S9nEJq7wZv1c7F0sSF7s3IkdYbtmTVaYlHKZwCE7Mi
         cYFPMpH0wV4m9GWx/i7t0L2VCV7nw7jI7Yn3oE3ORni6Mn61FP2ueTktPfUBjgO0b0R9
         9lXgELdX8Ji+X5Noto7NdGJgfsPe2l9UR6olO/92BlPYbRK+tsKvftlygu37fFnB3hFr
         3RRPgz+4QMMkxCcTjIPGoMVwd1K4Rd8yUzvrsJg+BgnbsQqLy0T9HI+ym+4+iEUlBytF
         89zw==
X-Forwarded-Encrypted: i=1; AHgh+RoUPXGo/Zygjt+Tx7mltq9HB1NTVs3xbU2/qaIeAI4/sKLOHpuOnnihJ4DATf3lQvRsWq/f5VwfjfR7jw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YydzANxMt7Kh2OYAkvuoGJvcXAVfncxpxpE7uSPrVIhoBKlCeUm
	0+Cv+Q53HmEaWFkNvjzO+y6wNUBxdY6m2cjUCF6Ufliq1YH9bAl0E6uZuBxQcNvhZAU2FKX75Rr
	DaddFfIt/1jAnPi2kCVuiKeRh3+bzmliPlWptEUKZzYU0T3lp0zsSxmsYJmvH1g==
X-Gm-Gg: AR+sD11GHV9yr1DgfWYzXKyKoubczWvMBcY4oB6aLKi3UTKWKjTdKSQstIlroKDcvDS
	WvFCpWroGcL16WD93ihbD2OvfpOFhUCkUcu9KVh/96LWeki1OuwuVrwL7V1/kfiop/3Yj2NZ5Tl
	12pb5iXsd0A5rf3X66e/Txc6sW7S+lQ5ClVJeTxxaOde64OV/orucvnpOdufK1XR2pOJL8FvJ+T
	pSI9xY4TGywYqD2nDNwt0/2IQBupBUSsYmYjVSGdKkl9LgfcWOweMB08lIqEwPecBqpRaiw0wIQ
	CmVoyI59r6IKH2eifc9v4Vx85avW7D6lzzUDAkOqo1WG9dmaTopTBXrQxHdgbCPaf0fMe5fYye2
	1T2HHi7KuX24dkxc4FQWr/fT9zHr8lkUgaeUGvB7G92HPvPwhR0na0g==
X-Received: by 2002:ac8:7fc7:0:b0:519:89b6:78b4 with SMTP id d75a77b69052e-52d20a819bamr234404611cf.40.1786378221623;
        Mon, 10 Aug 2026 09:10:21 -0700 (PDT)
X-Received: by 2002:ac8:7fc7:0:b0:519:89b6:78b4 with SMTP id d75a77b69052e-52d20a819bamr234403791cf.40.1786378221085;
        Mon, 10 Aug 2026 09:10:21 -0700 (PDT)
Received: from [192.168.0.165] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997402a89bsm4159805e9.0.2026.08.10.09.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 09:10:19 -0700 (PDT)
Message-ID: <8eb00a03-d6c6-423e-9768-48fd2566f11d@columbia.edu>
Date: Mon, 10 Aug 2026 19:10:16 +0300
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
Subject: Re: RWF_DONTCACHE regression fix for xfs
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
 <annkDbhXBEeMoNVT@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <annkDbhXBEeMoNVT@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=P9gKQCAu c=1 sm=1 tr=0 ts=6a79f7ee cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=dys9yn6NND9hJ5TNHOUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEzOSBTYWx0ZWRfX7mb7wQP8oN7+
 f+GWN0HToO05vYD31jwK/hmyn8XBjPT13q7xljJNB8PwXuXoMQZtwtYPXqwd8vSaKZzCNwwfMQf
 EMH65qoaYDcKe3N3oVSB2MsRTYWBKYYM+NN/Cr65Jw/5sKKY6wzb
X-Proofpoint-ORIG-GUID: _uGRCRy5x5fiFsg_BWPBy-l_KrFird32
X-Proofpoint-GUID: _uGRCRy5x5fiFsg_BWPBy-l_KrFird32
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEzOSBTYWx0ZWRfX9z6AagmomFH4
 UFaHm9yI5CLjMLClmwH5EepAvlC8ENP7uwx203VSg3vMNEdTB3mt74sPBlONRkmd644tHcaLAdj
 qtYBxPBH8WH25ddisLIye9x8UXnZadtbVD8HSHatRiZZhqg4SDFZw57AaR8BmjNBmV59DpHOick
 YZqGQjnbIIW8ozGEcrrZDCZZGu2ujsRdoB94pPfH3pWn6Wf4V/UnbTmq9r7gfTAjjV0tGJbwfVZ
 tQH9iemGo2O8nooAZtI0kQszrcCFGcA1+ij2s8xyBJOLp8rfbLx+0Su9tE9Z5oRE/QZo/awGpyj
 XGLO9DgEvVq3JEVLHZmY2650YHAjJZXucRZSIunvA9RWAS7k5EL6lPKTA+7zni98IoDSK6aNFlW
 6szhQmbiKuYWgk7i+8QKJ06ObGdWe7RMJrPeso4fY/2Vze9Zx89kqQPPL+l8kImd0Pk29Fw0i1R
 pf2l5UK3zZ86F1QHF0g==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11871
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=10 bulkscore=10 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100139

On 8/10/26 10:45 AM, Christoph Hellwig wrote:
> Below is Tal's suggested fixup for xfs with the whitespace damage fixeѕ.
> It should probably be attributed to Tal instead.  Can you handled it
> from here and send it to Jens with your signoff/authorship to avoid
> the performance regression in XFS?
> 

Yes, will do shortly. Thanks Christoph!

> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: avoid double deferrals for RWF_DONTCACHE writes
> 
> XFS already defers some writes to a workqueue when transactions are
> needed to process the I/O completion.  Disable the block layer bio
> task completion in this case to avoid a major performance drop.
> 
> Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
> ---
>   fs/xfs/xfs_aops.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f73e26d9c9f9..059846a8d65c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -372,10 +372,14 @@ xfs_writeback_submit(
>   	}
>   
>   	/*
> -	 * Send ioends that might require a transaction to the completion wq.
> +	 * Send ioends that might require a transaction to the completion wq,
> +	 * and disable the block layer task completion for them as there is no
> +	 * need to defer twice.
>   	 */
> -	if (xfs_ioend_needs_wq_completion(ioend))
> +	if (xfs_ioend_needs_wq_completion(ioend)) {
>   		ioend->io_bio.bi_end_io = xfs_end_bio;
> +		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +	}
>   
>   	return iomap_ioend_writeback_submit(wpc, error);
>   }
> @@ -481,7 +485,14 @@ xfs_zoned_writeback_submit(
>   {
>   	struct iomap_ioend		*ioend = wpc->wb_ctx;
>   
> +	/*
> +	 * Defer all completions to our workqueue as all zoned writes require a
> +	 * transaction to be persisted.  This also means we never need the block
> +	 * layer in-task completion for a task context.
> +	 */
>   	ioend->io_bio.bi_end_io = xfs_end_bio;
> +	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +
>   	if (error) {
>   		ioend->io_bio.bi_status = errno_to_blk_status(error);
>   		bio_endio(&ioend->io_bio);
> -- 
> 2.53.0
> 


