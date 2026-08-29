Return-Path: <linux-erofs+bounces-4367-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D56C61DBE
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Aug 2026 10:31:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXBPG31vRz2xlZ;
	Sat, 29 Aug 2026 20:31:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::32d" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787999474;
	cv=pass; b=BmU0Wtu+kYU9YJ7HcxG6lTjm8eZrGhCh2tmMf5mh/LD2FjSOd3RjBJ+8TtvbMi8ZxJ5IsUeN/guu18MQn6yKd+JZWn+cxUU4cWZ/mXr4vwtzysEFC4piWdfn4k9fXWyMRm2z4gQzRa4yGP9wjLrpLmPhbAiFuqWxOnyznR5VRNcY7YGlrjN3BcJmaX6eo+W3bItM3lQKnbTZ3DKeMBbJTzycSLGxqI9xqCsPGOwGBk51LyTjHc+OmjzB1+O3TUt0xhdMSmednZHrKQSzCMGIrzCnXFxaLLkqmw+bnsMbCXtHs3DljwkOHMLp9NDy3k2fBfYOPY7YbM3vfM0rFqCt5w==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787999474; c=relaxed/relaxed;
	bh=5YYwdbwIFm1bt+Bm+Slx8HLcSXB7jVVOB/aPsXgqr2E=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=FF/Zw03HN/MTW6pmLoiNQguRdyPZR+CW6HFH/2UQ8A+5VVIGMeU7p1R7G0YaIDXkZNSzfGXRudM4HObTu9ND2BDSvHbIs5agVtTUi1O/Cf3rerOvmc6gsKBIzZPC4ECtric0TdRPQbC/jPHT0eXoMsDs+aCPVLonvPITM82vnX1oTLHq5VDphZMY/fOgCWCYJ++rguBY/x8gEosV1TLmsc0qae6Jn99fKqsMXYdpJRbrLbL/VnGCJCEFSwyF+FK6P0B3UEfvJ0ZND+zzhsmnocRZFsNRlLBD5SAiNjYuOWjwW9t39BJc60C+IbOJuJB3niBmgCI+kEcW0vDfLkOvQA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nMF8W5t+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::32d; helo=mail-ot1-x32d.google.com; envelope-from=atlasemma716@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nMF8W5t+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::32d; helo=mail-ot1-x32d.google.com; envelope-from=atlasemma716@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXBPF1FYyz2xT6
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 20:31:12 +1000 (AEST)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-7e6b5737bb2so2535520a34.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 03:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787999469; cv=none;
        d=google.com; s=arc-20260327;
        b=pdKlxpZZ1B86VYBs1ybjGvv03ONT5boKrwrnKDyk7WW9C9LL3G7ZPxHopqiDDroYZh
         Gy/AwVlDGRJmBGbtzAOLTlEbz1lG9xYSkuWFFRrgRL0hW9vYTvOuODVQ+dHYr+lIspeH
         CpnEHd0rQlimET3IG/ybmZDN3WVdK0VyP5IaSycqS1q3YiT87ujwrHNGIEqaUOH1z5Cu
         DvFOdENlZ+S8LD7YIR37ycSBaL12eHtbIAkTmFR6iGZtSR//B5cNe/WIGrZmHHsOuQ1W
         2sK6Wi8+fb7/ArW/4DHw+O5q0T2mMfeCa5a/ll9JxkBim9x3ZSQkSDO3Ei2PJLRxJzcq
         wSEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5YYwdbwIFm1bt+Bm+Slx8HLcSXB7jVVOB/aPsXgqr2E=;
        fh=wOhGMmq2KH+KOElLlPuS8ws9o9ArjDb4wH58JVHh4Vg=;
        b=Yk5RPeIFJ0ZkyYfTfvQgLDLMTdgBILaGmmZ4YRNqczSwypHtHKXd1T8o/uH92nBqnq
         wq/NBXkrdgaAj4rzVQNQ8dwckZArRT5tX0t2S3N4Smxrfd0WCFnzA6umAxvnaZZxGmiL
         W11ehBvTzk1UyeJmRKwO5A89k9jTPW5J1Es+MU19zOpubozs3wsdgLVyY35W7t1drLKV
         NunfX2YxtMYdCoro642iXci+pzMcbMRTuti6MenaoggvVP/sAREpzABg366VsXDea3DN
         GjZsNvmyDNa+jE51hsZ0OwoOhvxByYl5Dx+1PbxLvQCwJVnTz7+F/uN0uh6sRfZpzmP8
         8n6w==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787999469; x=1788604269; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5YYwdbwIFm1bt+Bm+Slx8HLcSXB7jVVOB/aPsXgqr2E=;
        b=nMF8W5t+00dsuhXQUyzTIJy8cu5Ud2CUcHGzIvd991QfQ9nHxUF/6IxVq5Ds62bpGy
         AWhtDtIiWIMNwVx2qlWRooUtfeVibxpnLe9dZwyfizrcwdhOeH4SZwCeFX1nv2ym3zyz
         gV8sZpimUR6qXB9bxQvb8VFjU/5vRajD4+gyFCcd4k7tC2ncfBUmKYA9RV6bRO2S+9kd
         aVEoHBkis2tojR/F0obJvLL0Ui+UcbBVwcUuYNUIk2y5uCEqzafV1U2YBcxcUgZgIlJ6
         +eE6Hgv5BcjduuepdE4CmWToqzTBhWO7QWvFXlzi3QUOCyuCsQNeKbaLpidBFaxWfSq0
         mOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787999469; x=1788604269;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5YYwdbwIFm1bt+Bm+Slx8HLcSXB7jVVOB/aPsXgqr2E=;
        b=eIGIZqf1aapTs1FzPM6Nu+f3Al30C1KO+cUKB51MNSPUy2HwWkxFL8RqtDjwBnggm0
         i+i9akIfDotLd+53TN1ZBJMl//Yd5seisZkk1pX+Dktn/rGAJo5NjwNxHwI61zbVqECy
         IjZglN6qKOYXI2xNoO3/1FyTHXgnDMRAKnuqQqfWGdG0B1ElSzKRUoiDAm1UESiYKdqu
         vNhxC45Yo8hLcbc/9Xf2ZMC7Ym9DFQrf1H+BtRgmaVpmHa3fEMwwcEVAO9zfin9opp2v
         yByEWuDF/gK5eR3qH6g70HGcS9ACpWz5gfiAW4R/OY4sK/iRnd4EhrMIcL0JkYwvw+cc
         xc6w==
