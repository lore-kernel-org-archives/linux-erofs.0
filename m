Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC435E77170
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Dec 2024 19:46:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y44dg5Kr2z30fg
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Dec 2024 06:46:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=116.67.46.92
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1733427990;
	cv=none; b=AIOY+Wx1EFlb4gRjvvPVpJQQtbvpYiIhr4lgKD734SXILXRbCByeWKMyKuFfYl3k9Zk473DLNbEAxrN//oraRRxutQ9to0cC57jmT63YDRLRHQMDa21cNZUuUSL+JbQ3F51EoMnrWzL4sB16vmZko3en07J4Nl1sEp3j744/9TR2I8FaQEvVwNSWpc5H7CGVjHpM5TyGAIWEAQm4GLXgNN+IAjHjhFkNEiv2Tk8ZlzVuWTwb5MRklW2NtbZx4Cw5Z79xY78lYUFx82tQylbPqwUyU2WhXcbRXFKkklV24bhFRvN87A3S9ztC2qBpLDhKCYyGRawTkAhc0AVYb3c3/A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1733427990; c=relaxed/relaxed;
	bh=/wxMPYA6T20AxEz9Uh22ZTVn/1aTGPtwLIV1VseQIek=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cwqW9dhtjbDCbDgHARNXUMSeMhYXv1ocRdZTvaS0iTryIFrxy/Pq55c9cVW91k3gyPBSjzssIqmO73BVAaw8Nwmoynl4qJkqomurHb1hc1oV8BYntVG4d/kuaSO00Qize8c7oyu/6Ew5QGRgxR3nQB7mRiQMi75sbtAs7FM0KQg8WIw0p6+pQjmZ0oY5XVSuDjo8cRloXp6P4bxdgOQkB4w4kuBTybafN8N9bHZ/NuHL/wHzYTJGFSY5pwu+qUov2m+KzZ2CkqVkvS+CxQstq3/pVq35ge4DhbyNrCpOx5N4TEOX0ephrHcjxSjkbuK29R/3n1Nbknxuzin3m6pLhg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=bizinfo.go.kr; spf=pass (client-ip=116.67.46.92; helo=bizinfo.go.kr; envelope-from=donations@bizinfo.go.kr; receiver=lists.ozlabs.org) smtp.mailfrom=bizinfo.go.kr
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=bizinfo.go.kr
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bizinfo.go.kr (client-ip=116.67.46.92; helo=bizinfo.go.kr; envelope-from=donations@bizinfo.go.kr; receiver=lists.ozlabs.org)
X-Greylist: delayed 6128 seconds by postgrey-1.37 at boromir; Fri, 06 Dec 2024 06:46:28 AEDT
Received: from bizinfo.go.kr (ems.bizinfo.go.kr [116.67.46.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y44dc65mgz30Sx
	for <linux-erofs@lists.ozlabs.org>; Fri,  6 Dec 2024 06:46:28 +1100 (AEDT)
Received: from bizinfo.go.kr ([67.205.153.114])
	by bizinfo.go.kr (8.14.4/8.14.4) with ESMTP id 4B5Jjo4i013190
	for <linux-erofs@lists.ozlabs.org>; Fri, 6 Dec 2024 04:45:52 +0900
From: Lee Shau-Kee<donations@bizinfo.go.kr>
To: linux-erofs@lists.ozlabs.org
Subject: Lee Shau-Kee Charity Donation
Date: 05 Dec 2024 11:45:48 -0800
Message-ID: <20241205114548.4E1BEC29715A5BFB@bizinfo.go.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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
Reply-To: lee@asb-risk.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Greetings linux-erofs@lists.ozlabs.org,

I am Lee Shau-kee, a prominent Hong Kong business tycoon,=20
investor, and philanthropist. I have allocated a donation of=20
4,000,000.00 USD for you. Please get in touch via email at (=20
lee@asb-risk.com ) for further information.

Sincerely,

Lee Shau-Kee
