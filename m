Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90868C77B75
	for <linux-erofs@archiver.kernel.org>; Tue, 16 May 2023 00:59:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QKyYJ6fjXz3f6R
	for <linux-erofs@archiver.kernel.org>; Tue, 16 May 2023 10:59:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20221208 header.b=J4s70hg4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62d; helo=mail-pl1-x62d.google.com; envelope-from=zbestahu@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20221208 header.b=J4s70hg4;
	dkim-atps=neutral
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QKyY921DWz3blx
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 May 2023 10:58:52 +1000 (AEST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1aaef97652fso93149455ad.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 15 May 2023 17:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684198730; x=1686790730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVkJA3lTgCORmQkh7N6TzUrBQFxDZlWdNA3lW0Mj46Y=;
        b=J4s70hg4/JjW2UMnl2JT8bfnV8Ukk7qLfBS4DfHMVP/JOgNwokgC8Dkyy2iBK3s/cp
         gYZ6QgETEMQEuQcaiI/OJ5jo/jb+rywH6Mkwi5VKIqdUn+z7pLG0mH8/Xdu1ClrSnI0F
         D3LvdA8xlycb8GyP3a6rCitQflEC7moRpyYaf5up3ILf0Xx0cSBVaMnvbFy8NVBts9GE
         5hECGlXekzHP+n599yioqGSTNeSbVPLdCnkcSBxJYGSOBFyrtH/4tmSwwxn2ZeMeC+1n
         AMsNcnG9GUeKoQDRdWRnVSFVTXhZtCpL5/fALCQksNQ+CACQun2/IQWigbCmHWXY7tc/
         DK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684198730; x=1686790730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVkJA3lTgCORmQkh7N6TzUrBQFxDZlWdNA3lW0Mj46Y=;
        b=Y0jU+nvOmetUzoLLjseQI/aNU4YphZ+yLiTNTnYimZN093dS7TV65ZHmHJoPRnXndC
         0n2azNGrj51NaXBADmLr79S4UdZWVi0dXn73PspoF0bt5H90Fj+ADT0YJ9koSxE5vjX7
         Y2TrG+jCQstrYgxbTPfcKqWAg4kfERCQF4nLEQLc8wnLJLCYPkbozXWfnYBavkneUi+F
         xjPtrO37xQMZ+vlgsqMQmF49KnC66ZU4JJtA3g939cq/1Hs5pzhRf0czjyi5TTg6AnpW
         kpmfdYMFuJZ9FW0RP8cJnWingbq+7zEnRCUfWRlJsgtUE8Mddh4s4m0WhVwajbrJPOWN
         5Mdw==
X-Gm-Message-State: AC+VfDw4SesRLtyDT8TJBLVmGxHoIJxgYzD1W+mQlHKhV+TleTBcw0TE
	fVfzhBOlwZVWJ1J4/YWRiRo=
X-Google-Smtp-Source: ACHHUZ59kkW3M/Lto4bJ5/I3FVMybYj2cauPWRT3XU4pPllt57pKl1czKu4W3Q3W8oduUHqHXWZ1MQ==
X-Received: by 2002:a17:902:e543:b0:1ac:8062:4f31 with SMTP id n3-20020a170902e54300b001ac80624f31mr39420635plf.37.1684198730328;
        Mon, 15 May 2023 17:58:50 -0700 (PDT)
Received: from localhost ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id v20-20020a17090ad59400b0024e1236f599sm232716pju.8.2023.05.15.17.58.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 May 2023 17:58:50 -0700 (PDT)
Date: Tue, 16 May 2023 09:06:40 +0800
From: Yue Hu <zbestahu@gmail.com>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Subject: Re: [PATCH v2] erofs: fix null-ptr-deref caused by
 erofs_xattr_prefixes_init
Message-ID: <20230516090640.00001a85.zbestahu@gmail.com>
In-Reply-To: <20230515103941.129784-1-jefflexu@linux.alibaba.com>
References: <20230515103941.129784-1-jefflexu@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Cc: linux-kernel@vger.kernel.org, zhangwen@coolpad.com, huyue2@coolpad.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, 15 May 2023 18:39:41 +0800
Jingbo Xu <jefflexu@linux.alibaba.com> wrote:

> Fragments and dedupe share one feature bit, and thus packed inode may not
> exist when fragment feature bit (dedupe feature bit exactly) is set, e.g.
> when deduplication feature is in use while fragments feature is not.  In
> this case, sbi->packed_inode could be NULL while fragments feature bit
> is set.
> 
> Fix this by accessing packed inode only when it exists.
> 
> Reported-by: syzbot+902d5a9373ae8f748a94@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=902d5a9373ae8f748a94
> Fixes: 9e382914617c ("erofs: add helpers to load long xattr name prefixes")
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Yue Hu <huyue2@coolpad.com>
