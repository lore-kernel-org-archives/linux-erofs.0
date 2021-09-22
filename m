Return-Path: <SRS0=LzaZ=OM=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B563AC433EF
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Sep 2021 14:01:14 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C69746120C
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Sep 2021 14:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C69746120C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=szeredi.hu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HF0MD37bLz2yQ8
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Sep 2021 00:01:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="key not found in DNS" header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=XmOBm56H;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=szeredi.hu (client-ip=2607:f8b0:4864:20::e31;
 helo=mail-vs1-xe31.google.com; envelope-from=miklos@szeredi.hu;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dkim=fail reason="key not found in DNS" header.d=szeredi.hu
 header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=XmOBm56H; 
 dkim-atps=neutral
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com
 [IPv6:2607:f8b0:4864:20::e31])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HF0M41tW6z2xtf
 for <linux-erofs@lists.ozlabs.org>; Thu, 23 Sep 2021 00:01:01 +1000 (AEST)
Received: by mail-vs1-xe31.google.com with SMTP id f18so3081130vsp.2
 for <linux-erofs@lists.ozlabs.org>; Wed, 22 Sep 2021 07:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=/PFaCHE2WPQbR8drQXuuWr5Eu0qa3Smkwzq6UOruVoI=;
 b=XmOBm56HjqwB5qD9VVdHzC/i8Edr+mLRECUuTTW3RVWZW26D1FuP0VcRWWRx7bB25l
 DRDY76/ZERZ8y1/wnstMEheh5w6tN7bqeMdkj3ssQxSWpnqX5VDNT1Lz40Tc4DqOY4PR
 mCH5FG+dkzmz+C4mIegeKS1PI6bZRNlhhWfEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=/PFaCHE2WPQbR8drQXuuWr5Eu0qa3Smkwzq6UOruVoI=;
 b=RmeSuSlt7zotC+GTux0+wIi6zNdFvD9NkTc++z79jaGt7rWjASt7tZn8e0g248xNaN
 446hju7wyEJzmPZ9SG1aDI2KdJGdLFEhoFhNkLVNyCorwW73uKf+JStuJZJ5I4RTFBA9
 AgWziahAtZf7kUZxQ3BHdole5Dvfdc9eZau619aRXJ5o+5HmiCEnwiLhdsRTj4+LnZZB
 cVAgxdpFVr2/2zbYUXI6UKbRjwpFIJhh19C0mIDw4dMBj4BH0leHYdRtW2OoeZKOy+gl
 gF1efgx8TTOrvUso9gd6dJug1ofAflqC6aVxqCXwAPc54lEhPz9+fiIjqYiQ/bJjNvnL
 L/qA==
X-Gm-Message-State: AOAM533D3F4q5tf7d5AVzhp7+VX83l3atXrOxt7PdzuPeszYcnytOAPQ
 e0TcnrCle0af0d+bUjx2lwbwCxj6hjOb+zWZ2wuw4A==
X-Google-Smtp-Source: ABdhPJzLFDP6oHPM8O+TCnOQ2tcicQwVUQ05DQqQP1jodQ+V7vyRWUcwn6ifv4Zj61RXNiYgu/wXWpvU6BF987IT/pQ=
X-Received: by 2002:a05:6102:40f:: with SMTP id
 d15mr18784743vsq.51.1632319258613; 
 Wed, 22 Sep 2021 07:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <9ef909de-1854-b4be-d272-2b4cda52329f@oppo.com>
 <20210922072326.3538-1-huangjianan@oppo.com>
 <e42a183f-274c-425f-2012-3ff0003e1fcb@139.com>
 <919e929d-6af7-b729-9fd2-954cd1e52999@oppo.com>
 <314324e7-02d7-dc43-b270-fb8117953549@139.com>
In-Reply-To: <314324e7-02d7-dc43-b270-fb8117953549@139.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Sep 2021 16:00:47 +0200
Message-ID: <CAJfpegs_T5BQ+e79T=1fqTScjfaOyAftykmzK6=hdS=WhVvWsg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: fix null pointer when
 filesystemdoesn'tsupportdirect IO
To: Chengguang Xu <cgxu519@139.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
Cc: zhangshiming@oppo.com, linux-kernel@vger.kernel.org,
 overlayfs <linux-unionfs@vger.kernel.org>,
 Chengguang Xu <cgxu519@mykernel.net>, yh@oppo.com, guanyuwei@oppo.com,
 linux-fsdevel@vger.kernel.org, guoweichao@oppo.com,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, 22 Sept 2021 at 15:21, Chengguang Xu <cgxu519@139.com> wrote:
>
> =E5=9C=A8 2021/9/22 16:24, Huang Jianan =E5=86=99=E9=81=93:
> >
> >
> > =E5=9C=A8 2021/9/22 16:06, Chengguang Xu =E5=86=99=E9=81=93:
> >> =E5=9C=A8 2021/9/22 15:23, Huang Jianan =E5=86=99=E9=81=93:
> >>> From: Huang Jianan <huangjianan@oppo.com>
> >>>
> >>> At present, overlayfs provides overlayfs inode to users. Overlayfs
> >>> inode provides ovl_aops with noop_direct_IO to avoid open failure
> >>> with O_DIRECT. But some compressed filesystems, such as erofs and
> >>> squashfs, don't support direct_IO.
> >>>
> >>> Users who use f_mapping->a_ops->direct_IO to check O_DIRECT support,
> >>> will read file through this way. This will cause overlayfs to access
> >>> a non-existent direct_IO function and cause panic due to null pointer=
:
> >>
> >> I just looked around the code more closely, in open_with_fake_path(),
> >>
> >> do_dentry_open() has already checked O_DIRECT open flag and
> >> a_ops->direct_IO of underlying real address_space.
> >>
> >> Am I missing something?
> >>
> >>
> >
> > It seems that loop_update_dio will set lo->use_dio after open file
> > without set O_DIRECT.
> > loop_update_dio will check f_mapping->a_ops->direct_IO but it deal
> > with ovl_aops with
> > noop _direct_IO.
> >
> > So I think we still need a new aops?
>
>
> It means we should only set ->direct_IO for overlayfs inodes whose
> underlying fs has DIRECT IO ability.

First let's fix the oops: ovl_read_iter()/ovl_write_iter() must check
real file's ->direct_IO if IOCB_DIRECT is set in iocb->ki_flags and
return -EINVAL if not.

To fix the loop -> overlay -> squashfs case your suggestion of having
separate aops depending on the real inode's ->direct_IO sounds good.

Thanks,
Miklos
