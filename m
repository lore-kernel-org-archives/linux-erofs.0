Return-Path: <linux-erofs+bounces-4414-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F903C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 07:14:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZYr93zkkz2xyl;
	Wed, 02 Sep 2026 17:14:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::629"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788333257;
	cv=none; b=nkvs/zzn31AEqdJy0AG8l262XMaUuaxKB3qiiNfQ/37N791BGMBpji1WiHhiaHHJmdX0R3ui42EceXoFnyeOe13sKb6HQALXn0xR6RoGbao+Sj7yOki4RPp4ab9zuLxJthjCJHaaWDEeFtcMZjq3o+mfwAYjiHZDyA1gz9v3F9gI9jTLHq65M6//FT0MdsSR7+zTvTm9ZSGBwF6f9YNGIp2hxExeJvZbeeldKE27ofyxSEjdNhpP7QLWMiphY4t8navTLZe6rZ/6cW6Ni+AOrQpUi69IBynnRscAy27oPOFSK2kA8P0niE4z81ppzYnEak+oc28J+4GMq35+eUMpWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788333257; c=relaxed/relaxed;
	bh=zLkm9t3GiAl0UKpPjANo6QjYOY3p+XrKIXRSm9/HYTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLUsh2Do968hnoChc6VA8WvDS/Q2Aqsjha0dykcYFbcCFe0HBniAE/whgIsMdF7pl/ENRXM8FH4eYfh9swppWbLlBNWYa27ZHZWIxKDwOmNomdRL67NHK2Re1zIBkJo9UZJYTQL8siWS1d5JJLyk4HZr79a3dVa9wqT2u2AW8FH/amGKX3NSU0C3VC9ql4Ld3sAJzV6TKz1OfPn9XsaIO9y/RajauE6Vxk2a/32ewYwT5uMfsoZfOuwQxS5hPc+P8nDkK24vF8LXjqYPG0EfeH18qAiztcq7TlLMY8tgO3eCRd9XdD7oAN4n6u8VoS3x8Tn5hSTHcXl/tKCp+h1lyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mo/w5WMH; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mo/w5WMH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZYr82z01z2xpn
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 17:14:15 +1000 (AEST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so6122365ad.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 00:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788333253; x=1788938053; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zLkm9t3GiAl0UKpPjANo6QjYOY3p+XrKIXRSm9/HYTs=;
        b=mo/w5WMHEknKcGnwXu2TJVYTxzkrEn0rCVXO5+8CI7o/4Ns22+wrBukFAPlMYkvi9B
         36PYpPcKSHc4REIrA+oqhPKJn6KjjNHEHSEcO8dxIjiigPTk09WTbsBGdzgFKS39WIIz
         GSA7cZ0ZsQjtmKyyPpZvLjD535ZTakGb+YSXWGsQq1X3PUIxNK7a+uh95ODu0zdeb3a1
         Kibf3NKEcsRWUkrcqpvDAj6LDogofLqAeKxU5Wx5AgcqR5ttb/lYLsGGIvkv2UCSXYdT
         W/3OL3JJgHSe5btFMTqZEtp4SVyh+xngS6DgcnSDuDtiZ8l3gnoXM72WSHWEL5lluFlS
         1uIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788333253; x=1788938053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zLkm9t3GiAl0UKpPjANo6QjYOY3p+XrKIXRSm9/HYTs=;
        b=WVlUXjFFczGHx5pYag6/Jar19j1KBZ1ymSKO5vlnzkc/Vd2wdZqyPVLaMPhNa8QfNk
         n8YGGHLQajOl+9Ap/sb+EPiUez5ehEQgT1LfYIwB84luNxqJEgUej62Qxc5NWnfAZsdT
         mYLIbLgtXpXeYqwzrdaPO1uJrp08DBQI4cR+nBqtpHnFYhjQcfAbL7hSt8JQekadJoIx
         7DMm8Wxazbvlio7ckM5UwwAAah7ttGPyBbZ/AmynAyks+rTKEbSoHA45EysKBZXrIQLL
         SPkyl6+tauEdEGCG/QT4FELfSEjt3s5SDgp6aGtQFbxdTmKScGJnZlF3QHVsUGHcDc/2
         V/Zg==
X-Gm-Message-State: AFuF++kpfhUcipA5ajerntz1J3FS3IT9W3ORBr1m2aCo2dbnFqSoWexv
	bReGo9OIzjxmLEryGYYVIgclwqjvHqtukKskt3SDjOAcCyrK623aVdqO
X-Gm-Gg: AYBFou2bwS4k7PdRwMZlIWeB8A8jIgFsDFxxTCv+9C6H9JBlmY+UGYnk2XfdMIajhF0
	muawXXgtEPCiW3NseYDYNYekQ0fQNmobmzGA/d5y0y1rfUEuE5YyUwptcH9jrQWqvzpUq/9Pm5I
	K77G1+rMHfMyPP9+gh4YIMEZIQO0lm94VVFM0I/oUiKIBGaHSVpzpmLJd2KHpA8if6aABLYMHFM
	NTGaGourrto+45WfZTRfEf4vxtfveTPa2BnlwvMKl4x9n+ajrMG5c4Ebi3hlXbaCU88iwNrKn08
	ZXJR43hkD1hW+8g8YSH3+LeFQyPRsvWcbQ5TyRcJlhqj7nkCXuGQpcTsJ7bT/R4sIcg+9x0LJhL
	shFqQY3EplKoirn4WXwePKFsFto0+IEAw+Mnrb3UAg/xsFVX4CNtM0aC9aYURUF3Pmjxmo8WmsB
	o35tJzdve3fpOeiRhu65cVNXL2HuHMnW6fM28BAtFRWc15CKdPlOoJ0D3pdwpqAi0yZktPgh9h
X-Received: by 2002:a17:902:ccd2:b0:2d8:d4ce:7e3a with SMTP id d9443c01a7336-2daec6e9924mr40021195ad.15.1788333252684;
        Wed, 02 Sep 2026 00:14:12 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd382116sm8417575ad.26.2026.09.02.00.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:14:12 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 3/5] erofs-utils: lib: migrate `c_chunkbits` and `c_blobdev_path`
