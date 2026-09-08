Return-Path: <linux-erofs+bounces-4506-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D05C79F82
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 12:12:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfN9n2j8qz2y2b;
	Tue, 08 Sep 2026 22:12:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788869565;
	cv=none; b=U86cmj3KLtyEKqpX+/JVaa5QW1htx0G0MiNk+PoAbc/+PBUi71GfwXfFTgUt+KAR6WUM3mxKQQs4UeCvkukuk22ug5JCN+dsPwvEVL8msW7EYd6aXJTkn7ovVIKAyLRC9FxusM8YDgmKTEK83Cbi2gR/8t/Iyr6XO42UF5IzaFxPKQhdEy0OZymcnB4Jm1eSIJoWV/eF6ieDMxb4/PraTjy0Ol0+7JieaEczsNQHy4acb7sQv0GJRJzB1JUvsNnVS45mFuXMbRc914KZ1UW674M/wgsjkuUQfa4i5xSyiVGAw4N8PBNkFL2sbgJIQ7pX7Dc+CWPyXpOqHyJYG9FWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788869565; c=relaxed/relaxed;
	bh=4jZ73zSFs8YrDXG0RMmU2p9sST4TMhpplgB3nL3uVw0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=LbzcSpAuj2nsyzCPgO/faaCLmPN3xD34tgb5RTiHtNzbMYw4wDaUJVMOdU03Q74z4m3N6/UPpR72mv0cGEpvvJuQeiMSPQyUzuBs5Jawy0z/bhR+ybFZuKZzRRCMwZxfxcl2/sA+B+xMsjH8eZpkuZ/ZctLufre4MoTb+ouPJSjCRjkc3fNHEHTxugSVR0iy0rSuGPx/kVD2EPrfWa4FDFWcWAsyAK1kd7AH+0s89nRSFa0KXkPvbkpsuGwRLT2fNJhyrFbCG1/iSLgWz46K2NH/pOLkPmOJh/wMFlFYYRnJrKzFU8MMAEE24tpaHn36Uet5nypeAMhAgq2A48wVtg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kQjqHlXL; dkim-atps=neutral; spf=pass (client-ip=192.198.163.18; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kQjqHlXL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.18; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfN9k0gGMz2xlJ
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 22:12:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788869562; x=1820405562;
  h=date:from:to:cc:subject:message-id;
  bh=xtQya+s8YdIgbtlsfIgCT2SrlQtmMWehPnCPpKVSUkU=;
  b=kQjqHlXLquz6RDcsCIDGaxJrC+0DwfiQtcclI10VfOzPpNu2EojrC4QC
   c1MwP/t39kpufOFldtPVKrXMySoMk2OlN/liwfVl34blm7wP2lNGZeuFE
   UU8n2gYs8F80fO+wOUHl8pHNk+3s+Y+YORDg3UetH/BdYnrXoHYn3VuFu
   /UoiQNRuBvMSerQmEpMm7j/hEyFey2z20RrSixSMPs58BZmm8waqJAIQH
   MC9lqA1tv7xc0LrDqvRN/FXKBBKohGlnIH/azs44Nl45D+AisbLMJs0um
   59jetziAyh5IB4zufoX5nvitWFepOLNATcvKOAemyUGKkalVQ/jPRw10F
   A==;
X-CSE-ConnectionGUID: gEhasWRtQJazNMjnfkRQCQ==
X-CSE-MsgGUID: ISFS12WoQ8CufaKiMTkizA==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="88419178"
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="88419178"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 05:12:35 -0700
X-CSE-ConnectionGUID: 3kt8iKcNT8at1OK2oOzk6w==
X-CSE-MsgGUID: o3E4Y/AWS86pAH/XGxJWBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="268394154"
Received: from lkp-server01.sh.intel.com (HELO dc5b8f51e05b) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 08 Sep 2026 05:12:34 -0700
Received: from kbuild by dc5b8f51e05b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3ugh-0000000005z-4BRS;
	Tue, 08 Sep 2026 12:12:31 +0000
Date: Tue, 08 Sep 2026 20:11:42 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev-test] BUILD SUCCESS
 96bf9831fbf423b8104f7948cd8fe7007ecfb46c
Message-ID: <202609082040.G2ik1ktl-lkp@intel.com>
User-Agent: s-nail v14.9.25
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

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test
branch HEAD: 96bf9831fbf423b8104f7948cd8fe7007ecfb46c  erofs: delimit inode_share cache key components

elapsed time: 1519m

configs tested: 81
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

