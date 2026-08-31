Return-Path: <linux-erofs+bounces-4395-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 506BEC61DD3
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 23:34:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYlh92Lrzz2y2P;
	Tue, 01 Sep 2026 09:34:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788219273;
	cv=none; b=U6prR4NxyH+i6oD14gad2mmuLKueyXIMW9qgqnjgrtZg0G9EE59YghrXIelu4fhp7QZKQb5gtuhalnz3S9QdaxTM0YOzEfM/ZfyTZ3dHVSpx7JSa6SbX3fyvfSoVOjWB4ePfXBbDbWF9klrUsnxM5+q/8paIIZcOoGmj0TRsE7YZNNV/rmYmlpJ6KzrrXW4crLZJ8fsKPjJtcBLGnhJNLKjNI8SuauTc3fMHt9f8R45bqN2tFWiSveglSK6nxu8NV9zzNruO5SuYBSXQKU32TJQTRXkJJkVptTbh9FgrBbDiGM48+j7PeADJEy5SvXo0jtNzqAkym+ZmCdy5bm+GTg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788219273; c=relaxed/relaxed;
	bh=tAVWsBwACx+IpWMY6PFdTt/YVw93rBRGG3Ku2i4nYdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KunL/nynroJ/ESxmH68y5LziRwGVmgSzoVhg5zE5G9dOy67XuXe9pu9L0DGAMSpTkD/8nNumbc9edINQdJR+sj+YNFJ666q76stuBrVM0XSuddyY9JVCNOT8LNSvLlFMhrX6F50Wv3q6Uf8JRq9TCW7zaaK+iYHUnR15D3WoqdvBy3t5cS3bIxsJy8sV2zYQ+ixaNtDGBxMl/cib6Rstqy08ZTmjjGkYHRPwp6LVSegF88iXwGysLSA5XSXGv9hRvwx1kEBzE3OrbeKSesgq1zH4zRxT8KnoXO1ofdiYIltmQPr3XxwTGrEE61NzEWPPu2K7wx4KzF/MUPe2M6xEZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BqwSL8Y9; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=linkinjeon@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BqwSL8Y9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=linkinjeon@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYlh84lvKz2xGr
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 09:34:32 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A382602D4
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 23:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56BF1F01558
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 23:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788219268;
	bh=tAVWsBwACx+IpWMY6PFdTt/YVw93rBRGG3Ku2i4nYdQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BqwSL8Y9QvsoIybchgXr6SUjZcK550Ma89hPYKjDRnI//v8B9t8VdKlxGUVEtuWtM
	 GPSHMzHRkbFLT5aippmi3DoORpBtyvMWkGdzuLX2TkN1RkYr1Y18ecpsxP0a3/dDGQ
	 E1qzzU55vAzNYtD19sGVLpbM1a/td1Akzm1xvtet9cmIQC6bOFLDtKH1WJl8knIVkK
	 sgwGb3huydDXsJWPKxPYNkRFY1ebxs31WQSmIgMCkVUPuH0pcM9Bm5lNGgJUyXm2Fx
	 0xS1iqKPSwQYqow7xHjb6LPbCTsHSOXakH4+bQAHcAQHEUpD+rZX0TzZQQnguaZKFn
	 9Ry8kyeZLUGFg==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a6108734d5so6037559a12.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 16:34:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBykmpDMocEik18hkkA9FF9hQLHnyy1wALWbqtACXuebehi+zOuFEQmtnPumSMdkub5Z7V7yjvn7/gE4IA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++nJAWNDZMFUWV58haQOo3FKc2gXwczr6prEyt+c7okEgPxWhfRh
	tfqqZOPtsgyC1bWmjaQZpcrWuYTGU5m1ErNGRFZjKFefIW+BUlMoY0/Hg1m+GOAg0g+OeYs57kq
	4J2KzHggzpKMk6XxFYLcjWctYEg4AsEU=
X-Received: by 2002:a05:6402:3245:b0:6a5:f44e:a009 with SMTP id
 4fb4d7f45d1cf-6a663a4a9dfmr2170192a12.7.1788219267560; Mon, 31 Aug 2026
 16:34:27 -0700 (PDT)
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
References: <20260830041901.2668-1-willy@infradead.org> <20260830041901.2668-6-willy@infradead.org>
In-Reply-To: <20260830041901.2668-6-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Sep 2026 08:34:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qgCe0Kt_Pmpd+228LP+hCtF2shmVqftazX1+xrSCkFQ@mail.gmail.com>
X-Gm-Features: AcwNN1WHItk-3z0F1xUEgtAcqL_7gSvlVk8E7QxJwHtI0RZzvTtB9qGbIwZCYNg
Message-ID: <CAKYAXd8qgCe0Kt_Pmpd+228LP+hCtF2shmVqftazX1+xrSCkFQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 1:19=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> I do not believe that FGP_NOFS is needed here.  This function is called
> from one place (ntfs_inode_attr_pwrite) which calls either this function
> or __ntfs_inode_non_resident_attr_pwrite().  The latter function does not
> use FGP_NOFS in its calls to allocate pagecaache memory, so it should not
> be needed here either.  If it turns out to be needed by both functions,
> then we should use memalloc_nofs_save at a higher level to protect both
> of them.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

