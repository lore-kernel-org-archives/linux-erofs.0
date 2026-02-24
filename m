Return-Path: <linux-erofs+bounces-2401-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494D6F4BB68
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 17:49:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fL4wj55crz3cZn;
	Wed, 25 Feb 2026 04:49:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771955365;
	cv=none; b=R/QuEaL3ZrDobKvdsXh/DoQzOudX7CbGdLmOfVoJheAtY7IcFl4fd6ct4mdVyNpjxHpJVShz9hCpAFUW5CcQ+bv6gvVB9n95yvcsxDZMUGiCpVMbojuLv9FgPDlI/EZn+Uuqa9siGnxOGiTu/CrOoIcGM6ua1YJnDOcX0CMKPaOHQnZqprLb3BqA7wx5z19/v8Rg0Gf/S8ifWzVz0lqRYhgBdHrgXe/L6BzXNbOfltx0A1dHbgkK6gDUkGIgQxb28xUauGKVl5b8HUWh7nPOKNsuYhxS+2Ci1qnisLinrWnhNSfkZSIEWufwkkF3UTuupHkBThBCpWmiKY+LjtsWHA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771955365; c=relaxed/relaxed;
	bh=mYFexmvy1TM0kgUgbj+AklH9Eq/ukFKaQcdiNu4DC/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VopBm4vpDagVVLg4g58fw+17PhfEH98vlie8H8mthnbh7MRgL0JCRY8sWj6ZyZ4bOlBq5dX9zr50oOw7RQZ5we1qz2hiNjx+W2NR66NqkGtfFrKDFWKaKZFNTdceE4Ro6Y/S0XsXsKjUcIkai4CnFnPoBgwmYex9ZGtd/I9Vw2uOFPRAX6e4YdMELi5eg8yZhfpjNTYbEqD90AlM2XJv7gys3toVe3zjJpqSsO2pcWTQ4swI7xn+OuVaA2AametsHvJpj8dEwS4qj0pd0+7TS/66d1DX5QFnhu2J98+CtuFkWxlR2uTeZCnUuSYMo/aPXXmLxX2IOsvp7OiZrVTlwA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MucPGBKA; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MucPGBKA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fL4wg5qVlz3cZj
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 04:49:22 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771955358; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mYFexmvy1TM0kgUgbj+AklH9Eq/ukFKaQcdiNu4DC/Q=;
	b=MucPGBKALEVpsLJN8iM/6hvBQgPRCbQN8+sLPnetNTuWlRrz7n6PGwztI4NE1eFtlgrWAgc2c7ALX56/j5VpnNpMaDI18Xpe8NdDS0u3sMUPbWWlmN2DdVhaLdSQjMbmOoVUtGLgy7pi/lIRMK8HvfH5krHbGJesWp4aMWGWeOI=
Received: from 30.42.59.174(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wzjx-Dk_1771955356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Feb 2026 01:49:17 +0800
Message-ID: <57cdeefb-b88b-4a70-b871-9aa3c38716bb@linux.alibaba.com>
Date: Wed, 25 Feb 2026 01:49:16 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: converted division to shift in
 z_erofs_load_compact_lcluster
To: Ashley Lee <yester1324@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20260224163149.60016-1-yester1324@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260224163149.60016-1-yester1324@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Ashley,

On 2026/2/25 00:30, Ashley Lee wrote:
> perf on fsck.erofs reports that z_erofs_load_compact_lcluster was
> spending 20% of its time doing the div instruction. While the function
> itself is ~40% of the fsck.erofs runtime. In the source code, it seems
> that the compiler can't optimize the division by vcnt despite it only
> holding powers of two.
> 
> Running a benchmark on a lzma compressed freebsd source tree
> on x86 yields a ~3% increase in performance. The following
> test was run locally on an x86 machine.
> 
> $ hyperfine -w 10 -p "echo 3 > /proc/sys/vm/drop_caches; sleep 1" \
>    "./fsck.erofs ./bsd.erofs.lzma"
> 
> With shift optimization
> Time (mean ± σ):     360.0 ms ±  12.0 ms    \
>    [User: 236.3 ms, System: 120.6 ms]
> Range (min … max):   342.3 ms … 379.8 ms    10 runs
> 
> Original Dev Branch
> Time (mean ± σ):     371.1 ms ±  16.1 ms    \
>    [User: 254.8 ms, System: 115.0 ms]
> Range (min … max):   354.8 ms … 404.4 ms    10 runs

Which compiler are you using? Does both gcc and clang
behave the same?

I wonder if it's possible to refactor this a bit instead
of introducing another `vdiv`, also if the kernel
codebase behaves the same, we should improve the kernel too.

Thanks,
Gao Xiang

> 
> Signed-off-by: Ashley Lee <yester1324@gmail.com>
> 
> ---
>   lib/zmap.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/zmap.c b/lib/zmap.c
> index baec278..1ba52b5 100644
> --- a/lib/zmap.c
> +++ b/lib/zmap.c
> @@ -112,7 +112,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
>   	const unsigned int lclusterbits = vi->z_lclusterbits;
>   	const unsigned int totalidx = BLK_ROUND_UP(sbi, vi->i_size);
>   	unsigned int compacted_4b_initial, compacted_2b, amortizedshift;
> -	unsigned int vcnt, lo, lobits, encodebits, nblk, bytes;
> +	unsigned int vcnt, vdiv, lo, lobits, encodebits, nblk, bytes;
>   	bool big_pcluster = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
>   	erofs_off_t pos;
>   	u8 *in, type;
> @@ -144,13 +144,16 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
>   	pos += lcn * (1 << amortizedshift);
>   
>   	/* figure out the lcluster count in this pack */
> -	if (1 << amortizedshift == 4 && lclusterbits <= 14)
> +	if (1 << amortizedshift == 4 && lclusterbits <= 14) {
>   		vcnt = 2;
> -	else if (1 << amortizedshift == 2 && lclusterbits <= 12)
> +		vdiv = 1;
> +	} else if (1 << amortizedshift == 2 && lclusterbits <= 12) {
>   		vcnt = 16;
> -	else
> +		vdiv = 4;
> +	} else {
>   		return -EOPNOTSUPP;
> -
> +	}
> +
>   	in = erofs_read_metabuf(&m->map->buf, sbi, pos,
>   				erofs_inode_in_metabox(vi));
>   	if (IS_ERR(in))
> @@ -160,7 +163,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
>   	m->nextpackoff = round_down(pos, vcnt << amortizedshift) +
>   			 (vcnt << amortizedshift);
>   	lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
> -	encodebits = ((vcnt << amortizedshift) - sizeof(__le32)) * 8 / vcnt;
> +	encodebits = (((vcnt << amortizedshift) - sizeof(__le32)) * 8) >> vdiv;
>   	bytes = pos & ((vcnt << amortizedshift) - 1);
>   	in -= bytes;
>   	i = bytes >> amortizedshift;


