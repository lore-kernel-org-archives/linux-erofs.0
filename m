Return-Path: <linux-erofs+bounces-2185-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E553D3EE89
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 16:28:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxmhV0W9Tz2yFm;
	Fri, 23 Jan 2026 03:28:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769099306;
	cv=none; b=clFFbs0HdROFIt42upKq/BAeJhFTid3HwtODWbjUc0QWupVdSO252EhO/BZ7MhtYCaRyZORJ2JEnBr+ySOR/ZSDXv4bRgopw+FBH7pYN6mBIeQGCWTfXdEdjfLebxG3jf+lj5VZKAnuHSXcW5oKyxnTPQLnTOW1C6bBHW2WQQprItbJlJV8Jg3x8w9Wg4bKXyyIdRz3LPa7IKVCXLRWOmL8vjg6kbWzEVXPUmL7/UhS2rAj5mHmjabdVe1C7zW7KybNU8zex/+A4I5ze/1ACFnumTH+9r+yCotgAgoUixATTI1eBYzlSPk1BejpC3StR0Iv1mRVN3L6ERL7wwZC7Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769099306; c=relaxed/relaxed;
	bh=XWX8sKG8xrwbs9iqmEBS/RJQlvN79p8s5kBuqCBWZqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cl9jwFXgiEIjfgyMqLWZjgJ6Io+kmUOUN41br6w3u4hlPpNJ0K/3AKEfQhPv2d5VyAXHlOp0c0ehr3v8zBEG4RCos6rV9sx8MXLapoK3Y+EhK3OGNfOrQUlxjaqyZDXYsNtb+96cGshkbXoWhKsQ37Raa/7xojK5EZyR+gIG87ap4B58Yrur84IL87UTMc4KCt0USgDkx0iQzD172sr4KtbtuPRkhgC3PL4sAyg/O8x8RoIV3U+VlyC6/hwGjeH7MqeqDT6VqgtJd/z2cegRaVMWHk1aPQpSZzWKXKVXIZDIjzeTncPEXNJKtFxe6QhW5plO+DZWS1862tdRn/hRTw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NYbO4xy0; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NYbO4xy0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxmhR3tb6z2xl0
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 03:28:21 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769099295; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XWX8sKG8xrwbs9iqmEBS/RJQlvN79p8s5kBuqCBWZqo=;
	b=NYbO4xy0XeNZ4pSsuEYhVsGkdUS1R2UtSgCHLA0yGrm4iaor1NAxprcKJaSz38MkbFhIJRO/GLpAE7e8elGR3K/9OVZo22tIDclhJPEqlw9MSggqbUaUASt3My/aAhVoXxSHqh5Y7fR9kqOJG6Iaxvo20tD1X6Ct5t6vxhM/smM=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wxcw24g_1769099293 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 00:28:14 +0800
Message-ID: <98cb255a-86c7-48b2-a8de-e7bd9dcb72bb@linux.alibaba.com>
Date: Fri, 23 Jan 2026 00:28:13 +0800
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
Subject: Re: [PATCH v17 04/10] erofs: add erofs_inode_set_aops helper to set
 the aops
To: Hongbo Li <lihongbo22@huawei.com>
Cc: hch@lst.de, djwong@kernel.org, amir73il@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, chao@kernel.org,
 Christian Brauner <brauner@kernel.org>
References: <20260122153406.660073-1-lihongbo22@huawei.com>
 <20260122153406.660073-5-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260122153406.660073-5-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/22 23:34, Hongbo Li wrote:
> Add erofs_inode_set_aops helper to set the inode->i_mapping->a_ops
> to make it cleaner.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

