Return-Path: <SRS0=QKTq=KP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEA9C433ED
	for <linux-erofs@archiver.kernel.org>; Thu, 20 May 2021 08:40:42 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 33CEF611C2
	for <linux-erofs@archiver.kernel.org>; Thu, 20 May 2021 08:40:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33CEF611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Fm3945nt2z300P
	for <linux-erofs@archiver.kernel.org>; Thu, 20 May 2021 18:40:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=JDVbF+LV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=JDVbF+LV; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Fm3924MNMz2yYM
 for <linux-erofs@lists.ozlabs.org>; Thu, 20 May 2021 18:40:38 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7023860E09;
 Thu, 20 May 2021 08:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1621500036;
 bh=9lMFE/wOwBjZrwNwRhEMmXbUPibX8C5KbGbXR7vX1Ik=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JDVbF+LV3KbT3feNmZ7ctQnbsm8METdwil3rB9cebi2S08lFMi88QvAi7DZKh9l8c
 Vp40W+3XgSse8WpKibMC6iA2Yg91S/GUGJlvA4Z4VFp2Vb8JAqRkH8BgavRjd9lpdJ
 XFQNWaYdqeKtf1rKoeITxKJw2RaWZKdVAmqZclbtUx04K8OvZ13WvDWJW9kUFPwWMm
 +iL4XPqNf8Tycw5XeSgRHZdG12yv1Dr+AWKuYakSq69IDB3L2qMtahkBLcExss+2Hm
 /6vQIg67Ou81VCyhkmXhAeUOuPiU1x6Zu1DobmGjJM2bB1Jk6Zo9s7i+8kAr6r/RtK
 j6495jlX4l1Iw==
Date: Thu, 20 May 2021 16:40:24 +0800
From: Gao Xiang <xiang@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Wei Yongjun <weiyongjun1@huawei.com>
Subject: Re: [PATCH -next] erofs: fix error return code in
 erofs_read_superblock()
Message-ID: <20210520084023.GA5720@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210519141657.3062715-1-weiyongjun1@huawei.com>
 <20210520053226.GB1955@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210520053226.GB1955@kadam>
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
 Hulk Robot <hulkci@huawei.com>, Gao Xiang <xiang@kernel.org>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Yongjun and Dan,

On Thu, May 20, 2021 at 08:32:26AM +0300, Dan Carpenter wrote:
> On Wed, May 19, 2021 at 02:16:57PM +0000, Wei Yongjun wrote:
> > 'ret' will be overwritten to 0 if erofs_sb_has_sb_chksum() return true,
> > thus 0 will return in some error handling cases. Fix to return negative
> > error code -EINVAL instead of 0.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> You need to add Fixes tags to bug fix patches and you need to ensure
> that the authors of the Fixes commit are CC'd so they can review your
> fix.  get_maintainer.pl will add the author automatically, but normally
> I like to put them in the To header to make sure they see it.
> 
> Fixes: b858a4844cfb ("erofs: support superblock checksum")

The commit and the tag look good to me (sorry for a bit delay on this),

Fixes: b858a4844cfb ("erofs: support superblock checksum")
Cc: stable <stable@vger.kernel.org> # 5.5+
Reviewed-by: Gao Xiang <xiang@kernel.org>

(will apply to dev-test for a while and then to -next.)

Thanks,
Gao Xiang

