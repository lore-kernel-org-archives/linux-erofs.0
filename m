Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18FDD3ABD0
	for <linux-erofs@archiver.kernel.org>; Mon, 11 Nov 2024 16:48:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XnFqm1Dkwz2yjN
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2024 03:48:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::134"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731343729;
	cv=none; b=oQ+RMUbIn9KAcyiQjPv23L+PUBLcvu7GuT4LZANHxg3pXgBmAw3VuIE3VDbLaxzKFIoivWm7AqeLtrNecgH2wMLLOgSf3F0NS9TUXOwsLU3RjhfdUh0Ia8XHO/XBzGAQk/+fr1oUPpS4Ki6r7ZIDTfKkUbONLRSh7swCz3uOdoKDG2079m/skzlNt3qfJFUtHAuX9dBYFW9plStA197Wi6sNpY+4gh0SVmmxaO6NU+VZmRsJI1KzJo0e66N/KFgCHusEoddsGaFwcdNSBxJS5ccSItMknmiW1hcuciW75++Xnfnb8XvC1qp1j9IFJS9v7wNs91/oEzOfg6POFHlWgg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731343729; c=relaxed/relaxed;
	bh=gg7crtMaAfxWkGbymepkORPPMe8iMJQ98rnaLnpLBmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FynGYpWCLGEUN/bM7EleZWtQMt9l6IJYafcGf2KEvi/FNZHF36zXkpbC4pI7Zs1SUvJXHoMOMSzuougKPmwq4srDlKbikR/VsiffJ8qUzILzVgh+PYhyiHGw3G17v+DZRFi2LoNbQx/Zabi5Hwe8IB2K1Cqq1kjKRhKk9u909Rb0U9pNuvQNrLILAIkG6zbSRdMz3ZcvLcfE4Z7nqDF8WEfnqBQW6x6HBP75VYkav0/+a8Ne2a3dxIyPnMxeiVWOY0iYr1B8Z9PNZgHoWNpr2bmEmcj7aouvG1/5/pvQeTTjQdEuRsIh/Nis6U/qJIko3MVNUnG5eL/QLvYOaxHw4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; dkim=pass (2048-bit key; unprotected) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.a=rsa-sha256 header.s=20230601 header.b=rAGjaQOF; dkim-atps=neutral; spf=none (client-ip=2607:f8b0:4864:20::134; helo=mail-il1-x134.google.com; envelope-from=mike@mbaynton.com; receiver=lists.ozlabs.org) smtp.mailfrom=mbaynton.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.a=rsa-sha256 header.s=20230601 header.b=rAGjaQOF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=mbaynton.com (client-ip=2607:f8b0:4864:20::134; helo=mail-il1-x134.google.com; envelope-from=mike@mbaynton.com; receiver=lists.ozlabs.org)
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XnFqd5z9rz2xGj
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 Nov 2024 03:48:44 +1100 (AEDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3a6bd37f424so18649685ab.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 11 Nov 2024 08:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1731343721; x=1731948521; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gg7crtMaAfxWkGbymepkORPPMe8iMJQ98rnaLnpLBmI=;
        b=rAGjaQOFUMzVYkV20lZjr6gcOswi1kh260L3j/ze7l/nOD3ST10uBSZVwssHSgX2Re
         aXVOucHTGl+lZhe2avNQb/cFM12HNhnpdSrE71lWAFPSACdZnKPimcaKaFm752W0GDjR
         xIQ6b/CZEZ4Urh4w19QdFNPBoyjeTbccjWvJPjIKgmUTAzGUqmm+2dnqT2llqb9PukP9
         udCE+HHxptiomd6vWPswJukiew9xfD4ZRWr02WcPluiz7ZjiF/qrHN4edeUTYfbIQdKK
         NPHEhTF2EUGwHFkj9dXw/m5WAhBR+UUXcjmxffq23A+WU5ppS1Wrrho69XmHrUNeAQrp
         K+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731343721; x=1731948521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gg7crtMaAfxWkGbymepkORPPMe8iMJQ98rnaLnpLBmI=;
        b=VzanCn7m7UtaXtLnUu3Xy2xtVzCXbUxsScQn7YbX5c3zYwOAQbml5E5U6v1jiHoYph
         AGrDT9qkVebU0Q+ZuEhOAwPMlvLpT29EnoGcCG6ulCbXwwOQG9Iun+C89IYio7M5rWdk
         0eWPI7Bpa287I/rCJeorLkdmHwcaFqdO0GX8DKkmplyX5zOc2CjNWrw04sl5ihBRLFh+
         h/p5N4X4Y1wIsALVJxywbkjLTXFIpl0xDa7TozN7v5P/r370m7Hu8hcvJuAy7PGXfXsq
         LoGmAx36i8YDd3mk+TSsIVAx79NUbxX/C1QdTILoFkOkUWd5xrQju/mQkZYC36CQyvdN
         ljUw==
X-Gm-Message-State: AOJu0YzCdUYwOCB/hxLx8p5Q3klY/VagIULg0psnEdSnZ3UZxpFm9Jot
	ZAFCtvWJsGDKVTg+GXA0jPmaIhkWRpJvrNcOBnj+tMaznm8+EtX32zzGPcDlIfcudqaf7AkTcOZ
	s
X-Google-Smtp-Source: AGHT+IGkIT5ZAM1MSlPbDzwHsjr+jcCWKIkJO4/vetMggv0NKIndGlV3pQLLsRqX7PIGoFBCaQGasQ==
X-Received: by 2002:a05:6e02:1a82:b0:3a3:4175:79da with SMTP id e9e14a558f8ab-3a6f19c686emr113535935ab.13.1731343721116;
        Mon, 11 Nov 2024 08:48:41 -0800 (PST)
Received: from mike-laptop.. (c-66-41-251-251.hsd1.mn.comcast.net. [66.41.251.251])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6f9837458sm15559515ab.22.2024.11.11.08.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 08:48:40 -0800 (PST)
From: Mike Baynton <mike@mbaynton.com>
To: linux-erofs@lists.ozlabs.org,
	hsiangkao@linux.alibaba.com,
	sam@posit.co
Subject: [PATCH v2] mkfs: Fix input offset counting in headerball mode
Date: Mon, 11 Nov 2024 10:48:19 -0600
Message-Id: <20241111164819.560567-1-mike@mbaynton.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <02a3a22d-782b-434b-b3e6-5138f77ee251@linux.alibaba.com>
References: <02a3a22d-782b-434b-b3e6-5138f77ee251@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When using --tar=headerball, most files included in the headerball are
not included in the EROFS image. mkfs.erofs typically exits prematurely,
having processed non-USTAR blocks as USTAR and believing they are
end-of-archive markers. (Other failure modes are probably also possible
if the input stream doesn't look like end-of-archive markers at the
locations that are being read.)

This is because we lost correct count of bytes that are read from the
input stream when in headerball (or ddtaridx) modes. We were assuming that
in these modes no data would be read following the ustar block, but in
case of things like PAX headers, lots more data may be read without
incrementing tar->offset.

This corrects by always incrementing the offset counter, and then
decrementing it again in the one case where headerballs differ -
regular file data blocks are not present.

Signed-off-by: Mike Baynton <mike@mbaynton.com>
---

Thanks Gao for the suggestion, looks good to me and tests ok on my
sample headerball inputs. Let me know if you want me to resubmit this
with Co-developed-by / Signed-off-by you.

 lib/tar.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/tar.c b/lib/tar.c
index b32abd4..990c6cb 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -808,13 +808,14 @@ out_eot:
 	}
 
 	dataoff = tar->offset;
-	if (!(tar->headeronly_mode || tar->ddtaridx_mode))
-		tar->offset += st.st_size;
+	tar->offset += st.st_size;
 	switch(th->typeflag) {
 	case '0':
 	case '7':
 	case '1':
 		st.st_mode |= S_IFREG;
+		if (tar->headeronly_mode || tar->ddtaridx_mode)
+			tar->offset -= st.st_size;
 		break;
 	case '2':
 		st.st_mode |= S_IFLNK;
-- 
2.34.1

