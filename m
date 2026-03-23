Return-Path: <linux-erofs+bounces-2962-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB3BF4613A
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 15:08:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffc4D2dSSz2yWK;
	Tue, 24 Mar 2026 02:08:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774278492;
	cv=none; b=XsLz/8+6/n6vo5HokKLJQLNWSjpkFtvhKLjhK9j7Ku2ytqcS8UADTgocGLwG+QRRNyzbEfBt9NgSBNmjHR9HdjZENa+LCrilh7v3VEPdleKbYjmYW/ovV2+W4EwNdYkPfjBSL/os2wnqrfZdF+AwcnvyVwn+NZzI7hnjiTYoZA5xj0txgz+9DCAGkNaiTw/vfGFyr8QoJCpgETIkQY5XdEb0WdDGwusNx2PLukzevl3aF+JF67MFI8xjtQT3V+SDwauF/M38kqW9i/qMinIJ8f61mxB+eHCBTT61BDm2hwwbm52yYXQb8Tktx/Sx5ZhB6SgXdtc0qYm21SyIIeb+yA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774278492; c=relaxed/relaxed;
	bh=AHNxxjHmadguxMxHo/TO1CM0I9chEEPt7qn3e4hYAKc=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Subject:Cc:
	 References:In-Reply-To; b=Cu5YjGGcpeN4vscnVwnqeiN9MMvpknJvJzu0Wx7WHGU0QX+NmWvZMVsctyiCwiq0hYcWVhusxMw14xhEVeIPT5/Ylfksan313e7BxQ2YDG1xgHOo0rjc42sNt9Mje3VaPIlpxjHyPfy/ZqfVROUqCCvaXMWPLOHF22N9i8EN29YSGXkBAUTs4GSU2jFVLicE8uebBP0vztDPVXk5pER5MIYq1o1ZJ9LAeA/U9DDh2KP09KT/QKtG/KMqJrHJNyQCjAXumI18kBnWajKLCxOA92YoGYpH5G7LZHVco9yhBI+z7Z+5OAFdNxlYG2rAQLUyf8BDvRsNfUkQkAHdARArbg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=FbWayW17; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=mwalle@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=FbWayW17;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=mwalle@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffc4B6nlGz2ySB
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Mar 2026 02:08:10 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D99360120;
	Mon, 23 Mar 2026 15:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA42C4CEF7;
	Mon, 23 Mar 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774278487;
	bh=99pFc5lqEm3HxVz/exMZerXEHwyavsRZ+6NWbBoKUu8=;
	h=Date:From:To:Subject:Cc:References:In-Reply-To:From;
	b=FbWayW17Rsg9Ow1rNOXeKW98kSAo875Ay6O96tvV6rS4SF3yV7eartMVTzWidlasA
	 l9S9Y1mLNegrsjlj0MkAZ0naozF3/j+ClXyxSu+4uCr/T+UnhmL3mDEqyX0kUXMvoh
	 bTAoTRynTxHFHEG6kpMPmGV3EqEBzVqm765qSapIFh2wbVsECf68y49jUnkO9XONlI
	 EVDTyTlpSW6marJbJtQElPtryGO86JLOJAuzi2eksKOvQ5krU53av9so1vB2bLeUlo
	 xPofYJ1QVoGgHrJdPNUNzHTD/ktH9ftz59SpDZGR6evZ6HfsIYNVwfhbnIlDHUj6YR
	 Ozr2rhHiXfJvA==
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
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=5e3ab7e9be9fb049f7a17dec87288033ce5a62afd946d4a9ae13b0b1b96f;
 micalg=pgp-sha384; protocol="application/pgp-signature"
Date: Mon, 23 Mar 2026 16:08:04 +0100
Message-Id: <DHA98B2R8313.2J0R49KQ2WE1X@kernel.org>
From: "Michael Walle" <mwalle@kernel.org>
To: "Gao Xiang" <hsiangkao@linux.alibaba.com>, "Huang Jianan"
 <jnhuang95@gmail.com>, "Tom Rini" <trini@konsulko.com>
Subject: Re: [PATCH 1/4] fs/erofs: align the malloc'ed data
Cc: <linux-erofs@lists.ozlabs.org>, <u-boot@lists.denx.de>
X-Mailer: aerc 0.20.0
References: <20260323134305.2675822-1-mwalle@kernel.org>
 <20260323134305.2675822-2-mwalle@kernel.org>
 <b761dcf1-db25-47f3-8ef6-096c7a2f0493@linux.alibaba.com>
