Return-Path: <linux-erofs+bounces-4369-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA58C61DD9
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Aug 2026 15:26:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXJxX5tmgz2xq0;
	Sun, 30 Aug 2026 01:26:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788017168;
	cv=none; b=aNuUynmGSzJ73IeprTD8OMKyB7fQN2Z71i8l2bH+4XpkRxQQ+Gx4LdzWzi5aiYmveMrFbn9AZ18ZG/G5BXs3d0An4HEwGqncnrpro+zBnjWOof2b85FCIpsgwMCmyh50vKjhTFIJc4QP3Kz+rCkwRepLKQneRUZoTDmipgTC7ftcYvprRfcpd82+H1kCtr0kOzuYA6p0Hfwd9z4zxxv9V4OQbSGbLmaD2uGguXFmfrRSuh6OaFexfwpkaaY6YF8eXzR8UlsjMJM4+942YY4tsknM91KYf2MkiXa35XY8QRpzTCLSFJYef9svg4mFW0drviiE7QP3gwR/67XRsCJWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788017168; c=relaxed/relaxed;
	bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oht2pBfiM8B8NSGtQPjfGvVVDaOVy+xgH99+jdTXAWvZ6n3IaXxvTmx7bUDTmbZG5YD/Tvu8+/ClmAsSYwhveUxJg4n/g6NUiPp6XW8luqfPGFslkakpdG9s/DSsBof3WjGnIRiUkDq+vsVy6dxsT4czf8Q7SpXW0NLkMQvkPijcAzr1GUHkMwIEbQgICzZdcNjncHgYuw6FcSL+H9dV+k8enyTHqv55oODfFWKdER1e4DCugdcLEc5meidSqsmJ+cfyoGkt4N79Q5rncZyWaL+1cAZcyHasx1rlfSwRAq6JYdXvJsCP+GnHk2ETU1E2vWpF3TH9W5A9wMbXvIPnGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Gu2zFIuG; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=oQUNeVne; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Gu2zFIuG;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=oQUNeVne;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXJxT0knDz2xT6
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 01:26:01 +1000 (AEST)
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TEesqX855754
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 11:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TFVW
	lDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=; b=Gu2zFIuGUDCk+rJ2VDBk
	70a9GXKIRmd3CKMeiyckWv/D5MP7Zgaj/CA+sovdSkrETK1IrJb2qFnGnQEaNT3S
	N9KtoDtS2aWLMgdaZS8EG79pcfDMQu06yKTxqcmPhJVJAftER9ykGtp1pbja1UeX
	kUFeO1YwKQdpDr1sZdsz5l4M5OOqmQkrZTmdrHduJ4FxpamhWS1IQq9E37/oh+3q
	nZtzyUcZ5SRVAnnPNjuAJxQT4FXqYOGakyKLjlrLX5KwZ+Imu1kdoq89hPFZ5bjm
	jEkOlYV+J6fGeVEAdtwq+7wZe5VJJ9mAqHAPx4qs90lyy6hcLcj/IAjQH5/0tLN2
	0w==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbqxha9dt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 11:25:58 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8fc6b670b4bso21209826d6.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 08:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788017158; x=1788621958; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
        b=oQUNeVnetyKiveDjbe7mKMFcuFg3ytpMswY5AiMqBmKZ0PiiyIClLmS/7IttukLIGh
         6JDGv+SrNpqsAmtwxROLiWHvJeuYqpWsBL8GaH0lwTgleVSQ10IT1obmFkHKcW5XjodM
         PnpK6QuCEJTrouNa9VnJ2KbBy5bV/GbHP89Tz+TAPTNMlRIwwK7Hfa8qQmq/U/xOCtA+
         8jPLYuRrWRxJrWNVhhA3oL4UcMice2SaK9tesxY3IDUcK3IsvhTZzgU8NxSK5qvN2Ei4
         XqlGTFWQ+CrJ+rtfq5OaApXv0x5M6XBt3O1aEFU8BRz3qp1k7/Bmsu29TnStP9gli6vZ
         KmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788017158; x=1788621958;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
        b=F0GCYtVh8xBg4+p7ab4EVJ8hNEZisO0DhMB/lUWuquMecvSJ4cK3+y3N+GoE9vtrvK
         lSp9lSOYARQsDGATIl4GsfZ5Vun8yf9YZAghsl+g8j3zEp4ws6OLZU9R9amtc05zfO8F
         CTwOl1JRrLXjbt2Zt7UtHA5nJyH2KBJqJ5dniU1Mvn4kBCkWtHmbnkAIpf/mpQ9/zlHT
         mFI/2q4dKaoOkx9RqlIw3lXOjwiMRc50MZKpGLaNmVvoXy3V0nZBbs8h14EyssYZh+zH
         byTqMLNBf+y/abpHY00jWKouLtWUq8k15V2PN5sKMIvjKSpkMa+gKm6WsAfiIBHoKJA7
         EbbQ==
