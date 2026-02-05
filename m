Return-Path: <linux-erofs+bounces-2261-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8ABE83F05
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Feb 2026 05:54:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f65yC0Dmpz2xrk;
	Thu, 05 Feb 2026 16:54:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770270850;
	cv=none; b=DQbj/is9HcxIkQrF4L5NzrcK3p0KDD7B5hS+1CYh5cN6I6N4jgPZtnHeWn+Pi4oV45he2DKiB6m4EjXPMmiBY6rUGGJSx7Y8XT/JsVC7+bGwY8hH4ppaYQCtz0qAAHBVT55l3jzZgPIaQubUY0dmPsEOolVxUuB6vP7dS7uXXPPPIWH7Eyg3eHkwctWqkkDTmsanZWTeYQ3XePPfCCp4pwKdozoPzkeADyLSHBKpi4OkQtKLtec2B1EF42eUSfDhCSD81R4NeY1sVs3gTlB3PUvITAOlhfcUtLlFJX7yXB6eaCOLuMUfNfcvXEQfCXuoduhWFhY5lbUjMIpE7bcyZA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770270850; c=relaxed/relaxed;
	bh=b86ovKP+ab8HMH2dN7Q6T3UeJOE29A7dljYvTF2CV5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UU1jWgvybPCHAGogiYxHeXiY6iUqSM57UV7LENR/pp0Zq/m6fzhXPLcGVaM8IFEM3h4zdrxfQSPgcKxuAXwwaLkihr3VIUeY9ZYDuYhuZT3t6aBBFr2VEeykkXIEU5EgvTgAUi+FLcVrPHVrmOtFkIUeDFzfOwCazn0sdy5W5Ty1wFAN2r2oqND0z4TONhISFtYzlbStnV8j4hlP9n3UZvbfb99Kt9NgAX6n4z0LeZa6CJYSSN2oF1NHieY9SDu2S9bhjd1sMMzx5duVhPWxi4nAQwbYcXi4f0UwR10SmgogXmbJOg6KbFDEs2a3ktSxbmmAS36qlhHDppTa/ZvoZg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ogf3Ds/X; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ogf3Ds/X;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f65y80tdVz2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Feb 2026 16:54:06 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770270840; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=b86ovKP+ab8HMH2dN7Q6T3UeJOE29A7dljYvTF2CV5s=;
	b=ogf3Ds/X7U1vrX/kPOjh0KzXsDuS1rOZOhJIAwhpyZcwE0riUEgJIO5qpj5ECP1SgrVsYcFaK3/z1riAKL5B1lR7HggODBuKHJNU2/pSglID83+YoGIstKTpkRHVIE2lPX3UTxiV3801PPikN7JpzfozRqEXYVWqTCDCT2HIOqI=
Received: from 30.221.130.135(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WyZngzr_1770270838 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Feb 2026 13:53:59 +0800
Message-ID: <f8f431a2-82a5-4f88-884e-71e0b0351328@linux.alibaba.com>
Date: Thu, 5 Feb 2026 13:53:58 +0800
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
Subject: Re: [syzbot] [erofs?] WARNING in erofs_iget (2)
To: syzbot <syzbot+c2dd47dc153320cc4692@syzkaller.appspotmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6983fff5.a00a0220.37c87e.0024.GAE@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <6983fff5.a00a0220.37c87e.0024.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/5 10:27, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+c2dd47dc153320cc4692@syzkaller.appspotmail.com
> Tested-by: syzbot+c2dd47dc153320cc4692@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         1ec50c08 erofs: update compression algorithm status
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test
> console output: https://syzkaller.appspot.com/x/log.txt?x=119f5a5a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2168d83cc33f9cb6
> dashboard link: https://syzkaller.appspot.com/bug?extid=c2dd47dc153320cc4692
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Note: no patches were applied.
> Note: testing is done by a robot and is best-effort only.

#syz invalid

The issue was valid but introduced by a new commit only
in linux-next:
erofs: use inode_set_cached_link()

PATCH v2 already fixes this issue.

