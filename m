Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29823C4332F
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Nov 2022 12:19:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4N9pJz4j4kz3cJF
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Nov 2022 23:19:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1668428371;
	bh=IggqRsG6zyyiJTsuHTvPfu+aryWmvQ8Thb531wDkz4U=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=j/X/KFAmz9BifyV9gTZOXxLdrlzOX2rA8YWvNEGk0xn05lhly1yjxRaxWG0/Lsiag
	 GjTJ1ggNLG4+1gA/9UNqM8CIhIWkgZ66Vn8YwiLEL5xFZzyUTdxrECHmBtaRmqwyKL
	 +2fWN63Aht4H66jLWd9uND1TjobNX7SXLKcgq1LbsX7vfdcU5eUo+niR3Bgzvux3CD
	 OBEUuEy4yntGtLxYdOZ66AEXrE3eOX/Htn5yDiFHP8EXc4jIHVe8J4Xn8B9xobdkdx
	 4Dy2lVq9+g6qfe8CIHyBFZ16qZNNAvE8YBc/hKfz/w9NVQiV9pc1vL4JplVHVQdnof
	 yIq+F55F8kMBg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=siddh.me (client-ip=103.117.158.50; helo=sender-of-o50.zoho.in; envelope-from=code@siddh.me; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; secure) header.d=siddh.me header.i=code@siddh.me header.a=rsa-sha256 header.s=zmail header.b=JPHUw5BK;
	dkim-atps=neutral
X-Greylist: delayed 906 seconds by postgrey-1.36 at boromir; Mon, 14 Nov 2022 23:19:23 AEDT
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4N9pJq3Ttkz2yYj
	for <linux-erofs@lists.ozlabs.org>; Mon, 14 Nov 2022 23:19:23 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; t=1668427448; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=ZRzORh6m8nEovh7z5LC9xoKhnIYR2azpervtA+NTZV0P0nNZh7GDcun/d8lEJ5dKKUvlJOV0juJkvf64ZDm2QmtEBe9D+wyi3xwfqoARpgojzTNxCroQklWyjC98A6YUe85aK45FM/dR8dXq22FKXTj5dHcS3jYjdw2VZRiBMDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1668427448; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
	bh=IggqRsG6zyyiJTsuHTvPfu+aryWmvQ8Thb531wDkz4U=; 
	b=cjE7oDUZx0sspDXdnM0tglLm97e4Yn4ueJQ1AFaM0KfOke1ao0TZabJosM+BupogR2DiVjOp35fGiw2KER0k6hD6NVw0jhhis6I5V85iCqRoTtxxdhsINbnGOJonbwjfM+LrByHGppbMRXU0Mo0ao5W4jOluz0Tc4VkSwly+Wwg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=siddh.me;
	spf=pass  smtp.mailfrom=code@siddh.me;
	dmarc=pass header.from=<code@siddh.me>
Received: from kampyooter.. (110.226.30.173 [110.226.30.173]) by mx.zoho.in
	with SMTPS id 1668427447485815.8405388936613; Mon, 14 Nov 2022 17:34:07 +0530 (IST)
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20221114120349.472418-1-code@siddh.me>
Subject: [RFC PATCH] erofs/zmap.c: Bail out when no further region remains
Date: Mon, 14 Nov 2022 17:33:49 +0530
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
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
From: Siddh Raman Pant via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Siddh Raman Pant <code@siddh.me>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs <linux-erofs@lists.ozlabs.org>, linux-kernel <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The following calculation of iomap->length on line 798 in
z_erofs_iomap_begin_report() can yield 0:
=09if (iomap->offset >=3D inode->i_size)
=09=09iomap->length =3D length + map.m_la - offset;

This triggers a WARN_ON in iomap_iter_done() (see line 34 of
fs/iomap/iter.c).

Hence, return error when this scenario is encountered.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This was reported as a crash by syzbot under an issue about
warning encountered in iomap_iter_done(), but unrelated to
erofs. Hence, not adding issue hash in Reported-by line.

C reproducer: https://syzkaller.appspot.com/text?tag=3DReproC&x=3D1037a6b28=
80000
Kernel config: https://syzkaller.appspot.com/text?tag=3DKernelConfig&x=3De2=
021a61197ebe02
Dashboard link: https://syzkaller.appspot.com/bug?extid=3Da8e049cd3abd34293=
6b6

Reported-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
 fs/erofs/zmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 0bb66927e3d0..bad852983eb9 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -796,6 +796,9 @@ static int z_erofs_iomap_begin_report(struct inode *ino=
de, loff_t offset,
 =09=09 */
 =09=09if (iomap->offset >=3D inode->i_size)
 =09=09=09iomap->length =3D length + map.m_la - offset;
+
+=09=09if (iomap->length =3D=3D 0)
+=09=09=09return -EINVAL;
 =09}
 =09iomap->flags =3D 0;
 =09return 0;
--=20
2.35.1


