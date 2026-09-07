Return-Path: <linux-erofs+bounces-4491-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB649C79FA1
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 14:50:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdqjy5B0Sz2xk7;
	Tue, 08 Sep 2026 00:50:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=203.205.221.239
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788792614;
	cv=none; b=WnEFBqwtQ7cB3xdl6hfsjM0ix+PaYh4w0FmZP0YwlB4WBDzOJQJxmyx5bn7EZQhCO1BEyw/EYpYgd2xfDEZVQkUi2JANMJGcwUN+uw+ZWQYWYXl1DbTkBQnklmLnTOcdKfTf+UFvoloFWUxci2izDCSQ+R/yfGRt+rSMH2gMyHHV2IMDqr2AFlp1LIOkMmVSqj8rRBjh57ifG2GOGRI4+izrK5d0ln8+AA7UiR97OnVxRHZs8T7lRrTzN1aT2b/mJkKL5MAce1hI1J925hPm2dZ2G/MqNlLZNROVGXTB7UKSEDw4svYKNkdv0dDbHcS6BD/cCHkeSPGLc2Rf55cb8A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788792614; c=relaxed/relaxed;
	bh=5Td8aUIZ9BCAa1tGjWQMGfDSHSB8C01PBcI3FXS1CRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oAKjA7WdNvos6KFiLsemv/PQ9TnKiU/+jWeVnZVe51rwJ8z0nnmLOji13t6fseRwp77jwTA9VIk5UzYa3+4ffBSZEm9JlRpaiIMuJIQRopbe/7yNsbwXPy8hZVB3FYxE+bmdl8KBf5KTEaO29KgM/4EwVyvo3PM0X/+Q9boe/H0/3/o222TPMIwIDpINgaCz0kJSQtYbIUNOJaoG2y7U0PFSWQh8Sdae0b5L+xgIe1EycSdM0u0QxG6lJvA0i516Q+ivrjORKS+EQauxZOyuXEAUcc7ulExDNtZSxBzNNlbKQSbPjecGGo4EWzHOOwi7cfvUINosmDPMXFxTAvsiYg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=midh9TG4; dkim-atps=neutral; spf=pass (client-ip=203.205.221.239; helo=out203-205-221-239.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=foxmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=midh9TG4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=foxmail.com (client-ip=203.205.221.239; helo=out203-205-221-239.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org)
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdqjq0bhYz2xfT
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 00:49:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1788792593;
	bh=5Td8aUIZ9BCAa1tGjWQMGfDSHSB8C01PBcI3FXS1CRs=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=midh9TG4Yw8s9A9MADoXXYBo07aGIfqt71OsKwCaSi8hWmIRQrQUJs4gqyY0N3WmM
	 uWzezZP+QDpFjduxUMvUyj+8zkX6NPWo42ztJ29dpxhiVuQpf5QNXGROJygqVCM4Ta
	 UpJR9TnH1dISYqIuyCyGOBQ2jrIbI3R/p+P0aEjo=
Received: from [127.0.0.1] ([112.64.102.27])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id C1CA1CAE; Mon, 07 Sep 2026 22:48:28 +0800
X-QQ-mid: xmsmtpt1788792508tsm9ye5p6
Message-ID: <tencent_2885ED3B33A8AB09CB47F47ECF92AE9DC508@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJhx4svpIW5M3Mz6JONa2JbiSTDCWFuRYTmXggJHk0yDPj9TjvC7
	 j9s+d5z6MKE0dzF6i9QG3Ff2D1GnpNHrZHy0BYu1SFUOJYzQAp63rMPvqqWNK113egv94drWs60C
	 cJ+UIjTXA5c+M9hlbDZcqI5JjSCwvhS1HaT/lBGPICuLlwP0eVByR2jqTL1JrolG0jULRzvNX/bn
	 jEKTUTyJzag11HpujS1zNERrGs3IGB01LNFJmTRQhOUG2bNIrxpNjTYuLG62F/4i48Vq1rysmTVW
	 mzYrtgTkCLeFGEQj1217t9QJKhZvXdClC6qSZWyf30C7es1xRrorGa3Mj84DITHGA4pFZncKy0QN
	 ETurXgTRnc3Ztk5jWGp/6tqlJFNwiqrSaxe31iz0Wr86NMrItB8VL9xgkBTeHZqIm/P6oN8217l+
	 lNRLv9v1fDUtopKEF2tym7tEHnnd0mFdlSfvV2AdoTMhNPg0cQ2/Kb983xcypU/1L14s/PJg4Xup
	 TsReCQ9noxlx8i8806hKTZZqdspxv8dEkm0zY3XWp5FDTjtSsIW60KxXOn1q+fW9i8bsN3xakBiR
	 IrPJNL5JOa/Uxz0wNkCDVn8snzvqo4ECzEjeG41FdKynE/WTjbAS0E5wowLqJFIxWuL1PRUF2KLB
	 uFkAzu8KSysKO5+9Qm4F3gSPvBxt0pS4hrg8UM8N3pu6uBrvzOJ6Y7n8qM6cM7u5vy/fAHYKJ/AE
	 U4hQzzxkOW9PdSYXwJxhdiTPiFUekuudrv2F9c+ZxVle6gDUFlPaq6vNaZPPqtvKDP/JKlOSwnzR
	 gh5VsRi9GChXNI1xfGnGzQJu+nMnbZaYsvg6b/M3v6ZpahmTffv9gVhEu+p5xkNisdPyYwt4Bky4
	 fHXEgLKK1X/fUMkY9YF1lvGMK79mbLK7ad4MwJHkueejB8x8jvpF7bLLIwyECIovQoe971+1E25D
	 s1OCOA13gjYBkOwjulwYtasmqbwTtCxR1efXc3ccNd3XAcvNHyf5qsJikmmPpVg2dQtAi/KF4=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-OQ-MSGID: <e59c165f-cc55-4a95-b560-5ce8b19ac55c@foxmail.com>
Date: Mon, 7 Sep 2026 22:48:32 +0800
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
Subject: Re: [PATCH 2/2] erofs-utils: lib: fix direct S3 writes to blob
 devices
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260907083027.13793-1-xiang@kernel.org>
 <20260907083027.13793-2-xiang@kernel.org>
 <tencent_B0673C3FB942146BB5B3CD80ADEE2CDBD20A@qq.com>
 <ap7HTja0xidxmBX7@XiangdeMacBook-Pro.local>
Content-Language: en-US
From: Yifan Zhao <yifan.yfzhao@foxmail.com>
In-Reply-To: <ap7HTja0xidxmBX7@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/7/2026 10:16 PM, Gao Xiang wrote:
> Hi Yifan,
>
> On Mon, Sep 07, 2026 at 07:04:18PM +0800, Yifan Zhao wrote:
>> missing #include "liberofs_cache.h" in s3.c
>>
>> remotes/s3.c: In function 's3erofs_remote_getobject':
>> remotes/s3.c:1068:54: error: invalid use of undefined type 'struct
>> erofs_bufmgr'
>>   1068 |                         sbi->devs[device_id - 1].bmgr->vf :
>> &sbi->bdev;
>>
> I've fixed it up, could you check again?
Tested-by: Yifan Zhao <yifan.yfzhao@foxmail.com>
> Thanks,
> Gao Xiang
>
>> Thanks,
>>
>> Yifan


