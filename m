Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B4606A330
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 09:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=CR5JQv0r
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKKPn488Hz2xK7;
	Wed, 04 Nov 2026 20:09:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=160.236.53.14
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793783357;
	cv=none; b=P9QaD+AYtXnr6mPOLAhttCRS9etVBzBP2G3QISZ4bMZOmT/p0LjrQjfVfS4950R55YN1I4ghS7eauyzJRFbHN8/bbzBpC8t/cEBQsgOsizGhoj3HQ2h6njxThA1L06kCop3sdHczQtvhksmdQdJ0hxg99LAnqtmpu+GZHzLNq7mtztr87mVV6Rp+UMdVwhWrZ8RJ0IvhO01WbwGYoDYcA+03Nj/lxzlScFk1vZNLZfC8NTLW+YXvJSq2cKcRumR/NFcI8+WoQa/UhEbzmybZwc8hyn2IjkE0uIFjr/QECEYri6o+zP3Ka+31/ckAjsLY0nN2cetbvpFUqIzUtC9LEg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793783357; c=relaxed/relaxed;
	bh=A5xdvd39hyjiOt0HCfswvWzbXoUdnJF8L9nr7SRJDX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R119w6Pvj/Ff2XkPM2w4mmFQai68ADtNjHQcpB8NoO+oLfWHlWmqv0XKrwR57j3vurYE3ZY8AdMxSgsAiLJEwhOQG0yUBYHOlFdrkUpsoF9oayWlE9iJg38cCx/0Yxq6L/5ouxL8Wq1yQgwTlV29bHkmWNJeSJgmhDydpEqYULOjtxZosXUKZebl91vN2zy8y1tGyq2ofYnV2PQfEKPQqv+IZi5swBGpdC2EfQsDSX0MitiWh8Zc4KXG5mFgNBc9tKx0AmPpFf+ax41Js8f4jZPIWLrNX+cLp8lkvLNrVmvxQfpTxpzuV7XNkS0uvJTpKuzypoQx9RavWT+sXfKGLQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=CR5JQv0r; dkim-atps=neutral; spf=pass (client-ip=160.236.53.14; helo=mail-m1602365314.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=CR5JQv0r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=160.236.53.14; helo=mail-m1602365314.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 303 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 20:09:14 AEDT
Received: from mail-m1602365314.xmail.ntesmail.com (mail-m1602365314.xmail.ntesmail.com [160.236.53.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKKPk5qC7z2xGg
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 20:09:14 +1100 (AEDT)
Received: from [192.168.24.192] (unknown [60.176.210.209])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5376d9f72;
	Wed, 4 Nov 2026 17:04:04 +0800 (GMT+08:00)
Message-ID: <b45973ea-a218-4367-8b89-58986b177438@deepseek.com>
Date: Wed, 4 Nov 2026 17:04:03 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: fsck: extract zero-length xattr values
To: xiang@kernel.org, linux-erofs@lists.ozlabs.org
References: <20261104035208.2471090-1-sereno.xu@deepseek.com>
 <aurunz5-1b4visC4@XiangdeMacBook-Pro.local>
From: Wenyuan Xu <sereno.xu@deepseek.com>
In-Reply-To: <aurunz5-1b4visC4@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1a5cd182103a3kunmc4108352ae964
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZQ0JNVkgZH0pJTBhIGUpJTlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNS1VKTE1VSUpLVUlLQllXWRYaDxIVHRRZQVlPS0hVSk
	tISkhNSlVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=CR5JQv0r78F2Fw9yBPGBUCWdEROWr3jCPMb1DXJE7Hgk8hFBHr0BLDcuu+G1sf6R+ZDRYORfrKobat59ItjCJA/z3DiMI9vf+qMRRBucui4F0+ioC12UcbMlMXFT3yQLCPSYwSfIfnVGrA+K9gRxoom3F36vHtobG0wKn+M8/ks=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=A5xdvd39hyjiOt0HCfswvWzbXoUdnJF8L9nr7SRJDX8=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/4 16:36, Gao Xiang 写道:
> Hi Wenyuan,
>
> On Wed, Nov 04, 2026 at 03:52:08AM +0000, Wenyuan Xu wrote:
>> A zero return value from erofs_getxattr() denotes an empty attribute,
>> but the extraction path treats it as an error.
>>
>> Accept zero-length values and allocate at least one byte for the value
>> buffer, avoiding dependence on malloc(0) behavior.
>>
>> Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
> According to
> https://linux.die.net/man/2/getxattr
>
> Return Value
> On success, a positive number is returned indicating the
> size of the extended attribute value.
>
> So 0-sized xattrs are not a valid number or here is a mistake.
>
> In principle, filesystems accept 0-size xattrs, and
> overlayfs uses it (see ovl_path_check_origin_xattr()).
>
> I think EROFS should support 0-size xattrs, but here
> we shouldn't expand to 1.
>
> I applied the following diff (please find if it works or not):


LGTM and it works for me.

Thanks.


Wenyuan Xu



> diff --git a/fsck/main.c b/fsck/main.c
> index 8e3ae52..1a36ef8 100644
> --- a/fsck/main.c
> +++ b/fsck/main.c
> @@ -458,25 +458,33 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
>   		size_t size = 0;
>   
>   		ret = erofs_getxattr(inode, key, NULL, 0);
> -		if (ret <= 0) {
> +		if (ret < 0) {
>   			DBG_BUGON(1);
>   			erofs_err("failed to get xattr value size of `%s` @ nid %llu",
>   				  key, inode->nid | 0ULL);
>   			break;
>   		}
>   		size = ret;
> -		value = malloc(size);
> -		if (!value) {
> -			ret = -ENOMEM;
> -			break;
> -		}
> -		ret = erofs_getxattr(inode, key, value, size);
> -		if (ret < 0) {
> -			erofs_err("failed to get xattr `%s` @ nid %llu, because of `%s`", key,
> -				  inode->nid | 0ULL, erofs_strerror(ret));
> -			free(value);
> -			break;
> +
> +		/* Empty xattrs are allowed */
> +		if (!size) {
> +			value = NULL;
> +		} else {
> +			value = malloc(size);
> +			if (!value) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +
> +			ret = erofs_getxattr(inode, key, value, size);
> +			if (ret < 0) {
> +				erofs_err("failed to get xattr `%s` @ nid %llu, because of `%s`", key,
> +					  inode->nid | 0ULL, erofs_strerror(ret));
> +				free(value);
> +				break;
> +			}
>   		}
> +
>   		if (fsckcfg.extract_path)
>   			ret = erofs_sys_lsetxattr(fsckcfg.extract_path, key,
>   						  value, size);
>
> Thanks,
> Gao Xiang
>
>> ---
>>   fsck/main.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fsck/main.c b/fsck/main.c
>> index e54c523..9db5ae9 100644
>> --- a/fsck/main.c
>> +++ b/fsck/main.c
>> @@ -458,14 +458,15 @@ static int erofsfsck_dump_xattrs(struct erofs_inode *inode)
>>   		size_t size = 0;
>>   
>>   		ret = erofs_getxattr(inode, key, NULL, 0);
>> -		if (ret <= 0) {
>> +		if (ret < 0) {
>>   			DBG_BUGON(1);
>>   			erofs_err("failed to get xattr value size of `%s` @ nid %llu",
>>   				  key, inode->nid | 0ULL);
>>   			break;
>>   		}
>>   		size = ret;
>> -		value = malloc(size);
>> +		/* Empty xattrs are valid */
>> +		value = malloc(size ? size : 1);
>>   		if (!value) {
>>   			ret = -ENOMEM;
>>   			break;
>> -- 
>> 2.43.0
>>
>>

