Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE10606A31E
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Nov 2026 03:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MBxonUp4
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jYT5S23HDz2y2b;
	Tue, 24 Nov 2026 14:37:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1348"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795491436;
	cv=none; b=mbGQhYG8/qIvRia1DOjE3S8jsfRMNuemcINMSaOrYscf58ori2QIxo9lr5O7ZSnXMQyIXRSNKAB26NOZtQya2YYsybMnDQNLPP/9KGG5D3MKiZP+Bvm7RxDO90FLiV8Oq+4k91KNDeZO8FRF/gkpnW2q4z/EjbfxZOa3M63kzs+EfHRhpUXzomWn11PXLWdqHcjJShAQXluUOAarG/ilKVRPKOSdOn6NzheJ3Taqe50fGXUY8OoISmv8AjVR4Uj9K72rKkI0csUEe0dTea1pzSAAi2kis4zUul4+AVr3jP7lSZrW8vEGuMPtyggiShef76UgyG4qlhifR4FJVeO2hg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795491436; c=relaxed/relaxed;
	bh=uDG1RJSmWdo8vSOwgeBff+qT3aagATVcwdDZ+WsiaR8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gyJUvEooZBlMm/uL4T7CQMZ1LDczYfWU7rRS+R3Ihv0TFSVCLp8gG8+LA0dEGFDsHhvhvCZn8lglwggSzZeFHzqpCr4tuZNiOhRwUdaaNw7224xwY/FE0fifOClDj//6Za0Ke4wQNfFfGx/WXHV+iaY9QkFeWbUuYUcxQ++bjhsAGGrEllXKhHqRueN6IVHNP8sBqBW4MCSzLiKQFOfzfVLGjEVliB7wdhnIEFPbRjE9IAZ+q0fBxUnGbJC5Zzhz+4XSfItAijRNlheyn3KjADXMCYjDhsQ3UYSDSGuiSEr40DFQILEvoTGfgA/dWCy88ML+aadxvZzlAntDxt5xXQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MBxonUp4; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1348; helo=mail-dy1-x1348.google.com; envelope-from=3zgyfawokc-uupshfchpzonvvnsl.jvtspube-lyvmzspzaz.vgshiz.vyn@flex--nilayvaish.bounces.google.com; receiver=lists.ozlabs.org) smtp.mailfrom=flex--nilayvaish.bounces.google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MBxonUp4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--nilayvaish.bounces.google.com (client-ip=2607:f8b0:4864:20::1348; helo=mail-dy1-x1348.google.com; envelope-from=3zgyfawokc-uupshfchpzonvvnsl.jvtspube-lyvmzspzaz.vgshiz.vyn@flex--nilayvaish.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x1348.google.com (mail-dy1-x1348.google.com [IPv6:2607:f8b0:4864:20::1348])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jYT5Q3Gxnz2xNT
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Nov 2026 14:37:13 +1100 (AEDT)
Received: by mail-dy1-x1348.google.com with SMTP id 5a478bee46e88-341eff9e381so6530866eec.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 23 Nov 2026 19:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795491431; x=1796096231; darn=lists.ozlabs.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uDG1RJSmWdo8vSOwgeBff+qT3aagATVcwdDZ+WsiaR8=;
        b=MBxonUp4RXZZKA96767jxMpawphtXYpMYJ1ONpB4ab37CfyRp3PoQzUM35U1lIhPin
         44j+8wgU/PeYJKa8rdqnOd4GdbLbHcI24d08wbP6ylNPkIYpfhAj5e2l80M3uffHUy6c
         MZmzZ7oAYfElcZzWX6Le3I9VrEAoSFDG/E0EhFT0ZHsLRxhDv0OO01GpN8pewRgivZkd
         B4ulOAewGB1N7FrVwlbOPJVkG+okqWExugeqn9U4GH8bHchPRgmmaa7EDh5q2y5oQN5B
         lPmlxJALRc6kaec4aNYYZn3VsyMxCQB5lynQoCarHZ+qmr/2dqWfPCFAe8VgVU9u/HuQ
         UWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491431; x=1796096231;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uDG1RJSmWdo8vSOwgeBff+qT3aagATVcwdDZ+WsiaR8=;
        b=1HUqoee70hIg/m1Fuv3dviHBvAEXPRpwZ0O172jqajzWOGz2smRU79w/pkqr/sDpp9
         WaKFBnXaLXJuEXIHRdVeyunKA66TdHQ66xkVeqQZaUfC54y/u2sxRRIK/aSu2xHPM71x
         n3KjC5nsB7J7Xb1VJBJo/joRSxeXIWJq/ObNlojRjlAMIkxY5Xiw8EeZQztAU8WMNT9k
         WY7AP0tyOKdgnJjSUy4Xi09g+nRwAj8IZn5+TPcXk7VDudOxSeovUaxXAyAHNFUc63BQ
         rHz0n//Iu3KcbREbmtI1R7DRH4cE46P/MsPm8HJDWpP5AeG2l2B5MeWlJdgofTBJ5y0m
         FI7Q==
X-Forwarded-Encrypted: i=1; AL+hErHQFi/A7pziIJgin9X5DHxsY+0QW7R7o6Z2pwQUG2jHIdcMtp2sal8DSLe6R2Q1aLnIT0sqC7CAEgp2fg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/dyMATlMJuGXYfI/U2np81+eMXSymTVopoBLZat5ZmS0qRA3yo
	wjkMsDU6at/0689anLaV293jTr+yrKrFpx/xJJ3S2amythzeUa8I1/NZf7FkkmjwlXdNnulHXVI
	hE2uLUZoGoVu8jkawJGpsRA==
X-Received: from dlxx13.prod.google.com ([2002:a05:7022:408d:b0:1b2:4b00:1331])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2209:b0:1b2:43ac:d3a3 with SMTP id a92af1059eb24-1b5568b9e59mr17010052c88.24.1795491430211;
 Mon, 23 Nov 2026 19:37:10 -0800 (PST)
Date: Mon, 23 Nov 2026 19:37:01 -0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261124033701.832938-1-nilayvaish@google.com>
Subject: [PATCH] erofs: use page_private() in z_erofs_is_shortlived_page()
From: Nilay Vaish <nilayvaish@google.com>
To: Gao Xiang <xiang@kernel.org>
Cc: Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Short-lived pages are marked with set_page_private(), but
z_erofs_is_shortlived_page() tests the marker by reading page->private
directly.

struct page is being shrunk as part of the memdesc work, and its private
field is one of those that will move. Direct users have to go through
the accessors before that can happen.

Read the marker with page_private(), to match how it is set.

No functional change.

Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---

Notes:
    This patch was written with the help of an AI coding assistant (Gemini).
    
    Based on next-20261123.

 fs/erofs/compress.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/compress.h b/fs/erofs/compress.h
index 84c8e52581f4..a9ff02b443a8 100644
--- a/fs/erofs/compress.h
+++ b/fs/erofs/compress.h
@@ -41,7 +41,7 @@ struct z_erofs_decompressor {
  */
 static inline bool z_erofs_is_shortlived_page(struct page *page)
 {
-	return page->private == Z_EROFS_SHORTLIVED_PAGE;
+	return page_private(page) == Z_EROFS_SHORTLIVED_PAGE;
 }
 
 static inline bool z_erofs_put_shortlivedpage(struct page **pagepool,

base-commit: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
prerequisite-patch-id: d52d42a2ec9ddc2b12b3412ec0d07254b417e60f
prerequisite-patch-id: d8338f943ba7ae297eefbb26dabc3bcfe7994461
-- 
2.56.1.839.g22a8290db9-goog


