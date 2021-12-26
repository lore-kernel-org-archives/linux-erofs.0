Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF7EC433F5
	for <linux-erofs@archiver.kernel.org>; Sun, 26 Dec 2021 22:54:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JMbhp1qJsz2ybK
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Dec 2021 09:54:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=47.88.44.36;
 helo=out4436.biz.mail.alibaba.com; envelope-from=hsiangkao@linux.alibaba.com;
 receiver=<UNKNOWN>)
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
 [47.88.44.36])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JMbhg2yPgz2xZp
 for <linux-erofs@lists.ozlabs.org>; Mon, 27 Dec 2021 09:54:25 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R831e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=5; SR=0; TI=SMTPD_---0V.oTzay_1640559242; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0V.oTzay_1640559242) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 27 Dec 2021 06:54:04 +0800
Date: Mon, 27 Dec 2021 06:54:01 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: Re: [xiang-erofs:dev-test 10/10] ERROR: modpost: "__umoddi3"
 [fs/erofs/erofs.ko] undefined!
Message-ID: <YcjyiS9szZaQ93XB@B-P7TQMD6M-0146.local>
References: <202112270112.rgS0dZPa-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202112270112.rgS0dZPa-lkp@intel.com>
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
Cc: Yue Hu <huyue2@yulong.com>, kbuild-all@lists.01.org,
 kernel test robot <lkp@intel.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Dec 27, 2021 at 01:14:59AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test
> head:   9204beaeb1c1bf4eeac42df048c5bd829deedfff
> commit: 9204beaeb1c1bf4eeac42df048c5bd829deedfff [10/10] erofs: add on-disk compressed tail-packing inline support
> config: m68k-mvme16x_defconfig (https://download.01.org/0day-ci/archive/20211227/202112270112.rgS0dZPa-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git/commit/?id=9204beaeb1c1bf4eeac42df048c5bd829deedfff
>         git remote add xiang-erofs https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
>         git fetch --no-tags xiang-erofs dev-test
>         git checkout 9204beaeb1c1bf4eeac42df048c5bd829deedfff
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> ERROR: modpost: "__umoddi3" [fs/erofs/erofs.ko] undefined!

I've updated rounddown to round_down since
the divisor is pow of 2.

Thanks,
Gao Xiang

> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
