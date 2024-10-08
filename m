Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB97CED27C
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Oct 2024 08:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1728377194;
	bh=SsZzWNQUxssvBsScCHPgJH6ImP4FZEXYjAOzDpmlIKQ=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=SFG1D6pE5rvPwxqb0lDic5wBwpjc53KpIW5wSz5IIv/DLQgTmxR7O7HYWN7FZnZDo
	 +m79jfRug710PkR+1h5XG9YWtHfMaMQCR5kPkNxaYkwzDGai5qYB0DGJVXDBulds+E
	 1+c9bwIJbLc7NSrM0/wOULISuECLjEbQog8HfV2G1KIH0N0KnA7PAhuoL/THpO9k7p
	 lyqRZrcId1UTnr53OeaYyskCyyn4Zj8jU1vOo7qyE1ztVXoxUUJDTdv4+AUr/BF+17
	 vSu248YpHzBTfuMcKXZYi+hHyBgT1sCWYWQc/+LIpnQx8KAWmyXyg7IZbcsiAIBZoQ
	 Saexv9iMBZPFQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XN8ky0DjZz2yZN
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Oct 2024 19:46:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=139.178.84.217
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728377192;
	cv=none; b=PJ6fzeXcdg0tN9Zw5A9hdjmt6/xRCvBZSmQ2ULZYPWatkno8gwA9jiXaLw6goFHzg9g1O8veNVEvRM+U2CxiknyUxP7i1zXTKThmveW22UzsjS9pl+2ICAY30o7cVo8EQbI4nS5bc6hJ2Avgi7+68iSgYvptFA7eJBJRIuDgaz3IwUE9Sv6Nmd5dY3F4jNvsk67XAmYL4kTVbpiJ0GC5eVDxJICVIZH+gKK8rP7ETwHqv0HigpmZz8KZPkpr3/M3if6DtvAgu1/16p4p9PxupD0pt+D/jLV/r5xTBY8iS9msZIsX1BcfeUpCjPhChlQyI+0/JNp/G2udRBPXU+1qVA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728377192; c=relaxed/relaxed;
	bh=SsZzWNQUxssvBsScCHPgJH6ImP4FZEXYjAOzDpmlIKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAW8Xt7E/dwwYOg4Bdpdq9KvqtK0zEColEE+ZiBWM06Uo5UuwM72YIpy4Zo2rdsVN/sE7fRPmSn8Ni1JbMVxRIAaOLMmCVSyicitcm4zqvWduwkRUyX1mVuszeKZghaL45ctTlr2SzOaDACwbk2bgGDGSxiP9dTnroeJIx2GrB90zyXygqxNxVfzOwIhpNS+n3aF6Mq6F2WQbCLNvlVcJW1Q3ulZ7abY+M/def5M3XIY5F2uxFB/RPbar/Y2fiQ7xz8oOalCvph+FE3gU6g4eRMHNPX9p9qv5nPWRbc9ha0uue0TpNb6ofLnU5P0LV215oWs8jnYuZPrU4c3fg5V4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=kDY9HX/c; dkim-atps=neutral; spf=pass (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=kDY9HX/c;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XN8kv5WCRz2xHb
	for <linux-erofs@lists.ozlabs.org>; Tue,  8 Oct 2024 19:46:31 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2223F5C59B9;
	Tue,  8 Oct 2024 08:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2CCC4CEC7;
	Tue,  8 Oct 2024 08:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728377188;
	bh=8szYLqKKyxTax3jide3X0jKr5gWhHG0hju86NR+iJ9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kDY9HX/c9secNidyfMA6UUWTyk1YRhsTY4tF4/rW3Emgk4ahbRIZzmkEciBHUEUmd
	 BzCSPfSLlYo4uz0eKmmMQInE67o16lG2e8gXTZFbAXRc3WikZ4SOojcQYMlQW1akBR
	 Blk1uvZ7FmRiV1b7F/+6ZIfGqN7el/OHtwpAS5VxwSCquRP5xw20SSpbkM6JwpMAb5
	 1OF8/HiEWNu64LK0lIs56RQHkBMBjsEQjhwRVMWw4Gu0hk/uIgqJcaQ9eW1kNhgZuf
	 R70fQnWA8v2QMnYp/kKXxqf01D3EpQOu1P4JRiSOM8jlbObZsqyum/5Wd+Ezt4wzfY
	 +yOjkftl/pznQ==
Date: Tue, 8 Oct 2024 10:46:24 +0200
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: Incorrect error message from erofs "backed by file" in 6.12-rc
Message-ID: <20241008-blicken-ziehharmonika-de395b6dd566@brauner>
References: <CAOYeF9VQ8jKVmpy5Zy9DNhO6xmWSKMB-DO8yvBB0XvBE7=3Ugg@mail.gmail.com>
 <bb781cf6-1baf-4a98-94a5-f261a556d492@linux.alibaba.com>
 <20241007-zwietracht-flehen-1eeed6fac1a5@brauner>
 <b9565874-7018-46ef-b123-b524a1dffb21@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b9565874-7018-46ef-b123-b524a1dffb21@linux.alibaba.com>
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
From: Christian Brauner via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, Allison Karlitskaya <allison.karlitskaya@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Oct 08, 2024 at 10:13:31AM GMT, Gao Xiang wrote:
> Hi Christian,
> 
> On 2024/10/7 19:35, Christian Brauner wrote:
> > On Sat, Oct 05, 2024 at 10:41:10PM GMT, Gao Xiang wrote:
> 
> ...
> 
> > > 
> > > Hi Christian, if possible, could you give some other
> > > idea to handle this case better? Many thanks!
> 
> Thanks for the reply!
> 
> > 
> > (1) Require that the path be qualified like:
> > 
> >      fsconfig(<fd>, FSCONFIG_SET_STRING, "source", "file:/home/lis/src/mountcfs/cfs", 0)
> > 
> >      and match on it in either erofs_*_get_tree() or by adding a custom
> >      function for the Opt_source/"source" parameter.
> 
> IMHO, Users could create names with the prefix `file:`,
> it's somewhat strange to define a fixed prefix by the
> definition of source path fc->source.
> 
> Although there could be some escape character likewise
> way, but I'm not sure if it's worthwhile to work out
> this in kernel.
> 
> > 
> > (2) Add a erofs specific "source-file" mount option. IOW, check that
> >      either "source-file" or "source" was specified but not both. You
> >      could even set fc->source to "source-file" value and fail if
> >      fc->source is already set. You get the idea.
> 
> I once thought to add a new mount option too, yet from
> the user perpertive, I think users may not care about
> the source type of an arbitary path, and the kernel also
> can parse the type of the source path directly... so..
> 
> 
> So.. I wonder if it's possible to add a new VFS interface
> like get_tree_bdev_by_dev() for filesystems to specify a
> device number rather than hardcoded hard-coded source path
> way, e.g. I could see the potential benefits other than
> the EROFS use case:
> 
>  - Filesystems can have other ways to get a bdev-based sb
>    in addition to the current hard-coded source path way;
> 
>  - Some pseudo fs can use this way to generate a fs from a
>    bdev.
> 
>  - Just like get_tree_nodev(), it doesn't strictly tie to
>    fc->source too.
> 
> Also EROFS could lookup_bdev() (this kAPI is already
> exported) itself to check if it uses get_tree_bdev_by_dev()
> or get_tree_nodev()... Does it sounds good?  Many thanks!

Sounds fair to me.
