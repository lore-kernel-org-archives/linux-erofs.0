Return-Path: <linux-erofs+bounces-3074-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A604DF3D5FF
	for <linux-erofs@archiver.kernel.org>; Sun, 29 Mar 2026 10:36:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fk9lq6cQJz2yYs;
	Sun, 29 Mar 2026 21:36:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a01:4f8:192:486::2:0"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774780583;
	cv=none; b=GzqEmAt+UAy/1wXS5VZSRteEaVaIQsohsWaJAVFRutHXGLATQ7cRYvTRs5bTualimWIsIcx8SYSuozOPskQzdQ5LrG9QsG+EiOqf5W7sOyQFX+SMBudAz+PTz39qZOLcz0HDphNKTN42H53LHx7EKyMp4Bakc0z32ouCEaM9ZJaOk1SAZsQZrneE/ZDyeXW4K5HjU0hY35y34B5YP4DlvFXdcjd6w0IxmXASTGmeESCxT2W0IiZ0n3/DmJ7dIQqSiRBten4D5P8/8TcZiu8NS6mI87XFemIXE6VVAniRsBNUY+TqHQ5FpJt2HXx4EkMxS5x0+p0BkkZBI/ba/ppd/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774780583; c=relaxed/relaxed;
	bh=h5eM8nrJzZ6W15HT/jpsM8V2AUQr7PUIFnp6zW6jBc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+gA0sb+tiwPWu8J5WILHKRNHVqRavPy2VL94a3KSSw6ma78gdhLlZebiOWWZgGHsrH+GZM9yutHf9XS/GUP9dqwskmVO12B99f3JgXD+AvODhTovXZ+NTrExpQTqFlXSqgUh/XprpmMzXT9pz1vSZ78JFG0KTfPD2J55JW3TxGCf3WQglq/Cs/v2RLo3+EpAtCCGw46qpuT5czNAEp6KbldtwfJ+OFklL0+S0uugQ5kvjcGiSxoe2TMIQ+mCCHxlvWLPXCGLBZG27IPlzQqVXv1tUFAbAzUSSc5zzJ2BL57hV1re/vYm3FWsmggnpb8aNwmKT918nNfvM9fNKuMug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; dkim=pass (3072-bit key; secure) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=z+2I+EsC; dkim-atps=neutral; spf=pass (client-ip=2a01:4f8:192:486::2:0; helo=hr2.samba.org; envelope-from=metze@samba.org; receiver=lists.ozlabs.org) smtp.mailfrom=samba.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (3072-bit key; secure) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=z+2I+EsC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samba.org (client-ip=2a01:4f8:192:486::2:0; helo=hr2.samba.org; envelope-from=metze@samba.org; receiver=lists.ozlabs.org)
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fk9ln5tkLz2xlK
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 21:36:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=h5eM8nrJzZ6W15HT/jpsM8V2AUQr7PUIFnp6zW6jBc0=; b=z+2I+EsCMfs+xrchz8bAZUcLJu
	mEgw1uxNVxyKoydzGHYkY1wgWsuXzWoBDiShT1BgwxuNr9yHEcFZ7y3TreWQ5MawJYOvVkY5Oa7Tp
	Kd+sQykeeKv1irSbOtQL838p9yvhKEjt07JYtZHZ9ww7u5EOeGLG0A6OMzg1tC241DbmSroVFSska
	5JiBs3eOWaTvanJUYirJFfUZSvzTrr9lcVR9n0b9jKidyNg+OutWdHaqoRCTfuGWUcjsWC54yukTj
	BjTj6BsPyAbpXAW/uQOEbInho7iRjpaDbCvIzgJEwqaWrQPWvzj2Sfl/OWAmCagU7Na3aWuf6I629
	M4Rvoq3+1hhUBWaS9DZkerCVtrHWS8QIhbzM8mpkL5kG6+i5T2kFKNUaCc9AstpwY8J7YzNwqvvLz
	N/ccB5SEvjXdIdeYC6JH9T7+kSeNQz2YN6FC+dLv+We3mT2pphhvqyfE8UVdFIZH0D2S96cm4RQmJ
	SIADzPqUoN3z9q4vzYSZFFXj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1w6nV3-00000004jBp-1bxe;
	Sun, 29 Mar 2026 10:36:09 +0000
