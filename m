Return-Path: <SRS0=suzf=ZO=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19248C432C0
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Nov 2019 09:33:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6D1420718
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Nov 2019 09:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6D1420718
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47KB7g4qD8zDrMs
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Nov 2019 20:33:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.189; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47KB7T3QdGzDrHZ
 for <linux-erofs@lists.ozlabs.org>; Fri, 22 Nov 2019 20:33:22 +1100 (AEDT)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 0BBF05A8F2804053A12D;
 Fri, 22 Nov 2019 17:33:10 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 22 Nov 2019 17:33:09 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 22 Nov 2019 17:33:09 +0800
Date: Fri, 22 Nov 2019 17:35:30 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Haruue Icymoon <i@haruue.moe>
Subject: Re: [PATCH] erofs-utils: fix configure.ac
Message-ID: <20191122093529.GA106418@architecture4>
References: <20191122085859.GA2414688@usamimi.host.haruue.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191122085859.GA2414688@usamimi.host.haruue.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.140.130.215]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
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

Hi Haruue,

On Fri, Nov 22, 2019 at 04:58:59PM +0800, Haruue Icymoon wrote:
> ./configure will fail when --with-lz4-libdir is not set, since
> $with_lz4_libdir will be an empty string and generate an empty -L
> into LDFLAGS. This patch fixes it.
> 
> Signed-off-by: Haruue Icymoon <i@haruue.moe>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index f925358..870dfb9 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -174,7 +174,7 @@ if test "x$enable_lz4" = "xyes"; then
>  
>    if test "x${have_lz4h}" = "xyes" ; then
>      saved_LDFLAGS=${LDFLAGS}
> -    LDFLAGS="-L$with_lz4_libdir ${LDFLAGS}"
> +    test -z "${with_lz4_libdir}" || LDFLAGS="-L$with_lz4_libdir ${LDFLAGS}"
>      AC_CHECK_LIB(lz4, LZ4_compress_destSize, [
>        have_lz4="yes"
>        have_lz4hc="yes"
> -- 
> 2.24.0

Thanks for your patch. *thumb*

Applied to experimental branch now, and I will move it to dev branch
tomorrow since it's a useful trivial build fix for some debian builds
as well [1].

[1] https://buildd.debian.org/status/package.php?p=erofs-utils
    https://buildd.debian.org/status/fetch.php?pkg=erofs-utils&arch=hppa&ver=1.0-3&stamp=1573917897&raw=0

Thanks,
Gao Xiang

> 
> 
> -- 
> Haruue Icymoon
> GPG: E16D 3FA4 E636 A602 2684  0D38 A54A 7E9C 812E EB09
> https://haruue.moe/
> 
