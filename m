Return-Path: <linux-erofs+bounces-4151-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59A0C5AD55
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 13:12:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJZtG11W3z300M;
	Mon, 10 Aug 2026 23:12:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786367558;
	cv=none; b=UcfrbHsSFh4Ufmf/GvgpCBNBmmOGj/JZGMWiDQ1AnWbob8C9bsaP5Savd1gWWRUTNwEP3VirDp4A+a+QMbFd7LlNIXd0/ogjnrTC9LvmxCSvL2JmtfrCWNFsXudslVPnBcPz7X1Cp4J2I0eqxp2l0rFIY7dFqurLPKFj/C3NH9g5ETi6PSE1DcLRMGAjHNDBLV6sHMFNE6oJphGnby50wqY51JlH3OhfEsrTwP8k9Ofzu870obnRVlSvJpRbVWnu59UgZL4QTaGUS/M/jPJxishaaaEh/NmKcHxMMtU6T+Tmcb3j6fMqqn4IgUGlXakL9SvIlXV82ydLU8f8uo4qkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786367558; c=relaxed/relaxed;
	bh=gzwFhtE0Ek2LlVIsTwETJaTv5SvMI/8Bx08qLe2Vxtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HEJ6OCPr42VEnTswYPPFTlEGgoWh2mciPLTcnkXmy65auCMiSRLBgaCi3trHxMhC5OJYx2zuLn44Xvf012mxBAMk8PPjjoJmLYOsMKAwFArh5MiiwT3w43fesozltvnLIeVWdkfclGI60uxEKgShswl9Us7U2p8JVpCzbiWlciLh63oehFYb+4kXx3QhRrGLvjOH/MhIl1S+bdGZlkw7wBTKCDkpQJqjjdGS8VlF/Phc6XgJTFR2fntVKfKQuQfOLsmKQS5Z8QXIipoVykoAqZhHNl6IZ/10PHNMmlXgkCpxIaWKuLGu9dim0m5wwgCbuNFu9X1jL5p5/+4V6ibCmA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gD7tKxwY; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gD7tKxwY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJZtD5k6Wz2xRs
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 23:12:36 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E416760120;
	Mon, 10 Aug 2026 13:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B801F000E9;
	Mon, 10 Aug 2026 13:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786367553;
	bh=gzwFhtE0Ek2LlVIsTwETJaTv5SvMI/8Bx08qLe2Vxtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gD7tKxwYhcI7DHlrAioW2qhKgIAABui+x7xOWM4yNge/+pxISG8Prmuy7Nw1PWEo8
	 h0IXKke3j8f3JhEchHd2VYAiFknegfIvqbj3fZvne9Z4HdzC/03nUZtBJ3AOBDzi81
	 hmRrKeUHFkWBTJtgJ0EWBy5jiJS6xIgAOu56flgrDCUqxAJJ5fc0PbJZSysDPVWS2s
	 kMoQfcWZGyQuL/xvmYbiBn3teBRTbCUUa9+nLUu3qTZQke/zsjObGWHu7PyyAjg6TY
	 XPEotAtFQm884B2uRvPVe+xj3Qo8xDW3CUdlrdupZzS2yqdcUNZodAqzXiW3qvf52C
	 AbGgrCKjIgvcw==
From: Christian Brauner <brauner@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/25] netfs: Keep track of folios in a segmented bio_vec[] chain
Date: Mon, 10 Aug 2026 15:12:23 +0200
Message-ID: <20260810-luftdicht-popmusik-hypen-61dd8d9e3c06@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804100224.2748935-1-dhowells@redhat.com>
References: <20260804100224.2748935-1-dhowells@redhat.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3993; i=brauner@kernel.org; h=from:subject:message-id; bh=H4bkzjyn5PYFF1fjCINLDBhQNmdAHkuGSmghaii28ks=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRVnrN4Erc35H3fhn/clms7GJ4uEZWeJhcuUrNrW+arA JGQ3SaJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABfhYPinGptzyGzilt/72nwE E3ab2vZrKqdG7hRYYeuScWP2gbQTjAwHlysWdRuZxNts5j2tfWFGkW/arCzbN+KvBaYoVvILruU DAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 04 Aug 2026 11:01:55 +0100, David Howells wrote:
> Could you add these patches to the VFS tree for next?
> 
> The patches get rid of folio_queue, rolling_buffer and ITER_FOLIOQ,
> replacing the folio queue construct used to manage buffers in netfslib with
> one based around a segmented chain of bio_vec arrays instead.  There are
> three main aims here:
> 
> [...]

