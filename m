Return-Path: <linux-erofs+bounces-2390-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD677E9B269
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 14:22:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fL0L56blTz3cP3;
	Wed, 25 Feb 2026 01:22:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771942957;
	cv=none; b=cVFaMRLlpZoVBXFz5qjeD4Yj90FH9/qx9ITCh5ibJ7Jt3Nv35QFgXuI9wgUVvFJBLHSknkA4a99DvWZZ0OM+YO1BY0h6ZAQC+eq7hS9MXe4G+S86AMVtucOaFrGbFyul3Fg1W8ixL1oROvJWzui9gKV0pLtmYPUddytux8wwl9dMJ/YnBGop+TBAPXAKelV8Yp6kL63U5Q5WLkV0M3XYXi+TX93LDF6IztvIkFICoBMBsydOxFmfbu3DADe1a6Tr61V1iGqZCNt0ZFXGVhdcIAlgZrsLsbFAcDrWK8MeK12w+sJAumBgss/t/K5B1tVaUF1w/d+vosj0jczkC4lANA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771942957; c=relaxed/relaxed;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SMHh2JAlbHJv5tXv1HNp6/19665Tvt5zlHAYYK7/ZtSC2zAjzG0kvJ/Z52em85Qg/UO9A6ZkWzIl7QBIEM0DEVKoVNzeJpsgJm3deDMUl0stILiRla0F/y11tI4RcWcCvm1H8OKkK14TgZRANwZfG+PMNKfuCokkpS6cH2l8Ym9q1O/W4rDVykl5a8gKK+YiJ9Clt9xYswZvU2C0+d+p6bVUgWawx+UcDWu8kSklOzqHQxIGqb8k2N5jnzqVlYwx2YFKFxdh0hJ4NpfMjLUhrFwHV82/4CCgIW4CSBMZGF4Bm8IGR6SZA0zS7recSjZI1YoZ7ZNhuXEPrggEE93kXg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ncP4R96N; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ncP4R96N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fL0L32jjqz3cNY
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 01:22:33 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771942946; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	b=ncP4R96N6jSM2Si1PEttXnzH7+P+Ud0v5vcWynWDbogbr3uYWenuWLVg7B9rXs/o+jTp9oU352/hPEBwTBYsGSXMQGKwpc+p+B6ySj5gOywszGnXirqxlwJBEFfXh09OmiFCt6Gzm4xy3zs1adKKhmboUhQ5PgGB3oZAsbYEqW0=
Received: from 30.42.59.174(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzjgL7x_1771942942 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 22:22:22 +0800
Message-ID: <9fab8428-73f4-44b6-afd6-31271dcdd378@linux.alibaba.com>
Date: Tue, 24 Feb 2026 22:22:21 +0800
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
Subject: Re: [syzbot] [erofs?] KASAN: use-after-free Read in
 z_erofs_transform_plain (2)
To: syzbot <syzbot+d988dc155e740d76a331@syzkaller.appspotmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <699d5714.050a0220.cdd3c.03e7.GAE@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <699d5714.050a0220.cdd3c.03e7.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test