X-Forwarded-Encrypted: i=1; AHgh+RqZQOV7AAFktOzISkJ18stptkmzfJwlDhruRFqIqyqkliYMgu6ErGEQJFpSMFZ+WQe1d7dSFkfsdEpqqA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++l/wsmDM2Vet4RPZNH6rmEyuwEZxeHbJDaQ75s7VT1K00Mn61MV
	Mhvy63zIXVlr6YAMJjQy1/cNPUkF+jNsP58Pma/ShSDnzKnA/ka32tko2X3a2oukCdQpi7gUyyK
	DDHRooAvZE9X1vse0GqXi/5QnkjSejegNoCabi9CNXUSPJ9yHT8ezWKdvOeIuqA==
X-Gm-Gg: AR+sD10MWIzAi3iog7QbN6NRKRXtJMcXx40tEfP+Ws1sZiFRgrUEo1ESNWiel9iDR2S
	LR0Vqgez2Lgl6DmLPv/MtSAXqybU2vclU45WN2zWXT14KSVTxDTsqpuaEE0Rqo0frpyrOrO7Bwf
	7RM+WwIxHeO7PjnxJ0A93IrmgZeMsRJY0yPEjrLgE+blp6wHH4RG4C6s6mDY3ST9YOinS60SZy+
	SYqxp/W2NrqDorJgkHq884wMlVCShx9YlaHtu+BKh55wTEKaTv8+hydD/Htz6yJZpWt/bi1dNh6
	aK8DNetfN42/sd3FvsYmuDN4aOckU02yBDogrCNSBGoWnHvbgST9pkxg0h9aXEszkyi+UZe5H31
	0AOxQ1xFZlXh2+tXytFI7la43NqJAiMehmCbAUImakL+vuVc=
X-Received: by 2002:a05:622a:95:b0:519:8998:661b with SMTP id d75a77b69052e-52fb9640d64mr173116571cf.20.1788017157674;
        Sat, 29 Aug 2026 08:25:57 -0700 (PDT)
X-Received: by 2002:a05:622a:95:b0:519:8998:661b with SMTP id d75a77b69052e-52fb9640d64mr173115921cf.20.1788017157157;
        Sat, 29 Aug 2026 08:25:57 -0700 (PDT)
Received: from [192.168.0.175] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca1ed292sm84339685e9.8.2026.08.29.08.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 08:25:56 -0700 (PDT)
Message-ID: <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
Date: Sat, 29 Aug 2026 18:25:53 +0300
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
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
To: Barry Song <baohua@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
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
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
 <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDEzMyBTYWx0ZWRfX+lWCZYCEHkxb
 T02UUDr3KxQdqHYCD9OGZDRcE+INSiAHdG71pIK2DVrgedFbp/ZKqdYC4jiCFr/VmcpmJaBWRcH
 +oSet0Bd8e7o+OunSEsv2IuRGX6eIwFN54gZhAGb6ZoMH+4pgJmM
