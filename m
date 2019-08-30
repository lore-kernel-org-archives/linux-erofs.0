Return-Path: <SRS0=iJNB=W2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFF8C3A59B
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 16:28:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECC8523405
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 16:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m0ltjgx7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECC8523405
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46KlKB11WRzDr34
	for <linux-erofs@archiver.kernel.org>; Sat, 31 Aug 2019 02:28:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (mailfrom)
 smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:e::133;
 helo=bombadil.infradead.org;
 envelope-from=batv+b0e6514120785512acaa+5850+infradead.org+hch@bombadil.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=infradead.org
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46KlJz4brRzDr2K
 for <linux-erofs@lists.ozlabs.org>; Sat, 31 Aug 2019 02:28:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=RdPMpAXXBaiQno2G62m49MFypxqlVKUtgB8faAoi/bA=; b=m0ltjgx7t4ynixYMj9EPQrDSd
 gouxhmamQQK46+oauBJCwjtVgtNnrQh3DY23q1oViqIYVv0QTxvU8EoQ2QX088A3jt8it37QT5tav
 +G99U5Hvmr8MWiuaitu6f4u0/16jw6KiM7gZ1aQphmP3iwQ4Ep8Ka7z0Z1hi8dRKhi7TrUA50F4rN
 6tsT6WTOz8bN8V7WcePdcW6dl7pBthWt1CXoQ36kayghdBUUFC2rvbk2mlhO/aFNG+K6fyaE5nxxt
 s8RKesu5J5MzBXL4CN/QjwpPqfrgUu3acD8Zy1p3mVZi/IUFVrm/eTTNm+BVfU3APEHcq1XOQIYIO
 cSh/4TjEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat
 Linux)) id 1i3jky-0006Lt-Fu; Fri, 30 Aug 2019 16:28:12 +0000
Date: Fri, 30 Aug 2019 09:28:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v3 7/7] erofs: redundant assignment in
 __erofs_get_meta_page()
Message-ID: <20190830162812.GA10694@infradead.org>
References: <20190830032006.GA20217@architecture4>
 <20190830033643.51019-1-gaoxiang25@huawei.com>
 <20190830033643.51019-7-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830033643.51019-7-gaoxiang25@huawei.com>
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
 Miao Xie <miaoxie@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>, weidu.du@huawei.com,
 Joe Perches <joe@perches.com>, linux-erofs@lists.ozlabs.org,
 Dan Carpenter <dan.carpenter@oracle.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

> -		err = bio_add_page(bio, page, PAGE_SIZE, 0);
> -		if (err != PAGE_SIZE) {
> +		if (bio_add_page(bio, page, PAGE_SIZE, 0) != PAGE_SIZE) {
>  			err = -EFAULT;
>  			goto err_out;
>  		}

This patch looks like an improvement.  But looking at that whole
area just makes me cringe.

Why is there __erofs_get_meta_page with the two weird booleans instead
of a single erofs_get_meta_page that gets and gfp_t for additional
flags and an unsigned int for additional bio op flags.

Why do need ioprio support to start with?  Seeing that in a new
fs look kinda odd.  Do you have benchmarks that show the difference?

That function then calls erofs_grab_bio, which tries to handle a
bio_alloc failure, except that the function will not actually fail
due the mempool backing it.  It also seems like and awfully
huge function to inline.

Why is there __submit_bio which really just obsfucates what is
going on?  Also why is __submit_bio using bio_set_op_attrs instead
of opencode it as the comment right next to it asks you to?

Also I really don't understand why you can't just use read_cache_page
or even read_cache_page_gfp instead of __erofs_get_meta_page.
That function is a whole lot of duplication of functionality shared
by a lot of other file systems.
