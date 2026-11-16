Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF5C606A881
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PMrvCQ7R
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSvg55LfQz2xqL;
	Tue, 17 Nov 2026 04:17:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::534" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794849425;
	cv=pass; b=F9sfjuP1jgAu3KOdVLyQV4BODRu4a1GW+Lv4Vi6hxshN+oBSP29DpuDk6UiB7+GArl8bazcL3fIzBXtSbRonPFtVD3RiEySmirx6Mb598n2YRzYz8OWmSKKCBsFCbEdtBUZEF/T/JKJEOywRvfIuL/U7R1DRhXLgYw/Y1gasA2AMsZdW+gJY+avIfvsoouyTf736JiaGcuqKrESQ96zQa/+Gzs0iRvhiTj5cTZ98KpplL0Ic7XVqE6ypU7oGku5OXZu+f13jjo0MSSm8ww6j+DQ53SM3zW/dtKijHUjj57eQAa9EK2tmGgSccj8jxksrvNkAdMXGiwV8XUr85azJTg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794849425; c=relaxed/relaxed;
	bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VaO6mgDPua6zc+6x+Kns9VPEtmkOEoOUvf2MRepx6OHcE68LcteJxXiK6N9fv8eqCYP16LF15RebAghc/e5E03RsJ6ktS0/W7aFVI6TdMUN7kmGxz8aYh4bJYKf4PtKirBL53LEYtaZCeuX+XDmcE5/JONCGqOJVfuhazHLOD/KM5UWZPqpftI4/9bEvl+R7BW5woqSowvMmH2JHrGORDpcm8vxgnQ5uetSMLfVbqXJ6p3KphaX4uSoq23VxO5biQOE0sMVfaDEdlyVj3uNzOR1cxVn9NuhtNHD9S1XzcF6CbVb4oGPEOIt+U4Q3mambexdRgXYuZatLPfKPin7HiQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PMrvCQ7R; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::534; helo=mail-ed1-x534.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PMrvCQ7R;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::534; helo=mail-ed1-x534.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSvg32Syjz2x99
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 04:17:02 +1100 (AEDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so5448123a12.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 09:17:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794849418; cv=none;
        d=google.com; s=arc-20260327;
        b=lJWGcqsC5rV3f6+bxPPuMxwxl+mlZ17TOrN99p/jfX1J8yITsugIoivZYuSkMiCM6/
         3hE2uJF8SVYSr2rsLTn0AuHv5GGZjIuWf8oDe+IrGyVFSZfgPqT0VEUu3qANwfAOw+3j
         mfIT8tDw7AtMiPzA/Ix5ppizpx2wlPMcHFX/rzRffExvv9RRUfo39GLYv88Tq1mmrufL
         3ddVsKFbL9AcNmdykiL+542PhjDiQb4oZzAWXFwUm59xsaOkdA5hh63JMW9Q+GT3liTW
         syoI01FciTXbmj/5WxVHYDqR5n4NSR6ApfIX4Jo3Q93HFqhupv3ReEuB4LwKI5a3MGk3
         hgXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        fh=sX9NlpjrWzJ86t/qTdLjEkrqgzoYoFH+GsGwvu488ZU=;
        b=W2yXsVb2oR+LCDPDoa9Po9fdswm5v/9B/7H72q5KFcn4YtX3CCP5tWiHPM55SQGYlS
         26W2XS4XdMv3uvLbfHodZBTG+LH169HryFzzYk58Zpu/9Oig9LOq0XTmUg/7dw4Rr2bc
         dTNLQNw2uM6PQRTlQIj/MWj3HvYKsTG4TTWwDG+kfX22qB9kYSWJ0mivOXmkSBXRVRad
         PnW7SsVmgWHtxGhzHIwFOH1oMn6VIfL85dVOobP54AYrjXaPGw+1w0A2blQ8AYgd1bX0
         F0AJOHQwm3nIBZx2eOI5Cewkz6n33U4myDIc43MThWCym/R4Je9WVKrh0ml+IDbuXK72
         0JHQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794849418; x=1795454218; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=PMrvCQ7RjVi3Gv96maoynDuxs4Cp7Mgzourj2DtzWDd+6PYaZ/ozrYiL3LF008meH+
         x5EELu5wwrDQ0JuRxuPcc5Otlpntq0hGVxJGhz1LFUqk+8cF3JMhnPGrlbcJUm8yPwBY
         h+K1dieCXIGYlKS7mOu267M0rZltXja54rn2ZjKgaKXvrwXhgbHxQA2qzbJSFXz+XTtS
         hQ02wXSxvrIdtGcIs2lRChgMUKtznUJPKKt+6GZmICTGYoXJMt98Y5atmm/IkhdtnRu5
         tkjYHzg2HoredXvHIdHfQ8oCFk76vyKbY4oULr6xnwEYll7/gx2eOVUUsYPh2645ap9O
         6Gxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849418; x=1795454218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=zREwMi+4PMnm1a//vCJ9igTDMyqUp+szrAkn/xTUATP9HGFsDWGOtLL9jQi2P8AP2B
         At1yt6DdRrxaGQwlxbkhN35u/UKt6lvAuyPq2tKfmjn1r5Sv/zcowrqDBwC07VC2v5Ht
         B6BfppoSwdmrq1ZYD1AXyk0ivFtxeCxNR3k/5ZNqasyzEwDogPdRvAJyebezt/Mtyau+
         H8LZTzFDvAAPFyth9HPD+93UlebsgqfMi8jFwkiZ2kVddo5ZH3aGMWZRYYQRSNN01Ryr
         hGR16+SIkCbptclQ2fMYgjz1fmvXl6Uj3QuQmsapNlq/N2mU+a6Er8rdOPJZ+BhCD+b6
         kKrQ==
X-Forwarded-Encrypted: i=1; AL+hErHCiuIdAWgMJdLsuh/1/nMvkRKoEKmRAPlkdFBaRnO+iQ7Z7Hvc3nUiKJRHisppsu//1tvB97xBFpGoSg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z9/Q13iImZTb3FSSBRhN7YmLuwQAHUahJkxo3P4cP3i1Bn1sUSG
	UcjrX9M32pUrr2tJWjKq13ZXpM+Qg6i86pBBhUQ50EnRawsSz4pLQb8lREDFFjk+2aJWqm9gam0
	B0t+Y3fBaRgKU+aDuUC3xTOh0cyYkRd8=
X-Gm-Gg: AYBFou0Rhspl0HINuz5LBNUOLYQy0JF3/RVB8/+eW9/SGXYB5kfiR/WB1Es20YjXRiZ
	fgtrP2WCV+IMzE70ekwrXaP67kT1yKt+oauJsFIwwDnIPpet96Njfc6MBQBl3VOsMSX1cko8oYF
	nIj97hAW7I+ItgFBAbm2LVwLi3Lnp8RfjiQGdIGn73DBRQl2rQLSMp4mnscKs7UhxKri11zgy/B
	693onRBQd3/UXtIjV2e8VlBxjrDB0O0hpehrQGxFRpGGQMiKON9l776QNq26HBigdIqDNfCNihR
	evr1AY2a41oUJfustCtjCK5Q/rjNiKd3IVIDqigIkrBBS2HskHRmheMFkaeu5nfwJJ8N7RMG5IL
	+WaZqHPhnrgM8gdc6Ohmuo2rDTqkDsKd2s/xbxO/YDOTJE34epaIKsBV70B7d+Ll/SeCS+dDDLa
	SGmcXit+WlG829qkc=
X-Received: by 2002:aa7:c258:0:b0:6b7:d69a:a3d3 with SMTP id
 4fb4d7f45d1cf-6b7d69aa8fbmr5089335a12.39.1794849418257; Mon, 16 Nov 2026
 09:16:58 -0800 (PST)
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
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:16:46 +0100
X-Gm-Features: AclHuK_s2Kpb4OdbgPngYJl9gLHjfhlAmiJMqLtxRnpTDibz-Ni4SZJspSV9laM
Message-ID: <CAOQ4uxjJVgy-skUbbScfz=eAEATf=iMpqRHNshX=eKu3oiwnrA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 34/44] selftests/ovl: test data-only layers on
 pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Add tests that overlayfs refuses data-only layers on pseudo filesystems:
