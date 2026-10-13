Return-Path: <linux-erofs+bounces-4719-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20EACA9EDE
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:36:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3g4N7170z30Wd;
	Tue, 13 Oct 2026 14:36:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::535" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862612;
	cv=pass; b=AHRf7zWX93zQn3ka6Ivtn0/v3f5JW9q/bOWm9ZOgmRPfoYQbllQF3SrbYSvm/QLSahPmThDrDTveJU6OZSm2KcxW86qvOhEZI8D1wxAKJuAibglYCZNX9eW38FI4efy2X1F5Y2G+4mFE7oiovHSjIPM5NsKGx9M7NlacxW0Uy2SWBBQjKpcowgHISZbtdJk+Jz+KGEnY704LLloeKiBk1wpHXvUpOGk9YY4WOkttbFYf8WSf7XzcIdl4we47g8Pq0hUR25KYCaqnQyh5Bp2gk3kDmEKUKBxPfYvnDKa3StQkgO6gtGUl0sP0mIaEifMbBrEY6TOke37Bp2FpJVr9kw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862612; c=relaxed/relaxed;
	bh=1xpLvTCzrNbbOwmhy6TbM/Ml0nd/P1fw8V3L+CVs8pI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kbFXIZx7KgqrmpP1WY4sHO3ivBMHntVNt3G6PVkxVG4TyAZbodYkVPzMi/yvW/l+ELksbiAHpDisd3SCxcRO7MV1snDvAvO7FMs3rjtWnLdHfjsBwc2HLIpIq96//SARes7zf0sKeA67ouwCkzeMnwMZmxPRrRC/LOADNjHfN41roEdK2xSl5Kv+NlKL2+HY2OZpxnqaYEt9yudbAMzdgXRsBN0D+iNvEbYLbIskS6SgCfz+8g+dA+8icOetfNekivd94eG0TKz5tUDgKe6AbD4LzIz8/pG14OOa9vjq8SlThPyidkYCxrNtcoSqj/VEpqQwQN59PmOdLfKMyhAlHA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=MadlWqgG; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::535; helo=mail-ed1-x535.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=MadlWqgG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::535; helo=mail-ed1-x535.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3g4M2LLtz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:36:49 +1100 (AEDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso1327312a12.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:36:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862606; cv=none;
        d=google.com; s=arc-20260327;
        b=j11n5LcO/JsV/UYpmzwppVvVmLjmRCo21UOK2p/zeSe9XirbZgXdQnJU4qp/2DP622
         1tFZ4qGs0Xe6I4AbZ3+pu3sVACGu8br3pG4Io3NA4psEtTnzECvSmfr/Z/olKdYbRja3
         p/fWtuMGAQF09L0rVx3juKTyZbrJA/b8EFYRR4QnOh74T/TqdQ6ivjaYCefO++5FnypH
         Aw4fyLrQvRYB2DxWS/3Mr47OAJRRAkR/5spQVPLhinaFl2KeE5WauzWx8rSxZOTNhRjo
         6JIwWbFBlESlzBiMR2svRhn8jvQaabxY9kBGMpj8QC19d15zJRrQdC0jPzH8TMsBK+Jt
         3VaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1xpLvTCzrNbbOwmhy6TbM/Ml0nd/P1fw8V3L+CVs8pI=;
        fh=9BK+uXTMUDkUNi0XEGDp/w85JrywJfeTawtdqJ1vqwQ=;
        b=KF6/jvlMj2oVkcrI+eMkZsE2fkJ5X1s+5W49fqgNr/tcQ9kdbypvvuVn2ay1CjsEc5
         G/+myx1ILyICbXEz+n4jTdBnBPIrxzh7+DItrnVqnmPRytZNfbdvefZlF0oDB04hI+Qp
         Wf6tzLgAIIhX1P6FJTwZ+M3Vm/BMXQkNE2RhxO9vqbCOmzB3tIGWorIZ/rook/ZljO+s
         S8btqMf5Icka3zLin7irtY3Iz3zgzHNd4gV2MzceUq/wUisyVkxTI7loPyLmsRguk5FF
         bBW1rlwWPoRSHhUwdNqAodQG3m336fTW2C1B8+wGtg34yDepuMU6gNQ6v0yVQMQ7u4iN
         3i7w==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862606; x=1792467406; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1xpLvTCzrNbbOwmhy6TbM/Ml0nd/P1fw8V3L+CVs8pI=;
        b=MadlWqgG1LXL2PqBbDByGixSTQmUztNHZRUXeK1169T53ItiXChkWxqRsuiVWTOe4D
         IYvuWJwPtxOEsSWx4ZHcIwn2V1ace0G54cc8+ZFwtJJHafEto2a2ZkCkKHK1xTKsDN2M
         y9FXBvrhKqEEEA/3o+rVlTKCgfV1Q5nV7SFRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862606; x=1792467406;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1xpLvTCzrNbbOwmhy6TbM/Ml0nd/P1fw8V3L+CVs8pI=;
        b=xVbUMWbZqrQawE9j8au+kUpsJZkLO2xcI6vW5YgiPzLgM6C8KoTAR6wv6sGLI0oJIh
         XH1uTnaY0dclV4yvl4sJDhLwnC7xqtpnek/Uh5ybyFdEl6XoX2AdpG/veBOomm/yHiua
         VX1SRmF3PjrGyPV85apRUfBYbkB2h28W0LkBpkTl9g8UBIQT6qRZ15LakXXh/XBgLGdf
         FdbPvXYHswIgxiCaTP/Eh4SYEmtHDAUNIpIAY00bsr4eQvR6lwLiniK/P294FhdcIOHV
         Wmnie4I9jVb+its8rCl0yK7kBfZoAPmMZg4BC849XGU1T5/Cdw0vJqZeUOmGh+gY3rIa
         bgNw==
