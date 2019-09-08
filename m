Return-Path: <SRS0=rxNV=XD=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CFDC433EF
	for <linux-erofs@archiver.kernel.org>; Sun,  8 Sep 2019 23:56:37 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB27620859
	for <linux-erofs@archiver.kernel.org>; Sun,  8 Sep 2019 23:56:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="hzFDXbiN";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="tL/8v1jp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB27620859
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46RSr20857zDqQd
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Sep 2019 09:56:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1567986994;
	bh=w9TijnosMQuiRdSX4oAdACkBEIZjIyJFwDgPGa5p5l0=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=hzFDXbiNOFBW7OuhM1VxNRW6yS989VEK4oH5Aiv/9M0ulg4HV+oS4776tQE+mjBoL
	 06E3F5PK6fL2i/tszab1OQsAQXycqrhDisWkg9X6VizF63BtuX1XbWSN/E1bL3h+Ba
	 cIj5+jjtCbpjC9s/rfn6AxBEzVvVUiUn0LsYvqArk6zSYMSqvE5lwGhxi+F82MXfgf
	 UPupbbHul3PoGMghLK7itQfwVn0MbtbKtsbhI/O666jiXTZ4XS1mYwWN/6zSl6vUmJ
	 qEQqGrr7javv/27G/A5YnCy1TkaXEfzLQURKHGUjTwbrMdjsuayoWMoL3juXI88ZJH
	 p/egbD3fzX9CQ==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=98.137.65.110; helo=sonic313-47.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="tL/8v1jp"; 
 dkim-atps=neutral
Received: from sonic313-47.consmr.mail.gq1.yahoo.com
 (sonic313-47.consmr.mail.gq1.yahoo.com [98.137.65.110])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46RSqt0cvlzDqQL
 for <linux-erofs@lists.ozlabs.org>; Mon,  9 Sep 2019 09:56:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1567986978; bh=8Bw5voSTyYrsH2EAJhL50ttNNY3dDd4r+nOeI5GfOvg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=tL/8v1jpjRvms20TUNCbAmRx/hdb5qPyZX8CthEXrsS++H29mh99uWuDhZuUn5dW/RuQjNtVb7fH3qhz4DdGxqhFw8D3TYQW5qZdlNqsA5QiPcY327ov14m8oxwY4LAMGszvJLASLnjHOFnor40OYZ1O1EJMY1yZVUHuuZyZZjNIbD7KFIgUb/xg0GU7g2xTyM9/mHt1zwqWV/Y0KFMct21VDiGj2Do4Uo8QYg11EjITLkaMOdk13XF7vZegHQZZ8lj1xnp5e6/5aNmrtY3VReG6KV7unBMz5k8w3IGP0TSo7NtEt0tzPDKsjzyyGcnzigEgW0CWqNJpRejFnpEeow==
X-YMail-OSG: J6SKBjYVM1mjNqKqQ3tXtlQ2CuiSFiySX37CDfVPT6pWvSJDNsYFAdWDyjgLNgz
 W4O45.ExIXNMOLRi84GdjesazT6pQ.IdxnITBU.I2M1Na.ioLp63wsw4hR1putkUB4G23V3XXH.f
 MXb5WIL4fJhcdS_gXe3oGCwTLQdYk60eXp9MABgS3ziXNTTP6FwINwPXIy_MsgWYD_fr9zbhYkmo
 t0kYM4rCjb9ttRq2JYvml1za2cEi7Of7ymlz3B203DTmd2yllgGjcYFestrxckUtFQB6vlbK3CGz
 NWEg2pe_695mjCV0uAu7P68gNr6WxjZgsvwiuR0jb3b_BIuQOu19qFd1LZUNU4TNe9BuVL2tqQNy
 SB6QhObYOIy07zyhFLIRU03Hw.j5bXBtbr.G6gclW95kSnkJMXkTWo3Atms85EMWUY2YcGB3_J5T
 TVXh9GuvJHspXclpLlgvMn2ymW7lTGldCOnhv9hRIaI9arVek4TQ8uWU2rs2C61VW4bVA_5I8aM7
 1NDq30wL1ckHgLoa.otgt_ZGv3fztY05..p6ePatmgoyb4eEYQWXj2zJ1d6HheFAL1tSApygb3UA
 loKoyS5.kJWkX5xgvXEQioefSMPxSG_COpteAJN5xJNa_hNNkFaBJXc3IuJ8xTa5F0xSLdPQRKNB
 69FGfNiygKp6w4KZpU_.vzgO3c6Kdj2zeNGm0FlzC7_aBuHybalJKi6.LiC9bxBprReOwEqdEWD8
 bGF_mn0pTgMmtoVxG.DhgMsL2DaDF__UhnwoNrKdN5KmCQ8MVvYqveYuKLZ3.PQax63UyR9s_KIo
 kTlH0FKKptH18ZIpczH5IyrBiPDl4Nd8TSUxway_KtZ_a_uc0LA0s3H.4vJzvddJOTyrwYH9nYHo
 SnlXqk6wCdq0blVDFIwzvIAQpEzId84f6pYr7vyg5Vt9UH3wHUpjHuqfPzYtk0VZd7WtArhJDaOO
 PbUGojP9qgjOnR4X.b3oT7ySXZv0oda8N_SwxA0K0LD55CKgH0lzmCAWPojHvQOwtqup3zO_zUkQ
 1CILTF7Wgmmdxs6tQBwQV34aGPkAnvaO9wVXdyKpI77.clbvoH7jnMxczbxOplTEy5LqBb8Qgt_z
 cbEwnFD2JSAIp2aEb2Euqsfl1m1SjrxdOqah5WdY_Scu03ZAggPT8gJfO7oEyOOVZ_qnHDOG6DWT
 CBWbY6Dl986wEj8bnTDh_vYuZBu6ft2mqucbGACzyi7JrXSFwWXoPnTUrWHDo.c0nJwnj8uEpOzR
 CTRsYIZMQFmpITJXao7rZ4e3JXjpqEiQ_OcTwjRFdk6hwQLEFPizLE9.rcK69cnjCzv7IZ0R68WZ
 uXrIBL9Dh1EAnaOV00cl3ZVx8_o8wCoH9pskcaMezpIn2aqq.Q3RMvnYmB5z1zZWFapL1E2XNXK2
 epV2g11X7x6NeSJIOwAgomIJ71_PAPEviBFsYzkzEX7hB0itAP6bgS26mxQ--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic313.consmr.mail.gq1.yahoo.com with HTTP; Sun, 8 Sep 2019 23:56:18 +0000
