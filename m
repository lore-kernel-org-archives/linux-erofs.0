Return-Path: <linux-erofs+bounces-3083-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D7CFF4923
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 01:43:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fkYt11yvQz2xly;
	Mon, 30 Mar 2026 12:43:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774834985;
	cv=none; b=ksJ/En4RCvpCU+UN71gShcZdmakBFXNRI/yJv3NlrOZtPizdSqmQWE7J8YF9gx3qUHpqbe0TWDKXTj8YbpPKQgf0EXtze3o2RJIEbTPTcZ8sR7Ukh8k2rMMmo4eGPkGeOk+j78SgowxsaY1YIG3o8ELhwAz/CuaO5MiQD3RbKD0gw4PjwTdoFuxObToJQm/RQ6FaOpO0ENvmlJypiwfa2mRkCtNqX/6n1ou9DtKC+q1i25AxYWAlIMH0xGVZ4VPBGbBk08Ez/D+1ZplnlSDoy9xyZ26mPuxeDQ/YEajJdwxC3qEP7WFedBIry3Gl5MGuRE3SwH+HSepQ0LQcQDSbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774834985; c=relaxed/relaxed;
	bh=h1jvKRVy/dYlXyLKi2q1q2tOEAh3A3BaoHxsyOiw9x8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itWFYz0eCzwjyVtg3o6/lOfnjnFYioxpJCTzXcmfXc4uBwKkE63XQZer3jSgZYAJoD6pnm+J5uLoQeRcxmNEQLYBP8UR1QfjVocvqPdFQOWwcoJxegg5E6AwBwVGcOsx3GdYqZNq4i/s1yeG+vOXfkzRP7/JJGpsRhwVq1ebwsMvG9K8ZDM5aQfXECxOswKdfZ41MOqGUp07ZaYwgrSQJwMwiy3ZcdElNag2dJk9IpNhhP0azmKTL++LxtwBCIqFx0C7BWMELVYEGdqzTLiclvkyiO5FeaZioHk0EV5niqHf4MJXhm57K/lEYKplbocyxyZW8A5+z46tjE8sT7NuZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mxBrLbTv; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mxBrLbTv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fkYsy1LGSz2xdV
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 12:43:00 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774834975; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=h1jvKRVy/dYlXyLKi2q1q2tOEAh3A3BaoHxsyOiw9x8=;
	b=mxBrLbTvDaIqWPH+0/pT9jxPwzOXPvTciCRu9Im7enL7gk8VPcLSFq7ocZLVMN0Z8cGiH5tBA4LUprm4vevHkiEjR7WC9cmor390obnSjrrPqMMI5LdXgkHA6IXr3a+L8snJyWC/7+Si3/UX3/ddEubZCYc5zJWs2HbHjZZkMCU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.toMlf_1774834974;
Received: from 30.221.131.246(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.toMlf_1774834974 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 09:42:54 +0800
Message-ID: <ff4b7e1c-2370-471c-b461-f66dcd28967b@linux.alibaba.com>
Date: Mon, 30 Mar 2026 09:42:53 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: switch ZSTD decompression to streaming
 API
To: Utkal Singh <singhutkal015@gmail.com>,
 Nithurshen <nithurshen.dev@gmail.com>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org
References: <20260323052257.11377-1-singhutkal015@gmail.com>
 <20260323111901.44548-1-nithurshen.dev@gmail.com>
 <CAGSu4WO+q_zwjp_c3Bbk6eGEDiEpjhHf-8BOiKLaW02mJwS5Jg@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAGSu4WO+q_zwjp_c3Bbk6eGEDiEpjhHf-8BOiKLaW02mJwS5Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/30 04:25, Utkal Singh wrote:
> Gentle ping on this — happy to revise if there are concerns
> about the approach or the streaming API choice.

Again, I prioritize all patches according to the impacts.

Thanks,
Gao Xiang

> 
> Regards,
> Utkal Singh
> 
> On Mon, 23 Mar 2026 at 16:49, Nithurshen <nithurshen.dev@gmail.com> wrote:
>>
>> Hi Xiang,
>>
>> Can I test and verify this patch?
>>
>> Thanks,
>> Nithurshen


