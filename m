Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C203CF11D0
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Oct 2024 11:37:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XPSR325qtz3bmC
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Oct 2024 22:37:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728560237;
	cv=none; b=oyWCqXlnOVJ+c10wMVfOnbW0ZQJUDOdK/aQqWBi6ozyk+kSv+9ZpHMlEboWa9zbgY7S/UIKHCDNQMJxSkEnntQb6LvJW8qJtKApY/Zl8Iu53DUI3ARolYKJ8clIAB97W8o8SkjlIWTLG8up1G1VrGfnehvCsnE1vQ4sPUk/iuO38QeFqCxci+oPNeYSGuzzfQvR+k5xPxAPmsGunLEYB4+n80bjbxa/fo/YeieZUnKLsr3JJxbnJrNEpNKMTgi9ku0bckXoAl9vEuPytzUaUSgB4+7gpNZnNt5tiuZS5ElS3CEQsDDdG3HBNTAjQV1eFsGdA3hjbsZe9zojhFCtLmg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728560237; c=relaxed/relaxed;
	bh=7muf9vDPJHKAd2mvKg8YJK84HnrdBqeO6Zqe4jEU3is=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=J6GEgVhkArHRAsluvjlebbaegCGdoPzoei4pUnqatJEb/U2VB3bcTN0aasVXIT/86lXE4r9S5iIXhrp6m0nYcDnAlyDxcHeee572UllVGIVD0REwl8CuiMGLAfoPFxZDqLPPQmspU56G2+Rtx9kJCiNzj/+Lm2cEnPR+Xu0V8/6Fla+nRsxJCorfZsgaunm3gjAlmrbj6XpmnEVn/BrmvIVgLwbQCk8mfYkEV+1AhnVT1b2b3DiZQpx0EtOkHhOS1zNDnYRJIU3GWuWXvyd88bJfdDJGqEQK5D7XuYT2xWUy3mlPNjWzo6iIqtVYwHsf+baZHnJ5WAaElo/TKp0kwA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jDyQxBfP; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jDyQxBfP; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jDyQxBfP;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jDyQxBfP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XPSQz545wz2xjh
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Oct 2024 22:37:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728560230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7muf9vDPJHKAd2mvKg8YJK84HnrdBqeO6Zqe4jEU3is=;
	b=jDyQxBfPZBP6YymKXP598F1AEdtQ5bnFKaUlAFe0sgxOlArx0EjP4uTaCT+8nPNwgnH6au
	AjMkTomUwjVywMErRzXXKieLqiYPFWoFildkZaUjd4HykkUlU9y4Occ6eNPT3aCf3yb5xn
	6MagestESWrVVDD7aYMaZsn4Aua/cmM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728560230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7muf9vDPJHKAd2mvKg8YJK84HnrdBqeO6Zqe4jEU3is=;
	b=jDyQxBfPZBP6YymKXP598F1AEdtQ5bnFKaUlAFe0sgxOlArx0EjP4uTaCT+8nPNwgnH6au
	AjMkTomUwjVywMErRzXXKieLqiYPFWoFildkZaUjd4HykkUlU9y4Occ6eNPT3aCf3yb5xn
	6MagestESWrVVDD7aYMaZsn4Aua/cmM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-zaMNslEuNF-beVOermW28w-1; Thu,
 10 Oct 2024 07:37:04 -0400
X-MC-Unique: zaMNslEuNF-beVOermW28w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 243EC1955EA5;
	Thu, 10 Oct 2024 11:37:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 34F1019560A3;
	Thu, 10 Oct 2024 11:36:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e94a52d9-ded4-4a22-90d5-18cb7665607b@huawei.com>
References: <e94a52d9-ded4-4a22-90d5-18cb7665607b@huawei.com> <20240821024301.1058918-2-wozizhi@huawei.com> <20240821024301.1058918-1-wozizhi@huawei.com> <302546.1728556499@warthog.procyon.org.uk>
To: Zizhi Wo <wozizhi@huawei.com>
Subject: Re: [PATCH 1/8] cachefiles: Fix incorrect block calculations in __cachefiles_prepare_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <304310.1728560215.1@warthog.procyon.org.uk>
Date: Thu, 10 Oct 2024 12:36:55 +0100
Message-ID: <304311.1728560215@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
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
Cc: yangerkun@huawei.com, jlayton@kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, hsiangkao@linux.alibaba.com, netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org, yukuai3@huawei.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Zizhi Wo <wozizhi@huawei.com> wrote:

> For scenarios such as nfs/cifs, the corresponding bsize is PAGE_SIZE aligned

cache->bsize is a property of the cache device, not the network filesystems
that might be making use of it (and it might be shared between multiple
volumes from multiple network filesystems, all of which could, in theory, have
different 'block sizes', inasmuch as network filesystems have block sizes).

David