Message-ID: <1eda9321-e259-43b8-8c4a-d0f54a9d28d5@samba.org>
Date: Sun, 29 Mar 2026 12:36:08 +0200
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
Subject: Re: [PATCH 17/26] cifs: Support ITER_BVECQ in
 smb_extract_iter_to_rdma()
To: David Howells <dhowells@redhat.com>,
 Christian Brauner <christian@brauner.io>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Jens Axboe <axboe@kernel.dk>,
 Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Marc Dionne <marc.dionne@auristor.com>,
 Eric Van Hensbergen <ericvh@kernel.org>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Ilya Dryomov <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>,
 netfs@lists.linux.dev, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-18-dhowells@redhat.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260326104544.509518-18-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,

this conflicts with my patches in ksmbd-for-next
where we have this as smbdirect_map_sges_from_iter
and shared between client and server.

Can you rebase on ksmbd-for-next?

Thanks!
metze

Am 26.03.26 um 11:45 schrieb David Howells:
> Add support for ITER_BVECQ to smb_extract_iter_to_rdma().
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Christoph Hellwig <hch@infradead.org>
> cc: Steve French <sfrench@samba.org>
> cc: Shyam Prasad N <sprasad@microsoft.com>
> cc: Tom Talpey <tom@talpey.com>
> cc: linux-cifs@vger.kernel.org
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>   fs/smb/client/smbdirect.c | 60 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 60 insertions(+)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index c79304012b08..f8a6be83db98 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -3298,6 +3298,63 @@ static ssize_t smb_extract_folioq_to_rdma(struct iov_iter *iter,
>   	return ret;
>   }
>   
> +/*
> + * Extract memory fragments from a BVECQ-class iterator and add them to an RDMA
> + * list.  The folios are not pinned.
> + */
> +static ssize_t smb_extract_bvecq_to_rdma(struct iov_iter *iter,
> +					 struct smb_extract_to_rdma *rdma,
> +					 ssize_t maxsize)
> +{
> +	const struct bvecq *bq = iter->bvecq;
> +	unsigned int slot = iter->bvecq_slot;
> +	ssize_t ret = 0;
> +	size_t offset = iter->iov_offset;
> +
> +	if (slot >= bq->nr_slots) {
> +		bq = bq->next;
> +		if (WARN_ON_ONCE(!bq))
> +			return -EIO;
> +		slot = 0;
> +	}
> +
> +	do {
> +		struct bio_vec *bv = &bq->bv[slot];
> +		struct page *page = bv->bv_page;
> +		size_t bsize = bv->bv_len;
> +
> +		if (offset < bsize) {
> +			size_t part = umin(maxsize, bsize - offset);
> +
> +			if (!smb_set_sge(rdma, page, bv->bv_offset + offset, part))
> +				return -EIO;
> +
> +			offset += part;
> +			ret += part;
> +			maxsize -= part;
> +		}
> +
> +		if (offset >= bsize) {
> +			offset = 0;
> +			slot++;
> +			if (slot >= bq->nr_slots) {
> +				if (!bq->next) {
> +					WARN_ON_ONCE(ret < iter->count);
> +					break;
> +				}
> +				bq = bq->next;
> +				slot = 0;
> +			}
> +		}
> +	} while (rdma->nr_sge < rdma->max_sge && maxsize > 0);
> +
> +	iter->bvecq = bq;
> +	iter->bvecq_slot = slot;
> +	iter->iov_offset = offset;
> +	iter->count -= ret;
> +	return ret;
> +}
> +
>   /*
>    * Extract page fragments from up to the given amount of the source iterator
>    * and build up an RDMA list that refers to all of those bits.  The RDMA list
> @@ -3325,6 +3382,9 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
>   	case ITER_FOLIOQ:
>   		ret = smb_extract_folioq_to_rdma(iter, rdma, len);
>   		break;
> +	case ITER_BVECQ:
> +		ret = smb_extract_bvecq_to_rdma(iter, rdma, len);
> +		break;
>   	default:
>   		WARN_ON_ONCE(1);
>   		return -EIO;
> 


