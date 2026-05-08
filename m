Return-Path: <linux-erofs+bounces-3385-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4979CD3436
	for <linux-erofs@archiver.kernel.org>; Fri,  8 May 2026 08:39:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gBjGc18v2z2xdb;
	Fri, 08 May 2026 18:39:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778229576;
	cv=none; b=NImn9j0vL4W8dx69tdTZPCJGa8bMY6fxt5n5akHU6wqIq0cmQCifYUTHgGLzBl1/tkUX7aDEHLeDvz9fLmk9bD7FxJavO3RQMwPRuInzFwXhu7T0bkr6B0eNj21B2XtLLZqn475PMwx5JnGPfT04J2VCR6n3B5VXbqvnzcL56cmiP7ak7WaAg5SS/c6qryRQNqelZqqLVqwdRhiBUTwgUkPA+jtW19Ii7EFG9Tq2yKWUW6mToPYcgpvNBsjweJhQEM29OLDJZa820XFABXmplRF+e15lNLaqmDTtb2jPYyG5e9JRqCpLLv0pGV5XbeFVrcRM6AY4V8dpUyhtq67UDw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778229576; c=relaxed/relaxed;
	bh=9AJ8IZgkstBlyKEy++hhq2nD3+vl1iyXZTtJuFPuPFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iu+Uo46H7avKaALqWKGU9FDb7d5wtulLLsWwp923PU6XzWYOAhh44n6m3C4rhVCIKxRJuT8k/WdKJSfiRZTuopMWdwUw3rrS8DHJ2tcZodcqXoPMkNlbP4LV7eQ3erwmYnfpd0nLJ/tWpbch3F3k2Cv5wfWxJAlicJ7XyD4Io0JIMJO7fBHRh07LHxa3WdNqi0+b0eIfOrBVQx1sR8lZ4XFFPZcOpWGHYf1IyAn3oj2sAulvwB8X8MA3sUtC1SepS4esgsHqsiedMBESEE6izS3bFz0EEWtHsSRoO9A1JaTHp7YMp8n4660+rS4qtCydl4UOF3SatuNySZDRCILJyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aYw1rA5+; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aYw1rA5+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gBjGY3cHrz2xQC
	for <linux-erofs@lists.ozlabs.org>; Fri, 08 May 2026 18:39:31 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778229567; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9AJ8IZgkstBlyKEy++hhq2nD3+vl1iyXZTtJuFPuPFo=;
	b=aYw1rA5+aklMh1pyK0skHBQz25UIiBjbSwmQnggwaKlyc8ABBDc4TDVj5Kc4sLj3AL4zhmMn/sLrZZUIDmcj4LQ6rAwYDlKEqm6Ct1Hqy6iV0Oi1vEPFZJgMWyQhpXqxKc7HKjNQ5m8VM1y0//gsGnO1IHjen7R8cbX5U8C9WPc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X2Wy2S2_1778229556;
Received: from 30.69.177.140(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X2Wy2S2_1778229556 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 16:39:24 +0800
Message-ID: <188c33e2-331f-4362-8475-b8cea7a8fe7d@linux.alibaba.com>
Date: Fri, 8 May 2026 16:39:15 +0800
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
Subject: Re: [PATCH] erofs: use the opener's credential when verifing metadata
 accesses
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-erofs@lists.ozlabs.org, Chao Yu <chao@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, oliver.yang@linux.alibaba.com,
 Carlos Llamas <cmllamas@google.com>, Sandeep Dhavale <dhavale@google.com>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Tatsuyuki Ishi <ishitatsuyuki@google.com>
References: <20260505155615.2719500-1-hsiangkao@linux.alibaba.com>
 <af2c4X1YCB7NEb8p@infradead.org>
 <CABqzrSOaCMPD_QrSq_y_6bXLC3ecm3FZsE_ACrdNbTHG8baMCw@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CABqzrSOaCMPD_QrSq_y_6bXLC3ecm3FZsE_ACrdNbTHG8baMCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Christiph,

On 2026/5/8 16:24, Tatsuyuki Ishi wrote:
> On Fri, May 8, 2026 at 5:20 PM Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Tue, May 05, 2026 at 11:56:15PM +0800, Gao Xiang wrote:
>>> Similar to commit 905eeb2b7c33 ("erofs: impersonate the opener's
>>> credentials when accessing backing file"), rw_verify_area() needs
>>> the same too.
>>
>> Two things here:

Let me use Tatsuyuki's reply to address your two comments.

>>
>>   - rw_verify_area is a helper for use inside the VFS and file system
>>     read/write method implementation.  Erofs as a user of the VFS should
>>     not use it at all.

Currently EROFS file-backed mount metadata is directly using underlay
fs page cache, which is mainly used for composefs, etc. to avoid
different EROFS instances have their own EROFS page cache for the
same underlay backing file and avoid unnecessary copies into them.
--- That is also what composefs once did in their codebase.

Since EROFS just read the underlayfs page cache and does _not_
touch anything inside the underlay page cache itself, so I guess
it's fine?

On the other hand, we talked a bit commit f2fed441c69b ("loop:
stop using vfs_iter_{read,write} for buffered I/O") in another
private thread related to fanotify, which lacks proper
rw_verify_area() as well, since it called into raw read/write
iter methods instead of using the previous vfs_iter_{read,write}.

>>   - using the opener credentials when accessing the backing file seems
>>     wrong.  The entity accessing it is the file system, so it should
>>     have system or mounter credentials, not that of someone causing
>>     metadata / fs data access.  And this applies to all access by
>>     a file system backed by a backing file.
>>
> 
> I think there's probably some confusion of terminology here. buf->file is
> opened with the mounter's credentials, so we are impersonating the mounter
> here. Perhaps the commit message could describe that more clearly. Same for
> the previous patches mentioned.

Here "opener" means the mounter as Tatsuyuki mentioned, I just
follows Tatsuyuki's term, but it just means mounter credentials
indeed.

Thanks,
Gao Xiang

> 


