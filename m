Return-Path: <SRS0=KN46=F2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F09AC433E0
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Dec 2020 09:27:42 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8B0F2310D
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Dec 2020 09:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8B0F2310D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4D0WG40qqBzDqR7
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Dec 2020 20:27:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=YqkbqQ2C; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=YqkbqQ2C; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4D0WFz6G42zDqKj
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Dec 2020 20:27:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608629250;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=O18PKvo3bMWKB9T9G8oQlT6pHoFnQhc6J1mxqRIWfJI=;
 b=YqkbqQ2C+JInzpyH82ZssHbMLVN4ib6yVkFnPI0AsKZISE0d+gLqdYkixOu5ZkzAyRGWT6
 V49gnQ4PKG2hDuJWlmLLX9tYIWboDzrR/myax73BVfQjtWnoOdO22SiJWslI8GzFFJ8i2k
 J1/1niavfFc97kzD9LJYsrs4DIAqu8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608629250;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=O18PKvo3bMWKB9T9G8oQlT6pHoFnQhc6J1mxqRIWfJI=;
 b=YqkbqQ2C+JInzpyH82ZssHbMLVN4ib6yVkFnPI0AsKZISE0d+gLqdYkixOu5ZkzAyRGWT6
 V49gnQ4PKG2hDuJWlmLLX9tYIWboDzrR/myax73BVfQjtWnoOdO22SiJWslI8GzFFJ8i2k
 J1/1niavfFc97kzD9LJYsrs4DIAqu8E=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-AFI0agT1NXyy7Dxg_TKgww-1; Tue, 22 Dec 2020 04:27:26 -0500
X-MC-Unique: AFI0agT1NXyy7Dxg_TKgww-1
Received: by mail-pj1-f71.google.com with SMTP id hg11so986270pjb.2
 for <linux-erofs@lists.ozlabs.org>; Tue, 22 Dec 2020 01:27:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=O18PKvo3bMWKB9T9G8oQlT6pHoFnQhc6J1mxqRIWfJI=;
 b=IV2/5fmwiXrLQalKrijwisMhkWC2PylW1zRLZvsOcmTORADj16ARE7kONauxnjRDEp
 HAueSnmKb7lOUN5khzVjLE6oMuIogZEtaHm3XhLgbqMHdE4x0+LP6QHeFGxf0EXHy9dA
 vzXTeG0ayuETHOSgLg6TzLryro71+OHAw8bDV2GN/AnCLImmTf91sfrVTZhAxx2PqRFL
 VLfzmQgDIkrlz3oOA4Oi6kziVOIVidBFOKniccB7rhm9zxRlMbLzJ1MVEmhhTZl/vyCp
 pyFu+ohIrFRlQkX7AnOwbxg8+m/WBiysvUmvHKOQmhOWVlkVIXKshBDjq+Lyt9Gbo/e5
 gPzQ==
X-Gm-Message-State: AOAM532OlWgtvx04/rOOgZY5sc8mbulhkDH+pbXWqla7QB2AmgjHBwFZ
 mFBBPDW2KtFH9VodznKByNnn24Lzr6fI7aLUYWDg7f6K6TquUcAhZbwfclWrzOmEE46BqJx0kE9
 GJ2gwvRb2mf0JQjWuoAVUxpIw
X-Received: by 2002:a63:9dc1:: with SMTP id
 i184mr12269132pgd.409.1608629245642; 
 Tue, 22 Dec 2020 01:27:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyToEvNeUVRIepiLdyPM8069BQ+Ha++W7B71gEGrscu0nzcSBxUG1zd8dCDjlScfY5iSWQ/yw==
X-Received: by 2002:a63:9dc1:: with SMTP id
 i184mr12269117pgd.409.1608629245404; 
 Tue, 22 Dec 2020 01:27:25 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id q23sm20318259pfg.18.2020.12.22.01.27.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Dec 2020 01:27:25 -0800 (PST)
Date: Tue, 22 Dec 2020 17:27:14 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Yue Hu <zbestahu@gmail.com>
Subject: Re: [PATCH] AOSP: erofs-utils: fix sub directory prefix path in
 canned fs_config
Message-ID: <20201222092714.GB1819755@xiangao.remote.csb>
References: <20201222020430.12512-1-zbestahu@gmail.com>
 <20201222034455.GA1775594@xiangao.remote.csb>
 <20201222124733.000000fe.zbestahu@gmail.com>
 <20201222063112.GB1775594@xiangao.remote.csb>
 <20201222070458.GA1803221@xiangao.remote.csb>
 <20201222160935.000061c3.zbestahu@gmail.com>
 <20201222091340.GA1819755@xiangao.remote.csb>
MIME-Version: 1.0
In-Reply-To: <20201222091340.GA1819755@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hsiangkao@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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

On Tue, Dec 22, 2020 at 05:13:40PM +0800, Gao Xiang wrote:

...

> > > +		fspath = erofs_fspath(path);
> > 
> > lib/inode.c:688:10: error: assigning to 'char *' from 'const char *' discards...
> >                 fspath = erofs_fspath(path);
> >                        ^ ~~~~~~~~~~~~~~~~~~
> > 
> > -           fspath = erofs_fspath(path);
> > +         fspath = (char *)erofs_fspath(path);
> 
> oops, I think it can be modified as a temporary workaround, will submit a formal
> patch after verification.
> 
> > 
> > 
> > > +	else if (asprintf(&fspath, "%s/%s", cfg.mount_point,
> > > +			  erofs_fspath(path)) <= 0)
> > 
> > The argument of path will be root directory. And canned fs_config for root directory as
> > below:
> > 
> > 0 0 755 selabel=u:object_r:rootfs:s0 capabilities=0x0
> > 
> > So, cannot add mount point to root directory for canned fs_config. And what about non-canned
> > fs_config?
> 
> Not quite sure what you mean. For non-canned fs_config, we didn't observed any strange
> before (I ported to cuttlefish and hikey960 with boot success, also as I mentioned before
> some other vendors already use it.)
> 
> I think the following commit is only useful for squashfs since its (non)root inode
> workflows are different, so need to add in two difference place. But mkfs.erofs is not.
> https://android.googlesource.com/platform/external/squashfs-tools/+/85a6bc1e52bb911f195c5dc0890717913938c2d1%5E%21/#F0
> 
> For root inode is erofs, I think erofs_fspath(path) would return "", so that case
> is included as well.... Am I missing something?

Also I don't find any special handling logic in make_ext4fs for root inode
https://android.googlesource.com/platform/system/extras/+/refs/heads/oreo-release/ext4_utils/make_ext4fs.c#229

Actually I think the squashfs commit above might be wrong if "--mount-point" is
specified if my understanding is correct. Anyway, could you help verify it in advance?

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> > 
> > Thx.

