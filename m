Return-Path: <SRS0=ChUK=4H=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9224DC3402F
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 03:28:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4875F24673
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 03:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSo+l0jq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4875F24673
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48MjqR6c02zDqjd
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Feb 2020 14:28:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=ebiggers@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=default header.b=sSo+l0jq; dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48MjqL4lr8zDqXg
 for <linux-erofs@lists.ozlabs.org>; Wed, 19 Feb 2020 14:28:30 +1100 (AEDT)
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net
 [107.3.166.239])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C791F24658;
 Wed, 19 Feb 2020 03:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582082908;
 bh=VSakUIZdUnh4kwjCiCYOK30SKm0FPJHaDrKhBHNH/O0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=sSo+l0jqfJP5IDuZCWJUj4RO9pEWAB1W4p4Feik4xAkV3cci+4Xqzgigh+5tJwH9v
 sE1kq86XdWrgqVDsv1RolnDs1ziPSCTYBt6BD/mOmWDhMIlqCxeffX/y5V/4JZzwPR
 SQktNIjOJLPhkomAjO77iIh3++VkdKq2Nvgz61hQ=
Date: Tue, 18 Feb 2020 19:28:26 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v6 10/19] fs: Convert mpage_readpages to mpage_readahead
Message-ID: <20200219032826.GB1075@sol.localdomain>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200217184613.19668-18-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217184613.19668-18-willy@infradead.org>
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
Cc: cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Feb 17, 2020 at 10:45:58AM -0800, Matthew Wilcox wrote:
> diff --git a/include/linux/mpage.h b/include/linux/mpage.h
> index 001f1fcf9836..f4f5e90a6844 100644
> --- a/include/linux/mpage.h
> +++ b/include/linux/mpage.h
> @@ -13,9 +13,9 @@
>  #ifdef CONFIG_BLOCK
>  
>  struct writeback_control;
> +struct readahead_control;
>  
> -int mpage_readpages(struct address_space *mapping, struct list_head *pages,
> -				unsigned nr_pages, get_block_t get_block);
> +void mpage_readahead(struct readahead_control *, get_block_t get_block);
>  int mpage_readpage(struct page *page, get_block_t get_block);
>  int mpage_writepages(struct address_space *mapping,
>  		struct writeback_control *wbc, get_block_t get_block);

Can you name the 'struct readahead_control *' parameter?

checkpatch.pl should warn about this.

- Eric
