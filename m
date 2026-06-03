Return-Path: <linux-erofs+bounces-3512-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D826CD6E64
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2026 10:08:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gVk1G3SQcz2ybQ;
	Wed, 03 Jun 2026 20:08:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780481314;
	cv=none; b=BpRLHUhbEhStbBKMPtT4GpgpaRgJL16FNQoOlAFQX0Lzk4x9nzj27V2/w2y9ro/KsCp+5vqJ/vCwqP7d2mKNpGOmnas1PbF+EUJr6+xR9yhW0YDPWkBE4ullQoNVHA9Uub0tW3zFBN8Yi/V+0d/S96alhN1MPjfOd7Y5tanXjQgVeoCAj/Ozt1yQZw92Mf8gK4vWwdiWXbd8eEfXyqKOEZDcwXeqMLXc8ouEkr5jq4d2lJX89QiwJNd5Gs83yuGNrS1NEJWh0DB8+pgeOn7ivKxRrwBRlx4n7twNTnuBIAI55aNvYOb9ZHKuEqGzimyJK8ESBk9y9VTICz+kYuN2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780481314; c=relaxed/relaxed;
	bh=na6QPKW0qMMSeAE1Te/Tb8VZeJaR84E/3Y8DLdNoIW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWPJobkTXd2Zo2qB5eqBjn62HQ7IXQXcF1ZdDP5gjmhwL/be7ksgp1dW23oIa6T8DdVREjFHHeQO4HHiEo19+ryJz0T39T1dKPMr8RqjsNJaOWasR3a7IlFi2BYvqXUrUinlqAzqQx3cdkScS1GvDepwTCb35+AGKPkqCoglkMui2h5+KuPBsG3LwypWr4SupX8gYGUc0pjinS2Xvecjb285f3BUOpitlUzfenqs+TOJ6BgplIff77+3O0h8KFlqdK0BGSxkKA2WfYat6pKKgUTbsAcmXNkL62yFXdtG19VZgg3ocXiDTTqdtkwbdOoMmIefqQOfNIUJYJUpdLuzDQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YszBflaB; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YszBflaB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gVk1C28ZCz2yL8
	for <linux-erofs@lists.ozlabs.org>; Wed, 03 Jun 2026 20:08:29 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780481300; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=na6QPKW0qMMSeAE1Te/Tb8VZeJaR84E/3Y8DLdNoIW8=;
	b=YszBflaBTTM93NE8/XZraehIY3cz8Q6qJOPgUQQraJ+HUd7vBNN29105WybkRQ9hjVDpuQfKFZUmXByqyufrGi7UlkelkzCI1w1NiiMBQraPgsQYUFK0TKlOXxAP2BKVLTxHaUhGrEoctU9mf4ynjoruG/w2SRqtrUYZD3hBlKI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X477l-7_1780481297;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X477l-7_1780481297 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 18:08:18 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 2/2] erofs-utils: tar: handle empty values in pax extended headers
Date: Wed,  3 Jun 2026 18:08:12 +0800
Message-ID: <20260603100812.2617238-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260603100812.2617238-1-hsiangkao@linux.alibaba.com>
References: <20260603100812.2617238-1-hsiangkao@linux.alibaba.com>
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

As POSIX pax(1) [1] says,

If the <value> field is zero length, it shall delete any header block
field, previously entered extended header value, or global extended
header value of the same name.

Note that extended attribute removal is not implemented yet.

[1] https://pubs.opengroup.org/onlinepubs/009695399/utilities/pax.html
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/tar.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/lib/tar.c b/lib/tar.c
index c522bc3f21e1..9e53af511c0c 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -487,7 +487,7 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 
 	while (p < buf + size) {
 		char *kv, *key, *value;
-		int len, n;
+		int len, n, j;
 		/* extended records are of the format: "LEN NAME=VALUE\n" */
 		ret = sscanf(p, "%d %n", &len, &n);
 		if (ret < 1 || len <= n || len > buf + size - p) {
@@ -514,20 +514,25 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 			value++;
 
 			if (!strncmp(kv, "path=", sizeof("path=") - 1)) {
-				int j = p - 1 - value;
 				free(eh->path);
+				if (!*value) {
+					eh->path = NULL;
+					continue;
+				}
+				j = p - 1 - value;
 				eh->path = strdup(value);
 				while (j && eh->path[j - 1] == '/')
 					eh->path[--j] = '\0';
 			} else if (!strncmp(kv, "linkpath=",
 					sizeof("linkpath=") - 1)) {
 				free(eh->link);
-				eh->link = strdup(value);
+				eh->link = *value ? strdup(value) : NULL;
 			} else if (!strncmp(kv, "mtime=",
 					sizeof("mtime=") - 1)) {
-				unsigned int ns = 0;
-				int digits = 0;
-
+				if (!*value) {
+					eh->use_mtime = false;
+					continue;
+				}
 				ret = sscanf(value, "%lld %n", &lln, &n);
 				if(ret < 1) {
 					ret = -EIO;
@@ -535,6 +540,9 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 				}
 				eh->st.st_mtime = lln;
 				if (value[n] == '.') {
+					unsigned int ns = 0;
+					int digits = 0;
+
 					while (value[n + 1] >= '0' &&
 					       value[n + 1] <= '9') {
 						if (digits < 9)
@@ -566,6 +574,10 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 				eh->use_mtime = true;
 			} else if (!strncmp(kv, "size=",
 					sizeof("size=") - 1)) {
+				if (!*value) {
+					eh->use_size = false;
+					continue;
+				}
 				ret = sscanf(value, "%lld %n", &lln, &n);
 				if(ret < 1 || value[n] != '\0') {
 					ret = -EIO;
@@ -580,6 +592,10 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 				eh->st.st_size = lln;
 				eh->use_size = true;
 			} else if (!strncmp(kv, "uid=", sizeof("uid=") - 1)) {
+				if (!*value) {
+					eh->use_uid = false;
+					continue;
+				}
 				ret = sscanf(value, "%lld %n", &lln, &n);
 				if(ret < 1 || value[n] != '\0') {
 					ret = -EIO;
@@ -588,6 +604,10 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 				eh->st.st_uid = lln;
 				eh->use_uid = true;
 			} else if (!strncmp(kv, "gid=", sizeof("gid=") - 1)) {
+				if (!*value) {
+					eh->use_gid = false;
+					continue;
+				}
 				ret = sscanf(value, "%lld %n", &lln, &n);
 				if(ret < 1 || value[n] != '\0') {
 					ret = -EIO;
-- 
2.43.5


