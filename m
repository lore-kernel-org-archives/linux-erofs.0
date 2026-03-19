Return-Path: <linux-erofs+bounces-2854-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7A11090234
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2026 14:14:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fc73Z00MZz2ynW;
	Fri, 20 Mar 2026 01:14:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773929641;
	cv=none; b=ZTpgS13YYOH15EYSjENHobVilSXTjjtvtG4VKwVdTiYKMXTa5FR5CfOA0YH736N12nD5xqtNt4PU3o8Wj1hn1hSHVg2X66AGsbaTMgL18ddfACU2LZQuwPn5yMTYl62JP6vPEm/OkLGf3NIUn2NwusRn+MYEoRWNLGU79uutuEgTJIsl7jkvRKQo/mGZOV/Srkl9yQ//KBVQU30UJTiMGVmemnAnHrlGNG77p8pnVmkLtl96gW4ydHPRD+9xITiJJ8vZ74Earx0/ebyg2HTgE4rgRIHC2MBp7M3H+njY6XX4/6VnEnI6vuIbpcTTGwDLj9C/Gr2D0vzaQuC5t8X/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773929641; c=relaxed/relaxed;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnI2qoVqw3SoCjhFJkgsJvNqQPv0wjzEuKVwcGydLZiWYH9uKfZdwDXaXZOFtghg+jPV6/G1Cr52bn2Hr6dsmLkKOBFYzXNfbaxrRGoKvlwqT38J9YPloryN/wwE3MR2GwlfVjA0pCBmo486AUWhomcTC2shYgxvwxVe0dA5/aJPaeGlHoyk9zGdjvPw5cj0n7SQZiKH+mPzo6C7EuaZn7RuongzjJk5NSUaS3pO/Kxl2aNEzm+MJKvEb+rDAVKosPaqL0U/eF9+0JFQ1/5hFe4mOSumSgW3L+CHlizT8dFwzYTjnNUQ9GbeG31XLpY0G20//qaUz5U7fENCu5qA4g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz; dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qJFdgiFw; dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4jpB79yc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OrcSAEzL; dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HXVk5/yP; dkim-atps=neutral; spf=pass (client-ip=195.135.223.131; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org) smtp.mailfrom=suse.cz
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qJFdgiFw;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4jpB79yc;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OrcSAEzL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HXVk5/yP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.cz (client-ip=195.135.223.131; helo=smtp-out2.suse.de; envelope-from=jack@suse.cz; receiver=lists.ozlabs.org)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fc73X4rdbz2ygT
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Mar 2026 01:14:00 +1100 (AEDT)
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 233AB5BD4B;
	Thu, 19 Mar 2026 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773929632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=qJFdgiFwZof840urwELAyJUPmqr5R5KSb1T4rwYuc7bb8XNbCm/kv+M5FkrKSBEOM1bZiu
	/MGyuwm/OFnFKmJm/t/Uz/+GbEcAEAQCMtEWioCbgwKOh4DWZ0qNVZOg9g66xDY+m4U+fD
	w9Xqoe30eNI+goFz62hSwZMzWorThdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773929632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=4jpB79ycXSQsxOkgtV3HKUa6Dm/vQ/wRir8pmFsiYnB6qgK3LbPe12RtulXb4tol7/E3ij
	faYPra8B4GTfZjDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773929631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=OrcSAEzL/6c4UDB40dZmtUkHL2UKN/t418W/3/WLfRE3VUYtttdOTA1LBRs2LexriSZBXr
	IUCLAcO9QxQoLCNXA0PSitgNb7BC5cuH9t+EXroQLbXGhfbC1mTChSWj64vc6V41FfYy8R
	mio6pb/J12e+5TPnOnmBoDRex83ce1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773929631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=HXVk5/yPJtxIjyky0dtujMNvVHE9KONXRU8D1O6wb4LBxoqwDaKPYOnkGEkCrYDJmYyVOA
	klxEA++oJw6AsaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14B714273B;
	Thu, 19 Mar 2026 14:13:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TmUEBZ8EvGlPZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Mar 2026 14:13:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C850FA0B32; Thu, 19 Mar 2026 15:13:46 +0100 (CET)
Date: Thu, 19 Mar 2026 15:13:46 +0100
From: Jan Kara <jack@suse.cz>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, gfs2@lists.linux.dev, 
	intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-pm@vger.kernel.org, linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Jan Kara <jack@suse.com>
Subject: Re: [PATCH 12/61] quota: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <ol2d7c5z7yfyuwo5tyfxurgqedruhr6bzmuv37bx5phhrmmoyh@4zjspbtexid3>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
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
In-Reply-To: <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLck44p98ib5bmd95s13xxw3gp)];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_GT_50(0.00)[55];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]

On Tue 10-03-26 12:48:38, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> To: Jan Kara <jack@suse.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Thanks for the patch but frankly I find the original variant clearer wrt
what is going on. So I prefer to keep the code as is.

								Honza

> ---
>  fs/quota/quota.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd70758007129e0375bab44d7431195ec441..2e09fc247d0cf45b9e83a4f8a0be7ea694c8c2a1 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -965,7 +965,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
>  	else
>  		drop_super_exclusive(sb);
>  out:
> -	if (pathp && !IS_ERR(pathp))
> +	if (!IS_ERR_OR_NULL(pathp))
>  		path_put(pathp);
>  	return ret;
>  }
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

