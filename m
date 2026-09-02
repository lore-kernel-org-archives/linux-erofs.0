Return-Path: <linux-erofs+bounces-4415-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621A2C61DFD
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 08:11:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZb6c2DZJz2xBK;
	Wed, 02 Sep 2026 18:11:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788336712;
	cv=none; b=RMXvxGg6moZWsIGKlZXJez+GpbJlb/I59An20Ut/uSM/NyJbSfArSX44woS+DjZ1cHVdf/V79Xlb4MH050zbBJ7YsKDMEM7N9ZsrdHSwMsXJfphSBJZXsmOT2lbCJjGGNer5Q7D9OO3spnqTnV+ZtWCnSTo7SiVc66b4glZthMkT1/7NmJOK09rJtptDy/4iajpeMv1vMPo16F9khevQIGUZPyYQGzhxwxj38D1ab2NCYSysDMWQf01xjZey0xqtbfqNA9qHITF3n7nBEMK356B4pKuxEaEWwCbFDCvXY1p6SraFSPk0K6bnmhNwgmx4OkL0B37vhUUswTlNc/XAOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788336712; c=relaxed/relaxed;
	bh=IEFE3cVUs1TS9YehlDLf9ufdHltZ63WUC/AW3noEJ0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SduaMx4NfGvfsV4Qv9FRvz2obERsG5jXaP8tkdDc98onVRQH3RJ3R3PiyC5EiHk6DYRYfst4fCEv0uz70dNKMIRI2HBIsY2mX8btDjJnRtSc+/y89mNVqMe//BBe1TpQjf3nldLTg63WjKBTPrJYwvPNLfBSfMtSUl7lPlzA6CXRHJfBkNoZ6FIAg1glmJcfhskTA43zK5wF6YVy3X/tPVQ95rx2UkUs3+5LBlHBzku6gJbO06mF8fYsvYO+9uAn9Q4cuXO9usvoKZuvob813VZ+0E0XqZBsJhEFpK45Aoc3GCfcB7aYMUNQFvIcVej7y2TNOu3xPDpbSgRyXFG5GQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sFS/X/kS; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52d; helo=mail-pg1-x52d.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sFS/X/kS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52d; helo=mail-pg1-x52d.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZb6b0cjPz2x9g
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 18:11:50 +1000 (AEST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so620345a12.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 01:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788336707; x=1788941507; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEFE3cVUs1TS9YehlDLf9ufdHltZ63WUC/AW3noEJ0M=;
        b=sFS/X/kSUcFlTBeuaAinOt//r+1ZZHfSqpSqwbp/AfBi2KpeE6ZUwksjWCnvRT7/d9
         fKxMXXwlFwzizIDu08mTc9jkMrsT3hRlmOXgpEQreM+SnrTPbedipiul6AU7Ex4B/P/P
         TLrto37Jn7akfCGF+xyQ9arGENriL25/rqKl0P4kQCn0FUH9oW8lvCcmlkfqPAjeuIV1
         x2cGNRJP12nyZOvhNKCp954exYigzsdmyyMxRfkwnSXvqFq2uP9krNy3qKhBvok+vetP
         bas3zhWcu7j9sz7gEsPYH3Z3VdfT4lntd7xYtmoOqS/OXyQ2HiNZxy3Ps+TKGWZm9S57
         FeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788336707; x=1788941507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IEFE3cVUs1TS9YehlDLf9ufdHltZ63WUC/AW3noEJ0M=;
        b=QlssiZB6Ss7Q/6D2eMdzXj3Gw0rXBUSgANOwgVuspigddzv6Dkxh/xOBOqyy7WMXhv
         o7MagrOxtrq92HHr5hPHEIRDGDSaB5A4W+aIS0v6fWpE8zgWvY8gh7QxKCChJv+Nn6Ew
         6lPPdttVUmKRali6aGiiP1FMAtr7OMxrQPcB7DMMro9HmTkhQ33eu3j+nCzvUTf/nAHh
         xIhrNhXOvJXX5H8pF3SVEjtfRHvdFjI5ZlRz07hXZNjPIfofo0dd18Z0bqRUjfjYchrL
         Wp7vpQIGgP7wBx2gDJG/tlBNv/2qB7pJ+03jRdSGCNsgIqIEBmMMAbHXZO3k1zBRlfqI
         Gn7Q==
X-Gm-Message-State: AFuF++nbNT8UxYRc10SsVrYNxwdurlovsxRd8R9Bc8e/rSV6gMc72NpA
	RHe9Zl/BmVCsOQiduWqh2wKi7eskvI0S9wW6TjFbumtmFJiQim+Fk6kL
X-Gm-Gg: AYBFou1on4gNm00fbeAvG6yymWfju6IA0SWvKzTJAvk6j7Q/3QDjk5Sc1q4wM5hQPKZ
	BLBYqmtcvorDaGcmueWZc9S55ZJsO526lSk++QeGsDgnE/qGI5NMq0AwtLUmKYln2qdq37GN8kv
	jxmgqTwoO6kbn9Up7HpGtydh0O5+le2uIh67eKj3d56AMYt85Dke26Ew/E+XKD8XWf+LKVnnnEv
	KHwlNkiiIoz1SIO1y9gPnI4LS3Ex64A60oWTFrYC2saWWgez0adL2QQXdgD98ZbeIo8l/8cj/H9
	L5iteUusMzxV/wLp+M6/rXmM+1bcjW+HIcks9XVB339BmnYqK1JHwxBFWfeCMMoeY2gcHPvcXyF
	lSD6OyVx5akmcgTICZiYR+V3127V3E3+GfeC0XhNeAw7zxYIZlToqy/Cu9bs27MCtw8Er0Kft+0
	LAmnxRjvDqum0hE/thRM2XInTwmKJ/QEUg9SPcF4mfEaVDzYjLDBsixtyaXcD6awzzBjXg0BoP
X-Received: by 2002:a17:90b:390e:b0:398:9be9:ab8e with SMTP id 98e67ed59e1d1-39aee124474mr3354227a91.19.1788336707041;
        Wed, 02 Sep 2026 01:11:47 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd21e9dsm10536625a91.4.2026.09.02.01.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 01:11:46 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 5/5] erofs-utils: mkfs: enable `--blobdev` for flat inode layouts
Date: Wed,  2 Sep 2026 16:11:41 +0800
Message-ID: <20260902081141.3309090-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902025031.50499-5-xiang@kernel.org>
References: <20260902025031.50499-1-xiang@kernel.org>
 <20260902025031.50499-5-xiang@kernel.org>
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
Content-Transfer-Encoding: quoted-printable

Hi Xiang,=0D
=0D
--blobdev without --chunksize works here, and fsck.erofs --extract returns=
=0D
the tree byte for byte.=0D
=0D
Two things in erofs_allocate_inode_bh_data().=0D
=0D
The bmgr initializer is dead, since the chain below covers all three signs=
=0D
of device_id, and for device_id > 0 it picks the metazone.=0D
=0D
The new message prints the sentinel when the metazone is the unavailable=0D
one.  mkfs.erofs --incremental --MZ over an image built with --MZ:=0D
=0D
  e1959e9  cannot allocate data in the metazone when unavailable for ...=0D
  0badea0  cannot allocate data in unavailable device -1 for ...=0D
=0D
Both refuse it, so nothing changed there, but "device -1" no longer tells=0D
the user which target was meant.=0D
=0D
Thanks,=0D
Zhan Xusheng=0D

