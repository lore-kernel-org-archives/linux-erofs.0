Return-Path: <linux-erofs+bounces-4227-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C96B1C5B572
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 21:46:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMG5Y71Hnz2yS0;
	Sat, 15 Aug 2026 07:46:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.19
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786744001;
	cv=none; b=oNwRgyOnwhPbrfnjm+S7HvtHI51qW/svokZXaeFdoSYEFfg8Uhqgk+vqz4N41XFT7knaWz0pUX/28GsOsc5HkDkUB/SX6y/edYQmL6z9OFBXOe/69WAMBiYrcsYw4LHFe/agYDmAOWz7JT/2MrIDyUOpjs4kJXjAacKqCLzjS9uchm8Iv6t+gzgDgTq990oRUzHT4dJkCG+Cmiz6zs76Ps1CquaGUuA0GYv3SuSAdFy8I/adOtl3/ZN2+DWgHsEF3+h8WhVy2U8tHNIGSCjxUID/JXG4k/63HFHzOa03MCm/C/scZD3/x/tpmku0bTX3V4lcwwmgB7umwUnXchfiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786744001; c=relaxed/relaxed;
	bh=FON6QmcKkOjFWkXUIuckRjlFLis+f6cXOtSLQW5kTJs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=fw0CbWEcfIUqzBWLl8AudeWX/8DVmO/NJrRKvzXiUsTiHGDqxlKmmqMJmVJSy0LZeaCp2NUhhNEO7y7yEAlH+VCfhSJFCZe3ZIRfk0KK9jTlgmQmQd5ezYhpmUTiMKebTPTgQEHVXzAtrnbq8y4ySZXn9o5QtH3OVvB+Lcdrh9bb47NxV7zvp9F0qeMHzTjtiuV8OV88eRGAjf+ftGChjgsfVlQqCbz+WeNrHb9EUoaOMDdbwLDOIcuxmnuo3db8L5dV8PuK5hTQBjn1oGU2NwcjQL9bJ23PBXNucxsu4idBD7Ao40fQJADo1xvxtGmAWgZTGTRzgKT4JvL7a2sMoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j2DJJ9+v; dkim-atps=neutral; spf=temperror (client-ip=192.198.163.19; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j2DJJ9+v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=temperror (SPF Temporary Error: DNS Timeout) smtp.mailfrom=intel.com (client-ip=192.198.163.19; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMG5V19Prz2yH5
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 07:46:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786743998; x=1818279998;
  h=date:from:to:cc:subject:message-id;
  bh=D0LvV79oE4pgrEWLL1SpcQU/tWhdFXq4FydVScxUZsE=;
  b=j2DJJ9+vx0plzEeR1ALL8ffKn/d0ccaZr4qGHvgQnIis8Y6o7zzcdMb6
   YtBoo2nVyBRP9arqcYkQO8VYegfC36PF7Y5RdTlsJuD8Y3VJGuUrQoRcw
   k4H5QkmxrTcymTEm7buB048iPVeFT5vJu8gWdTaXxRsZsv9EKem8MKvuH
   oaZinD+y2ZGBu7q4Jdk+04OZl9vKsUdwXtPwTkG3j8dBg6z4QGNqPjjrm
   3u25RcwzrX90hi6WGbJGABZylfKkTqJKBjiIGgWveWIDnUmj+wU5VOPUx
   dKCOlTjcQKn9CGHyT0JP3oGz6ag5zas2NbEfTiSvMP5eT5AMnh0MBlHrR
   Q==;
X-CSE-ConnectionGUID: QsklCAASRha+EYi9kj8STg==
X-CSE-MsgGUID: 5LrRXkf0RZm3pxpY+qwi3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="86287672"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="86287672"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 14:46:12 -0700
X-CSE-ConnectionGUID: kWTHmroKSnimup5u6x6NoA==
X-CSE-MsgGUID: IkrNJWh8RZmtNJ6u9nnsFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="260091267"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 14 Aug 2026 14:46:11 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuzj6-00000000aIP-41EO;
	Fri, 14 Aug 2026 21:46:08 +0000
Date: Sat, 15 Aug 2026 05:45:54 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:fixes] BUILD SUCCESS
 430a5b1b10cf2897253eff940395639a40cdae0c
Message-ID: <202608150543.4ebdz7VN-lkp@intel.com>
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
branch HEAD: 430a5b1b10cf2897253eff940395639a40cdae0c  erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms

elapsed time: 792m

configs tested: 71
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260815    gcc-11.5.0
arc                  randconfig-002-20260815    gcc-8.5.0
arm                  randconfig-001-20260815    clang-21
arm                  randconfig-002-20260815    gcc-8.5.0
arm                  randconfig-003-20260815    clang-17
arm                  randconfig-004-20260815    gcc-8.5.0
arm                       shmobile_defconfig    gcc-16.1.0
arm64                randconfig-001-20260815    clang-24
arm64                randconfig-004-20260815    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260815    gcc-13.4.0
csky                 randconfig-002-20260815    gcc-15.2.0
hexagon              randconfig-001-20260815    clang-24
hexagon              randconfig-002-20260815    clang-22
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260814    clang-22
i386       buildonly-randconfig-002-20260814    gcc-13
i386       buildonly-randconfig-003-20260814    clang-22
i386       buildonly-randconfig-004-20260814    clang-22
i386       buildonly-randconfig-005-20260814    gcc-13
i386       buildonly-randconfig-006-20260814    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260815    clang-18
loongarch            randconfig-002-20260815    clang-18
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260815    gcc-8.5.0
nios2                randconfig-002-20260815    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
riscv                randconfig-001-20260814    gcc-14.3.0
riscv                randconfig-002-20260814    clang-24
s390                 randconfig-001-20260814    gcc-11.5.0
s390                 randconfig-002-20260814    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260814    gcc-16.1.0
sh                   randconfig-002-20260814    gcc-16.1.0
sparc                randconfig-001-20260814    gcc-16.1.0
sparc                randconfig-002-20260814    gcc-15.2.0
sparc64              randconfig-001-20260814    gcc-8.5.0
sparc64              randconfig-002-20260814    clang-24
um                   randconfig-001-20260814    gcc-14
um                   randconfig-002-20260814    clang-22
x86_64               randconfig-001-20260814    gcc-14
x86_64               randconfig-002-20260814    clang-22
x86_64               randconfig-003-20260814    clang-22
x86_64               randconfig-004-20260814    clang-22
x86_64               randconfig-005-20260814    gcc-14
x86_64               randconfig-006-20260814    gcc-14
x86_64               randconfig-011-20260814    clang-22
x86_64               randconfig-012-20260814    gcc-13
x86_64               randconfig-013-20260814    clang-22
x86_64               randconfig-014-20260814    gcc-14
x86_64               randconfig-015-20260814    gcc-14
x86_64               randconfig-016-20260814    clang-22
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260814    gcc-14
x86_64               randconfig-072-20260814    clang-22
x86_64               randconfig-073-20260814    clang-22
x86_64               randconfig-074-20260814    gcc-13
x86_64               randconfig-075-20260814    gcc-14
x86_64               randconfig-076-20260814    clang-22
xtensa               randconfig-001-20260814    gcc-9.5.0
xtensa               randconfig-002-20260814    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

