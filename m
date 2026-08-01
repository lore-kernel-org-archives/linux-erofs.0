Return-Path: <linux-erofs+bounces-4077-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598FAC5516F
	for <linux-erofs@archiver.kernel.org>; Sat,  1 Aug 2026 22:06:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hCH8S2dsVz2xlw;
	Sun, 02 Aug 2026 08:06:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785621992;
	cv=none; b=j51yjAPCh0yiDB50VCNENcBbg9UHFp7h96LJ8YQUaLLkRypOPSAEmZeQ2bOLNqCLw8vJ6oJsZ/LhVnrCI3WUIEsI9B/GPkQC0NLWImJ/NcazoyLYdBRnLgBQYvzao8f6TQNlofvYYVr5dx9RT+qk4tD1DJw2/qHUHFECz1JrkqxEFBskhfuZv/mJdoc0ow/msWp8YsE5WnhfAYbhQnQY8CeusB26rxFPiINPeMCTpVwATbzRVmjKpbyw3cjGv9GSCCCr50hpNM/u+YfTzBt4g52dpqMiFcRAyKrqA4555ono11dw6T01bWZKaak/B2PF+H3TCyZSJEXGOfbW5EmCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785621992; c=relaxed/relaxed;
	bh=H4dfm4Rl61ZvqTQutTBUCrqsmNfWF3Yb5y3RCcTRLR4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=YrILiaHwGEWEdpjxK6lfSEDK6aMiDIeRX63F9QSkr6IIrxO0sEQOzliAWICoW0DqwUGwzgiY2xXv4OC6Am1mQ+B4WEmpidcK+VaGOgb2d8Z9uiso5YmDDj2IPDkpwmlU+SVW19oOnUqYAY2ea6jmW6ue99SlBJk2vP9d9TKdgBKXPxuj0aqjqtvHH2UKmB/b4uKvOOM9xvZ5D+EWyBhmnpRzVEcpyIxNA4urYLq+LRZguLVLNELAPwnESWmEtCMvXCxDWfuYBRTtVVbagYO8RYkewAZsYApoq4gPRh3fIV8YgrpzXpzblSmE4Gp15r+Z+/Lz7WbRPweE+IA9PzY43Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IR0OmyjF; dkim-atps=neutral; spf=pass (client-ip=198.175.65.11; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IR0OmyjF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.11; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hCH8N6YFSz2xRs
	for <linux-erofs@lists.ozlabs.org>; Sun, 02 Aug 2026 08:06:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785621990; x=1817157990;
  h=date:from:to:cc:subject:message-id;
  bh=neXU8nBSjxSVRTri9JnCh0YwppfuRoYj8efbh8JPTF8=;
  b=IR0OmyjFUokG5bEtPily4Zw/xCKcfaezPxSdFQ+LWdN1Xm8vfw2LimyN
   a1AvJ1Duk8JE4pJ/TMHdvY5Nrqnr3LJUSafQqWmY6+b/AJlZV1UK42oo1
   dKs35zE8rD9J6YftypT+/Ao8IkV2MrL/58Anb9ZIRsmHpHuabQN5QFO8u
   DPTkDygL/ar8sSRBxTP+DACoeKAH/cqpD8iD4PTOhJ1wa+nRabiLC4Sz/
   tDs+L7XLfSKS2yYZMbik+Y+UWZ33xUbdQWFoL6AnkrlcmAlE/zx8YTthz
   tGirmwBok2UCbwaUiAZOfGqXlhDt425FgLNVYDGqi1efH4MPB/LOobqmK
   g==;
X-CSE-ConnectionGUID: e0uPOx/KRT2skdg4/dY4rA==
X-CSE-MsgGUID: eVSor29IRBeWDbVAjcaaHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11862"; a="96570827"
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="96570827"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2026 15:06:21 -0700
X-CSE-ConnectionGUID: LRGU92b5TDyoRWRnkINBnw==
X-CSE-MsgGUID: 5DBzX0dsS56ZWaxSaTvGMA==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 01 Aug 2026 15:06:18 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqHqS-000000003xJ-2Yx7;
	Sat, 01 Aug 2026 22:06:16 +0000
Date: Sun, 02 Aug 2026 06:05:51 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev-test] BUILD SUCCESS
 8e4b6b4af0d15c6ee95e6f4a1b29a4d5dfb97cfd
Message-ID: <202608020637.co0MEl5z-lkp@intel.com>
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
branch HEAD: 8e4b6b4af0d15c6ee95e6f4a1b29a4d5dfb97cfd  erofs: fix typo in error messages

elapsed time: 759m

