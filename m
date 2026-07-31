Return-Path: <linux-erofs+bounces-4064-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C39C5516D
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 14:16:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBSmn706Xz2yY1;
	Sat, 01 Aug 2026 00:16:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785507401;
	cv=none; b=JSlymTDML3SQKImVCQ3EmmMnsq2nrFxWHnTHvV+j46Uf8Ad0GvXplvAYEX6OLmHOD+2uuMREDtml2j0PZJXNv47KeG0+2ZuCbFi0Mbh6FQ5SOFlLqyAJ+NLSQrcHt0fG5hBwEMq7bgHeScNL2VQU2/FgWxVVnz8PHS7Qw7aevCfQgZvX2kPG/XILegYKqWIwDf5KdWS1U3gEDeFjkAjeeb4s/8WtTiQMOOV30SvER5pty54ymVmlCmGFAIxK1s5X7JUkxE8KqaRTMp7dYdCSjTpbL9rAvQ8eyy0wXbeh852JWfOw4ODFZDJPd8T+lpD6k2TMv0AgPjlKNwME/dbs1g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785507401; c=relaxed/relaxed;
	bh=avc82mK1UmZAD3w/nysJCQ0MMMUepmVdTRAqRneNAu8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=V/s2N+7KsrU7xjVR86MfC1T7UJOwOj2wYlgtvyFmr0liyyuEXG0uppyci25wGNql4q2EFD4lSahfkoGrM2Ok0JtEAE2o65Hg+oBliCB48V10oZDdfX+48U9GsrJFXzNvCqBX5UBMwFPmokOc7rN11jKoNrdrdm/ORakx+4tuLnT9dL6ZteRxxQSlA8av5uwrImHdJNrcw9FugG9FY90t8aPNnEveb9tLx3wILESOOlOU/0E4/skS4mjG4Kl8nZmXfw+DE9D1Q8uadmd9yFwsZG8P5eNgG4ow5WEiv9WwY9+JWusOCVvVcnBLXPOVgc548fT5McJ7BhXRK5kiR49Z6w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G8vT6R5g; dkim-atps=neutral; spf=pass (client-ip=198.175.65.9; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G8vT6R5g;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.9; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBSmk2xX8z2xwH
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 00:16:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785507399; x=1817043399;
  h=date:from:to:cc:subject:message-id;
  bh=rZFfmC5zSz6qN4Qr2AafrTUfJQ4s2m8zFRa/f86P4Qw=;
  b=G8vT6R5gIuLn7B8Boa5hrBeshiRtQt6Q6bQT2mgMcmOYySuT/IUKDq8k
   Xj1IkczgkOysU2wOoPiTi2xquDnx08DMg+KNAQlZ4zbiKRqpo0V4PB7cc
   MUkB0SFyjQTx6prxsdu9BIb+iXb6j4e9sEbwGiOr7TsJzMJr1GYNGT/NK
   BNqGhUtL8VMYwQt3l7O7KODzak2/XNzZ8L0+RrADnvlYAfPalSWrp7dBS
   MoIcnsS/UWvxehMlQ47FhePqJ4BYldf79+2gPv2Qgb18B+IHghWczAO3O
   DQnwfiyOskdjIsbzx75UBiYe/CmP9KaYfDvW8aPAAHbaNJ6I0aEXrWloI
   w==;
X-CSE-ConnectionGUID: BQdTAteiRd+Kxvou9qE08g==
X-CSE-MsgGUID: OhUA6nQPTrC9ui3d1XHhXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="108928887"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="108928887"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:16:30 -0700
X-CSE-ConnectionGUID: TP6FrodcTDuVZVNLWHZomQ==
X-CSE-MsgGUID: QqdzEilYTyqHrGwkdBB98Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="264399041"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 31 Jul 2026 07:16:29 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpo2F-000000001Ax-1IFC;
	Fri, 31 Jul 2026 14:16:27 +0000
Date: Fri, 31 Jul 2026 22:16:10 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev] BUILD SUCCESS
 e1a16b5ff51218dce414629f7634923162824001