>
> - sysfs and procfs via the "::" separator in "lowerdir=3D"
> - sysfs and procfs via "datadir+" by path
> - sysfs and procfs via "datadir+" by file descriptor
> - tmpfs as data-only layer
> - sysfs as regular lower layer
>
> The last two must keep mounting.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  .../selftests/filesystems/overlayfs/.gitignore     |   1 +
>  .../selftests/filesystems/overlayfs/Makefile       |   1 +
>  .../filesystems/overlayfs/pseudo_datadir.c         | 131 +++++++++++++++=
++++++
>  3 files changed, 133 insertions(+)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/.gitignore b/t=
ools/testing/selftests/filesystems/overlayfs/.gitignore
> index b343cc430051d..e1410fee2269d 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/.gitignore
> +++ b/tools/testing/selftests/filesystems/overlayfs/.gitignore
> @@ -3,3 +3,4 @@ dev_in_maps
>  set_layers_via_fds
>  idmapped_mounts
>  automount_in_layer
> +pseudo_datadir
> diff --git a/tools/testing/selftests/filesystems/overlayfs/Makefile b/too=
ls/testing/selftests/filesystems/overlayfs/Makefile
> index 382a59bda5e70..ace75f5627e0f 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/Makefile
> +++ b/tools/testing/selftests/filesystems/overlayfs/Makefile
> @@ -10,6 +10,7 @@ TEST_GEN_PROGS :=3D dev_in_maps
>  TEST_GEN_PROGS +=3D set_layers_via_fds
>  TEST_GEN_PROGS +=3D idmapped_mounts
>  TEST_GEN_PROGS +=3D automount_in_layer
> +TEST_GEN_PROGS +=3D pseudo_datadir
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir=
.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> new file mode 100644
> index 0000000000000..3b59fd3e9f5c2
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include "kselftest_harness.h"
> +#include "../wrappers.h"
> +
> +static int setup_tmp(void)
> +{
> +       if (unshare(CLONE_NEWNS))
> +               return -errno;
> +       if (sys_mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
> +               return -errno;
> +       if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +               return -errno;
> +       if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
> +           mkdir("/tmp/merged", 0755))
> +               return -errno;
> +       return 0;
> +}
> +
> +/* Mount an overlayfs with the legacy "lowerdir=3D" option. */
> +static int mount_lowerdir(const char *lowerdir)
> +{
> +       char opts[256];
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s", lowerdir);
> +       if (sys_mount("overlay", "/tmp/merged", "overlay", MS_RDONLY, opt=
s))
> +               return -errno;
> +       if (umount2("/tmp/merged", 0))
> +               return -errno;
> +       return 0;
> +}
> +
> +static int set_layer(int fd_context, const char *key, const char *path,
> +                    bool by_fd)
> +{
> +       int fd, ret =3D 0;
> +
> +       if (!by_fd) {
> +               if (sys_fsconfig(fd_context, FSCONFIG_SET_STRING, key, pa=
th, 0))
> +                       return -errno;
> +               return 0;
> +       }
> +
> +       fd =3D open(path, O_DIRECTORY | O_CLOEXEC);
> +       if (fd < 0)
> +               return -errno;
> +       if (sys_fsconfig(fd_context, FSCONFIG_SET_FD, key, NULL, fd))
> +               ret =3D -errno;
> +       close(fd);
> +       return ret;
> +}
> +
> +/* Create an overlayfs with "lowerdir+" and "datadir+" through fsconfig.=
 */
