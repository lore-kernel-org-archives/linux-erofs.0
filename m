Return-Path: <SRS0=oztu=KQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1975C433ED
	for <linux-erofs@archiver.kernel.org>; Fri, 21 May 2021 01:57:25 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23EF76138C
	for <linux-erofs@archiver.kernel.org>; Fri, 21 May 2021 01:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23EF76138C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FmV9H6Csgz300S
	for <linux-erofs@archiver.kernel.org>; Fri, 21 May 2021 11:57:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=bT7Qhuof;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=bT7Qhuof; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FmV9B2NLmz2xfw
 for <linux-erofs@lists.ozlabs.org>; Fri, 21 May 2021 11:57:18 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67D6B61363;
 Fri, 21 May 2021 01:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1621562235;
 bh=Y4sLWiCzmZggrB+DEXmTmjrF0Kc7khKDtRYj72Uoeqw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=bT7QhuofxtHbsF5GzqdcOeUo7Ce9mBCbXSyj24ijq9OMyTHIVBSSRNZAShFQxCGYf
 qz22D7ADPC+AxZhB4zbHZqZLUq95Fl4xNrLiDaQFJE5lmuSr6LsqpTlM1FhH9c5Agt
 /0bGAaxfgBn8oS/eksHmJgAiabwDAhfo2scRNdbzy7k6ZEaS4PISO+jc5FmtkbZRdD
 BYzDXWcMMh0Mdt2EsVLQzZB+9PL6cEyJoPDlbGKvsvRudrOkWauNg8xa5ZoUYs//f+
 TwN5Pu2LpR66EGKm539QBCvpG6SG8h3inFC7h7KTktoRY6MVS4HI5ng1xSp3/nVCsI
 /vsDuOFvc8RLw==
Date: Fri, 21 May 2021 09:57:01 +0800
From: Gao Xiang <xiang@kernel.org>
To: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH -next] erofs: fix error return code in
 erofs_read_superblock()
Message-ID: <20210521015700.GA5725@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210519141657.3062715-1-weiyongjun1@huawei.com>
 <20210520053226.GB1955@kadam>
 <20210520084023.GA5720@hsiangkao-HP-ZHAN-66-Pro-G1>
 <9f96b12f-b05b-c118-4391-448f780702ff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9f96b12f-b05b-c118-4391-448f780702ff@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hulk Robot <hulkci@huawei.com>, Wei Yongjun <weiyongjun1@huawei.com>,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Dan Carpenter <dan.carpenter@oracle.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, May 21, 2021 at 09:14:58AM +0800, Chao Yu wrote:
> On 2021/5/20 16:40, Gao Xiang wrote:
> > Hi Yongjun and Dan,
> > 
> > On Thu, May 20, 2021 at 08:32:26AM +0300, Dan Carpenter wrote:
> > > On Wed, May 19, 2021 at 02:16:57PM +0000, Wei Yongjun wrote:
> > > > 'ret' will be overwritten to 0 if erofs_sb_has_sb_chksum() return true,
> > > > thus 0 will return in some error handling cases. Fix to return negative
> > > > error code -EINVAL instead of 0.
> > > > 
> > > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > > 
> > > You need to add Fixes tags to bug fix patches and you need to ensure
> > > that the authors of the Fixes commit are CC'd so they can review your
> > > fix.  get_maintainer.pl will add the author automatically, but normally
> > > I like to put them in the To header to make sure they see it.
> > > 
> > > Fixes: b858a4844cfb ("erofs: support superblock checksum")
> > 
> > The commit and the tag look good to me (sorry for a bit delay on this),
> > 
> > Fixes: b858a4844cfb ("erofs: support superblock checksum")
> > Cc: stable <stable@vger.kernel.org> # 5.5+
> > Reviewed-by: Gao Xiang <xiang@kernel.org>
> 
> Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks Chao, will add soon. :)

> 
> Thanks,
> 
> > 
> > (will apply to dev-test for a while and then to -next.)
> > 
> > Thanks,
> > Gao Xiang
> > 
> > .
> > 
