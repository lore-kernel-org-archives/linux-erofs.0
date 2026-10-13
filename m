Return-Path: <linux-erofs+bounces-4730-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FE4CC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 11:10:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3s7z4n1Qz3brP;
	Tue, 13 Oct 2026 22:10:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::82b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791889839;
	cv=none; b=i0C7+VMSL4dyxWQ9fUGdgs4Qci/OoJLu6VGDV3k7ezIVsbZP9qRpKBT7v766o71d+t8gbmyIMBSYmE0BC+75lyrtiSF9Ouk7LXiQWOdTqqQOPlR2e2D7ost7cdRR6jfbXDgaOdsfl+mCleHWP2+mgvXxL3YJfyJyLLeIM5SxzYr6Ps3hReQYC17p8aeGWBYjFeu6dQUrormpjU7kGHdX5mEps6rsI7QYEJSoYViu3/Bfqiuho3qsVHcQkEhno5HvUSw1+PttCaPk06OCOJ/qvrtVgChY/dVudQc18vJHNKabRBkYERBFsm/Rkf+rjBJ0KETbRnUd2TVVJ0pXnfJbuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791889839; c=relaxed/relaxed;
	bh=UAd3pyrjYJ79zz7XvVbYN8zMVTiBQfNrye9emGFKP5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXcqfTO1z884afeTdXSkQIqV5nm1fgQ93a4RZ78kRrNwMMpQDXcT7ToMzU/VH8m15Vb4zshVknNo6N9rsQh6rteoHgLJBmE7GJROV+6UzbhMU1NKfQNk6W5j5pJur03R2iFXcHVAzi7M0MwvRYNHVlgvEJtfH0HA0ToInQAY27BY9POpLZKcIYkJSmkiX8AmKnztVbpBHFYzPyJNGgmDwUZh3UIJKyHnVsQAlVqDl3uSmC3pg5zPGBNYx0DyahByyhhM5HSkdvEJQtR/YP81KyoY0q7ZoVJjMLdiJVdOCMb76ZyIRaAfDCu/X/Ekzv7n7OIqvqhfGKZ3oY98M55RPw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T96wW6DL; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::82b; helo=mail-qt1-x82b.google.com; envelope-from=michael.bommarito@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T96wW6DL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::82b; helo=mail-qt1-x82b.google.com; envelope-from=michael.bommarito@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3s7y3P8nz3brM
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 22:10:38 +1100 (AEDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-53506b44151so38259671cf.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 04:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791889836; x=1792494636; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UAd3pyrjYJ79zz7XvVbYN8zMVTiBQfNrye9emGFKP5E=;
        b=T96wW6DLSWqw/tT86BAl6TbsYZ1OElNzrg2+01lDNmYYsVZZsrJKnBKIr/LLh8Tlc+
         h5tQdQEcZQUSpPKAYdU6OF/qQuC818jNOGctHfz75d28FrzmfpS1TH9rniSidCLrk6kK
         GOWLeT5p2vVem1rQftDYVo7CFVOr2NbKC/lmNELcbxprua6BjnvVid7NR3VP/XSLVtLv
         6NRO/S7CYO9pRrZlXCM3vVoELqRoBUDAssxI83ZGcOCMwfLFap9PKsRppS3Pt0cZGjMm
         LO+ZFgFAfKn2T6dN7+UiTmwnFec96BIzshL+K3XGzgngEeLJIh0nNqSOoCtg8DwLhrqK
         qOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791889836; x=1792494636;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UAd3pyrjYJ79zz7XvVbYN8zMVTiBQfNrye9emGFKP5E=;
        b=q5uwTYG+9BNtwscg8H3bJ6IpbVbdYh0Wc3FkkoLPyiS9p55VmcpNOZW1wvg2MK1wh6
         L9junuZJ+FoQDRvZFnHPbex0E/B9GaqVonHVC2MIgfL4jKxJNyCqpivn7nuIvgGXZ53S
         /qw0E+YeIbNWXMJ9P+3PBa+lHAlG+Oom2nGuXZreuBoC3hasXbT3HT7p93//cgw/8LrB
         fxUhjDLte8yiNwsSyzQBbGnUQq5UTjmYyi+5ZV3B2T8okft+qP9VBe6Ee1wsSX32TGNd
         qXsyvrBO3PFfBr/eZLcUY3x3qDwW/9pDyyMLjkog+LiHzR3vFL+ta0fTXPdYzZRNTnW8
         VOsA==
X-Forwarded-Encrypted: i=1; AKwUvBxxRC1c6OzincB0DCFtoxDlkoDevsmzb/5vUHe3/BBSVONJJmy+URuwjioSbCYVmayeNVG65LPf+fm8GA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYI/AN/uspYiA4PUN3A/fXAMMb5WH9UJ/JuUWbaBueBDx45qfsZi
	3dsaScYACUzucQwFAxMrS7ThfVEzmdJLuryph5OWqJl3bEdYBGlJh6U5
X-Gm-Gg: AYBFou27giq1Il2aHhWIIzuFBj7+gZ0U4fM9GpLrR1cBEyHKPWg7u08NON2IWcTujuU
	IwVyv6xY9xXIi1JjWQYbqxE8a6SDT0AIbV51u+6xsNcqD5uLWdKh5xqF2ughg8jB74boyS76fhw
	66A7MMPUQ5FGiojf6MAY3ofmyly0RMEzh3O/ILdMCYOf41AMy/8i0LDd0c5es76xIIuq8RrXbJj
	MwLoL51hW7gtNY4w/6kiT2xor7F+piZI+2DehVEQndh48Dhf9AOIiDX/M5U8WxQmVGXJ8WKD4DE
	tdZtXLghw4/VZxFP4NGr9xycXJB5Dh37Wzs/Mh/pSA7Ha7hSp+OXJZowM34U86I7yWO8I84MRdo
	LRguOzF7pDx5XE1GhdhaqcwSgq0HMd5O8mVwDsezToJA58fspwZUw0bz0IF7ctka81QY9qogAmN
	ipw35iWBR9pzbunX5a3eMlLIv0QScNbFYVl7ZWCJvl4R79sGkqrE1D3t3RoVBEZdGcBwjdwJ0Nz
	36RO2evEru3m34sJ0RII/J8lAVo3RbrNJNyKHAxBGTi9lWSDDt+qkuurTkaYtI8MRW1Kgbmhw==
X-Received: by 2002:a05:620a:4515:b0:93e:9171:b72 with SMTP id af79cd13be357-93ebd27ab18mr2002162085a.49.1791889835669;
        Tue, 13 Oct 2026 04:10:35 -0700 (PDT)
Received: from server0.lan (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef502497bsm212394585a.17.2026.10.13.04.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 04:10:34 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org,
	Chao Yu <chao@kernel.org>,
	linux-erofs@lists.ozlabs.org
Subject: Re: Patch "erofs: remove fscache backend entirely" has been added to the 6.18-stable tree
Date: Tue, 13 Oct 2026 07:10:11 -0400
Message-ID: <20261013111011.2814836-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <as3drCZLoTUPS_oC@XiangdeMacBook-Pro.local>
References: <20261013020044.2527207-1-sashal@kernel.org> <as3drCZLoTUPS_oC@XiangdeMacBook-Pro.local>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For context, the original bug I found can hit both 100% deterministic
local DoS and a textbook UAF on kmalloc-128 slab that requires timing,
but I don't think an LPE can be ruled out...

Since it is reachable by an ordinary read() on Nydus or others that
enabled ondemand in Kconfig, I think it is worth thinking about what to
do for all of the pre-deprecation users (even if it's just comms).

I would defer to Gao, but I sent a minimal fix in June that can
close the UAF without any other breaking changes.

Thanks,
Michael Bommarito