configs tested: 197
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260801    gcc-12.5.0
arc                  randconfig-001-20260801    gcc-14.3.0
arc                  randconfig-001-20260802    gcc-15.2.0
arc                  randconfig-002-20260801    gcc-12.5.0
arc                  randconfig-002-20260802    gcc-15.2.0
arm                       keystone_defconfig    gcc-16.1.0
arm                  randconfig-001-20260801    clang-24
arm                  randconfig-001-20260801    gcc-12.5.0
arm                  randconfig-001-20260802    gcc-15.2.0
arm                  randconfig-002-20260801    gcc-12.5.0
arm                  randconfig-002-20260801    gcc-8.5.0
arm                  randconfig-002-20260802    gcc-15.2.0
arm                  randconfig-003-20260801    gcc-12.5.0
arm                  randconfig-003-20260802    gcc-15.2.0
arm                  randconfig-004-20260801    clang-18
arm                  randconfig-004-20260801    gcc-12.5.0
arm                  randconfig-004-20260802    gcc-15.2.0
arm64                         randconfig-001    gcc-10.5.0
arm64                randconfig-001-20260801    gcc-10.5.0
arm64                randconfig-001-20260802    gcc-9.5.0
arm64                randconfig-002-20260801    gcc-10.5.0
arm64                randconfig-002-20260802    gcc-9.5.0
arm64                randconfig-003-20260801    gcc-10.5.0
arm64                randconfig-003-20260802    gcc-9.5.0
arm64                randconfig-004-20260801    gcc-10.5.0
arm64                randconfig-004-20260802    gcc-9.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260801    gcc-10.5.0
csky                 randconfig-001-20260802    gcc-9.5.0
csky                 randconfig-002-20260801    gcc-10.5.0
csky                 randconfig-002-20260802    gcc-9.5.0
hexagon              randconfig-001-20260801    clang-24
hexagon              randconfig-001-20260801    gcc-16.1.0
hexagon              randconfig-001-20260802    clang-24
hexagon              randconfig-002-20260801    clang-17
hexagon              randconfig-002-20260801    gcc-16.1.0
hexagon              randconfig-002-20260802    clang-24
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260801    clang-22
i386       buildonly-randconfig-001-20260801    gcc-14
i386       buildonly-randconfig-001-20260802    gcc-14
i386       buildonly-randconfig-002-20260801    clang-22
i386       buildonly-randconfig-002-20260801    gcc-14
i386       buildonly-randconfig-002-20260802    gcc-14
i386       buildonly-randconfig-003-20260801    clang-22
i386       buildonly-randconfig-003-20260801    gcc-14
i386       buildonly-randconfig-003-20260802    gcc-14
i386       buildonly-randconfig-004-20260801    clang-22
i386       buildonly-randconfig-004-20260801    gcc-14
i386       buildonly-randconfig-004-20260802    gcc-14
i386       buildonly-randconfig-005-20260801    gcc-14
i386       buildonly-randconfig-005-20260802    gcc-14
i386       buildonly-randconfig-006-20260801    gcc-14
i386       buildonly-randconfig-006-20260802    gcc-14
i386                 randconfig-001-20260801    clang-22
i386                 randconfig-002-20260801    clang-22
i386                 randconfig-002-20260801    gcc-14
i386                 randconfig-003-20260801    clang-22
i386                 randconfig-004-20260801    clang-22
i386                 randconfig-005-20260801    clang-22
i386                 randconfig-006-20260801    clang-22
i386                 randconfig-007-20260801    clang-22
i386                 randconfig-011-20260801    gcc-14
i386                 randconfig-012-20260801    gcc-14
i386                 randconfig-013-20260801    gcc-14
i386                 randconfig-014-20260801    gcc-14
i386                 randconfig-015-20260801    gcc-14
i386                 randconfig-016-20260801    gcc-14
i386                 randconfig-017-20260801    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260801    clang-18
loongarch            randconfig-001-20260801    gcc-16.1.0
loongarch            randconfig-001-20260802    clang-24
loongarch            randconfig-002-20260801    gcc-16.1.0
loongarch            randconfig-002-20260802    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260801    gcc-16.1.0
nios2                randconfig-001-20260801    gcc-8.5.0
nios2                randconfig-001-20260802    clang-24
nios2                randconfig-002-20260801    gcc-11.5.0
nios2                randconfig-002-20260801    gcc-16.1.0
nios2                randconfig-002-20260802    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-9.5.0
parisc               randconfig-001-20260801    gcc-9.5.0
parisc               randconfig-001-20260802    gcc-14.3.0
parisc               randconfig-002-20260801    gcc-9.5.0
parisc               randconfig-002-20260802    gcc-14.3.0
powerpc                  bluestone_defconfig    clang-24
powerpc                  lite5200b_defconfig    clang-24
powerpc              randconfig-001-20260801    gcc-9.5.0
powerpc              randconfig-001-20260802    gcc-14.3.0
powerpc              randconfig-002-20260801    gcc-9.5.0
powerpc              randconfig-002-20260802    gcc-14.3.0
powerpc                    tqm8541_defconfig    clang-24
powerpc64            randconfig-001-20260801    gcc-9.5.0
powerpc64            randconfig-001-20260802    gcc-14.3.0
powerpc64            randconfig-002-20260801    gcc-9.5.0
powerpc64            randconfig-002-20260802    gcc-14.3.0
riscv                         randconfig-001    gcc-14.3.0
riscv                randconfig-001-20260801    gcc-14.3.0
riscv                randconfig-001-20260802    gcc-13.4.0
riscv                randconfig-002-20260801    gcc-14.3.0
riscv                randconfig-002-20260802    gcc-13.4.0
s390                 randconfig-001-20260801    gcc-14.3.0
s390                 randconfig-001-20260802    gcc-13.4.0
s390                 randconfig-002-20260801    gcc-14.3.0
s390                 randconfig-002-20260802    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260801    gcc-14.3.0
sh                   randconfig-001-20260802    gcc-13.4.0
sh                   randconfig-002-20260801    gcc-14.3.0
sh                   randconfig-002-20260802    gcc-13.4.0
sparc                randconfig-001-20260801    gcc-11.5.0
sparc                randconfig-001-20260801    gcc-8.5.0
sparc                randconfig-001-20260802    gcc-12.5.0
sparc                randconfig-002-20260801    gcc-11.5.0
sparc                randconfig-002-20260802    gcc-12.5.0
sparc64              randconfig-001-20260801    gcc-11.5.0
sparc64              randconfig-001-20260801    gcc-9.5.0
sparc64              randconfig-001-20260802    gcc-12.5.0
sparc64              randconfig-002-20260801    gcc-11.5.0
sparc64              randconfig-002-20260801    gcc-15.2.0
sparc64              randconfig-002-20260802    gcc-12.5.0
um                   randconfig-001-20260801    clang-17
um                   randconfig-001-20260801    gcc-11.5.0
um                   randconfig-001-20260802    gcc-12.5.0
um                   randconfig-002-20260801    gcc-11.5.0
um                   randconfig-002-20260801    gcc-14
um                   randconfig-002-20260802    gcc-12.5.0
x86_64              buildonly-randconfig-001    clang-22
x86_64     buildonly-randconfig-001-20260801    clang-22
x86_64     buildonly-randconfig-001-20260802    gcc-12
x86_64     buildonly-randconfig-002-20260801    clang-22
x86_64     buildonly-randconfig-002-20260802    gcc-12
x86_64     buildonly-randconfig-003-20260801    clang-22
x86_64     buildonly-randconfig-003-20260801    gcc-13
x86_64     buildonly-randconfig-003-20260802    gcc-12
x86_64     buildonly-randconfig-004-20260801    clang-22
x86_64     buildonly-randconfig-004-20260802    gcc-12
x86_64     buildonly-randconfig-005-20260801    clang-22
x86_64     buildonly-randconfig-005-20260802    gcc-12
x86_64     buildonly-randconfig-006-20260801    clang-22
x86_64     buildonly-randconfig-006-20260802    gcc-12
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260801    gcc-14
x86_64               randconfig-001-20260802    clang-22
x86_64               randconfig-002-20260801    gcc-14
x86_64               randconfig-002-20260802    clang-22
x86_64               randconfig-003-20260801    gcc-14
x86_64               randconfig-003-20260802    clang-22
x86_64               randconfig-004-20260801    gcc-14
x86_64               randconfig-004-20260802    clang-22
x86_64               randconfig-005-20260801    gcc-14
x86_64               randconfig-005-20260802    clang-22
x86_64               randconfig-006-20260801    gcc-14
x86_64               randconfig-006-20260802    clang-22
x86_64                        randconfig-011    clang-22
x86_64               randconfig-011-20260801    clang-22
x86_64               randconfig-012-20260801    clang-22
x86_64               randconfig-013-20260801    clang-22
x86_64               randconfig-014-20260801    clang-22
x86_64               randconfig-015-20260801    clang-22
x86_64               randconfig-016-20260801    clang-22
x86_64                        randconfig-071    clang-22
x86_64               randconfig-071-20260801    clang-22
x86_64               randconfig-071-20260801    gcc-14
x86_64               randconfig-071-20260802    gcc-12
x86_64               randconfig-072-20260801    clang-22
x86_64               randconfig-072-20260801    gcc-14
x86_64               randconfig-072-20260802    gcc-12
x86_64               randconfig-073-20260801    clang-22
x86_64               randconfig-073-20260802    gcc-12
x86_64               randconfig-074-20260801    clang-22
x86_64               randconfig-074-20260801    gcc-14
x86_64               randconfig-074-20260802    gcc-12
x86_64               randconfig-075-20260801    clang-22
x86_64               randconfig-075-20260802    gcc-12
x86_64               randconfig-076-20260801    clang-22
x86_64               randconfig-076-20260802    gcc-12
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260801    gcc-11.5.0
xtensa               randconfig-001-20260801    gcc-9.5.0
xtensa               randconfig-001-20260802    gcc-12.5.0
xtensa               randconfig-002-20260801    gcc-11.5.0
xtensa               randconfig-002-20260801    gcc-15.2.0
xtensa               randconfig-002-20260802    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

