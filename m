Return-Path: <linux-erofs+bounces-3800-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73188C43458
	for <linux-erofs@archiver.kernel.org>; Thu,  2 Jul 2026 10:27:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4grY3T3kp5z2xLk;
	Thu, 02 Jul 2026 20:27:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782988037;
	cv=none; b=CrfEjDx5G0VyH9twyyGiD74L5riE29ep4dePF4aV4TJxs6bNVTIn6BKRDciGHDDxZm01DHEhMYnTWt/GSmTOY7s4emIPviTzKPn9o6OXRrpPd5jQmTPXmx03dFa0t/g12xWzb3KYtEp9z/gtRHTW21FUawkqPcPgpEsYGTPcgTKka5RWk7el4G8rEsxbj+FxsEhQtMXXupHdi8k4YiqcLPHa3ycivJw0X0RaeTCTLVwNsq9Xmjzw7Olp7t5iCEGP9sRiNChks/2Q2qlfFlLtdwDMoBrbYvsB4pjvVp5t4ut+HUpQx6b4oUxOaFeh/HNuytXTnHi9X3NlcoB/5j+tNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782988037; c=relaxed/relaxed;
	bh=2QSpOHJ4tbguE1GPlnnA7Qo/MJflg19F6M7cmaJHNU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrXGqKSaGclTnNwgL8Tn1tixru3Fdrox6OcN1g39TxRn5k0X3QvC3Cxt+5gzW7enKU/MGo/M5m4LmeC8+qSQ26/j4+0ZORm9D8ZPpARWGlq2wLWAeCD/YnhwoFWgvmbiNm5X0rbup59HJjmoDuoHRKiMfzt1tVRSeBQP179nEgdzS42gstep0H4vDQ6pNKc+zeAlzSYXabd166UaHKx+rqlzkWFaeX3FNGXRYJkFIrxNq7XFBbwo3wapnvBChJUnosWTfaFmJHvi7OV1u6IlMHqSkkXBRzabnhLLyB3st5xjsMiK9Hf9ADmHjWdtK5s7WQDPHoaQMwsbnh1RE/IvGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4grY3S06fXz2xJT
	for <linux-erofs@lists.ozlabs.org>; Thu, 02 Jul 2026 20:27:13 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 35C9B68BEB; Thu,  2 Jul 2026 12:27:06 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:27:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: consolidate bio submission
Message-ID: <20260702102705.GB6252@lst.de>
References: <20260629121750.3392300-2-hch@lst.de> <20260701-davon-kniegelenk-gedehnt-96476b242a09@brauner>
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
In-Reply-To: <20260701-davon-kniegelenk-gedehnt-96476b242a09@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 01, 2026 at 03:27:40PM +0200, Christian Brauner wrote:
> Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> Patches in the vfs.fixes branch should appear in linux-next soon.

Hmm, both this mail and the merge commit in git reference the first
commit instead of the cower letter.  Is there an issue with your
automation that made it miss the cover letter?

