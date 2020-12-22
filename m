Return-Path: <SRS0=KN46=F2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E2AC433E0
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Dec 2020 04:47:54 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F4DE20E65
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Dec 2020 04:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F4DE20E65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4D0P3D0NQpzDqQq
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Dec 2020 15:47:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102d;
 helo=mail-pj1-x102d.google.com; envelope-from=zbestahu@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=l6BPAQjp; dkim-atps=neutral
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com
 [IPv6:2607:f8b0:4864:20::102d])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4D0P373nKJzDqPm
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Dec 2020 15:47:44 +1100 (AEDT)
Received: by mail-pj1-x102d.google.com with SMTP id j13so667588pjz.3
 for <linux-erofs@lists.ozlabs.org>; Mon, 21 Dec 2020 20:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=THPbrY8q3hP61HeiuNsYDnl45ZhgZ4mye5Va3A5VKew=;
 b=l6BPAQjpVfJr0IFzzoP5yvwbPzml5DCi3DKPDilQHPIPB8EqkOK4QcBacU8KuZhOmr
 xYDmQ7Mxurbybg2VdyqPddUvMyoVGjM8MXe7VjlFS2Wmxbz/fLOyvAHXcmcUwZwDoFp0
 mQKH8TPPtSR3jI6Nt6UYxbuhBIKa+cRNG+05dd97LuEePKdll2ZLkwIByCIC3clf+REV
 BhjNoBmAEWuEXlF35gFwvnFzBeH1uXNWhvGJX30aiwVUFgB6RMZ3qlh0x2UmDc9uYxAv
 rHvZx48UQX538GeBbLigEFI7KsniXir+6n0KIpCXHLi2dtUk9ouf1q0edMiVmKFoF+p2
 8qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=THPbrY8q3hP61HeiuNsYDnl45ZhgZ4mye5Va3A5VKew=;
 b=KF9g/DHykt51XaqOMJRN9TWtTmCMRodJVPhEoiDPyCE/1OOHQuc57xGeQ9eGeLRAxL
 +BYQzc44RNA4Os5g3i3JxuxoeDp8XxW+LD8Uc8xdS9Sj4sA2kDBATUMwzG3PLcDd3w4m
 9zEPp300KvhqC1jo6BVhnvc0Z1oYN1f6Wny9g4Jzzkn5jSrmtSUlyjj9T4djVE0+V4o7
 ICpa0B1r1t+Hxl+oJBHB/WsZPArFYyFub8JJgyd44Dp3thnj3ydpSv+SpHHSNdxMhe2g
 nFmVnXvZzYyBt0Zb6XCLj2miFzGTg8mkJa+AnSFewPo7vgpA4nFTbT+PvPuGUG0RKsDV
 SiIQ==
X-Gm-Message-State: AOAM532r9/0oefT8OnoekuJsLJmaEhrkML7/susAqvubzJD8zwd4Og35
 WpZ+FFNjRN5hjEbLFp7TfKQ=
X-Google-Smtp-Source: ABdhPJyGow3jtx6azBYzxDJuQvd5HRSxfd3KYa+u0F8hY3gQ07qDpkWJRCj7jnGgniW47QfnmNpJvw==
X-Received: by 2002:a17:90b:228b:: with SMTP id
 kx11mr21048373pjb.122.1608612461075; 
 Mon, 21 Dec 2020 20:47:41 -0800 (PST)
Received: from localhost ([103.220.76.197])
 by smtp.gmail.com with ESMTPSA id x16sm9846074pfp.62.2020.12.21.20.47.39
 (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
 Mon, 21 Dec 2020 20:47:40 -0800 (PST)
Date: Tue, 22 Dec 2020 12:47:33 +0800
From: Yue Hu <zbestahu@gmail.com>
To: Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] AOSP: erofs-utils: fix sub directory prefix path in
 canned fs_config
Message-ID: <20201222124733.000000fe.zbestahu@gmail.com>
In-Reply-To: <20201222034455.GA1775594@xiangao.remote.csb>
References: <20201222020430.12512-1-zbestahu@gmail.com>
 <20201222034455.GA1775594@xiangao.remote.csb>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org, huyue2@yulong.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, 22 Dec 2020 11:44:55 +0800
Gao Xiang <hsiangkao@redhat.com> wrote:

