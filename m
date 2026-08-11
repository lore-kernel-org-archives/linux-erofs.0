Return-Path: <linux-erofs+bounces-4190-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA79C5AC67
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 07:27:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hK39C1sfYz2yvG;
	Tue, 11 Aug 2026 17:27:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786433231;
	cv=none; b=afwkwjf8Yzc7cEwUHDIXQObq7bBYYV/PpAdg/TWl8RSULk2R0VrNO0EGPBzAvCQ7kVVajNToActq1iUhPV/xsXqzkvhfIndNHwQdRs9U7BaI4znvbMxvQxd2c8g1EvIMwqy15GT5Jhp7w/3pkiktSpG7IqOIf3pxF8hVUSTtEdVyQ3fpRd2jIMgr2NkeG6ftwhN1yalnbg+V/QdVg7XIQ+WhmiNzLRLnpfjG+bZZ+93QNlvWKD/bQMY1mstgwl1SKcS2pxF0aCs8b2hZZs55Eb2h5b4maOXpbj7PK6montkSpbUxW5LE8cundXxZNlkCgXLBEVJuxVP/+nrhKtfsaA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786433231; c=relaxed/relaxed;
	bh=K66bNXWEf3y6O/2oqZ+5XO0lv/SJwQqJyQa/tQNc0AA=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=E5ttWtbBednn06PCGdNCHOWXBQRFAmBg6IureY3cXrztIW1D45LirmdSJ7IK3KYbN6OQ0ZCqdn+xZJEXj/bGKws8J3ECAT/MYCl9HB27JhzAqC2hEPNbkuVDsUcQpgJNazdx8ZgUz1gjXHqPKy+UKS9r+dfRsTLJVzBle4b9g+77waExzUJIpsYUkCsIV16YScSmal2c/18SPzfub8nFeZqEXqUzYyvn2ZlZidUQqJABOt5RrYfsDDQtIUMTTQb/BYwiXUc2P15+cVs2ziGrw7AzxhIVAzlvi/jy/2O1zwX7XzM2JnK7kqf6/DaMK4mKXEfzO5oaKGu9JZackVgRAA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jyhX1YFr; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jyhX1YFr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hK39B3fh1z2yrL
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 17:27:10 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 503C840787;
	Tue, 11 Aug 2026 07:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881E11F000E9;
	Tue, 11 Aug 2026 07:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786433226;
	bh=K66bNXWEf3y6O/2oqZ+5XO0lv/SJwQqJyQa/tQNc0AA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=jyhX1YFrrnq1wTxRvMX2adEyfpPN3v/LJ7/qtkjf+TYdWFsYYIcugMNXAPa+bsGb/
	 K/t7nFn3T7LYAgj/TynmyrcK3PZxbWxXlwHLiiQ/Y4kFCPNuv5IEcYsHUfdEiW+Pxp
	 2RhUyax+NkA0059s4IyvBX9JhRD7NVUe85TJCyjg2CMsC5MBqQh8WBd5CwGBSBdCdn
	 GQxT+li/hISZxCSp6HCFTAYrjNCgXdi7JRHv3tHOS34+Nlo8+p2FgK40/y3WWGPwhg
	 Nkpi9xSZrGb1Uc0q5QOmLvYqQAzyBiUYoHN0fp5YJ46Or6u9LTuAuZTuOub0fsdPN0
	 xQoweGsA1+/VA==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v9 00/26] netfs: Keep track of folios in a segmented
 bio_vec[] chain
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, 
 Christian Brauner <christian@brauner.io>, 
 Matthew Wilcox <willy@infradead.org>, Paulo Alcantara <pc@manguebit.org>, 
 Jens Axboe <axboe@kernel.dk>, Leon Romanovsky <leon@kernel.org>, 
 Steve French <sfrench@samba.org>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
 Marc Dionne <marc.dionne@auristor.com>, Stefan Metzmacher <metze@samba.org>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev, 
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <annlWwsCPjNgcKa-@infradead.org>
References: <20260810144746.574036-1-dhowells@redhat.com>
 <annlWwsCPjNgcKa-@infradead.org>
Date: Tue, 11 Aug 2026 09:26:58 +0200
Message-Id: <20260811-wegkommen-unfehlbar-selektiert-547aaf3c775b@brauner>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=600; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SbLo78Cr2HW2DkoM+Zu8uqrpTL6/jkg7YGLG/5Ws134=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRVnTv6756TAWNwzpYbp6uPrDGo4imQ/fbk+jW7DUsuL
 b71cnIze0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEFv5n+KftNFM8KmD21nd8
 72qdX0/+//vls7jriRGWqee6nD1evXJi+Kef+vzIchGNyFqW00a/fZW2Xk22O79bdrrI22h3iYi
 zz9gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> this is a bad idea.  This is a giant series that also touches core code
> with no review whatsoever.  And I repeatedly asked for:

Since it's post the cut off point the series does not make the coming
merge window. It's also not in -next on purpose. The series was just
pulled for testing.

> 
>  1) the core changes to be split out
>  2) come up with users for this very core primitive in the hot path
>     (iov_iter) that are not just for your rather niche use case
> 
> There's been absolutely no follow on to this, and we should not treat
> the absolute core I/O path like this.


