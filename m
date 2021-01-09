Return-Path: <SRS0=F98C=GM=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6E6C433E0
	for <linux-erofs@archiver.kernel.org>; Sat,  9 Jan 2021 21:06:45 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E72B723A9C
	for <linux-erofs@archiver.kernel.org>; Sat,  9 Jan 2021 21:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E72B723A9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DCswL2THXzDqSC
	for <linux-erofs@archiver.kernel.org>; Sun, 10 Jan 2021 08:06:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=f4hnUcFS; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DCswF0QgRzDqQq
 for <linux-erofs@lists.ozlabs.org>; Sun, 10 Jan 2021 08:06:37 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99CF7239D1;
 Sat,  9 Jan 2021 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610226394;
 bh=82DAPj85UpnL8li+cswzW/c+MUVI5rJnOFam+qbBAIg=;
 h=Date:From:To:Cc:Subject:From;
 b=f4hnUcFSHUhvN4EgrzUVwyFmIrOFYnDUvv4NwADYZwyjlgLpfNOiTHFxYKnMc2rXk
 VEwboKkoGg1YcB/tXz4i6hB53G+QIsm5+ddtwibHXrsd9vsJEEZdL7N1ayfEQsIyt4
 9DxkDpHhConrrtSsJbCHq4UOtMclKJwZYo0XaOm8JjfiCgWMecDGXnhmI7+YrXnJav
 66QmiiiHuV4Vmsn+5iplNtshgur4IWJmm5m7iwAXDBZ6bm6n3idu0x/LbCoJ5gGV5L
 W7CKRixdZVE30e4dGV/2h0x8mnv+dRUq5wNzNd9ztTum4TixB2yoncGOWt9jpmqJaH
 IxEp/ttycMEXA==
Date: Sun, 10 Jan 2021 05:06:07 +0800
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [ANNOUNCE] erofs-utils: release 1.2.1
Message-ID: <20210109210607.GA9532@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: nl6720 <nl6720@gmail.com>, David Michael <fedora.dm0@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 Miao Xie <miaoxie@huawei.com>, Yue Hu <zbestahu@gmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi folks,

A new version erofs-utils 1.2.1 is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git tags/v1.2.1

This is a quick release addressing recent reported issues since v1.2:
 - fix reported build issues due to different corner configurations;
 - (mkfs.erofs, AOSP) fix sub-directory prefix for canned fs_config.

Thanks,
Gao Xiang

