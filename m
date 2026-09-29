Return-Path: <linux-erofs+bounces-4628-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C00CA5FA5
	for <linux-erofs@archiver.kernel.org>; Tue, 29 Sep 2026 13:42:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvK9j4NgHz30Vn;
	Tue, 29 Sep 2026 23:42:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790689353;
	cv=none; b=Yc1CpISEgqKSBaCOcdSjJ89+fFTBDiP7B0FQTG2E84uKgJyWRxDA4DsRurdiy8fy+UEnvnx+7hI26uvH5NH3/S1JXVKnH3PKOGgQpP7/wu9nSAhdbQfeesqEoNuPwT2YbFlJRkxdSxDqkuN11BnDcCeASKN+9YSIAgn7YLmUMj9TbvDYTnu/ANtIpfIQIvlcH5ky4z1bxa/ybQeUzNu9iJMJddKCVOCVYN7vIAbz0nFzNg7K5KLoQdJKPRw3WT80advH/sTl/TFRgmHZY5hiZvFI6QPLbVhG7UjFJKfLzXIdw73KwN75Vs9p6TiUI/sI8bQ+69UNWjQr3VnXmqS6MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790689353; c=relaxed/relaxed;
	bh=xRGB63FdTu0iRmvE4Qh46lAQlJfORL2czG4OCc92vFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6fPK1+wGjRsAcHdLypU93FBFoGhFTEMDge32EtieffDlpZ2hZg4g1J+qi5sXBLoETrXTSEwsvEQlc+oamEWC1WfV1QbK6P2bK0oWxKh3J5ey3jGLEqx1fktS8ohI4nDEfM+Vm5crZ9YQ3IytEfDlWbtncfnElpYw5sdOcexpBfTcRjj5kaTB9Dmh4JRKN9/2SKyAtfMnN/DMsKT3hMpNDYPNpCrOoqSKmcHpg7CFn5kZy9UBJZ6oRWK0iMcEnuEih1ml9V6pz8WI5VBPiGWC2SXgVzHTpTbUzDm3mPhqrm1e3Zt9Bet6a5inKsmtx2jgLHcqukW3OUYvCJgihSH4A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtkewwQ0; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtkewwQ0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvK9h6y6nz2xnn
	for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 23:42:32 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 572C341640;
	Tue, 29 Sep 2026 13:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B471F000FF;
	Tue, 29 Sep 2026 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790689350;
	bh=xRGB63FdTu0iRmvE4Qh46lAQlJfORL2czG4OCc92vFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NtkewwQ0TiN28zN6U9/6x/SAaFTPiLXD0HMtU6IfVMkxhouqQNIZFu9zwXRrzinE0
	 wuS8MemegdHBUnhf/SCnH/UbTz50iDWR+1l8n9Cl38a3P85oAHe+u+zey6EdpIc5VL
	 1KU8/JK5NWhCLNs65jENowbhd2BhkXVLDXr6FK3aIs02uWnD9aEeXFvX7MCnrVkqEr
	 1E/BEynk2cP/6Qo7/SMgCya6hPj9EBX14WaJKw/En5yRdlvaFOFIXxoUy7Zdp6g6Jx
	 BNgJmA6Bx6dvL2orN2HFOYa0BulHyvPymMljkusok2XaWilp8Op9QgOSybUGLPpr/3
	 3NeT1A7OCxp/g==
Date: Tue, 29 Sep 2026 15:42:26 +0200
From: Gao Xiang <xiang@kernel.org>
To: Garv <garvkumar1502@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs-utils: zero directory writer buffer
Message-ID: <arvAQh9Uz9cDG2KN@XiangdeMacBook-Pro.local>
Mail-Followup-To: Garv <garvkumar1502@gmail.com>,
	linux-erofs@lists.ozlabs.org
References: <20260929133917.14100-1-garvkumar1502@gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929133917.14100-1-garvkumar1502@gmail.com>

On Tue, Sep 29, 2026 at 07:09:17PM +0530, Garv wrote:
> Signed-off-by: Garv <garvkumar1502@gmail.com>

Can you explain a bit more why we need that?

Thanks,
Gao Xiang

> ---
>  lib/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/inode.c b/lib/inode.c
> index ec96556..e7d07e0 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -597,7 +597,7 @@ static struct erofs_vfile *erofs_dirwriter_open(struct erofs_inode *dir)
>  {
>  	struct erofs_dirwriter_vf *dwv;
>  
> -	dwv = malloc(sizeof(*dwv) + erofs_blksiz(dir->sbi));
> +	dwv = calloc(1, sizeof(*dwv) + erofs_blksiz(dir->sbi));
>  	if (!dwv)
>  		return ERR_PTR(-ENOMEM);
>  	dwv->vf.ops = &erofs_dirwriter_vfops;
> -- 
> 2.53.0
> 
> 

