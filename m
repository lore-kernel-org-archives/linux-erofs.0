Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EB4C77B7A
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Jun 2023 09:38:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QXdH769rkz3f03
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Jun 2023 19:38:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20221208 header.b=oB1+bWpw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::730; helo=mail-qk1-x730.google.com; envelope-from=zbestahu@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20221208 header.b=oB1+bWpw;
	dkim-atps=neutral
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QXdGz4KnXz2yfg
	for <linux-erofs@lists.ozlabs.org>; Fri,  2 Jun 2023 19:38:35 +1000 (AEST)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75affe977abso208509085a.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 02 Jun 2023 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685698712; x=1688290712;
        h=references:in-reply-to:references:in-reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jtuuDI286V2NtQdr3A1YRLIlMVtJQoVa9FQQN9XBRoU=;
        b=oB1+bWpwJ7nn8dMBViA6WXaSPD2sIhvQEUdkMp2xxfb3gdb7K+5fSkqu2Q+gJ6jGBi
         aBN1LeFME4kS0FWaECewoLnMR1GbrcofIhEnjpD2R/48MU62ki4CN+Ji33L5sjU5cOmi
         S2GAtO1TFNC1Z4B+yx3cti3n7csfYjLzBEdwDGu1wqDq9Ynp8PWeviYrYKrTvIiHS00O
         J2HryKKDuuWR9RwvR7N64yvxdXvrGr8mjlkCXOhpQ8hTtfnMJenQfy0DLgfbNLPaqd5z
         rbgvDylJj0MMj19akeRn5e6y+eTQK6hrgUdQQnzFcy79UAQF2Ga6SO8z66XW1UfB4MBe
         3kJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685698712; x=1688290712;
        h=references:in-reply-to:references:in-reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtuuDI286V2NtQdr3A1YRLIlMVtJQoVa9FQQN9XBRoU=;
        b=NhNvtMFQllSF9gqdRDJgo2HqLQWywQo8JACBvwu8WhRyNoGZdTN+MTIYnMJi4CYb78
         iIuGA7+spjpk6DUVhaq9z8Hdaf3v06QUeu1eLX8hKIl9G4L1RsXUBbLG17tjWS6d56Ng
         /Wp5AxeOHpB/c32CSOmVeUB4tKzmvVUS84TzTZNcTuYWMWWcV0Jb56S9Q58GyPEx7Apl
         1YFBdCMG2oojuJv0OjhSkJWn9VqjL+lmimmOR9vgVIC+wi1Cl3U4pYqGXDD3CBr1gSWY
         x928iPnXo01RkjLSp5rjoXCa773rl3qTJ9IxKSR60uLu0MGZauhuEXbdIgnYDFV3/PhU
         6vxA==
X-Gm-Message-State: AC+VfDzEm3t6xO01w4Ex3RnX2ies0rsCiET0431PCYiVxUbWkHyNx/xC
	n4t/Fgd1iXQfcxxU2aIpjvahDH69vUY=
X-Google-Smtp-Source: ACHHUZ7/KC6rPOW6xmngSqbbufH8KkB7YooYeOI+iIBwLX8Ei+685+FWMHR0OeL4AHNiLuUnlIuMvQ==
X-Received: by 2002:ad4:5b8f:0:b0:621:2ad5:df74 with SMTP id 15-20020ad45b8f000000b006212ad5df74mr14208070qvp.51.1685698712475;
        Fri, 02 Jun 2023 02:38:32 -0700 (PDT)
Received: from localhost.localdomain ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id n24-20020a170902969800b001a072aedec7sm917210plp.75.2023.06.02.02.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 02:38:32 -0700 (PDT)
From: Yue Hu <zbestahu@gmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: fsck: check packed inode only by valid packed_nid
Date: Fri,  2 Jun 2023 17:37:55 +0800
Message-Id: <ba534c32f9a96d6492917b5bf333d31edc936d31.1685697802.git.huyue2@coolpad.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <b07be6197e879b8200b4c25f91957d6a206dc143.1685697802.git.huyue2@coolpad.com>
References: <b07be6197e879b8200b4c25f91957d6a206dc143.1685697802.git.huyue2@coolpad.com>
In-Reply-To: <b07be6197e879b8200b4c25f91957d6a206dc143.1685697802.git.huyue2@coolpad.com>
References: <b07be6197e879b8200b4c25f91957d6a206dc143.1685697802.git.huyue2@coolpad.com>
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
Cc: sunshijie@xiaomi.com, huyue2@coolpad.com, zhangwen@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@coolpad.com>

Since dedupe feature is also using the same feature bit as fragments.

Fixes: 017f5b402d14 ("erofs-utils: fsck: add a check to packed inode")
Signed-off-by: Yue Hu <huyue2@coolpad.com>
---
 fsck/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsck/main.c b/fsck/main.c
index ad40537..de59532 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -789,7 +789,7 @@ int main(int argc, char **argv)
 		goto exit_put_super;
 	}
 
-	if (erofs_sb_has_fragments()) {
+	if (sbi.packed_nid > 0) {
 		err = erofsfsck_check_inode(sbi.packed_nid, sbi.packed_nid);
 		if (err) {
 			erofs_err("failed to verify packed file");
-- 
2.17.1

