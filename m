Return-Path: <linux-erofs+bounces-4093-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D5DEC55182
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 22:08:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDW5K25Cbz2xqM;
	Tue, 04 Aug 2026 08:08:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785794885;
	cv=none; b=XpFWriChGlJbUsulukfGyxTTCpGG27iCWmfxFZWhAMG1L3tpDWlErLBRRj3JM/ZeWy/uN5cXOMOhXsx/T30ELndZSnnf3bj+Q/qORLUET6Q2AdPzCZB7h+97SecpNvHvrxxTCU2H0LqClULGTKx0O6X0OyCTVdKPHHKy4cOdVkmp4XPuUkOVL4/swxyN8MHMB3/QNfVde37rDXnnROKUJLe6exuPtbA5FY7NC7EyX/m+XlHXa/afKsq8fut2JX5jW1JUx8Ax4SEyDyQeXNqOQi8tNhO4sRmjwqKIdFBPf/E96jEtRl4Shd0whTCT/m0D7XZwC6/tQuRe4Nh+/kMfCw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785794885; c=relaxed/relaxed;
	bh=fOOgcSyC1q7CYK5FpOLsfzAEIk8W7+yEgmXcX8Mfj1c=;
	h=Date:From:To:Cc:Subject:Message-ID; b=L5H7CsXKnTQ4Yr0zOste3akVBdvIgn2038s6xMtQcx4d47nLvuJ0Cqlylif2QVP6/V3//MJhLt1X7CvtM0ysUIRuoOlY2n27iy7Utuvczm/Sb2lbU9N0Gdcbn4eqop/gS72IABWSsHrQEhz4/MCVg+vh48sMYDJRQizwNl9I14UOwE3yKGsY8Y2BLhxaS2ND43Ob7Lg/8ssVgU4Ozo5X46h3QBcP/sgkokAXwhAwZm1JD371pcXC14IK18QbcU38UAxoBIMAAx+BWfLxsKEyzSYyQoCpis6dtWNWD24sVRtC5fdnLaGd2j6oeIJGeYclFhhuxVVKlD7+L+MX0yEMsA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ccf5OhZf; dkim-atps=neutral; spf=pass (client-ip=192.198.163.17; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ccf5OhZf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.17; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDW5C3CwLz2xYg
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 08:07:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785794879; x=1817330879;
  h=date:from:to:cc:subject:message-id;
  bh=iQvkC/zpk1CX4tavAP61IEB7r2e4lBnAlJ9Oh8hIRNo=;
  b=Ccf5OhZfgfmcjxwaNBAjdOTd040eSUpHFShunNoPtPZp+CsF6lkg4r2h
   6kngncPpG4W1XFEt2UQRtdH0E42LEjh/yR/w4QvwD3ox9zRk0hefQFUWB
   ayKRMNBmOTGc3j1ihqFnxe8pjgyjhbbllmjLDzcvGUX5l90DGVi50J3n6
   sywOdJx7OOTtx2APt2ClAAI1uEZ01FQVRi3iV5l0zjK4pGtD7PNI3hHq3
   eJDb/NPJBGINCfGyNh3iq27RO6Ia12TNLLLPgO5JmvDrxsUOxeiD1xfQ+
   ZzeF/OG3rJcgQBQMhRa/TOpSEEvQh5QTO2TJoca9IZhpChelWvYbDzorC
   w==;
X-CSE-ConnectionGUID: TEn+jE32QaqMD/wQFqW8Aw==
X-CSE-MsgGUID: apSyK8RESUm4oZNDmj7zyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86216708"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86216708"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 15:07:54 -0700
X-CSE-ConnectionGUID: t7T8LNISQUWRAE8UIHtMxg==
X-CSE-MsgGUID: qABSxbWhRL2fEzZQfErDug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="259537416"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 03 Aug 2026 15:07:52 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wr0p4-0000000085D-2Rld;
	Mon, 03 Aug 2026 22:07:50 +0000
