Return-Path: <SRS0=+o4z=HI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11407C433E0
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 15:29:36 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9ACA164E7D
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 15:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ACA164E7D
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DXx6M3Cl6zDwlf
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Feb 2021 02:29:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1612625371;
	bh=hgxIN1xz6WNtMS2XX6++ji+mL1lsSUdOLZCakEZ17hI=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=Cax4jpjgEdRW3Iu5/Ylgdiry+RjDY/TEO/ZiR/VAjrXXNF82iehmGo//IEGVH4ue7
	 EGIf7qIqcM+tiXLyBoTt9ql5eqqA2BUDZ0Lee1p0kkG61lhPhIfbe+smJmgygpKz9H
	 n9SQifHjWCIF5/sAuGBXcuHKUkv2OSaWi7ftyaLI+TGNt9UV714QJ6R2i8RBljD9qS
	 TiW/iJqyXra5spbF9M0FfOzlxEXguYk9E7aUIGDU8foK9H6PUZQFVAXfazzlx5fEC3
	 YsvkEZXVrO4GnSODxIGZZJMOP41c9VzJpztZ+vknAJZpo3AYJ+avEQVNfIGvaKErgr
	 dWbZfwMJDudcg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.16;
 helo=out30-16.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=YATxWL4Y; dkim-atps=neutral
Received: from out30-16.freemail.mail.aliyun.com
 (out30-16.freemail.mail.aliyun.com [115.124.30.16])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DXx633dHYzDwjP
 for <linux-erofs@lists.ozlabs.org>; Sun,  7 Feb 2021 02:29:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1612625330; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=QSmsTJ+Wv9wEcTFD7i0msaKTG7/aWn89btTxRmrHcOE=;
 b=YATxWL4Y0cNkYo730ez8wDsgCBLqlC277ZsxePKtVr5mY7Rp+BJTUK6CLQIO3BOAnMvQdvGox+00MM2yH3TYLRAosPSGi4QxSgK9KqiO1ngpvhsApC7RspdYoHhAVyhocXvd2tR075hpVPQz0inW2WiCAiMJAE5flmCEPVx0+DU=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1552433|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.0270403-0.000693898-0.972266;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04420; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UO0t.rd_1612625328; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UO0t.rd_1612625328) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 06 Feb 2021 23:28:48 +0800
Subject: Re: [PATCH v7 1/3] erofs-utils: get rid of `end' argument from
 erofs_mapbh()
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20210122171153.27404-1-hsiangkao@aol.com>
 <20210122171153.27404-2-hsiangkao@aol.com>
Message-ID: <0d6fadd3-29ca-2c05-559c-ae5d4e4d9eb4@aliyun.com>
Date: Sat, 6 Feb 2021 23:28:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122171153.27404-2-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2021/1/23 1:11, Gao Xiang via Linux-erofs wrote:
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> 
> `end` arguement is completely broken now. Also, it could
> be reintroduced later if needed.
> 
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
>  include/erofs/cache.h |  2 +-
>  lib/cache.c           |  6 ++----
>  lib/compress.c        |  2 +-
>  lib/inode.c           | 10 +++++-----
>  lib/xattr.c           |  2 +-
>  mkfs/main.c           |  2 +-
>  6 files changed, 11 insertions(+), 13 deletions(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

Thanks,
