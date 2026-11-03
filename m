Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C80606A330
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 03:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SM54FBq7
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJZWr43Mjz2xN4;
	Tue, 03 Nov 2026 14:56:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::122b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793678216;
	cv=none; b=TGnUpBbOXwCkXOQFb6EQqtBHwLfOGGcfuQ+AnILuI1Q+t707FC0Ojn4kPfYhWPd0/SI6SiaTSDfOriQPR84umPE3oLPTy7nWd3cUraXKyQjkRqtuX+7relw8J6sT1HeEf2ut2cSh6yCcBpbZRiXfHIQcIn5P5lOdIAP0yLS4ImwWfLSif2s7h5nsHAZ3Gr2Ss4F6afgUwIGC0Z2fBENGJGVbVFdmzRN+tMfxSukFne/qt523DNXmkcVH/o6UMMyqEjpQKjFVVBlEKqWJxRP2LjFNYsXS2AGRDFTWhqk83ro5TPZH9N0X9mDK5s++SoVMOH5e7rSwg0E0n8KjMYYneA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793678216; c=relaxed/relaxed;
	bh=BglRv2f4EfYxLM7Eysc2RoRvvS4v0u9k5xhRuNtFy9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Jc4WH4Avs2Q6mT/AZWG65VDtL6lGfkTF8QekGPiOJXOnfydsirnqtt/Gcg8l8jYonL0JP6j1VQQUqvPvn81wXtM7Q0GX2uyLA4mMeWYwofg/V48J0w6cDIWYlWYWjoNPbCtwVAXGcHaiqeyT2zBRQHPtQoBC2haYWOxCziPEZ1Up3CrJ55/3wLrcMR/jz5xMx5dNkyUfz0oLelV5EBZqNEc5/v06zPY1jE+Orj/wFEE/4YC+9JPQaoOu6ffaD7F2wkoEU1g+LBnIPz9l73D2/Ff3AQ67skylAS9MJlxlU0EPdkDKF1g9w8E+L9WBtOdpJ+/tAcOcPujzhNoajdg3ag==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SM54FBq7; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::122b; helo=mail-dl1-x122b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SM54FBq7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::122b; helo=mail-dl1-x122b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl1-x122b.google.com (mail-dl1-x122b.google.com [IPv6:2607:f8b0:4864:20::122b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJZWp5hcTz2xBK
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 14:56:54 +1100 (AEDT)
Received: by mail-dl1-x122b.google.com with SMTP id a92af1059eb24-1a3c08d6928so4588265c88.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 19:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793678212; x=1794283012; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BglRv2f4EfYxLM7Eysc2RoRvvS4v0u9k5xhRuNtFy9Y=;
        b=SM54FBq7IXcsn2mRtLDN0ao/omuOEeIx+ZmknZRpxoab1Wwxovl5oxEgR6r/UiXZGp
         0frBCROlmCFiWcpQR/jfMJVLgb3eoWw+sO675CzQzXQdIuP6dIoYAB1UqnZFJNulPcJA
         sW0YfCTojcn9QiFLF2a4OLrdcvezmgdx66L58g6jlLWSkoMWfsknCNOnqRILEKlDTQ/v
         UEMfL9r4iEAKdBx2Gl/aeNuEXLdkl5dXjCK/dLFo+VwbYtBtDaNPssp5J+j2I8hGcrSF
         eENoWZPzNZmtuoJ1ZZg7Li3xhW3viUM2DXZJB/8TEHqYLA3fXOdHUeIk2pbKxsnxjixC
         TvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793678212; x=1794283012;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BglRv2f4EfYxLM7Eysc2RoRvvS4v0u9k5xhRuNtFy9Y=;
        b=OWu80dG+deaRNs/Y22qyQq78DG3xoX7ecIVx5tk1GE7J/k+zTMI5BUezHf6P7Wfsm6
         PGozw+vPup56DyJwOABmN3cr12GdZdwyZZrxGf00EILqxoDdZww7DPnobIR6fmMuvYou
         X2CTODwzwE3db1S7agodC6ap5sOO9L9M629lAqPHMwMPiO+jRc9DVGZ19Yis+p6yK+8+
         UNKBzO1dMl2HaJHVsY908/beeIWrPOsGVPH+sgHmGOlL0+jjOgZtpoGOQa+UZDQIp7WS
         y5NYrsRggSqHkarkA1p2/F0C54mFPwh2vJp7R7Wv08KdTqBg59qcnlTr3hntdtOvhdhE
         hZtg==
X-Forwarded-Encrypted: i=1; AKwUvBziaykagy3s6+DtlT3nDNVAasjF7dl/p7fico1XPwrdBGNEUH+jjXXCjH51BtAt6ha+rum4vtMuE/c5Jw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJbATgkiXhi8jOl82oZPl41bchEAahOYDZ9gNTdqaxN2uOLB8Md
	QSRucueTRp8kK5bg5jPXa0x4Rv1WgK5Ll/JlxDu/ntwOZo6t9D4DjW2K
X-Gm-Gg: AYBFou35eLQlukcwQJfsLyZb9ovWLZyeKoBtLhZ8ML6xTZs/Euc6kTaB44KcWBZnMyS
	TraflvTsZf76sqYJSZ5QjwNhIJbYa+JmesPzxfk0i47yO/WyiUpMKLc3x7vMa8GRi+0fcgQsrDb
	YekynVwI0/sbFij2g8sN+/bTGIfr7j2CuvtFX9xtbzolRoi5BOLaLMWTUU4R/AU1Q2k4x+Uoyvo
	yX4h6w8MDsRF38PrisMEKGqSjpj5WjpEyKdybxeFabbD1h7rS/AZDMpX8VPC13itgNBusAWKjim
	VDZ7PvH7E1mtd8jKQg0Y5HRWF/K5ov+FWh1/0d+a//B1NT54dyfUDzj0jgtF4/82w3ScclMllHe
	B2LRffSPLIZ2pwXm2e9aX+vmtBv0gGQ5zlvY0GjM/dT45g+qQ4q3S9cQ8LzBkX3+qy9lWw8cfoi
	1gHA6Tg5wnvkcqp0cf0B3ZI/ggE+YsHtRpGX4jXoe75ssavYbK+FclDhhR4K4Qr8fuEX8pcUqvp
	+d69baxIzhHK3pu6nU5lZT+0Z2YCcRaPbsTIyGeJF9w22uWMnu1r76T8XNFE5wZeSR0RgCIhtT3
	QPJCd8T7I/4zA9ynINBv/7D6Tf1gsRvdSj69aLlgYiNAOhWpTA==
X-Received: by 2002:a05:701b:2816:b0:1a0:f970:4f5d with SMTP id a92af1059eb24-1ac5bda42d5mr16406051c88.17.1793678211261;
        Mon, 02 Nov 2026 19:56:51 -0800 (PST)
Received: from [127.0.0.1] ([2404:c140:2103:8564:d421:38da:52b7:98ac])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac194b5437sm42835222c88.13.2026.11.02.19.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 19:56:50 -0800 (PST)
Message-ID: <6f29b317-9df0-4e96-94c0-e3c3858f41e5@gmail.com>
Date: Tue, 3 Nov 2026 11:56:46 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] erofs-utils: lib: track packed inode position
 explicitly
To: Gao Xiang <xiang.gao@docker.com>, linux-erofs@lists.ozlabs.org
References: <20261103004547.15053-1-xiang.gao@docker.com>
Content-Language: en-US
From: Yifan Zhao <stopire@gmail.com>
In-Reply-To: <20261103004547.15053-1-xiang.gao@docker.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 3/11/26 08:45, Gao Xiang wrote:
> Track the packed inode position in memory instead of querying the
> file offset. Use positional writes for fragment data and seek
> explicitly before the sendfile fallback.
>
> Factor out __erofs_io_pwrite() and fix its short-write handling.
>
> Assisted-by: ChatGPT:gpt-6.1-sol
> Signed-off-by: Gao Xiang <xiang.gao@docker.com>
> ---
>   include/erofs/io.h |  2 +-
>   lib/fragments.c    | 44 +++++++++++++++++++++-----------------------
>   lib/io.c           | 29 ++++++++++++++---------------
>   3 files changed, 36 insertions(+), 39 deletions(-)
>
> diff --git a/include/erofs/io.h b/include/erofs/io.h
> index 96309fd..f3d4899 100644
> --- a/include/erofs/io.h
> +++ b/include/erofs/io.h
> @@ -68,7 +68,7 @@ struct erofs_vfile {
>   	};
>   };
>   
> -ssize_t __erofs_io_write(int fd, const void *buf, size_t len);
> +ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos);
>   int __erofs_0write(int fd, size_t len);
>   
>   int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf);
> diff --git a/lib/fragments.c b/lib/fragments.c
> index f137e41..bb9ef72 100644
> --- a/lib/fragments.c
> +++ b/lib/fragments.c
> @@ -49,6 +49,7 @@ struct erofs_packed_inode {
>   	unsigned long *uptodate;
>   	erofs_mutex_t mutex;
>   	u64 uptodate_bits;
> +	erofs_off_t pos;

erofs_xattr_flush_name_prefixes() also manipulates the packed inode's fd 
offset.


     if (bh) {
         bh->op = &erofs_drop_directly_bhops;
         err = erofs_bh_balloon(bh, offset - start);
         if (err < 0)
             return err;
         bh->op = &erofs_drop_directly_bhops;
         erofs_bdrop(bh, false);
     } else {
         DBG_BUGON(bmgr);
         if (lseek(vf->fd, offset, SEEK_SET) < 0) // maybe a packedinode
             return -errno;
     }


Introducing a separate pos field would leave the two out of sync; how 
should this be handled?


Thanks,

Yifan Zhao

>   };
>   
>   const char *erofs_frags_packedname = "packed_file";
> @@ -245,9 +246,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
>   	if (__erofs_unlikely(!inode->i_size))
>   		return 0;
>   
> -	offset = lseek(epi->fd, 0, SEEK_CUR);
> -	if (offset < 0)
> -		return -errno;
> +	offset = epi->pos;
>   
>   	if (vf->ops)
>   		memblock = NULL;
> @@ -260,20 +259,24 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
>   		bool noseek = vf->ops && !vf->ops->pread;
>   		off_t pos = fpos;
>   
> +		memblock = NULL;
> +		rc = lseek(epi->fd, offset, SEEK_SET);
> +		if (rc < 0) {
> +			rc = -errno;
> +			goto out;
> +		}
>   		do {
>   			sz = min_t(u64, remaining, UINT_MAX);
>   			rc = erofs_io_sendfile(&vout, vf,
>   					       noseek ? NULL : &pos, sz);
> -			if (rc <= 0)
> -				break;
> +			if (rc <= 0) {
> +				if (!rc)
> +					rc = -EIO;
> +				goto out;
> +			}
>   			remaining -= rc;
>   		} while (remaining);
>   
> -		if (remaining && rc >= 0) {
> -			rc = -EIO;
> -			goto out;
> -		}
> -
>   		sz = min_t(u64, inode->i_size, EROFS_FRAGMENT_INMEM_SZ_MAX);
>   		memblock = malloc(sz);
>   		if (!memblock) {
> @@ -291,7 +294,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
>   			goto out;
>   		}
>   	} else {
> -		rc = __erofs_io_write(epi->fd, memblock, inode->i_size);
> +		rc = __erofs_io_pwrite(epi->fd, memblock, inode->i_size, offset);
>   		if (rc != inode->i_size) {
>   			if (rc >= 0)
>   				rc = -EIO;
> @@ -299,6 +302,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
>   		}
>   	}
>   
> +	epi->pos = offset + inode->i_size;
>   	rc = erofs_fragment_pack(inode, memblock, offset, inode->i_size,
>   				 tofh, onheap);
>   out:
> @@ -332,17 +336,16 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
>   		return 0;
>   	}
>   
> -	offset = lseek(epi->fd, 0, SEEK_CUR);
> -	if (offset < 0)
> -		return -errno;
> +	offset = epi->pos;
>   
> -	ret = write(epi->fd, fi->data, fi->length);
> +	ret = __erofs_io_pwrite(epi->fd, fi->data, fi->length, offset);
>   	if (ret != fi->length) {
>   		if (ret < 0)
>   			return -errno;
>   		return -EIO;
>   	}
>   	offset += fi->length;
> +	epi->pos = offset;
>   
>   	if (!list_empty(&fi->list)) {
>   		struct erofs_fragment_bucket *bk = &epi->bks[FRAGMENT_HASH(tofh)];
> @@ -380,7 +383,7 @@ int erofs_flush_packed_inode(struct erofs_importer *im)
>   	if (!epi || !erofs_sb_has_fragments(sbi))
>   		return 0;
>   
> -	if (lseek(epi->fd, 0, SEEK_CUR) <= 0)
> +	if (!epi->pos)
>   		return 0;
>   
>   	erofs_update_progressinfo("Processing packed data ...");
> @@ -460,7 +463,6 @@ int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs)
>   			.sbi = sbi,
>   			.nid = sbi->packed_nid,
>   		};
> -		s64 offset;
>   
>   		err = erofs_read_inode_from_disk(&ei);
>   		if (err) {
> @@ -469,11 +471,7 @@ int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs)
>   			goto err_out;
>   		}
>   
> -		offset = lseek(epi->fd, ei.i_size, SEEK_SET);
> -		if (offset < 0) {
> -			err = -errno;
> -			goto err_out;
> -		}
> +		epi->pos = ei.i_size;
>   		epi->uptodate_bits = round_up(BLK_ROUND_UP(sbi, ei.i_size),
>   					      sizeof(epi->uptodate) * 8);
>   		epi->uptodate = calloc(1, epi->uptodate_bits >> 3);
> @@ -548,7 +546,7 @@ static void *erofs_packedfile_preload(struct erofs_inode *pi,
>   	if (err)
>   		goto err_out;
>   
> -	err = pwrite(epi->fd, buffer, map->m_llen, map->m_la);
> +	err = __erofs_io_pwrite(epi->fd, buffer, map->m_llen, map->m_la);
>   	if (err < 0) {
>   		err = -errno;
>   		if (err == -ENOSPC) {
> diff --git a/lib/io.c b/lib/io.c
> index 3333170..14253af 100644
> --- a/lib/io.c
> +++ b/lib/io.c
> @@ -26,7 +26,7 @@
>   #define EROFS_MODNAME	"erofs_io"
>   #include "erofs/print.h"
>   
> -ssize_t __erofs_io_write(int fd, const void *buf, size_t len)
> +static ssize_t __erofs_io_write(int fd, const void *buf, size_t len)
>   {
>   	ssize_t ret, written = 0;
>   
> @@ -61,24 +61,12 @@ int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf)
>   	return fstat(vf->fd, buf);
>   }
>   
> -ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
> -			u64 pos, size_t len)
> +ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos)
>   {
>   	ssize_t ret, written = 0;
>   
> -	if (__erofs_unlikely(cfg.c_dry_run))
> -		return 0;
> -
> -	if (vf->ops)
> -		return vf->ops->pwrite(vf, buf, pos, len);
> -
> -	pos += vf->offset;
>   	do {
> -#ifdef HAVE_PWRITE64
> -		ret = pwrite64(vf->fd, buf, len, (off64_t)pos);
> -#else
> -		ret = pwrite(vf->fd, buf, len, (off_t)pos);
> -#endif
> +		ret = pwrite(fd, buf, len - written, (off_t)pos);
>   		if (ret <= 0) {
>   			if (!ret)
>   				break;
> @@ -96,6 +84,17 @@ ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
>   	return written;
>   }
>   
> +ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
> +			u64 pos, size_t len)
> +{
> +	if (__erofs_unlikely(cfg.c_dry_run))
> +		return 0;
> +
> +	if (vf->ops)
> +		return vf->ops->pwrite(vf, buf, pos, len);
> +	return __erofs_io_pwrite(vf->fd, buf, len, pos + vf->offset);
> +}
> +
>   ssize_t erofs_io_pwritev(struct erofs_vfile *vf, const struct iovec *iov,
>   			 int iovcnt, u64 pos)
>   {

