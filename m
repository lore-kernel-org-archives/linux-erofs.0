Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32010C001DF
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Jul 2023 13:53:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RF0824LPGz307s
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Jul 2023 23:53:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RF07t50Gdz2ypx
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Jul 2023 23:53:30 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D7B2367373; Mon, 31 Jul 2023 15:53:25 +0200 (CEST)
Date: Mon, 31 Jul 2023 15:53:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Subject: Re: [syzbot] [erofs?] [fat?] WARNING in erofs_kill_sb
Message-ID: <20230731135325.GB6016@lst.de>
References: <000000000000f43cab0601c3c902@google.com> <20230731093744.GA1788@lst.de> <9b57e5f7-62b6-fd65-4dac-a71c9dc08abc@linux.alibaba.com> <20230731111622.GA3511@lst.de> <20230731-augapfel-penibel-196c3453f809@brauner> <20230731-unbeirrbar-kochen-761422d57ffc@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731-unbeirrbar-kochen-761422d57ffc@brauner>
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
Cc: jack@suse.cz, syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, huyue2@coolpad.com, syzbot <syzbot+69c477e882e44ce41ad9@syzkaller.appspotmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>, sj1557.seo@samsung.com, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Jul 31, 2023 at 03:22:28PM +0200, Christian Brauner wrote:
> Uh, no. I vasty underestimated how sensitive that change would be. Plus
> arguably ->kill_sb() really should be callable once the sb is visible.
> 
> Are you looking into this or do you want me to, Christoph?

I'm planning to look into it, but I won't get to it before tomorrow.
