Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34579606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 08:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vsLQUCAr
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVW906Q8Vz2y2R;
	Thu, 19 Nov 2026 19:00:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::122c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795075204;
	cv=none; b=M+/gjRdKqSUVgPs8jsujvKMsL5RUkYv7TgBy+ZgRGmRO636Tc/s9bVlG1NABxqPFMKRdGU+vsScH0P1q2WJS+Hvpvrwp/5GdD8G2/MI/FLkZOgtxy0UZRHtiwhjV647UhtIWTDo/ESiB8AaSnnhCdif4zbZYkxz0nSlBViaqnKLTTL6Ns26cSUaNWS37O769LnebkzupxwzIzkzHjODlqlP8m/Z1DODw/FoG3bCldwCIbTitTsl9U+osMWWapIvMith+Rk7Udvko0FZXv4M+N5yT6WwjE+LRkuCvZ875G4dJzoOlbhtGepwSkEt3xuSZytoDmiXzhcgrxhCsxEXI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795075204; c=relaxed/relaxed;
	bh=YfETK7b3CrgEtcTI4sJo+5rjbV/28mFG5UdkoDek8ms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lzteOyGBBVXP7qfsv4ppbpnHN7/LBIuT95CI2AdZImfgXgPr18pj2DjeOtSWCX7hA7LhPUOhyO6+P6fo6A08tXJxICuao8HEIHo1nJOHiy8GZFK2NjBYfeK5biPVXDvvz+2KY0TlyRLYdT4ytyWjnUP4YigzVnucu4jeKI0SxGYE+K59dCzpTaRzDNmfdrzkPX9C+d/MxWcLotUJ/fde+LqvGtlnKL8QyzgkGA5qFkqvodBWmNIm8f0OjgOa4SysqVW4HYc4u9aaeDcDbnk7lFZYUCmihmlU1SPok8/f6VfU7OjkBgrUawllJ+yhg7jMG1Li7ydSd7a50yafz4svFg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vsLQUCAr; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::122c; helo=mail-dl1-x122c.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vsLQUCAr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::122c; helo=mail-dl1-x122c.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl1-x122c.google.com (mail-dl1-x122c.google.com [IPv6:2607:f8b0:4864:20::122c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVW8z0hDJz2y0B
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 19:00:02 +1100 (AEDT)
Received: by mail-dl1-x122c.google.com with SMTP id a92af1059eb24-1b24f4b15c4so215616c88.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 00:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795075200; x=1795680000; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YfETK7b3CrgEtcTI4sJo+5rjbV/28mFG5UdkoDek8ms=;
        b=vsLQUCArFstLI455xBmaJuCdgL6zpT2iDIxa1Jtg0fX5tkjkSBcABzsOM1OXUeoAs6
         Eey8NBtvJLewee0mZF0Dj8fNo2dWykqHCTkKf8lJ+E1IYEryKE662N+mIlhDT2/CZBen
         QB9cYY02uyooE6Mm3qUEakhslpMxsBczLF4aOQM7QwhVFmlMeVsIauB98hVR9uvyWfYV
         fmtHwY9HiPjSFm5ylKpn1bjQPiSs29z8LCjo90fFFFhQCaalczSfWJxeZqaplcULe6TR
         +GsokhZ1+iDmsIouFdnYNzx6H6X5vv5nJdfxgbhnKMoAAe/I2CCpjq16MdgHacpYqy4c
         8xAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795075200; x=1795680000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YfETK7b3CrgEtcTI4sJo+5rjbV/28mFG5UdkoDek8ms=;
        b=S7996aqfCM04j0lWM2oqI+DSpK5Naud+bbpqkeF6dvC5jqOKoRtwtRITNLUBEFQGXF
         kV8ls9YHqJmXstrTmqrUE/0vyAS7HeySdfntqKL4dJQdNbKRyXIGMF4HzGI9Kn69zmUk
         yuRsZOZzAN1NHNGawYw9E6i22UKrNcsCnkWX91YP+yZLV73EgjNTwN0gnt3agtwh1ACO
         rpkWleTqu1Cd3462vvvIfUacoHO+Tbsn4sBnNss2BX5g9tLTRQY8a7BWp8cLw3LOPgsv
         hRYubrQrckSTmjRh/E36AlygUhyQ/w009m82WRfrwKdEDVe9AjR+r3k9+Qpo9c1tVNVz
         dS/g==
X-Gm-Message-State: APuU4Z8ze2Mx1dgvBKa0UJu/QNxQBjGR2CbxkU0NCw1iZFZIn8XM8wtE
	Q2W8sLI+9fq0naf0EqGEiZcaCrwyzQRJVf2zAwpkpBmo9o2FMDZM/cS4/tAI6SkH
X-Gm-Gg: AYBFou2mOrREdOvG9kpqe/QcMNbAhVMaFwXZmdxtI+ICyZ6j57zV8UWfITr/O0eo5XW
	9FIZWl1+tM+WSywVzLX0jlEDNyA9atVomPyBA4Eap7bfPjMYZgfY/oTQcndtiy5XabtF0Jqy5A9
	HfTxb5V+ikxEnzgscyh+wXzLwjuDL3HSatljpREDxHqogv666BxZ7qLLSLG5BtuvmmsMzl33qyZ
	W6uJCVLHdKqXP8KQWaGnJsEuDtRJ6H8gIRA7O3DHT7sLYZtF11UMDtYep/XGY46CkeLCS/NXkJs
	xIOxHNpgji8Njyq8XoA3MHuCSQQR9rFaCGeKffAZ5fehNUsoklFA3b9Jvp98IOJCXIiNKmZvdzb
	Mw7SEBbZ1l+1MVe8abUdTqcOySP1lHkTARIaocQ5yDFuhVlw/52s5rCOO8nPExbfcLdBr9hI627
	Bx5fnb2ZcnZPxyqy6qmPsi7TkvcecyZ5OYN+F0guLzAhUEA/Qc4eKPmtuX6OSx2mQXiTUmTPVfD
	logkkufSE/E6GFyWqyQAHn2vbt9N8e1tMnDU9DlYVbHCn7HB4/T/0uh8mm1ZZ8vvE3SvB11BaOX
	GYQkrMvHgzHb9oRKaTeG8aEgbI46NBFG/7wD7OJ2vXn3lw==
X-Received: by 2002:a05:701b:2603:b0:1b2:5ecf:9bd1 with SMTP id a92af1059eb24-1b55249484cmr307672c88.7.1795075200420;
        Thu, 19 Nov 2026 00:00:00 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447f4e19sm17608095c88.13.2026.11.18.23.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:59:59 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] erofs-utils: tar: return an error for invalid device numbers
Date: Thu, 19 Nov 2026 15:59:56 +0800
Message-ID: <20261119075956.3837714-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

If devmajor or devminor does not parse, tarerofs_parse_tar() jumps to
out with ret still set to 512, the header size returned by
erofs_iostream_read(). mkfs.erofs treats a positive return as the end
of the archive, so it drops that entry and everything after it and
exits with 0.

To reproduce, make a tar of a file "a", a character device whose
devmajor is "00000x0", and files z0..z4, then run

  mkfs.erofs --tar=f t.img x.tar

mkfs.erofs prints "invalid device major @ 1024", exits with 0, and the
image only contains "a".

Return -EIO as for the other invalid header fields.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 lib/tar.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index bab855f..9fca2e9 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -1047,12 +1047,14 @@ out_eot:
 		major = tarerofs_parsenum(th->devmajor, sizeof(th->devmajor));
 		if (errno) {
 			erofs_err("invalid device major @ %llu", tar_offset);
+			ret = -EIO;
 			goto out;
 		}
 
 		minor = tarerofs_parsenum(th->devminor, sizeof(th->devminor));
 		if (errno) {
 			erofs_err("invalid device minor @ %llu", tar_offset);
+			ret = -EIO;
 			goto out;
 		}
 

base-commit: 1114f15f3df938c1494553061e732b0a79a6463d
-- 
2.43.0


