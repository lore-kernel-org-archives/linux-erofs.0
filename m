Return-Path: <SRS0=/59c=7U=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16A5C433E0
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Jun 2020 14:59:27 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61748206A4
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Jun 2020 14:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HSNnNRuc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61748206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=163.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49g00F23sTzDqZn
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2020 00:59:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=163.com
 (client-ip=123.126.97.2; helo=mail-m972.mail.163.com;
 envelope-from=wylgf01@163.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256
 header.s=s110527 header.b=HSNnNRuc; dkim-atps=neutral
X-Greylist: delayed 241 seconds by postgrey-1.36 at bilbo;
 Mon, 08 Jun 2020 00:59:10 AEST
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49fzzy3tVvzDqVB
 for <linux-erofs@lists.ozlabs.org>; Mon,  8 Jun 2020 00:59:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
 s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=bAGhZ
 0bkqEizSlICvOzghxrCy7izcd61H6fsBIls+hI=; b=HSNnNRucrRnQZKRx5RFLF
 YlmSX52AIXIjIgIME3gdjjNOEKCr3spmGMukGDYV/fagtetuVBa3cSvCoun4od6z
 FTVOIWOhXTBpgOTgZ3TLhDDN48fb9DoWMNzuUK8JrQ90x9nV01gDTHzJX15GzR/k
 CKy2+wn3Q6B8iV9FSa1hn4=
Received: from [192.168.3.5] (unknown [223.167.142.197])
 by smtp2 (Coremail) with SMTP id GtxpCgCXl7u2AN1erukvDg--.25334S2;
 Sun, 07 Jun 2020 22:59:02 +0800 (CST)
Subject: Re: [PATCH v2] erofs-utils: support selinux file contexts
To: Gao Xiang <hsiangkao@redhat.com>, linux-erofs@lists.ozlabs.org
References: <20200530161127.16750-1-hsiangkao@redhat.com>
 <20200606081752.27848-1-hsiangkao@redhat.com>
From: Li Guifu <wylgf01@163.com>
Message-ID: <158c1e89-15c0-4a82-fafc-9091586e5c02@163.com>
Date: Sun, 7 Jun 2020 22:59:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200606081752.27848-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GtxpCgCXl7u2AN1erukvDg--.25334S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
 VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUVJ5rUUUUU
X-Originating-IP: [223.167.142.197]
X-CM-SenderInfo: pz1owwiqr6il2tof0z/1tbiLxY8y1UMTYJnowAAsc
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
Cc: Shung Wang <waterbird0806@gmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2020/6/6 16:17, Gao Xiang wrote:
> Add --file-contexts flag that allows passing a selinux
> file_context file to setup file selabels.
>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> It looks good
> Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
> Tested-by: Li Guifu <bluce.lee@aliyun.com>

