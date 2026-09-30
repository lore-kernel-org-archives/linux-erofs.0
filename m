Return-Path: <linux-erofs+bounces-4636-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB58C9830E
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 03:38:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvgjv6n7Mz2yDm;
	Wed, 30 Sep 2026 13:38:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:38::e" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790739491;
	cv=pass; b=SQnjkrZszHmQhitV7XH7E9bhOtdkrX2LicCcRJyvslP87i4HkSrScTJEX6CXYss1EYWf1oPkUURDy/bCenaJR/X7F5rgkR10GiemCx7+xpTVvhp19UtTPKbbbyijFzRBsle7dUlIEnRwjKO07VW9jpqIJJFSiKnJ0abB+Xh13GJdNYvMMxJMUWqaIcv2tAYwYQcN0fm4M+S5JbxzkhGxZgXsMzwltKbHVTB1Q+fuQvpXPob9WJvavRwb2ZaEljGNujd2vxvWGr3SRgR1OzXmWIAx7ba56A6cISpCdb/zjA/yJBFkKNcY6gpvVNetm4Eh80BX+zHUIPKYB1V6AXvmLQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790739491; c=relaxed/relaxed;
	bh=+Hf5YnZpc1V7IGSMbtPymIkH7UZS8gGKRoIdelBrOCI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=VX38bdSpZPfTMiTXWey5XGE064rYJHlhauILyUF2GdUj6mwuHG/fNi9X5sABiPIa7WG+Yi4PagTkWvM+viVu7Ae3QE6yub4oZk668X8k2+zIi/wvyJKJgKE1OAcUj3YZPrbmYlv39j8+Ulxy3+XAb1NAd6Q8gzem7qMQ/lcnvQYvypc5bH+tyGGgh3ghu26NdJsFrfBQ88g3rXkUSe7lqdk6ovKe+RiL/MEcu/UUO9/YAF2a6sDTAEZuq4FvcuogUcz7vNo0v5f+o07Z4dQIz8spMf+4NSkvhj5gkrOPdyWLWtUWHLJDFaY5atMmkxtGRnwNysENHbonf/pvAlZAXg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WE45xFqs; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:38::e; helo=mail-dl2-x0e.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WE45xFqs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:38::e; helo=mail-dl2-x0e.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl2-x0e.google.com (mail-dl2-x0e.google.com [IPv6:2607:f8b0:4864:38::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvgjs72BVz2y21
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 13:38:08 +1000 (AEST)
Received: by mail-dl2-x0e.google.com with SMTP id a92af1059eb24-144f47a9b57so4451232c88.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 20:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790739485; cv=none;
        d=google.com; s=arc-20260327;
        b=SwQrpTY7O4D4P2lRmL2kthLcW0jMr2XFTMV+f7DwmH4gMUXYO8CEk79AnZ7ULASzmA
         9DHHr8oJ/Zj+EhooEn2yerLp/H18hBM1dkW4Guxvcf+PBfQmKc9lCgAdShzJstY2jV1f
         FGBHMwmjp+kKm+yD6QzAWdD1DnW9+pCaZPWuTUruT+7xKCPJjA5myClaB2NyW/NCDbTm
         B8A3hGT+VpZZ1T8J9NrVgYhVypyZ6xIfut/QMSUcUhentRbPtIAn53b5UlAO051uWsM2
         iRRzUN/snRNVVTRY+A6EtBmNJnzYfveG+UApwQk5kQ++YfI746hywkUyH2WdyTWeTWbI
         Mj1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+Hf5YnZpc1V7IGSMbtPymIkH7UZS8gGKRoIdelBrOCI=;
        fh=CX5xQT5FTxWnusx/YWXwNaw102wec7zxtyOxzcFC1HI=;
        b=F1wrfbrAf6a7TokJtXOLPIh90Om/UGJWZ3sNjlY60c9FrUSy3L7tqMgObSih/xkJQq
         t+Gv17NB+HVeIlbVX4RSpwtqzFcL0rLhBI44ghT311G2N0w6TKhkJ2e+PTBYQU+OOjVo
         ux2PSzk3E2rvTJMvda8s/IggW7Nrw5MRfcfN9UHFmETsxy7uTmPjABuJQgP/Un7m0b/W
         +4MP63NnOigEJ0s0pvIFIN71PGfwQnwf1/eT6QovgmfKA1Y9gMIyMCRhL6VPv3dtnE3n
         cYIXuDqmM0VzjCFJrlpAiHFxouYKGu57UAPCU8kZtstIQwaDtqAsfrCa+moECuZWlcvk
         2U8A==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790739485; x=1791344285; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Hf5YnZpc1V7IGSMbtPymIkH7UZS8gGKRoIdelBrOCI=;
        b=WE45xFqsM7FwD6MJ8CgG7JhNU2g3XMTZrqcuKLCzRDasXbHbfSYtSm+KdZjTy6Ln2N
         y9nZ/vwyoQ2+8MJQH6NNQkiWQcB+K3XFApi55+RT0JAPygJjATy9b062kNqIvRxT8Iae
         rqvVWQeWwMkklPoEEHmIeToFBy7VKZ+vOGH1XO9aO/00LNuGUpMVjtmCGLyBlZPlrm2J
         c6nye440AQietOmrpHZ47KFDVZCQvIqG2UqbE3Vck/EcucNVWNLonRjDJlS3+rKyGPMn
         T4WQAz9HRAwKHNilHhwAYNS5/o52xK3G1WJZUXkyp/wRJLcQFhKYl7/BCxWscwC5M9Cr
         mubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790739485; x=1791344285;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+Hf5YnZpc1V7IGSMbtPymIkH7UZS8gGKRoIdelBrOCI=;
        b=YDVOlley6CYri+ozNUqXKDZZVYFCR/++/iiKCE4koMbtKZcv+ViiZVhl5K0t032YLS
         1VhvBnm3ZmIbMeCkbGPJUuazkn7WeW8Wbo1ApgkXNI3AmesT19DUwXKlsAFb6qfZtEIF
         xAxS0e6NQk9ro0T7i7Jr9iI+UaJsVa+ITVry52WwY7h3Qj4XMYHZuAfzLM7pidfRu3Rh
         DI6feEN1N0gsX2gX2NDYVEzqFg+ugCxlPeuIaBHKQKzFBzwTDuhE3GugfImiRV2ckcVe
         UWsNnRem86M7kJXPxgg6k9tnfiV/NMd0JwwfBCWelnOFZBHyD3YUH4ei8/9t6dEiS0UW
         i/hQ==
X-Forwarded-Encrypted: i=1; AKwUvBwAGE3mgTdGX+WMbCm6zC4vWEzo8t6K2eeK+jqz+4e4rdKmNsR/ShpCzITW566Q07sGJxY60OZvCnngRg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kaTSGQBsftKx8Hz/5Xw8vbTWesZbDifaluzxR42PT/Dxh8qgCM
	UDnQD+eGLzuJ3u4d8vuRMnuevNZAOyoxUUI7xQAEA5dvpMeQrsqEKUY/ABOcXjptTiJk1/arbdK
	s/Bd58nEeFqZDndLv7L6VKShaSPgQcOg=
X-Gm-Gg: AYBFou13Z70HkVSZned1kQ25l60EkSs13fOcmgtzMqp5xNarjfIOfJI8mD9ZDf9lrKo
	KOGe6UwOUXwIFx6wmHzVrUIEKPiOh2nWpZ4By6L2VIZTkOD7/TGLwS216I4LYER/Th3FplQXUP3
	40PsUMYcqirkmr1Qca8bVmXQlaLdjlscZtpxJCsJKNKrldcqAzFn7/B1pOmKiDYsvRjVQTCd3nj
	PEcUmzZzI09vzoN/rFPnoxEtBJzjm44jRkHqByzUhnzdH3gdDHhjoAyzdGrQP7vZdYNXmPUW5mB
	rn+zh9hiOwqylCePIlydaEHa4ADm180qHkIBrZXF785mKhf5EGJyEYjM
X-Received: by 2002:a05:701b:420d:10b0:148:4d6c:2018 with SMTP id
 a92af1059eb24-14c9ec43b4emr1371468c88.22.1790739485046; Tue, 29 Sep 2026
 20:38:05 -0700 (PDT)
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
From: binglei wang <l3b2w1@gmail.com>
Date: Wed, 30 Sep 2026 11:37:53 +0800
X-Gm-Features: AclHuK8mhsClsok-OH4eVXMSpnBvvb4uhzTatcayPdIhb6tlYUz196i8X08PhQU
Message-ID: <CAJ3C4KySUqKevOBn=CROzsWkaLdK_X241oLFXO26FKBVq73QJg@mail.gmail.com>
Subject: [PATCH] erofs: fix folio reuse from a different address_space in erofs_bread()
To: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org
Cc: zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com, 
	hongbohbli@tencent.com, guochunhai@vivo.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e4ae4c065cab0633"

--000000000000e4ae4c065cab0633
Content-Type: text/plain; charset="UTF-8"

erofs_bread() caches the last folio in struct erofs_buf and reuses it when
the next request lands on the same folio, but the reuse predicate only
compares the page index; it never checks that the cached folio still
belongs to buf->mapping.  Correctness therefore relies on an invariant
that is nowhere enforced.

fs/erofs/xattr.c already breaks it: erofs_xattr_iter_inline() and
erofs_xattr_iter_shared() call erofs_init_metabuf() on the same buffer
with no intervening erofs_put_metabuf(), and their in_metabox arguments
come from different sources (per-inode vs per-fs).  When the two differ,
buf->mapping is switched while buf->page still holds a folio of the
previous address_space, so the next erofs_bread() can return data from
the wrong one.

This is observable with METABOX enabled, where shared xattrs silently
disappear on the mounted fs, while the same tree built without METABOX
reports them fine.

Fix it by validating the address_space in the reuse predicate too: if the
cached folio belongs to another mapping, drop it so that the existing
slow path re-reads from buf->mapping.  Reading folio->mapping is safe
here because a reference on the cached folio is still held; if the folio
was already truncated, folio->mapping is NULL and the slow path is taken,
which is the safe direction.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
---
 fs/erofs/data.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index be63b89f0862..d8b6523bc218 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -33,8 +33,13 @@ void *erofs_bread(struct erofs_buf *buf,
erofs_off_t offset, bool need_kmap)

  if (buf->page) {
  folio = page_folio(buf->page);
- if (folio_file_page(folio, index) != buf->page)
+ if (folio->mapping != buf->mapping) {
+ /* the cached folio belongs to another address_space */
+ erofs_put_metabuf(buf);
+ folio = NULL;
+ } else if (folio_file_page(folio, index) != buf->page) {
  erofs_unmap_metabuf(buf);
+ }
  }
  if (!folio || !folio_contains(folio, index)) {
  erofs_put_metabuf(buf);
-- 
2.33.0

--000000000000e4ae4c065cab0633
Content-Type: text/x-diff; charset="US-ASCII"; 
	name="0001-erofs-fix-folio-reuse-from-a-different-address_space.patch"
Content-Disposition: attachment; 
	filename="0001-erofs-fix-folio-reuse-from-a-different-address_space.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_munk0zf80>
X-Attachment-Id: f_munk0zf80

RnJvbSBhMTdlYWY2YjQ3NmE2NmU2YmM2ZDg1YzU2OTU4NDkxMWFjY2IwNWJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaW5nbGVpIFdhbmcgPGwzYjJ3MUBnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMzAgU2VwIDIwMjYgMTA6MzQ6NDggKzA4MDAKU3ViamVjdDogW1BBVENIXSBlcm9mczog
Zml4IGZvbGlvIHJldXNlIGZyb20gYSBkaWZmZXJlbnQgYWRkcmVzc19zcGFjZSBpbgogZXJvZnNf
YnJlYWQoKQoKZXJvZnNfYnJlYWQoKSBjYWNoZXMgdGhlIGxhc3QgZm9saW8gaW4gc3RydWN0IGVy
b2ZzX2J1ZiBhbmQgcmV1c2VzIGl0IHdoZW4KdGhlIG5leHQgcmVxdWVzdCBsYW5kcyBvbiB0aGUg
c2FtZSBmb2xpbywgYnV0IHRoZSByZXVzZSBwcmVkaWNhdGUgb25seQpjb21wYXJlcyB0aGUgcGFn
ZSBpbmRleDsgaXQgbmV2ZXIgY2hlY2tzIHRoYXQgdGhlIGNhY2hlZCBmb2xpbyBzdGlsbApiZWxv
bmdzIHRvIGJ1Zi0+bWFwcGluZy4gIENvcnJlY3RuZXNzIHRoZXJlZm9yZSByZWxpZXMgb24gYW4g
aW52YXJpYW50CnRoYXQgaXMgbm93aGVyZSBlbmZvcmNlZC4KCmZzL2Vyb2ZzL3hhdHRyLmMgYWxy
ZWFkeSBicmVha3MgaXQ6IGVyb2ZzX3hhdHRyX2l0ZXJfaW5saW5lKCkgYW5kCmVyb2ZzX3hhdHRy
X2l0ZXJfc2hhcmVkKCkgY2FsbCBlcm9mc19pbml0X21ldGFidWYoKSBvbiB0aGUgc2FtZSBidWZm
ZXIKd2l0aCBubyBpbnRlcnZlbmluZyBlcm9mc19wdXRfbWV0YWJ1ZigpLCBhbmQgdGhlaXIgaW5f
bWV0YWJveCBhcmd1bWVudHMKY29tZSBmcm9tIGRpZmZlcmVudCBzb3VyY2VzIChwZXItaW5vZGUg
dnMgcGVyLWZzKS4gIFdoZW4gdGhlIHR3byBkaWZmZXIsCmJ1Zi0+bWFwcGluZyBpcyBzd2l0Y2hl
ZCB3aGlsZSBidWYtPnBhZ2Ugc3RpbGwgaG9sZHMgYSBmb2xpbyBvZiB0aGUKcHJldmlvdXMgYWRk
cmVzc19zcGFjZSwgc28gdGhlIG5leHQgZXJvZnNfYnJlYWQoKSBjYW4gcmV0dXJuIGRhdGEgZnJv
bQp0aGUgd3Jvbmcgb25lLgoKVGhpcyBpcyBvYnNlcnZhYmxlIHdpdGggTUVUQUJPWCBlbmFibGVk
LCB3aGVyZSBzaGFyZWQgeGF0dHJzIHNpbGVudGx5CmRpc2FwcGVhciBvbiB0aGUgbW91bnRlZCBm
cywgd2hpbGUgdGhlIHNhbWUgdHJlZSBidWlsdCB3aXRob3V0IE1FVEFCT1gKcmVwb3J0cyB0aGVt
IGZpbmUuCgpGaXggaXQgYnkgdmFsaWRhdGluZyB0aGUgYWRkcmVzc19zcGFjZSBpbiB0aGUgcmV1
c2UgcHJlZGljYXRlIHRvbzogaWYgdGhlCmNhY2hlZCBmb2xpbyBiZWxvbmdzIHRvIGFub3RoZXIg
bWFwcGluZywgZHJvcCBpdCBzbyB0aGF0IHRoZSBleGlzdGluZwpzbG93IHBhdGggcmUtcmVhZHMg
ZnJvbSBidWYtPm1hcHBpbmcuICBSZWFkaW5nIGZvbGlvLT5tYXBwaW5nIGlzIHNhZmUKaGVyZSBi
ZWNhdXNlIGEgcmVmZXJlbmNlIG9uIHRoZSBjYWNoZWQgZm9saW8gaXMgc3RpbGwgaGVsZDsgaWYg
dGhlIGZvbGlvCndhcyBhbHJlYWR5IHRydW5jYXRlZCwgZm9saW8tPm1hcHBpbmcgaXMgTlVMTCBh
bmQgdGhlIHNsb3cgcGF0aCBpcyB0YWtlbiwKd2hpY2ggaXMgdGhlIHNhZmUgZGlyZWN0aW9uLgoK
Rml4ZXM6IDQxNDA5MTMyMmM2MyAoImVyb2ZzOiBpbXBsZW1lbnQgbWV0YWRhdGEgY29tcHJlc3Np
b24iKQpDYzogQm8gTGl1IChPcGVuQW5vbGlzKSA8bGl1Ym8wM0BpbnNwdXIuY29tPgpTaWduZWQt
b2ZmLWJ5OiBCaW5nbGVpIFdhbmcgPGwzYjJ3MUBnbWFpbC5jb20+Ci0tLQogZnMvZXJvZnMvZGF0
YS5jIHwgNyArKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZXJvZnMvZGF0YS5jIGIvZnMvZXJvZnMvZGF0YS5jCmlu
ZGV4IGJlNjNiODlmMDg2Mi4uZDhiNjUyM2JjMjE4IDEwMDY0NAotLS0gYS9mcy9lcm9mcy9kYXRh
LmMKKysrIGIvZnMvZXJvZnMvZGF0YS5jCkBAIC0zMyw4ICszMywxMyBAQCB2b2lkICplcm9mc19i
cmVhZChzdHJ1Y3QgZXJvZnNfYnVmICpidWYsIGVyb2ZzX29mZl90IG9mZnNldCwgYm9vbCBuZWVk
X2ttYXApCiAKIAlpZiAoYnVmLT5wYWdlKSB7CiAJCWZvbGlvID0gcGFnZV9mb2xpbyhidWYtPnBh
Z2UpOwotCQlpZiAoZm9saW9fZmlsZV9wYWdlKGZvbGlvLCBpbmRleCkgIT0gYnVmLT5wYWdlKQor
CQlpZiAoZm9saW8tPm1hcHBpbmcgIT0gYnVmLT5tYXBwaW5nKSB7CisJCQkvKiB0aGUgY2FjaGVk
IGZvbGlvIGJlbG9uZ3MgdG8gYW5vdGhlciBhZGRyZXNzX3NwYWNlICovCisJCQllcm9mc19wdXRf
bWV0YWJ1ZihidWYpOworCQkJZm9saW8gPSBOVUxMOworCQl9IGVsc2UgaWYgKGZvbGlvX2ZpbGVf
cGFnZShmb2xpbywgaW5kZXgpICE9IGJ1Zi0+cGFnZSkgewogCQkJZXJvZnNfdW5tYXBfbWV0YWJ1
ZihidWYpOworCQl9CiAJfQogCWlmICghZm9saW8gfHwgIWZvbGlvX2NvbnRhaW5zKGZvbGlvLCBp
bmRleCkpIHsKIAkJZXJvZnNfcHV0X21ldGFidWYoYnVmKTsKLS0gCjIuMzMuMAoK
--000000000000e4ae4c065cab0633--

