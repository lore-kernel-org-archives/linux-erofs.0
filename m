Return-Path: <linux-erofs+bounces-2622-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D32FD2D70
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:54:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVYjc0D85z2xlx;
	Tue, 10 Mar 2026 23:54:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773147251;
	cv=none; b=kdg8A3hiVJYqExNtjoncsRp0jK7ddjanWuSeg4puP+4M1bFvmSbfJmMCZs0COmsopvg4QxSx9BlnRWeetKl0WOtKtNmCnMuD9RS2WTdEwAtpId6jfE6sLxRn2sBF6YyaO4s5kYLggXW+heuXA7pTxAhSKeC47I7CLpxbtCkKX2KFcrBzYuLlEpHOSRVKM3Okeydv9DtV7NzOpb/1BCFMaH0ohC48NM0dsHU1wyX96eoqWPH/3xBFilsvQZMgtWU9eBcIW3K8xJe5itq95DiNIds0sFg7jBc88Yu86aiP0CUGY8vyy9WbnBeDLYnP3alRelCandUIFwBHNmXVNhSq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773147251; c=relaxed/relaxed;
	bh=mm6hm+LHoMGo5Ew01sq1dP9YSITnoqIDxYFDqmtgvh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDEbJb6C/uyEBc7wvuqJs4wpPVSIQCBRB7fZhTRpUePDbJDZUzFPNwE28SyOduZ2C7iOlf80oXD8WaiH/Q2sl1cRt64j4ARRismZiKfrD3evqO0cQVKapgNkRyiaq3v/jtYzu7M8hkVaAE3pN6oLuU7ofu/HTy0CB1M/OT77gx4/iSVynMZOYvRKWK63fOyhhIeYqO25J7vs8uzsedO/M3j7C8XTkDPoAbOaUUYr8EzNfh5+sJnn52hZ8ZOI3BuaeTVxW7RosVXaqZpTJfRDm2zPmY4lAvuvNLFtbsOkNJfY8uvkBSti/2IzlINs8ThF8AmF/OXK3YrrnKWDtP+l/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=0ccCaUpB; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62c; helo=mail-pl1-x62c.google.com; envelope-from=praan@google.com; receiver=lists.ozlabs.org) smtp.mailfrom=google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=0ccCaUpB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::62c; helo=mail-pl1-x62c.google.com; envelope-from=praan@google.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVYjZ15cbz2xjh
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:54:09 +1100 (AEDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-2aeab6ff148so1335ad.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 05:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773147248; x=1773752048; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mm6hm+LHoMGo5Ew01sq1dP9YSITnoqIDxYFDqmtgvh0=;
        b=0ccCaUpBGeFXW9VuCVOTas9+TIR/P+6drvFifn2zf/eqro63BYkXQASV08Qn/wyqYy
         3c742zmjXSF+VigBscOQ6/7yrrO0wFyjqJ0urv2FrHxH/cdkzqw+1E5Or9/wUbjO1zZy
         xngAmTYFIr2k5fnBWK067AG0YQyAW3p9w+YGcQP5xZs9ws61br9ILApOCmE9eDUfyYDD
         JZMdeKLJwJ4o0nTgDAma6xgyqyTjFNDDINm1N+k+A6MM4z/E+GqQPw/viP4f8Frl6mlH
         dsB5DLFCqZpnhBVuugYw1P57GiKabv89fjYzA/GsirWvn1BQ9Ai9CWyi5GGk2q3gkwod
         GLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773147248; x=1773752048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mm6hm+LHoMGo5Ew01sq1dP9YSITnoqIDxYFDqmtgvh0=;
        b=KM/w4YZWItlczlSfbJeGCqzfYxRYDc6dXId7Ci72DmxXquP+uye6ondXabXHpxiwkf
         BaRFpDz3S8eNT0ZnGTb3E0cn4VgXhSXKsum/pqNZ3aQ2R4JWw4Dt30KpCpU7/UJpeSYE
         y4eViq1ETbQf+WruYg3ndeo+ldb4rRfrQi0+3KR1fiijlzpQtU3G1mLISwciJgEaAWaF
         oiABrMju86ZUvKktcb/kFVKZAze/KFX2KTVVJJA93Ui+pPyTWxaw29AOahJDlSc/fe6Q
         EdaCUR2r/QMHGQjBWkDgNZD234gr+8VRxnQ927Pq0eM9kKGVrtjrjmHJC/zVeDB1WyOX
         gRAw==
X-Forwarded-Encrypted: i=1; AJvYcCWd6nAjAnTLn2VnK1/yjnq6qB1aPEvTK/wEy2K97c5aaR0DOrvG5KvDlZLP2jyfI7Tcb729/QBaaUOzNA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyLv6UlYwNFrD2Pe/SOQaXcxNQcIeU0y+Lv6vfSfl7fP6jS++VQ
	bL8Cno7t/d0Po6JpbKlIJmJ6HGSDQTvUBZlN9/oDTJlMxyOZhjL4mEjnoa4ondfguA==
X-Gm-Gg: ATEYQzzbsIYDXnrthVjXi9yiOXAj4Q4EFs/oAL/i6UwOfzX7frw7qCDKhJciqcdI0AZ
	3wsP94MKPEml3DQnXsulbdfLexulHO1B+93npgA9a932CZEaAQBki4VTeoMoGIh6bVPC7sED2GX
	QEcacp19HzYQVr1sZnmrqTuJL/53FtUXwqHQyqn7Bmc8eZ+c/0Vzr3YR1VApq+69ONltOsKmnVa
	HwHfS3mGZoAncCkDjYX3OrAsv3u+U//2IrTyYRKrjq93tieMgLlA85YednHgBBWDv/NPSYP55ud
	1+Ffc/lobOlJH0XBAaudIB5i7Hg2pYX9zu8NnzdIBx2zX8iOc7USatcspvw1m9yPgxsT7ivcIl4
	MUZ0VlDAsEpBmoqzHWbT3/AgND9cIUm17VxGoNPwWAgf10EY/9MRQhAPdSvF461KxMdW9BeL7k2
	+7onyBGd6hecfI2Q+oUosQK7sVOJVqJtfjt6Qpcvv4wwgAZHrWudJb78+Ayw==
X-Received: by 2002:a17:902:ebd2:b0:2ae:45bb:bc4e with SMTP id d9443c01a7336-2aea30ebe48mr3008685ad.24.1773147247400;
        Tue, 10 Mar 2026 05:54:07 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0cb73dsm12445679a12.11.2026.03.10.05.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 05:54:06 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:53:54 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>
Subject: Re: [PATCH 46/61] vfio: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAUYvx6VEdSmInm@google.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>

On Tue, Mar 10, 2026 at 12:49:12PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> To: Alex Williamson <alex@shazbot.org>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/vfio/vfio_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 742477546b15d4dbaf9ebcfb2e67627db71521e0..d71922dfde5885967398deddec3e9e04b05adfec 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -923,7 +923,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  
>  	/* Handle the VFIO_DEVICE_FEATURE_SET */
>  	filp = device->mig_ops->migration_set_state(device, mig.device_state);
> -	if (IS_ERR(filp) || !filp)
> +	if (IS_ERR_OR_NULL(filp))
>  		goto out_copy;
>  
>  	return vfio_ioct_mig_return_fd(filp, arg, &mig);
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

The cleanup alone looks fine, but I'm not sure if the maintainers would
be happy about the tree-wide spam, since each patch might go through a
different tree. I'd wait for Alex's preference/ack on that.

Thanks,
Praan

