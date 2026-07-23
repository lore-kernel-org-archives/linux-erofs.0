Return-Path: <linux-erofs+bounces-3994-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AA6C531D4
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 14:46:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5YqQ1MNrz2yh4;
	Fri, 24 Jul 2026 00:46:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784818018;
	cv=none; b=Ncw4k+D7hL5pziCnLD4VhhZQhAbMmRk1qA75Gu7vJd7h+uUYe1NReCilkuObjzh0Vl7sTxrQ7GkPEilqLXG3M5GmwhHcupxM+s5E1vAQ6ffsN9B97sSsSVg7uHQRURaf67UucMyrX6TUDh3Z+NjlFAFtsvong5MPmsNQk1indgaX7G8hat4917eCnlLczRwobhh9e7SIBTj1txuedEnGj2qzCFd/nEbO9MsLAdfTn5FGhXyqLnF29OCWZHv9ywoRa0JBADj5TribhBfXMFJ03v4aeQUBDDv22xwWNaQJTPTpC3+gPDEGGZvroPqk83ildWaQcP0Lb8rnFhJ2G6ohyg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784818018; c=relaxed/relaxed;
	bh=04rJgth8C2nU396fmhBsL9Df5jNE4GqWoAm1aGz1NtY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=GWztN8YqkW6uGaYBHTPWEsKQUvP119llQEFUqR8Ol0z2PmceQ+L3D7wdq317ZGQCRt4+rWFV4+sq869s1RetYPFYs/zr9ltxA4gigREyU+NBAZPzSTkjamJMrRnUPGLjg3aWYdVjLxo5eDYV+ygXBqyqyjnygMi0rN0JiZ2XBBjQXZAfgfzlmqvpZBzAdkrZJtzCSV0Ta9SRwQF2ssHJdAgDM/3fh8fZE+LxhCbVUqBIT6b5aFHdtRTlsUHdXhYOkEXRfup304AhHgf5Ja9SorqZnay93Rbk6MTmbuQ7uutttpvvtQcFG/dneLXzv1NYivTRC6bLNz7r4ITKuKRhIw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFac4XbW; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFac4XbW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5YqP3WPCz2ygK
	for <linux-erofs@lists.ozlabs.org>; Fri, 24 Jul 2026 00:46:57 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E983543A90;
	Thu, 23 Jul 2026 14:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653EF1F000E9;
	Thu, 23 Jul 2026 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784818013;
	bh=04rJgth8C2nU396fmhBsL9Df5jNE4GqWoAm1aGz1NtY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=QFac4XbW5BKnsGW0VCewkPEY/8Pk4UmgqpR4wknbIWl5FvQTLvc4eQn8izREcKJSd
	 lkklQTQrbyQskcRZiqZ9PFBZjA7aVqpsgW9dlDDoo7SCYz3GQTuUXgO1hjbUbYf4cl
	 Fyq8m6SUHTesS5dEiMaw4Bs+LD0k2RruNNQAThWRYsIwHkqKGfa+oMNw280oHyD+RT
	 bCUh6UTNMKIF1fwxvYmhVFPbz/O7MnT5mwNxZN8p/UJ1Q3Dp0EPFfHbTimvr/efE40
	 5Q/x6Igrd57fwNMbCTNNK1/M9BR80J0skXfSn6/Wl2Baw0BQukfjHiAYokr7baMtMo
	 /1f+IA1R0FoBw==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] erofs: accept source file descriptor via fsconfig
From: Christian Brauner <brauner@kernel.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org, 
 cyphar@cyphar.com, linux-fsdevel@vger.kernel.org
In-Reply-To: <6d1ac697-d5f8-4952-ba68-27610f17bf3c@linux.alibaba.com>
References: <20260717134147.1602735-1-gscrivan@redhat.com>
 <20260722-notnagel-allemal-kampfsport-8fd4e4d98a15@brauner>
 <6d1ac697-d5f8-4952-ba68-27610f17bf3c@linux.alibaba.com>
Date: Thu, 23 Jul 2026 16:46:29 +0200
Message-Id: <20260723-wickeln-schindel-rotstift-d987d4e9c036@brauner>
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1524; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LDQpyaLboE5OxsAw5Npt9mA3NF0xevJpMGml9LKT8aM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlacY0zjCbcrjj7duUbCZHhfXiK2Lz0w7vmD5Z6NtWe
 Z0OZS6XjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn8LWb4n5GhGvGAgX3Ky659
 nFHnuaOrpUpCNxzqYWec2c8+9327EiPDkqdB6mk911ccuHJEMab26PcggcJVLcqCf9hmewedi63
 kAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> I'm not quite sure if I catched the point, I think Giuseppe's patch here
> tried to record `file` into `sbi->dif0.file` (which indicates the primary
> "device" later.)
> 
> And if `sbi->dif0.file` is set up by erofs_fc_parse_source(),
> erofs_fc_get_tree() will just use `sbi->dif0.file` instead of
> `fc->source` according to this patch.

Oh, so you only do it for file-backed mounts. Do you only allow regular
files or do you also support block devices with
CONFIG_EROFS_FS_BACKED_BY_FILE?

Do you document the expected behavior for the file you're consuming?
Meaning, are concurrent modifications supported and what type of
behavior does this exhibit?

> The reason why `fc->source` is set was discussed in the
> thread of the previous version suggested by Aleksa.
> 
> > 
> > If they close it before this means you can mount something completely
> > different. The other thing is even if they keep the fd open someone
> > could just rename the damn thing and fc->source ends up pointing
> > somwhere completely different. The could switch namespaces as well in
> > some circumstances and then it points again into wherever.
> > 
> > I've played with that fd idea before. The only way to make this work
> > correctly is if you plumb this down into get_tree_nodev()
> 
> fc->source in this case has no use in erofs_fc_get_tree() (`fc->source`
> is just used for mountinfo for example), `sbi->dif0.file` works instead
> I hope I don't misunderstand something.

No, I misunderstood this.


