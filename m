Return-Path: <linux-erofs+bounces-4482-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529FDC79F8C
	for <linux-erofs@archiver.kernel.org>; Sun,  6 Sep 2026 18:06:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdJ6m6dYJz2y2S;
	Mon, 07 Sep 2026 04:06:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::1029" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788717984;
	cv=pass; b=o2rrjX/MF4mTMl2BiVr+U3IB/GS4ROctP6HAet+rOf2kI75S3Ow74ElTUBw3TqGYUbX2i8CH2PQT8D1n+oO2RvCziM98OAI8HR9hRyMFLfJkdUPZgBzZiCnNpXsGf8l6DQj8ilmX7uklfW36qJWGZSuSTEKvNEwPbXko/DpkhjQpdlGDIeWMFTQGL2GyAtqfShPLT4S3NSg5z6Bs8HO2c+my5U0XH/ZdYrjHODGo/FmpWDOiHxx23QFenBWuXsKtICk1duCEcyP5XVfGtgXHr+KPdaO95CLQlgD5YsJWyHu6GgksMusz7JO5L1MPL8edW03I/xkQoJaWNUD46D6vsg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788717984; c=relaxed/relaxed;
	bh=gWulUfgeId9qrCMdd5oBv0M7YdFc/1Rp/05i9Kepj4U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=M7KRQx5dvVa/wiyn0jveGXOf2gNB8PYoL+odeZHdTELgPO25ZdYY6U5rIuMAHkv8b9+WFnxdjM4EGhIFHsgeE7L08boyh2e2gYh1ekK9+mfPwTCO3AOATtBNyd0JjAwDCstKpwIncODGoyPi/Xayq1rf6bnpm6TvWNE5vtU3iOx0LgRJiXUkb7AoX4holwipQAv0tEgxdSqnic8iVvrKn7Cs7jnPx99aZtv3GW8fNgzR2NrjGI0GmgNHdu9XIaZGuJ8DNc5Lrc7ki8HkzKmfn5K75oo5d1uYwnkpXK5t+Y+6zD0VYm07XFQMbikLJgW/9+6YpHYw9j5NOihWAtsY9Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AiBkUz8C; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=virtuowebinnovators@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AiBkUz8C;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=virtuowebinnovators@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdJ6k5G0tz2xmh
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 04:06:21 +1000 (AEST)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-38e58034d05so2188600a91.2
        for <linux-erofs@lists.ozlabs.org>; Sun, 06 Sep 2026 11:06:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788717979; cv=none;
        d=google.com; s=arc-20260327;
        b=MOA3hCNR9faP5xxrV5n9aWZuX1U4HB1QIO2hp2mvxQMCU+DeY5kbdoALlFjdBsuAmF
         AigC/+jE5B+3Dy9i2+47omSPOaDlKCe1kkWxhz3laa0wQ4FHLvP38MnVaO7lOQxyg5ki
         KQdlQDQ0707Nj773Da20eRHCh6KsspHJwL45oxTiii9NvaUwrqMqQrtO/QBztguqkwFF
         7Qij2Monl+Amixr3aV4nVeWfELkebu15QEzInWqpbbquWEk43l263CzFCmcM9xYFoRKm
         O7mF/g7/sQsyLP5o8h8S+6T7XxpBuUInawzOROFf1nOdqa0OSVHc66SrwhSqr0CBC1Ag
         NMjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:sender:mime-version:dkim-signature;
        bh=gWulUfgeId9qrCMdd5oBv0M7YdFc/1Rp/05i9Kepj4U=;
        fh=wOhGMmq2KH+KOElLlPuS8ws9o9ArjDb4wH58JVHh4Vg=;
        b=BYR5IrA96A6lT/Gi5i8q4xYbPatYVxVBJWKesyVhtodZBBDWiuL/5GS8Uvv4WOMwrG
         C9eOKuUnt3082X8Ugz+QgWb6CS3cjDdd/0UMgywy5Swvaea9EofkcOZ4uI1+PGL74L0D
         A1dF7dh5JqoDF4yPNhkx1y8uSuXSVPGEFp57Xb7vQ1/EjB6kZg4Ono5D/wIl5HjABt5z
         LktPPNKxOZItMyBoPJMOZY9F5ZHSZCZyjcY/AvA8nUwTwsMACa548/XyBfDFZ+/ywmb6
         URdoEVbTVMTnPoiapIRgL3GiFBW108Oe1OXfr94iUjSFghkCchiVN04HE+wVqbGu69bJ
         BxMQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788717979; x=1789322779; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:sender:mime-version
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gWulUfgeId9qrCMdd5oBv0M7YdFc/1Rp/05i9Kepj4U=;
        b=AiBkUz8C0gfGmF/dQKOfocC1mj/39oNX+15glH3DPUHoBn5LTFTXhWTpz21O8+jurM
         W5XKgG4tA/gn9c88ZgXWb5vj0/oJF2vpls5mIvmbUNMVbPltEKkqN6SJcK2DPiI76jqV
         vBDOSu4/BecoAamldmX3csUTlbKDHSdqvw8XcVbYBEFKxg3n0Hb31VPqgSPOGt6ulOGY
         CniS08ybg0rprRe4mBIFdL4UBM5fyMGNfWHXMInWHh9oJfxkzI2wAIMWVE5SLRk02S8U
         GY9OBh8aGFmg6yQlDyjaCtFWYykxBj/yDMMazTv+aTxf2YIgEYRiALg4pGens7ArJPU0
         o0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788717979; x=1789322779;
        h=content-type:to:subject:message-id:date:from:sender:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gWulUfgeId9qrCMdd5oBv0M7YdFc/1Rp/05i9Kepj4U=;
        b=HgvD/l84sLSjyk42XVIN6TWRKhCg4z0iwK7OQDwTqFVh2guy9H06irwEe/BCQjLofX
         4Lk3zqOuXgeTBKsVK36DSf5jPAPUcZx4T1ivntGbF3WNEvaHHpeG51iwAIIAqV60c5eM
         1FzLlwJ5HFThomovCnaWkvJTX4OIMRMbbK/4NemyDyD1wmtqsu2LsyWZUZMCuszDrstB
         QvLxv/Dv/3kNiXnfFQwGNQFVywyUTV+8P+fk+T5p3elyVUQ64oQ+rfMNKzzfQWHond82
         /Lbna/N/ZAcR2MdCybLcC1bOfp/zRrP/c2vVxM/UHlCrC/xOZbhL97SUfv4ruQzVkJ5z
         WFiw==