> +static int fsmount_layers(const char *lower, const char *data, bool by_f=
d)
> +{
> +       int fd_context, fd_mnt, ret;
> +
> +       fd_context =3D sys_fsopen("overlay", FSOPEN_CLOEXEC);
> +       if (fd_context < 0)
> +               return -errno;
> +
> +       ret =3D set_layer(fd_context, "lowerdir+", lower, by_fd);
> +       if (ret)
> +               goto out;
> +       ret =3D set_layer(fd_context, "datadir+", data, by_fd);
> +       if (ret)
> +               goto out;
> +
> +       if (sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0))=
 {
> +               ret =3D -errno;
> +               goto out;
> +       }
> +
> +       fd_mnt =3D sys_fsmount(fd_context, FSMOUNT_CLOEXEC, 0);
> +       if (fd_mnt < 0)
> +               ret =3D -errno;
> +       else
> +               close(fd_mnt);
> +out:
> +       close(fd_context);
> +       return ret;
> +}
> +
> +TEST(datadir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/sys/kernel"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", false), -EI=
NVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", true), -EIN=
VAL);
> +}
> +
> +TEST(datadir_procfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/proc"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", false), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", true), -EINVAL);
> +}
> +
> +TEST(datadir_tmpfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
> +}
> +
> +TEST(lowerdir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel:/tmp/lower"), 0);
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", true), 0);
> +}
> +
> +TEST_HARNESS_MAIN
>
> --
> 2.53.0
>

