Return-Path: <linux-erofs+bounces-2137-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D79C44500
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 09:07:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxZvd6G0Mz2yFm;
	Thu, 22 Jan 2026 20:07:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769072845;
	cv=none; b=Lgm68eSCYXdl5CSsKt7i5sjLpVn4O9dyFkNyIu9TnotNZijubV2FSvoX4vAoQ7CNF9euq91cAEVNI+oLQobfsVaYH/K7JNhUCXzlneB5B0qMr8zsK/8qfUi6pp8d9323/IkkqD6sBE+rNES5mxxQTrwBpffNzFJmV9yDH7wHGAJ6P10sHcuXyzZgTAy51tgO+pO+7s094Q9UkBLdmgQv468TA9GLu40kI229b85LRi0IXzXsuE+keULGdBA4qqBTZz8Qu/iZTjgODoypsSuOrpZiDxL+SME0ClJVSTmKF+wcQCBknRi06zTc8zlJhAw3GDq+kSvppptzIOiR+yRSwg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769072845; c=relaxed/relaxed;
	bh=d65oHEvT3cHsAVahE1JJoTH2Gu65TGV5L7Fjbgywk7Q=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T2NCIpdR4EpEGY0E/4fCB8s6LQRi41ibEpDd0UTmzXpl7p8ERpRpGHmIrYFOlC9TmngKriLQzEkuPjyOfTj1ook96OXIjBrTC2hI30MnzYVHxSIl84w986NcBUaQjBkFwv4Ri5HDcqOxyJGpx95VWiHrEthDma6JpyEq3O39p7xg5Pn3xTz6iTSfSOE03RJws+TSXhWPPlChw0iILda8h+bourePbY5yF18kAdX4FEa0cSq8LRc5YqIsU0prwITPiXYRNfyyKDOTUbE4m8f1Rct5PlNG24I3r3v9ziTS7CgzAjo6R8RM2rfBYqPv2dVIWVmo6asJhZ8D1JDBXR57zQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=P4CvsgZv; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=P4CvsgZv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxZvd2VLtz2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 20:07:25 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A10E0401A5;
	Thu, 22 Jan 2026 09:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB7AC116C6;
	Thu, 22 Jan 2026 09:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769072843;
	bh=u3ok0sg5/nL6TiH6Pus4jQHK3tl7flif93KDA6HbCyA=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=P4CvsgZvpN8W4Rtyk1A+AcSJOG6wWSVw6Y5EBR1DNQ+Pkh8Ps1+l4BjZBRB0C/nck
	 CKJYIkcf2DsGq3AzgL229eoFHCIK8eYKNgF+xSBshC8B69Ga4Y/PhMpUB+gztg4jU9
	 J0LSIwuqh0sl7EHTJml710IDcfbnPr8WIJMXh4Rum54+QXhSwZ3KgT/ObvTithOrJ7
	 GF7gxtTxAioU+51dqc9hpx9sbz7A3YdCxux16K2Tw6kh/XpdYehBdZ1D9i3l0WixQh
	 LetqaKuq5qmbRUmIA7p6CQBt7FRiu8y+BPx9MM355hARN8AcAo/Pzc2aFCHsYsdgQN
	 ymzI8ZBw6uRmQ==
Message-ID: <1af5d4ed-7c3c-4330-90d4-a7a07c93d400@kernel.org>
Date: Thu, 22 Jan 2026 17:07:27 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] erofs: fix incorrect early exits in volume label
 handling
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251229092949.2316075-1-hsiangkao@linux.alibaba.com>
 <20251229092949.2316075-2-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251229092949.2316075-2-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/29/2025 5:29 PM, Gao Xiang wrote:
> Crafted EROFS images containing valid volume labels can trigger
> incorrect early returns, leading to folio reference leaks.
> 
> However, this does not cause system crashes or other severe issues.
> 

Will be better to add:

Cc: stable@kernel.org

> Fixes: 1cf12c717741 ("erofs: Add support for FS_IOC_GETFSLABEL")
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