Message-ID: <202607312259.WqfShluW-lkp@intel.com>
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
branch HEAD: e1a16b5ff51218dce414629f7634923162824001  erofs: accept source file descriptor via fsconfig

elapsed time: 800m

configs tested: 105
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    clang-17
arc                  randconfig-002-20260731    clang-17
arm                           mmp2_defconfig    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-17
arm                  randconfig-003-20260731    clang-17
arm                  randconfig-004-20260731    clang-17
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    gcc-8.5.0
arm64                randconfig-003-20260731    gcc-8.5.0
arm64                randconfig-004-20260731    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-8.5.0
csky                 randconfig-002-20260731    gcc-8.5.0
hexagon                       randconfig-001    clang-24
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260731    clang-22
i386       buildonly-randconfig-002-20260731    clang-22
i386       buildonly-randconfig-003-20260731    clang-22
i386       buildonly-randconfig-004-20260731    clang-22
i386       buildonly-randconfig-005-20260731    clang-22
i386       buildonly-randconfig-006-20260731    clang-22
i386                 randconfig-001-20260731    gcc-14
i386                 randconfig-002-20260731    gcc-14
i386                 randconfig-003-20260731    gcc-14
i386                 randconfig-004-20260731    gcc-14
i386                 randconfig-005-20260731    gcc-14
i386                 randconfig-006-20260731    gcc-14
i386                 randconfig-007-20260731    gcc-14
i386                 randconfig-011-20260731    clang-22
i386                 randconfig-012-20260731    clang-22
i386                 randconfig-013-20260731    clang-22
i386                 randconfig-014-20260731    clang-22
i386                 randconfig-015-20260731    clang-22
i386                 randconfig-016-20260731    clang-22
i386                 randconfig-017-20260731    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    clang-24
loongarch            randconfig-002-20260731    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    clang-24
nios2                randconfig-002-20260731    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260731    gcc-8.5.0
parisc               randconfig-002-20260731    gcc-8.5.0
powerpc              randconfig-001-20260731    gcc-8.5.0
powerpc              randconfig-002-20260731    gcc-8.5.0
powerpc64            randconfig-001-20260731    gcc-8.5.0
powerpc64            randconfig-002-20260731    gcc-8.5.0
riscv                   nommu_k210_defconfig    clang-24
riscv                         randconfig-001    clang-19
riscv                randconfig-001-20260731    clang-19
riscv                randconfig-002-20260731    clang-19
s390                 randconfig-001-20260731    clang-19
s390                 randconfig-002-20260731    clang-19
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260731    clang-19
sh                   randconfig-002-20260731    clang-19
sparc                         randconfig-001    gcc-14
sparc                randconfig-001-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-14
sparc64              randconfig-001-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-14
um                   randconfig-001-20260731    gcc-14
um                   randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-001-20260731    gcc-14
x86_64     buildonly-randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-003-20260731    gcc-14
x86_64     buildonly-randconfig-004-20260731    gcc-14
x86_64     buildonly-randconfig-005-20260731    gcc-14
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260731    gcc-14
x86_64               randconfig-002-20260731    gcc-14
x86_64               randconfig-003-20260731    gcc-14
x86_64               randconfig-004-20260731    gcc-14
x86_64               randconfig-005-20260731    gcc-14
x86_64               randconfig-006-20260731    gcc-14
x86_64               randconfig-011-20260731    gcc-14
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    gcc-14
x86_64               randconfig-014-20260731    gcc-14
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260731    clang-22
x86_64               randconfig-072-20260731    clang-22
x86_64               randconfig-073-20260731    clang-22
x86_64               randconfig-074-20260731    clang-22
x86_64               randconfig-075-20260731    clang-22
x86_64               randconfig-076-20260731    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260731    gcc-14
xtensa               randconfig-002-20260731    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

