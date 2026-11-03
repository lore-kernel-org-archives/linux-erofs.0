Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC129606A32D
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 00:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=qjgGrLOm
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJVHY3S2zz3c4V;
	Tue, 03 Nov 2026 11:46:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793666761;
	cv=none; b=RQ2QvGjrkSaadCUWUdeVDI0mJgPfrAMNFjkDC8cz4goNYPbKx3apz766xHP+wlU2EWpa1T1s0PKgMZMgg0RED55kErO+XiBLL64Yi+SsKMYaxjNUFUUZN2spZnaPtbf6R3M6D9lXg1Hh4pZYyY54/d+C2KONaU5nmvlFdLTwQQRfDp3547b3n6Fi4fUb025Ytt0nXXi4uyfzJNWHGd6Y55VHidEcNiQgY8V8Ml0hySzNy8gjFmETEhN6lOY/BNjbv3F6DXO4DBaxOgfZ6UHH5ZYtw5N92PkJIh/Xx0O6+OvdfiExIJbn/+XFBbpioh2P5YEAKjdF1uB5Izy2EsSAhw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793666761; c=relaxed/relaxed;
	bh=g4Aw+SGHCHPx6znJnPOvK85mbdaafK2JSPQUb6dLCQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ5fRk1miHfTUAKxzquqUJ9iTZn4cvZH03fWGJRA/XVCvFqQRz45PETuylgAcjddeasll+sG7AnzdKwvM7nKM1SQ8EAGAhK1ReOMdUk8gAxGbez3SzTpvkXwoR+3tdQ+FgHiPmKTj+fAbCgka/7sGpVzj/A69dW1prJtYPDkOZ/WGvTI8jhXU7jqvUt1JMZu9RLJQcIxbZ5fnkRv7AIVI7AAIa4/Ap+7f6tuvUzJTKUJhtw+UEguefuRQyVuYZNyUIingJMjHbDBlyK/Ck8mDKmosHGDlkvTwO1yho+8vAqUQDmb1epVJAZ55DD4b9Ey46L4Gy41baiDQUGcOmS1xw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=qjgGrLOm; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32a; helo=mail-wm1-x32a.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=qjgGrLOm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32a; helo=mail-wm1-x32a.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJVHW1xX7z3c2V
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 11:45:59 +1100 (AEDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so30451225e9.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 16:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793666755; x=1794271555; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g4Aw+SGHCHPx6znJnPOvK85mbdaafK2JSPQUb6dLCQ8=;
        b=qjgGrLOm58sBwsWY5grI6HK2RB/3a6Y7pnoHZUYQJXKtYLtRGXNOnW3G2/xc+fE18D
         iqjGriYtbdloaD+R6soq+1bFRbiHa43uGZFqKfBS1jjH4znrJPRijAygWIs9Ftcy4GpY
         5RVbw6l9CGg5jlON9Vp/juGU/drpgpf31hZVuURnaiCzgmSm+t11IF+6lyCU/6d8rTay
         oqkevvhBLFSfPdVagA7n5KKUJi6F2I+KjvJDhUu9eP8LON48nUD6zgcEXyjZ90dSgwcX
         xp901Mr2EkaX7OJjoLmDvCNhb+QQOuRDUJCIU5SoGXVbB127VU02njNCIqKAXI+9Ks25
         /HDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666755; x=1794271555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g4Aw+SGHCHPx6znJnPOvK85mbdaafK2JSPQUb6dLCQ8=;
        b=HjyDfSTZIpe9/5ypTKI8bPISPP1LFZ2Kkh/+SB/I1Nj6vJrj4jGi9h7OdsfWf9Ycyd
         udna4YBLfcacw4FFYssffDsJLfCs0ziVQP3rIPAjB5hRG8WkgJb5aWRqzIWQj4MRx3w1
         Yj0bitIVVgv3GRnHn8QJHoIUbY3et8IL2k0kKm4+OUDXk8xn5Ec8DK3JuSrtnfjGwWAJ
         0xeGxpISbamK30MihHAS0LOoHLgf6JIXb0eN2lEzgWJNuHcQYTn9dFExMzBufVSTqp3t
         o1nScgyfm3T7BPNVdO1tl6J2U84dCxbbxA7WRniCyU5RWETL0v3/0534JDNXSkwFGB0x
         sExg==
X-Gm-Message-State: AFq9FYJzIoEMF6ysbeDpNNacpaPVEVMCTD6DBZE2kzSsp7rO4sddw26y
	3Skwk2kQxanc13FmI/dQRPHmAM2YULUbvvoRXnAvRw+BsCNLhKct10xmNUa7sg7hpxY3XV8/SCj
	FCFxoGUc=
X-Gm-Gg: AYBFou2UXsgpiz4m7tMey8S9syS7tgJdQK+Z8hE/AfL1K0Stfe2u8DZiNnpOsA8IC12
	tqFPeajKAGMbPOJChO9Y98uBRvmGkBlnzipdOf/o5AwQ+sahFPhIVMczGkjTC7WpbbV3zYv9ons
	QpeU8uEwNCkovbps5jdIkVbnxPIRBKqKBuirfSN/atwVyb7TsADAtMY2Nc58pWOCEmt5glfVaMN
	u9rP0xhr6133H/VfrZqwlarRk33qV2ih7aaPhUVXfhSXM4/PLDxghofKaO57pVYe2AUqs14DRhR
	3hVJ4pDNjocAXJCIcHwTc2mPhBfVqoGYxUs1I0cl1OhbFs9jBGnyccDiiG4tDEp/b197PYvNdYc
	XS3pPmWqIoEM+IT8vFBUJiEteFp1S5U17Rcx+5pmF3T8aScaDAqsQlP473DYAuge331UVlt24LZ
	IJN8allEANPS71UvkUBU48Xjc4ptlyAJzmZsOe5qDJ9PdOsAV7F+xDWSYuGFi7lgBAySjS2k0ji
	nY25Ie5GOs9Sxa8Za1mkOQks4gDrd9FsZuUjSxM5DX4Cis2G248pgcSiAW8zX/623Qw2XMQCoDU
	KMsUK4Fk9WXMICbv7Sxl3pS6j3GQ8tddIoxJIlw6xcDCDm/NmT3a5Tq2NURdYWGMqeyb
X-Received: by 2002:a05:600c:8116:b0:4a1:ddaa:571e with SMTP id 5b1f17b1804b1-4ac182dc29cmr252927315e9.15.1793666755405;
        Mon, 02 Nov 2026 16:45:55 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:3c00:331c:b5fa:ff22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm22078585e9.0.2026.11.02.16.45.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:45:55 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH 3/5] erofs-utils: lib: fix S3 and OCI portability