Date: Tue, 04 Aug 2026 06:07:20 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev] BUILD SUCCESS
 ae8673ccefbfc5996b2c55e0c3378a082f9b9972
Message-ID: <202608040606.lsep3FtB-lkp@intel.com>
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
branch HEAD: ae8673ccefbfc5996b2c55e0c3378a082f9b9972  erofs: fix typo in error messages

elapsed time: 733m

configs tested: 152
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260803    gcc-8.5.0
arc                  randconfig-001-20260804    gcc-8.5.0
arc                  randconfig-002-20260803    gcc-8.5.0
arc                  randconfig-002-20260804    gcc-8.5.0
arm                  randconfig-001-20260803    gcc-8.5.0
arm                  randconfig-001-20260804    gcc-8.5.0
arm                  randconfig-002-20260803    gcc-8.5.0
arm                  randconfig-002-20260804    gcc-8.5.0
arm                  randconfig-003-20260803    gcc-8.5.0
arm                  randconfig-003-20260804    gcc-8.5.0
arm                  randconfig-004-20260803    gcc-8.5.0
arm                  randconfig-004-20260804    gcc-8.5.0
arm                          stm32_defconfig    gcc-16.1.0
arm64                randconfig-001-20260803    gcc-12.5.0
arm64                randconfig-001-20260804    gcc-11.5.0
arm64                randconfig-002-20260803    gcc-12.5.0
arm64                randconfig-002-20260804    gcc-11.5.0
arm64                randconfig-003-20260803    gcc-12.5.0
arm64                randconfig-003-20260804    gcc-11.5.0
arm64                randconfig-004-20260803    gcc-12.5.0
arm64                randconfig-004-20260804    gcc-11.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260803    gcc-12.5.0
csky                 randconfig-001-20260804    gcc-11.5.0
csky                 randconfig-002-20260803    gcc-12.5.0
csky                 randconfig-002-20260804    gcc-11.5.0
hexagon              randconfig-001-20260803    clang-18
hexagon              randconfig-001-20260804    gcc-16.1.0
hexagon              randconfig-002-20260803    clang-18
hexagon              randconfig-002-20260804    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260803    clang-22
i386       buildonly-randconfig-002-20260803    clang-22
i386       buildonly-randconfig-003-20260803    clang-22
i386       buildonly-randconfig-004-20260803    clang-22
i386       buildonly-randconfig-005-20260803    clang-22
i386       buildonly-randconfig-006-20260803    clang-22
i386                          randconfig-001    gcc-13
i386                 randconfig-001-20260803    gcc-13
i386                 randconfig-001-20260804    clang-22
i386                 randconfig-002-20260803    gcc-13
i386                 randconfig-002-20260804    clang-22
i386                 randconfig-003-20260803    gcc-13
i386                 randconfig-003-20260804    clang-22
i386                 randconfig-004-20260803    gcc-13
i386                 randconfig-004-20260804    clang-22
i386                 randconfig-005-20260803    gcc-13
i386                 randconfig-005-20260804    clang-22
i386                 randconfig-006-20260803    gcc-13
i386                 randconfig-006-20260804    clang-22
i386                 randconfig-007-20260803    gcc-13
i386                 randconfig-007-20260804    clang-22
i386                 randconfig-011-20260803    clang-22
i386                 randconfig-012-20260803    clang-22
i386                 randconfig-013-20260803    clang-22
i386                 randconfig-014-20260803    clang-22
i386                 randconfig-015-20260803    clang-22
i386                 randconfig-016-20260803    clang-22
i386                 randconfig-017-20260803    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260803    clang-18
loongarch            randconfig-001-20260804    gcc-16.1.0
loongarch            randconfig-002-20260803    clang-18
loongarch            randconfig-002-20260804    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260803    clang-18
nios2                randconfig-001-20260804    gcc-16.1.0
nios2                randconfig-002-20260803    clang-18
nios2                randconfig-002-20260804    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-15.2.0
parisc               randconfig-001-20260803    gcc-15.2.0
parisc               randconfig-001-20260804    gcc-8.5.0
parisc               randconfig-002-20260803    gcc-15.2.0
parisc               randconfig-002-20260804    gcc-8.5.0
powerpc              randconfig-001-20260803    gcc-15.2.0
powerpc              randconfig-001-20260804    gcc-8.5.0
powerpc              randconfig-002-20260803    gcc-15.2.0
powerpc              randconfig-002-20260804    gcc-8.5.0
powerpc                    redwood_defconfig    clang-24
powerpc                    taishan_defconfig    clang-21
powerpc64            randconfig-001-20260803    gcc-15.2.0
powerpc64            randconfig-001-20260804    gcc-8.5.0
powerpc64            randconfig-002-20260803    gcc-15.2.0
powerpc64            randconfig-002-20260804    gcc-8.5.0
riscv                         randconfig-001    gcc-8.5.0
riscv                randconfig-001-20260803    gcc-8.5.0
riscv                randconfig-002-20260803    gcc-8.5.0
s390                 randconfig-001-20260803    gcc-8.5.0
s390                 randconfig-002-20260803    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260803    gcc-8.5.0
sh                   randconfig-002-20260803    gcc-8.5.0
sparc                randconfig-001-20260803    gcc-16.1.0
sparc                randconfig-001-20260804    gcc-16.1.0
sparc                randconfig-002-20260803    gcc-16.1.0
sparc                randconfig-002-20260804    gcc-16.1.0
sparc64              randconfig-001-20260803    gcc-16.1.0
sparc64              randconfig-001-20260804    gcc-16.1.0
sparc64              randconfig-002-20260803    gcc-16.1.0
sparc64              randconfig-002-20260804    gcc-16.1.0
um                   randconfig-001-20260803    gcc-16.1.0
um                   randconfig-001-20260804    gcc-16.1.0
um                   randconfig-002-20260803    gcc-16.1.0
um                   randconfig-002-20260804    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260803    clang-22
x86_64     buildonly-randconfig-002-20260803    clang-22
x86_64     buildonly-randconfig-003-20260803    clang-22
x86_64     buildonly-randconfig-004-20260803    clang-22
x86_64     buildonly-randconfig-005-20260803    clang-22
x86_64     buildonly-randconfig-006-20260803    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260803    gcc-14
x86_64               randconfig-002-20260803    gcc-14
x86_64               randconfig-003-20260803    gcc-14
x86_64               randconfig-004-20260803    gcc-14
x86_64               randconfig-005-20260803    gcc-14
x86_64               randconfig-006-20260803    gcc-14
x86_64               randconfig-011-20260803    gcc-14
x86_64               randconfig-011-20260804    clang-22
x86_64               randconfig-012-20260803    gcc-14
x86_64               randconfig-012-20260804    clang-22
x86_64               randconfig-013-20260803    gcc-14
x86_64               randconfig-013-20260804    clang-22
x86_64               randconfig-014-20260803    gcc-14
x86_64               randconfig-014-20260804    clang-22
x86_64               randconfig-015-20260803    gcc-14
x86_64               randconfig-015-20260804    clang-22
x86_64               randconfig-016-20260803    gcc-14
x86_64               randconfig-016-20260804    clang-22
x86_64                        randconfig-071    clang-22
x86_64               randconfig-071-20260803    clang-22
x86_64               randconfig-072-20260803    clang-22
x86_64               randconfig-073-20260803    clang-22
x86_64               randconfig-074-20260803    clang-22
x86_64               randconfig-075-20260803    clang-22
x86_64               randconfig-076-20260803    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260803    gcc-16.1.0
xtensa               randconfig-001-20260804    gcc-16.1.0
xtensa               randconfig-002-20260803    gcc-16.1.0
xtensa               randconfig-002-20260804    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

