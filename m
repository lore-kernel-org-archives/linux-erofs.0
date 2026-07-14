Return-Path: <linux-erofs+bounces-3893-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3F9C44509
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2026 06:37:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gzqNF5F1Rz2xqn;
	Tue, 14 Jul 2026 16:37:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784011021;
	cv=none; b=U+2pa91FwjIKSAhekupSLWRqQy02gYs0cVeBozQHl059Hqu04PIduGnnWL9pBA7NsVuGeVu0vownC/RLQvPDcRNQfJq87Udp2uJz0y7F5qiKhJLE5Wbtlvm5rpoJ4oxDi6vQgtXr3LJKMmrd0oq26C5loKvleYWFyKBrn3B1H/0cJKlgKfkJ11aLS0/zGQpiF5MYsYuiJaWiCokZLID2C5CjtCWjbePKD8IWQIUl0IKKTo95tBeEu1pdv2/zAdIiQnoWz+olbxXq0AJRp5ik8KaRkYs8FchYkWFxgO9qXFncFhkto+ZjChoIqO5/I7YFcy2Z3fds1AT2N7ctZNno7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784011021; c=relaxed/relaxed;
	bh=7Rl9EBcDj5Rw07yZgsZcSBReQweTqcqI79roXrGYq+k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=b1u3YlMSEvZfgmi7Sf+dQASWoRVMAKNax4N0dC+lQGDICSrbpZsQKEXQuaMQ9oVZG2UOr2O5Or3/nhZUmn5Cf5s/rm/xGnQibg3T0wcx0s2ecZAogj+BNwMgeZgwCqwUxCfjjS8v0qXzppp3bv5wAcMvtb0dtLjj8OZYPzTYHKhIftCD7SkMASKeSwgEKt+WmcNxypEEBMM6p4HKr6Nox7GgVuVSxrQmBdDKVgXX7Pvksnm2vn2XRYyDMLWZgU3beepRrP325KFJHuU1TZR8hMC4oKyMgg4yDz2hVgnXk+7MOR9RspgWFvgo4c7g6pvi4UjE8ePlUG0/I9WhH36nEA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVl8CYEL; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVl8CYEL; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVl8CYEL;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVl8CYEL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gzqND4JlGz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Jul 2026 16:36:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784011014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Rl9EBcDj5Rw07yZgsZcSBReQweTqcqI79roXrGYq+k=;
	b=XVl8CYELL993KKoHqHUqmWRayh9rdrQeDKSCpiK7NsZjKyhYHwi1x+oVjytXvAyzcamcn4
	OWbwwOm3Isj8kZngjmjSNcncHY5yAiglFn3v3ym9bgUK9iYHLr0dRCBepbjiqNGqM3gtnB
	3JsLFChHYylMd3CLpaBcQQZWQFcnum0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784011014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Rl9EBcDj5Rw07yZgsZcSBReQweTqcqI79roXrGYq+k=;
	b=XVl8CYELL993KKoHqHUqmWRayh9rdrQeDKSCpiK7NsZjKyhYHwi1x+oVjytXvAyzcamcn4
	OWbwwOm3Isj8kZngjmjSNcncHY5yAiglFn3v3ym9bgUK9iYHLr0dRCBepbjiqNGqM3gtnB
	3JsLFChHYylMd3CLpaBcQQZWQFcnum0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-OmJJdam5Nn6tvayeIcVZ3w-1; Tue,
 14 Jul 2026 02:36:48 -0400
X-MC-Unique: OmJJdam5Nn6tvayeIcVZ3w-1
X-Mimecast-MFC-AGG-ID: OmJJdam5Nn6tvayeIcVZ3w_1784011007
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 035C31800366;
	Tue, 14 Jul 2026 06:36:47 +0000 (UTC)
Received: from localhost (unknown [10.44.32.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 227AC1800676;
	Tue, 14 Jul 2026 06:36:45 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>,  Christian Brauner
 <brauner@kernel.org>,  linux-erofs@lists.ozlabs.org,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] erofs: accept source file descriptor via fsconfig
In-Reply-To: <ba9cf493-45c8-45e8-9e21-9731ec492030@linux.alibaba.com> (Gao
	Xiang's message of "Tue, 14 Jul 2026 09:56:57 +0800")
References: <20260711071137.4130824-1-gscrivan@redhat.com>
	<2026-07-13-dandy-better-exposure-wager-9hBmfv@cyphar.com>
	<871pd748kh.fsf@redhat.com>
	<2026-07-13-chief-single-carnival-graders-7dI4ue@cyphar.com>
	<87wluz2nnc.fsf@redhat.com>
	<2026-07-14-drafty-folded-woes-volumes-Z93P4V@cyphar.com>
	<ba9cf493-45c8-45e8-9e21-9731ec492030@linux.alibaba.com>
Date: Tue, 14 Jul 2026 08:36:44 +0200
Message-ID: <87pl0q2i2r.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Gy61w-sSHVnLnyTMw1t-BaxlW_iyi0ms2AuPUX4tbsI_1784011007
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Gao Xiang <hsiangkao@linux.alibaba.com> writes:

> On 2026/7/14 08:49, Aleksa Sarai wrote:
>> On 2026-07-13, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>>> thanks for the hints.
>>>
>>> I'll prepare a v3 if you are fine with the version below:
>> No worries, and this seems more reasonable at a first glance.
>> 
>>> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
>>> index 86fa5c6a0c70..72c85cc53085 100644
>>> --- a/fs/erofs/super.c
>>> +++ b/fs/erofs/super.c
>> ...
>>> @@ -437,6 +439,38 @@ static bool erofs_fc_set_dax_mode(struct fs_context *fc, unsigned int mode)
>>>   	return false;
>>>   }
>>>   +static int erofs_fc_parse_source(struct fs_context *fc,
>>> +				 struct fs_parameter *param)
>>> +{
>>> +	struct erofs_sb_info *sbi = fc->s_fs_info;
>>> +
>>> +	if (fc->source || sbi->dif0.file)
>>> +		return invalf(fc, "Multiple sources");
>>> +
>>> +	switch (param->type) {
>>> +	case fs_value_is_string:
>>> +		fc->source = param->string;
>>> +		param->string = NULL;
>>> +		return 0;
>>> +	case fs_value_is_file: {
>>> +		char *buf, *p;
>>> +
>>> +		sbi->dif0.file = get_file(param->file);
>> A very minor nit, but you can actually steal the file reference here
>> with
>> 		sbi->dif0.file = no_free_ptr(param->file);
>> A few other places do this. (You'll also need to change the
>> param->file
>> reference below.)
>> 
>>> +		buf = kmalloc(PATH_MAX, GFP_KERNEL);
>>> +		if (!buf)
>>> +			return -ENOMEM;
>>> +		p = file_path(param->file, buf, PATH_MAX);
>>> +		fc->source = kstrdup(IS_ERR(p) ? "(fd)" : p, GFP_KERNEL);
>> I think that /proc/self/fd/%d would be a more useful name for
>> debugging
>> if file_path() fails (not that it is really possible here AFAICS). But
>> I'm not really too fussed.
>
> Not quite sure if we should get in agreement with the format of this
> one in advance (IOWs, users use source_fd and how fc->source looks like;
> since other fses may follow the same practice if source_fd becomes common
> later) since it's a user-visible field and I believe we shouldn't treat
> this one as a dontcare field as some pseudo fses (since those fses don't
> rely on `fc->source` by design but typically EROFS can rely on.)
>
> I hope Christian and others could share move thought on this part too
> before I land this feature for the next cycle.

would it be better to just return the error from file_path without any
fallback?

Thanks,
Giuseppe


