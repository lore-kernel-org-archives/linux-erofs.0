Return-Path: <linux-erofs+bounces-4425-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8930C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 16:42:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZpS60Z9rz2xlv;
	Thu, 03 Sep 2026 02:42:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::636" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788367366;
	cv=pass; b=j52ei1Rn9EiOjGm4uhItsPJRhy3i21FVkBKLAa4HhVDPO+QUP2W4ucXzZqDNCXeOucpg/252RtHfdR3JK2ANZO1uJPT9aVm9pBwbiRM0ZqOp/OOKBniI/IOQZB4ehqRXSQlVOHXhEMNp3jF4z/Sn+HcxUku3XAcJ5FK6LHIY5TgXHY5Bj+gsXiIv5hwurrfX5i4/kSENB952yt6B2sciBN1Ywa6dGx3ltC6e5Wqefrd78nzAp44bVPN2ENNsFgthfwP/RgJMORgjfKkY9hoZUSuax+N8KF3wTUn9Pwr7RxKnP/GnKP4P8qpjLU0BTVTwGzORZUNq7atiHorfcSqNew==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788367366; c=relaxed/relaxed;
	bh=8/VNXQ//i5lHtQt3Q0JD9VyLtuTXQRpHQiqYBPB+gok=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=UD1q/Dcz3eJgueODUkrV577180PnodlfzD3jJ6+9Sqidf5Ta7oojbhVsPi3fTAFPllUcQHfsF7lOJZssp1dN0LuCwWXlWeCdp/ImYjO1imwbEdyHPmeQaP3QqC/CgC3Gz4BpkWFXWCYdSyNSUvyFiom1tCPM7NQnU0ggMacBt4WuqeaXunYoUx8w4FTZ3QaQhZgtRmXBe09wJT5Q0UBbcsnbcr79lFCb3fffHOX0TfqAeEn8z66eO/g7rkyAuHYe+ItCM+EyDQ3EC4fd3BeoFj+lsLCEz933w5dy8FT+pmfVpJWOL2F6gg3XrLTOz4IooNvDYH+QzQ51Fy4/UftWCw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XhVjAPW0; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::636; helo=mail-ej1-x636.google.com; envelope-from=farhanmalik38361@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XhVjAPW0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::636; helo=mail-ej1-x636.google.com; envelope-from=farhanmalik38361@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZpS44JFsz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 02:42:44 +1000 (AEST)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-c15e592da74so155519966b.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 09:42:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788367361; cv=none;
        d=google.com; s=arc-20260327;
        b=qwqaPMNX08C7yviexpnSl3JIf4V6g5i0t172VfsGl8hVpg8QyBBn0BOcKb3TtiEiQn
         XDu2hWzsR3YwS8DCMA0+xgV7dsz/rl5Bodph5ufq0lQewBChWfsKaSBlp553g620P6fN
         wM2UfamsJEZpEE3IwmOwZZUZ4qWm2WF9BGz1R8VV/QiH0xy67KYq2qMHlZFtMedx2n6o
         dI2qOgQJenFwKRptkeOD37Nd0yzVo5s1Nqe5vMQ651mWGMvYcH3geZwECtx9ClKE3YCy
         gz4YQ7VSFA9YkQTWiPv1IW24IMConNzte5c8MVfyqrQ50RzRIf/1EPNCUTortN7MC2La
         CsqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:sender:mime-version:dkim-signature;
        bh=8/VNXQ//i5lHtQt3Q0JD9VyLtuTXQRpHQiqYBPB+gok=;
        fh=wOhGMmq2KH+KOElLlPuS8ws9o9ArjDb4wH58JVHh4Vg=;
        b=hymI+ZmvrbpUyfFDope/coV+4Dvy7Ybv77FOYqV6KgGPu8Yuf9fk/H6malQ0SZ+M91
         7jm1qgRZD8molEChcjc37a9HN8YM/+GZZb2sdrdDaEqPaeYM/iUJ5eFeilKuMgE6m67M
         EhGhzDnfyfoZTNXuPgzLU0t+CTXSZ+yy6aM07vExmLchLxMbzMZdAlVZuqC9z63JoWE3
         kM22Et/zbIQu8eQg5MRhjbE/caclTDVhhyVVeCKNb2rs2NOS9axqhzHaE3fg/qLMjenH
         uR/DjshC2hnCmn+Ijcsiplaw6e7dFJZi5VM35sy5u389RA1DJy8WAhqipEzEoqWQTr7G
         d5aA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788367361; x=1788972161; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:sender:mime-version
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8/VNXQ//i5lHtQt3Q0JD9VyLtuTXQRpHQiqYBPB+gok=;
        b=XhVjAPW0rWzNaxfOJoCzZWAA7bD8FYrpun88YkpqO4dPSbRppWa1v2rz5mRDx7HnsV
         KSKLTTE0/bpYNzkm/MLzF5Iz2MB2FPnT3FhlQcRHpxpte74gj99j1csSb6B2Cl3JndfS
         HKzsiq444IvyWQUSqNJQCSlaMzICr81iWcIlZQtr6RcmbuHcnLTAUOqhBWvI+qDvds6N
         6Rv/2Dxpl+08hk3amPWHHQcj16otDaXSQ6KJ97DOeMgykFDlz7x+4+4zKyQtTL72JF/e
         zW9ycgOgzedbkyanIp2NDmhvqCllKKmHxgkVZg/2zAYzpDXyZy/ikDmSSV5JqVsi2CEy
         De4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367361; x=1788972161;
        h=content-type:to:subject:message-id:date:from:sender:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8/VNXQ//i5lHtQt3Q0JD9VyLtuTXQRpHQiqYBPB+gok=;
        b=r8sGY34ipz+1Vo5TMvYdJHl5/5pvQw6ErFk3UsOcuWelA/Dgpg+a2Qws9fzWwZ+6CO
         YocqgkUwPdbdm4tUALirV6gN7PmyC0Zm7Ugpp8k3Yorij5y99hDRTIjAA++Egg9EdF+G
         6ZV2oOywVztwTykbr4lAfT+dpmWjxdqQI0zy3cz6RWNxYKOgEjbQjoiQdHY7DS6Sd5Wb
         C+WTLswxg8MiUtFYnA0P9Sc3ZGa6okXYZiR2xlr8cteLQVFVVlIhp+J5+6XpT+OG2deE
         kE8TULcAogCo/OeTSKwulpwNaU+GBlfNtoy2yf0wCdld1Ug4DBtJFFs41qMH43EPl2L/
         gSNg==
