Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA09BD1A42C
	for <linux-erofs@archiver.kernel.org>; Sat, 12 Oct 2024 02:39:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XQSP06q2fz3c57
	for <linux-erofs@archiver.kernel.org>; Sat, 12 Oct 2024 13:39:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=198.175.65.18
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728700739;
	cv=none; b=hD2ocNK12Wg+MiHt73TM06D+tdpDh2EUXlphgEtRE2idXvqaMAue82iElsd/ucump3ivfD2099tqaXNGiAJsV8HMdo/QuW6MxGXtPbCHWNyYxmL7XbIr8X7+5kpWao/FtoQgmeXUCK1z1uFu5efDTdiGWb7d5ZfsnipBcw7BU/BTDKDhv2/RtMMzc6sco1CYPP6ul/jeK2jvmM0dC4iHd+i4lNCPzHe/w8Wqmv0iQ3v4okdquK1RV344JZqCJxTwMUjqdRSinTnBV5lJtVptAi/bzupNzqf5MLsa5Jx4iaffSnrKvvDa3PaOiJDMdxDibIKXWcc9OJEuXUQadAz5qg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728700739; c=relaxed/relaxed;
	bh=OW2tXKHGz/qv2M/xXfYZ6NFQGK8nkX30dqNnB8CsY9Q=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hKaHcG3f3gpWSAOnspZvGwSsdqb19cSqKksMfBbQ8BPQESQLGuQ1yE/Rmrv/4cW6uiAZzvcD33AEtiUf0j6Au3dFk848pIULk2UPE/tVixU7xKlve8DVZukeDOg7pAE5K1qx7xfcD1c4ZSz6wOJbPYP6Dot0ymvXiICguLn9O+cCw37WVjdy34k9y5mzYzWueB5ol+B1YzJFzGpvysYcbHurbg+Wd6dihP4Tt0qPfRSmPtxSMM6phhFzSAHjsRK0NbBJRfBzcYsyay82a1q59fojIuj58HUOKaNUgDulUa3zYT3db/V9sSe9ZfGO6/YccH1P4QbFuXKipvPeYEMx9w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DiaV1aXb; dkim-atps=neutral; spf=pass (client-ip=198.175.65.18; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DiaV1aXb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.18; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XQSNw6yQcz2xf2
	for <linux-erofs@lists.ozlabs.org>; Sat, 12 Oct 2024 13:38:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728700737; x=1760236737;
  h=date:from:to:cc:subject:message-id;
  bh=dNsloFqf7dMrq6FhmV4/dFK68wwlBBDrQK/1MwZDrY8=;
  b=DiaV1aXbbB/nMsBmrn58U6A4kz28+OLtQXcobs5muKbgXagHnJ7qZStZ
   txtpj9FnIq2S8FKk1JtgCf4UPKfciqGbKW0sNxH1KMdUREzWhAlGQgYH5
   uN/0VyfPMCf7E0BgoDYp/Vm3JxCbtXqaDvjxmRH1t0sXJZ/aq0+861NuL
   Um947sQ7mTzEU23SwzZmNjBet4S0BYqozwQ0MOpbJmlfmSJhcAn4Y0AVh
   EpsBJn51stDuDha1ncMGNMcup5VmAu7VchbjyNhx3DY7M8Q81I8TW/uYh
   LBFOXgZRd1Z43OkyN6O6cY5OoU71JXoE72YT2OlQTFHN+bAjB3qqXTBSj
   A==;
X-CSE-ConnectionGUID: AolmJmalSGadRu+F/Abpbg==
X-CSE-MsgGUID: 3Ac+UeskSnCWtkDb4g/Irw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28243219"
X-IronPort-AV: E=Sophos;i="6.11,197,1725346800"; 
   d="scan'208";a="28243219"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 19:38:50 -0700
X-CSE-ConnectionGUID: PwUSwErYS3mqpLbAMPFVlA==
X-CSE-MsgGUID: zZil/UfbTwmU6z+eRK7Sow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,197,1725346800"; 
   d="scan'208";a="81855931"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 11 Oct 2024 19:38:49 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1szS1m-000CyB-2U;
	Sat, 12 Oct 2024 02:38:46 +0000
Date: Sat, 12 Oct 2024 10:38:13 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [xiang-erofs:dev-test] BUILD SUCCESS
 ae54567eaa87fd863ab61084a3828e1c36b0ffb0
Message-ID: <202410121059.k0UNETjt-lkp@intel.com>
User-Agent: s-nail v14.9.24
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test
branch HEAD: ae54567eaa87fd863ab61084a3828e1c36b0ffb0  erofs: get rid of kaddr in `struct z_erofs_maprecorder`

elapsed time: 1200m

configs tested: 94
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-14.1.0
alpha                            allyesconfig    clang-20
alpha                               defconfig    gcc-14.1.0
arc                              allmodconfig    clang-20
arc                               allnoconfig    gcc-14.1.0
arc                              allyesconfig    clang-20
arc                                 defconfig    gcc-14.1.0
arm                              allmodconfig    clang-20
arm                               allnoconfig    gcc-14.1.0
arm                              allyesconfig    clang-20
arm                                 defconfig    gcc-14.1.0
arm64                            allmodconfig    clang-20
arm64                             allnoconfig    gcc-14.1.0
arm64                               defconfig    gcc-14.1.0
csky                              allnoconfig    gcc-14.1.0
csky                                defconfig    gcc-14.1.0
hexagon                          allmodconfig    clang-20
hexagon                           allnoconfig    gcc-14.1.0
hexagon                          allyesconfig    clang-20
hexagon                             defconfig    gcc-14.1.0
i386                             allmodconfig    clang-18
i386                              allnoconfig    clang-18
i386                             allyesconfig    clang-18
i386        buildonly-randconfig-001-20241012    gcc-12
i386        buildonly-randconfig-002-20241012    gcc-12
i386        buildonly-randconfig-003-20241012    gcc-12
i386        buildonly-randconfig-004-20241012    gcc-12
i386        buildonly-randconfig-005-20241012    gcc-12
i386        buildonly-randconfig-006-20241012    gcc-12
i386                                defconfig    clang-18
i386                  randconfig-001-20241012    gcc-12
i386                  randconfig-002-20241012    gcc-12
i386                  randconfig-003-20241012    gcc-12
i386                  randconfig-004-20241012    gcc-12
i386                  randconfig-005-20241012    gcc-12
i386                  randconfig-006-20241012    gcc-12
i386                  randconfig-011-20241012    gcc-12
i386                  randconfig-012-20241012    gcc-12
i386                  randconfig-013-20241012    gcc-12
i386                  randconfig-014-20241012    gcc-12
i386                  randconfig-015-20241012    gcc-12
i386                  randconfig-016-20241012    gcc-12
loongarch                        allmodconfig    gcc-14.1.0
loongarch                         allnoconfig    gcc-14.1.0
loongarch                           defconfig    gcc-14.1.0
m68k                             allmodconfig    gcc-14.1.0
m68k                              allnoconfig    gcc-14.1.0
m68k                             allyesconfig    gcc-14.1.0
m68k                                defconfig    gcc-14.1.0
microblaze                       allmodconfig    gcc-14.1.0
microblaze                        allnoconfig    gcc-14.1.0
microblaze                       allyesconfig    gcc-14.1.0
microblaze                          defconfig    gcc-14.1.0
mips                              allnoconfig    gcc-14.1.0
nios2                             allnoconfig    gcc-14.1.0
nios2                               defconfig    gcc-14.1.0
openrisc                          allnoconfig    clang-20
openrisc                         allyesconfig    gcc-14.1.0
openrisc                            defconfig    gcc-12
parisc                           allmodconfig    gcc-14.1.0
parisc                            allnoconfig    clang-20
parisc                           allyesconfig    gcc-14.1.0
parisc                              defconfig    gcc-12
parisc64                            defconfig    gcc-14.1.0
powerpc                          allmodconfig    gcc-14.1.0
powerpc                           allnoconfig    clang-20
powerpc                          allyesconfig    gcc-14.1.0
riscv                            allmodconfig    gcc-14.1.0
riscv                             allnoconfig    clang-20
riscv                            allyesconfig    gcc-14.1.0
riscv                               defconfig    gcc-12
s390                             allmodconfig    gcc-14.1.0
s390                              allnoconfig    clang-20
s390                             allyesconfig    gcc-14.1.0
s390                                defconfig    gcc-12
sh                               allmodconfig    gcc-14.1.0
sh                                allnoconfig    gcc-14.1.0
sh                               allyesconfig    gcc-14.1.0
sh                                  defconfig    gcc-12
sparc                            allmodconfig    gcc-14.1.0
sparc64                             defconfig    gcc-12
um                               allmodconfig    clang-20
um                                allnoconfig    clang-20
um                               allyesconfig    clang-20
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-18
x86_64                           allyesconfig    clang-18
x86_64                              defconfig    clang-18
x86_64                                  kexec    gcc-12
x86_64                               rhel-8.3    gcc-12
x86_64                          rhel-8.3-rust    clang-18
xtensa                            allnoconfig    gcc-14.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
