Return-Path: <linux-erofs+bounces-4716-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196D3CC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:31:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3fxn2bK3z30VQ;
	Tue, 13 Oct 2026 14:31:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::531" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862269;
	cv=pass; b=g9mCzwJ9xvylffVh9ztSi138jARL44lfofGWIqhRJ79qFJV4p3YdDuX6iiNZ0gzO2Bw2hhONN8s6tIWzGYMD1erBdM1WjsMp/iu3hx4ac6T3P5BPtP4A9UR3BkS7Bnqrw6Aysu6C9MOutBFGCcYgeLbDvsBs0tNEQStypdJfG1ENhPrdEVaPFo90cGjqfILiilBEfos7hRiEVvJYV2ryyfYs5/pfu1Lqny1fdu5TziWq5BIIqepGudxA5Pz5Jc08xOC2cuKZYB07Hv2Xr/yO8unQxH4cECYAJRxF0IQlRbKe4ZI8y4oIlsUcCiUumFgWLlTCN9mqUgTWW+QN0xtz8A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862269; c=relaxed/relaxed;
	bh=ixp0gwcDzT/gOTcIFY6ZgU5UUL8+seL2a4GqUvvZO4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oi7WcLn8bKSFEYNtiGPuBHWFHIEN3Rsf3aRQ+mJXqzK+KwYDI6dhTWXJBKfR22ZAsfJ85imVfBsViqT8kHK8o+FfkL3xHdXcLu2+ULkI3/PhMb6DuvG2yxW6tvp1BVShT43WMEWQrj/K3AYbHXwMgsU2kdov9DFH+mLCjCtX9TKp5jI9vubRE8X/V6DcfhB6WK7URr6otuXpF82xd38a7mi+uFdYOx32bedOFwC+BCZ4YlIRdgBIInhSiYXMOOtBJh20KKlK9ksnIQVoZt8McKwTJSLK0Zo/m7VGm9Iebm10vZopqF3Ee7YIAJkeSui3Mf4Q9DoSS3JlQGT3xyBCtA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ZZUoY2Sk; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::531; helo=mail-pg1-x531.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ZZUoY2Sk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::531; helo=mail-pg1-x531.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3fxm3znKz30Tf
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:31:08 +1100 (AEDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so2111927a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862265; cv=none;
        d=google.com; s=arc-20260327;
        b=Hf58oGqOzg05Qsn+XDD1hrZnOymJjwo7PzK+vCC50iXHVMdTz3svKp1/i5cyDsuO4c
         ta/nO4r+HGXo+szQppR2d5CdiToRX1m2NShX6OXqWakiL/G+eeza+ftwYbazK1NdaB7S
         5QEO06km1wTZL9/N1wae4Z1EWJajaNGLPsqbbAblCFUxGj/isu4hz3xXlsVd/E1zZFIY
         N+9+fAFsmar3EFJzgRX35FVk6no1fUP1GKjLeH7A74F9tqCA/xRazomMxK+LO9PInci0
         BHs+ZXa8Snio7uoZlHong7fcyi1Ebfgi3Qsoi2Yi/jo/atUmNU2vv55PGMZuiTOjR4k5
         mpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ixp0gwcDzT/gOTcIFY6ZgU5UUL8+seL2a4GqUvvZO4o=;
        fh=Jf+s+gzFNyiODck4SdVAYsw6Fy/W6+g/ctumXuZv+G0=;
        b=m9n+2pTi9k8HR2p7A66yrVj3bmUwL8JnCUEKEMh4khsr+efyiq+AOygCIfK+ITbZzM
         m2HiXv4x5jCciefpaAvwYMZmE2I1XV7h5Algj1jXTPgEcGWivj/pr/XFrw6I/qaE7qOS
         uDPzDZyXNkiXm2I/za6CaHRvsvPvKz5+40KtCwXkrY6TU9fWZSST0IHshrkLmsYV7ikv
         VG37LeJ+XtBlsxcNi/KGmu68o0gqLlfZQ5ttoqBMIAcwrVZttfRvgDxpUY6yUXJNwmR+
         vCsUMpqd6X5M0U43p/FJqtkhq+SMZL7ihltV/ol8ZGBZpV+D4LKx//dGW39SLXc8jEtK
         fuSg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862265; x=1792467065; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixp0gwcDzT/gOTcIFY6ZgU5UUL8+seL2a4GqUvvZO4o=;
        b=ZZUoY2SkcvGb/HPyJca3sI6iIgGf1Cci/+gvQspk6sQH6GAXs1PYw1nI/OkxvSnS4P
         lDomApfJwd8tq50R82hvfTfXCjwp/fLYzdTSMNpEVltD7td6KfKRUmIDWpW26f24tmyi
         ydh6W4bzDcckZJIKSGxwDsaQ1bdOq0Wk4T2BQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862265; x=1792467065;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ixp0gwcDzT/gOTcIFY6ZgU5UUL8+seL2a4GqUvvZO4o=;
        b=PSWLcuS9D7SPjNx6jg/xHeWeobAB71jYZZqBY/EvoLBFF5kNNcU4bN1xZOo9A318uj
         pYWRxrIZQEFaz6WmZ1ybcgulc1jE93keFAbUsf17nThzgb4rZ6IrIyxfwnslNgzI/Ohv
         Qtg+fBl3ELzUNgx6JxUG9ajfhcwgmfyUBxl31wUo9CUUYHxnm6rUTxz5X9dUaCtb7JNO
         VdqqNx57PJ58mBnW6SF2yK0c8cZhR9/oB6TOLoLTHNYIU8ksGMmu/tykEkNT/FC/pdfs
         wDWO1wE79/1gPneCIMYiRUjZ0TpO1PlwF5edzaTdmFnDz2Xbl0ZF7ZVjnQM8d0C5mpDn
         jGgA==
X-Forwarded-Encrypted: i=1; AKwUvBzHTVdSjWJ9KuPu0jkvO3e/de925Xv7i7jqf/ZokRCQsu6LGMYUzZZpn7SXk6jvVa27fM3Bs7rZuPQnuw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLMs0dMwGtd/+lTdM7ltEgjntRhzubdESauj6nCebhOtKM8lQId
	0mjil6c7QNhiVk3nL3EQ6RdHQAOhMYzmDPcaoU+zYPzVlGJ/umUEiJ5KhVVVNp22K/McIoFdRLK
	faOYs83NBR2sNL3jdKRd0mtUVFMaEixnS7x8IchDK
X-Gm-Gg: AYBFou1umcpX+SN8ED9rFZCo8QU3Zoeakf4XRNfAUabP0ma6IMvcHB73SALa//Yc+To
	Buy6nSJujAvxHRqTmJCNNt0JXXP8WQVTJ3M04HYcchNG+C1U7t3+KLMINTEOdWCsoQ4lUf+kZOk
	h89IO7yWg/x+oW/KRTwaZH+7fT+Kz6GFrDI4NAtOXsWQS2l3xYQ9wzoMcEwaVIKujDAljhVamvm
	PHSnuw1RvqmLz2cd308Av35odjMQQG/GYDq6HvgQ2r/kDWPYJy83njYhYU0p0xCAesTj5weLosD
	vEoK96LAKoW8sqYbgl5KwnEOdCoFwm7UnQ9nJ6sczub1uHhPFYJJcLIe3tBzXygArII=
X-Received: by 2002:a17:90b:3c0f:b0:3ab:b764:8256 with SMTP id
 98e67ed59e1d1-3abb7649df1mr4024600a91.17.1791862265444; Mon, 12 Oct 2026
 20:31:05 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-5-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-5-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:30:48 +0100
X-Gm-Features: AclHuK8WwdCSGkCMdXjk0bM2LSgGqGD0emanwMKwWErheekLFkiCYylny6MMJE0
Message-ID: <CAFLszTj=uzZkXLhO0Ox1UqnAfF9DOoLc6F13+MjLg5CKNreErA@mail.gmail.com>
Subject: Re: [PATCH 4/9] fs: ext4: don't read time fields in XPL
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Daniel Munic <v-dmunic@microsoft.com>, 
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>, 
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com, 
	Aristo Chen <aristo.chen@canonical.com>, u-boot@lists.u-boot-project.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi Heinrich,

On 2026-10-12T14:00:39, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
> fs: ext4: don't read time fields in XPL
>
> The ext4 readdir implementation populates dent time fields in XML
> builds though that information is never used.

Typo: 'XML' should be 'xPL'. Please can you also give the motivation?
Presumably it is the code-size saving in SPL. Do you have a figure?

> Guard the three rtc_to_tm() calls with !IS_ENABLED(CONFIG_XPL_BUILD),
> consistent with the FAT driver.

The patch also adds le32_to_cpu() to each of the three fields. That
fixes a real bug on big-endian hosts, since the struct ext2_inode
members are __le32. Please can you mention it here, or put it in its
own patch? It is currently hidden behind the subject.

>
> Guard the three rtc_to_tm() calls with !IS_ENABLED(CONFIG_XPL_BUILD),
> consistent with the FAT driver.
>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> fs/ext4/ext4fs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

> diff --git a/fs/ext4/ext4fs.c b/fs/ext4/ext4fs.c
> @@ -319,9 +319,11 @@ int ext4fs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **dentp)
> +             rtc_to_tm(le32_to_cpu(fdiro.inode.ctime), &dent->create_time);

Your next patch points out that i_ctime is the inode change time, not
the creation time, yet here it is copied into create_time. Since you
are touching this line, should create_time be left zeroed, or filled
from i_crtime when the inode is large enough? What do you think?

> dirs->fpos += le16_to_cpu(dirent.direntlen);
>       dent->size = fdiro.inode.size;

BTW, the line below has the same endianness problem: 'size' is __le32
and is used without le32_to_cpu(). It also ignores size_high, so files
of 4GB or more show the wrong size in ls. Not for this patch, but it
may be worth a follow-up.

Regards,
Simon

