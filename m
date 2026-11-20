Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D862606A325
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csiMIdOD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWNBP0l9Qz2xqJ;
	Sat, 21 Nov 2026 04:49:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795196957;
	cv=none; b=ZmA47OrRIFqGBVNoEPbpaFwpunowCaBl/N1TB0kqAja5Enkg1s8vEVgr103NSzFFtDLi+EZ+16hL7jV3tQghZk5gzZR6R5hI1BB5yudtifqpLQONSd0Q6ofCzfjw1HpP8pgHQTHgiOfcJR5V8gpu1XxuFfV52lX6Ts6q2BDxqwRczZexwKZnxLL2WfRR6m919b2gZIKafvHGAB2UDSswp57WhtLakzSot6ovEpsWjbOnUfNGmnpDp3TOt/LDACrf37pG5Q7gxeXuVstt+3ALmkQC8zBzDQN+i1Nlxr+l9zZgILTEY5WI8FJT99Pwq0XHgUNU0xG2+6Px4hq0H1rQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795196957; c=relaxed/relaxed;
	bh=+zYovALtkcHPl59gCzX5V7GWLuEm62g0nvKcmVyct1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIG8nMj/ASZN/TFnycRR4CGQDedxHjbf6TQCdYm1klee2JmIIAGwFx1oHBCQHpIJzB7SP8zD7Q5ZNfHqwo/7XV0MLzDlK8zld2+xLxFeO0gYoEF/dqcbOK6ClQB6BoToqrI9hzETbYrMCRcHSSnqpc0oUKQHrKHMRB0HljSBel94XHnHt9h/coQJAqyUBsvyDboYcZXgwJhEY8SmIATvSftXfKG/oCDyO7q6zgB74W57uwXB3LZCuNfEd0yZpX7FIMqmQP0WPlNmi02FENW0/EOdEDsC8Em5YCPc1s/5WaiazgMA6Z81MVLAxWLTebejdnH8mSOvUrrY8TLbS9Wo0A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csiMIdOD; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csiMIdOD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWNBN2QCXz2xpt
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Nov 2026 04:49:16 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74FD1446F2;
	Fri, 20 Nov 2026 17:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BCD1F000D1;
	Fri, 20 Nov 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795196952;
	bh=+zYovALtkcHPl59gCzX5V7GWLuEm62g0nvKcmVyct1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=csiMIdODBm2pIDuSwd75co35GN0fA1GSj/myokYyx8Yn/BCJOJdAw8SM674xNgffp
	 2aXr/FJHVTANstwKgZZ5V/uzpjO/TkEJKLx4dYYui43b3KJkaF911PA+ju+/thhlyu
	 F6LAh7WBrY5lDnBjsHT59LrBetngPqexvqJ3BzigCP7vhEWAovhMuaAnC2j6XO3oAN
	 y/X5uwxOaWSahlA1HMwVj6I+1UWURHr+9aPmtZjbXRRepcDq4XM7toUXIcAOjHd3rM
	 bEndgoIOMO0xylKyVyM8QT13G7Lill/LE/Tz3xKZZKJ73HXis+SNHz/+EzrEb0w9yP
	 6Fj1FkH6QS5OQ==
Date: Fri, 20 Nov 2026 18:49:06 +0100
From: Gao Xiang <xiang@kernel.org>
To: Friendy Su <friendy.su@sony.com>
Cc: xiang@kernel.org, chao@kernel.org, jack@suse.cz, amir73il@gmail.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: Re: [PATCH v3] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Message-ID: <awCIEqmgv8Z6xw_0@MacBookPro.fritz.box>
Mail-Followup-To: Friendy Su <friendy.su@sony.com>, xiang@kernel.org,
	chao@kernel.org, jack@suse.cz, amir73il@gmail.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
References: <20261120031909.1757230-1-friendy.su@sony.com>
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
In-Reply-To: <20261120031909.1757230-1-friendy.su@sony.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:19:09AM +0800, Friendy Su wrote:
> Set SB_I_ALLOW_HSM to enable fanotify FAN_PRE_ACCESS events for
> bdev-backed mounts. File-backed mounts are not supported.
> 
> This allows EROFS to handle cases where file data is not available
> locally at mount time and needs to be fetched on demand by a
> FAN_PRE_ACCESS event handler.
> 
> For example, an EROFS image can use blob mode with metadata stored
> on /dev/pmem0 and file data on /dev/pmem1, where the latter initially
> contains dummy data.
> 
> The filesystem can be mounted with:
> 
>     mount -o dax,device=/dev/pmem1 /dev/pmem0 /mnt/erofs
> 
> On receiving a FAN_PRE_ACCESS event, the handler fetches the actual
> file data from a remote source and fills the corresponding blocks
> on /dev/pmem1 before access proceeds.
> 
> Signed-off-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

