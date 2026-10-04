Return-Path: <linux-erofs+bounces-4658-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E1BCA5FE4
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Oct 2026 04:30:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hy8hw1qzZz2yjp;
	Sun, 04 Oct 2026 15:30:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791088256;
	cv=none; b=T6u59kPfarNSnR71Q/zyVPG2KTU+PFxEPXmADOHIM/4tYMK5293dqMTTKko2vVtnhEemdE1ezaZ/w1sqi/yrXO7CxyFh13KL/Wze2GF8g5kMKzeGLC0e8Bz0Nfji/2CJ3LxVjQAponIU7wSDXZpN4UWI6cGE7iFehKVVfO0vGh0ugvLi96t2UCONJvolpZH5QPqjbi3lCNkuj+vvFjht+D0F55PZfUeKtuOVuvBXhRT4mvj+WLNgEdfE4jSwJXz0m30Xy/pMZ//gK/8pjOJg7rl88kVnd15mL7Vou/5S5qMwMWcWJ3dnx46c7EzxsjnEPmh0hrbBCn55/S4OLJUPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791088256; c=relaxed/relaxed;
	bh=2NYFOUXv6Dp2VnorW0+krz5CedXSioA8GQJKfQbDjmU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=kPInVJWREnCuICaEceeVxXmTM+naKNAPM1wttj2CU+eTLo6OPiGimq+NrDqW+j98hW10YGJ6RSUHyPE4HBlXP6nLpo2JfjrOz/k929vZOdP24jujvsKG54Q9c6XXf5zpmA/tLWi4TBUpajOevz5VMV/dmKGPTirSRPa1w/zOi8smjP9JURudgFaXVCny1SjVrd2/OjOgJxoMTPBz5gzjnq/ugZB139bsoIlMET6MsUzCLpIu08YleDR4y19Lltt2vC827XVpFLpVaUjvXUMzbsJsXtnzqS0+VUC6m3f5tauqYdCxs6jqnj/6/F8tIfNVm5eY6fByXW98WRDLh0rOPw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aq8eR5Oj; dkim-atps=neutral; spf=pass (client-ip=192.198.163.16; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aq8eR5Oj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.16; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hy8hs4TtKz2y2K
	for <linux-erofs@lists.ozlabs.org>; Sun, 04 Oct 2026 15:30:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791088254; x=1822624254;
  h=date:from:to:cc:subject:message-id;
  bh=PKeKjjPCYXSrGVNlc7XnW5leK1Gi6+nCJT8xQFSMbFo=;
  b=aq8eR5Oj0QpCW9kUaug58EWPLNNCiFqDlJ3IFNV77mBE5e+GDSV3YqbO
   zU3amMUAdnRYsvyDaZF5SrgV0yJQxqzCnZzjzPlVDeBVPPOw3mScBqOj0
   UfBE2/UuKaF1N+GMLqzlqT7/Q+PhnjIhkHePd6ow1LmycoqJB/VLiT0fb
   MPe3VE5v5nylGuTTjEJyDGx83WTsTBLAM5P56CYHqAKRvYKVGW7ESTIlu
   GnRnrdb5nqL0A1vlPi+L6Db2lVu54XXsY+JoYGKnUOePJn3A+z9gxcv9H
   YsACFCXurVkeh/UB5PsFeyd2+tCqhCwRr0m6vpoXGYBiOKDcGoaJmznEb
   A==;
X-CSE-ConnectionGUID: u5XxG1xkRQeEqfmo4zMNBA==
X-CSE-MsgGUID: ZdBk9z2MTzixi5Ow3hinsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11924"; a="79355724"
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="79355724"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2026 21:30:48 -0700
X-CSE-ConnectionGUID: rc7EBezjQ5eaaiU81Zzm7g==
X-CSE-MsgGUID: zgDJN3MDTDCkxCVwya/4Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="276089295"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 03 Oct 2026 21:30:46 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDDs4-00000000USb-2aCV;
	Sun, 04 Oct 2026 04:30:44 +0000
Date: Sun, 04 Oct 2026 12:29:47 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev-test] BUILD SUCCESS
 6ad72f8c839a25b83d5aeaa65c233602151bca44
Message-ID: <202610041244.Yz8BqHdV-lkp@intel.com>
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
branch HEAD: 6ad72f8c839a25b83d5aeaa65c233602151bca44  MAINTAINERS: erofs: update my email address

elapsed time: 1374m

