Return-Path: <linux-erofs+bounces-3940-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 020B3C4451B
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Jul 2026 09:22:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h3ZmQ3Tmkz2xm3;
	Mon, 20 Jul 2026 19:22:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::831" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784539350;
	cv=pass; b=RrVE4k1tcShbRIRrTveCRFVlSzZzlu6Z56RKi1R7UpM+BGCO6vIcwh2B/K+iFWE43ulSflF2Zs+PvFZ342XgwXAI1rQV/P0u9dVtXnjr87E+KQzTHJLOD9EAbT2w0yfEDCAQBWAIghyG0pM73hoHlGEsy53OtNwFkBmj/f1MVJ5Ib8IbZobJzyXpJ3IDMtmnaK8+CLjbrsA1x2rnagtaTZzMsoaz9JQ0eKXzMURJqXX1NUM9DPbq4o3kijYHBtKTmHL0aFUf9ZX1Rpc6luvjsrNn4rgqFNH+mOWWwNBSLJ/2qGq7ur9dYlB+o9FoPjrBjDpesepCp0wfpS9Hwov3vw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784539350; c=relaxed/relaxed;
	bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lf1VnwXl1qT5YzVuwRsqgs2w56KVFxmwSF5Cqo7KmXLYQzSZ+NcEdavan67bSXMW7xm5AX3WMtcoHS3dMyHVsXj3HEY64gq/brGeZOSikPLwEakzjsmnRPi6/GSorXwvEOJmotnFpIN0esoFnyrjyhOK0pYKWttYHy7/5ZnCmZvlQSoarqhxeZImbgzkzlNLquW7NHhqxbMlSK4DO94+dg0Pz0MLKvBC8fLERtigZg5FIaGUBmqqq6Zxe0fEXBXSkR8p7t/nA+jSoLcJsH98iT19o/9YKhcbRtTBQ29h5q8plu48LvYZypOQVfWPg3lHrhpejDYD5oy3b3j9tQ9irA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=mLKwTvRj; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::831; helo=mail-qt1-x831.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org) smtp.mailfrom=szeredi.hu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=mLKwTvRj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::831; helo=mail-qt1-x831.google.com; envelope-from=miklos@szeredi.hu; receiver=lists.ozlabs.org)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h3ZmL3JvJz2xlZ
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 19:22:23 +1000 (AEST)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-51bfe810293so50665151cf.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 02:22:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784539341; cv=none;
        d=google.com; s=arc-20260327;
        b=hXQjL1XVU/OWogcMK+CEGGrDbiOSpkB4nnw0ch60asmHvlkJDiq79jZ/4Y1nzMQBJe
         /x3Ly7mhGWPEpw5w4H1KMvBwpMBTDcY6ZM6OnjdIw6j3cMsC4TUa8LP3poFT9QAFlvTX
         81va6/g4EbeBriFDaWT9hK9iKJK+oMinJiNPS+bP2N8t90d/0tg4DUZ5kmKVzMEAbev4
         xVzWwphhCnT6W61zCDpn5oV0KW2yW/sq92V+Ol6P+KC57OaxMIMOeFyA7EMM18FtoRAA
         7IqnxjkjcRvvyi/8QEkvtClQRrPDrspoA7/b3HSCwWhCzxxUXoajtDxCNB8cO+NNJAKr
         hzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        fh=c9/OZ11pvq8PRM6u/j/tqi+55qE3foS2bqmjqc+LWZc=;
        b=IDtRvn6Nxe9gNVYeZEyf1T4W11tvsUY4NpTiSt8bWjErChQ4S2pRaCpH3WZq7zXkAE
         Fy+Hk+ANpzs1obHWGsNKJ1FF6wQqC5S2kIzlEdUNImR6NgOCQbhwiBku8UHo1CTrA6Jy
         rKkDSvOqdLCrbvkqo228NEtO1JtPgc6bD0SKXOYyaivsRQw4bxi+M69zGHUy0AB92/xM
         XDvV4RqzVNVt1Q6N6FuAbCaK8h0Om8M67ntbHFEb105B/oC3baUp2+q83/2tW0FxPgZ6
         BCTVLp0r5oGqnQ74rOYLx+bhYB1au/A8Hm9Xw9P1p2tBccX9fZIqXBnGOQuVYibOu4E+
         djZA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784539341; x=1785144141; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        b=mLKwTvRjfH3rcj9e90QiZir6X1JHOSgpll2B2HB0V7eIARU3/W9yJzMPDURMn9H0Xg
         p+A8IOzxCc5n1hWdyrSpi0elnfqt04JY20lix7u0X4qr+NxLOH4UM/Nwyjj0pMJQg3le
         DX9qAPGShu95jXQ0/5Twk2KpvpO5NOWPqVw54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539341; x=1785144141;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        b=hTJRW9d1Xn+I9BIDoKzoSWLTe0eF69LEH9ZVVmMIgIup8KAtatSLe+Y+/IFdNhP/fC
         LnODiYAmyKlQv8qylfpL+eewtgQS/fkLAeEBgCt1H6Rlvknnv+m9GzeM+7zpcgr9EWR+
         NFkqhbkSq0BwEugTH2ylv+wtko+aJPPPkEWyq3J2ZyXYpkTLL7Bff0qOFtftVjUlmUeO
         7cHge1rWKzUKEf4unNjk6e0ANsTMAfcxED2CWeNDrN7NTm/cLC7IkslcD/y+EE6JyR9/
         GIYYjz9QOC8SieCfkS9kuBqSuJYhiaMFuZKHKluBW2xEhp78vq4FztSwEb0KuUXIZje4
         MAbQ==
