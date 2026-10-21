Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029EA606A31D
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 08:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAPZ6e0F
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8hfZ3yLbz2xRm;
	Wed, 21 Oct 2026 19:05:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792569926;
	cv=none; b=cYuWf2JiWT3FU/623ZKa7mt3LTwbdTC8VZD/Fgn+CZPDNu4dUHu/l6UNSrtlDraRc3fsOKSq/WdxOfRREZ2MCvcn6cBEToU8foiEtkh59Pv1a/uWOUkM0qxnz8JjnSMsQzEjm9XMiXWSY6BhJSu+P33pLr/dTov/9RVJ2aRC5Uz7eByX2YxaLJLl7H35jIi/pwGYAGYGenQXH1zeoienSWwcsWuJZHv6joU3Qx4Rm8fDwotzx37qzukpkbmpEH9qhP1zX2MzJIjzz/MmX+JEE3NVsA2sKoUzwdVkoVpjDthTNNHgEyozSLvbdW88W3QKDLZglYKU/0o1E/BB9UepAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792569926; c=relaxed/relaxed;
	bh=hDOMQ91uhDohJSZ7YqAbXMPKl28Jt5X94do2OgtHl1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSqwhasPlyOgA5U+zwhJpoDdfNNoiSD5/vS+7LwkD/tOSZruenhKdBdPlePD74fPhf/0zJzktLojgWvaMPGsDO8iC5Ig5z9tav4WgGih2KKLmnUfj58XlgvkbYLE/GOOYODlsUMZjQL97oWPlvVlDpPIITWOD1NiWuKaYIT3wIcivgxS3OLvHmnrUU/QITUtH0S93gYcjDmm4yqKXfFE7OB7HJj1MqpoJEG2iiCP8gTCoXHcucyZAgHir8KeJeONRHAQ+RgyiFZog4Z8Mk2Xirg248SoSTK7PM+PV4P39kpdk9GxA4vN/CuAwd0tmY7cCjVu2S1jT+Lgo3TV/KvJ9g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAPZ6e0F; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAPZ6e0F;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8hfY1FWDz2xPW
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 19:05:25 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 919BC43B7C;
	Wed, 21 Oct 2026 08:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDCD1F000C9;
	Wed, 21 Oct 2026 08:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792569922;
	bh=hDOMQ91uhDohJSZ7YqAbXMPKl28Jt5X94do2OgtHl1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gAPZ6e0FjFqyx/5EKk5EftjsDjjpWqCdZ4W4OoWg8evKclBA1AUU1Q+l6xq/s7FbO
	 +C2oQ/g54n7vdYgi6BBBqe4obM+SWb2roYAaoUhCtCwTTAe1S4PrQ4f0F6RgR+m8nn
	 Oru3ScwSh7sBTaeXMVnoYaNM3SVx2tQm6yzoS4G9x110yy3XY/shfEI31KoOw37ruT
	 3UwwPteJst3WBGAi9/GSCsUKZQx1FV3Zp8SCK0AYBWl5URdqvM3AAmFvdj/JfHD9/z
	 nXv8DRgUQmJtsfFO/J0GHFdkFLILMEfEYCSkTDSJRLoSIva/rfqS8ixrhf1Ud1ZjwQ
	 V3faTezO/X8uA==
Date: Wed, 21 Oct 2026 10:05:15 +0200
From: Gao Xiang <xiang@kernel.org>
To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
Cc: Gao Xiang <xiang@kernel.org>, "chao@kernel.org" <chao@kernel.org>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
	"Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
	Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
Message-ID: <athyOw_WoXy9-NDR@MacBookPro>
Mail-Followup-To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
	Gao Xiang <xiang@kernel.org>, "chao@kernel.org" <chao@kernel.org>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
	"Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
	Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
References: <20261010094000.2036805-1-friendy.su@sony.com>
 <asqsNhtlXaEOrEky@XiangdeMacBook-Pro.local>
 <TY0PR04MB6191A63F6B79E4109D185F41FD9F2@TY0PR04MB6191.apcprd04.prod.outlook.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <TY0PR04MB6191A63F6B79E4109D185F41FD9F2@TY0PR04MB6191.apcprd04.prod.outlook.com>
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(+cc Amir, Jan)

On Wed, Oct 21, 2026 at 07:18:06AM +0000, Friendy.Su@sony.com wrote:
> Hi Gao,
> 
> Sorry for late reply.
> 
> We have considered fanotify in erofs-utils. I think it must be used with 
> file-backend mount. It actually utilizes FAN_PRE_ACCESS on ext4 or xfs. 
> Also file-backend mount can not support DAX mount.
> 
> But for our case, file-backend mount can not be used. Firstly, there is no 
> ext4 or xfs file system in actual environment to put a sparse erofs image 
> file. We have to mount a normal block device. Secondly, mount must be DAX.
> 
> The basic flow is file content is fetched from remote then filled into 
> local erofs file on the DAX mounted block device in FAN_PRE_ACCESS handler.
> 
> "/dev/loop0" is just an example, not our actual use case. The actual block 
> device is something like /dev/pmem0.
> 
> In order to make SB_I_ALLOW_HSM only set under block device backend, 
> we can do like this:
> 
> if (!erofs_is_fileio_mode(sbi)) {
>         /*
>          * Allow HSM to support fanotify pre access event
>          */

nit: single line /* Allow HSM to support fanotify pre access event */
     according to EROFS code style.

>         sb->s_iflags |= SB_I_ALLOW_HSM;
> }

