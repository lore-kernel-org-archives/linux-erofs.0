Return-Path: <linux-erofs+bounces-4057-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8B9C55167
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 13:49:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9rCw1Pm7z2xnp;
	Thu, 30 Jul 2026 23:49:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785419372;
	cv=none; b=Bh2UclNYaZOW2tVfmkDSi6refyVxyZfF0ltzGXPsU4k8HXRwciPUpjq+XgFLGUm6FJihiht6DcAwQ+ahPx06vWyQnwTSTlpStaIcEWA9jWIkVZ5pOVif8AH+Q0hLIfxfJkR9Nfp7oWBL68T24R/auz656+b18/uzQTo52X4LKOfdtwPXx6w2QaBjFtgUOZGCY1XyvTKvKGF2CxDulVVl/2I7dov2tCZhzom9rxEUgH3wNIBvrIT3E5UPpkAyKhCU233vY7xaprEBCdaMcC4ueza2/4rrBrPwICyBHZsCdP6NPr4UytfwKkhPB71i7+Npf1x+a+a5V1Io3jEJzmMnqA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785419372; c=relaxed/relaxed;
	bh=b4EqHffQZ+7yOTPccLs7D+jOVNUfFcke1CghDWdjZE8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ggQ4nigcp3+JNrRH+NTEk0Q8ltbSg1OyZIV5DxgZWdEkqaOip4VsxHGyA+ZDK8cUwe5kWB2OPibV3IYOVEASAnNOq6aI/+n4MCDTZLiuuMimVSsHlkDg6DgLzwZO63oQNvAcADc/9TwhYBqEngbfYHTNBTZYro+ftdGS5CY5DfbXvSp5wdM3qWLYFH7rhm5qmWNdeKdHF+jI1VN567i7iacPEpmZ/G2GzRlUeXReTe+BhmfmHY41f5QGUU8B+31Om9PFS/yMLqfGvAOgXkYCI22OtmJdq1fNv+AbAdoUk/aPaAHTPu4pxv9HdIYft0ZJHYjNIexfqwneulc2MY2Lng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FOxBGy4E; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FOxBGy4E; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FOxBGy4E;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FOxBGy4E;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9rCt66C7z2xd2
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 23:49:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785419365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4EqHffQZ+7yOTPccLs7D+jOVNUfFcke1CghDWdjZE8=;
	b=FOxBGy4EcHDQu26oGN27oL4I62V4K/XkyyAfN2aA2RfTQg8+54Dpoog1ebE54Bl/RlmLFm
	MjkrOh7HVmSnnlquedJxPIFh6apYnawD74WlqaIUkj4Fi8eaPx8zWHuILj95+y9zuXJZ0V
	XbJvpe1PfHBjGQP2KBaNO45yuaFi4sk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785419365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4EqHffQZ+7yOTPccLs7D+jOVNUfFcke1CghDWdjZE8=;
	b=FOxBGy4EcHDQu26oGN27oL4I62V4K/XkyyAfN2aA2RfTQg8+54Dpoog1ebE54Bl/RlmLFm
	MjkrOh7HVmSnnlquedJxPIFh6apYnawD74WlqaIUkj4Fi8eaPx8zWHuILj95+y9zuXJZ0V
	XbJvpe1PfHBjGQP2KBaNO45yuaFi4sk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-shRJlmpBPsm3LdaYnEvU1Q-1; Thu,
 30 Jul 2026 09:49:19 -0400
X-MC-Unique: shRJlmpBPsm3LdaYnEvU1Q-1
X-Mimecast-MFC-AGG-ID: shRJlmpBPsm3LdaYnEvU1Q_1785419357
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1561195608D;
	Thu, 30 Jul 2026 13:49:16 +0000 (UTC)
Received: from localhost (unknown [10.44.49.125])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 390E11956089;
	Thu, 30 Jul 2026 13:49:15 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-erofs@lists.ozlabs.org,  xiang@kernel.org,
  linux-fsdevel@vger.kernel.org,  amir73il@gmail.com
