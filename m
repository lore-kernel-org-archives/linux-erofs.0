Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC55606A320
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 20:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FYd8m0c6
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVD6n2BCkz2xlY;
	Thu, 19 Nov 2026 07:42:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795034529;
	cv=none; b=HDn1FHUUIJnA2KEnGmmbWswW27B2rQwKTqdfHxecdUgjq04FGchyV3bxXl+7hmUsNugyDJV2y/QUxxZP6gbMwHCVyZS3ltpmZaeOKAEtUd41ZHXvJTzcePTbfVx0W65ab3rN6JYaUpnd+5zEU2QHWCdEZa4o9VPhO48X6tqKYG5Vlq+DfrcIXQzHvA+xBHU9xXDr3hbw5ecA2v66mNlwkijqz/3Wrz/kRgZaiBAYAcxHUwIRtO6PCIJWLqh+4TQiwygtlqRMUmKMeKPz4FlqZZIPRflqwL8M/l30+ZSuPJHbIEJm4VtqcrGdHGYF2Syb8ZVbBHPWN0f0IYTR02sCbA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795034529; c=relaxed/relaxed;
	bh=BVCmIbx2U7QcLbtqICzyMTWm+nYMD+0RXRKfme3Ti48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0xyeKpSM9WTpd0/MIlWE9JhQ5toBZ098FaKS7WdJwXLjavQmKNXfHiHvvxZ+JVrgpitaJnVL7L8nTrQDFTkJgHy9TiNLV84YQiz4sgWkgBsZgggWbK79ax2seKKJtTpzblKyciWprbEC/hN7V1syJ8xa5Z07fl88glX3OI6+z+v2beQG5/5p6HIiJ08lDi3F4ycNHjevFPJrzdCRMLRww0FU/oyyx2QVAJlspMJJY+eDxjI1/qYzEenZUboqZFxHEX0S66q45Su1xVlJN27aSirmD1I/1pGCWgZIX0VpQ2xxvzJfh3X0BXLj8FzMTLgt2yPhTclvQMj27zWAYRjrw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FYd8m0c6; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FYd8m0c6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVD6m2tMDz2xdX
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 07:42:08 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BDC44676E;
	Wed, 18 Nov 2026 20:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3461F000C5;
	Wed, 18 Nov 2026 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795034525;
	bh=BVCmIbx2U7QcLbtqICzyMTWm+nYMD+0RXRKfme3Ti48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FYd8m0c617Gdi3iZ5UtuYTyFIknEupMmaYC/tEN10FOMvQ0oDHcr3LmL4SuTaNWc+
	 KDs0sew3/tr0UMi2LddBJjsYJeePgLc6vg02OFszNPzDdGaJjqYVQC2mWISUZ+Svbn
	 t2GWuEnUaaTJA3AzD8cjiUziZ1jU+sLpmui9MbGkmV06E4NOYkAQeJkK7XZiVz5OFS
	 0j6MXfXLxe9tL5z6GCHfsJ17fsYDMcm51LQsvimpSdCNzzyfXTXeP19gSbBufsNPUk
	 4clMEnLxDmR/lG/7SqGQivvf0k5xmhizy4eNTct90F5vNQVBvBxr+AQinO2NSTTGp9
	 ovKT4pr7ydE5Q==
Date: Wed, 18 Nov 2026 21:41:58 +0100
From: Gao Xiang <xiang@kernel.org>
To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
Cc: "xiang@kernel.org" <xiang@kernel.org>,
	"bluce.lee@aliyun.com" <bluce.lee@aliyun.com>,
	"jnhuang95@gmail.com" <jnhuang95@gmail.com>,
	"hudsonzhu@tencent.com" <hudsonzhu@tencent.com>,
	"zhaoyifan28@huawei.com" <zhaoyifan28@huawei.com>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
	"Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>
Subject: Re: [PATCH v1] erofs-utils: tests: add test for fanotify
 FAN_PRE_ACCESS event
Message-ID: <av4Nllpo8_mERWXp@MacBookPro.fritz.box>
Mail-Followup-To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
	"xiang@kernel.org" <xiang@kernel.org>,
	"bluce.lee@aliyun.com" <bluce.lee@aliyun.com>,
	"jnhuang95@gmail.com" <jnhuang95@gmail.com>,
	"hudsonzhu@tencent.com" <hudsonzhu@tencent.com>,
	"zhaoyifan28@huawei.com" <zhaoyifan28@huawei.com>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
	"Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>
References: <20261030091713.101900-1-friendy.su@sony.com>
 <TY0PR04MB61915C09A76E5B2F432EE7A5FD6D2@TY0PR04MB6191.apcprd04.prod.outlook.com>
 <TYZPR04MB412848968AB5079D30B4D979FD7A2@TYZPR04MB4128.apcprd04.prod.outlook.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <TYZPR04MB412848968AB5079D30B4D979FD7A2@TYZPR04MB4128.apcprd04.prod.outlook.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Friendy,

On Wed, Nov 18, 2026 at 11:35:39AM +0000, Friendy.Su@sony.com wrote:
> Hi,
> 
> How about this patch ?

Thanks for the ping.

I don't forget this one, but let's wait until there is no more
urgent fixes for this cycle, so I can merge this feature then
for the next cycle.

Thanks,
Gao Xiang


