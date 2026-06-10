Return-Path: <linux-erofs+bounces-3565-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6709CD8CB9
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Jun 2026 16:58:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gbBnH5sHWz2ysW;
	Thu, 11 Jun 2026 02:58:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781110723;
	cv=none; b=PveDwDQzhOscdma/7c1xp9nTO94TYvYBziiluu9e1gIdfIR9SmFarzi/owsNZH2ahoYg27wtW4jWJmuAhvu6NDxsP6x07vo9bow44lOrO1NqcbZQw6ijWreHH9UhTFBSkfvjUVB9jZba4TL91xx548HvI4kx0jhYabJqrwvbyBbNk123lTEM1M5pADvk2CuUdtBT7SMBngBG09fA8Vkln2C950WnQnJHQdlJgJY0dRJJesqnvzN3TLzun5rNU4M2UI3G4cRUSh9cS6wB78WzbipgCGvwr630xImN1R9wQFz5A1P79BIiIlS4Jxqy0rhkRD1wzo4PJi81ZZ0pq1fVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781110723; c=relaxed/relaxed;
	bh=CXTTcuFWbZ7V0XvKeXPADe0IJquvkzdNY73C33bMulk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=n/SWlA9Krj1ZD2BiK9zOwpE5wRcg/+bieikR5dRqJBpgz2OOhixf6uHNZZsW7cY6E3d1f3MWDS0qzd5O5Ys/B5z7g36QTEUG/JRADUzhndujCRh6Z8qXenU4VYCYjz7ub3eVtRjrP2z6ru68PHJt8kb9ECwMZ1iht0+vqvN0fMpaLmlkG8FHT2cHdK2/1lWCoamtkF9U3h2NEaXH6gy4m6sqhVESdOANpRBA0CD0/mu4Xt3za7CG5+tW4DvALD8sElQ7rdFjkb+ULeaOvyPCtRHovo26YNkwgO7pu2+VcGWIdtCXlJ6FlUxghOHnZGeg4mq0FEYCAdoLeWyqWjeHfA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B+b0ikbI; dkim-atps=neutral; spf=pass (client-ip=192.198.163.13; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B+b0ikbI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.13; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gbBnD5dSNz2yfD
	for <linux-erofs@lists.ozlabs.org>; Thu, 11 Jun 2026 02:58:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781110721; x=1812646721;
  h=date:from:to:cc:subject:message-id;
  bh=VOhILyXbME9z1HBGHYM9Zx5PrEVHKK/JJZA8YEqqTJ8=;
  b=B+b0ikbIyUw3olvQa6L076XeLPDy+KEUmvuD1JBVhqwDh9xW7MCr3LdJ
   R/119mB9yA5RPrAZTlIEC6VFS9ko95mQt6iu9uaGYpurhdHBOfVQA8ZuP
   geDkPlgUT/VFtoopSQq/b2uvVDL5Q3wKYF1gV7iRLyLj+yDUDZe3gJpLq
   dnDa7kZ9YQUsWMIjyC8Z2FZVILu3RFCQ4xVnwt6wKrd3FTc3elWPCo7Dn
   ooJzWlztyB40M2eswdXuspWBEupDAzb14cLUBlmnF9gg3gQo5XK1ARJuD
   6DUWitCnrqk+pmaYWqpzl8hBezvYYWAeR7B2AZu89jPAP9MwvKuRKPRuE
   A==;
X-CSE-ConnectionGUID: T8DvfMd8Q3moxTHcBehamA==
X-CSE-MsgGUID: kAeJhKRaRJaQUEvBmL8r3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="84482573"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="84482573"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:58:34 -0700
X-CSE-ConnectionGUID: KGYrZm3sQ/if2YYkmzde3Q==
X-CSE-MsgGUID: gySx1ax0S1ioZ1qPc2x5QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="245101260"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 10 Jun 2026 09:58:33 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXMG5-00000000Lh4-43Jc;
	Wed, 10 Jun 2026 16:58:29 +0000
Date: Thu, 11 Jun 2026 00:58:05 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Xiang Gao <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev] BUILD SUCCESS
 ed9ad8d3a13931a5a0f65208b82135dd166a3ce0