Subject: Re: [PATCH] erofs: reuse superblock for file-backed mounts
In-Reply-To: <amtJX8aTZT5d_sP3@pedro-suse.lan> (Pedro Falcato's message of
	"Thu, 30 Jul 2026 13:57:29 +0100")
References: <20260730124120.1501126-1-gscrivan@redhat.com>
	<amtJX8aTZT5d_sP3@pedro-suse.lan>
Date: Thu, 30 Jul 2026 15:49:14 +0200
Message-ID: <8733x0k2p1.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Q2rZfYhSX_4kOhtxRX713nYHnEjN6ldIPWyMuzCcB8c_1785419357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Pedro Falcato <pfalcato@suse.de> writes:

> On Thu, Jul 30, 2026 at 02:41:20PM +0200, Giuseppe Scrivano wrote:
>> When the same file is mounted multiple times (via path or fd), reuse
>> the existing superblock instead of creating a new one.  This allows
>> multiple mounts of the same image to share in-kernel data structures
>> more efficiently.
>> 
>> The backing file is identified by its inode and fsoffset.  If mount
>> options conflict, a separate superblock is created transparently as
>> a fallback.
>> 
>> Tested by mounting a 177M Fedora EROFS image 20 times with full
>> traversal:
>> 
>> ```
>> \#!/bin/sh
>> IMG=${1:-/root/fedora.erofs}
>> N=20
>> DIR=$(mktemp -d)
>> trap "umount $DIR/m* 2>/dev/null; rm -rf $DIR" EXIT
>> 
>> sync; echo 3 > /proc/sys/vm/drop_caches
>> INODES_BEFORE=$(grep erofs_inode /proc/slabinfo | awk '{print $2}')
>> MEM_BEFORE=$(grep ^Slab: /proc/meminfo | awk '{print $2}')
>> 
>> for i in $(seq 1 $N); do mkdir $DIR/m$i && mount -t erofs "$IMG"
>> $DIR/m$i && find $DIR/m$i > /dev/null; done
>> 
>> echo "Superblocks: $(grep $DIR /proc/self/mountinfo | awk '{print $3}' | sort -u | wc -l)"
>> echo "erofs_inode delta: +$(( $(grep erofs_inode /proc/slabinfo | awk '{print $2}') - INODES_BEFORE ))"
>> echo "Slab delta: +$(( $(grep ^Slab: /proc/meminfo | awk '{print $2}') - MEM_BEFORE )) kB"
>> ```
>> 
>> unpatched kernel:
>> 
>> Superblocks: 20
>> erofs_inode delta: +46368
>> Slab delta: +39952 kB
>> 0.08user 0.82system 0:00.98elapsed 93%CPU (0avgtext+0avgdata 4796maxresident)k
>> 19168inputs+10304outputs (24major+16672minor)pagefaults 0swaps
>> 
>> patched kernel:
>> 
>> Superblocks: 1
>> erofs_inode delta: +2044
>> Slab delta: +1088 kB
>> 0.07user 0.21system 0:00.31elapsed 91%CPU (0avgtext+0avgdata 4848maxresident)k
>> 19024inputs+6784outputs (25major+16810minor)pagefaults 0swaps
>> 
>> The time difference shows that sharing the superblock also benefits
>> the page cache and inode cache, as subsequent mounts of the same image
>> avoid re-reading the backing file.  This is particularly useful for
>> container hosts running multiple containers from the same base image.
>
> Doesn't this approach break-down as soon as you get to change SB flags (through
> e.g mount -o remount)? It will change superblock flags for all of them, right?
>
> (I don't think you can switch off the superblock transparently on a
> reconfigure?)

This is the same preexisting behavior for block device mounts.  That
said, I realize this can feel confusing since EROFS is not a block
device and allowed this so far.

One way to solve this could be an explicit mount option "share_sb" that
is opt-in and, once set, blocks any remount operations.  Would that
work?

Regards,
Giuseppe