X-Forwarded-Encrypted: i=1; AHgh+RqdCn4naQCuPSVhTkp1lRHNc/lhGG4M1c4PdmWPuovx+oKBXghIp/OYgL1ur4OUclyKopDUy89tA4wFxg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxJ8iEYYXntRqIKpS2eN+L7CXcIK9ndYUFkACkyg6I56tB2WsXb
	MEeSLVeSvUsyzSzkPMwxgpOEy2Bksi4xuskePGDFQs8BBuLgaNRXvFtvpuT4KMVkOEuZvACs/xV
	eRVjDtJndJ42hdwywzpCsR4IjP8+QBVgn0nrUexen0A==
X-Gm-Gg: AfdE7cmpA5w5zUFdvQrQO1hp3AaAmIsqrFSSxC5Wjqk0hi5B6cbLhzu6JdqXF5mvUwZ
	mBVSgfBIgFBNpRLrF0pdcGiR0hysD3dpgiBMmEgWBICs+veQc7datfzwW+0uWheTZPtlVgeCiwC
	aKYvI6GGsYNMJL3tlrByIWB/1e51vGCABmIUKHPXXRlGesSmFXg8MkxTIGKKGUDzmBOHlOCbZYF
	WFVvOxKdF8qTkSuJRx+/SVhC3wSepwLwFLpz8ysYUIqOicjDgfDPqP+bWjTvOyFWI6QY/cuULZ7
	HtZOpCGemkWZab7WBA==
X-Received: by 2002:a05:622a:1192:b0:51a:8c9b:64a2 with SMTP id
 d75a77b69052e-5213d0c7ca4mr116936831cf.70.1784539341012; Mon, 20 Jul 2026
 02:22:21 -0700 (PDT)
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
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
In-Reply-To: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 20 Jul 2026 11:22:09 +0200
X-Gm-Features: AUfX_mz0IN3hn5QumsNu3idUZDFLnqeEUQTN9zg17vrQKR01GmrNXzVy6O1zEgw
Message-ID: <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:

> This gives me the willies a bit.  It's very cool, but it has some
> potential security issues that I think we need to watch out for.  As
> sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> supported files-as-directories.

I realized that we can keep the creepiness factor minimal by
introducing this first in procfs only.   That way zero changes are
needed in the path lookup code:

sprintf(buf, "/proc/self/fd-alt/%d/%s", base_fd, alt_path);
alt_fd = open(buf, O_PATH);

Thanks,
Miklos

