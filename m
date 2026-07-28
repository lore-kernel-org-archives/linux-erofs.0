Return-Path: <linux-erofs+bounces-4025-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B41C531F9
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 11:19:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8Y075WKTz2xyk;
	Tue, 28 Jul 2026 21:19:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785237591;
	cv=none; b=EJZ1bZ5zf2zZ9EqNyvq9L7ZRg1UJDXvxFGUd5ujmoTST+GJETfgA+OxwNgguRKEEyYBtkJPSfM5dz504Pc6dU9+SknFKfp95yMLKRwBiS7p8FJtAwn7HiMcOTbPjwt1cIwKj8MjZtOTEX+ottqYDwT3/bOKpAjdnRPbSHZf3hrLRZWVjmBR0HDA7FqcMS02ObA67Zz9u9kdE3VkgpYu5Y2qq+Hx4U7vWCxqwqb/XMentBsDBHkmhrPypkFVNrinncOzeybVkx9NnezQa40YsQfCTqRLeviBVILHQpd95tvJEN7JVWVIr3nj7uPG4GyUcbACUVL/lj5cMA9NyyufqWg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785237591; c=relaxed/relaxed;
	bh=LSh67P9xFpckUhRzpas/bsBM6NzRfLo2WD39+fCdPSk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=mWvnA29aQUwHGYxKSN3HDgiyjCkdGOvLIOZHUHqsPwsHvIxiKBIgYXDDbIK7OPYJl1X+v6pN51inkd3SRNHJzrLqikdAxIdk06ggU8t+HG91civpgzAYF0zXpIIrkxFSBnclYXV1KoQk9Jpb6VXocw+2namrIWONei4jjkYfZgP3ylsk5QapQLd8S0JNSskbZIiJ31NOH9e0PwZmnQ6VAAculpEcgDUXps/eOdWHifzcyADAjEXjZ8mJ0fGi1ug8COobzYoTj36D50pOuLvQOf3GnKXsIpk10222w9BUxhSuCCLSHYW/NVeFm9Ndne2GS47eSdyeO9T3J+d2uEx37Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kkXO4Twq; dkim-atps=neutral; spf=pass (client-ip=192.198.163.18; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kkXO4Twq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.18; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8Y03719mz2xJR
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 21:19:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785237588; x=1816773588;
  h=date:from:to:cc:subject:message-id;
  bh=uU8kjNE91bxUJpNUHXr8XLZMrNpzisMI5hD5iykHXV0=;
  b=kkXO4TwqEYC8mXxp6NZD/qoOSFV204hUjpuqcg4/3yLFIkgtimxG00Uk
   42HHb2ijGu7I+ezBLVpsiQFvsXtocBemrLfsCIYOehZ3vQAvivgJ58fW8
   TuejSJoifMqNmgAW8Ow6P51zAjgHWXU3RHkvUo/pMUlZfcdXKQlJ54Lr8
   AbtZz4mTxp1EzL2ubMwlCHMY9yhk4tFPOgSDCFnA3QgpMNyOodP1IcyH7
   uiC0KFCoKvJIVgirBGNKO1o6kN4YcrcR2nMs1Z9Za/Z2aeERihg1pL3nX
   KTjtdiYLh2c6Png7xbEMGNeK5FdaCTtfn0Jbdd2tPUoZ3u++aPi8sZG2H
   g==;
X-CSE-ConnectionGUID: iFalD+XHRt+RXKPDmXiM6Q==
X-CSE-MsgGUID: FZn6JZ1fRnm8jMZiXGXupg==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="84943841"
X-IronPort-AV: E=Sophos;i="6.25,190,1779174000"; 
   d="scan'208";a="84943841"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 04:19:42 -0700
X-CSE-ConnectionGUID: xVCfqRJJT9y31m9aKV7Riw==
X-CSE-MsgGUID: QDoPBAVJQteSu8PjBcdSIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,190,1779174000"; 
   d="scan'208";a="257870633"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 28 Jul 2026 04:19:41 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wofqU-00000000eIh-2IxM;
	Tue, 28 Jul 2026 11:19:38 +0000
Date: Tue, 28 Jul 2026 19:18:59 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Xiang Gao <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:fixes] BUILD SUCCESS
 c9b47e6b23114e939b17f818471c7a46e59006e7
Message-ID: <202607281937.al3VZMPd-lkp@intel.com>
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

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git fixes
branch HEAD: c9b47e6b23114e939b17f818471c7a46e59006e7  erofs: cap LZMA stream pool size

elapsed time: 916m

configs tested: 45
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arm64                randconfig-001-20260728    gcc-8.5.0
arm64                randconfig-002-20260728    clang-17
arm64                randconfig-003-20260728    clang-24
arm64                randconfig-004-20260728    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260728    gcc-16.1.0
csky                 randconfig-002-20260728    gcc-10.5.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260728    gcc-14
i386       buildonly-randconfig-003-20260728    clang-22
i386       buildonly-randconfig-005-20260728    gcc-13
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260728    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
powerpc                canyonlands_defconfig    clang-22
riscv                randconfig-001-20260728    clang-20
riscv                randconfig-002-20260728    gcc-8.5.0
s390                 randconfig-001-20260728    clang-22
s390                 randconfig-002-20260728    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260728    gcc-16.1.0
sh                   randconfig-002-20260728    gcc-14.3.0
sparc                randconfig-001-20260728    gcc-13.4.0
sparc                randconfig-002-20260728    gcc-8.5.0
sparc64              randconfig-001-20260728    gcc-13.4.0
sparc64              randconfig-002-20260728    gcc-8.5.0
um                   randconfig-001-20260728    clang-24
um                   randconfig-002-20260728    clang-24
x86_64               randconfig-011-20260728    clang-22
x86_64               randconfig-012-20260728    clang-22
x86_64               randconfig-013-20260728    clang-22
x86_64               randconfig-014-20260728    clang-22
x86_64               randconfig-015-20260728    clang-22
x86_64               randconfig-016-20260728    gcc-14
xtensa               randconfig-001-20260728    gcc-8.5.0
xtensa               randconfig-002-20260728    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