Date: Tue,  3 Nov 2026 01:45:45 +0100
Message-ID: <20261103004547.15053-3-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103004547.15053-1-xiang.gao@docker.com>
References: <20261103004547.15053-1-xiang.gao@docker.com>
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
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace strptime() and strcasestr() with portable timestamp parsing
and curl_strnequal() for the upcoming Windows builds.

Pass libcurl compiler flags to both test programs for static linking,
and build both when S3 and OCI are enabled.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/Makefile.am   |  9 +++++----
 lib/remotes/oci.c |  7 +++++--
 lib/remotes/s3.c  | 28 ++++++++++++++++++++++------
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 0a82915..f9b2ed2 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
 noinst_LTLIBRARIES = liberofs.la
+noinst_PROGRAMS =
 noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/block_list.h \
       $(top_srcdir)/include/erofs/config.h \
@@ -98,15 +99,15 @@ liberofs_la_CFLAGS += ${json_c_CFLAGS}
 liberofs_la_SOURCES += gzran.c
 
 if ENABLE_S3
-noinst_PROGRAMS = s3erofs_test
+noinst_PROGRAMS += s3erofs_test
 s3erofs_test_SOURCES = remotes/s3.c
-s3erofs_test_CFLAGS = -Wall -I$(top_srcdir)/include ${libxml2_CFLAGS} ${openssl_CFLAGS} -DTEST
+s3erofs_test_CFLAGS = -Wall -I$(top_srcdir)/include ${libcurl_CFLAGS} ${libxml2_CFLAGS} ${openssl_CFLAGS} -DTEST
 s3erofs_test_LDADD = liberofs.la $(LIBEROFS_LIBS)
 endif
 
 if ENABLE_OCI
