Return-Path: <linux-erofs+bounces-2498-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C664EFCE22
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Mar 2026 23:40:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fR8L12wPmz30FF;
	Thu, 05 Mar 2026 10:40:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772667625;
	cv=none; b=VXKkEI351GVe50rZYBwisUhTlm+Frmlw7COlOExk9IxUTdyjYPYwxNBL3TJ4MlQApBywwNBZoSwxtbWsBEVQjFcMnLE+Dbyh04mV81IPfnfsaxvTFzMhwhy5G16OrAEOX1l46NCRlnWAXvUj4cnhWcOx00yd0LbjSo+YB2CxN1EPMxI4H3WLz1GDMtJqfAk37UEC9VTJei9opyyWetSl8VO4Y7zYlUBvrTTbNxYhabaGVzuYelPKmJSfyKAvpjOT/IxE3hS5xYL4u1zNxKBwOcdMXDyvgmq1gS9CwvZ6NofsQbW59Rcgk095kxE2lKdv1k9CkcFb4KJr2G97ccN82g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772667625; c=relaxed/relaxed;
	bh=YbRq4Ni8LNRWBMlbQIwvZJiX3/hACkXSaHWn0BLWCiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PCIuZvXdS99gGSRy8uHGESR7DauxWE4zSaJNSoW7KbNbtyWY+9vX2SlfJ1/DnS0PRzyww4NhoR6gn+nu+ckMnh9kBU8JNNH+ZI20j/MtajMdcFU8pV4PgDWyZH3J25FYZ1JcWDxh/2D+PuWlZMplM1e3grhUHsrcCJz1KGaAtdVe+x2GP/1fercGf9Wc4jvNj9BuU8fJjcvs/fl6nGfhuax+ufRCA8haecJ0Yi3FtoRGibqFS29ScE1t1LsvmUYiTx+PVaqZFOkuYP+hqFuEuYjYpfuOZ0E7lbhEaS2HUyAhMIDMZJ/r0H8IcdDv60aqeIIhRnaZNjwWz5WNSTxduQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vfY7E+md; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vfY7E+md;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fR8Kz1hW5z2xR4
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 10:40:21 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772667616; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YbRq4Ni8LNRWBMlbQIwvZJiX3/hACkXSaHWn0BLWCiI=;
	b=vfY7E+mdtF/4B1ER2f1AGwa8jCsY4WPzmmmHDNGySFoNSg3q6U2QzDAgR4Vra4kKcrrQHVAOYXlqJLjKwws04JGS60GekmVWSvii3VPfxPX4K+Fna/0eNLHy7ZMs0rhww+LR0b1uqSSm/75rZ+NLP5ffJYiDjhDmsBz0mu/T/jQ=
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-GJJDY_1772667613 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Mar 2026 07:40:14 +0800
Message-ID: <b72aae71-fec9-4998-a5bd-ca5cc030b9a5@linux.alibaba.com>
Date: Thu, 5 Mar 2026 07:40:13 +0800
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
Subject: Re: [PATCH] tests: add basic smoke/integration test script
To: Aayushmaan Chakraborty <aayushmaan.chakraborty@gmail.com>,
 linux-erofs@lists.ozlabs.org
References: <CABCXVcmmXnEw6256sJsfGuG7eqLA0ytR-sJharrOHx+Yc2bLxA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CABCXVcmmXnEw6256sJsfGuG7eqLA0ytR-sJharrOHx+Yc2bLxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/5 02:13, Aayushmaan Chakraborty wrote:
> Hi Gao Xiang and linux-erofs team,
> 
> The repository currently lacks any automated smoke or integration tests.
No, automated integration tests are in another repo, we don't
need anything here:
https://github.com/erofs/erofsnightly

