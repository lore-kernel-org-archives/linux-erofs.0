Return-Path: <SRS0=HDt7=AA=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39261C433E0
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2020 17:45:14 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD7172100A
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2020 17:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="WzKMZKkD";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="lXNcmkg3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD7172100A
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49pR601m3QzDrTK
	for <linux-erofs@archiver.kernel.org>; Sat, 20 Jun 2020 03:45:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1592588712;
	bh=8ibRMuGFGONFqA1Zkrwky/pJkS2ksDaYBegp0GX71Zk=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=WzKMZKkDbk3+EezcPCASgMayCqaSi09xb5j5/8dGvFcBuGKfDeHMdoPtG1N7m+iXY
	 rMTf/0ypMh1jCKVwMdkS2cR/siG1xViDdYbVE1kLogjqGek6Vn8M7EZV7ZYqc1aWLP
	 7oZd2q/Olo03dwCJBorVijw6Xj674aiJhKftnUQJSS9ySIcVc+TouWBnWHtrOg987X
	 oQAdMbtC9YlXumUcSWyLGYQY7PfQBKhLZJJSZk7tk62cKTnwbSuy6zxxVeUU5gg9Nv
	 8BZ+xi8C89paWBgP2JloXu2XK3opHZdM5Mec5N/NHss6j9vEXvo5f7naMKrDyAcB5g
	 9GOPEdCKaTaig==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.41;
 helo=out30-41.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=lXNcmkg3; dkim-atps=neutral
Received: from out30-41.freemail.mail.aliyun.com
 (out30-41.freemail.mail.aliyun.com [115.124.30.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49pPXZ0qXQzDrRW
 for <linux-erofs@lists.ozlabs.org>; Sat, 20 Jun 2020 02:34:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1592584469; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=WPS6GAhpdWXmw89MQ13M23PP/oJL9lnwyPVywjzVoc8=;
 b=lXNcmkg3Il/6SnHXw/Lz546eDPuI/YbvhDe1tsHMmNp7uAMJCyvrSUpVmQsXPicScu+O+ngUEPXZ3AgcBbrClWrJHpJl8tiR6w7fLyrVdI13Nq7mihnuqrD0FFvlcSIr96+4hdRWb/7XOjxnBiCxiaFmQYWh1iAVhVIwFEBFygc=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1625505|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_social|0.0128945-0.00154629-0.985559; FP=0|0|0|0|0|-1|-1|-1;
 HT=e01f04427; MF=bluce.lee@aliyun.com; NM=1; PH=DS; RN=2; RT=2; SR=0;
 TI=SMTPD_---0U044zLE_1592584467; 
Received: from 192.168.3.5(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0U044zLE_1592584467) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 20 Jun 2020 00:34:27 +0800
Subject: Re: [PATCH] erofs-utils: pass down inode for erofs_prepare_xattr_ibody
To: linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@redhat.com>
References: <20200617072744.7979-1-hsiangkao.ref@aol.com>
 <20200617072744.7979-1-hsiangkao@aol.com>
Message-ID: <c21302b5-800b-84a0-6409-2fe2c3356ec1@aliyun.com>
Date: Sat, 20 Jun 2020 00:34:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617072744.7979-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8
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
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


On 2020/6/17 15:27, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
>
> Instead of several independent arguments for convenience.
> No logic changes.
>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  
>
> It looks good
>
> Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
>