Applied to the vfs-7.3.netfs branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.netfs branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.netfs

[01/25] mm: Make readahead store folio count in readahead_control
        https://git.kernel.org/vfs/vfs/c/bb16bd52f872
[02/25] netfs: Bulk load the readahead-provided folios up front
        https://git.kernel.org/vfs/vfs/c/49fe2955409b
[03/25] Add a function to kmap one page of a multipage bio_vec
        https://git.kernel.org/vfs/vfs/c/71947db0b6b2
[04/25] iov_iter: Make iov_iter_get_pages*() wrap iov_iter_extract_pages()
        https://git.kernel.org/vfs/vfs/c/fc0f8aa28cb0
[05/25] iov_iter: Add a segmented queue of bio_vec[]
        https://git.kernel.org/vfs/vfs/c/b7eab1a852c3
[06/25] netfs: Add some tools for managing bvecq chains
        https://git.kernel.org/vfs/vfs/c/a8e973126d3f
[07/25] netfs: Make mempool available for bvecq
        https://git.kernel.org/vfs/vfs/c/c95787e047bf
[08/25] netfs: Add a function to extract from an iter into a bvecq
        https://git.kernel.org/vfs/vfs/c/8854b625d977
[09/25] afs: Use a bvecq to hold dir content rather than folioq
        https://git.kernel.org/vfs/vfs/c/acb8eed74013
[10/25] cifs: Use a bvecq for buffering instead of a folioq
        https://git.kernel.org/vfs/vfs/c/b0d72aea6001
[11/25] smbdirect: Support ITER_BVECQ in smbdirect_map_sges_from_iter()
        https://git.kernel.org/vfs/vfs/c/27a6832d7b93
[12/25] netfs: Remove the writethrough code
        https://git.kernel.org/vfs/vfs/c/de4a0d855ae3
[13/25] cachefiles,netfs: sunset ondemand mode
        https://git.kernel.org/vfs/vfs/c/3b09163b7bed
[14/25] cachefiles: Don't rely on backing fs storage map for most use cases
        https://git.kernel.org/vfs/vfs/c/f3ac229c89a0
[15/25] netfs: Add the cache object ID to netfs_read/write tracepoints
        https://git.kernel.org/vfs/vfs/c/592472ff5a77
[16/25] netfs: Switch to using bvecq rather than folio_queue and rolling_buffer
        https://git.kernel.org/vfs/vfs/c/4c9ea0ae64f9
[17/25] smbdirect: Remove support for ITER_FOLIOQ from smbdirect_map_sges_from_iter()
        https://git.kernel.org/vfs/vfs/c/c9529300bd22
[18/25] netfs: Remove netfs_alloc/free_folioq_buffer()
        https://git.kernel.org/vfs/vfs/c/bc89b7f32adb
[19/25] netfs: Remove netfs_extract_user_iter()
        https://git.kernel.org/vfs/vfs/c/e533d0d598c4
[20/25] iov_iter: Remove ITER_FOLIOQ
        https://git.kernel.org/vfs/vfs/c/ca929d6a6044
[21/25] netfs: Remove folio_queue and rolling_buffer
        https://git.kernel.org/vfs/vfs/c/6440cb5fd08b
[22/25] netfs: Check for too much data being read
        https://git.kernel.org/vfs/vfs/c/353f336ead13
[23/25] netfs: Limit the minimum trigger for progress reporting
        https://git.kernel.org/vfs/vfs/c/0150b23b0a63
[24/25] netfs: Combine prepare and issue ops and grab the buffers on request
        https://git.kernel.org/vfs/vfs/c/473527604b71
[25/25] cachefiles: Preset the state xattr when creating a new file
        https://git.kernel.org/vfs/vfs/c/9476c221814c

