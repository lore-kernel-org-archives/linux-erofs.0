Return-Path: <SRS0=Di2a=MS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C38C4338F
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 18:19:34 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 43FEE60F6E
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Jul 2021 18:19:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 43FEE60F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GYSr46XwVz307v
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Jul 2021 04:19:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=peAvI0Sj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=djwong@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=peAvI0Sj; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GYSr16MqVz2xfw
 for <linux-erofs@lists.ozlabs.org>; Tue, 27 Jul 2021 04:19:29 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93BC5604DB;
 Mon, 26 Jul 2021 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627323565;
 bh=9Y7V+0t54qESU/DDHx7nrwaFgxexW3sul/7/SX89afs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=peAvI0Sj/Qkz8JzjIXEHgwgzb64oGjD7myvo5JvDG+XTEd8ZHX9L6BCJHsi4YOAi4
 BPL4KIYLienRJDvpIaS+LjFo7I+serdOHQk8M2cC3ACw6K6vNGLL0d/DwOkr5SIZS5
 96BqmA/EYb5/CLTUbmmUBK60kKKEPAA9KMXo1GtoUrwoFZmAt2vxRLccdUipleoFT7
 7CaDdo+Xq2n5XH8xdWxzDPXVosJAuy81Z/p26LYKNcmKy4gZRBrH8scIdRiqwDP1sD
 XH1K5TnNAooWpd553jllQSL4wLuxQsY347COKv9PJi2UEQc4zIWgOdm+s+qXfQIzSf
 l9mJUfhl0V5+w==
Date: Mon, 26 Jul 2021 11:19:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8] iomap: make inline data support more flexible
Message-ID: <20210726181925.GE8572@magnolia>
References: <20210726145734.214295-1-hsiangkao@linux.alibaba.com>
 <20210726145858.GA14066@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726145858.GA14066@lst.de>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Jul 26, 2021 at 04:58:58PM +0200, Christoph Hellwig wrote:
> Looks good to me:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Uh, did you mean RVB here?

--D
