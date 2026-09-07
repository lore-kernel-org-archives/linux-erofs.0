Return-Path: <linux-erofs+bounces-4490-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A572CC79F99
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 14:16:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdpzZ0FRlz2yvX;
	Tue, 08 Sep 2026 00:16:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788790617;
	cv=none; b=P8PhImErlh0yLxG3futfydZxbwLa3ZQ2iAij5QojogPaqIsuSScfuzWTE5F2RJJ8O3HzVpNX745JybG83POqAgV9OaqH2MF57PLtyymYhi3bucD3tjCBQrh1BcUDmMy/TJtNROOCb3br+XQ+tppDqDvA7wFkJpfRgx5HSLi5QlKI5v7mXBgnk6RcREL+E5MJokwQ+DeL9iuDUvlh3T0ZqpbukFEaIYq0p1qUXKr2naXlzEr8fiTxHNojnb/0h+frCETK+3sTCQ+Yc/MW1JeH9k0MFKjQ8eRvK0o+6UQpLQJmqz9orhvpG2GaNxB7LF6ymd8Y6tNn41PxsTGtV7jEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788790617; c=relaxed/relaxed;
	bh=GXK7Ex6Uu1GIDFnOcOi0478HbmUyFunCeP/pjUQ9paw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJJp8Q8stCIXTXV5NEtgFCnmNfaAUcj8Kkpn47TrFfrApl5wqdUDx9QIAPUMP2N7Zbu9PM2V8daRhnq8a6B8yoSaY8ZXLBtsazuCSCz8nmRo2Hr/14E4E+GGI5IBYuEw5Y6GmU7JE7pCsmizaza8VQV78WpsmGuRjTL3AqhFLvO6hXCnbldw7KkxzO4eT0INW1cpJbtYjTw1fe/13kYGc1R2rNZGcHmIKF54l5vjY6e1WGDsYhLH+ZiZt/C0giBLe/noH5QJs907BRsYmTbvRX3KlFQt1eIl9nVS3a7u7bOnQ5cr0iwAxCwrKjE6pRkJQUQUeKR9P6qKduqq+/c4Ww==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K++hJa0r; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K++hJa0r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdpzY1Pcgz2y8f
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 00:16:57 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F62941FF2;
	Mon,  7 Sep 2026 14:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1761F00A3A;
	Mon,  7 Sep 2026 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788790614;
	bh=GXK7Ex6Uu1GIDFnOcOi0478HbmUyFunCeP/pjUQ9paw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K++hJa0r7ahjsxL4OyG0kzL/JCPyeWWfLGYLY/zVSrira+vtZnwMVsDrC5IGk5GHe
	 M6bRP2DCC9P41ePqnr340GEz2faHMX1S5zxqjTrTBjQTAsv1M5or+JcShNxm6tbmvv
	 Z8WZ1SXfQvvZcvgUlB6S3UfLUn46kQYIp05FIpcNAPcFJ3iFkluK1AFTFeQ9+UgBS0
	 +OrwQUGLWrQQQg2537qvmlDbgnLdtElRipxztkPI/q2cEhBra1Jxh7tSXvsm90vzR0
	 fuPtrxuweX2/tVR0P6jAKbrQmR5g7/GJVim2Eck71l6fli5dGDW+u7Xg5JuIl3349W
	 gVzRnFf5cj8BA==
Date: Mon, 7 Sep 2026 22:16:46 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <yifan.yfzhao@foxmail.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 2/2] erofs-utils: lib: fix direct S3 writes to blob
 devices
Message-ID: <ap7HTja0xidxmBX7@XiangdeMacBook-Pro.local>
Mail-Followup-To: Yifan Zhao <yifan.yfzhao@foxmail.com>,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260907083027.13793-1-xiang@kernel.org>
 <20260907083027.13793-2-xiang@kernel.org>
 <tencent_B0673C3FB942146BB5B3CD80ADEE2CDBD20A@qq.com>
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
In-Reply-To: <tencent_B0673C3FB942146BB5B3CD80ADEE2CDBD20A@qq.com>

Hi Yifan,

On Mon, Sep 07, 2026 at 07:04:18PM +0800, Yifan Zhao wrote:
> missing #include "liberofs_cache.h" in s3.c
> 
> remotes/s3.c: In function 's3erofs_remote_getobject':
> remotes/s3.c:1068:54: error: invalid use of undefined type 'struct
> erofs_bufmgr'
>  1068 |                         sbi->devs[device_id - 1].bmgr->vf :
> &sbi->bdev;
> 

I've fixed it up, could you check again?

Thanks,
Gao Xiang

> 
> Thanks,
> 
> Yifan