configs tested: 449
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2303-20261003    gcc-8.5.0  sparse
arc                               alldefconfig    clang-24
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                  nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261003    clang-17
arc                   randconfig-1000-20261004    clang-22
arc                   randconfig-1001-20261003    clang-17
arc                   randconfig-1001-20261004    clang-22
arc                  randconfig-r2103-20261003    gcc-11.5.0 cocci
arc                  randconfig-r2105-20261003    gcc-8.5.0  cocci
arc                  randconfig-r2106-20261003    gcc-8.5.0  cocci
arc                  randconfig-r2300-20261002    gcc-14     sparse
arc                  randconfig-r2301-20261003    gcc-14     sparse
arc                  randconfig-r2302-20261003    gcc-13.4.0 sparse
arc                  randconfig-r2306-20261002    gcc-16.1.0 sparse
arc                  randconfig-r2309-20261002    gcc-8.5.0  sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                           collie_defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    clang-24
arm                       jornada720_defconfig    clang-24
arm                          nhk8815_defconfig    clang-24
arm                              pxa_defconfig    clang-24
arm                             qcom_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261003    clang-17
arm                   randconfig-1000-20261004    clang-22
arm                   randconfig-1001-20261003    clang-17
arm                   randconfig-1001-20261004    clang-22
arm                   randconfig-1002-20261003    clang-17
arm                   randconfig-1002-20261004    clang-22
arm                   randconfig-1003-20261003    clang-17
arm                   randconfig-1003-20261004    clang-22
arm                  randconfig-r2103-20261003    gcc-14     cocci
arm                  randconfig-r2104-20261003    gcc-15.2.0 cocci
arm                  randconfig-r2106-20261002    gcc-16.1.0 cocci
arm                  randconfig-r2309-20261003    gcc-8.5.0  sparse
arm                          s3c6400_defconfig    gcc-16.1.0
arm                          socfpga_defconfig    clang-24
arm                     vt8500_v6_v7_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261003    gcc-9.5.0
arm64                 randconfig-1000-20261004    gcc-16.1.0
arm64                 randconfig-1001-20261003    gcc-9.5.0
arm64                 randconfig-1001-20261004    gcc-16.1.0
arm64                 randconfig-1002-20261003    gcc-9.5.0
arm64                 randconfig-1002-20261004    gcc-16.1.0
arm64                 randconfig-1003-20261003    gcc-9.5.0
arm64                 randconfig-1003-20261004    gcc-16.1.0
arm64                randconfig-r2104-20261003    gcc-11.5.0 cocci
arm64                randconfig-r2106-20261003    clang-19   cocci
arm64                randconfig-r2200-20261003    gcc-16.1.0 smatch
arm64                randconfig-r2202-20261003    clang-24   smatch
arm64                randconfig-r2309-20261002    gcc-16.1.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261003    gcc-9.5.0
csky                  randconfig-1000-20261004    gcc-16.1.0
csky                  randconfig-1001-20261003    gcc-9.5.0
csky                  randconfig-1001-20261004    gcc-16.1.0
csky                 randconfig-r2106-20261003    gcc-15.2.0 cocci
csky                 randconfig-r2300-20261003    gcc-14     sparse
csky                 randconfig-r2307-20261003    gcc-11.5.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261003    gcc-16.1.0
hexagon               randconfig-1000-20261004    gcc-16.1.0
hexagon               randconfig-1001-20261003    gcc-16.1.0
hexagon               randconfig-1001-20261004    gcc-16.1.0
hexagon              randconfig-r2100-20261003    gcc-11.5.0 cocci
hexagon              randconfig-r2105-20261003    clang-19   cocci
hexagon              randconfig-r2107-20261003    clang-19   cocci
hexagon              randconfig-r2202-20261002    clang-18   smatch
hexagon              randconfig-r2304-20261003    gcc-14     sparse
hexagon              randconfig-r2307-20261003    gcc-16.1.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261003    gcc-14
i386        buildonly-randconfig-1000-20261004    clang-22
i386        buildonly-randconfig-1001-20261003    gcc-14
i386        buildonly-randconfig-1001-20261004    clang-22
i386        buildonly-randconfig-1002-20261003    gcc-14
i386        buildonly-randconfig-1002-20261004    clang-22
i386        buildonly-randconfig-1003-20261003    gcc-14
i386        buildonly-randconfig-1003-20261004    clang-22
i386        buildonly-randconfig-1004-20261003    gcc-14
i386        buildonly-randconfig-1004-20261004    clang-22
i386        buildonly-randconfig-1005-20261003    gcc-14
i386        buildonly-randconfig-1005-20261004    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261003    gcc-14
i386                  randconfig-1000-20261004    gcc-14
i386                  randconfig-1001-20261003    gcc-14
i386                  randconfig-1001-20261004    gcc-14
i386                  randconfig-1002-20261003    gcc-14
i386                  randconfig-1002-20261004    gcc-14
i386                  randconfig-1003-20261003    gcc-14
i386                  randconfig-1003-20261004    gcc-14
i386                  randconfig-1004-20261003    gcc-14
i386                  randconfig-1004-20261004    gcc-14
i386                  randconfig-1005-20261003    gcc-14
i386                  randconfig-1005-20261004    gcc-14
i386                  randconfig-1006-20261003    gcc-14
i386                  randconfig-1006-20261004    gcc-14
i386                  randconfig-1007-20261003    gcc-14
i386                  randconfig-1007-20261004    clang-22
i386                  randconfig-1008-20261003    gcc-14
i386                  randconfig-1008-20261004    clang-22
i386                  randconfig-1009-20261003    gcc-14
i386                  randconfig-1009-20261004    clang-22
i386                  randconfig-1010-20261003    gcc-14
i386                  randconfig-1010-20261004    clang-22
i386                  randconfig-1011-20261003    gcc-14
i386                  randconfig-1011-20261004    clang-22
i386                  randconfig-1012-20261003    gcc-14
i386                  randconfig-1012-20261004    clang-22
i386                  randconfig-1013-20261003    gcc-14
i386                  randconfig-1013-20261004    clang-22
i386                  randconfig-2100-20261002    gcc-14     cocci
i386                  randconfig-2100-20261003    gcc-14     cocci
i386                  randconfig-2101-20261002    clang-22   cocci
i386                  randconfig-2101-20261002    gcc-14     cocci
i386                  randconfig-2101-20261003    gcc-14     cocci
i386                  randconfig-2102-20261002    gcc-14     cocci
i386                  randconfig-2102-20261003    gcc-14     cocci
i386                  randconfig-2103-20261002    gcc-14     cocci
i386                  randconfig-2103-20261003    gcc-14     cocci
i386                  randconfig-2200-20261002    gcc-14     smatch
i386                  randconfig-2200-20261003    gcc-14     smatch
i386                  randconfig-2200-20261004    clang-22   smatch
i386                  randconfig-2300-20261002    gcc-12     sparse
i386                  randconfig-2300-20261003    clang-22   sparse
i386                  randconfig-2301-20261002    gcc-12     sparse
i386                  randconfig-2301-20261003    clang-22   sparse
i386                  randconfig-2302-20261002    gcc-12     sparse
i386                  randconfig-2302-20261003    clang-22   sparse
i386                 randconfig-r2103-20261003    gcc-13.4.0 cocci
i386                 randconfig-r2306-20261003    gcc-8.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261003    gcc-16.1.0
loongarch             randconfig-1000-20261004    gcc-16.1.0
loongarch             randconfig-1001-20261003    gcc-16.1.0
loongarch             randconfig-1001-20261004    gcc-16.1.0
loongarch            randconfig-r2102-20261003    gcc-13.4.0 cocci
loongarch            randconfig-r2200-20261002    gcc-16.1.0 smatch
loongarch            randconfig-r2201-20261003    gcc-16.1.0 smatch
loongarch            randconfig-r2305-20261002    gcc-14     sparse
loongarch            randconfig-r2306-20261002    clang-22   sparse
loongarch            randconfig-r2307-20261003    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                          apollo_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                 randconfig-r2103-20261002    clang-17   cocci
m68k                 randconfig-r2301-20261003    gcc-14     sparse
m68k                 randconfig-r2304-20261003    gcc-13.4.0 sparse
m68k                 randconfig-r2306-20261003    gcc-16.1.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2200-20261003    gcc-8.5.0  smatch
microblaze           randconfig-r2301-20261003    gcc-8.5.0  sparse
microblaze           randconfig-r2307-20261002    gcc-16.1.0 sparse
microblaze           randconfig-r2308-20261002    gcc-13.4.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    gcc-16.1.0
mips                            ip32_defconfig    gcc-16.1.0
mips                 malta_qemu_32r6_defconfig    gcc-16.1.0
mips                 randconfig-r2101-20261003    gcc-13.4.0 cocci
mips                 randconfig-r2102-20261003    gcc-8.5.0  cocci
mips                 randconfig-r2300-20261003    gcc-14     sparse
mips                 randconfig-r2303-20261003    gcc-13.4.0 sparse
mips                 randconfig-r2309-20261003    gcc-16.1.0 sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261003    gcc-16.1.0
nios2                 randconfig-1000-20261004    gcc-16.1.0
nios2                 randconfig-1001-20261003    gcc-16.1.0
nios2                 randconfig-1001-20261004    gcc-16.1.0
nios2                randconfig-r2100-20261003    gcc-14     cocci
nios2                randconfig-r2101-20261002    clang-17   cocci
nios2                randconfig-r2101-20261003    gcc-14     cocci
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2104-20261003    gcc-8.5.0  cocci
openrisc             randconfig-r2200-20261004    gcc-11.5.0 smatch
openrisc             randconfig-r2202-20261003    gcc-12.5.0 smatch
openrisc             randconfig-r2300-20261003    gcc-8.5.0  sparse
openrisc             randconfig-r2306-20261003    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                 generic-32bit_defconfig    gcc-16.1.0
parisc                randconfig-1000-20261003    gcc-11.5.0
parisc                randconfig-1000-20261004    gcc-12.5.0
parisc                randconfig-1001-20261003    gcc-11.5.0
parisc                randconfig-1001-20261004    gcc-12.5.0
parisc               randconfig-r2101-20261003    gcc-8.5.0  cocci
parisc               randconfig-r2104-20261002    gcc-16.1.0 cocci
parisc               randconfig-r2202-20261003    gcc-14.3.0 smatch
parisc               randconfig-r2304-20261003    gcc-8.5.0  sparse
parisc               randconfig-r2305-20261003    gcc-8.5.0  sparse
parisc64                          alldefconfig    gcc-16.1.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                      kmeter1_defconfig    gcc-16.1.0
powerpc                      powernv_defconfig    clang-24
powerpc               randconfig-1000-20261003    gcc-11.5.0
powerpc               randconfig-1000-20261004    gcc-12.5.0
powerpc               randconfig-1001-20261003    gcc-11.5.0
powerpc               randconfig-1001-20261004    gcc-12.5.0
powerpc              randconfig-r2102-20261002    clang-17   cocci
powerpc              randconfig-r2107-20261003    gcc-11.5.0 cocci
powerpc              randconfig-r2303-20261002    gcc-14     sparse
powerpc64             randconfig-1000-20261003    gcc-11.5.0
powerpc64             randconfig-1000-20261004    gcc-12.5.0
powerpc64             randconfig-1001-20261003    gcc-11.5.0
powerpc64             randconfig-1001-20261004    gcc-12.5.0
powerpc64            randconfig-r2106-20261003    gcc-11.5.0 cocci
powerpc64            randconfig-r2300-20261003    gcc-13.4.0 sparse
powerpc64            randconfig-r2302-20261003    gcc-14     sparse
powerpc64            randconfig-r2309-20261003    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261003    gcc-12.5.0
riscv                 randconfig-1000-20261004    gcc-11.5.0
riscv                 randconfig-1001-20261003    gcc-12.5.0
riscv                 randconfig-1001-20261004    gcc-11.5.0
riscv                 randconfig-2000-20261002    gcc-9.5.0
riscv                 randconfig-2000-20261003    gcc-16.1.0
riscv                 randconfig-2000-20261004    gcc-11.5.0
riscv                 randconfig-2001-20261002    gcc-9.5.0
riscv                 randconfig-2001-20261003    gcc-16.1.0
riscv                 randconfig-2001-20261004    gcc-11.5.0
riscv                randconfig-r2102-20261003    gcc-11.5.0 cocci
riscv                randconfig-r2201-20261003    clang-24   smatch
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261003    gcc-12.5.0
s390                  randconfig-1000-20261004    gcc-11.5.0
s390                  randconfig-1001-20261003    gcc-12.5.0
s390                  randconfig-1001-20261004    gcc-11.5.0
s390                  randconfig-2000-20261002    gcc-9.5.0
s390                  randconfig-2000-20261003    gcc-16.1.0
s390                  randconfig-2000-20261004    gcc-11.5.0
s390                  randconfig-2001-20261002    gcc-9.5.0
s390                  randconfig-2001-20261003    gcc-16.1.0
s390                  randconfig-2001-20261004    gcc-11.5.0
s390                 randconfig-r2100-20261002    clang-17   cocci
s390                 randconfig-r2103-20261003    gcc-8.5.0  cocci
s390                 randconfig-r2305-20261003    gcc-14     sparse
s390                 randconfig-r2309-20261003    gcc-11.5.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261003    gcc-12.5.0
sh                    randconfig-1000-20261004    gcc-11.5.0
sh                    randconfig-1001-20261003    gcc-12.5.0
sh                    randconfig-1001-20261004    gcc-11.5.0
sh                    randconfig-2000-20261002    gcc-9.5.0
sh                    randconfig-2000-20261003    gcc-16.1.0
sh                    randconfig-2000-20261004    gcc-11.5.0
sh                    randconfig-2001-20261002    gcc-9.5.0
sh                    randconfig-2001-20261003    gcc-16.1.0
sh                    randconfig-2001-20261004    gcc-11.5.0
sh                   randconfig-r2201-20261003    gcc-16.1.0 smatch
sh                   randconfig-r2301-20261003    gcc-13.4.0 sparse
sh                   randconfig-r2306-20261003    clang-24   sparse
sh                            se7724_defconfig    gcc-16.1.0
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sh                         sh7785lcr_defconfig    gcc-16.1.0
sparc                             alldefconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261003    clang-17
sparc                 randconfig-1000-20261004    gcc-14
sparc                 randconfig-1001-20261003    clang-17
sparc                 randconfig-1001-20261004    gcc-14
sparc                 randconfig-2000-20261002    clang-24
sparc                 randconfig-2000-20261003    gcc-14
sparc                 randconfig-2001-20261002    clang-24
sparc                 randconfig-2001-20261003    gcc-14
sparc                randconfig-r2101-20261003    gcc-11.5.0 cocci
sparc                randconfig-r2105-20261003    gcc-11.5.0 cocci
sparc                randconfig-r2107-20261002    gcc-16.1.0 cocci
sparc                randconfig-r2201-20261002    gcc-8.5.0  smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261003    clang-17
sparc64               randconfig-1000-20261004    gcc-14
sparc64               randconfig-1001-20261003    clang-17
sparc64               randconfig-1001-20261004    gcc-14
sparc64               randconfig-2000-20261002    clang-24
sparc64               randconfig-2000-20261003    gcc-14
sparc64               randconfig-2001-20261002    clang-24
sparc64               randconfig-2001-20261003    gcc-14
sparc64              randconfig-r2100-20261003    gcc-8.5.0  cocci
sparc64              randconfig-r2105-20261002    gcc-16.1.0 cocci
sparc64              randconfig-r2202-20261004    clang-20   smatch
sparc64              randconfig-r2302-20261002    gcc-14     sparse
sparc64              randconfig-r2302-20261003    gcc-8.5.0  sparse
sparc64              randconfig-r2305-20261003    gcc-13.4.0 sparse
sparc64              randconfig-r2308-20261002    gcc-16.1.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261003    clang-17
um                    randconfig-1000-20261004    gcc-14
um                    randconfig-1001-20261003    clang-17
um                    randconfig-1001-20261004    gcc-14
um                    randconfig-2000-20261002    clang-24
um                    randconfig-2000-20261003    gcc-14
um                    randconfig-2001-20261002    clang-24
um                    randconfig-2001-20261003    gcc-14
um                   randconfig-r2104-20261003    clang-19   cocci
um                   randconfig-r2201-20261004    gcc-14     smatch
um                   randconfig-r2301-20261002    gcc-14     sparse
um                   randconfig-r2304-20261003    gcc-14     sparse
um                   randconfig-r2308-20261003    clang-24   sparse
um                   randconfig-r2308-20261003    gcc-11.5.0 sparse
um                   randconfig-r2308-20261003    gcc-16.1.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261003    clang-22
x86_64      buildonly-randconfig-1000-20261004    gcc-14
x86_64      buildonly-randconfig-1001-20261003    clang-22
x86_64      buildonly-randconfig-1001-20261004    gcc-14
x86_64      buildonly-randconfig-1002-20261003    clang-22
x86_64      buildonly-randconfig-1002-20261004    gcc-14
x86_64      buildonly-randconfig-1003-20261003    clang-22
x86_64      buildonly-randconfig-1003-20261004    gcc-14
x86_64      buildonly-randconfig-1004-20261003    clang-22
x86_64      buildonly-randconfig-1004-20261004    gcc-14
x86_64      buildonly-randconfig-1005-20261003    clang-22
x86_64      buildonly-randconfig-1005-20261004    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261003    clang-22
x86_64                randconfig-1000-20261004    gcc-14
x86_64                randconfig-1001-20261003    clang-22
x86_64                randconfig-1001-20261004    gcc-14
x86_64                randconfig-1002-20261003    clang-22
x86_64                randconfig-1002-20261004    gcc-14
x86_64                randconfig-1003-20261003    clang-22
x86_64                randconfig-1003-20261004    gcc-14
x86_64                randconfig-1004-20261003    clang-22
x86_64                randconfig-1004-20261004    gcc-14
x86_64                randconfig-1005-20261003    clang-22
x86_64                randconfig-1005-20261004    gcc-14
x86_64                randconfig-1006-20261003    clang-22
x86_64                randconfig-1006-20261004    clang-22
x86_64                randconfig-1007-20261003    clang-22
x86_64                randconfig-1007-20261004    clang-22
x86_64                randconfig-1008-20261003    clang-22
x86_64                randconfig-1008-20261004    clang-22
x86_64                randconfig-1009-20261003    clang-22
x86_64                randconfig-1009-20261004    clang-22
x86_64                randconfig-1010-20261003    clang-22
x86_64                randconfig-1010-20261004    clang-22
x86_64                randconfig-1011-20261003    clang-22
x86_64                randconfig-1011-20261004    clang-22
x86_64                randconfig-1012-20261003    clang-22
x86_64                randconfig-1013-20261003    clang-22
x86_64                randconfig-1014-20261003    clang-22
x86_64                randconfig-1015-20261003    clang-22
x86_64                randconfig-1016-20261003    clang-22
x86_64                randconfig-1017-20261003    clang-22
x86_64                randconfig-2100-20261002    gcc-14     cocci
x86_64                randconfig-2100-20261003    clang-22   cocci
x86_64                randconfig-2101-20261002    gcc-14     cocci
x86_64                randconfig-2101-20261003    clang-22   cocci
x86_64                randconfig-2102-20261002    gcc-14     cocci
x86_64                randconfig-2102-20261003    clang-22   cocci
x86_64                randconfig-2103-20261002    gcc-14     cocci
x86_64                randconfig-2103-20261003    clang-22   cocci
x86_64                randconfig-2200-20261003    gcc-14     smatch
x86_64                randconfig-2200-20261004    gcc-14     smatch
x86_64                randconfig-2300-20261002    gcc-12     sparse
x86_64                randconfig-2300-20261003    clang-22   sparse
x86_64                randconfig-2301-20261002    gcc-12     sparse
x86_64                randconfig-2301-20261003    clang-22   sparse
x86_64                randconfig-2302-20261002    gcc-12     sparse
x86_64                randconfig-2302-20261003    clang-22   sparse
x86_64               randconfig-r2102-20261003    gcc-14     cocci
x86_64               randconfig-r2201-20261003    clang-22   smatch
x86_64               randconfig-r2303-20261003    gcc-14     sparse
x86_64               randconfig-r2305-20261003    gcc-14     sparse
x86_64               randconfig-r2307-20261002    clang-22   sparse
x86_64               randconfig-r2308-20261003    gcc-8.5.0  sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261003    clang-17
xtensa                randconfig-1000-20261004    gcc-14
xtensa                randconfig-1001-20261003    clang-17
xtensa                randconfig-1001-20261004    gcc-14
xtensa                randconfig-2000-20261002    clang-24
xtensa                randconfig-2000-20261003    gcc-14
xtensa                randconfig-2001-20261002    clang-24
xtensa                randconfig-2001-20261003    gcc-14
xtensa               randconfig-r2100-20261003    gcc-13.4.0 cocci
xtensa               randconfig-r2105-20261003    gcc-15.2.0 cocci
xtensa               randconfig-r2107-20261003    gcc-15.2.0 cocci
xtensa               randconfig-r2107-20261003    gcc-8.5.0  cocci
xtensa               randconfig-r2200-20261003    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261003    gcc-14     sparse
xtensa               randconfig-r2304-20261002    gcc-14     sparse
xtensa               randconfig-r2307-20261003    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