In-Reply-To: <b761dcf1-db25-47f3-8ef6-096c7a2f0493@linux.alibaba.com>

--5e3ab7e9be9fb049f7a17dec87288033ce5a62afd946d4a9ae13b0b1b96f
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi Gao,

On Mon Mar 23, 2026 at 3:41 PM CET, Gao Xiang wrote:
> Hi Michael,
>
> On 2026/3/23 21:42, Michael Walle wrote:
>> The data buffers are used to transfer from or to hardware peripherals.
>> Often, there are restrictions on addresses, i.e. they have to be aligned
>> at a certain size. Thus, allocate the data on the heap instead of the
>> stack (at a random address alignment). Use malloc_cache_aligned() to get
>> an aligned buffer.
>
> Many thanks for the patch, I wonder if it's possible to
> submit the patches to erofs-utils first (even make
> malloc_cache_aligned() as another malloc() for example)?
>
> Since I'd like to make u-boot codebase following
> erofs-utils, but I don't think Jianan have the
> bandwidth now, but if you have some use cases,
> you could help syncing up a bit.

Sorry, I don't have the bandwidth neither. But now I see where all
this is coming from. In userspace, you have much less (or none at
all) restrictions. So not sure, if that even makes sense to share. As
you've already pointed out the malloc_cache_aligned() would have to
be changed (back!) to malloc() again.

> Or at least, let's keep these four patches in sync
> between erofs-utils and u-boot.

Not sure what a DMA alignment has to do with userspace, or do you
mean moving all the block data from stack to heap?

This is more or less the result from an internal evaluation. You (or
anybody else) might take it - or leave it.

Do you share code between linux and erofs-utils, too? How does that
work?

Thanks,
-michael

>
> Many thanks!
> Gao Xiang
>
>>=20
>> Signed-off-by: Michael Walle <mwalle@kernel.org>
>> ---
>>   fs/erofs/data.c     | 11 ++++-------
>>   fs/erofs/internal.h |  1 +
>>   2 files changed, 5 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
>> index b58ec6fcc66..61dbae51a9a 100644
>> --- a/fs/erofs/data.c
>> +++ b/fs/erofs/data.c
>> @@ -319,15 +319,13 @@ static int z_erofs_read_data(struct erofs_inode *i=
node, char *buffer,
>>   		}
>>  =20
>>   		if (map.m_plen > bufsize) {
>> -			char *tmp;
>> -
>>   			bufsize =3D map.m_plen;
>> -			tmp =3D realloc(raw, bufsize);
>> -			if (!tmp) {
>> +			free(raw);
>> +			raw =3D malloc_cache_aligned(bufsize);
>> +			if (!raw) {
>>   				ret =3D -ENOMEM;
>>   				break;
>>   			}
>> -			raw =3D tmp;
>>   		}
>>  =20
>>   		ret =3D z_erofs_read_one_data(inode, &map, raw,
>> @@ -336,8 +334,7 @@ static int z_erofs_read_data(struct erofs_inode *ino=
de, char *buffer,
>>   		if (ret < 0)
>>   			break;
>>   	}
>> -	if (raw)
>> -		free(raw);
>> +	free(raw);
>>   	return ret < 0 ? ret : 0;
>>   }
>>  =20
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index 1875f37fcd2..13c862325a6 100644
>> --- a/fs/erofs/internal.h
>> +++ b/fs/erofs/internal.h
>> @@ -11,6 +11,7 @@
>>   #include <linux/printk.h>
>>   #include <linux/log2.h>
>>   #include <inttypes.h>
>> +#include <memalign.h>
>>   #include "erofs_fs.h"
>>  =20
>>   #define erofs_err(fmt, ...)	\


--5e3ab7e9be9fb049f7a17dec87288033ce5a62afd946d4a9ae13b0b1b96f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iKgEABMJADAWIQTIVZIcOo5wfU/AngkSJzzuPgIf+AUCacFXVBIcbXdhbGxlQGtl
cm5lbC5vcmcACgkQEic87j4CH/hlzgF+MQNTBBoBCdia2AtL2tMg+YFjYbZnq3fX
nBm2QHe9f+fb5/8OkA6OQEBY66SKXGonAYCmynQh6BizftTuiKu+LZGK+0+xJj39
vwqvFOhadBjMmVq/P/J7nxpbBwtlCE/JnxM=
=xw/2
-----END PGP SIGNATURE-----

--5e3ab7e9be9fb049f7a17dec87288033ce5a62afd946d4a9ae13b0b1b96f--

