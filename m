Return-Path: <linux-erofs+bounces-2188-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D6BD3EE89
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 16:38:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxmvV6XlVz2yFm;
	Fri, 23 Jan 2026 03:37:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769099878;
	cv=none; b=OwDcP7oATX/Y/APQpQl7ZrTWjGGvwZzVri6jyD8f0ksSgWkzatBhWLsrwCctfbnEFth7WCID4NQ5RrTPYnUUj4no5/R0IIIATX7XA7QIRILs8+ROxtzzatgVjlh1hiEgPN1C02zPTnq5GzX44ArHZvhk5rS2P/xqiTat7nMArbI8jdXl8rtL4RzzuOfboyqTr7jIr0HkxH2KoKZF0qUvI5Zgk4LaQGf2t+EleQlsLtfl6VaIS+H1MDijVVmtE+4TVkto+wdGOLThJSgCD6/41gEJf3dD0v4WM1tk79gtFgfRq2mMYvwp8juwG36+AqAlaj1rmVV9nXH8JiCMIbBMWA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769099878; c=relaxed/relaxed;
	bh=Lwld6vAnJB2NFeizg3t/vAsO9VfqN5FwLF5cCvhERHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EgA2PbjK0XTo7cJsQnANd2I6RU/M5zHw3S8vVthwXpMTLZrcnuaPqRuAie+NudsgOeYOk74UnlxpOHYc7UTnajxDLRv6OIN9P67Jy0VgrNYuKsIb8RDmHeF9GSWN0dGM3iBvTp6nEh7XP/zrbPJjaAMcYbY31wOgwcJ6YxtGejEEopv5Twdf7WCSh9R+tifLqdPhszJNWyw4K/S1HPs1auWih45/Lu5yGIo+XDl0uYhiT/fQts8jxsUB+EoD8pI82VwSu+TRr0EC02WkvGYtGQTOfZ5fY7XL2KCcwRd8BxOqD7MqPW9uNm0E8iXDcQp1wGml4etNXCR0OgkrvYQlaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qILSA5H8; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qILSA5H8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxmvT44mVz2xl0
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 03:37:56 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769099870; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Lwld6vAnJB2NFeizg3t/vAsO9VfqN5FwLF5cCvhERHo=;
	b=qILSA5H8zNAYVQ94dKL821X8jG6gwrWSPGW7nmiAdq7LjPVaL6/tqDWeXyeH1J24yVocMHPUThI2SSb6pLIQTKd4xJsSzbsNAEKoT9AVpz0uKvfCsdQoIpfmzcFcO8/yXG8GJbiLPTuIiDw3ELiIvpLj8qbqK3ExXh9x9R57bqI=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wxcwr5W_1769099868 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 00:37:49 +0800
Message-ID: <b8329bf7-6686-4a35-bc99-25befc350e4d@linux.alibaba.com>
Date: Fri, 23 Jan 2026 00:37:48 +0800
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
Subject: Re: [PATCH v17 07/10] erofs: pass inode to trace_erofs_read_folio
To: Hongbo Li <lihongbo22@huawei.com>
Cc: hch@lst.de, djwong@kernel.org, amir73il@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, chao@kernel.org
References: <20260122153406.660073-1-lihongbo22@huawei.com>
 <20260122153406.660073-8-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260122153406.660073-8-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/22 23:34, Hongbo Li wrote:
> The trace_erofs_read_folio accesses inode information through folio,
> but this method fails if the real inode is not associated with the
> folio(such as for the uncomping page cache sharing case). Therefore,

                 ^ in the upcoming

> we pass the real inode to it so that the inode information can be
> printed out in that case.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

