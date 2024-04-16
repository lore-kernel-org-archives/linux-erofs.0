Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0971DC4345F
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Apr 2024 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1713229126;
	bh=z5SK7S2VhEiXxhwEiJuw/hgNQSU9au6u6OsDRuqOGr0=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=cAawTelMWVrwLzzhlC//Z15XuY4H4dlArrb04OyUMTCWxjsjnzmPTveENmHC1RJKb
	 ufWGuV33vXNNhcw2usrfC65lL8vFTHynoX5G8VF9OBSBJE92eZA81OkRBxgZViJ/yN
	 ymwjXMtRwAvSSj+vccm9kgYM0QLlUj24kvwYiVJ2reKWHa0SSCBqHZ/9m+llXf3lq4
	 49h2y72nJHCeUHtdXCUqyZqYRA52C149N3K+WZYEaeP+NMvHOXM+tpHNpqX/gv7Nnf
	 lquI8ncofj6UsQwADsFWp0UvbIsvZ5Ayk9vrSjmFZvDEwX1BmJa/wkACb4kz+CkKPL
	 BU49M1Zn99yBA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VJQdy57Mxz3dTx
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Apr 2024 10:58:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=gmx.com header.i=hsiangkao@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=pjumrHDl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmx.com (client-ip=212.227.15.15; helo=mout.gmx.net; envelope-from=hsiangkao@gmx.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 314 seconds by postgrey-1.37 at boromir; Tue, 16 Apr 2024 10:58:36 AEST
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VJQdm53qcz2xPV
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Apr 2024 10:58:35 +1000 (AEST)
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from debian ([209.37.221.130]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mo6qv-1sY6fL3JAR-00papO; Tue, 16
 Apr 2024 02:53:05 +0200
Date: Tue, 16 Apr 2024 08:52:58 +0800
To: Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH v2] erofs-utils: dump: print filesystem blocksize
Message-ID: <Zh3L6o+LSrvMiVkx@debian>
Mail-Followup-To: Sandeep Dhavale <dhavale@google.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	hsiangkao@linux.alibaba.com, kernel-team@android.com
References: <20240415183538.2012717-1-dhavale@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240415183538.2012717-1-dhavale@google.com>
X-Provags-ID: V03:K1:Q/UhyJF1cNGP4ZOEnnFm7vPO5esySI61vw37ykhPpHd/HkutzbD
 o18ugYO+iLbkeJTD5UJ855e1x/CrTESAuBFEe5VIR7YRcCeSW2BS3VUOE6U9eOVkEIG54Ek
 ybCTIQFOiHFnn5XtHkJHdzMr5VoKC4tcsPlNGaFdx0Z26qIcrVqBXqccUlbQRZokN7P9Gh+
 76u1lcRn+eprhCCrJKv8Q==
UI-OutboundReport: notjunk:1;M01:P0:Th4L+N8iiOo=;0qLtV3ej8rK6EpS00p4cB35su26
 6S+FBu4A2x5VkUgVQvIcyHtPUSWDx0J3DJ3ngAIbXDIAsiuvUCay6gCj+DCwPfkG5kxpgY0fK
 MmXk2lexK95WVn0OJKKQ/5stDeiqu7gIu04LwqifIC/zjpVoVbsJMM5cbLLP35QmqsTUGDUv4
 3c6Ev5EG937flryjmsLeDgnKCotCqhLl94HGQJ9zQdLi5EUf3g9mgXcJ429Ba83PkY22Fevhm
 cDk+AHuKomA2Npdrs9Jg8fOopJDChKZjH8+Vw95uFUvGdi74R6qGxQCZ5vteJ79ltnQtS1s4r
 xxqHJH/MBQuoSyD2bFZMoRlyNJxbBywmp316Y0i2YuLx2A4Bp4iDlDq8CbP1yKCJE1NH3XGQX
 d81imE7jGqpcMNhcUe8ahK8aKidvKqJrhnVYenELQ1wCO6Jr9JuEaRB7aq6QOSzJ5pAIsL6p1
 aNhZegfMA+YcJrl/5OG/1zbhmX093fgrsVP0Hm3eSZBbF1aj/JZPQoTmlMH9krzQI/MjXzFkZ
 0bQZ7ZEkz0oU4x7cHDOavKO8/qe3+Ala+BMpwrI44Fg23fSOAZYmqqxFyb8BIg7diF5kc0NQh
 KGD2bpdqqlveuqG/RL8GULFLAPGMXQ3tSLStwYJYQbJ0yUIUxd1yL05VVNbiJpXYyLfdzRIKd
 EJdhvLjypA7JHSTDx/t5uzW0oBKLPnj67rSj9EuJzH2U9T3ktMbN7KkPWapscMz3ojseb1j0e
 1LFxnXAMWR//Rn77wyn/U2Dg9cBYpqFOlBEspuOa9vwrMoIU35KWZVM1xfuqWSJIzVUTHSX+2
 Yx9Ao6FFul1P/AN2a34Oblk0QHAqOTLl6hpvQ8vwRp51A=
Content-Transfer-Encoding: quoted-printable
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@gmx.com>
Cc: hsiangkao@linux.alibaba.com, kernel-team@android.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Sandeep,

On Mon, Apr 15, 2024 at 11:35:38AM -0700, Sandeep Dhavale wrote:
> mkfs.erofs supports creating filesystem images with different
> blocksizes. Add filesystem blocksize in super block dump so
> its easier to inspect the filesystem.
>
> The field is added after FS magic, so the output now looks like:
>
> Filesystem magic number:                      0xE0F5E1E2
> Filesystem blocksize:                         65536
> Filesystem blocks:                            21
> Filesystem inode metadata start block:        0
> Filesystem shared xattr metadata start block: 0
> Filesystem root nid:                          36
> Filesystem lz4_max_distance:                  65535
> Filesystem sb_extslots:                       0
> Filesystem inode count:                       10
> Filesystem created:                           Fri Apr 12 15:43:40 2024
> Filesystem features:                          sb_csum mtime 0padding
> Filesystem UUID:                              a84a2acc-08d8-4b72-8b8c-b8=
11a815fa07
>
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>
> ---
> Changes since v2:
> 	- Moved the field after FS magic as suggested by Gao
>  dump/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/dump/main.c b/dump/main.c
> index a89fc6b..928909d 100644
> --- a/dump/main.c
> +++ b/dump/main.c
> @@ -633,6 +633,8 @@ static void erofsdump_show_superblock(void)
>
>  	fprintf(stdout, "Filesystem magic number:                      0x%04X\=
n",
>  			EROFS_SUPER_MAGIC_V1);
> +	fprintf(stdout, "Filesystem blocksize:                         %llu\n"=
,
> +			erofs_blksiz(&sbi) | 0ULL);

Could we use `%u` for `erofs_blksiz(&sbi)`? since currently EROFS
block size isn't possible to be larger than PAGE_SIZE.

Even if block size > page size is supported, I think we should
not consider too large blocksizes.

Otherwise it looks good to me.

Thanks,
Gao Xiang
