Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B785C001DF
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Jul 2023 09:17:33 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GyQLyI1D;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4R9BJD4V9tz3bhr
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Jul 2023 19:17:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GyQLyI1D;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.dev (client-ip=2001:41d0:203:375::2a; helo=out-42.mta1.migadu.com; envelope-from=muchun.song@linux.dev; receiver=lists.ozlabs.org)
Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [IPv6:2001:41d0:203:375::2a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4R9BJ35Drsz2yFB
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Jul 2023 19:17:21 +1000 (AEST)
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690276634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LkxORCEddVXylYLMZWxeVj/rzxAJufQsQsoKMX9s7XM=;
	b=GyQLyI1D1TTXamIiZSPpttowrS97LQ+Cvba3kwh3HO3Mr0wmyVIbpLLBPb98H+kjVW5rA+
	/zd7C2ydW45ZzgH545IUXQ8vSPh6L3WEGSQz1gl3354IzH/cv4sDH5rzcHYAT/4O8ESTlb
	D32dfiCpfyNxorLxCJCQE9t24/FgOFc=
MIME-Version: 1.0
Subject: Re: [PATCH v2 04/47] kvm: mmu: dynamically allocate the x86-mmu
 shrinker
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230724094354.90817-5-zhengqi.arch@bytedance.com>
Date: Tue, 25 Jul 2023 17:16:24 +0800
Content-Transfer-Encoding: 7bit
Message-Id: <AA25C9A6-B2F4-44B4-AF31-B2A2C2A1F867@linux.dev>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-5-zhengqi.arch@bytedance.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, david@fromorbit.com, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, Linux Memory Management List <linux-mm@kvack.org>, dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org, x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, linux-arm-msm@vger.kernel.org, linux-nfs@vger.kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org, yujie.liu@intel.com, Vlastimil Babka <vbabka@suse.cz>, linux-raid@vger.kernel.org, Christian Brauner <brauner@kernel.org>, tytso@mit.edu, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foun
 dation.org>, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



> On Jul 24, 2023, at 17:43, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
> 
> Use new APIs to dynamically allocate the x86-mmu shrinker.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.

