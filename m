Return-Path: <linux-erofs+bounces-4255-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19CAC5DF85
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 03:11:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQT3h6vQdz2yhY;
	Thu, 20 Aug 2026 13:11:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1031"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787195472;
	cv=none; b=l/n5NxbxhitKfM6pBmcRfrzVc7guVud26BK0ItZjtz+NpvBOB9CT+QTxiFgSBwxjQWGDnCuFw9KZxT3TMqzqomsew6PB/Peo+bHxKX3boCLP3iWJgBdDHYLhZUTXPja0jEzdX3lCqGlp1QZasjPumFFOEluKr2Mh82hnNdpkFZP4pX2/YXkxl5Wr92/CrzixllynlMR/Bo8GcaT2Hwd3hVji46BT5cJkXxTsjStH45bYdOlh+ZEshADY+GUL4WWNYtIjthBv84KpoYpLxfXoCiaVjod10WOuAFVjzqkUqwrOh8snyJZGifHNKDnkLppYz/iMbrD0A1mpn3d/TMfcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787195472; c=relaxed/relaxed;
	bh=LsQFRjNiJYCD/Hb5maV9dtGODC4Q60m2oS5/S3Jp00Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bih//SWptnKoZn8FAW2Tlo2y84dsZSJxl+1kY1hjj1la0xPe+NsAUvCVPUuIwK8rFcgsAsnpCM1LJ48it293yR+TCSA0OP0EH8uPS9j6H3tIepaEoMvoGg+akK+zNPhIhuxyacVQNJOv9E+4oaghlH4K7RcFP2cECHpy8+UJAFgq+YpHJmdyxuV06Ml6TuLjYBne/uY2Kw63/d3SPQexbC0czOfGJRkpxRg1UxXm1lXPZZtKhcz8YKpE12WBJ8Qk7iBqm8sxKzg20GjCdLKPXeWgiMcC6zEH+wHH4Yf1rXv/wc+DEV9l8k2KWlT63WVBd28DlX0khdxVhD40yBwDQA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZMs83Cnq; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1031; helo=mail-pj1-x1031.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZMs83Cnq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1031; helo=mail-pj1-x1031.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQT3g57Svz2ySm
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 13:11:10 +1000 (AEST)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so2148348a91.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 19 Aug 2026 20:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787195468; x=1787800268; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LsQFRjNiJYCD/Hb5maV9dtGODC4Q60m2oS5/S3Jp00Q=;
        b=ZMs83CnqCmTohwf2oqHTunI8Mxv+DcowAdsjCcYITAcJZhRJPjxwDj7NIq0EbrMLHn
         w84pTOMzWT3v0kKucB9HrPmsvRRBVy6D3Tuk9hSCTz/5c4ANUOHaFbZKbTIeKGzLYopj
         K73Va+VtLIwx7xfFgpa/mMjI4KbeKba5KFOpgjGyaPFXmhDEpTUfZET3QS6h5UspZLgo
         Gu38PdRRVGFLU6kKqnR3ThyOBS3yWRgGCT01RXXsL85lL2BGyCqFPXyTvxEO4FrOgZaX
         zx7M0V630jg2vfN3EcxTV9F6IedQDzlcg2ENIP2vKzzVRQeXGuipvdrHnDADqqSQQVi/
         y4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787195468; x=1787800268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LsQFRjNiJYCD/Hb5maV9dtGODC4Q60m2oS5/S3Jp00Q=;
        b=jtL8M9cbuLsxpzMJBzEdvTCSVECugNTf6EISxUqeVy3kJ9cvdXNiqAbusiOv6bP001
         GF0LiJ1KKvZWfN5obWypRq4G9bVn/VHpOEFdvTaeLKvdLuNUZr82o78E6sdv6ycv4NnM
         umVE/BY8WUvHhrGR6ansI3RYTbiF4QRmlirbp055RVJlz78k2AqrAGQ9zOasFg+iSAec
         IB5WtpYQbzla0B4dB9NqVjM4Himx5xNA13eOJCBQ59uZ3TltkoesmXSP8Vu3ZHIjrJ2v
         h8lUTrpuE4NLURP1rz+c47UeZCZv8ov8GvC6BP28FbU5dR1grtGmszeEx4+fvpxTyGJI
         5Dnw==
X-Forwarded-Encrypted: i=1; AHgh+RqokREMRok8nnZKHoLojNg3A9iw4kGbFGY9feK9l7UbW+BLnomiSyhqMtI7C3lxFZMX20F4k43iI1vVjg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++ms52/9eI2AiocdMDiAAJr4zhZ5jjhQS9usLRP3QeVda0U6QAl6
	doNRGxKyqPvPp2Nr14eXXc113IT95A5Ux6leYF/8On5riJMCDogFNzvX
X-Gm-Gg: AR+sD13El/rJnroj4Lm5RXLUY8qGc6iEfKYH/txAq1xHeXsZLOXh61eThB22hCDwGmf
	Nigv0RWKtpT2VNU/kGCzFs91kTcLmZPEfRt7KVZ7KrIIr6+RneAbA0Mhf/zUl3VAR5PmskivMKZ
	zdXjRZGE2xNxpJ9epI0Y7hr8QWD5AgV2xqmtTYpJxcN4KzCneV+v37PDUs+d9blbvW+86ACs9W5
	o9BLJEFFkW0l/ITHYu+rM4NPJY668oQItyFx8mSdRxtNxSp3q6Czhk+gkblyUq59KDmlyK//cjp
	MGFDcPqPVqxyJJgp9Wj/6OqB62Fi8v5aIkGFihTYltrEQi3tm1j4ak9Ya9Bn101PY/BWqI/B5aO
	yHz0J7UJBfjyUAI6LOnepEVYNjG4/DOpB4hZfXKGunvoU6MEHvsmFt+gBbbQrRZ7zAU3GVULgxc
	byeNiRQsdNvz7AK3Q890SNaPqn0i7sM4m2p59Y99lDtcRf49SpwLJP90tVVqvzqFi9rPRGAfi/
X-Received: by 2002:a17:90b:4a4b:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-3958054b82bmr15871490a91.0.1787195467778;
        Wed, 19 Aug 2026 20:11:07 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm5562328a91.2.2026.08.19.20.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 20:11:07 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Jingbo Xu <jefflexu@linux.alibaba.com>,
	xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
Date: Thu, 20 Aug 2026 11:10:59 +0800
Message-ID: <20260820031100.1038753-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818113713.116849-1-jefflexu@linux.alibaba.com>
References: <20260818113713.116849-1-jefflexu@linux.alibaba.com>
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
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 19:37:13 +0800, Jingbo Xu wrote:
> - .llseek   = generic_file_llseek,
> + .llseek   = erofs_file_llseek,

No objection to the change.  While in that table, .splice_read is the entry
left that touches the page cache without going through ->private_data:

  .read_iter   kiocb_clone() onto private_data, then filemap_read()
  .mmap        vma_set_file(vma, realfile)
  .fadvise     vfs_fadvise(file->private_data, ...)
  .splice_read filemap_splice_read

filemap_splice_read() does init_sync_kiocb(&iocb, in), and
filemap_get_pages() then takes iocb->ki_filp->f_mapping (mm/filemap.c:2686),
so it works on the user file's mapping, which after your patch is confirmed
to be the real inode's.  erofs_fill_inode() sets that mapping's a_ops
unconditionally, so the data splice() and sendfile() return is correct, but
they populate the per-file page cache from disk rather than the shared one
read() and mmap() use, caching the same content twice.

Thanks,
Zhan Xusheng

