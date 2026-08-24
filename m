Return-Path: <linux-erofs+bounces-4338-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E8DC5DF9C
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 22:26:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTQVY2zc6z2xKh;
	Tue, 25 Aug 2026 08:26:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787610373;
	cv=none; b=iCv/bxeBYSUMtcgK5kOK2DeE9r9iigBmvSEyRNLK1oIFABctEdzpgtdq2YbEgkUROv7yn/aywtqLAuDYpgEa7O7TAwmPpoTZcPjcIdK6d1M/0u8ysNS6orPg7zzmE+Iy0l0OOoqibAx8V9PTE+kSaMaORpv8LBh+VGHlS2k+9zK2nJ1N5udZ0bgJJYLfo3daTOI19BSCsi1NaTv9RucglDIwyfiLX62vNHQSATFkyqRlFb9fwBLq/TofHvxSo3NyMzL69yPWA7Yw9OHUE7f3ybC92ITvzaG43njCVhbPktzY2jNaht33YlwzuQJzKiXGEbHfW0NnurwDtA5ByspcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787610373; c=relaxed/relaxed;
	bh=yeZeb6foz1MNn/HyKrfLgN187SkcfQEHocVs4k7s0R4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=CJKp0WspyIFIpK4DlZWMrcJTlY6V7RjME59XvMM4TGinczg49wQWFSK8DCyA5jdc35gA72SAIvUK0RdAxkuT9FyG3hEquphbUEFTCLb7HJGecC1FPm2Rp4YkZVruMYwvWnXDxp4hUzEwj0ta7fKP0D7mNEv7jRJ9QxC2SkqtPiExStsDiPKfK0JkOeHLciwVOaaJo8f0mD+iRuy/SKyW2F4qyIwjMg3m/NY6nUTFHtV3gBfxDMoVCStB/+fT8D0Cv33ybYWm+afp7h8v1J0n5wAQ+S6LK1VCDJ1IqcicUMZ5JfDFzBEeFU1Kjq6UATIUSbzMpTKeGeTejvDNbyiQVQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TNkC13Ai; dkim-atps=neutral; spf=pass (client-ip=198.175.65.21; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TNkC13Ai;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.21; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTQVS0hMkz2xJJ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 08:26:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787610368; x=1819146368;
  h=date:from:to:cc:subject:message-id;
  bh=YMm8XjxY8pDWgnGpCIjKRUCmhj1et9w2iNeuO4cBCHU=;
  b=TNkC13Ai2QRctM9MOa+EN5G6EyUcWk6gXiiDIdSWMM9ceKIDRGvkMOp4
   SbgrHDzYYka+5rdYJzc9BC++juUqjcWNiPJGP1ggZuG5r0Oaa1Zk4rbi4
   UvJOcV86keeyxRe8IMapqyNDvTauius6FqwsDWlFhX1bSMiwBGuWJ8/WH
   XmXNoIrvExXBbPRiWB8MMxNGqFdnqSY5q+43xbzjKqmn3qQFB2mem0Qgq
   xAHEVpnLdodPmWSKUcAnCyt/sW5R+BBoy0dL5fuP+mcsiOoUFEI7orLXk
   0ZTpDDT96LBM7vD17OrLYulK4y+WIHY6dVuIkqY9E9aZ06U7ARXnvSK2u
   A==;
X-CSE-ConnectionGUID: 0bZ3Pp27Qi6GYatfzLOZsg==
X-CSE-MsgGUID: ae4Z/TR4R9qv3WbLnOQVQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="87933588"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="87933588"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 15:25:55 -0700
X-CSE-ConnectionGUID: CCFaqc/1QpaJs/UCPhUYTw==
X-CSE-MsgGUID: eFBqxqjZTAe9KFOD/2VpyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="267174811"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 24 Aug 2026 15:25:54 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wyd6x-000000004Kq-117C;
	Mon, 24 Aug 2026 22:25:48 +0000
Date: Tue, 25 Aug 2026 06:23:59 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev] BUILD SUCCESS
 a7d28aa0e9b2c983b915d091f9596f0e3b253355
Message-ID: <202608250648.wSNWmASV-lkp@intel.com>
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

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev
branch HEAD: a7d28aa0e9b2c983b915d091f9596f0e3b253355  erofs: simplify z_erofs_gbuf_growsize()

elapsed time: 789m

configs tested: 28
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                  allnoconfig    gcc-16.1.0
alpha                 allyesconfig    gcc-16.1.0
alpha                    defconfig    gcc-16.1.0
arc                   allmodconfig    gcc-16.1.0
arc                   allyesconfig    gcc-16.1.0
arm64      randconfig-001-20260825    gcc-13.4.0
arm64      randconfig-002-20260825    clang-24
arm64      randconfig-003-20260825    clang-24
arm64      randconfig-004-20260825    gcc-8.5.0
csky                  allmodconfig    gcc-16.1.0
csky       randconfig-001-20260825    gcc-11.5.0
csky       randconfig-002-20260825    gcc-9.5.0
i386                  allmodconfig    gcc-14
loongarch                defconfig    clang-24
m68k            m5208evb_defconfig    gcc-16.1.0
nios2                 allmodconfig    gcc-11.5.0
nios2                  allnoconfig    gcc-11.5.0
parisc                allmodconfig    gcc-16.1.0
parisc                allyesconfig    gcc-16.1.0
parisc                   defconfig    gcc-16.1.0
riscv                 alldefconfig    gcc-16.1.0
sh                       defconfig    gcc-16.1.0
x86_64     randconfig-011-20260825    gcc-14
x86_64     randconfig-012-20260825    gcc-14
x86_64     randconfig-013-20260825    clang-22
x86_64     randconfig-014-20260825    gcc-12
x86_64     randconfig-015-20260825    gcc-14
x86_64     randconfig-016-20260825    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

