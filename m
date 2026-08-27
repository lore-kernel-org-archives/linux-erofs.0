Return-Path: <linux-erofs+bounces-4355-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4623BC61DC2
	for <linux-erofs@archiver.kernel.org>; Thu, 27 Aug 2026 12:11:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hW0jN2v9Tz2xwN;
	Thu, 27 Aug 2026 22:11:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787832664;
	cv=none; b=N1vXL8bkaEUZI+yVl9wgdEZOoDRTmFJxWU1TzLWv6RQ3WAdHEHHCl6yJGp9AIohQ4ZY1PzvD5eLagy3HhBoxsJHgCtlavsgEyHinUmHbzBeUqOQ1H0VkgZfEDjpHIb2bY0EVoXzJ/fG1blOpSDqax8OxyQ2X3mCx+RI7q/bCn/HfHgWxJDssWXAWofwhKHTxByatWepmJq4gc0peQRu0xDw/tf/rx/BjBgJs3eRUmuh+3qIcaYDK+owZ77L0bzhxzRyke5n/aP2SXlI004fV5I7opGGjsp7f1GZ4gO4CKMIEMdaLdPedQ5H6VUOfcT1NWi9kU9z2V7gMJ5IfqQ8YIw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787832664; c=relaxed/relaxed;
	bh=g7emBe9EshWdz4d7qczIQdj1HNRKn1jW37LfWnCoVRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a44eMt08Tz/vOUhuBg3zuqRu6viRfyF/tkXKQYmJS8wuwJm3CjEvAKuPx0hPVX6qe9qn0FsVEYerQFQS/Mov4GXhJyZpVgUvHwym/ZPMVyndtG/pVzNJVxBBRHuhkq8iImRq3wvDfZR+PCbpGzgk+P0xC3KjUCizv37QZkOsQ7RuR3LUYXmq8uefFTV2Mzf8pnvz8EALp9WqddhTbOtfg6WGvDjOEmqOgru0Hcg9wcdisgpusymILcqujlqV1fa2HH0KB7wwV1JwU7dyJ9c6dWbr+XmTFiZx5xNmlA5yH2N/p3EQ6LvZsJK3pn51JncXyteOyM3VJ/xClGUSc1dqKw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUdLTDda; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUdLTDda;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hW0jL5639z2xGr
	for <linux-erofs@lists.ozlabs.org>; Thu, 27 Aug 2026 22:11:02 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 499F6600D4;
	Thu, 27 Aug 2026 12:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAC61F000E9;
	Thu, 27 Aug 2026 12:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787832659;
	bh=g7emBe9EshWdz4d7qczIQdj1HNRKn1jW37LfWnCoVRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TUdLTDdaLGAoQntCs/4R4YwV10F6G+G2kb3ekwuDNw8AlI/EvbDTuzTc8WK7E8mqL
	 ZRGLCrewWJ2jYlCLJaVj6YFZX8Bv4jiv8naazFjgEYfxq2snLS9pFaiu0lHM/CfwOk
	 ZEj2UvyOwWYOIngyA7v7H0W+JulZ2QnQBRyIpqMQV9IzmqPcFsNZXXF4CZYYSf3OQ+
	 jriXbyDxnYZVMUe8KXK0FgXa2nSzXRoIpg5ioyXT28z0SXAYl4qiIIfbQzBwAqtc+q
	 maMXMVCP+H2AGS4UgefOzmopvTlHC/ItdDjrci706HzfMtrkFolkRFy8aMtxO4fopd
	 zyEfqRgHWTk2Q==
Date: Thu, 27 Aug 2026 20:10:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Martin Pitt <martin@amutable.com>
Cc: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 3/3] erofs-utils: tests: check that the xattr layout is
 order-independent
Message-ID: <apApTbxttZN996wk@192.168.5.19>
Mail-Followup-To: Martin Pitt <martin@amutable.com>,
	linux-erofs@lists.ozlabs.org
References: <20260804033214.211267-1-martin@amutable.com>
 <20260804033214.211267-4-martin@amutable.com>
 <ao88F-F9wTDhKjvI@piware.de>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ao88F-F9wTDhKjvI@piware.de>

Hi Martin,

On Wed, Aug 26, 2026 at 09:18:47PM +0200, Martin Pitt wrote:
> Hello again,
> 
> Martin Pitt [2026-08-04  5:32 +0200]:
> > b260119b8edb ("erofs-utils: mkfs: emit an inode's xattrs in a canonical
> > order") made the layout independent of the order listxattr(2) reports an
> > inode's attributes in. Cover it: stage the same tree twice with the same
> > attributes set in opposite order, and compare the two images. The names
> > differ in length and share prefixes, so a subtly wrong comparison cannot
> > order them correctly by accident.
> 
> I see my first [1] and second [2] preparatory patch made it into the tree
> [3][4], but not this third one (and the main test).
> 
> Do you want me to explain or change anything, or did it simply fell through the
> cracks?

I didn't miss this one, there are also other pending tests in my queue,
I need to resolve them all but maybe a bit delay.

It's already merged with very minor changes.

Thanks,
Gao Xiang

> 
> Thank you!
> 
> Martin
> 
> [1] https://lore.kernel.org/linux-erofs/20260804033214.211267-2-martin@amutable.com/
> [2] https://lore.kernel.org/linux-erofs/20260804033214.211267-3-martin@amutable.com/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-tests&id=4b02ea1792c14cb9f250bd55aced5614e699397a
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-tests&id=887ce207bc8b068de9771b736333a8da6d939670
> 

