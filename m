Return-Path: <linux-erofs+bounces-4008-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E02C531C9
	for <linux-erofs@archiver.kernel.org>; Sun, 26 Jul 2026 17:02:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7ShL0GdPz2yFP;
	Mon, 27 Jul 2026 03:02:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785085345;
	cv=none; b=iXCEkZDUYvs0K7YfQ4Xd4aQaRxNT5aTXiRgByMjrDd2MkEIKlcRrZLEwTqnJqH7gMnPNHsG9G6ELi+OWCrVsWg7+CUZX69PK6PD3rj8tQAIQNMIQffV88mT0otBGCcjCqJdImO2GPxQ9b9sOPAyNvCC6vU0vTxfB0Li2HW4svxlFoebCayA4BDj2Sg72PovZVE554zuzYuO2E1zIUPYKYBYo+xL06BbNufa5uELm1GlicYOc3o+Hkguv+SyK2i3GcVL5LOs4+MxCYsU/Wl+cMdfpYYgj10O1Q8z+/XrOM0UGjfB5fTSxj60cMkfOF4X/Ipgv7delbdSHteTPTnGVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785085345; c=relaxed/relaxed;
	bh=JY71NELZGrRMciGefJklIu7l8Fqf/TLyTlJRMliEMYA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=m487NGLmrLUN/S7BASPIxE9XGVlpt9Vjm7XFC3oXHPARWJyOkGPuqnjuN07aa84Mxj/9gI5LMcWWZ40TzQCP1PDox5jD+ZeX8k+IPDU1qpHzidL276fyUQGOloi7awWiIqxOWR4IbwzDAGZFD8FZT6cvh4UnLziiDYSGWX8qQrlMdT/BHK6zOEClxChFpZKbxQrAxXJQX2mH3P6f22sbMzzXY/Zo8wY6CKHXUDOSYPKsrRkXA8gMYAQDElkdtA+7txWeyZrXV5uG5bLJuqmWupNOVpFXvB7i9OGUymONoEDZhuLP/SNeZe4VW6VRPUtMW+OJ7vTYbN8DbFg9mlEBYg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VB/ywLzL; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VB/ywLzL; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VB/ywLzL;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VB/ywLzL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7ShJ2lMSz2xyk
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 03:02:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785085337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JY71NELZGrRMciGefJklIu7l8Fqf/TLyTlJRMliEMYA=;
	b=VB/ywLzL+Jm+t0RjK8aXTbgvCb6fpedSMRN40QwFHBlT306VSzGsxEReTjOZtF3rQOWtUc
	8ILEBGVfqhovNc37y1zudhSX74e98mLuFAUGxRK2Iv25AfVAAJ9ky8q4Pd3wgM7C207OXR
	ZN21cRxrYKT7lAkb1fdJF08ROqtrMLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785085337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JY71NELZGrRMciGefJklIu7l8Fqf/TLyTlJRMliEMYA=;
	b=VB/ywLzL+Jm+t0RjK8aXTbgvCb6fpedSMRN40QwFHBlT306VSzGsxEReTjOZtF3rQOWtUc
	8ILEBGVfqhovNc37y1zudhSX74e98mLuFAUGxRK2Iv25AfVAAJ9ky8q4Pd3wgM7C207OXR
	ZN21cRxrYKT7lAkb1fdJF08ROqtrMLE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-1z0wFhV3PXy0qFNRA1VPzA-1; Sun,
 26 Jul 2026 13:02:12 -0400
X-MC-Unique: 1z0wFhV3PXy0qFNRA1VPzA-1
X-Mimecast-MFC-AGG-ID: 1z0wFhV3PXy0qFNRA1VPzA_1785085330
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20FA718011F0;
	Sun, 26 Jul 2026 17:02:10 +0000 (UTC)
Received: from localhost (unknown [10.44.32.68])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AF821955F7A;
	Sun, 26 Jul 2026 17:02:08 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  Christian Brauner
 <brauner@kernel.org>,  Miklos Szeredi <mszeredi@redhat.com>,
  linux-fsdevel@vger.kernel.org,  linux-unionfs@vger.kernel.org,
  linux-api@vger.kernel.org,  linux-erofs@lists.ozlabs.org,  Gao Xiang
 <hsiangkao@linux.alibaba.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
In-Reply-To: <CAOQ4uxhqmh47w46x0zhOzqJ54iiL0KDpuuAqr2oPyjm4AOgDYQ@mail.gmail.com>
	(Amir Goldstein's message of "Thu, 23 Jul 2026 11:20:51 +0200")
References: <20260715101107.973997-1-mszeredi@redhat.com>
	<20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
	<CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
	<CAOQ4uxhqmh47w46x0zhOzqJ54iiL0KDpuuAqr2oPyjm4AOgDYQ@mail.gmail.com>
Date: Sun, 26 Jul 2026 19:02:07 +0200
Message-ID: <87se55k7lc.fsf@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ELDl35V3Ofn1Iifc1Ji1D51eUX4y65BVZggTL1SnsAc_1785085330
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Amir Goldstein <amir73il@gmail.com> writes:

>> > And the smaller details really show how inelegant this model is and why
>> > Al and I have opposed it multiple times before. Scalar options are
>> > modeled as symlinks and non-path options are dangling links whose
>> > readlink still returns the value while for path options readlink returns
>> > the option string but following the link jumps somewhere else entirely.
>>
>> Hey, this is was a prototype to show that this can do what Giuseppe
>> needs.  Not with nicely polished interfaces.
>>
>
> I want to do a sidebar regarding "what Giuseppe needs".
>
> As I wrote I am all for introspection of overlayfs layers, but I was never
> fully convinced that getting an open fd was the correct API.
>
> The starting point of the use case is a userspace daemon that wants
> to reuse mounted erofs images, which are used as lower layers.
>
> When considering a single daemon (e.g. composefs) this reuse
> would be better done completely in userspace without kernel involvement.
>
> The reason for a need for kernel UAPI for introspection of layers was
> to allow cross daemon optimizations, so that containerd could reuse
> erofs images mounted by composefs.
>
> This optimization works under the assumption that the image file
> or the image file hash is a unique identifier of the desired lower layer.
>
> But what if composefs mounted the image with idmapping or some other
> property?
>
> And how many container runtimes are there out there?
> Is it really worth the elaborate effort to provide introspection
> to this level?
>
> My intuition is that introspection should provide static information
> like uuid/fsid/fhandle rather than an open fd.
>
> I am willing to be convinced otherwise with the proper arguments.
>
> Thanks,
> Amir.

My end goal is to retrieve the EROFS mount itself that was used as an
overlay lower layer so that it can be reused across multiple overlay
mounts.
I'd like to do it without requiring a daemon to keep the file descriptor
open.  If the daemon crashes or is terminated for any reason, it can't
retrieve this information from the kernel anymore, and the daemon must
also worry about closing the file descriptor when it's no longer used by
any mount.  It seems like an unnecessary duplication of state given the
kernel already knowns about that.

How can the uuid/fsid/fhandle alone be used to solve this?  The overlay
mounts are private mounts that cannot be accessed anymore, even if you
know their handle.

In fact, before posting these patches I thought about extending
open_by_handle_at to work with mounts, in addition to namespaces and
pidfds.  Christian didn't agree with this idea and suggested the
introspection API for overlay.  IMO, this functionality would solve the
problem in a very elegant way, because we could store the handle for the
EROFS mount in a file and try to reuse it later.  On ESTALE, the mount
is recreated.  This would need only some locking, without the daemon
duplicating the kernel state.

Regards,
Giuseppe