X-Forwarded-Encrypted: i=1; AKwUvBz23JT/XWzVmezZQF+NbiV66T/guld7XCUKZO65vVRld+M/QuMND9h/3qCCEEAZ6aZxvlyCYX20NlFlIA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJqfmKHiLcA//oDT15p/1uQ7Ugz2Lye7JmFYwg7tvKJJzMLVdoi
	yF4dwj7VtBQOJe6ke9Sv1UF82yzSyfMPQMn/o7mwW7KlDOl26Df6yHsBHBlNUric6eM1UJFFlPK
	tK26lJpXhVMIyyC/kugdCua8vbPkR8jD8pTvUikJP
X-Gm-Gg: AYBFou3SBqZHo4SL8PqCJDukr9Mb3AjvMsdatCd6ItbMD/MmXU1UWGg+BVT1KF4pjd3
	kHUAAJvxeaTMq4ZWa9WlLK+s1BQKr3fKiI45DHCsyxWnw7hEELhRCJyp3enzpeMhCQxp0FHOvia
	BrA0bGqes/Cubow1bJoytqLrwo4TNvrRRqKUidigueKXkRF76BQujzI3RSU0/4CFxlERnJgT3db
	3HBP5GpngB/fWhSw32tF99pQyHTC9CawLRLRq3nP6Puc+EcwO5i5b1JYim3oksR5Mp6jFPmt9mE
	KcjPM5sfa6AC0nEqpyl/QAAxzGENWs5J9uDEMns33RNcroTJtbNgcLCy
X-Received: by 2002:a05:6402:501d:b0:6b1:e474:e0e2 with SMTP id
 4fb4d7f45d1cf-6b1e474eb97mr933337a12.43.1791862606489; Mon, 12 Oct 2026
 20:36:46 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-7-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-7-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:36:32 +0100
X-Gm-Features: AclHuK_8eWU6TosaTZ-HXyg6Ts2LDPmT8tFaG46D5wh9GKxkSAKgPt7kufI849M
Message-ID: <CAFLszTgC727cRd=0vu28r1_iKj+5+1ASBgRW5qA1BZTognE9Jg@mail.gmail.com>
Subject: Re: [PATCH 6/9] test: Probe RTC early in dm_test_host()
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Daniel Munic <v-dmunic@microsoft.com>, 
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>, 
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com, 
	Aristo Chen <aristo.chen@canonical.com>, u-boot@lists.u-boot-project.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi Heinrich,

On 2026-10-12T14:00:39, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
> test: Probe RTC early in dm_test_host()
>
> The ext4 driver probes and reads the RTC which allocates memory.
>
> Ensure that the device is already probed and read once in dm_test_hook()

Typo: this should be dm_test_host()

Also, patch 5 adds the RTC read to ext4fs_write(), so dm_test_host()
fails from patch 5 until this one. Please can you move this patch
before patch 5 so the series stays bisectable? It is harmless on its
own.

> diff --git a/test/dm/host.c b/test/dm/host.c
> @@ -26,6 +27,18 @@ static int dm_test_host(struct unit_test_state *uts)
> +     if (CONFIG_IS_ENABLED(DM_RTC)) {
> +             struct rtc_time tm;
> +
> +             uclass_first_device(UCLASS_RTC, &dev);
> +             if (dev)
> +                     dm_rtc_get(dev, &tm);
> +     }

This test runs with UTF_SCAN_FDT, so the sandbox RTC from test.dts
should always be there. I suggest asserting rather than ignoring
errors:

    ut_assertok(uclass_first_device_err(UCLASS_RTC, &dev));
    ut_assertok(dm_rtc_get(dev, &tm));

Then a missing RTC or failed read shows up here, rather than as a
confusing memory-delta failure later. My understanding is that the
allocation on first read comes from sandbox_rtc probing the I2C
emulator lazily. It would help to say so in the comment, since it is
not obvious why reading would allocate memory.

> to avoid false positives.
>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> test/dm/host.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

Regards,
Simon

