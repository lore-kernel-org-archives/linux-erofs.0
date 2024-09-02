Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E92CA0ED3
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2024 07:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1725263850;
	bh=vFg7frQZFwf8sr2E7jIEdq9FvqRSKuqpQbVH+tIiz2E=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=GRvpLKHfxYa9e7Fo6Xg/5+GW+4wP+njmwoDGPWdZw+w48n2aIe6By13ELICF01E0M
	 dv+9SziFG/tFMLOgZLclFcTx8qk8eqdK2zpNq0xHPxMc3fUIc5lGdpFHjHQNTxSqZF
	 MGNuTWJIe1kgXmHj0XLOJ7W/43p/8A1VQSZ0Y7mZfAug7LDnJ9cLchQl+XTslRcI+0
	 y9SWiHlN+ObtOGsaY5hcLoS1TqtIdUHIzJOhDqOkH00TWfvc6ozxErfwKiPq7Bsv6U
	 CZkn+8rPWjsHYAeumWC2yS7OmL6mj8ZBWoyCUs2mJLKJl7sWV5V6a+XzCd3ecPEUSM
	 PRyCdXDTCjFEQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Wy1Ly0Qh4z2yR5
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2024 17:57:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.135.17.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1725263847;
	cv=none; b=h+vObG/+A8DqjaBdIc1f7GFddOZTPmfEWxftf4nv/lcUBy00V10kqu4DJ5PGrS5uR373iLZ/m2JGKrp/7jrtrJynGWLOe+V5Siz+6X91PVmYWVZYy5DMUbrWpe1HKMkKjEB/Zh9fw2WwH5PsxrZPpK1KvZhwhqkKunt11KznU2A4wIKtKtC+NifzYG9rjA8TKOMeWsnsam0Tw8IWFxilaV4D4QzL6S9L4j9C0VWGv/0Z5PG5xYUka2JM+4IdhMX1dF43ISODLrHNMMYE/JpZBMKdrrunKNS0hp2rwbeNn0g0f64l1JH3p0iYoTYYXLoKDnmw0g05rL44UKj/Hll+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1725263847; c=relaxed/relaxed;
	bh=vFg7frQZFwf8sr2E7jIEdq9FvqRSKuqpQbVH+tIiz2E=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version; b=WRhmzbdk7eA7Fd6pzQfs5TyJ4Gl7JV+TiuZO8PsaJ5/gkhX2/GmJrZslan3sHtZydGO5LvCCp/y0yCy4zEpYedmov33JEu0GaXIohIPjoOPIiO2NC6U12luVO/ewjuVBuaQoCyp9Xz6sTuhpQfWEOLePCf1GTpbMaIyGRFRZH/g1E8hQQ9fc6L7/m1pdte9Qyxkl0uApVRXXkkSJDW31+oK6jJtPUOq19BGhIsaCSfcjwB3F8iRz7y8tqlRtuJgH50txgDsZl/c48DI0vRvew8nHvVvAYWPHiG2xQ6SDj1W+O1adkSmkfbSbZSBzmKQs28y0dgAJmHeB9PVW1ePvYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc; dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=gcFEFHtz; dkim-atps=neutral; spf=pass (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org) smtp.mailfrom=tlmp.cc
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=gcFEFHtz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=tlmp.cc (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org)
Received: from mail.tlmp.cc (unknown [148.135.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Wy1Lv3yTnz2xWV
	for <linux-erofs@lists.ozlabs.org>; Mon,  2 Sep 2024 17:57:27 +1000 (AEST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4B15B69840;
	Mon,  2 Sep 2024 03:57:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tlmp.cc; s=dkim;
	t=1725263843; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=vFg7frQZFwf8sr2E7jIEdq9FvqRSKuqpQbVH+tIiz2E=;
	b=gcFEFHtzUx81lI4ANpjib9RaxtJt76JdX8yt+3bJ2QQrHaFLMlvwFxQkvchSdZ9eljFAZi
	cKH1hufcOstX1zvSPqc3k0pA71xYQi60FtIMqwoN6pKBeOG1xJdXyJFHN6s3b9yr9v2Moo
	q/CU6zhjVdma+k7+fEITRGoFNr0blM/oYS3xMqV248euzNxlsmGgKfWokouXUG7YvU8wjA
	sAFVaTraW0mig5xnCURLydegWJwUoyqDE1c19RPW5bDY/QHWpxmqpYMQT3dFmuv3oon7dT
	NqDtFuMrJTxSAw6fbvZUJ7/A5Cb6Dvrg9s40dyPT5Tc35QTrCnBX3/sRBNCd9g==
Date: Mon, 2 Sep 2024 15:57:17 +0800
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH V2 2/2] erofs: refactor read_inode calling convention
Message-ID: <kcqmmpzzd3zr244dceocn7gbnvltrlyhqbku5aj52nnimoxzfu@eyj26z254w4b>
References: <20240902070047.384952-1-toolmanp@tlmp.cc>
 <20240902070047.384952-3-toolmanp@tlmp.cc>
 <1067fd19-495e-40d7-9acf-bf2735ca89fb@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1067fd19-495e-40d7-9acf-bf2735ca89fb@linux.alibaba.com>
X-Last-TLS-Session-Version: TLSv1.3
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
From: Yiyang Wu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Yiyang Wu <toolmanp@tlmp.cc>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Sep 02, 2024 at 03:18:54PM GMT, Gao Xiang wrote:
> 
> 
> > +	m_pofs += vi->xattr_isize;
> > +	/* inline symlink data shouldn't cross block boundary */
> > +	if (m_pofs + inode->i_size > bsz) {
> > +		erofs_err(inode->i_sb,
> > +			  "inline data cross block boundary @ nid %llu",
> > +			  vi->nid);
> 
> Since you move the code block of erofs_fill_symlink,
> 
> I think it'd be better to update this statement to
> 		erofs_err(inode->i_sb, "inline data cross block boundary @ nid %llu",
> 			  vi->nid);
> 
> As I mentioned, the print message doesn't have line limitation.

I just simply cannot tell the difference here. But since you put it
here, I will change this in the next version.

> > +		DBG_BUGON(1);
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> > +	lnk = kmemdup_nul(kaddr + m_pofs, inode->i_size, GFP_KERNEL);
> > +
> > +	if (!lnk)
> > +		return -ENOMEM;
> 
> As I mentioned in the previous patch, so it could become
> 	inode->i_link = kmemdup_nul(kaddr + m_pofs, inode->i_size, GFP_KERNEL);
> 	return inode->i_link ? 0 : -ENOMEM;
> 

Looks good to me.

> > +		if(S_ISLNK(inode->i_mode)) {
> > +			err = erofs_fill_symlink(inode, kaddr, ofs);
> > +			if(err)
> 
> missing a blank:
> 			if (err)
> 
> 

Fixed here.
> > +				goto err_out;
> > +		}
> >   		vi->raw_blkaddr = le32_to_cpu(iu.raw_blkaddr);
> >   		break;
> >   	case S_IFCHR:
> > @@ -165,63 +202,29 @@ static void *erofs_read_inode(struct erofs_buf *buf,
> >   		inode->i_blocks = round_up(inode->i_size, sb->s_blocksize) >> 9;
> >   	else
> >   		inode->i_blocks = nblks << (sb->s_blocksize_bits - 9);
> > -	return kaddr;
> > +
> > +	erofs_put_metabuf(&buf);
> > +	return 0;
> >   err_out:
> 
> I wonder this can be unified too as:
> 
> err_out:
> 	DBG_BUGON(err);
> 	kfree(copied);			I'm not sure if it's really needed now.
I agree. copied doesn't need to be freed anymore as it's already freed when error happens in the first switch block of inode format part. 
Will be fixed in the next version.
> 	erofs_put_metabuf(&buf);
> 	return err;
> 
> >   	DBG_BUGON(1);
> >   	kfree(copied);
> > -	erofs_put_metabuf(buf);
> > -	return ERR_PTR(err);
> > +	erofs_put_metabuf(&buf);
> > +	return err;
> >   }
> > -static int erofs_fill_symlink(struct inode *inode, void *kaddr,
> > -			      unsigned int m_pofs)
> > -{
> > -	struct erofs_inode *vi = EROFS_I(inode);
> > -	unsigned int bsz = i_blocksize(inode);
> > -	char *lnk;
> > -
> > -	/* if it cannot be handled with fast symlink scheme */
> > -	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
> > -	    inode->i_size >= bsz || inode->i_size < 0) {
> > -		inode->i_op = &erofs_symlink_iops;
> > -		return 0;
> > -	}
> > -
> > -	m_pofs += vi->xattr_isize;
> > -	/* inline symlink data shouldn't cross block boundary */
> > -	if (m_pofs + inode->i_size > bsz) {
> > -		erofs_err(inode->i_sb,
> > -			  "inline data cross block boundary @ nid %llu",
> > -			  vi->nid);
> > -		DBG_BUGON(1);
> > -		return -EFSCORRUPTED;
> > -	}
> > -
> > -	lnk = kmemdup_nul(kaddr + m_pofs, inode->i_size, GFP_KERNEL);
> > -
> > -	if (!lnk)
> > -		return -ENOMEM;
> > -
> > -	inode->i_link = lnk;
> > -	inode->i_op = &erofs_fast_symlink_iops;
> > -	return 0;
> > -}
> >   static int erofs_fill_inode(struct inode *inode)
> >   {
> >   	struct erofs_inode *vi = EROFS_I(inode);
> > -	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
> > -	void *kaddr;
> > -	unsigned int ofs;
> >   	int err = 0;
> >   	trace_erofs_fill_inode(inode);
> >   	/* read inode base data from disk */
> > -	kaddr = erofs_read_inode(&buf, inode, &ofs);
> > -	if (IS_ERR(kaddr))
> > -		return PTR_ERR(kaddr);
> > +	err = erofs_read_inode(inode);
> > +	if (err)
> > +		goto out_unlock;
> 
> out_unlock can be avoided too, just
> 		return err;
> 
> >   	/* setup the new inode */
> >   	switch (inode->i_mode & S_IFMT) {
> > @@ -238,9 +241,11 @@ static int erofs_fill_inode(struct inode *inode)
> >   		inode_nohighmem(inode);
> >   		break;
> >   	case S_IFLNK:
> > -		err = erofs_fill_symlink(inode, kaddr, ofs);
> > -		if (err)
> > -			goto out_unlock;
> > +		if (inode->i_link)
> > +			inode->i_op = &erofs_fast_symlink_iops;
> > +		else
> > +			inode->i_op = &erofs_symlink_iops;
> > +
> >   		inode_nohighmem(inode);
> >   		break;
> >   	case S_IFCHR:
> > @@ -273,7 +278,6 @@ static int erofs_fill_inode(struct inode *inode)
> >   #endif
> >   	}
> >   out_unlock:
> 
> Remove this.

I'm not sure whether we need to remove this becasue device inodes do not
need other operation bindings below and still needs the out_unlock to be
early out. Another solution is to use the early return but i deem the
goto solution is clearer.

> 
> Thanks,
> Gao Xiang

Best Regards,
Yiyang Wu
