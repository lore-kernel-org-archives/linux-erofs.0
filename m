Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D52A606A339
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LaWkj3Km
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQthG1F0Wz3bh4;
	Fri, 13 Nov 2026 21:26:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:31::b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794565566;
	cv=none; b=TXPpnDpaIlaE3AFJV2fTbzJJHjs6Djp7sz7kGyB7wiwDmaLvvy27NUgZaOpXUf852lkYHDEK8EhZOeaVuTeZLYl5TkQPiYaBkgEa27+Npcr97v+znmkmaoFlYqk35/lvbFw6wyEAfOF4BS1itI0ge6/BPCGuGC1lCg9fsXzNdopqwfKPGLhol/5LTzUe2/UFKygcZiwJ14JoMgGrET9xTOu0UDVupNHpIKuKJV49by+WhjGsA+JV9cnlOXxB8Q3QkcfWaLZnrfPyPOkZythDK/PCbGlWT8LDYqksSL/H0CX9o4FQ5B9R/L/i+xRCEqeajMU5ENYVRtsz1BBF7y4mZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794565566; c=relaxed/relaxed;
	bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cd259fxFg9HmGbhjA9AVxznq8iKB0OMHvoUGWGqyX/YbYXfsWnr3QBGE2IwcinXcTOH/bXAbrxyezsVKM05T38P+NAi5oXicyuu8juMJ3dIAsBWlfRloEydBRIkJ0A8IDqxLhdKnxdRZS2oGlyQM0LQeBSKTgovWwX44XVLL0+WyovDTjrWU1RxXsHciaibO0ShNJMTyniA+DPzPl550MBVAqTXOMy+I8dbcDQTCU9Yu7OlQmUQMXqD4du4O6I4MHVXSV8/Zxejzt89l9P2waLVUGFGiJZBlcZmbFafQdLfGKwilPnux2hOv8UVXm+NTYmVbW4wX15RLYhXq3A6efA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LaWkj3Km; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:31::b; helo=mail-wm2-x0b.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LaWkj3Km;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:31::b; helo=mail-wm2-x0b.google.com; envelope-from=alex@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm2-x0b.google.com (mail-wm2-x0b.google.com [IPv6:2a00:1450:4864:31::b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQthD4vPZz3bfR
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 21:26:03 +1100 (AEDT)
Received: by mail-wm2-x0b.google.com with SMTP id 5b1f17b1804b1-49ff9833fedso1224135e9.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 02:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565560; x=1795170360; darn=lists.ozlabs.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=LaWkj3KmWZM4XIl2PkwQaWNN7s9XA6W67kS522hruf/6h8Og/ESDEeAi6ONR2IIKB3
         h3LSBl2Yuk0FAfl0RaIxRdMpmym/VdRbSHxlWf+jK8qXi8qfzQUnVJsstVLlzroMXcNO
         3bDlNiPEAR8DN+sPgvjohZHmtL06NfhxAcpJYC+X44GjYsjM6qNvnuJGuOrkt9oj8REH
         kSe+bwTcSGf36xECsIVKcWqou/wqZU+PmiRyFhAfMfumWw0UR/mwQKwNLquNSLclHRDm
         1sZ2K6KgypK7sMwJv/8VoU7WU1Y4BYQ7sNNrLbYPFkoWRcSfGIo5GbRSjvOgaUioDIWT
         VTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565560; x=1795170360;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=LbOxoixn78auhun2DMGXUrYPQK+zgDp2jlxTXxihxkFTnySpi/5BIJERNzro7Io2US
         8/BbqpaST/RoJ0YWp7FNiitA/EhtTnFYpfVT1KwapfW/4Gpj+0GjBVnIa44WjReJx0/0
         JsgHY79LI9swA75DjClGzc4H0EfO3YojagYtDEAXcnJOYlcljQXMd95YjrEImklyzGQt
         XuaAKgznnHemwk5H3WV5+OrgY0tWPGke132mNFE9KtGDUApVCBJRQRzVOnZ9lSM/5NIf
         PUInVg5vpLH/9hY8Lx5FJDNvkPzaQcbPuw65sHK45CehtBgrO3QF4iHSXgQvLRkAxAHG
         cU5w==
X-Forwarded-Encrypted: i=1; AL+hErGKHXjXREXIqeeLrvrLF/OYpCqEXnSnSDUdeIah+yHYzIPKjN2hlvF1R3yQKP2YeXIc6Npehbn1adsKqQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8JAMVPC9ey06/7EujO5YfSHJFtzEerNoEVURrWLH3iTTZnmOcy
	ci/z6ds0cQQdE59OLIyUjQlJbx0yeCwDK4HKe1v4SlT3mBn1aoBjIbnS1g7cE11p+81I
X-Gm-Gg: AYBFou0rOSCoMmdAs5EHOpeEhoxjNMddLH4Jd1BcvBdG8EluyxMgIBp2AEcy+9JlDsu
	S3qr5dSUB6g2JIB5dGmkUY+Aq2glqUv+ZleDRTR/Som9zJCXPo4f2Tu9VoKYoEIVWtWhkTxGvPK
	gBWXcshZp2ci8F/GeX1j4hdRft1e6Req9EXjAdtkHyiY9tgXsYdjtQg6NCGW4b9hvmTHJ/bWoyr
	Gc81OD5O7NiPvhlPpu83+HkATbGwepQrE8Qce8p9EeeDiH7xQ9hioQi+rpnY8lsA1RlCuhf+C61
	4ggyiRH4xCQjlT375tC+PVE9s8ZnKU6r6J40JlBgtvpWIG+oBu40eauFtDA75sZUkSL6VIIOvE8
	HC6SGyajUTB8ZoYcFQ/HvXk1hE0furFGxVEDl192JcDNiwNYEr8bIz1qMlHido1cbBLMtBiU8eM
	ZuV3dwe978XSnpkOn1NyeKKGPpxZSBLSOGEKONj+evV0695XkjDNgqHqNqCwwkLMTNUNBd+IJ5M
	v3j3Hn0KUCEqd6/y6BCwn5WL/6cpg/T/mfNuQ/qur0mmqhVJ4SiTHSNTDc8/T+7aY+SI287q9ya
	d9xtmljt2lBBxsYkruzlLy0Mb+ezVzIX1AMOpf/LT3x2OJSOr5VgL2FiwDEB3kY=
X-Received: by 2002:a05:600c:4e49:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4bb55aa999dmr38995625e9.33.1794565560090;
        Fri, 13 Nov 2026 02:26:00 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm244439965e9.1.2026.11.13.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:25:59 -0800 (PST)
Message-ID: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, Chris Mason
	 <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:25:57 +0100
In-Reply-To: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
	 <20261111151202.GA11391@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christoph,

On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> I've seen setups where people use fuse to mediate access to sysfs
> sysfs in odd ways.=C2=A0 No idea if that's still around, but if so, this
> patch will break it.


Oh, that's painful. Do they use backing files for that?
It's a relatively new feature in FUSE...

Kind regards,
Alex