X-Gm-Message-State: AFuF++mNH2tTwBJ2NnrxV1mousZDoLl8o/bnIPOKusDhLK7lZVY/jP+t
	gQLzz8ApSjyiAl/11n+XpXiLg5EguPxURUkckTO65lYcujNnqXvEIHGZ3StT6HdvpoBABRkTGdB
	XExm8v+ch2vmx1E+jGul1N6tym+HGGhQRvXcp4YA=
X-Gm-Gg: AYBFou3HRAijEQSclwpCSM4Asyign3mX1p2u8nOvJBALwcqXdd0guyjsHYQekC5wG5c
	+KCplof5jZ1cuB50A6VvNpE52OVe8f2BmWfOI7tEAObh3SQ1COQ5VB1gj853cFq4XPNvEW8o3cV
	oPUT5fZV/lTCERlUkGL7sJhBop0WdXWLNeMjJ5bngkpKX+s3VgkiSrorOZGKJcIJI69Xqp8g5sd
	x9aSXn9x0SVCkzLsPUfzQZhPRLhwQ58QztRgj6JT/kSwF2Rh2ATvUJe2v1pB8U2Z3NWiZRPRM15
	hMsHhtqq8+IJmYt3hM2PQpN7fWtFRaIhMZzjRVYPEEoZiA==
X-Received: by 2002:a17:907:c817:b0:c12:6d25:2c7a with SMTP id
 a640c23a62f3a-c25d55fdd03mr402653766b.17.1788367360572; Wed, 02 Sep 2026
 09:42:40 -0700 (PDT)
Received: from 1012270809936 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 2 Sep 2026 12:42:39 -0400
Received: from 1012270809936 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 2 Sep 2026 12:42:39 -0400
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
Sender: farhanmalik38361@gmail.com
From: farhanmalik38361@gmail.com
Date: Wed, 2 Sep 2026 12:42:39 -0400
X-Google-Sender-Auth: DpwaZKoYmA4BJbFuCkP8Za5rfGs
X-Gm-Features: AcwNN1UR-e5_VE99FHgywWHg6nDG22VtwRVzV8VZHglaalluwMJ0fcPNb3pu9pg
Message-ID: <CAE6ZJR4Gxf82Qs0Y0y3FGBh8L8xFt0E=-eZgVrkq=k8hdGiL=Q@mail.gmail.com>
Subject: thoughts on growing erofs-image-spec?
To: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi erofs,

 I'll be honest, I stumbled on erofs-image-spec kind of by accident
and then ended up reading through the whole thing.

 With 4 stars so far, it's basically hidden which is a shame, because
the work's there.

 What I do is grow GitHub projects the honest way: real eyes, real
developers, no bots or fake stars.

 If you're curious, I can show you what a plan for erofs-image-spec looks like.

 Cheers,
 [Your name]

