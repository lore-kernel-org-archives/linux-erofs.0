Return-Path: <linux-erofs+bounces-3100-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C4DFF4949
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 05:43:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fkgCG1GGkz2xpt;
	Mon, 30 Mar 2026 16:43:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774849402;
	cv=none; b=cFqpBODaWbppfnfUxUWQvN614gw9sTYFmhoSxc93kVg2lLCA6JetdE7Tl3IfxW+ETczImMq9x68eSKBF+dR0gYF0pwj5A9NCpyIlf5KqsIEn1Hb18z1ByWHmantJ1Bm05nv57CoKi+/IU4m3UN5MHWYoGM9TMyukti+22R14HsdQQ4etA9ezEtfQa3Av/KCpWdpIC1mzZz7UThk4H7VNKQaxzyJ5LoP/IlZt1LIrITwJXnFVJhX60AwpeEr5My7BFsM++7X8L14EmUkUegp/oKLzXJ5GlMksXzSg5MwiS6W6wxZY9de8gWjxeML/a7W78dUD5Dwk1IWo70g7Lj/+3w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774849402; c=relaxed/relaxed;
	bh=BxMQKC6zaLOpwahiWD7u3XDlf8WTDewmUscIa5Hro6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vw1wVdgHHkUKBABUsSp2kZlTdFxpAR9YoD3D+Q0P2vyuVSohDUqDGEHZbaScmV5ldGProbi7IXjMx2IelxX5CI/0MqunbXm0WBy0Xiuz4E6S2fGKrCTjbX7VnC/ec3/0mCFk0JkVbVerjeFoWzbt2XWa3kmdY2WL4o+oh5J4HIC/z+C7rHIxYunXCO282YECivohoGk7ZnnUPkY7D/fs0Rrmm/GVsrbz8y3JYcf4COOeko9yZ7V1pAK92mlar/m+0MOJIkYNmGrq1eJbhm+EB+eYf88JJ7jpMxZCmX4NjZt/GZtWliEa1KrrKINDqrHNwMxpGs63Zwu2ki+wrVe4Lw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qiGzBV3E; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qiGzBV3E;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fkgCC53V9z2xlK
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 16:43:18 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774849393; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BxMQKC6zaLOpwahiWD7u3XDlf8WTDewmUscIa5Hro6Y=;
	b=qiGzBV3E4+C235iXEkxoVx5gk4v/Lme/JCidQrI84WaXwXaAek6sS+iORBKj63BOJBaaQSLlsBbJnosfSLyVih553mFWNH9jlSLLk3Hwu/G8aaPgtd/LAW6+uE1ZvPjZGTAzhvYEMqMtXcd7rClse+Nd0pOhO4rynDn0M+DMS30=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.uNxsG_1774849391;
Received: from 30.221.131.246(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.uNxsG_1774849391 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 13:43:13 +0800
Message-ID: <0e7b2ad8-91a6-420f-8da6-cbd95b186abd@linux.alibaba.com>
Date: Mon, 30 Mar 2026 13:43:12 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH experimental-tests] erofs-utils: tests: test FUSE error
 handling on corrupted inodes
To: Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, newajay.11r@gmail.com
References: <20260330042801.78385-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260330042801.78385-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/30 12:28, Nithurshen wrote:
> This patch introduces a regression test (erofs/099) to verify that
> the FUSE daemon gracefully handles corrupted inodes without crashing
> or violating the FUSE protocol.
> 
> Recently, a bug was identified where erofs_read_inode_from_disk()
> would fail, but erofsfuse_getattr() lacked a return statement
> after sending an error reply. This caused a fall-through, sending
> a second reply via fuse_reply_attr() and triggering a libfuse
> segmentation fault.
> 
> To prevent future regressions, this test:
> 1. Creates a valid EROFS image.
> 2. Surgically corrupts the root inode (injecting random data at
>     offset 1152) while leaving the superblock intact so it mounts.
> 3. Mounts the image in the foreground to capture daemon stderr.
> 4. Runs 'stat' to trigger the inode read failure.
> 5. Evaluates the stderr log to ensure no segfaults, aborts, or
>     "multiple replies" warnings are emitted by libfuse.
> 
> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
> ---
>   tests/Makefile.am   |  3 ++
>   tests/erofs/099     | 76 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/erofs/099.out |  2 ++
>   3 files changed, 81 insertions(+)
>   create mode 100755 tests/erofs/099
>   create mode 100644 tests/erofs/099.out
> 
> diff --git a/tests/Makefile.am b/tests/Makefile.am
> index e376d6a..c0f117c 100644
> --- a/tests/Makefile.am
> +++ b/tests/Makefile.am
> @@ -122,6 +122,9 @@ TESTS += erofs/027
>   # 028 - test inode page cache sharing functionality
>   TESTS += erofs/028
>   
> +# 099 - test fuse error handling on truncated images
> +TESTS += erofs/099
> +
>   EXTRA_DIST = common/rc erofs
>   
>   clean-local: clean-local-check
> diff --git a/tests/erofs/099 b/tests/erofs/099
> new file mode 100755
> index 0000000..952bdbd
> --- /dev/null
> +++ b/tests/erofs/099
> @@ -0,0 +1,76 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0+
> +#
> +# Test FUSE daemon error handling on corrupted inodes (missing return fix)
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS="/")
> +
> +# get standard environment, filters and checks
> +. "${srcdir}/common/rc"
> +
> +cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +	# Ensure we kill our background daemon if it's still alive
> +	[ -n "$fuse_pid" ] && kill -9 $fuse_pid 2>/dev/null
> +}
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +echo "QA output created by $seq"
> +
> +[ -z "$EROFSFUSE_PROG" ] && _notrun "erofsfuse is not available"
> +
> +if [ -z $SCRATCH_DEV ]; then
> +	SCRATCH_DEV=$tmp/erofs_$seq.img
> +	rm -f SCRATCH_DEV
> +fi
> +
> +localdir="$tmp/$seq"
> +rm -rf $localdir
> +mkdir -p $localdir
> +
> +echo "test data" > $localdir/testfile
> +
> +_scratch_mkfs $localdir >> $seqres.full 2>&1 || _fail "failed to mkfs"
> +
> +# Corrupt the root inode to force erofs_read_inode_from_disk to fail.
> +dd if=/dev/urandom of=$SCRATCH_DEV bs=1 seek=1152 count=1024 conv=notrunc >> $seqres.full 2>&1
> +
> +# Bypass _scratch_mount to run erofsfuse in the foreground (-f)
> +# This lets us capture libfuse's internal stderr warnings.
> +$EROFSFUSE_PROG -f $SCRATCH_DEV $SCRATCH_MNT > $tmp/fuse_err.log 2>&1 &

If this testcase is erofsfuse-specific, we should
check FSTYP="erofsfuse" instead, otherwise this
case should be skiped.

Otherwise if this test case can test the kernel
as well, we should make the kernel tested too.

Thanks,
Gao Xiang