Date: Wed,  2 Sep 2026 15:14:06 +0800
Message-ID: <20260902071406.3292294-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902025031.50499-3-xiang@kernel.org>
References: <20260902025031.50499-1-xiang@kernel.org>
 <20260902025031.50499-3-xiang@kernel.org>
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
On Wed, Sep 02, 2026 at 10:50:28AM +0800, Gao Xiang wrote:=0D
> +	importer_params.chunkszbits_def =3D mkfscfg.chunkbits;=0D
>  	err =3D erofs_importer_init(&importer);=0D
=0D
This snapshot is taken eight lines above the dedupe fallback that assigns=0D
mkfscfg.chunkbits =3D g_sbi.blkszbits, so the fallback no longer reaches=0D
erofs_write_unencoded_file() and the "Turn on chunk-based data=0D
deduplication instead" message stops being true.  erofs_blob_init() and=0D
the condition above it still read mkfscfg.chunkbits, so the blob side is=0D
set up for chunks while no inode gets one.=0D
=0D
Eight identical 256 KiB files, no -z so that available_compr_algs is 0:=0D
=0D
  mkfs.erofs -Ededupe img dedsrc=0D
=0D
  b96836c (2/5)   266240 bytes, datalayout 4=0D
  3dde13e (3/5)  2101248 bytes, datalayout 0=0D
=0D
Moving the assignment below that block gives 266240 again.=0D
chunkszbits_def has a single reader and erofs_importer_init() does not=0D
look at it.=0D
=0D
Thanks,=0D
Zhan Xusheng=0D

