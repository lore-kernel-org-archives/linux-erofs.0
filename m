Return-Path: <linux-erofs+bounces-4049-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D50C54FDF
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 09:45:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9kp46TmFz2yYd;
	Thu, 30 Jul 2026 19:45:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785404716;
	cv=none; b=XcM5kqoOVMhKyDZUb8dgpjwoOs3vGEjSzqJVzXgLZeWgtoEEr2kUDnhuPDWRpECVoIVs47kZkwTQoo1ZOB08HADfGu5HZ8heElzc7LOzh14XOGPAb39z9Veoh354wAdi6lR1VF6kKHp8nRPso03ITMAE0wDMYVGeY3i0C+CeBzG3XRXemit2Xk+T9kNgpBsZsmiwh7JZb93bOq9iJFsglZvxYg+FfAFTEwiw+i2YpFZQjAeJSjmlabWd88WjGTjcaNyI/zG9C2zNfcZRv4MAa9E32W2NSeEaEfMjEN39N1nBpNLriLp5VYva95tF3+ampK0Vs9dvOojBdKu+cifFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785404716; c=relaxed/relaxed;
	bh=0lfLA369TUu0P4YVdcb2+35w4wWIyfEzp88ExDkoXt8=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=CbND1MNnyTA2iNd95mNlrgS4RY6Dnd2Cp/p59a6nDQhyKMc7FzEA/FrF+RLnhRh/qo2NCvyJzf94oIJiWAenKbCDdlKCFGLwlQtOas6DVN2+OzGHkqYR8nPnH1PjP8vaPV8G04LoQ3r39MsCUVKBcLadbEYCnoWaNc5crnfW+egV1GDUlCF4WXzI4EKVhbyzPXSNBAQgBWKBnHA3TX33JrUqTu+NIhdsymAQhUtCEce1bGAjGSXJOXRtEAVHzg1yGsBsT6Qrds/pBvPLfjfT6rpNrKCSB7j6UeNB3pLXhQvnzr3RQjjusPyXNNdVL5TwHl7hbo2wKeIjGigv34DLLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dln0HoAD; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dln0HoAD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9kp36qyKz2yMn
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 19:45:15 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC82D600AB;
	Thu, 30 Jul 2026 09:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A6E1F000E9;
	Thu, 30 Jul 2026 09:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785404713;
	bh=0lfLA369TUu0P4YVdcb2+35w4wWIyfEzp88ExDkoXt8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dln0HoAD0MLxF+F/bLL0ALyx58jCYdu5BF9IkoewlwJtHcG3x99YjBhKx6cIiv8mj
	 IQJ67bGpL0rYg012BknHdLFDbKPkLY/cX5yHlXVPbf6s/pCnIRzeywOlKn031N3vI/
	 3X+uEmImP0VAX2UQo5Xqq4wPty2FVxOVqlD6QUFRnWkatVoFGkKLyqjdiAv+Iprm8O
	 F7WQsrI7y++manrUNDw+Gk7Q8zxwdY+jq4DBNjoMDd4fgIqzBC1pB78x1rlp7kMh0V
	 gxCpxECoz/H0nfY61en/mLP1BEnl4RCOtMe7xEB2693hQSIp+w4IjlXR/Jn8adZ2HM
	 D3lAt7sYV8zHw==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
From: Christian Brauner <brauner@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, cyphar@cyphar.com, 
 hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260728160619.853924-1-gscrivan@redhat.com>
References: <20260728160619.853924-1-gscrivan@redhat.com>
Date: Thu, 30 Jul 2026 11:45:08 +0200
Message-Id: <20260730-krisenfest-hunger-anspannung-acbe386967b0@brauner>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=386; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jlQoa5SFA5X6pn/MrSivvi449RxWG8OdfPmVva4MvNo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRly2oYX53jXrS06tDMiCdH3tqd3li17abe/BU9kVrTT
 0U5vIow7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIGSMjQ9/pn8tv+ZZM/5di
 el+3zmvjLuONzPbicYlSc0QuyHXNPcvI8OpP36dnP1J8Gx7w1DycnF5aKPB3b3P7bEWXebvEYpl
 3sQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Hi Giuseppe,

> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Acked-by: Christian Brauner (Amutable) <brauner@kernel.org>

-- 


