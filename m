Return-Path: <linux-erofs+bounces-4262-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88936C5DF87
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 12:37:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQjcv0tbvz2xT6;
	Thu, 20 Aug 2026 22:37:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787229439;
	cv=none; b=EQaxyW3C27ozDl8eMqrU745HJTViGd+GSu+RowQCUTJB06y5HeBeBflt9MH48U7mOJISLExJthFN32v++jbN/o8lP+RoCJDpWuDb895qqcuRcuqICdU3wkDPblsE9CBp+kjuuZZJ+iWhf8YhLlIUhSAPZcOBulXNEF1aFF+yG81/3C0URofr/ErHr3P5mGHJgM4eWE6fRwQGGE6Dl7e086i+KItKAGjyNOIg1PpH4ieROK8f+2DipwJnA35Ni2cOWaJb3z41Ee47+3nBP/F+l3TtxkJpujQFflWoSr6CqHjkmOf52nkLOJb6bUJxTCC3eHbzJ5f/gB6G15EnP39Wnw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787229439; c=relaxed/relaxed;
	bh=t/+PHaJA4ed08R9FWti0sClu0mYtklXQnNLIgN0wwZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+RU3kxWM6NA0Agz2BoQuzFdNUfFNpv/PomZlaNeGKm3uVVbh+/pQRsCaofeS3Qad7UFxzGWvD9P1eFjyZXzq8nmQk3wE8bE5nYE+LJZ8t0zgN0SPTwMUi1/KavIfKAqiPVJvJKbsTtP+qyBQt968UWrKQjqmVRH86xMycvhDpu6hRtYLJl2rsgitgdLqmUC7gw93zDgzdQDzy8BtDvdhv+fHHPYmLj7Cnx886lYdRM/kiZCtuh0xGB2jv4Qw5IUDJVh84Q6vt9L2UI9R4KS7t7XncNdvtFhK/j6c13r2S4axJvn3Lp4bRm7F0sxkkZmFPiekA2jYKS73lzIKg61Jg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=S1Ab/9Py; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42f; helo=mail-pf1-x42f.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=S1Ab/9Py;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42f; helo=mail-pf1-x42f.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQjcs0Fmhz2xRx
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 22:37:15 +1000 (AEST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-84a2c90e383so604367b3a.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 05:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787229433; x=1787834233; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t/+PHaJA4ed08R9FWti0sClu0mYtklXQnNLIgN0wwZ8=;
        b=S1Ab/9PyEuGmKkooYnei+APg0khkFGTeX63EK/i5qpsAPne+DZAKH+1x/y+9m0Ttp7
         gMbM7eIv6FvWeS8pOB7lwFlsVUCrvBQBEGkTh88B4EJZI/d/D+VXNmpsz4DjjfXBYnZr
         j8NfI1f6Jx8xOngQHDI8aZjDT1iZXB9tFwEsMR81vcaDmpGceVtCvxPHr31Dx6H6puVU
         GU9Sqxhulv+f0begdjaXs3XMmHLvVTavI0MpuwtV1ipAj7s4Z3VkZQ9+DOk216ajXd2K
         qr9nyet53KjSafhyZ9cq/L9DwHuDngmLPIkbRhm/YhT8dbwOO4o6TqTuAGKwAzZw3Jfx
         w/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787229433; x=1787834233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t/+PHaJA4ed08R9FWti0sClu0mYtklXQnNLIgN0wwZ8=;
        b=FNHt9e7LTgYiqySbGGvtCCXE0GMpgd5svEJlyUTp+HNFpinn94E2YCXdjgMiR/X/fG
         drONUeByC3xOXRmQ1aK/5iFU7frW70y8BLIwxPilsw2lJ4aXbgxujRe35KXnog+x09nf
         S29hLMlsg9KGVphUKNZTxuroV6u1wYeCph24q/ZhE+J5A7u5mbXCEbSCKLl7fgsz/TA0
         GGtKgmLvrCCs5OmIgVT/eeLAuYP+2axKaKrZdcRZ34zRCTnE+lscJ72PGCqZZdOk+hCZ
         9iAyBrBAFxzT79qsWk8R2EjJ5+sal8ZVGOYefoo85AWP6ectWDclqS2/eVsrrDl12m/R
         2IRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrCQZSvUEAt9gZ6+447eWtDKsLHhcNwwMCkYobdw3dncK0+3JL65A/HpN07s2L7v5H9ULvJEWKzLxIIuA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwvBzYwJAXpP897HGRlLQFbojz+kOH52VdQMm56K0ubuRDV6Uxj
	sypjsslcXxWcM6lEArjsww4juHl1jVNitkI21KdCoOcA0OlX82Q6E6xO
X-Gm-Gg: AR+sD10VVaOUboV5Ics6/F8QTiQoOGL3Y/GmkYKBQ8qPC8wFdVV8rZDoEvT+3RYFXlk
	29dvhxrc3HexlSHT5OoBTohm1BQ3/TTOFh9dUOgZrUgslMDoSTEq36iLzp1WeKJquYwZYncytN7
	05qPyEfgyrl6iKfEq8eoHYzkhDdzA80J3UeWfNxjjznWFyiuJr7Qne91qRw4BckEJwMIXH4E460
	CHYDVaic2Li9pqfB9Sl2ipAzYjaAfuiTjNQt8fh5Y3H/CEbe4iWYaRoPWo47lcd+JJfd6eXQ4iM
	E8OVnA7IHfzA4/W7RegwarqgncF9b4Me6bY4bgFCOzCr6uO/7DIux2+5dZE+D4yq11ra8IytwWs
	NbXbSJzySZKyr0pMiD1QSW+9XRlampWNp4T2SpZSFtQ/k0P7VCHxgs/KDo7FozHroTmST4uor69
	+0V3g8aprix69UXs4/J69K+V7jOtVdWhKmN09gORLpJf7k+c1uIF1oV75sGnQBVKctE3es+GNf
X-Received: by 2002:a05:6a00:808:b0:84e:354:422b with SMTP id d2e1a72fcca58-851df8c97eamr6426584b3a.2.1787229432534;
        Thu, 20 Aug 2026 05:37:12 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d366dc9fsm1656065b3a.51.2026.08.20.05.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 05:37:11 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Jingbo Xu <jefflexu@linux.alibaba.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: use the shared page cache for splice in inode_share mode
Date: Thu, 20 Aug 2026 20:37:04 +0800
Message-ID: <20260820123705.1748738-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3d735f18-2d26-4b4c-be68-b000742e9826@linux.alibaba.com>
References: <20260820064441.1083470-1-zhanxusheng@xiaomi.com> <3d735f18-2d26-4b4c-be68-b000742e9826@linux.alibaba.com>
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

On Thu, 20 Aug 2026 17:53:20 +0800, Jingbo Xu wrote:
> Please refer to backing_file_splice_read() called from
> ovl_splice_read(), file_accessed() needs to be called on the original
> file (just as what .read_iter() i.e. filemap_read() does), and the input
> @ppos needs to be updated accordingly.

Taking the file_accessed() one, thanks.  filemap_splice_read() calls it at
mm/filemap.c:3155 on whatever file it was handed, so on the backing file,
whereas backing_file_splice_read() ends in ctx->accessed(iocb->ki_filp),
which for ovl_splice_read() is the original.  v2 adds file_accessed(in).

@ppos looks already handled to me.  filemap_splice_read() takes a loff_t *
and advances it itself, at mm/filemap.c:3144; its internal kiocb is seeded
from *ppos at 3083 and 3098, not the other way round.  ovl_splice_read()
has to copy iocb.ki_pos back because backing_file_splice_read() takes a
struct kiocb and hands &iocb->ki_pos to vfs_splice_read().  Say if I have
that wrong.

One you may want for read_iter too: it clones the kiocb onto the backing
file, so filemap_read() marks that one accessed rather than the user's
file, which is the shape splice_read had.  Neither is observable today,
since erofs_fc_fill_super() sets SB_RDONLY | SB_NOATIME and the backing
file is opened O_NOATIME, so both reach a no-op.  That is why I left
read_iter alone here.

Thanks,
Zhan Xusheng

