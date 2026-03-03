Return-Path: <linux-erofs+bounces-2484-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF049E67A91
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Mar 2026 07:55:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fQ7Pv6Y6Vz2yFY;
	Tue, 03 Mar 2026 18:55:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772524515;
	cv=none; b=ExkrBIM0n7q/lstAjcnxuwj+RVdPXZYBGQHgGGBmK3RlHN1B2fwGs4TseNFHCt2AGeR8gnB2dKxy0WJwNOCv+QRYq3JQ8jnJYucg/4PAacQXBfUlCfQCyNckZa23q0UEaaC3tnEjS9LXFJF5pu91L0LL0tGlZu/Cszd9/WwQkynO7Spxm/yXEtZxQ6Sq03T9FKrt0WNn3zgPra4gd4TeCerSTaaUsN3YzF19np22vwHLEcpaoKjM1cH4uIdHkXT1NrIDV5a/6iAcip431sd2xw7wtN4/cz1sdPEr8CgjyqftXWys7WL4g6KrLgWxH1XJN36izX846n1V5GHI7mRWGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772524515; c=relaxed/relaxed;
	bh=bcq/+Er+XlH36TbkDwSj6qIapveA/UvS9c0MTwjC4oE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N84gbi/0pR0eoo3mJf5+jbFRlTJfArFPCFmvFREgS2yow9Sy0kO0Dx+vcG90SDiHdKJAPpZSjD6q2MzSLcvIFVST4DNXjsrBo043JFwXdhVmabYqGqeMrfUiNQGYqD/EgUL2QW9UI3mu6K8+X+u8c3jXKssr0hgpHmTqwYgFrUPlJuHaciY64xaptU+87xV0A0Q2pqrklsSZ3nN5j9KSP+vUu943+RPZsA+ep/eHGB5Be5tkHvrb9C3VUtUvjIhQ1BSrz+nfIfXNMrizQz/2XOX3Nqhm0KGmZfMOS0kC4Pt38q3I9DD79NbBr2fYr/KrA3U9z74QT/80W3V/KrMQsQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=QYaciU2o; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=QYaciU2o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fQ7Pt4YQVz2xpk
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 18:55:14 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56B3E41A87;
	Tue,  3 Mar 2026 07:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B639C116C6;
	Tue,  3 Mar 2026 07:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772524512;
	bh=/gWb85WOvGqAlgOSzLtDehw7AKRnh+7E8B4cTlui6fw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=QYaciU2oTpG8jfg3ywavoUiUqpdz43zwccKQdfL94+zd4UUvD5f9kqIpXU8XSUhTy
	 m1lXpQAXTS6rc+B68mSIoOzBoEvJGtdwQ+GFPa4qerpaiH1ShUUfbRCldUEvc8R0lw
	 JezPOvqEDXFybMiPFQrwGVkebHvCjtQjVKTi3El6atbY8lCukdubtq1j5kPpAQwDlq
	 /iuH2jz5X1T1lyrcvFtTYPT7LqP4+DG/C5jjbDV4foBq1frQsZ/dnza18RsSdA0iQB
	 onYYPhY5BD50yYjm49zykM6l3DKbKX3ZxAi7NPxvPc1mmdTulkNcuD+Tn779xw0JfR
	 O//pf4NTsUnVA==
Message-ID: <59f168be-36ee-4982-b1fe-727e88484b59@kernel.org>
Date: Tue, 3 Mar 2026 15:55:03 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, Sheng Yong <shengyong1@xiaomi.com>,
 chenguanyou <chenguanyou@xiaomi.com>, Yunlei He <heyunlei@xiaomi.com>
Subject: Re: [PATCH v2] erofs: set fileio bio failed in short read case
To: Sheng Yong <shengyong2026@sina.com>, xiang@kernel.org
References: <20260227023008.147813-1-shengyong2026@sina.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260227023008.147813-1-shengyong2026@sina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/2/27 10:30, Sheng Yong wrote:
> From: Sheng Yong <shengyong1@xiaomi.com>
> 
> For file-backed mount, IO requests are handled by vfs_iocb_iter_read().
> However, it can be interrupted by SIGKILL, returning the number of
> bytes actually copied. Unused folios in bio are unexpectedly marked
> as uptodate.
> 
>    vfs_read
>      filemap_read
>        filemap_get_pages
>          filemap_readahead
>            erofs_fileio_readahead
>              erofs_fileio_rq_submit
>                vfs_iocb_iter_read
>                  filemap_read
>                    filemap_get_pages  <= detect signal
>                erofs_fileio_ki_complete  <= set all folios uptodate
> 
> This patch addresses this by setting short read bio with an error
> directly.
> 
> Fixes: bc804a8d7e86 ("erofs: handle end of filesystem properly for file-backed mounts")
> Reported-by: chenguanyou <chenguanyou@xiaomi.com>
> Signed-off-by: Yunlei He <heyunlei@xiaomi.com>
> Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