> Hi Yue,
> 
> On Tue, Dec 22, 2020 at 10:04:30AM +0800, Yue Hu wrote:
> > From: Yue Hu <huyue2@yulong.com>
> > 
> > We observe that creating image failed to find [%s] in canned fs_config
> > using --fs-config-file option under Android 10.
> > 
> > Notice that canned fs_config has a prefix to sub directory if mount_point
> > presents. However, erofs_fspath() does not contain the prefix.
> >   
> 
> Thanks for your patch. Let me play with it a bit this weekend (I'm not
> quite familiar with canned fs_config, it would be of great help to add
> some hints/steps for me to confirm this issue.... since some other vendors
> already use it without report (maybe they don't use canned fs_config.)

Hi Xiang,

It's been observed under QC/QSSI platform with dynamic partition.

such as product.img/product_filesystem_config.txt:

```txt
 0 0 755 selabel=u:object_r:rootfs:s0 capabilities=0x0
product/app 0 0 755 selabel=u:object_r:system_file:s0 capabilities=0x0
product/app/CalculatorGoogle 0 0 755 selabel=u:object_r:system_file:s0 capabilities=0x0
```

product_filesystem_config.txt should be from below build:

$(call fs_config,$(zip_root)/PRODUCT,product/) > $(zip_root)/META/product_filesystem_config.txt

Do not observe this issue in squashfs, so i check related code of squashfs, squashfs have
considered the mount point, also ext4 does. So, erofs should be same as one long used before.

After this patch, build & boot are working fine by test.

Here's a change from mksqushfs: Allow passing fs_config file for generating mksquashfs

> 
> > Moreover, we should not add the mount point to fspath on root inode for
> > fs_config() branch.  
> 
> Is there some descriptive words or reference for this? To be honest,
> I'm quite unsure about this kind of Android-specific things... :(

Refer to change: mksquashfs: Run android_fs_config() on the root inode

I think erofs of AOSP has this issue also. Am i right?

Thx.

> 
> Thanks,
> Gao Xiang
> 
> > 
> > Signed-off-by: Yue Hu <huyue2@yulong.com>
> > ---
> >  include/erofs/config.h |  4 ++++
> >  lib/inode.c            | 29 +++++++++++++++++++----------
> >  mkfs/main.c            | 14 ++++++++++----
> >  3 files changed, 33 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/erofs/config.h b/include/erofs/config.h
> > index 02ddf59..1277eda 100644
> > --- a/include/erofs/config.h
> > +++ b/include/erofs/config.h
> > @@ -58,6 +58,10 @@ struct erofs_configure {
> >  	char *mount_point;
> >  	char *target_out_path;
> >  	char *fs_config_file;
> > +	void (*fs_config_func)(const char *path, int dir,
> > +			       const char *target_out_path,
> > +			       unsigned *uid, unsigned *gid,
> > +			       unsigned *mode, uint64_t *capabilities);
> >  #endif
> >  };
> >  
> > diff --git a/lib/inode.c b/lib/inode.c
> > index eb2e0f2..d0805cd 100644
> > --- a/lib/inode.c
> > +++ b/lib/inode.c
> > @@ -684,20 +684,29 @@ int erofs_droid_inode_fsconfig(struct erofs_inode *inode,
> >  	char *fspath;
> >  
> >  	inode->capabilities = 0;
> > -	if (cfg.fs_config_file)
> > -		canned_fs_config(erofs_fspath(path),
> > -				 S_ISDIR(st->st_mode),
> > -				 cfg.target_out_path,
> > -				 &uid, &gid, &mode, &inode->capabilities);
> > -	else if (cfg.mount_point) {
> > +
> > +	if (erofs_fspath(path)[0] == '\0')
> > +		goto e_fspath;
> > +
> > +	if (cfg.mount_point) {
> >  		if (asprintf(&fspath, "%s/%s", cfg.mount_point,
> >  			     erofs_fspath(path)) <= 0)
> >  			return -ENOMEM;
> > -
> > -		fs_config(fspath, S_ISDIR(st->st_mode),
> > -			  cfg.target_out_path,
> > -			  &uid, &gid, &mode, &inode->capabilities);
> > +		if (cfg.fs_config_func)
> > +			cfg.fs_config_func(fspath,
> > +					   S_ISDIR(st->st_mode),
> > +					   cfg.target_out_path,
> > +					   &uid, &gid, &mode,
> > +					   &inode->capabilities);
> >  		free(fspath);
> > +	} else {
> > +e_fspath:
> > +		if (cfg.fs_config_func)
> > +			cfg.fs_config_func(erofs_fspath(path),
> > +					   S_ISDIR(st->st_mode),
> > +					   cfg.target_out_path,
> > +					   &uid, &gid, &mode,
> > +					   &inode->capabilities);
> >  	}
> >  	st->st_uid = uid;
> >  	st->st_gid = gid;
> > diff --git a/mkfs/main.c b/mkfs/main.c
> > index c63b274..684767c 100644
> > --- a/mkfs/main.c
> > +++ b/mkfs/main.c
> > @@ -474,10 +474,16 @@ int main(int argc, char **argv)
> >  	}
> >  
> >  #ifdef WITH_ANDROID
> > -	if (cfg.fs_config_file &&
> > -	    load_canned_fs_config(cfg.fs_config_file) < 0) {
> > -		erofs_err("failed to load fs config %s", cfg.fs_config_file);
> > -		return 1;
> > +	cfg.fs_config_func = NULL;
> > +	if (cfg.fs_config_file) {
> > +		if (load_canned_fs_config(cfg.fs_config_file) < 0) {
> > +			erofs_err("failed to load fs config %s",
> > +					cfg.fs_config_file);
> > +			return 1;
> > +		}
> > +		cfg.fs_config_func = canned_fs_config;
> > +	} else if (cfg.mount_point) {
> > +		cfg.fs_config_func = fs_config;
> >  	}
> >  #endif
> >  
> > -- 
> > 1.9.1
> >   
> 