Received: by smtp416.mail.sg3.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 2eacc41cc96e05ff3db40f99becfb3a1; 
 Sun, 08 Sep 2019 23:54:16 +0000 (UTC)
Date: Mon, 9 Sep 2019 07:54:12 +0800
To: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH erofs-utils v2] build: cure compiler warnings
Message-ID: <20190908235409.GA9570@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190908214821.32265-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908214821.32265-1-jengelh@inai.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Mailer: WebService/1.1.14303 hermes Apache-HttpAsyncClient/4.1.4
 (Java/1.8.0_181)
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Cc: linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Jan,

(cc erofs mailing list...)

On Sun, Sep 08, 2019 at 11:48:21PM +0200, Jan Engelhardt wrote:
> On i586 I observe:
> 
> In file included from inode.c:16:
> inode.c: In function 'erofs_mkfs_build_tree':
> ../include/erofs/print.h:27:21: error: format '%lu' expects argument of type
> 'long unsigned int', but argument 7 has type 'erofs_nid_t' {aka 'long long unsigned int'} [-Werror=format=]
>    27 | #define pr_fmt(fmt) "EROFS: " FUNC_LINE_FMT fmt "\n"
> ../include/erofs/print.h:43:4: note: in expansion of macro 'pr_fmt'
>    43 |    pr_fmt(fmt),    \
> inode.c:792:3: note: in expansion of macro 'erofs_info'
>   792 |   erofs_info("add file %s/%s (nid %lu, type %d)",
> inode.c:792:37: note: format string is defined here
>   792 |   erofs_info("add file %s/%s (nid %lu, type %d)",

Thanks for your patch. This patch looks good to me, applied with
minor update (80 character per line) and adding a unique prefix to
the subject line.

I've been on vacation in Japan for about a week, could not be reply in time..

Thanks,
Gao Xiang

> ---
>  lib/compress.c | 4 ++--
>  lib/inode.c    | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/compress.c b/lib/compress.c
> index a977c87..cadf598 100644
> --- a/lib/compress.c
> +++ b/lib/compress.c
> @@ -457,8 +457,8 @@ int erofs_write_compressed_file(struct erofs_inode *inode)
>  	ret = erofs_bh_balloon(bh, blknr_to_addr(compressed_blocks));
>  	DBG_BUGON(ret);
>  
> -	erofs_info("compressed %s (%lu bytes) into %u blocks",
> -		   inode->i_srcpath, inode->i_size, compressed_blocks);
> +	erofs_info("compressed %s (%llu bytes) into %u blocks",
> +		   inode->i_srcpath, (unsigned long long)inode->i_size, compressed_blocks);
>  
>  	/*
>  	 * TODO: need to move erofs_bdrop to erofs_write_tail_end
> diff --git a/lib/inode.c b/lib/inode.c
> index 141a300..db9ad99 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -789,8 +789,8 @@ fail:
>  
>  		d->type = erofs_type_by_mode[d->inode->i_mode >> S_SHIFT];
>  		erofs_d_invalidate(d);
> -		erofs_info("add file %s/%s (nid %lu, type %d)",
> -			   dir->i_srcpath, d->name, d->nid, d->type);
> +		erofs_info("add file %s/%s (nid %llu, type %d)",
> +			   dir->i_srcpath, d->name, (unsigned long long)d->nid, d->type);
>  	}
>  	erofs_write_dir_file(dir);
>  	erofs_write_tail_end(dir);
> -- 
> 2.23.0
> 
