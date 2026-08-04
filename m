Return-Path: <linux-erofs+bounces-4103-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B41AAC55184
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 03:37:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDfPR6zBxz2yMl;
	Tue, 04 Aug 2026 13:37:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=37.120.164.117
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785814651;
	cv=none; b=nTudxzXsRUWCNygEWyRmyDD9/SoruAZL7Cc6tbCIDDcbKfNCs+QYDU5Eqm+8x+8kZfEXMN4fMbJxb1vjIsopv6rGDXL10WsWFo3Evr1/gD1AzMHMZOaSyv0LwCNYYLbgxu3oOf467mSEupBbrIH3ynTI6KAaTcNbqM1rtPUOkV6c39F7Ry3YdACVUiFUBwTnmd+f8u2N10O/H4VqNkGv6fSBl3Z5eb1SufCTjkHFqrz5y+Gvss7g8OsNcbTRiOoTmwgrcvroiNxcjqlJZk4BLXV/KVV9YT045IGRKkNpfcHhiHbW7aZq6NUM9cNkGZsk7Tqjlv061HpmuGKYamxYCw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785814651; c=relaxed/relaxed;
	bh=W6zTC5NecTMcPyAxOBeqmW7HrD1htu138IUAT4+u7b8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNB5GF/EVvtrYmqHptleDHEsg0590Kas07UeY3zX6EYZMHY7TZE2UHnK3Jrz6tZua+Rbfiw69q51lnP0RWUEHW81VbxYqHrSYlWrh3/eTTGBYqmhOxVarXvORUHZJ6i9Txty0nyQq7hRYp2AMkqXWw8+McoLW3i5klebYu+4qbGgpszcbMjZRhZEk88fn8Y7fvABbebrKgeY7YPndacunGHriciXG47jtVXn+n4Y9iA80KaiPsSuvbdnHQM/OJDojKkR19npDr7Lfu5l49Y8puykiRs54VC6uhjqhVMFT1SMqMnTlRIRFKq58Y+oDWSt0DXCjY3rkYLmwYiEuX9uLw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de; dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=k+y8e+oL; dkim-atps=neutral; spf=pass (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org) smtp.mailfrom=piware.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=k+y8e+oL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=piware.de (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org)
Received: from mail.piware.de (mail.piware.de [37.120.164.117])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDfPR1hKxz2xpn
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 13:37:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=piware.de; s=2025;
	t=1785814649; bh=lRRwGqrgd6gN3IF7U5O+jqAPUbVbzSUMaAEZ5gzREC8=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=k+y8e+oLAX7vEmD1PoM3xVfxNKlLjJ+S+6OLCiwTvKlsZ1qt47RaKCYanr3g6kbnD
	 oDdtqDfmcS/5NKqXrIog8BceOxWFeB8iFlv4UVMBKZzhn/lacwcevhG3e9pvaRCFsT
	 Of3rGbpAITSHnsc0+Trs47TJ1hBOdpRrSgDV9cdFW1FnXwJCtmE1Ib3XLHq/mgQs65
	 wCObEUP6vsD0jTmMkniFb2com49XlA/R7jxFDSMgHa1ucXAytfJIM8bMLo8XLe3Ztx
	 /g1mt+8sPF3Jm3w2qVrAuOUG8pzo4jWBXe7k6/OIOsSUnoNF05GU/ewjpJwtPMVPb5
	 Xm/05D0oqH/1w==
Received: from piware.de (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.piware.de (Postfix) with ESMTPS id 03A13FF876;
	Tue, 04 Aug 2026 05:37:28 +0200 (CEST)
Date: Tue, 4 Aug 2026 05:37:27 +0200
From: Martin Pitt <martin@piware.de>
To: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
Subject: Re: [PATCH] erofs-utils: mkfs: emit an inode's xattrs in a canonical
 order
Message-ID: <anFed0LskD8IGVtr@piware.de>
References: <ampZ6MVV1nN3YzQ_@piware.de>
 <am9FM_v9vAAzlR5H@XiangdeMacBook-Pro.local>
 <am9GZFlgLYn9HFci@XiangdeMacBook-Pro.local>
 <anCAMSZK9ow3eGQD@piware.de>
 <anEgzI65bTzw4mn9@XiangdeMacBook-Pro.local>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anEgzI65bTzw4mn9@XiangdeMacBook-Pro.local>

Hello Gao,

Gao Xiang [2026-08-04  7:14 +0800]:
> I think we need to add a formal xattr reproducible testcase to
> experimental-tests branch.  If you have time you could help add one
> to ensure the order; or I could also find time too.

Someone said "tests"! 😀

Sent: https://lore.kernel.org/linux-erofs/20260804033214.211267-1-martin@amutable.com/

Martin