-noinst_PROGRAMS = ocierofs_test
+noinst_PROGRAMS += ocierofs_test
 ocierofs_test_SOURCES = remotes/oci.c
-ocierofs_test_CFLAGS = -Wall -I$(top_srcdir)/include ${json_c_CFLAGS} -DTEST
+ocierofs_test_CFLAGS = -Wall -I$(top_srcdir)/include ${libcurl_CFLAGS} ${json_c_CFLAGS} -DTEST
 ocierofs_test_LDADD = liberofs.la $(LIBEROFS_LIBS)
 endif
diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index d395581..24d3902 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -360,8 +360,11 @@ static int ocierofs_extract_www_auth_info(const char *resp_data,
 	if (!resp_data)
 		return -EINVAL;
 
-	www_auth = strcasestr(resp_data, "www-authenticate:");
-	if (!www_auth)
+	for (www_auth = (char *)resp_data; *www_auth; ++www_auth)
+		if (curl_strnequal(www_auth, "www-authenticate:",
+				  sizeof("www-authenticate:") - 1))
+			break;
+	if (!*www_auth)
 		return -ENOENT;
 
 	line_end = strchr(www_auth, '\n');
diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index d9fda79..6baaa73 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -5,6 +5,7 @@
  * Created by Yifan Zhao <zhaoyifan28@huawei.com>
  */
 #define _GNU_SOURCE
+#include "erofs/internal.h"
 #include <stdio.h>
 #include <stdlib.h>
 #include <ctype.h>
@@ -12,7 +13,6 @@
 #include <curl/curl.h>
 #include <libxml/parser.h>
 #include <openssl/hmac.h>
-#include "erofs/internal.h"
 #include "erofs/print.h"
 #include "erofs/inode.h"
 #include "../liberofs_chunk.h"
@@ -689,6 +689,25 @@ struct s3erofs_object_iterator {
 	bool is_truncated;
 };
 
+static char *s3erofs_parse_timestamp(const char *str, struct tm *tm)
+{
+	int len = 0;
+
+	memset(tm, 0, sizeof(*tm));
+	if (sscanf(str, "%4d-%2d-%2dT%2d:%2d:%2d%n",
+		   &tm->tm_year, &tm->tm_mon, &tm->tm_mday,
+		   &tm->tm_hour, &tm->tm_min, &tm->tm_sec, &len) != 6 ||
+	    tm->tm_year < 0 || tm->tm_mon < 1 || tm->tm_mon > 12 ||
+	    tm->tm_mday < 1 || tm->tm_mday > 31 ||
+	    tm->tm_hour < 0 || tm->tm_hour > 23 ||
+	    tm->tm_min < 0 || tm->tm_min > 59 ||
+	    tm->tm_sec < 0 || tm->tm_sec > 60)
+		return NULL;
+	tm->tm_year -= 1900;
+	--tm->tm_mon;
+	return (char *)str + len;
+}
+
 static int s3erofs_parse_list_objects_one(xmlNodePtr node,
 					  struct s3erofs_object_info *info)
 {
@@ -705,7 +724,7 @@ static int s3erofs_parse_list_objects_one(xmlNodePtr node,
 				struct tm tm;
 				char *end;
 
-				end = strptime((char *)str, "%Y-%m-%dT%H:%M:%S", &tm);
+				end = s3erofs_parse_timestamp((char *)str, &tm);
 				if (!end || (*end != '.' && *end != 'Z' && *end != '\0')) {
 					xmlFree(str);
 					return -EIO;
@@ -717,10 +736,7 @@ static int s3erofs_parse_list_objects_one(xmlNodePtr node,
 						return -EIO;
 					}
 				}
-				/*
-				 * Not set by strptime(); tells mktime() to determine
-				 * whether daylight saving time is in effect
-				 */
+				/* Let mktime() determine whether DST is in effect. */
 				tm.tm_isdst = -1;
 				info->mtime = mktime(&tm);
 			}
-- 
2.54.0 (Apple Git-157)


