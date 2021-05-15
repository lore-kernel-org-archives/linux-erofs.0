Return-Path: <SRS0=EhQB=KK=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0E7C433B4
	for <linux-erofs@archiver.kernel.org>; Sat, 15 May 2021 16:29:04 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4CE7613D1
	for <linux-erofs@archiver.kernel.org>; Sat, 15 May 2021 16:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4CE7613D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Fj9np3x2gz2yxY
	for <linux-erofs@archiver.kernel.org>; Sun, 16 May 2021 02:29:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=BRNVqj10;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=BRNVqj10; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Fj9nk0GZbz2xfx
 for <linux-erofs@lists.ozlabs.org>; Sun, 16 May 2021 02:28:58 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C891613C1;
 Sat, 15 May 2021 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1621096135;
 bh=1aAjMb/PMKY8MpaIcSW7Q3Y+qQrQc14gOdA0O0yknbQ=;
 h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
 b=BRNVqj10Io1ifiqgZKM2mU7KS6b7lBEo/GMkbcqH9XcC52xsIlwMGt9m7WXKBumJg
 S16ufRzKaGaDfznPXCvwXMjHjkDteIVBi1YuYACqhilKVWYFNle5HjGi9Q7tGwycaf
 rX3elxqasOXua4Zecbu1xU6oH0X4qn9IJFCg464s1dy0Kuo6btoSTTwSwQVAEjqo4z
 n38oamFDnLNM3Iwc24GqCvHu2q4HErlPftQ+iT1+RnaHKFyDgGFtU5XQhqtTVHMBjc
 UiVHWsiNj/8ipK22oFUhr1U8Dg0uZXZcrYS8uO/zciM0YVYwNGZDjhJeYRN30IZ4yk
 /kj/Z3UDMZErw==
Subject: Re: [GIT PULL] erofs fixes for 5.13-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20210515020731.GA2382@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210515020731.GA2382@hsiangkao-HP-ZHAN-66-Pro-G1>
X-PR-Tracked-List-Id: Development of Linux EROFS file system
 <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <20210515020731.GA2382@hsiangkao-HP-ZHAN-66-Pro-G1>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
 tags/erofs-for-5.13-rc2-fixes
X-PR-Tracked-Commit-Id: 0852b6ca941ef3ff75076e85738877bd3271e1cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 41f035c0626521fb2fdd694803c3397dbaddc9f3
Message-Id: <162109613523.13678.12019869520982105265.pr-tracker-bot@kernel.org>
Date: Sat, 15 May 2021 16:28:55 +0000
To: Gao Xiang <xiang@kernel.org>
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
Cc: linux-erofs@lists.ozlabs.org, Miao Xie <miaoxie@huawei.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Sat, 15 May 2021 10:07:31 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.13-rc2-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/41f035c0626521fb2fdd694803c3397dbaddc9f3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
