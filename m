Return-Path: <linux-erofs+bounces-3944-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6118BC44529
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jul 2026 06:55:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h47SP1TQ0z2xlb;
	Tue, 21 Jul 2026 16:55:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784616933;
	cv=none; b=YpBr9gm+hAO8dgle6tmR0p6GbqxKQ5YhdFjf0XeqhxveamgepCydmR5cg0QgNqD1PeoTJ9SfOhTYWd2w0KeMZctQhNX2U8R/+KwA9VtGcssFIWGhb/VgHWuMjGRHimGVviG/GWe+9Qcy/z3J0hWsZnIEh7IQxtwaWumLduzlsQVkzInIULRbYDmhHVxSnDsM8Z9EvVFZKLmTLaJu2afto3aSl4ZK4Y4xsa9D66CSPesex/orxA6IBdmdCGP3X7xPsGeFgq1TQedpLfbvvyf/a1XjiGH4pXiXWO3JSWeJDL7J2tA6I23qezBEwXow0tQ0fjIzz7sbGBBDMOogMJRNYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784616933; c=relaxed/relaxed;
	bh=DHTDzp2I/y81wqlzxiArgIU06hhGwecM6piqbzrai0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cfuqH0y78Hf2zNOnPUJKSEE9SVSjvc1U1HWGw2Hc66CaJ6D9zPq78HaWhwIJ94IWnmS/vzHwgqJ0C5bf59SQ6HF9SRyN0xB8IDOlzd7zKU75Vch9K42Q+Pk5V+tN4s9iwbo5xUH2+hQoDg8plbXbu+bcResMNpfDxhLVd9vYk0yPLBtRLSjIuqCOwLwow+007GPQTqTbIx5uC0AM1WUOcF3zEV7QN6zjQRDhW9aArGr74aonmPdfMOiQrV2XMPDbXmwOVkA5xw3SWBLHTRQld9zIliZptZlS7geYAgvMV47SkzHkHqvW02crffgoPYr59mfC+vMRCNcHZtxX71rcIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=y0TLTVR/; dkim-atps=neutral; spf=pass (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=y0TLTVR/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h47SL1Pzxz2xLh
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 16:55:28 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DHTDzp2I/y81wqlzxiArgIU06hhGwecM6piqbzrai0w=;
	b=y0TLTVR/7cE+x2oAej3V7imlAXroJLxGOc7jkmLFIbUN2ftcYlqwm3UlpVfbor/JoZY4fBm1l
	jIWjXSXZpXnDFC7q/DxxgUIcX0jPfhQUxRinrxobRueTuo+WV09VsN3HVb4gNKbxWgkXrdtbuDJ
	kKqXmyZSuVPKOWK+hi7RlwU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h47FL3DF5zKmWb;
	Tue, 21 Jul 2026 14:45:58 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id E6C43402AB;
	Tue, 21 Jul 2026 14:55:22 +0800 (CST)
Received: from [100.102.28.251] (100.102.28.251) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 21 Jul 2026 14:55:22 +0800
Message-ID: <5700f79d-2cfb-4408-80d3-509ac154bef0@huawei.com>
Date: Tue, 21 Jul 2026 14:55:21 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: lib: fix ztailpacking fallback across
 lclusters
To: Zhiguo Niu <niuzhiguo84@gmail.com>
CC: <linux-erofs@lists.ozlabs.org>, <hsiangkao@linux.alibaba.com>,
	<zhukeqian1@huawei.com>
References: <20260709123411.1166770-1-zhaoyifan28@huawei.com>
 <CAHJ8P3JK5gKS=RH2b=waY7g1AJ7S6ZHzDV0asg46pkzHsWzMHw@mail.gmail.com>
From: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
In-Reply-To: <CAHJ8P3JK5gKS=RH2b=waY7g1AJ7S6ZHzDV0asg46pkzHsWzMHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.102.28.251]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 2026/7/20 19:42, Zhiguo Niu wrote:
> Yifan Zhao <zhaoyifan28@huawei.com> 于2026年7月9日周四 20:36写道：
>> With ztailpacking, the final compressed pcluster is first stored as
>> inline data.  If the inode metadata area cannot hold it, mkfs falls back
>> to a normal tail block and drops the inline pcluster marker.
>>
>> The current fallback path assumes that the inline tail pcluster belongs
>> to the EOF lcluster.  That is not always true: the tail pcluster can
>> start in the previous lcluster and end at EOF, while its raw size still
>> fits in one block.  In that case, patching the EOF lcluster is
>> semantically wrong.
>>
>> Let's keep raw tail data whenever it fits in one block, and convert the
>> corresponding lcluster index to PLAIN during fallback.
>>
>> Reported-by: Alberto Salvia Novella <es20490446e@gmail.com>
>> Closes: https://github.com/erofs/erofs-utils/issues/51
>> Assisted-by: Codex:GPT-5.5
>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>> ---
> Hi Yifan,
> I tested this patch to focus on the issue fixed by commit
> 277a42502a7a, and it passed.
> But I have some questions:
>>   include/erofs/internal.h |   5 +-
>>   lib/compress.c           | 109 ++++++++++++++++++++++++++++-----------
>>   2 files changed, 83 insertions(+), 31 deletions(-)
>>
>> diff --git a/include/erofs/internal.h b/include/erofs/internal.h
>> index 2cc9cc8..bdde41f 100644
>> --- a/include/erofs/internal.h
>> +++ b/include/erofs/internal.h
>> @@ -212,8 +212,11 @@ struct erofs_diskbuf;
>>
>>   enum erofs_idata_type {
>>          EROFS_IDATA_TYPE_RAW,
>> -       EROFS_IDATA_TYPE_COMPRESSED_DEFAULT,
>> +       EROFS_IDATA_TYPE_COMPRESSED,
>> +       /* compressed idata follows a final 2B compacted index pack */
>>          EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B,
>> +       /* compressed idata follows a final single-entry 4B pack after a 2B pack */
>> +       EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV2B,
>>   };
>>
>>   #define EROFS_I_BLKADDR_DEV_ID_BIT             48
>> diff --git a/lib/compress.c b/lib/compress.c
>> index f7ad5a1..ec90f65 100644
>> --- a/lib/compress.c
>> +++ b/lib/compress.c
>> @@ -483,7 +483,7 @@ static int z_erofs_fill_inline_data(struct erofs_inode *inode, void *data,
>>   {
>>          inode->z_advise |= Z_EROFS_ADVISE_INLINE_PCLUSTER;
>>          inode->idata_size = len;
>> -       inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_DEFAULT;
>> +       inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED;
>>
>>          inode->idata = malloc(inode->idata_size);
>>          if (!inode->idata)
>> @@ -664,7 +664,7 @@ frag_packing:
>>                  ictx->fragemitted = true;
>>          /* tailpcluster should be less than 1 block */
>>          } else if (may_inline && len == e->length && compressedsize < blksz) {
>> -               if (ctx->clusterofs + len <= blksz) {
> Shouldn't this condition restrict the `tail pcluster` so that it
> corresponds to only  eof`lcluster`?
> and we drop the inline pcluster just when  eof_tailraw is not null.
> Thanks!

Hi Zhiguo,


A tail pcluster may start in the previous lcluster and end in the EOF 
lcluster while its whole raw payload still fits in one physical block. 
In that case `ctx->clusterofs + len > blksz`, but `len <= blksz`, but it 
should still be converted into a single PLAIN pcluster.

This patch targets this edge case so I think change the if statement 
here is necessary?


Thanks,

Yifan

>> +               if (len <= blksz) {
>>                          inode->eof_tailraw = malloc(len);
>>                          if (!inode->eof_tailraw)
>>                                  return -ENOMEM;
>> @@ -962,6 +962,14 @@ int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
>>                  dummy_head = true;
>>          }
>>
>> +       if (inode->idata_size) {
>> +               if (compacted_2b && !compacted_4b_end)
>> +                       inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B;
>> +               else if (compacted_2b && compacted_4b_end == 1)
>> +                       inode->idata_type =
>> +                               EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV2B;
>> +       }
>> +
>>          /* generate compacted_4b_initial */
>>          while (compacted_4b_initial) {
>>                  in = parse_legacy_indexes(cv, 2, in);
>> @@ -974,8 +982,6 @@ int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
>>
>>          /* generate compacted_2b */
>>          if (compacted_2b) {
>> -               if (!compacted_4b_end && inode->idata_size)
>> -                       inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B;
>>                  do {
>>                          in = parse_legacy_indexes(cv, 16, in);
>>                          out = write_compacted_indexes(out, cv, &blkaddr,
>> @@ -1205,11 +1211,65 @@ out:
>>          return metabuf;
>>   }
>>
>> +static void z_erofs_patch_tail_compacted_index(struct erofs_inode *inode,
>> +                                              bool previous,
>> +                                              unsigned int type)
>> +{
>> +       const unsigned int totalidx = BLK_ROUND_UP(inode->sbi, inode->i_size);
>> +       const unsigned int lobits = max_t(unsigned int, inode->z_lclusterbits,
>> +                               ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
>> +       u8 *base = inode->compressmeta;
>> +       u8 *pack = base + inode->extent_isize;
>> +       unsigned int bitpos, bitoff;
>> +       u8 *out;
>> +       u32 v;
>> +
>> +       DBG_BUGON(!totalidx);
>> +       DBG_BUGON(inode->z_lclusterbits > 14);
>> +
>> +       if (inode->idata_type == EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B) {
>> +               pack -= 32;
>> +               bitpos = 14 * (previous ? 14 : 15);
>> +               goto out;
>> +       }
>> +
>> +       /* Last compacted index pack is 4B */
>> +       pack -= 8;
>> +       if (!(totalidx & 1)) {
>> +               bitpos = previous ? 0 : 16;
>> +               goto out;
>> +       }
>> +
>> +       if (!previous) {
>> +               bitpos = 0;
>> +               goto out;
>> +       }
>> +
>> +       /* Second to last compacted index pack is 2B */
>> +       if (inode->idata_type == EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV2B) {
>> +               pack -= 32;
>> +               bitpos = 14 * 15;
>> +       } else {
>> +               pack -= 8;
>> +               bitpos = 16;
>> +       }
>> +out:
>> +       DBG_BUGON(pack < base);
>> +       bitoff = bitpos & 7;
>> +       out = pack + bitpos / 8;
>> +       v = get_unaligned_le32(out);
>> +       v &= ~(Z_EROFS_LI_LCLUSTER_TYPE_MASK << (lobits + bitoff));
>> +       v |= type << (lobits + bitoff);
>> +       put_unaligned_le32(v, out);
>> +}
>> +
>>   void z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
>>   {
>>          struct erofs_sb_info *sbi = inode->sbi;
>>          const unsigned int type = Z_EROFS_LCLUSTER_TYPE_PLAIN;
>>          struct z_erofs_map_header *h = inode->compressmeta;
>> +       erofs_off_t rawstart;
>> +       erofs_blk_t head_lcn, eof_lcn;
>>
>>          h->h_advise = cpu_to_le16(le16_to_cpu(h->h_advise) &
>>                                    ~Z_EROFS_ADVISE_INLINE_PCLUSTER);
>> @@ -1218,38 +1278,27 @@ void z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
>>          if (!inode->eof_tailraw)
>>                  return;
>>          DBG_BUGON(inode->idata_type == EROFS_IDATA_TYPE_RAW);
>> +       DBG_BUGON(!inode->i_size);
>> +       DBG_BUGON(inode->eof_tailrawsize > erofs_blksiz(sbi));
>> +       DBG_BUGON(inode->eof_tailrawsize > inode->i_size);
>> +
>> +       rawstart = inode->i_size - inode->eof_tailrawsize;
>> +       head_lcn = rawstart >> sbi->blkszbits;
>> +       eof_lcn = (inode->i_size - 1) >> sbi->blkszbits;
>> +       DBG_BUGON(head_lcn != eof_lcn && head_lcn + 1 != eof_lcn);
>>
>> -       /* patch the EOF lcluster to uncompressed type first */
>> +       /* patch the tail pcluster head to uncompressed type first */
>>          if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL) {
>>                  struct z_erofs_lcluster_index *di =
>> -                       (inode->compressmeta + inode->extent_isize) -
>> -                       sizeof(struct z_erofs_lcluster_index);
>> +                       (void *)((u8 *)inode->compressmeta +
>> +                                Z_EROFS_LEGACY_MAP_HEADER_SIZE +
>> +                                head_lcn *
>> +                                sizeof(struct z_erofs_lcluster_index));
>>
>>                  di->di_advise = cpu_to_le16(type);
>>          } else if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
>> -               /* handle the last compacted 4B/2B pack */
>> -               unsigned int lclusterbits = inode->z_lclusterbits;
>> -               unsigned int lobits, eofs, base, pos, v;
>> -               u8 *out;
>> -
>> -               lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
>> -
>> -               if (inode->idata_type == EROFS_IDATA_TYPE_COMPRESSED_DEFAULT) {
>> -                       eofs = inode->extent_isize -
>> -                               (4 << (BLK_ROUND_UP(sbi, inode->i_size) & 1));
>> -                       base = round_down(eofs, 8);
>> -                       pos = 16 /* encodebits */ * ((eofs - base) / 4);
>> -                       out = inode->compressmeta + base + pos / 8;
>> -               } else {
>> -                       out = inode->compressmeta + inode->extent_isize -
>> -                               sizeof(__le32) - sizeof(__le16);
>> -                       lobits = 16 - 14 /* encodebits */ + lobits;
>> -               }
>> -
>> -               v = (get_unaligned_le16(out) & (BIT(lobits) - 1)) |
>> -                       (type << lobits);
>> -               *out = v & 0xff;
>> -               *(out + 1) = v >> 8;
>> +               z_erofs_patch_tail_compacted_index(inode, head_lcn != eof_lcn,
>> +                                                  type);
>>          } else {
>>                  DBG_BUGON(1);
>>                  return;
>> --
>> 2.47.3
>>
>>

