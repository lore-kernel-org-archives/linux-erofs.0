Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA36C0015E
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Aug 2023 07:51:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RFS3z5QxVz303p
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Aug 2023 17:51:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RFS3q6vN6z2yVL
	for <linux-erofs@lists.ozlabs.org>; Tue,  1 Aug 2023 17:51:34 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 56FCF68AA6; Tue,  1 Aug 2023 09:51:29 +0200 (CEST)
Date: Tue, 1 Aug 2023 09:51:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH] erofs: drop unnecessary WARN_ON() in erofs_kill_sb()
Message-ID: <20230801075129.GA23838@lst.de>
References: <20230731-flugbereit-wohnlage-78acdf95ab7e@brauner> <20230801014737.28614-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801014737.28614-1-hsiangkao@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Aug 01, 2023 at 09:47:37AM +0800, Gao Xiang wrote:
> Previously, .kill_sb() will be called only after fill_super fails.
> It will be changed [1].
> 
> Besides, checking for s_magic in erofs_kill_sb() is unnecessary from
> any point of view.  Let's get rid of it now.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
