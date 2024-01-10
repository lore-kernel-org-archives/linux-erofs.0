Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AFCC47073
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Jan 2024 17:35:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4T9FLG0yl3z3cGY
	for <linux-erofs@archiver.kernel.org>; Thu, 11 Jan 2024 04:35:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=stoffel.org (client-ip=172.104.24.175; helo=mail.stoffel.org; envelope-from=john@stoffel.org; receiver=lists.ozlabs.org)
X-Greylist: delayed 584 seconds by postgrey-1.37 at boromir; Thu, 11 Jan 2024 04:34:54 AEDT
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4T9FL60svFz3bPV
	for <linux-erofs@lists.ozlabs.org>; Thu, 11 Jan 2024 04:34:54 +1100 (AEDT)
Received: from quad.stoffel.org (097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 17DD91E12E;
	Wed, 10 Jan 2024 12:25:07 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id A9991A8E30; Wed, 10 Jan 2024 12:25:06 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26014.54002.663705.978220@quad.stoffel.home>
Date: Wed, 10 Jan 2024 12:25:06 -0500
From: "John Stoffel" <john@stoffel.org>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/4] netfs: Don't use certain internal folio_*() functions
In-Reply-To: <20240109180117.1669008-2-dhowells@redhat.com>
References: <20240109180117.1669008-1-dhowells@redhat.com>
	<20240109180117.1669008-2-dhowells@redhat.com>
X-Mailer: VM 8.2.0b under 28.2 (x86_64-pc-linux-gnu)
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
Cc: Dominique Martinet <asmadeus@codewreck.org>, linux-mm@kvack.org, Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Steve French <smfrench@gmail.com>, linux-cachefs@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>, Ilya Dryomov <idryomov@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@kernel.org>, Christian Brauner <christian@brauner.io>, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, v9fs@lists.linux.dev, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

>>>>> "David" == David Howells <dhowells@redhat.com> writes:

> Filesystems should not be using folio->index not folio_index(folio)
                     ^^^

I think you have an extra 'not' in all four patch comments. 

> and folio-> mapping, not folio_mapping() or folio_file_mapping() in
> filesystem code.
