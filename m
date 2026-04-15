Return-Path: <linux-erofs+bounces-3306-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94330F9D0FD
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Apr 2026 02:07:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fwPfW05yTz2yvL;
	Wed, 15 Apr 2026 12:07:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776218834;
	cv=none; b=IiOjHZ6xwCCtZUaf5eWGuE/OE8aiQUqFXBovKI1JHDKJyB3EaPcY6ND0zEYzJcx3HFZvT1EWNw5cAF/TGPekY4kerHiPxFmxG1fRQpVkOrsbdGZQcAXCh1fp/+8tGIDjFyz7SU+dxoOZJ+lafOEIttGNqeikg7ZyGdoJVjPR/EU3nlp0SqCQfTgVVZbilKwvps4/2XteFjEQcFPMqLWXtFwdLFu1UTXZMIwKsltPAHxlu20DvFhFGZdTl6Ex1gBTG2vOOcci9FUYg0aDO4+Pm/9pRG+syWk/9nkJcVLnC7RRw5xKi/X+2/ct4LJZVzknNRZRrL6YOXVNBuMSnYSGyw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776218834; c=relaxed/relaxed;
	bh=jIbPylvgbC3xc5iwZFZMWLK0WvUqD6pG2kztaLMvMMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6jJtqOz/jVLUOCTCg9Dd9y3YHF8rQMre2kRt/fz0u7g9190FLmQqD13x0XcMas74IxcWtvi49e3oXz/rpM2/Jg6E/JrTN3joenpEKMdWOSIbrh7zXuEvPukB89J7dOmdB2Xfw6PqRjEEh0dRZQudXMNMu7pwKY22FSV4l8l7b8rLSClNgI0jjzTy4CXpGH6KrEeViGTyTN/BIogxlLUuYk8w2Z70fVuTntaOk5UkpbvF0eWfk5DSZLXs8HGBcrsD01Werz4bYg8ITcFIFvx7cghWgmHx4peiTYqCIbv2EWk4EmsWP6WjAtg96LkgTpOWDHjcSGspmhFZ7KFLg8ssA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WzUoc8Yh; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WzUoc8Yh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fwPfT0FJ8z2yrt
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Apr 2026 12:07:11 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776218827; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jIbPylvgbC3xc5iwZFZMWLK0WvUqD6pG2kztaLMvMMA=;
	b=WzUoc8Yhw0O+/w/aDwkja+J2FMKAY4FM/jobuehBPYeefmpjQorcBIYps9JIMCfcue+0yxYdYrr4rZtDwelix43iLkmO7l9AGPQ4cBqSVQcL8fbNr1Rlo1hri9WIqk+PChzDu8A4p4yrKbX5DPtPt/eshmX4FA/pKo2BXCcC1Bs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X12zihG_1776218825;
Received: from 30.221.132.134(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X12zihG_1776218825 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 10:07:05 +0800
Message-ID: <c91f39f7-4563-4514-b1dc-437ceb81423e@linux.alibaba.com>
Date: Wed, 15 Apr 2026 10:07:05 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] erofs-utils: implement the FULLDATA rebuild mode
To: Lucas Karpinski <lkarpinski@nvidia.com>, linux-erofs@lists.ozlabs.org
Cc: jcalmels@nvidia.com
References: <20260414-merge-fs-v3-0-266bd1367fd2@nvidia.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260414-merge-fs-v3-0-266bd1367fd2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/15 03:10, Lucas Karpinski wrote:
> Currently, erofs-utils supports backing blobs for multi-image setups.  This
> implements the FULLDATA import which allows for the merging of multiple
> source images into a single self-contained erofs image.
> 
> To optimize the rebuild process, erofs_io_xcopy() is used to leverage the
> copy_file_range(2) if available. This bypasses userspace buffering and
> enables kernel side data transfers.
>   
> Verification: Built same image with default rebuild and rebuild with
> FULLDATA. Then ran F-i-f/tdiff comparing the two.
> 
> changes in v3:
> - adhere to uniaddress semantics.
> - take advantage of existing infrastructure which allows us to drop a
>    significant amount of complexity + code.
> 
> changes in v2:
> - reworked erofs_rebuild_load_trees_full into
>    erofs_mkfs_rebuild_load_trees.
> - removed --merge option (use --clean=data instead).
> - updated man.
> 
> Signed-off-by: Lucas Karpinski <lkarpinski@nvidia.com>

Overally looks good to me, will apply to -experimental branch.

... Would you mind taking some time working on some tests
in experimental-tests branch?

Thanks,
Gao Xiang

