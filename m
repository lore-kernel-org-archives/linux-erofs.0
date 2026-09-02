Return-Path: <linux-erofs+bounces-4404-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363ADC61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:05:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZQzH2XmHz2xlY;
	Wed, 02 Sep 2026 12:04:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::432" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788314699;
	cv=pass; b=RCV64ZAXqADTWHscx7LohH7lI0ijG7pV7Bwk9i6ExgxKsCJMzXhDOxOXwZdIYNZcFKWZZxxvF8oGoPTo9PwRCIYdU2xIYY+EGbi4s0ltoLIi5on/F88Ujlh9IXHEDrbgipEmWkG1sZ3Yfu0rFcoe5bDEvudZHU7hgmHJ6SpzJlvT0ur2zoThrelkR8asy3UPwAQO1AmlB6ZxKZKn37FPdjY/ltQiddC13BgKo4uIoYMnXmHXsmsHSqplICP2qyOmeZdtVRHBBf73w8XYKDObCTI0j/IFWmU4Gn2YmeNwkJlSMaSV1fMLmznWw4XVNx79b1huojJeFHlsFec5dN5P9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788314699; c=relaxed/relaxed;
	bh=wyyDLth+ZOHBMkr86Vlswg04HV1jJ+33CAE9hpj/U7I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=l5aW2HGWB/VCR4eU33FnT8vpOQ7oPQfl9Sf75S8FNFjpE6bbqqp5jveS1bmDw6flRr8oe+e3umShGQG09pYH1UXgEsyyh8/Flf1DSVnNgtdyG6s26tL7vVj4T3wZA2xl5mwDTotvFnLkwRF9n6CbPjfQkE7M/IG5nKuwZP3HTaLrDY8UEpm3Z3rZTnXTYZDaUzJZ07RS3wjso+L0IZ8JYiaak5NWBEfo51+kr1u6z9cMiKo0Dvzo5RZ6cDMGG+uUatGzv4a/AiB5ffOWy7RzMZRNEeHuHQlf2z04A8rsg6AW4XkFnQEHwSw4jRLdIt5vgh3jmGXD7JKbk8dOmHV3vg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YpJnvC/F; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=usupergate@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YpJnvC/F;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=usupergate@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZQzF36sCz2xLf
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:04:56 +1000 (AEST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-4843c41f35bso283393f8f.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 19:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788314693; cv=none;
        d=google.com; s=arc-20260327;
        b=p0MRxsG5H1OuMuxlmkzkdDH5BqVIvkTLivr9Mwe2U0ISLc+SjCph/jiuNtOqEwudfY
         Dxfb8wcJXoGOtMO8pgZPuOxhMKgju30Vt6VhUAd7AxrEuz109WFl0Kx1xTWVuhQJsXCN
         o90wim7icL4nw781QOL42aEFU9lMZ6EzUVH2fWw9vXYfIKGxwl9fbYfCk4OvARRsK3bu
         ayvTU9p5Xux5gbocaF6gvrMXdYeWCpEQYb+yzDE6QKMW3vFLQJVriKPd63qWXqsyB+8+
         98WVUyuSPLO8Sta/fZrfL27+avQc3OGvYJOagwnhcFgZ79GFwxvdE3XoLgP47Kw3Fpey
         vlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=wyyDLth+ZOHBMkr86Vlswg04HV1jJ+33CAE9hpj/U7I=;
        fh=Y5MKFJWs28mVezeLQPQh95dDjeD1mJjmVYLlMXYlDKY=;
        b=A9iFUbT2Gvu02g15IyLw8WrJY7Flp2rQxqL87VB6Thz390nkcDQRdqlephzzUrt6qz
         y13fa1BtYHKZ5FqZFt/9qNnmzfzchhESu+HaFSfrZHZs3gdhGmCUfIM7t8pvbc/6c61p
         WZzJVUwXmnC9ajk8h6Sl/902rxSOuIoDj1txBoKzAmhqkHxdnLWRTtnFD2OeoYhUYCIz
         o4b/J4wGd7nerMcFUdk0JPWRGyREaptJYqGinXOIO0ohQog7/yxBqAcjVg6jfjakJpyV
         53mkuWYzC0LS9q2e1jQzDgKUMdbGC1lkbumJglb98EENPrvCloJpiZ9BdHCFQc2Vis0a
         bZaw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788314693; x=1788919493; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wyyDLth+ZOHBMkr86Vlswg04HV1jJ+33CAE9hpj/U7I=;
        b=YpJnvC/FMTyEe2ofq8lRxmhZUAT7TvEL/JEhky5IrZ5/B94lI+6yJyQsaCe28CTllR
         N43AH3NsREQEqnNsdqnS9GrB6mRWSHtrv/VD/B8RqsaNSdKT499F/ezWmFqRhZsyBuSb
         fXvnJOCM7ARttwdXlpRB9w43QaxHEMdQmskCTL3AHpmbaC05pKljgRE2Tj8OOSl9ioqg
         3QFbt73jup4x0d7F7+tD1VBN7ZA/ocYosDQnvuVFzmCY+aeYdXlEToqN/6aIPdxMoeTK
         lG3zFAwJy8ahfDk+zsd9knyPJsTmJgTxW/xEvsFDCm9nNAACVwzE3VZE2pB1YP0XMoOT
         GcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788314693; x=1788919493;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wyyDLth+ZOHBMkr86Vlswg04HV1jJ+33CAE9hpj/U7I=;
        b=DG3Qp5K3f73HIxbvRDCtiXuf2iUdaVPUk10vSevTFWEAHEcegngBpMfcIGampFHGWB
         KbT3aXawikZN1ffQTmisBMWqCZPxFkNZ0XZQQRVhoPZwtksEHmZMa14wW1sCL4DPlO8N
         +4z0pOq0woSo1azLewUs46zJTDcfi2GCsLiM0Lpab8l0pSG6DfX3BBYSt8sYL27cHgcE
         NXEcWn6Oh21NwyXmLJBfWYjRINvVcoHveqoU2kWwhd0ZW4CJblelmxUEQ89rfd2Hmash
         v7kVM1fG4iW1Eftv3Hx1Y3eMD3paRMjk/Izuh9E/cnSFYoSPTbw1Hl9m568X1L8a5pTr
         BCYA==
X-Gm-Message-State: AFuF++kLFSWTMtJTyEOkQYkHd7udP5V9BrzRt9/S+OoRb9cLa+zJVk3m
	a9yuEA7I6LRA3wt6tgKsKoTIK1aJJfQeSRYj4GHHo6AXHASftBi0y94UZVxfKKZ3rLjRGEYFmmz
	yqFnD6ASXDf47ut+rpZcLd+8by4t7dEA=
X-Gm-Gg: AYBFou3d1edwEv58cOrsCwm72EEEhEhsxW2x5H8gf9IP5NBASU6vs5YyeW10BJkZiyg
	03E0CkdTEVeAQA6okHLavBZbiVi9F0pCAU2FVWffzg8Bf55JP7LrWf64gOrsLv+VposQ+Aa8PqY
	SJUe1INo8259sg0njhfWZAsk2LwtX128E675SyLvBbf+ztAXP8+avrIfUrT7yNNmdrCLKgiJM9I
	XjTX496vxe9wA0qyTyU6sUgin0lRXXVXQ26MK1p94ROckwymMMiPXVVhXO+BZ15jB5MlCt7E6HL
	B0ZRZ/nHuutNs/OHVLp67/ZksxfaI2yAzf+XqubhXcA=
X-Received: by 2002:a05:6000:2dca:b0:484:42c1:41bc with SMTP id
 ffacd0b85a97d-484a3bc2e28mr1560654f8f.5.1788314692763; Tue, 01 Sep 2026
 19:04:52 -0700 (PDT)
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
From: Qingyu Zhang <usupergate@gmail.com>
Date: Wed, 2 Sep 2026 10:04:41 +0800
X-Gm-Features: AcwNN1UdyjD22a4J79gsh1SqF6GjF6XDdTJzwrSgkDe80nmS8380P2jwFtSVCD0
Message-ID: <CAPBHda=tMkmjY3-WE-d8jnNfDt5bEsAvu1BCiwOT4FgqqYASEQ@mail.gmail.com>
Subject: [BUG] erofs: LZMA stream state NULL deref after failed dict grow
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

z_erofs_load_lzma_config() can leave strm->state == NULL while still
publishing z_erofs_lzma_max_dictsize. The next mount of the same
image skips realloc and decompress NULL-derefs.

Type: null-pointer dereference

* Summary

       for (strm = head; strm; strm = strm->next) {
               if (strm->state)
                       xz_dec_microlzma_end(strm->state);
               strm->state = xz_dec_microlzma_alloc(..., dict_size);
               if (!strm->state)
                       err = -ENOMEM;
       }
       ...
       z_erofs_lzma_max_dictsize = dict_size;  /* even if err */

On alloc failure the old state is already gone. The next mount sees
max_dictsize >= dict_size and returns 0 without retrying. Then:

       xz_dec_microlzma_reset(strm->state, ...);  /* state is NULL */

* Affected

622ceaddb764. Needs CONFIG_EROFS_FS_ZIP_LZMA, a microlzma image,
and a failed xz_dec_microlzma_alloc (fault injection or memory
pressure). KASAN recommended.

* Reproduction

1. mkfs.erofs -z lzma,dictsize=4096 lzma.img dir/
2. Force xz_dec_microlzma_alloc() to fail on first mount
  (poc/fail_lzma.c: kprobe sets dict_size=0).
3. First mount returns -ENOMEM.
4. Disarm the probe, mount the same image again (succeeds via the
  max_dictsize early-out).
5. cat /mnt/payload

KASAN: null-ptr-deref in xz_dec_microlzma_reset from
z_erofs_lzma_decompress.

PoC: poc/run.sh. Use lzma_streams=1 to keep the pool to one stream.

* Expected

Failed grow keeps the previous xz state (or retries next mount) and
does not bump z_erofs_lzma_max_dictsize.

* Actual

NULL state + published max_dictsize -> NPD on the next read.

Please consider the suggested patch.

Thanks.

Suggested patch
```
diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 6b0cdb446c6a..3719c6f83f8a 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -128,11 +128,16 @@ static int z_erofs_load_lzma_config(struct
super_block *sb,
    err = 0;
    /* 2. walk each isolated stream and grow max dict_size if needed */
    for (strm = head; strm; strm = strm->next) {
+        struct xz_dec_microlzma *state;
+
+        state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
+        if (!state) {
+            err = -ENOMEM;
+            continue;
+        }
        if (strm->state)
            xz_dec_microlzma_end(strm->state);
-        strm->state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
-        if (!strm->state)
-            err = -ENOMEM;
+        strm->state = state;
    }

    /* 3. push back all to the global list and update max dict_size */
@@ -142,7 +147,8 @@ static int z_erofs_load_lzma_config(struct super_block *sb,
    spin_unlock(&z_erofs_lzma_lock);
    wake_up_all(&z_erofs_lzma_wq);

-    z_erofs_lzma_max_dictsize = dict_size;
+    if (!err)
+        z_erofs_lzma_max_dictsize = dict_size;
    mutex_unlock(&lzma_resize_mutex);
    return err;
}
```

