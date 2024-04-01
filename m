Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D1CCD1292
	for <linux-erofs@archiver.kernel.org>; Mon,  1 Apr 2024 13:54:13 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=c29yWJov;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4V7XYc42WTz3dSn
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Apr 2024 00:54:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=c29yWJov;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.73.55; helo=sin.source.kernel.org; envelope-from=horms@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4V7XYR51M4z3bmN
	for <linux-erofs@lists.ozlabs.org>; Tue,  2 Apr 2024 00:54:03 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 7EE14CE10C2;
	Mon,  1 Apr 2024 13:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA0CC433C7;
	Mon,  1 Apr 2024 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711979638;
	bh=dmYCendNfZLK2ZYRN4P3XHXSgHmLS9K4qfGr3Ifd3v0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c29yWJov1MPD3KNJnAc3J10X31RIJx5rJ8pZ9aMASTtRIDHTlXt3YBkMhR/2MmTeW
	 zKg7sKvzusvvzXvEpqIv8nO9JilxGOlGDD9rpErvCQJiT/+cOIdnykZR54Pb5hp73A
	 n3db2XvRlrrFuw27hXNlQVFklZF/bwBt1Tvksi8eyn/LaeBo2QoMfURHysv0Ra+tcm
	 5GNCZFCSDd/aMOWF7fV3ver/b2jE5QU8+WhPmhCzIjV1dmrOHawVXzxIdY9jTI6kkp
	 3RzhX7bCaKGHmMTJC3G9ZTma+EDhOVW6r/AdWBj3gvJJLSd3U3a0S7GGRMCCfrXnpN
	 BcEw/0JlvpOew==
Date: Mon, 1 Apr 2024 14:53:51 +0100
From: Simon Horman <horms@kernel.org>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 26/26] netfs, afs: Use writeback retry to deal with
 alternate keys
Message-ID: <20240401135351.GD26556@kernel.org>
References: <20240328163424.2781320-1-dhowells@redhat.com>
 <20240328163424.2781320-27-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328163424.2781320-27-dhowells@redhat.com>
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
Cc: Dominique Martinet <asmadeus@codewreck.org>, linux-mm@kvack.org, Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Steve French <smfrench@gmail.com>, linux-cachefs@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>, Ilya Dryomov <idryomov@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@kernel.org>, Christian Brauner <christian@brauner.io>, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, v9fs@lists.linux.dev, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Mar 28, 2024 at 04:34:18PM +0000, David Howells wrote:

...

> +void afs_issue_write(struct netfs_io_subrequest *subreq)
>  {
> +	struct netfs_io_request *wreq = subreq->rreq;
>  	struct afs_operation *op;
> -	struct afs_wb_key *wbk = NULL;
> -	loff_t size = iov_iter_count(iter);
> +	struct afs_vnode *vnode = AFS_FS_I(wreq->inode);
> +	unsigned long long pos = subreq->start + subreq->transferred;
> +	size_t len = subreq->len - subreq->transferred;
>  	int ret = -ENOKEY;
>  
> -	_enter("%s{%llx:%llu.%u},%llx,%llx",
> +	_enter("R=%x[%x],%s{%llx:%llu.%u},%llx,%zx",
> +	       wreq->debug_id, subreq->debug_index,
>  	       vnode->volume->name,
>  	       vnode->fid.vid,
>  	       vnode->fid.vnode,
>  	       vnode->fid.unique,
> -	       size, pos);
> +	       pos, len);
>  
> -	ret = afs_get_writeback_key(vnode, &wbk);
> -	if (ret) {
> -		_leave(" = %d [no keys]", ret);
> -		return ret;
> -	}
> +#if 0 // Error injection
> +	if (subreq->debug_index == 3)
> +		return netfs_write_subrequest_terminated(subreq, -ENOANO, false);
>  
> -	op = afs_alloc_operation(wbk->key, vnode->volume);
> -	if (IS_ERR(op)) {
> -		afs_put_wb_key(wbk);
> -		return -ENOMEM;
> +	if (!test_bit(NETFS_SREQ_RETRYING, &subreq->flags)) {
> +		set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
> +		return netfs_write_subrequest_terminated(subreq, -EAGAIN, false);
>  	}
> +#endif
> +
> +	op = afs_alloc_operation(wreq->netfs_priv, vnode->volume);
> +	if (IS_ERR(op))
> +		return netfs_write_subrequest_terminated(subreq, -EAGAIN, false);
>  
>  	afs_op_set_vnode(op, 0, vnode);
> -	op->file[0].dv_delta = 1;
> +	op->file[0].dv_delta	= 1;
>  	op->file[0].modification = true;
> -	op->store.pos = pos;
> -	op->store.size = size;
> -	op->flags |= AFS_OPERATION_UNINTR;
> -	op->ops = &afs_store_data_operation;
> +	op->store.pos		= pos;
> +	op->store.size		= len,

nit: this is probably more intuitively written using len;

> +	op->flags		|= AFS_OPERATION_UNINTR;
> +	op->ops			= &afs_store_data_operation;
>  
> -try_next_key:
>  	afs_begin_vnode_operation(op);
>  
> -	op->store.write_iter = iter;
> -	op->store.i_size = max(pos + size, vnode->netfs.remote_i_size);
> -	op->mtime = inode_get_mtime(&vnode->netfs.inode);
> +	op->store.write_iter	= &subreq->io_iter;
> +	op->store.i_size	= umax(pos + len, vnode->netfs.remote_i_size);
> +	op->mtime		= inode_get_mtime(&vnode->netfs.inode);
>  
>  	afs_wait_for_operation(op);
> -
> -	switch (afs_op_error(op)) {
> +	ret = afs_put_operation(op);
> +	switch (ret) {
>  	case -EACCES:
>  	case -EPERM:
>  	case -ENOKEY:
>  	case -EKEYEXPIRED:
>  	case -EKEYREJECTED:
>  	case -EKEYREVOKED:
> -		_debug("next");
> -
> -		ret = afs_get_writeback_key(vnode, &wbk);
> -		if (ret == 0) {
> -			key_put(op->key);
> -			op->key = key_get(wbk->key);
> -			goto try_next_key;
> -		}
> +		/* If there are more keys we can try, use the retry algorithm
> +		 * to rotate the keys.
> +		 */
> +		if (wreq->netfs_priv2)
> +			set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
>  		break;
>  	}
>  
> -	afs_put_wb_key(wbk);
> -	_leave(" = %d", afs_op_error(op));
> -	return afs_put_operation(op);
> +	netfs_write_subrequest_terminated(subreq, ret < 0 ? ret : subreq->len, false);
>  }
>  
>  /*

...