I am fine with that as long as you limits SB_I_ALLOW_HSM **only if**
s_bdev is valid (IOWs, I hope we don't need to bother it with EROFS
SB_I_ALLOW_HSM + file-backed mounts; it aligns with other filesystems).

Also I think it would be better to add a testcase to check the basic
EROFS SB_I_ALLOW_HSM functionality in erofs-utils (see
experimental-tests). You don't need to add support for EROFS
SB_I_ALLOW_HSM directly in erofs-utils; but a basic functionality
testcase for this is needed.


BTW, for your use cases:

> mount must be DAX.

As for virtio-pmem, why not just use userfaultfd on the host for
virtio-pmem lazy pulling? for example,
https://github.com/firecracker-microvm/firecracker/issues/5740

Personally I still don't think monitoring FAN_PRE_ACCESS of EROFS for
this kind of usage is a good idea.

But anyway, it doesn't matter to much if it applies only to bdev/pmem.

> 
> How do you think?

Also please just adjust the patch subject to:

erofs: set SB_I_ALLOW_HSM for bdev-based mounts

Adjust the commit message accordingly to your use cases, and
explain file-backed mounts are not your cases in the commit message
as well.

And since it enables SB_I_ALLOW_HSM, it might be better to
Cc fsnotify maintainers in the following versions.

Thanks,
Gao Xiang

> 
> Best Regards
> Friendy
> 
> ________________________________________
> From: Gao Xiang <xiang@kernel.org>
> Sent: Sunday, October 11, 2026 5:20
> To: Su, Friendy
> Cc: xiang@kernel.org; chao@kernel.org; linux-erofs@lists.ozlabs.org; linux-kernel@vger.kernel.org; Mo, Yuezhang; Palmer, Daniel (SGC)
> Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre access event
> 
> Hi Friendy, On Sat, Oct 10, 2026 at 05: 40: 00PM +0800, Friendy Su wrote: > This patch makes erofs support a use case below: > > erofs file data are not available at local, but need be > filled at fanotify pre access event handler. 
> 
> 
> Hi Friendy,
> 
> On Sat, Oct 10, 2026 at 05:40:00PM +0800, Friendy Su wrote:
> > This patch makes erofs support a use case below:
> >
> > erofs file data are not available at local, but need be
> > filled at fanotify pre access event handler.
> >
> > E.g. when format erofs to blob mode, meta data image
> > is store locally, blob image size is big so it is stored remotely.
> > At erofs mount, a loop device based on a sparse image file is
> > used as blob device. The sparse image file size is equal to blob
> > image size. Like:
> >
> > $ sudo mount -o device=/dev/loop1 /dev/sdb1 /mnt/erofs/
> >
> > Then at file access, need retrieve data from remote, then fill
> > into sparse image at FAN_PRE_ACCESS event handler.
> >
> > Signed-off-by: Friendy Su <friendy.su@sony.com>
> > Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> > Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> > ---
> >  fs/erofs/super.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> > index 0967aace9f7f..b92d3353319d 100644
> > --- a/fs/erofs/super.c
> > +++ b/fs/erofs/super.c
> > @@ -659,6 +659,10 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
> >       sb->s_maxbytes = MAX_LFS_FILESIZE;
> >       sb->s_op = &erofs_sops;
> >
> > +     /*
> > +      * Allow HSM to support fanotify pre access event
> > +      */
> > +     sb->s_iflags |= SB_I_ALLOW_HSM;
> 
> Did you notice
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/lib/backends/fanotify.c__;!!O7_YSHcmd9jp3hj_4dEAcyQ!3EhQW78Lg9hjdjMscHBj-V19jmMX6nlYdkPVufSmwLJEM5yM0uTCOLuqwilIL3MGLDqMV8LkNo1Chg$[git[.]kernel[.]org]
> ?
> 
> I am not sure why EROFS itself needs to set SB_I_ALLOW_HSM because EROFS
> is an immutable filesystem, its data should be considered as a golden
> one and it shouldn't be partially filled.
> 
> Instead, SB_I_ALLOW_HSM should be set on the backing filesystems (ext4,
> xfs, ...), and if I understand correctly, combining EROFS file-backed
> mounts (pls don't use loop for this) already implements what you said
> above.
> 
> And this functionality is already released in the latest erofs-utils
> and Nydus v3:
> https://urldefense.com/v3/__https://github.com/dragonflyoss/nydus/blob/v3/docs/fanotify.md__;!!O7_YSHcmd9jp3hj_4dEAcyQ!3EhQW78Lg9hjdjMscHBj-V19jmMX6nlYdkPVufSmwLJEM5yM0uTCOLuqwilIL3MGLDqMV8IXHHnVqQ$[github[.]com]
> 
> Thanks,
> Gao Xiang
> 
> 

