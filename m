Return-Path: <linux-erofs+bounces-2133-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965F3C44500
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 08:33:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxZ8H0sJrz2yFm;
	Thu, 22 Jan 2026 19:33:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769070799;
	cv=none; b=TVWWhBfaLcRewccXrix7uIPkMf9JwNQ/1lwFNhyXrBgJ5bP6sfg14cDF2VBX7lkKxvtakLka6NCroAssKSKWPYYS6/Bb7JgyCHGfPk9qtwOwwWkXtcKamuL02AJwAZgtc33ppCJfUGmn78UUD0mO+NTkQ4jwxt2DbjB5sqrR+2TLVHYFNSqJD40R6mTlaeGbfEKaUfrfaopeo7fTrl6zT5PbSunh0F4yWzqDvgq4nwP/Ax8StMLMzeMjREDadV4ASZvgFWT8goJNRHX7CxFOfT5kU4Y1e7HfApwqv5fO67hynQY/oeKgsuY4QOA0lK0zSpJHTgQJz8EDOPrQl2dnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769070799; c=relaxed/relaxed;
	bh=cUoCZ/yPHd1Cmv2T8GhVS6WPmxJlXtwAz38Ylt51ijY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=az/8j2Aaecg8EMmnP8qXtUBTN/qeYUiZDhOKcqVH8Q7HZvGIuJ+5yE3Rv4JVb41QzLhaBwG1P/vtmgu8ooRyxOFvt913hmvmzveMi0xcKkCiJlvikAqn6L8/NcNBjK5WMHPy0cY0nF8+lb8IkKP2KG2/eMW3IskAplUnqwoqtn9RTqSR2ZtqDLseu2mbGmof6NgRTArw6avNgB3d9Z9IRxFRDjeSH/3m06I9sm0HtVK9NLwxgR93OpZwzRwLrd5OB3nAr28KKWv2oLIqPOtlf44/xAbvkIdYj9QJ+wsJFeEa8j/WR+nwIsacYx9kdqY666fjGFjKP8wYXcdqhr1BEg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxZ8F6BtJz2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 19:33:16 +1100 (AEDT)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A2E6B227AB6; Thu, 22 Jan 2026 09:33:10 +0100 (CET)
Date: Thu, 22 Jan 2026 09:33:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>, Hongbo Li <lihongbo22@huawei.com>,
	chao@kernel.org, djwong@kernel.org, amir73il@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH v15 5/9] erofs: introduce the page cache share feature
Message-ID: <20260122083310.GA27928@lst.de>
References: <af1f3ff6-a163-4515-92bf-44c9cf6c92f3@linux.alibaba.com> <20260119072932.GB2562@lst.de> <8e30bc4b-c97f-4ab2-a7ce-27f399ae7462@linux.alibaba.com> <20260119083251.GA5257@lst.de> <b29b112e-5fe1-414b-9912-06dcd7d7d204@linux.alibaba.com> <20260119092220.GA9140@lst.de> <73f2c243-e029-4f95-aa8e-285c7affacac@linux.alibaba.com> <50db56b8-4cf9-4d62-b242-c982a260a330@linux.alibaba.com> <20260120065242.GA3436@lst.de> <5892c7bb-f06e-45d7-ad84-99837788e5ab@linux.alibaba.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5892c7bb-f06e-45d7-ad84-99837788e5ab@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 03:19:21PM +0800, Gao Xiang wrote:
>> It will be very hard to change unless we move to physical indexing of
>> the page cache, which has all kinds of downside.s
>
> I'm not sure if it's really needed: I think the final
> folio adaption plan is that folio can be dynamic
> allocated? then why not keep multiple folios for a
> physical memory, since folios are not order-0 anymore.

Having multiple folios for the same piece of memory can't work,
at we'd have unsynchronized state.

> Using physical indexing sounds really inflexible on my
> side, and it can be even regarded as a regression for me.

I'm absolutely not arguing for that..

>>> So that let's face the reality: this feature introduces
>>> on-disk xattrs called "fingerprints." --- Since they're
>>> just xattrs, the EROFS on-disk format remains unchanged.
>>
>> I think the concept of using a backing file of some sort for the shared
>> pagecache (which I have no problem with at all), vs the imprecise
>
> In that way (actually Jingbo worked that approach in 2023),
> we have to keep the shared data physically contiguous and
> even uncompressed, which cannot work for most cases.

Why does that matter?

> On the other side, I do think `fingerprint` from design
> is much like persistent NFS file handles in some aspect
> (but I don't want to equal to that concept, but very
> similar) for a single trusted domain, we should have to
> deal with multiple filesystem sources and mark in a
> unique way in a domain.

I don't really thing they are similar in any way.


