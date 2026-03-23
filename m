Return-Path: <linux-erofs+bounces-2937-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBDBD58CBB
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 01:56:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffGVS5WZgz2ySB;
	Mon, 23 Mar 2026 12:56:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774230976;
	cv=none; b=jFp1hHvYd465o3qz1GUmLKUJacU5wzYCXJMDUj68i8hYcQ7mnZgitSdL9mLA8AMtt+VLAQDGO9Dgx2YbekXhjGtCR8zkoIfC86X9ajE2VWb9F+8XZpYpZakDgWV7sAbufzBsgL//L3UihH0xLnTdWdZesc86oMB8rh2O+L417VrxThUDo2dPLYNS6/kiRMViKQ/c6mQikGFwlpzrhoYwi1IiQH0KKiFBT2a2KheRPSU4CvkJ8ZgxCAzDomEbeEwW8hTcokQ45m/MPSqsyqAQ2nO2UkVB79P8rBgzdTpUdzPOiPFnR/k1L4HwITtFhLbhUu0iXuo8MRAtYvdVftUy4A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774230976; c=relaxed/relaxed;
	bh=XUnduESIxWJcGfnoZERY/yeuRuBL3HcCGrCx1vhu3Mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DWoMIZm6w9BB3oqduRsLpZPR1UAgz/3MRJ6KMRhQayhTrtGPK/xJ1GrxXLvm+OwnrG47Rr0bnUdCKVa0ihT+xztLvyMqN9kyC8XfC4YW4+0S3H/3jHtd3J709ByOPq1O8BCic4pxOzGLJ4rZA5T+WPSFZUwCYPSlQbfBdF127Z7fCziXrJhevTEMw6665XUe1AQXbEVaSgrWt4i5jT9m60GqHD89CP6/Azn5cDaB94y32WEm+R0yhLrDpln297CWK1QP5FQCNvudY2LWkcHXSf/LZc9sgSwQQhiFLfCYBh/AS5ZXRK9To986obLlRyCBRK3B2a2EEn26jXX0GvHjjA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=OXcD3TcP; dkim-atps=neutral; spf=pass (client-ip=113.46.200.217; helo=canpmsgout02.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=OXcD3TcP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.217; helo=canpmsgout02.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffGVQ4l2Xz2xQ1
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 12:56:13 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XUnduESIxWJcGfnoZERY/yeuRuBL3HcCGrCx1vhu3Mk=;
	b=OXcD3TcPdEHIowmb9zx9D45R3q4OUigwZHfvcux0HP8um0PXAuPEgzfoL9vy9CstOLwCyqi3e
	yOyQciN9ZZm1c5hvw+CSzMK9Ls/zIIjhRm2HJ4oShiEF+ZPKvCmsyv6Wim1PA63qMBijpbncMxq
	rMf/fD6oBVNOmnofRpSqk9k=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4ffGMc5QTQzcbTv;
	Mon, 23 Mar 2026 09:50:20 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 60CD440363;
	Mon, 23 Mar 2026 09:56:08 +0800 (CST)
Received: from [100.103.109.96] (100.103.109.96) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 23 Mar 2026 09:56:07 +0800
Message-ID: <8e70b1d0-7a4f-4a51-9bbc-0e4c4e01069d@huawei.com>
Date: Mon, 23 Mar 2026 09:56:01 +0800
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
Subject: Re: [PATCH] erofs-utils: mkfs: bound-check s3 passwd_file credentials
To: Vansh Choudhary <ch@vnsh.in>, <linux-erofs@lists.ozlabs.org>
References: <20260321180239.36249-1-ch@vnsh.in>
From: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
In-Reply-To: <20260321180239.36249-1-ch@vnsh.in>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.103.109.96]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Reviewed-by: Yifan Zhao <zhaoyifan28@huawei.com>

On 2026/3/22 2:02, Vansh Choudhary wrote:
> mkfs_parse_s3_cfg_passwd() only checked the total passwd_file size,
> which left two issues in the parser:
>
> - a file exactly as large as the temporary buffer left no room for the
>    trailing NUL byte;
> - either credential could still exceed its destination buffer after the
>    string is split at ':'.
>
> Use sizeof(buf) for the temporary buffer check and reject overlong
> access key or secret key fields before copying them out.
>
> This keeps the existing parsing flow intact while making the bounds
> checks match the actual destination sizes.
>
> Signed-off-by: Vansh Choudhary <ch@vnsh.in>
> ---
>   mkfs/main.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 58c18f9..eb13aba 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -663,7 +663,7 @@ static int mkfs_parse_s3_cfg_passwd(const char *filepath, char *ak, char *sk)
>   		erofs_warn("passwd_file %s should not be accessible by group or others",
>   			   filepath);
>   
> -	if (st.st_size > S3_ACCESS_KEY_LEN + S3_SECRET_KEY_LEN + 3) {
> +	if (st.st_size >= sizeof(buf)) {
>   		erofs_err("passwd_file %s is too large (size: %llu)", filepath,
>   			  st.st_size | 0ULL);
>   		ret = -EINVAL;
> @@ -687,6 +687,12 @@ static int mkfs_parse_s3_cfg_passwd(const char *filepath, char *ak, char *sk)
>   	}
>   	*colon = '\0';
>   
> +	if (strlen(buf) > S3_ACCESS_KEY_LEN ||
> +	    strlen(colon + 1) > S3_SECRET_KEY_LEN) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>   	strcpy(ak, buf);
>   	strcpy(sk, colon + 1);
>   