X-Gm-Message-State: AFuF++m8d6ZBvpTC5TMUQkQGS3r+tk0rLm4U/p1YCS3WDFySIiU+Vg74
	rnEX5tLcBjsAi/Zjn5GFHftvPSJCkGoFGJkrVYE2XJRqK5F2viVXaQzxyb7NswjJlCEQPTq43mY
	20Qz5E+UF/QnMYkebTheVdGPTUNlAB7wJx18+Dog2SA==
X-Gm-Gg: AYBFou0MiyOVF2mwABi8idbfJZrAOAtmbDMHd7NQPPCKBMnTlGAQjt+tjzHAi/Dy8jh
	QASWPzipBF6QYqZg1DiBExGFrwcA0Hu4kVHDp4abc1CZVXgtK0HNKePeCySTMwMxhuXGlyYkHfR
	QR8fGc9fUPv7xx3jkplBDFB+9PkcRtOT0hVPZNUAdmAp3lCr/A9OQmTP6+zi/dgmctxIp7J855o
	PvX94bJ9866utmbJYC3JuE+aLfVqh65kB5LLjbUxbeo01/FoI14ORm6UqeYR1L9xeXJsfUtKHsL
	9PPRKGFLSfRhXiqsu0yss0R1vzbWtmVEvNZWbu+Y0svuUGAOMdZeWkmKxbMnkxpstYrguF5FQ9D
	bwKRGn/mT6d5r2CY9YZ2wvZxGiy5Y3VA7AiKajP7tMfjA0/P7uu3EaaoZ0CkDzg==
X-Received: by 2002:a17:90b:3804:b0:366:3517:1aa2 with SMTP id
 98e67ed59e1d1-39b25f4397emr28377423a91.0.1788717979059; Sun, 06 Sep 2026
 11:06:19 -0700 (PDT)
Received: from 257406940090 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 6 Sep 2026 11:06:17 -0700
Received: from 257406940090 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 6 Sep 2026 11:06:17 -0700
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
Sender: virtuowebinnovators@gmail.com
From: virtuowebinnovators@gmail.com
Date: Sun, 6 Sep 2026 11:06:17 -0700
X-Google-Sender-Auth: WvbrLUdPXXW9W1er-uWuiUFMbAw
X-Gm-Features: AcwNN1Wbzsq7yTlclEd48ZvmuXKt4QANA0WEJkLBDT4HSl-4WXHUJGBxOdrKl-A
Message-ID: <CAP-DNBU9h2_9cSP0bJHmXFSiSfU2xyEq_L1tve9ckSmxTq3OEA@mail.gmail.com>
Subject: go-erofs deserves more eyes
To: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi erofs,

 Came across go-erofs today. Spent a few minutes in the repo nice work.

 Right now it's at 26 stars. I think the only thing missing is the
right people actually seeing it.

 I help people get their repos in front of real developers actual
stars, forks and users, not bots or bought numbers.

 Want me to send a couple of ideas for go-erofs?

 Cheers,
 Nexora

