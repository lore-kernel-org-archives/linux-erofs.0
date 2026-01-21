Return-Path: <linux-erofs+bounces-2107-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FCDACA5FBA
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Jan 2026 04:10:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwrMx0Jm9z2yDY;
	Wed, 21 Jan 2026 15:10:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.168.172.138
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768968652;
	cv=none; b=FOG7fvd5ucOL5//VLE4k2Fl5z7VVfdTYIUqVsFEc8/y8vUjLIAayFQsZp3DgJyj6HQHHiEDemk6lg8RPXqSIkA0LM2kiU2MnQIMekxWAn1F69VxzyTR1RD6FU//S0hVMkyQrZ26dLiEC3KKRkcnwrKfeDzPYxincIJNLkfH8/G/WHxE1slgbEY6kzoq5C5lxQX/5aBcOdHn/MmHZVxjNeCyJ56nm2AwGhBwAQLQlqbj77MJI/kIIEnILbaZgRXiKBdIUnIpDb2w9pM41bdLL8n0cbxmQtLpGdUIYEaEPKTrbKZ9zdbvIWbVkdaKiGRdrrJYcPqlgHBUS2yVvwWvAfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768968652; c=relaxed/relaxed;
	bh=VHtydnr8fLS7IJeEIN+Bebc9EhZyuKs8Mrygf/E6Mwk=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=AE+IiPMwYcRwM5YJjNweJgNfjBs931SaOhQp3XOYjfBalKw90jpMIaK1p0oGkSqa98H1Pg9cMELxs4aPhwDTu2hEcbaqScxuqWyd+WqLGzi1xWj03/K2MkR978KqC/n+/u2SFurKXKR7+0ZrqdzIUz9RPGEzy6ttCkrfhS5FlElhFn4jrSmYr1tUwD1s9bUJQQ30i2qt5AfYyDWaeIt0oLlJ/rnR6slTmuU4+ifqV/LV5L7aSK/XEnzpo+GfqQNjQ2wYFaxbu+51Usn7ylfP/wA5zajh5AirTdw+KSot/I5uxIWC6/CvkAYbdYl5g9pG6lUp6zVGzUCLA9ueJW+izA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; dkim=pass (2048-bit key; unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=k3Rxmu5u; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=gAJ0npOh; dkim-atps=neutral; spf=pass (client-ip=103.168.172.138; helo=flow-a3-smtp.messagingengine.com; envelope-from=neilb@ownmail.net; receiver=lists.ozlabs.org) smtp.mailfrom=ownmail.net
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=k3Rxmu5u;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=gAJ0npOh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=ownmail.net (client-ip=103.168.172.138; helo=flow-a3-smtp.messagingengine.com; envelope-from=neilb@ownmail.net; receiver=lists.ozlabs.org)
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwrMv5Sqhz2xqD
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 15:10:51 +1100 (AEDT)
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id CDA9513807C6;
	Tue, 20 Jan 2026 23:10:49 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 20 Jan 2026 23:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768968649; x=1768975849; bh=VHtydnr8fLS7IJeEIN+Bebc9EhZyuKs8Mry
	gf/E6Mwk=; b=k3Rxmu5uR9LzcxYLB3t0g9OZO0rJkXHWHzZwWU2baOA0T+BauMb
	JVwdNn8FXLcfJjWpT/PesgXD8rWNCNVfalot0ujFj+m9iIfbTfXgug2Q3yJqrVyB
	8eJIYj37xg9eo1bP9zpmammhxmuGoBzvKOGPf5Qihx0i4Xtur2zoOlGt4VqfI2Aq
	VcQiUYFS9VLDwzq7PFAV47UiRi8Z6ewfEdkzCtfuUcbBtYGQ4REwO/NQfx0wGxZa
	zaqsbkKg/7unaAaTepYNC7FeekN9e3dyldZZ6WnZ81ri0JmX1JvDTDOyA9r/um3Q
	0UTk91MwX8RKLgf76R+Fpg0kqrT6VIZzfKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768968649; x=
	1768975849; bh=VHtydnr8fLS7IJeEIN+Bebc9EhZyuKs8Mrygf/E6Mwk=; b=g
	AJ0npOh094R5rlQ+lB6V86VTqskShc/USfs9jmX1TOsWUZfsPdWnx0W03o0QsD0J
	ole/Eq8d6vjOz/TwgxXAi4GUViQNE7aP9SFrw1QS88PkqsRNgUMpp2Dsk75jigEL
	Tq3UezOIFJ8hQFHcKj89Ey79saQSKP0MwkW63MgMtbV/mnNXN/xKVwew/W1KuJOB
	UtSIMWwNUT/KJ08KW4iRnFlHq35eiupz+giAs+7ptzAfWnDBN/iL/8qtRpNmSEaA
	7+qwUSVwzkTj44zrlBWH3L4VcAF8ddte590kdslQTISEXKuf5ZNRlxQrYy4fTjd4
	+bXU8lH/3WUCP5TODW9mQ==
X-ME-Sender: <xms:x1FwaXcQqjPpSgnEH0JKgQq9qBmBgEL4xriEE0RJAFk0DGbOHo3GJQ>
    <xme:x1FwaRGn5TWEli8N0_6q7i-Js7HZaHfbVLccEQrr6Mlj8opNJxVvGV2IOF4DACpZJ
    67k8djIbKVq6CJIz8sMWvyebtGqxQwHb9fq0iYg9h6RLbhG>
X-ME-Received: <xmr:x1FwaeOCYluQbHVqHC0b8yb2QyAzu4oYGvwgfL3Rv1YcRePq4NfK1L8su9uzG-K39Rf20ZSVJLGZZZsgDaJ4alcLa9ozRYjqUp45LbFlfXWe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedvvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epudetfefhudevhedvfeeufedvffekveekgfdtfefggfekheejgefhteeihffggfelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtohepghhuohgthhhunhhhrghisehvihhvohdrtghomhdprhgtphhtthhopehl
    ihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidquhhnihhonhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhnihhlfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:x1FwaR8X47pB82llCoOnx-_tqfG4Wgl__nF7iR7DTsvnBKEgoxWWLA>
    <xmx:x1FwadL_4AgUdEoAdrrjBUzKm_QwvAZ5_vABwDi-yZXKOEZQmRVN-g>
    <xmx:x1FwacjsPmz0p5xJHKbK1Llgy6XHSkD5sIUV00neAVndqU1R0osl9Q>
    <xmx:x1FwaQ-U7Yh5HcQNL5v5YvAtJgbgLMSzKZeFpndI7b9KPjw4FZERdA>
    <xmx:yVFwafa--UBBDa_lEtTQJ8XgCJ_3LeDDEGWDRnQKAI7NA5gXIajXqhW->
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 23:10:25 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
From: NeilBrown <neilb@ownmail.net>
To: "Jeff Layton" <jlayton@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>,
 "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.com>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Ilya Dryomov" <idryomov@gmail.com>,
 "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>,
 "Luis de Bethencourt" <luisbg@kernel.org>,
 "Salah Triki" <salah.triki@gmail.com>,
 "Phillip Lougher" <phillip@squashfs.org.uk>,
 "Steve French" <sfrench@samba.org>, "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>,
 "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Ryusuke Konishi" <konishi.ryusuke@gmail.com>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Dave Kleikamp" <shaggy@kernel.org>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Richard Weinberger" <richard@nod.at>, "Jan Kara" <jack@suse.cz>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
In-reply-to: <9fdf7a8c04861306b453a78233f4bd6004c465f4.camel@kernel.org>
References: <>, <9fdf7a8c04861306b453a78233f4bd6004c465f4.camel@kernel.org>
Date: Wed, 21 Jan 2026 15:10:22 +1100
Message-id: <176896862299.16766.6206046829320088529@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Mon, 19 Jan 2026, Jeff Layton wrote:
> 
> There is another approach we could consider: We could move the
> export_operations that are needed for local filehandle access into a
> new struct filehandle_operations or something. It does mean adding an
> extra pointer to the super_block for the new operations vector, but it
> might be more intuitive.

If that sort of change were seen to be valuable, I would rather not
create a filehandle_operations but merge some (or all) of
export_operations into super_operations.
Maybe then the existence of s_export_op would return to mean "NFS export
supported" even if it is empty.

Thanks,
NeilBrown

