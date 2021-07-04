Return-Path: <SRS0=O50f=L4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F93C07E95
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Jul 2021 16:37:21 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D803E61246
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Jul 2021 16:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D803E61246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mail.scut.edu.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GHvcG44g1z301K
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Jul 2021 02:37:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=fail (SPF fail - not authorized)
 smtp.mailfrom=mail.scut.edu.cn (client-ip=47.90.104.110;
 helo=aliyun-sdnproxy-3.icoremail.net; envelope-from=sehuww@mail.scut.edu.cn;
 receiver=<UNKNOWN>)
X-Greylist: delayed 717 seconds by postgrey-1.36 at boromir;
 Mon, 05 Jul 2021 02:37:10 AEST
Received: from aliyun-sdnproxy-3.icoremail.net (aliyun-cloud.icoremail.net
 [47.90.104.110])
 by lists.ozlabs.org (Postfix) with SMTP id 4GHvc62YRXz2yNg
 for <linux-erofs@lists.ozlabs.org>; Mon,  5 Jul 2021 02:37:07 +1000 (AEST)
Received: from smtpclient.apple (unknown [172.21.206.241])
 by front (Coremail) with SMTP id AWSowADnOk1L3+FgnFB7AQ--.18519S2;
 Mon, 05 Jul 2021 00:18:20 +0800 (CST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: =?utf-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] erofs: add "noinline_data" extended option
Date: Mon, 5 Jul 2021 00:18:38 +0800
Message-Id: <6B64A221-A140-4C6C-A60D-24EA99DABACC@mail.scut.edu.cn>
References: <20210704133327.32151-1-hsiangkao@linux.alibaba.com>
In-Reply-To: <20210704133327.32151-1-hsiangkao@linux.alibaba.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
X-Mailer: iPad Mail (18F72)
X-CM-TRANSID: AWSowADnOk1L3+FgnFB7AQ--.18519S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zry3CFW8uw4fXF1rury5XFb_yoW8AFW8pF
 WjkFy8CFs7tryUCF4xWF4qqFyY9as5Gr4jkayUuF18ZFnxJryqvr18trnIqrW8WrWkC3yY
 9F1S93WDCayUurJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyIb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
 0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
 A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
 jxv20xvEc7CjxVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4
 A2jsIEc7CjxVAFwI0_Jr0_Gr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
 w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
 vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2Iq
 xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
 106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
 xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
 xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWU
 JVW8JbIYCTnIWIevJa73UjIFyTuYvjxUc_-PUUUUU
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAMBlepTBRX4QAEsf
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Should the commit message starts with =E2=80=9Cerofs-utils:=E2=80=9D instead=
 of =E2=80=9Cerofs:=E2=80=9D?

> =E5=9C=A8 2021=E5=B9=B47=E6=9C=884=E6=97=A5=EF=BC=8C21:41=EF=BC=8CGao Xian=
g <hsiangkao@linux.alibaba.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> =EF=BB=BFIn order to add preliminary DAX feature support.
>=20
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> include/erofs/config.h | 1 +
> lib/inode.c            | 5 +++++
> mkfs/main.c            | 6 ++++++
> 3 files changed, 12 insertions(+)
>=20
> diff --git a/include/erofs/config.h b/include/erofs/config.h
> index 67e7a0fed24c..8124f3b36baf 100644
> --- a/include/erofs/config.h
> +++ b/include/erofs/config.h
> @@ -44,6 +44,7 @@ struct erofs_configure {
>    bool c_random_pclusterblks;
> #endif
>    char c_timeinherit;
> +    bool c_noinline_data;
>=20
> #ifdef HAVE_LIBSELINUX
>    struct selabel_handle *sehnd;
> diff --git a/lib/inode.c b/lib/inode.c
> index 97f0cf763baf..38906370f533 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -562,6 +562,11 @@ static int erofs_prepare_inode_buffer(struct erofs_in=
ode *inode)
>    if (is_inode_layout_compression(inode))
>        goto noinline;
>=20
> +    if (cfg.c_noinline_data && S_ISREG(inode->i_mode)) {
> +        inode->datalayout =3D EROFS_INODE_FLAT_PLAIN;
> +        goto noinline;
> +    }
> +
>    /*
>     * if the file size is block-aligned for uncompressed files,
>     * should use EROFS_INODE_FLAT_PLAIN data mapping mode.
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 28539da5ea5f..10fe14d7a722 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -161,6 +161,12 @@ static int parse_extended_opts(const char *opts)
>                return -EINVAL;
>            erofs_sb_clear_sb_chksum();
>        }
> +
> +        if (MATCH_EXTENTED_OPT("noinline_data", token, keylen)) {
> +            if (vallen)
> +                return -EINVAL;
> +            cfg.c_noinline_data =3D true;
> +        }
>    }
>    return 0;
> }
> --=20
> 2.24.4

