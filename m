Return-Path: <SRS0=r8Mz=W5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AD7C3A59E
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 12:12:46 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2381321744
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 12:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VEC6pF12"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2381321744
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46MTVg6lV3zDqcG
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 22:12:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (mailfrom)
 smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:e::133;
 helo=bombadil.infradead.org;
 envelope-from=batv+8d7e6b8ef813b711cfc0+5853+infradead.org+hch@bombadil.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=infradead.org header.i=@infradead.org
 header.b="VEC6pF12"; dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46MTVb5pKhzDqY6
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Sep 2019 22:12:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=J0pxvEooYSHFFvDUmWTNFz+UlFOUvqkrq1JQQgTfRZk=; b=VEC6pF121qFiWicGITTyJ67R/
 JHlTes3Yc76ZTVPm/SNG2x+oHLatym8c/VKWKkIgKfaii20PQy1iLenT1cDH27sgK6+Z2hfgGcJTb
 pZOry7+kGLDbJDKp0mcAIGCto6JO0dcM6jcv1juCErY2XIR8NVF0TwPXIMctgIWcI/gUr5CDcHmhX
 SwFDpCKjabQeTtC/CiDCjt0opyPMa8pTfB1vvlXdROgNPJbvCovs/DJqrtBav2SJ7lWvDoVDlCJY1
 8Pf8LavpFBNIG7iPx3AE97X4coexKtDkmGLoyHJ0xrJVVweajn3sjO4nml6/bWJaP2BHMZ0FxGemR
 F3AvZcCUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat
 Linux)) id 1i4lCE-00070e-Cb; Mon, 02 Sep 2019 12:12:34 +0000
Date: Mon, 2 Sep 2019 05:12:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@aol.com>
Subject: Re: [PATCH 11/21] erofs: use dsb instead of layout for ondisk
 super_block
Message-ID: <20190902121234.GJ15931@infradead.org>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190901055130.30572-1-hsiangkao@aol.com>
 <20190901055130.30572-12-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901055130.30572-12-hsiangkao@aol.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

> +	dsb = (struct erofs_super_block *)((u8 *)bh->b_data +
> +					   EROFS_SUPER_OFFSET);

Not new in this patch, but that u8 cast shouldn't be needed.
