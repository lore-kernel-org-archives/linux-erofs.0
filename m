Return-Path: <linux-erofs+bounces-4463-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDFDC61DD3
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 05:58:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hb85y05XQz2y8p;
	Thu, 03 Sep 2026 15:58:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788415093;
	cv=none; b=UeuUUTyjiPsrfT54lBR76PdFyEVweM8fqsGemeGm8ta03kfr3R+eXFAXLuGlRcn7MP0LDTPGi/sYYIJLlrFL4wpa0I6l7nryDRtjqSE+3XPLT30kEfctMdQg7F7Xi1BxZ0C2/BMQNJ8vQEeIY1hl5mo/Sgu4j9OyFQFTarDGYUkg3HpO8qwN5pq8yimXCrZfsSY1t60ahWCLsqqem8KNMROW3aAUhF9snHkz3yzZEjoJ0bc9j1Orn3E1e4XX7j30sOkQcySsyL8hkoqAUz9RAal2yizxo8KegS9oI2wrBJDM81RltKv+trbvyhzNdUJXooSD+E2es2/cC86ChGb9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788415093; c=relaxed/relaxed;
	bh=dHBdkyeBKadXP/ANicgGTrrttkcLUnipW/hGXWm4fck=;
	h=Date:From:To:Cc:Subject:Message-ID; b=c1Itxz2gHzwGtKCDqx6Z1kEeqpGfHiSiZuQAIcPPb9DGDDb9jIx/0Si4/NNyvUDqcCMp7PmvO1GYyKHXQwANRCiGTleZOTDSH0nLexZJIRq9EYOOlcObbJjLR1lsTT5NOcEDJfIizuYpWI+tGdmRVcBFLvYH2xtN5RChA8isppW6NETTtVKGszCtZuKW7jd5ZX8KsU2EJjnm5V3B+oKXwDgkQWbccresO6RLKCd2UYuJxW8jLt5hbC7y/rY2gEOQ/f8faMolg0CzkdlrmgyJbJ53iTi0ox7BxzTBTq/yLAS18aOO3uddA1i3J51FH+RscmO8s4S+NfAyojLoF66tAA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lzSjL9Oa; dkim-atps=neutral; spf=pass (client-ip=198.175.65.10; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lzSjL9Oa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.10; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hb85t287dz2y2W
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 15:58:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788415091; x=1819951091;
  h=date:from:to:cc:subject:message-id;
  bh=4dRMWHlXlUsJZgkuYC6stPRbZP1c4lwT2dPAPosPgL4=;
  b=lzSjL9Oa3X6y4pR07fu6mLBKEL8U6XKXZlHzoEAyvLoGxxlRh/7Lrb62
   diU4ms8pB4Wpo5AgS4Q/5oiIJDwUSZgKteuxoeTvkZLwrr9K7BG6h2eyN
   pTZ/ZU05sW22hs8qoSWZYGQxeuS+JO98Nh8wHO+Ky6P9b5m4KuWKaTqaz
   4sHeWZ+ybMB7MWZwe8ekzhJwhU8eCuIdVe22IqjN6plZywmA/JPZWPCtZ
   1I8wSsMEl+a6eAtxIOytJabo+g3R+eUYkbAbt047sdsc7W7DuldQmRvCd
   PrGURLzUpOzJ+ETK+ALHwi7R6gvC4R620mDN1P5AXbysKjzK0yVUP5EJ7
   w==;
X-CSE-ConnectionGUID: saVfI9l3RTK8TSjyxuHcYQ==
X-CSE-MsgGUID: iok0keSMS/OdY1avv08emw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="106250787"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="106250787"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 22:58:03 -0700
X-CSE-ConnectionGUID: j3gJ4GpdS5agoXHQZ3neeA==
X-CSE-MsgGUID: V9Y7Bw0xT8SkpxaA+alNbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="271576127"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 02 Sep 2026 22:58:01 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x20SU-000000004CW-2rWw;
	Thu, 03 Sep 2026 05:57:58 +0000
Date: Thu, 03 Sep 2026 13:57:42 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev-test] BUILD SUCCESS
 617d0d8d199ba1790c94310fd75a22d01c97a8d6
Message-ID: <202609031338.LZel8cLk-lkp@intel.com>
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
branch HEAD: 617d0d8d199ba1790c94310fd75a22d01c97a8d6  erofs: preserve LZMA decoders on resize failure

elapsed time: 1622m

configs tested: 73
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
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
loongarch    allmodconfig    clang-19
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
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
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

