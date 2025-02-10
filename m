Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15272C0219B
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Feb 2025 03:09:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YrqKz2h06z30NN
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Feb 2025 14:09:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1739156949;
	cv=none; b=KDtZE615y1X5Qg1YTmDoKwNSnNm368IIt9bp6PvjubI7zoPzfIuYObsXUfiaQAy1NDC9p9cHtyITwyjfPaAk3VDuUxWPPkSZKoBOGbfHS7yhZW+UuXVbp7euds6HtTV/wjqhPqnRlsrEQpCJREgcq9mym+CB3p2TsUnDpSzxuZf7At/CU7Iim/oj9ZVfAa9Vm1MjkdwokEoD96w2UtQTv4rHDhf0zkHbpDyXJtFjvAiDx1mbo3cxFrkn9f5qwjxih1zYcGL/33cGFwnbs/VzVxx43mrI5uGDquWHY2WOUByTGWC2tlEM2vNjvDr+QV0VaEpIXBIKb0UweGB0Zo17sg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1739156949; c=relaxed/relaxed;
	bh=GlDmWRmDfCk5qOpOzmFL/UKVQM1SCrFasK3lRIDCg1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRUIKF3U0ge5la24KDcst9B35yaGXQfN0HwS6qDmpsvsXVQFCiu9tJ+aPrldKnOjk92uZ/i1k1PAgV4E7hErHm+il1baA3PC4CsUa9AlJ58NixA/ZTofKuk90VZTR9P2t8pJ86KgZstT/hKqCOu0z0xsXJyyyjtr6yd+/FTT83efQB3WZOXGkIe9EIuK5ep8oPqBohb8lFruvK8I2evIUUiCisSeaYYjspSl+J0wNUa8FoUZKXAHoQqxc6dQnkxq6NrK9d6r2mOn8zxQsf+f7hv2sdfjh6sC+FPyr49q5gwrCx+ITupUdjuvMSVAPdVh4orfSXr5/Mm5BXkkmkkJxw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Lrqg81++; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Lrqg81++;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YrqKv5CK7z2xGH
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Feb 2025 14:09:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739156942; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GlDmWRmDfCk5qOpOzmFL/UKVQM1SCrFasK3lRIDCg1I=;
	b=Lrqg81++52Nc2zQW8LhqDIb1negj2RF/DZHFZTOJqcHbDPCpLbs9mfWAJ84/Lrf+jAhbutxpIVWHb9LKklO3wnj3FgbC5ICBpmomXEBMf2kcPHcACxWGQOB52gCC641KQyLgR51hDzP6QVQ3IQNKBG2rlBhn4zFJ7Iy1DCp7fqU=
Received: from 30.121.8.2(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WP4ieac_1739156934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Feb 2025 11:09:01 +0800
Message-ID: <1cbdb820-22e6-4cef-8f60-60799e674499@linux.alibaba.com>
Date: Mon, 10 Feb 2025 11:08:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] erofs: use Z_EROFS_LCLUSTER_TYPE_MAX to simplify
 switches
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20250207085056.2502010-1-hongzhen@linux.alibaba.com>
 <29c5e464-4a11-42f4-b303-279c4b642471@linux.alibaba.com>
 <5c55806f-56b2-4e00-8b88-ac97e5733b57@linux.alibaba.com>
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
In-Reply-To: <5c55806f-56b2-4e00-8b88-ac97e5733b57@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


On 2025/2/10 10:59, Gao Xiang wrote:
>
>
> On 2025/2/7 17:14, Gao Xiang wrote:
>>
>>
>> On 2025/2/7 16:50, Hongzhen Luo wrote:
>>> There's no need to enumerate each type. No logic changes.
>>>
>>> Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
>>> ---> v3: Code cleanup, remove logically inequivalent changes.
>>> v2: 
>>> https://lore.kernel.org/all/20250207080829.2405528-1-hongzhen@linux.alibaba.com/
>>> v1: 
>>> https://lore.kernel.org/all/20250207064135.2249529-1-hongzhen@linux.alibaba.com/
>>> ---
>>>   fs/erofs/zmap.c | 60 
>>> +++++++++++++++++++------------------------------
>>>   1 file changed, 23 insertions(+), 37 deletions(-)
>>>
>>> diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
>>> index 689437e99a5a..7dba1573498b 100644
>>> --- a/fs/erofs/zmap.c
>>> +++ b/fs/erofs/zmap.c
>>> @@ -265,23 +265,20 @@ static int z_erofs_extent_lookback(struct 
>>> z_erofs_maprecorder *m,
>>>           if (err)
>>>               return err;
>>> -        switch (m->type) {
>>> -        case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
>>> +        if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
>>> +            erofs_err(sb, "unknown type %u @ lcn %lu of nid %llu",
>>> +                  m->type, lcn, vi->nid);
>>> +            DBG_BUGON(1);
>>> +            return -EOPNOTSUPP;
>>> +        } else if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
>>>               lookback_distance = m->delta[0];
>>>               if (!lookback_distance)
>>>                   goto err_bogus;'
>>
>> Maybe just kill `goto err_bogus;` too, like:
>>                          if (!lookback_distance) {
>>                                  erofs_err(sb, "bogus lookback 
>> distance %u @ lcn %lu of nid %llu",
>>                                            lookback_distance, m->lcn, 
>> vi->nid);
>>                                  DBG_BUGON(1);
>>                                  return -EFSCORRUPTED;
>>                          }
>>
>> Otherwise it looks good to me.
>
> Sorry, I was wrong.  I was missing the part of the end of
> function, how about the following diff?
>
> diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
> index 7dba1573498b..d278ebd60281 100644
> --- a/fs/erofs/zmap.c
> +++ b/fs/erofs/zmap.c
> @@ -273,7 +273,7 @@ static int z_erofs_extent_lookback(struct 
> z_erofs_maprecorder *m,
>                 } else if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
>                         lookback_distance = m->delta[0];
>                         if (!lookback_distance)
> -                               goto err_bogus;
> +                               break;
>                         continue;
>                 } else {
>                         m->headtype = m->type;
> @@ -281,7 +281,6 @@ static int z_erofs_extent_lookback(struct 
> z_erofs_maprecorder *m,
>                         return 0;
>                 }
>         }
> -err_bogus:
>         erofs_err(sb, "bogus lookback distance %u @ lcn %lu of nid %llu",
>                   lookback_distance, m->lcn, vi->nid);
>         DBG_BUGON(1);
>
> Thanks,
> Gao Xiang

Sure, I will send an updated version later.

Thanks,
Hongzhen Luo