Message-ID: <202606110057.uNlSwBCu-lkp@intel.com>
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
branch HEAD: ed9ad8d3a13931a5a0f65208b82135dd166a3ce0  erofs: update the overview of the documentation

elapsed time: 786m

configs tested: 182
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                   randconfig-001-20260610    gcc-8.5.0
arc                   randconfig-002-20260610    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    gcc-16.1.0
arm                        mvebu_v7_defconfig    clang-23
arm                   randconfig-001-20260610    clang-23
arm                   randconfig-002-20260610    clang-20
arm                   randconfig-003-20260610    clang-23
arm                   randconfig-004-20260610    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                 randconfig-001-20260610    gcc-11.5.0
arm64                 randconfig-002-20260610    gcc-11.5.0
arm64                 randconfig-002-20260610    gcc-9.5.0
arm64                 randconfig-003-20260610    gcc-11.5.0
arm64                 randconfig-003-20260610    gcc-8.5.0
arm64                 randconfig-004-20260610    clang-23
arm64                 randconfig-004-20260610    gcc-11.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                  randconfig-001-20260610    gcc-11.5.0
csky                  randconfig-001-20260610    gcc-9.5.0
csky                  randconfig-002-20260610    gcc-11.5.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon               randconfig-001-20260610    clang-23
hexagon               randconfig-002-20260610    clang-22
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260610    gcc-14
i386        buildonly-randconfig-002-20260610    gcc-14
i386        buildonly-randconfig-003-20260610    gcc-14
i386        buildonly-randconfig-004-20260610    gcc-14
i386        buildonly-randconfig-005-20260610    gcc-14
i386        buildonly-randconfig-006-20260610    clang-22
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260610    gcc-14
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260610    gcc-14
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260610    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260610    gcc-14
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260610    clang-22
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260610    gcc-14
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260610    gcc-14
i386                  randconfig-011-20260610    clang-22
i386                  randconfig-012-20260610    clang-22
i386                  randconfig-013-20260610    clang-22
i386                  randconfig-014-20260610    clang-22
i386                  randconfig-015-20260610    clang-22
i386                  randconfig-016-20260610    clang-22
i386                  randconfig-017-20260610    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch             randconfig-001-20260610    gcc-16.1.0
loongarch             randconfig-002-20260610    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                        m5272c3_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                 randconfig-001-20260610    gcc-11.5.0
nios2                 randconfig-002-20260610    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                          randconfig-001    gcc-13.4.0
riscv                 randconfig-001-20260610    gcc-15.2.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260610    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                           randconfig-001    gcc-15.2.0
s390                  randconfig-001-20260610    clang-23
s390                           randconfig-002    clang-18
s390                  randconfig-002-20260610    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                             randconfig-001    gcc-14.3.0
sh                    randconfig-001-20260610    gcc-16.1.0
sh                             randconfig-002    gcc-9.5.0
sh                    randconfig-002-20260610    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                 randconfig-001-20260610    gcc-8.5.0
sparc                 randconfig-002-20260610    gcc-14.3.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260610    gcc-12.5.0
sparc64               randconfig-002-20260610    clang-23
um                               allmodconfig    clang-17
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260610    clang-23
um                    randconfig-002-20260610    clang-18
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260610    clang-22
x86_64                randconfig-002-20260610    clang-22
x86_64                randconfig-003-20260610    gcc-13
x86_64                randconfig-004-20260610    clang-22
x86_64                randconfig-005-20260610    clang-22
x86_64                randconfig-006-20260610    gcc-13
x86_64                randconfig-011-20260610    gcc-12
x86_64                randconfig-012-20260610    gcc-12
x86_64                randconfig-013-20260610    gcc-14
x86_64                randconfig-014-20260610    gcc-12
x86_64                randconfig-015-20260610    gcc-14
x86_64                randconfig-016-20260610    gcc-14
x86_64                randconfig-071-20260610    gcc-14
x86_64                randconfig-072-20260610    gcc-14
x86_64                randconfig-073-20260610    gcc-14
x86_64                randconfig-074-20260610    gcc-14
x86_64                randconfig-075-20260610    gcc-14
x86_64                randconfig-076-20260610    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260610    gcc-8.5.0
xtensa                randconfig-002-20260610    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

