Return-Path: <linux-erofs+bounces-4108-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02424C55172
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 09:58:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDps63ZcBz2ygL;
	Tue, 04 Aug 2026 19:58:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785837514;
	cv=none; b=AEccBrn9Osp4H+w3UofuZrBi/f3e9ov/M4NUmXVMkcBYkX0rrkQhhAY1fCy22VlTr1+UGJYNxXp5KyG0xeQeaLVk2d/cHCgSqSZIRplS84+meUuQWGYdSaK7k0BzISg9zUm1vH2MeCKESE1c7xKDDrmQKGOCrfh8GxuygTLkrdD2JPRRF5nHcqJzz908BzTx2suCH53yEFy2zr7XmfzA5ZRB0RjFb8pa/JLfOpX3qwZ1J6cQyXcTBIwMlLn9BPcjKYBAR2hruDEMVySxUPVmpgyZnaHKmiLmFayd9meWYl080D9CmTWfazN4eaby4Dr11SVYh3lM9ctncoMSQknohg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785837514; c=relaxed/relaxed;
	bh=m4o4wsGMHFoMKmCRlxicN4et5cqaz0/Lf/N40da+z+M=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XoQbSVVt8u9NizwhTMre/BKeSMh84UGDr5qxIlH4aQH8hBsMwQHIoRekyp5j4IDuQ14s7by4ahDiXK4GPXnqo5N2LRi2PB4YzW8dPWeIePdk3ucG5ANDovPUQhQ5ZVINQE/cjdDVrVqlqhgPKnQN9VGVox87LEjDOuLYMAMFMF9EslZn9tTWwNAB4LuGFsfkQi7vN4zAUdieGO9r4sRWQ0jofBXDnvybrR5zELiXqBpekuYGLsp9oH+dEQ5Xiy8hL7WHZsLbJ8epxiLPxD9sYIatNcRUYJBytk9GSgYUtiXm0cYyNLoAYfssSEbSgMLHp4/MH31jXtdAe0A0Tf/s9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/ZhEZLF; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/ZhEZLF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDps54jfPz309w
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 19:58:33 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AFD960A71;
	Tue,  4 Aug 2026 09:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364691F000E9;
	Tue,  4 Aug 2026 09:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785837510;
	bh=m4o4wsGMHFoMKmCRlxicN4et5cqaz0/Lf/N40da+z+M=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=P/ZhEZLFa2dVHRLWGQ4jZGXc0BxBptMWk5T3Ny+7Fw1iJCFS4IejlDet/0X7ZTyG1
	 jyNi6XoRoi9cgv5QBkEJu0gjiSpegW40wR16klAsR31KUNVZypFI1oWqyCqZyT/6u6
	 A8kV/+F/r1oOSEdQIAANCVgg18HVlQ48uFcV/J1nO4GHhIdUmAwFgA2UFbRg6aR36y
	 1NURQhTOHiumq8NCCtTwsOnfW/oj+NLgRJxVc4dNkV71U8FycCsTYKNL4DrvjuDsKp
	 d3UE7VSAhklumIsiv+twqZ8QBh3PUzuSp712jM9ruXASYdW+NS406XXJVwgIVfoNc1
	 HIRUtKRPPVudA==
Message-ID: <1d44be0f-7e38-453a-85b2-56c29d9b73c6@kernel.org>
Date: Tue, 4 Aug 2026 17:58:27 +0800
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
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, xiang@kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org
References: <20260804055949.2927896-1-gscrivan@redhat.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260804055949.2927896-1-gscrivan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/4/26 13:58, Giuseppe Scrivano wrote:
> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Acked-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

