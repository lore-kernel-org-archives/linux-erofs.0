Return-Path: <linux-erofs+bounces-4101-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38587C55184
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 03:32:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDfJ05SNyz2ygL;
	Tue, 04 Aug 2026 13:32:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::435"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785814368;
	cv=none; b=HDB9yxhCrzApA/d6WpACihBR51osgmStMaR5mW1YZvXT2fO4Td6Evzu5ZxManFEmG/pMDP6uU7ZE0xj5pks9K1KF+/vO+mRAhe4QqEIXn/G43YsfLlwQWg6DmqCQa6WNxd1pvcO3eu1WvVLjvUj56OIMGbvi+7konRb7/cjvizONl4w+JyYEdGP2BG7FZnE6BNLl5mA5hwwa3+H0g5cq/6fr0V2SuGFJ5aNy9OZfVVDA3kNfHXzJ99xvGXcD8+EwcUdkXpRYBte2hnOhASK5QftZahEqovnIi7czPwgWhj0ztD17uZe2h7W14QXKiNWSvW43ekENWJ4PO/N+glxgBg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785814368; c=relaxed/relaxed;
	bh=REw3j/vkkWZkoY1sEQxS0KlIV5p8ig8SVv24c5jMtTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7SVQoESjj9qzx4/EIpHFRy8Axq1nReww8YRvbSff+0da/qQH6AUIJ3d28eOP1OWfdqJvAQz8gc9c8yT0IHj97qges/RzrJHilXecLH8d1N4Nz7YREQ6+fqyEfhC4NIsMxbJTWgGWTDP3pl4KOHQt2a2OxrwrHbz0zwsUrZ6udb5+O6xeM2WOqs5tP2mWo74jjQtK73C/LMX8PdU7WhW0yVngiVheQsKbRmxtBbJKsA46N7jcVRny9HgoSRmisPj8uB6Yra11wyWYxWAewFNwP+zASIepiMeYQGyy2v2MjRcQqbwIJ0d4TZxgVfE2tZmSY9z/hANdO7ftQR1ZCGCTw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=oMWKK+aC; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=oMWKK+aC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDfHz5FqSz2xns
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 13:32:47 +1000 (AEST)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-47de0093c42so2800466f8f.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 20:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1785814364; x=1786419164; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REw3j/vkkWZkoY1sEQxS0KlIV5p8ig8SVv24c5jMtTQ=;
        b=oMWKK+aCDxTA3lmHxfgScNkPLhGLwPx8pQsoHcm/X8jZ9pQGV1sBMLJcR98Apt4sfW
         +/6fBDP1CEr9In1w+PXB3hJerf1XU4zCmWnxGfdJnWWQqWwR+16jXj2Csu4zZdBIyvao
         kRtSRKQV7OcPR0FBIdgywNMpEXiXPFvr8sWAFkjl0+xy0Aw4a1Sk5WwXHwezTLYKnawA
         cbqNIPN7qOQrZHOZOLHuWcKZUKSC0X00+cmUTwkWsR/5U2X9PcmOQ9k10vHh/jMlZiAu
         muWOAFptdUdtD1mEUKEAwp6c9jRkqw2q6m63RdRIPJ/KeZVwuAXpAfGYIxXpCpLh2NN9
         XgfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785814364; x=1786419164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=REw3j/vkkWZkoY1sEQxS0KlIV5p8ig8SVv24c5jMtTQ=;
        b=AYjorzXGdbaxhFKQPSslffhRv2zi/+SfoqHgmWMd7QlxKSSnE3VPF6C1meE+El+z7J
         6NP7E6QS+XkA8ykYIN55imKCKh4dfWMigwU2jKFi0IcFZfoxjzArxbheSf/jr4XeiBkQ
         qrNEpymf+xhucncvpTdQpFYaHHcaU0uGBd5cAkcHLYvQp019ilnRonpalVfXx03TLZLp
         /BCezjla2i2u5w7O/iM7h2sBYBwV8/4GJ5Q55N3Yhu38KEvy+wJOC9WifHcppSsKBJV/
         xp9WucIpl6n+d5wBNOGl5X/OVPrjOvxKm9FiEz4/iJJ8FXcPMFjaPG6cGp07l4d7Hu+Q
         md8g==
X-Gm-Message-State: AOJu0YyWePNkxKUQzn8Wn/OayVbs77Gqe7xKlgn7W1LccqwGgvESYHKi
	y+AwctjC2kvFPX+CK8RIZPIRy24EjIUHiAHf0Aiog4L+UK+C+mq0no5Qba8SE9zBEBGVwhuTZUW
	ITp4W6/BA
