Return-Path: <SRS0=H+WS=EJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AC6C388F7
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2020 15:59:07 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4E9C223AB
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2020 15:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDmilPl3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4E9C223AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CQZGH5C8hzDqLT
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2020 02:59:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=default header.b=mDmilPl3; dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CQZG443qGzDq8W
 for <linux-erofs@lists.ozlabs.org>; Wed,  4 Nov 2020 02:58:52 +1100 (AEDT)
Received: from [192.168.0.112] (unknown [117.89.214.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8133F20870;
 Tue,  3 Nov 2020 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604419129;
 bh=f29d1wETJnFFOtXCHry4rt0aAdsEHjADIZSHXNcZEw4=;
 h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
 b=mDmilPl3uHLlORwpgRDaKaE+rOVUG8Oo71Cbiy9N42GlzeZ5WECj2DTNmmTZpsa0U
 965hDAg7OT0Iz0S5+CQg473ryEPxeyaE7keYtQnncduHSjc3jhTIHHfr/IAAuo/WkT
 JGdC5BfRgrFb59B5i8bMdFZP9cmCi/khNzphFIyo=
Subject: Re: [PATCH] erofs: derive atime instead of leaving it empty
To: Gao Xiang <hsiangkao@redhat.com>, Chao Yu <yuchao0@huawei.com>
References: <20201031195102.21221-1-hsiangkao.ref@aol.com>
 <20201031195102.21221-1-hsiangkao@aol.com>
 <20201103025033.GA788000@xiangao.remote.csb>
From: Chao Yu <chao@kernel.org>
Message-ID: <275b73d7-9865-91c0-ecf2-bceed09a4dae@kernel.org>
Date: Tue, 3 Nov 2020 23:58:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20201103025033.GA788000@xiangao.remote.csb>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
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
Cc: nl6720 <nl6720@gmail.com>, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Xiang,

On 2020-11-3 10:50, Gao Xiang wrote:
> Hi Chao,
>
> On Sun, Nov 01, 2020 at 03:51:02AM +0800, Gao Xiang wrote:
>> From: Gao Xiang <hsiangkao@redhat.com>
>>
>> EROFS has _only one_ ondisk timestamp (ctime is currently
>> documented and recorded, we might also record mtime instead
>> with a new compat feature if needed) for each extended inode
>> since EROFS isn't mainly for archival purposes so no need to
>> keep all timestamps on disk especially for Android scenarios
>> due to security concerns. Also, romfs/cramfs don't have their
>> own on-disk timestamp, and squashfs only records mtime instead.
>>
>> Let's also derive access time from ondisk timestamp rather than
>> leaving it empty, and if mtime/atime for each file are really
>> needed for specific scenarios as well, we can also use xattrs
>> to record them then.
>>
>> Reported-by: nl6720 <nl6720@gmail.com>
>> [ Gao Xiang: It'd be better to backport for user-friendly concern. ]
>> Fixes: 431339ba9042 ("staging: erofs: add inode operations")
>> Cc: stable <stable@vger.kernel.org> # 4.19+
>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>
> May I ask for some extra free slots to review this patch plus
> [PATCH 1/4] of
> https://lore.kernel.org/r/20201022145724.27284-1-hsiangkao@aol.com
>
> since it'd be also in linux-next for a while before sending out
> to Linus. And the debugging messages may also be an annoying
> thing for users.

Sorry for the delay review, will check the details tomorrow. :)

Thanks,

>
> Thanks a lot!
>
> Thanks,
> Gao Xiang
>