X-Gm-Message-State: AFuF++lo90ztKYmBgCsQ4lQCRn2N8+0KXbHDsrF+BM+i3cuwU/G3dEct
	ps+d+xIKU/w+EwkL+06MCaoIVQLRnlJFbFYCgQ5m9PCB6wsDxvuMBDglEcwx3urbl2QBIhF7mng
	8Rrdgw93okmm6Cyp44cI5rmeTPgAC4edaXM/x
X-Gm-Gg: AR+sD12dgqTZMIXhiQnnlnWQa50ftX2ZyqNVOnni9EumEVRz1AQ6h6FE3YD+/jQPW4g
	D5R8CjKS+vJnUYFUbzzjStzX4sWSklrvgpCV8K2OKg7H99cGoe/2RdAb0SB+rhT9KNbjh7q+Sl8
	LLLHAA3S9Fg76CxGKpp5JCPwV3PCFyRUVbPpY4yE0wVjUavwSMA8E9A7puDXP5/olxM9k7Dgaxg
	5k7lvvuz54RGeEkkCXgp0Y+vFfAH3uZGFYFn6ayWZA+nQpdzw0cVolWC42QHOnAJqDMrNurjn6t
	MKQTh2GKfpwlh6Y3tRCj2o7l66e4WeynN92MwDmH0XI=
X-Received: by 2002:a05:6830:3745:b0:7f4:eb76:881d with SMTP id
 46e09a7af769-7f4f228d84emr17425533a34.5.1787999469085; Sat, 29 Aug 2026
 03:31:09 -0700 (PDT)
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
From: Atlas Emma <atlasemma716@gmail.com>
Date: Sat, 29 Aug 2026 11:30:56 +0100
X-Gm-Features: AcwNN1WWq3546EtSCTktIHTjXzanz6bjUgwG_G50emLd_Zd5rgTIAEdRIbx2XpM
Message-ID: <CAA9OPq45Aktwkf4yLr0ofHP--a4mn+BwFvA-ff26Kbd4-tGwxg@mail.gmail.com>
Subject: A quick thought on erofs-image-spec
To: linux-erofs@lists.ozlabs.org
Content-Type: multipart/alternative; boundary="00000000000036a729065a2d117e"

--00000000000036a729065a2d117e
Content-Type: text/plain; charset="UTF-8"

Hi EROFS team,

I came across erofs-image-spec and found the focus on filesystem image
standards interesting.

Low-level engineering projects often serve a specialized audience, making
discoverability an important challenge.

I work on GitHub visibility for open-source projects. Would you be open to
one quick idea?

--00000000000036a729065a2d117e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi EROFS team,<br><br>I came across erofs-image-spec and =
found the focus on filesystem image standards interesting.<br><br>Low-level=
 engineering projects often serve a specialized audience, making discoverab=
ility an important challenge.<br><br>I work on GitHub visibility for open-s=
ource projects. Would you be open to one quick idea?=C2=A0</div>

--00000000000036a729065a2d117e--

