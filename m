Return-Path: <linux-erofs+bounces-3942-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EBDC44515
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Jul 2026 11:43:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h3dtn1xZJz2xlZ;
	Mon, 20 Jul 2026 21:43:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::432" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784547793;
	cv=pass; b=RZSxOJ6274fSx6JooqZhLaPybtaLzQHEy7F5Gpj17i1nfxTG5dsvDt1qS3QhwHsWiCbYYRIdO0MyCjIELxVVDhl3Z4ejlTo/zRZKd3cEE/VBdr9PNlXqXvEm1intJnR5pyWJCwWLrihlbXH8imLq0BnyFo/vULQdRUbzyeC+Bhbrduh71mFgpHsSvFVxlcGP391vrPmOyGm2EDXuZ4GjyjJDlbidyoIzk23ugxmZ5R7hLr+94IG4FLDxqtPhKj0e56giD6HQopcbtAnvZ5PvPWBUfhOQRs0UNvsDQeZfLdn1xZucMa/Gh2tL84YV/XcmD/rdOd+CFrZ9jJr671LH/A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784547793; c=relaxed/relaxed;
	bh=hfrNUWV1tNeXgRY4WB7R1+T8wmfr0+/48eco5RV/syI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F1FyYZeKjurJQstYM0axG34mYSekjO8S5VeZru21aB8aoje3dryAu7vXrwRQfxt1MK7uCRwYTS33IOlpMqcHyJnpkhkfslqFe+0k3yQOcR7xKwWFRrZu0kzR3BvGUdts9Tc6zGAvZcRnJrA+grp1yPYmlXz+xBdwbsxpxrXNVWWuFkTvPcFRlRdBxpNlOUfi9z0K+g067g3GGygWHV9FLTpgUlXyHBa2PiE4KzcWCt2dO2rurbkJvyc2cZ3FncOZinU2MwMwm0CADC77RUc20PIMlEjvJlvoVqRMk2aqMVUSIzO9MMajZYgJahEI/ECYLngugqmgdLejOmuahxvbzQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IxVeRoUB; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=niuzhiguo84@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IxVeRoUB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::432; helo=mail-wr1-x432.google.com; envelope-from=niuzhiguo84@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h3dtl2tHzz2xF8
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 21:43:10 +1000 (AEST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-47f6981d244so98658f8f.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 20 Jul 2026 04:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784547785; cv=none;
        d=google.com; s=arc-20260327;
        b=TCKonGmmhOZnqhFr2hd6ghqT/aR8ArJhtCeu/KExo4RJCO8vWT2n6zPbLAD4WIKbbL
         KfbzFvMkWZ8GvHIrD4v1TiBPwOMWwsQBikEx6BWuxQzLpi0I5cCkSe0stFYCIYQp4dim
         FhMDxF5sZowGMBwKN55byLUKh9WqGm7o2r9NUYLmz7oEIu9kEInfGiZZrLZEQKjVH4Cc
         vdCTZo69TMJlFUARpuYwdQ+yzBLQ+8en+z/3422QCyIuW6VNBdrTm57CZpsAhZpB94DX
         CMnu+PWGhmysadVx4Ms5EXkDWY9EUVFO4zXMKNFqh8KIXcYGV+6/wINYgaZylGOzvax7
         8CeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hfrNUWV1tNeXgRY4WB7R1+T8wmfr0+/48eco5RV/syI=;
        fh=RBEOkj1KxUH1mx0Xq79k5PjDv6jXaTAvVWU3YyUgbY8=;
        b=Bn40d73X7acJ6xym9/o4ufH9ILPS0l4Tv6tdTheiqcgSVc6RiqMze/nTooUr2XdcGH
         iw+ArFwh5iCAla8jqA5lbkxHw8cGSz9WjKex9L+0OLz+T6PmKAGSajKEgN7pbg6bl6fG
         Hn18uOi6u6m4FHJqrj6Pz5Shha80OWtmek8ktxxOt/+eOSwKxfeExKGZFQZZ80xxFMiI
         iRPT7pXPlt4fuy4ZHexhfoQrtTBAwLbdGZYGjuCJQQs3up15LY0U4T1B6ipDHcquYonb
         Eex8Or8T/2l5SNblrrLcEFeG4dY5ASCazhhv1LgZfHk40AsVkRXY2mszCoURrQbkndsN
         Mpww==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784547785; x=1785152585; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hfrNUWV1tNeXgRY4WB7R1+T8wmfr0+/48eco5RV/syI=;
        b=IxVeRoUBga8DH3XcLTgpulQlfT2j7LbCHJWlmKAgUWjavS1JXOnQSUEnpqZpLXHLTY
         ZEsVanXWMC078sZbBZJskiour5hXWi03oi3CQPrcfUoIyjezEYNhblDplXlEqXw3X4/F
         Mg+mMU6SGFf8aCfciZyqaL4no2xqVs3DZtNzKzqIIKgtId3INLbD2WUcNeHU64dQ0hmv
         KMCZodTmU5jDxyySm+/IyTLSOf78os9AurRlG6RBaTfgVo0Fkl8xCGA06ObjSpY3QH2Z
         KTmvKahysNW1ooSkCJ6n25+fPEDF3ud2g4Ugq39/hnWQk3uq0RfNIvAt+GsCgI0/1Vq3
         46vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784547785; x=1785152585;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hfrNUWV1tNeXgRY4WB7R1+T8wmfr0+/48eco5RV/syI=;
        b=IkhpibnfTnuQBlxS/n+/i8Ve1yKystpNw6o9Gcv2ntriRQFgg/eQVj4hZD6BAOTWZx
         PQ7LaRVCkT+rf5XN7gFYn0DmxqrQcsPMZSs8Ab6och7uoTXvFyNbREx/TaYbUH7s/qny
         xGI2frFICc5TmXzzNTtWFKxiVYA+/UO5TrkgCsmdVk02Xw4mAln4Ln+b6aqSbHlhElGF
         JcA8fRvYr0hPTR9aGB6N1Zoo9O5PUJgbjG1xOBYhsVZWRAU6natQVt0k9aYGUWuLzWKT
         mCzYyyfxYs2h9kioKVaKjM+E4rJ5lOzfLMW6dhCvIWxHQtFqSuvkHs/rZW2g9S5hv2ww
         t9lQ==
X-Gm-Message-State: AOJu0YyLQC7Cpe1h2FzlsRAMx0EMdG2KZ47IDJod4Q+5g15OiYFXqPWF
	bQvCvDLE3qEb8pJ8HcrI3m+ijRnEeARyxVzU6th4PZcYCfCz/8ESIT2mMLkSv3+Fnb1e+Fz5gAk
	bbEFk3olxsL96o5+JJAIg1ijwY9nj43k=
X-Gm-Gg: AR+sD13orgmppfwYCXlVehQVFDVDi+n6E6WAB5VsEV6PJ1rdDSPVkwVydnzvcojUAr7
	SCdildCyyBGYtYLS8gDjYIVST2ii7WkW9T4p7ZF4lykwo/Atcl1De3Q4SmjLbk4zp3RMSwmCYeL
	LoB/BfERduH2JxXpvwwz4ckPwEETUqFjHZckVqULH+Vbm3UEsPGWB42Tl92LoomMFnsyfZ6M0oY
	LR257chVFpVh/tsFbPCevqt0oXOVtthQlhP1yxB+d7W3bYR92O28yM9rDrPRfU=
X-Received: by 2002:a05:6000:2483:b0:472:55a:ef95 with SMTP id
 ffacd0b85a97d-47f7e0f501fmr179703f8f.2.1784547784739; Mon, 20 Jul 2026
 04:43:04 -0700 (PDT)
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
References: <20260709123411.1166770-1-zhaoyifan28@huawei.com>
In-Reply-To: <20260709123411.1166770-1-zhaoyifan28@huawei.com>
From: Zhiguo Niu <niuzhiguo84@gmail.com>
Date: Mon, 20 Jul 2026 19:42:53 +0800
X-Gm-Features: AUfX_myrAIWNQJOlP3DUKXBQquO55wL7zxtD4t3J-BpcqRJ3WPmPL0fVa6mHr38
Message-ID: <CAHJ8P3JK5gKS=RH2b=waY7g1AJ7S6ZHzDV0asg46pkzHsWzMHw@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: lib: fix ztailpacking fallback across lclusters
To: Yifan Zhao <zhaoyifan28@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com, 
	zhukeqian1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yifan Zhao <zhaoyifan28@huawei.com> =E4=BA=8E2026=E5=B9=B47=E6=9C=889=E6=97=
=A5=E5=91=A8=E5=9B=9B 20:36=E5=86=99=E9=81=93=EF=BC=9A
>
> With ztailpacking, the final compressed pcluster is first stored as
> inline data.  If the inode metadata area cannot hold it, mkfs falls back
> to a normal tail block and drops the inline pcluster marker.
>
> The current fallback path assumes that the inline tail pcluster belongs
> to the EOF lcluster.  That is not always true: the tail pcluster can
> start in the previous lcluster and end at EOF, while its raw size still
> fits in one block.  In that case, patching the EOF lcluster is
> semantically wrong.
>
> Let's keep raw tail data whenever it fits in one block, and convert the
> corresponding lcluster index to PLAIN during fallback.
>
> Reported-by: Alberto Salvia Novella <es20490446e@gmail.com>
> Closes: https://github.com/erofs/erofs-utils/issues/51
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---

Hi Yifan,
I tested this patch to focus on the issue fixed by commit
277a42502a7a, and it passed.
But I have some questions:
>  include/erofs/internal.h |   5 +-
>  lib/compress.c           | 109 ++++++++++++++++++++++++++++-----------
>  2 files changed, 83 insertions(+), 31 deletions(-)
>
> diff --git a/include/erofs/internal.h b/include/erofs/internal.h
> index 2cc9cc8..bdde41f 100644
> --- a/include/erofs/internal.h
> +++ b/include/erofs/internal.h
> @@ -212,8 +212,11 @@ struct erofs_diskbuf;
>
>  enum erofs_idata_type {
>         EROFS_IDATA_TYPE_RAW,
> -       EROFS_IDATA_TYPE_COMPRESSED_DEFAULT,
> +       EROFS_IDATA_TYPE_COMPRESSED,
> +       /* compressed idata follows a final 2B compacted index pack */
>         EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B,
> +       /* compressed idata follows a final single-entry 4B pack after a =
2B pack */
> +       EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV2B,
>  };
>
>  #define EROFS_I_BLKADDR_DEV_ID_BIT             48
> diff --git a/lib/compress.c b/lib/compress.c
> index f7ad5a1..ec90f65 100644
> --- a/lib/compress.c
> +++ b/lib/compress.c
> @@ -483,7 +483,7 @@ static int z_erofs_fill_inline_data(struct erofs_inod=
e *inode, void *data,
>  {
>         inode->z_advise |=3D Z_EROFS_ADVISE_INLINE_PCLUSTER;
>         inode->idata_size =3D len;
> -       inode->idata_type =3D EROFS_IDATA_TYPE_COMPRESSED_DEFAULT;
> +       inode->idata_type =3D EROFS_IDATA_TYPE_COMPRESSED;
>
>         inode->idata =3D malloc(inode->idata_size);
>         if (!inode->idata)
> @@ -664,7 +664,7 @@ frag_packing:
>                 ictx->fragemitted =3D true;
>         /* tailpcluster should be less than 1 block */
>         } else if (may_inline && len =3D=3D e->length && compressedsize <=
 blksz) {
> -               if (ctx->clusterofs + len <=3D blksz) {
Shouldn't this condition restrict the `tail pcluster` so that it
corresponds to only  eof`lcluster`?
and we drop the inline pcluster just when  eof_tailraw is not null.
Thanks!
> +               if (len <=3D blksz) {
>                         inode->eof_tailraw =3D malloc(len);
>                         if (!inode->eof_tailraw)
>                                 return -ENOMEM;
> @@ -962,6 +962,14 @@ int z_erofs_convert_to_compacted_format(struct erofs=
_inode *inode,
>                 dummy_head =3D true;
>         }
>
> +       if (inode->idata_size) {
> +               if (compacted_2b && !compacted_4b_end)
> +                       inode->idata_type =3D EROFS_IDATA_TYPE_COMPRESSED=
_END_OF_2B;
> +               else if (compacted_2b && compacted_4b_end =3D=3D 1)
> +                       inode->idata_type =3D
> +                               EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV2B;
> +       }
> +
>         /* generate compacted_4b_initial */
>         while (compacted_4b_initial) {
>                 in =3D parse_legacy_indexes(cv, 2, in);
> @@ -974,8 +982,6 @@ int z_erofs_convert_to_compacted_format(struct erofs_=
inode *inode,
>
>         /* generate compacted_2b */
>         if (compacted_2b) {
> -               if (!compacted_4b_end && inode->idata_size)
> -                       inode->idata_type =3D EROFS_IDATA_TYPE_COMPRESSED=
_END_OF_2B;
>                 do {
>                         in =3D parse_legacy_indexes(cv, 16, in);
>                         out =3D write_compacted_indexes(out, cv, &blkaddr=
,
> @@ -1205,11 +1211,65 @@ out:
>         return metabuf;
>  }
>
> +static void z_erofs_patch_tail_compacted_index(struct erofs_inode *inode=
,
> +                                              bool previous,
> +                                              unsigned int type)
> +{
> +       const unsigned int totalidx =3D BLK_ROUND_UP(inode->sbi, inode->i=
_size);
> +       const unsigned int lobits =3D max_t(unsigned int, inode->z_lclust=
erbits,
> +                               ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
> +       u8 *base =3D inode->compressmeta;
> +       u8 *pack =3D base + inode->extent_isize;
> +       unsigned int bitpos, bitoff;
> +       u8 *out;
> +       u32 v;
> +
> +       DBG_BUGON(!totalidx);
> +       DBG_BUGON(inode->z_lclusterbits > 14);
> +
> +       if (inode->idata_type =3D=3D EROFS_IDATA_TYPE_COMPRESSED_END_OF_2=
B) {
> +               pack -=3D 32;
> +               bitpos =3D 14 * (previous ? 14 : 15);
> +               goto out;
> +       }
> +
> +       /* Last compacted index pack is 4B */
> +       pack -=3D 8;
> +       if (!(totalidx & 1)) {
> +               bitpos =3D previous ? 0 : 16;
> +               goto out;
> +       }
> +
> +       if (!previous) {
> +               bitpos =3D 0;
> +               goto out;
> +       }
> +
> +       /* Second to last compacted index pack is 2B */
> +       if (inode->idata_type =3D=3D EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV=
2B) {
> +               pack -=3D 32;
> +               bitpos =3D 14 * 15;
> +       } else {
> +               pack -=3D 8;
> +               bitpos =3D 16;
> +       }
> +out:
> +       DBG_BUGON(pack < base);
> +       bitoff =3D bitpos & 7;
> +       out =3D pack + bitpos / 8;
> +       v =3D get_unaligned_le32(out);
> +       v &=3D ~(Z_EROFS_LI_LCLUSTER_TYPE_MASK << (lobits + bitoff));
> +       v |=3D type << (lobits + bitoff);
> +       put_unaligned_le32(v, out);
> +}
> +
>  void z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
>  {
>         struct erofs_sb_info *sbi =3D inode->sbi;
>         const unsigned int type =3D Z_EROFS_LCLUSTER_TYPE_PLAIN;
>         struct z_erofs_map_header *h =3D inode->compressmeta;
> +       erofs_off_t rawstart;
> +       erofs_blk_t head_lcn, eof_lcn;
>
>         h->h_advise =3D cpu_to_le16(le16_to_cpu(h->h_advise) &
>                                   ~Z_EROFS_ADVISE_INLINE_PCLUSTER);
> @@ -1218,38 +1278,27 @@ void z_erofs_drop_inline_pcluster(struct erofs_in=
ode *inode)
>         if (!inode->eof_tailraw)
>                 return;
>         DBG_BUGON(inode->idata_type =3D=3D EROFS_IDATA_TYPE_RAW);
> +       DBG_BUGON(!inode->i_size);
> +       DBG_BUGON(inode->eof_tailrawsize > erofs_blksiz(sbi));
> +       DBG_BUGON(inode->eof_tailrawsize > inode->i_size);
> +
> +       rawstart =3D inode->i_size - inode->eof_tailrawsize;
> +       head_lcn =3D rawstart >> sbi->blkszbits;
> +       eof_lcn =3D (inode->i_size - 1) >> sbi->blkszbits;
> +       DBG_BUGON(head_lcn !=3D eof_lcn && head_lcn + 1 !=3D eof_lcn);
>
> -       /* patch the EOF lcluster to uncompressed type first */
> +       /* patch the tail pcluster head to uncompressed type first */
>         if (inode->datalayout =3D=3D EROFS_INODE_COMPRESSED_FULL) {
>                 struct z_erofs_lcluster_index *di =3D
> -                       (inode->compressmeta + inode->extent_isize) -
> -                       sizeof(struct z_erofs_lcluster_index);
> +                       (void *)((u8 *)inode->compressmeta +
> +                                Z_EROFS_LEGACY_MAP_HEADER_SIZE +
> +                                head_lcn *
> +                                sizeof(struct z_erofs_lcluster_index));
>
>                 di->di_advise =3D cpu_to_le16(type);
>         } else if (inode->datalayout =3D=3D EROFS_INODE_COMPRESSED_COMPAC=
T) {
> -               /* handle the last compacted 4B/2B pack */
> -               unsigned int lclusterbits =3D inode->z_lclusterbits;
> -               unsigned int lobits, eofs, base, pos, v;
> -               u8 *out;
> -
> -               lobits =3D max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT)=
 + 1U);
> -
> -               if (inode->idata_type =3D=3D EROFS_IDATA_TYPE_COMPRESSED_=
DEFAULT) {
> -                       eofs =3D inode->extent_isize -
> -                               (4 << (BLK_ROUND_UP(sbi, inode->i_size) &=
 1));
> -                       base =3D round_down(eofs, 8);
> -                       pos =3D 16 /* encodebits */ * ((eofs - base) / 4)=
;
> -                       out =3D inode->compressmeta + base + pos / 8;
> -               } else {
> -                       out =3D inode->compressmeta + inode->extent_isize=
 -
> -                               sizeof(__le32) - sizeof(__le16);
> -                       lobits =3D 16 - 14 /* encodebits */ + lobits;
> -               }
> -
> -               v =3D (get_unaligned_le16(out) & (BIT(lobits) - 1)) |
> -                       (type << lobits);
> -               *out =3D v & 0xff;
> -               *(out + 1) =3D v >> 8;
> +               z_erofs_patch_tail_compacted_index(inode, head_lcn !=3D e=
of_lcn,
> +                                                  type);
>         } else {
>                 DBG_BUGON(1);
>                 return;
> --
> 2.47.3
>
>