X-Gm-Gg: AR+sD12DuPOty19YYTXta8QB7+Jmo939UDARYNv+zbLmiKKf9phUrhVPiWgok4MURIA
	3fQ8vn0QKgFSponZP4Nd/AJ/zrpuVpQBPoerdFqUuf9gxCZJBdYlRK6ad8Ivlod+6NlWzRGyA7X
	1HrxJGy5x9ausox38NButc5tiArOJcjk6YYnlrTIPQMaOZJLPEi437GA5b1edcCh6yNkILpyP2M
	onHVjUsgNLoUfzyu9GV3y2OIynvXGNPuCvBKi5F8Znh6fkBX1crQvp/Z2yIP6HppNtAac1uNine
	Iq9dMamWK2niJgtNa2NIsUH4fijzXqj7PFAUn7B/fd8VpTeSTNIAe6sDsEwuoG2OnWbWO9hpqIA
	rIDicVIoXhEgL24QbcctOVOI6v7zLwWKHr3XCu73AkSUKN2Tyu1ER/ZPrHdODzinaSRHSb/4+yH
	5n40aiQoAkKQ8fhj6FYdTlp6opqcl7q4C5X5JCBv3JveIl24U5Zml1v3FD3XhkG4RH/93XeE/Bz
	lEz1Hs1379hY03dQKtjkmTYo0jewYeiskgOzEmlUCIC5nR9UWSi6uSER+s=
X-Received: by 2002:a05:6000:22c2:b0:47f:c648:e265 with SMTP id ffacd0b85a97d-47fd9cf7670mr31159171f8f.17.1785814363597;
        Mon, 03 Aug 2026 20:32:43 -0700 (PDT)
Received: from fedora.fritz.box (p200300c78f45f4002fc0e22e545c127a.dip0.t-ipconnect.de. [2003:c7:8f45:f400:2fc0:e22e:545c:127a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd42d91bfsm41286329f8f.15.2026.08.03.20.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:32:43 -0700 (PDT)
From: Martin Pitt <martin@amutable.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Martin Pitt <martin@amutable.com>
Subject: [PATCH 2/3] erofs-utils: tests: look up programs with command -v
Date: Tue,  4 Aug 2026 05:32:13 +0200
Message-ID: <20260804033214.211267-3-martin@amutable.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804033214.211267-1-martin@amutable.com>
References: <20260804033214.211267-1-martin@amutable.com>
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
Content-Transfer-Encoding: 8bit

`which` stopped being installed by default in recent distros, and it is
not needed at all. Use the POSIX `command -v` instead.

Drop a doubled "unless" from the POSIX compliant note.

Signed-off-by: Martin Pitt <martin@amutable.com>
---
 tests/Makefile.am | 2 +-
 tests/common/rc   | 8 ++++----
 tests/erofs/028   | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 2f109b8..c0291ac 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -137,7 +137,7 @@ TESTS += erofs/031
 
 # NOTE: When adding a new test case or updating an existing one, please write
 # POSIX-compliant shell scripts and avoid using Linux-specific features unless
-# unless the test case is expected to run only on Linux platforms.
+# the test case is expected to run only on Linux platforms.
 
 EXTRA_DIST = common/rc erofs
 
diff --git a/tests/common/rc b/tests/common/rc
index 78e704d..aa7ef99 100644
--- a/tests/common/rc
+++ b/tests/common/rc
@@ -48,10 +48,10 @@ _fatal()
     exit 1
 }
 
-export MOUNT_PROG="$(which mount)"
+export MOUNT_PROG="$(command -v mount)"
 [ "$MOUNT_PROG" = "" ] && _fatal "mount not found"
 
-export UMOUNT_PROG="$(which umount)"
+export UMOUNT_PROG="$(command -v umount)"
 [ "$UMOUNT_PROG" = "" ] && _fatal "umount not found"
 [ "$MKFS_EROFS_PROG" = "" ] && _fatal "mkfs.erofs not found"
 
@@ -94,7 +94,7 @@ _require_root()
 
 _require_xattr()
 {
-	which setfattr >/dev/null 2>&1 ||
+	command -v setfattr >/dev/null 2>&1 ||
 		_notrun "attr isn't installed, skipped."
 }
 
@@ -309,7 +309,7 @@ _do_unmount()
 {
 	local mnt_path=$1
 
-	if [ "$FSTYP" = "erofsfuse" -a "$(which fusermount > /dev/null && echo ok)" = "ok" ]; then
+	if [ "$FSTYP" = "erofsfuse" ] && command -v fusermount > /dev/null 2>&1; then
 		fusermount -u $mnt_path
 	else
 		$UMOUNT_PROG $mnt_path
diff --git a/tests/erofs/028 b/tests/erofs/028
index bf31c3f..05d9a5e 100755
--- a/tests/erofs/028
+++ b/tests/erofs/028
@@ -42,9 +42,9 @@ check_ishare()
 _require_erofs
 _require_erofs_inode_sharing
 _require_erofs_compression "-zlz4"
-which strace > /dev/null 2>&1 || _notrun "strace is not found"
-which fincore > /dev/null 2>&1 || _notrun "fincore is not found"
-which fadvise > /dev/null 2>&1 || _notrun "fadvise is not found"
+command -v strace > /dev/null 2>&1 || _notrun "strace is not found"
+command -v fincore > /dev/null 2>&1 || _notrun "fincore is not found"
+command -v fadvise > /dev/null 2>&1 || _notrun "fadvise is not found"
 
 # remove previous $seqres.full before test
 rm -f $seqres.full
-- 
2.55.0