X-Proofpoint-ORIG-GUID: PziiyYfOBH0MUp3ZHHiE7KH9Lvni7vrg
X-Proofpoint-GUID: PziiyYfOBH0MUp3ZHHiE7KH9Lvni7vrg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDEzMyBTYWx0ZWRfX0zOZL3bGs2aE
 oPIcvoqzT3ZByc1WbnP5RtCNMJta2+bG0QthLvb+ZeLfkQP1alQttCDbd8Ej9XFUziHvuLP8Leo
 bs4oD95kMNrFmsHEnmLfJmFfDULjqkupSrejVnfdk8tsbEbeR6I/Ix4r7og3lAiYaTR+ZSoJ4oN
 ceV4fS4wiWjVMYLRrscwnArwZiZhbo79I48CvwTVoINS9Jroi2lyS06/hWp0td7NEkq69GNoar1
 NMJ4rNN7kgQm/e/sQCB/0UcW7+ysVRbhlFOcZwC7zhmsEtKHxh7ITa3EQ4fKsI+Kqf2aEi4nP7a
 G+p3Kqttzpl7FTgIgxHjPAOBvYlGughlYJHVxPpq8QpHhuBkMys4Jk5pWxjNQfPPF8mJ/oRH44o
 SgneXZbgQD6B274JPXqBKhcuLFYMR1R7OdE5vgyJu5V7Gul8dAkJbXWt7WUK3atoNCPz/2IWLXg
 S3XMs5IJ3LoKkQXKCdA==
X-Authority-Analysis: v=2.4 cv=MJpQXsZl c=1 sm=1 tr=0 ts=6a92fa06 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=bN2RZfqcuyHWyQBaeeoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 bulkscore=10 adultscore=0
 impostorscore=10 spamscore=0 suspectscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608290133

On 8/16/26 7:11 AM, Barry Song wrote:
> Hi Tal,
> 
> Thanks very much for the patch. I’m just a bit confused that
> folio_end_dropbehind() only requires in_task(), and nothing more.
> 
> void folio_end_dropbehind(struct folio *folio)
> {
>          if (!folio_test_dropbehind(folio))
>                  return;
> 
>          /*
>           * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
>           * but can happen if normal writeback just happens to find dirty folios
>           * that were created as part of uncached writeback, and that writeback
>           * would otherwise not need non-IRQ handling. Just skip the
>           * invalidation in that case.
>           */
>          if (in_task() && folio_trylock(folio)) {
>                  filemap_end_dropbehind(folio);
>                  folio_unlock(folio);
>          }
> }
> 
> But we’re applying a much stricter check with bio_in_atomic():
> 
> +static inline bool bio_in_atomic(void)
> +{
> +     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +           return true;
> +     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +           return true;
> +      return !preemptible();
> +}
> 
> I feel like something may be missing either in
> folio_end_dropbehind() itself or somewhere in the
> filesystem/block-device path.
> 
> Do you know why they don’t match each other?
> 
> Best Regards
> Barry
> 

Hi Barry,

Apologies for the delay.

As far as I can tell, the in_task() in folio_end_dropbehind() wasn't meant
to be a generic test for if it's safe to sleep, but rather filtered out the
known unsafe case of buffer_head writeback completing from IRQ context.
In contrast, the bio_in_atomic() check needs to be stricter since the bi_end_io()
callbacks could sleep or the callers could be holding locks, RCU, etc.

I see there's some more discussion about this at [1], but I suspect there are
other instances that are (incorrectly) using in_task() as a proxy for being able
to sleep (like f2fs_read_end_io(), but I haven't looked too closely at it).

Additionally, it probably only makes sense to use bio_in_atomic() when there's
some deferral path, since with CONFIG_PREEMPT_COUNT=n, it'll always return true.

Thanks,
Tal

[1]: https://lore.kernel.org/linux-fsdevel/20260829121335.3491374-1-qwjhust@gmail.com/T/

