Return-Path: <linux-erofs+bounces-2138-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1578C44500
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 09:07:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxZw94f8pz2ySb;
	Thu, 22 Jan 2026 20:07:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769072873;
	cv=none; b=EWMafeeO2rc68SuYD6jGeVycT8yaTeSwjAyRZ32pRHIp0qu/kEVJoHw9IoJU46zg9hrgAv+6mwPc9MkQOLyLEgeCjtcNy1sWZLSQDfvIjwzkw06qrmHfBJ2AwmWNiYKC58dJK6ZtBSSnJ4Ves0qVM8WJa6CjDmi4gQiH7T+RGgdMXC7lKtC64LQ5xQ8SExV0AmytZQ1hedqHGokwcLEMFS0ZLn68v90oG1AzB7pRR5NApP0qcij0O35vhZi0lPErG1V1eFhlKc1bTxhwuVy1vQjEhBI6OGzmw3tY2Qu+su4rln6cS7bQjEEIEWLvSeZYZBaAk8VBWC1kD5ExJ7JqbA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769072873; c=relaxed/relaxed;
	bh=Fpur9RUBX77lSzE4BdLsWPyWfZXh7Phz0M02aKxwcfM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R4fU4alIPUUX+9fju8lUqK4wDwWeXhZOOzEwAOqJSOiTGm8rjDv5tbdiHwdcozkB8qbxjc1DR2eRYQRD6ZpKTGSb6TI6GTOuwZaciDBjlOxjj+7m5j9WLbnx995833aOW/lUf7Zw8xJCJAyCUW6JYwZpvI6/5xchq0JeX105EorRoet6+LxNK9mKXCAI1pZ4dEaGvpPWLA4lE9wlREn4efAxFzJIAcH0XZThVqY+fHgJAXQyN+g/GSe5ywooakPS5tQtIHJa66/ZpmtV+uFLxPgfsAcEYPAx+PSOemUuJyJYCsH3AFnMQxM1aYFVlQsCShpg63N7xmyMXfnhqO9jhw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=SQvJ69hj; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=SQvJ69hj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxZw90rSBz2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 20:07:53 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A7BB443DB;
	Thu, 22 Jan 2026 09:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80747C19425;
	Thu, 22 Jan 2026 09:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769072871;
	bh=Xk9mTjukMKN9xTu1l+345rA1ZV93eqnTSwmjzFrzBzw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=SQvJ69hjTWJwpNjyma4X96M+fh/ctCYbNI37gvly5/Ghswcg0jLCBw25I2JGUal+E
	 B9VYaf4bkNC7jAKeG+19RUZZBGioCH32/s5ak71PE/73Kb9meElFwwvjQXfpo2SQeR
	 jFHKYZsZBsrCNshtrSxFNOB77AggnuzNwsSLQvY5BtaR1R7qGmbTwaegjLY4EArThC
	 aKC9z2Kx6x0NoDWOhcMZoCPB3/64bElxNdG2SgBGFX6ul4Gs/SQBGMUi88npwAbd9Q
	 uv347w5bXxsAsvnAMlLBZ1M0XQXxl9uwn9xZsTBs/hmPDmSvYRY40HrSbsV+HDjAlJ
	 /k6pZH25GohEA==
Message-ID: <22e7f25c-cfe2-4a56-a733-b3c65c62f7ff@kernel.org>
Date: Thu, 22 Jan 2026 17:07:54 +0800
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
Subject: Re: [PATCH 3/4] erofs: unexport erofs_getxattr()
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251229092949.2316075-1-hsiangkao@linux.alibaba.com>
 <20251229092949.2316075-3-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251229092949.2316075-3-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/29/2025 5:29 PM, Gao Xiang wrote:
> No external users other than those in xattr.c.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

