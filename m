Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE450606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 07:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bovjj0eN
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVVtB4KRSz2y0B;
	Thu, 19 Nov 2026 18:47:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795074434;
	cv=none; b=L/g72LtqchsUw45DJHillRobvSGlCfkVEaai/I7LVa1KfWiLKoY1JZj6o42LicAGWiq9KaCUsJMKqXLH7Jb3FzLQ51gteooOoT2M/ZRTVMbBiCusywtzdrfsDSFlkbH3V0f/fIEBq4ooB5E0awKfjGEMBD24TuXIV44ovVurAtM1bEqKq7AfisPn4ZDC46ai/ghHT17c7NiCoJmGVGqZwJ0g4C3s6H5E7TnHM0vIYYSAa/S9jfPnY3mzvcd2dZq3D6gxf3FTvPO74kyfBzA+wSh1mcKuWaLtYdrAvVQHMbZjMlNJr0kENZxFhg9ZJ0S+a/cLxVfYG7ZYMtjLG4XYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795074434; c=relaxed/relaxed;
	bh=jILdaTrHOcDuphrTR11TMKHESrHboeP5KnFHqK1n210=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHjW7N2rfaAVTyxLaMRtCis8cpRZwGNTrZmlhTSy1NAJIPKfGXBvSf/ycAyBQz1vYyX3s+A8zHd6Obgsy73kzq7jCvAcwkgGXyBs6aFlqQvXHgKugseZ3FNjQvgLa0Jjip4p3LXzWQJo+yF3t1IvoRcFaoLE4Lsr5Hw/sshfVsKgkQVpZtFrtHeomtmTpyx54JdlcgT31jXWiy4/lj8knvsHac2HRRqNU7/2Nkn3oGJ38Zt/ssYqyrlDgzWQ567qyClqsTb3xfc0B9c+XDKvSBL3GvPmd/YjZy3ijscDJkVptkv7o5hK3yZMvbm195OwXMQw3JpCfAsZNO3KzyvlEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bovjj0eN; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::32f; helo=mail-ot1-x32f.google.com; envelope-from=uekawa@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bovjj0eN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::32f; helo=mail-ot1-x32f.google.com; envelope-from=uekawa@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVVt92SSLz2xlk
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 18:47:13 +1100 (AEDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-86298f9267fso1080297a34.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 23:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795074431; x=1795679231; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jILdaTrHOcDuphrTR11TMKHESrHboeP5KnFHqK1n210=;
        b=bovjj0eNIPn5+9i+4XcGgmJgxpWSbNMXXZ6fS8Pk6YtYGqEIIZzwsL2N8XYmOXiDPT
         Gx0Hc2zft7MSm8sdpPdbIn/1305DtEW1CPULls1kQe6oR+8iuFIIFXtXZG5yEM4v6wnt
         al85vL1T+ppZnwDU6I90KzcpOft0p+yPFI3hg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795074431; x=1795679231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jILdaTrHOcDuphrTR11TMKHESrHboeP5KnFHqK1n210=;
        b=jfAMkGcHMtK06/9heMYRsWUm7bDk1AzYh1pTJD+2lERXwT5hPCu+mIWLCqOEayYK3N
         +EaoAPfaZ1ceEY8eyYep4uJEKMRvyORlBZ7iFfnuR3VQPOYMMEGyEX5BlHeFNMoQDrKL
         hZST19XslavgkcSwIG/gHbm3eWaYgGdfL50FyzfDvcMIl6EZw7Mp8Z4UV/0g8MhdV9Dy
         KvDJGK3r9CiQmCcLLSs6ixrgqd1q2OZ6afveaYga6Q2kFcCzkazrQ7xQ12YOVDSfXTzo
         EbGJ/emVTtihUDP9fSDe716l6F5p0N9C1mCpaYdv3vQ07qC6T/CrtTezAo/6ii8D979Z
         rbdg==
X-Gm-Message-State: APuU4Z9iAJQ3kIhiWFZ+5Yx85ep8dPjhq/mMMXM0xmTpOW7KTWTo7IqK
	cZjZzvHXCLSXNo0Ub4WIL8scNfzLBQ8K+aA6ZmqYTua+Pss3YmeoJY8W5HRlGPh/C8rOPm0ktuF
	5U0SWX2M5
X-Gm-Gg: AYBFou2/oq9YuY7kQej+nT2Dyf2NugSfg6GueMx4SCY7kwCEmgjJO82bRyzrWKx1A7L
	Lxz9frRg/8tvGsCAdR0h+t3stsvU/RNJwT5zAfqWM4gMFXr3ByvXEOeuuhRLqjaTlo7rZ2gudQe
	4fHm0/gupFyAuqmv7G6lMyUYjroMqlkar2war7oEMZqZNeHd3q3CT68XUOSTWJRXWQfkj5gK+kV
	92HCnb6o4DuQmd2qgWWmkcdPzWXL6tFLss9pNVC0SrCYLuv/Yd//Oa+6bQcLT3K6f708YqUki8C
	xyX+tOgXsl+72goEQwoDgH7HV7athsR/P8POqjXTy3z7icNoSOTF2D5jk6jh2qrbdBH/LRFZBRU
	xIX510MJFKtdWnXm65Jat3woyQRVI2UEI98uo/9ggtuijIw/GUkbpiOqQX30486ciqrO0XCHwuR
	KTYEoEoeIiYCxE4yMZCbl/vHn/DoTDfW6OMbeWF2rBXT75gnnYAGTh1zzxTxM1ReUHKl7/e5z45
	NmKI2GXWukzIRSgGPXQ/FHC+LgOImMcYGOkKY6qr4JeNULHYKrdStL0hcrpOW/U3ZxgC/Be6pDM
	hAnVi02p25Hm0HsOxMA9U13hutEfHsG1kUuTMM99kA7XLiWrWTh6ngxZvxLzuodnudkXyR2cU6P
	B8jhxDSFDdwqbbXk=
X-Received: by 2002:a05:6830:3d8f:b0:80c:d30f:97d with SMTP id 46e09a7af769-862f0959ae0mr5889094a34.30.1795074430979;
        Wed, 18 Nov 2026 23:47:10 -0800 (PST)
Received: from localhost (139.118.171.34.bc.googleusercontent.com. [34.171.118.139])
        by smtp.gmail.com with UTF8SMTPSA id 46e09a7af769-862f01d4737sm3798520a34.7.2026.11.18.23.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:47:10 -0800 (PST)
From: Junichi Uekawa <uekawa@chromium.org>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	sarthakkukreti@google.com,
	jaegeuk@google.com,
	Junichi Uekawa <uekawa@chromium.org>
Subject: [PATCH 2/2] erofs-utils: fix BoringSSL build in s3.c and configure.ac
Date: Thu, 19 Nov 2026 16:46:22 +0900
Message-ID: <20261119074622.2199394-2-uekawa@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261119074622.2199394-1-uekawa@chromium.org>
References: <20261119074622.2199394-1-uekawa@chromium.org>
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

When building erofs-utils with --with-openssl against BoringSSL:

- lib/remotes/s3.c calls EVP_EncodeBlock() and EVP_Digest() while only
  including <openssl/hmac.h>. Unlike OpenSSL, BoringSSL's
  <openssl/hmac.h> does not transitively include <openssl/evp.h>,
  failing under C99+ with -Wimplicit-function-declaration on
  EVP_EncodeBlock(). Include <openssl/evp.h> explicitly.
- configure.ac probes EVP_sha1 via AC_CHECK_LIB(ssl, EVP_sha1, ...),
  forcing -lssl even though erofs-utils only uses libcrypto symbols.
  Use AC_SEARCH_LIBS([EVP_sha1], [crypto], ...) so builds with
  libcrypto-only or explicit static openssl_LIBS succeed without
  requiring libssl.

Fixes: 1affd4868216 ("erofs-utils: introduce extra build dependencies for S3 support")
Fixes: 397db5ab0d86 ("erofs-utils: mount: support mounting EROFS stored as an AWS S3 object")
Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
---
 configure.ac     | 2 +-
 lib/remotes/s3.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 25a4892..ae810ac 100644
--- a/configure.ac
+++ b/configure.ac
@@ -688,7 +688,7 @@ AS_IF([test "x$with_openssl" != "xno"], [
     CPPFLAGS="${openssl_CFLAGS} ${CPPFLAGS}"
     LIBS="${openssl_LIBS} $LIBS"
     AC_CHECK_HEADERS([openssl/hmac.h],[
-      AC_CHECK_LIB(ssl, EVP_sha1, [], [
+      AC_SEARCH_LIBS([EVP_sha1], [crypto], [], [
         AC_MSG_ERROR([openssl doesn't work properly])])
       AC_CHECK_DECL(EVP_sha1, [have_openssl="yes"],
         [AC_MSG_ERROR([openssl doesn't work properly])], [[
diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index 245efe5..7ee3659 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <curl/curl.h>
 #include <libxml/parser.h>
+#include <openssl/evp.h>
 #include <openssl/hmac.h>
 #include "erofs/internal.h"
 #include "erofs/print.h"
-- 
2.56.1.750.gf70dc682cf-goog

