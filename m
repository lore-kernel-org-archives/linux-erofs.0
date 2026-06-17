Return-Path: <linux-erofs+bounces-3661-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4FECD98E2
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Jun 2026 14:28:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ggR761Gnnz2xLk;
	Thu, 18 Jun 2026 00:28:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781706530;
	cv=none; b=m7VLV+2rAMI5NcIebHl9TN4w6nR8YtLLE81R/Sr1yK6XMy4bKe3amCVHmM0yZ1F9D4eZALOKBmwHopeeqO9lq/hZBHLWx4I9TtJyzEoocQgIAYKtnWNHMHYS/g8fuduHNna7ZEpqIPhm1yXOD1S/Uq30fsb8joNpyx3pzKFoEG+f77T3UkKH/XY8/YwVKUVuN6ywgBZ8KtuMc33G4ers6NK/KtnbPhlDHz97YUbiJ8oN0yg3aWAsdaMaydOB2loY7YIGqhKB/N6d70PpEhXaPr6+tahzRkZgUa8PlNWOXkGUAyyP8og/R0OeKSJxI0HBXB24LuoA/RH7+44ERxB+lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781706530; c=relaxed/relaxed;
	bh=vAMpGXHFuy3sfICo0U0yV6C46libuEph5dyHC4bxyEI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=fTmE3+RPKy87kWMyazusEx+6uAiADV4MmLkz1HTQdkIs6hD11LHLlBOuwDEgb2eWnzBcfjG8/OyH3sON3349Ei8WLmi43M67MHFp0SxNqFPLfrv+mLdke3cy9qexLuu5mrAfsAqdMY5kDVet5qTunLC/CkfKC+OtOrA6iGr6QCzbmmqIOmHLckzTMEyGS6qoondeZvhTGQaaupKQqKpYOVuhlv9J297sfG7wA2HnWrWmxqjYEXurBKdCuSSeU2zVOdhSyn0O/54gLJAwMr/oyRdJmW5sGcyt7EKhlxIvSxbQ3pX2XdHd7G9uHV3NlKNzZrUgRnG75GdT2nD/l4RWkw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YwIqSUz6; dkim-atps=neutral; spf=pass (client-ip=192.198.163.13; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YwIqSUz6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.13; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ggR7318y7z2xHK
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 Jun 2026 00:28:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781706527; x=1813242527;
  h=date:from:to:cc:subject:message-id;
  bh=Ucl8/StmjDiavl9tinnIAfOBhzDyLSEI/A/KaidMW4I=;
  b=YwIqSUz66mm8lrcg7tBSVVrUjKBWPz8hg2jUwz2gj0/HM8fgDPSX38uD
   hsuSPeQ5c8PpUKD675TzjcOgUVm+UabjVKkaxp76fkKnuWXeGOFS43poR
   Qi/YVfLx0kzcg6p8tDUaJg+wxUFGLuzD+C8HuromYmPhkqVk/dMvnhBSd
   TDzBlsyY6ARcliYUaOHvfAKdmonfZWgCo1h2Byz0c5/i1dZeOGBpMdB1v
   6EHRB0nBcyAUta5GQ/YWBTr3yxFR53IwVzk9XBmxdaly0n1iHdCSaRRNX
   DUggLPpV510PmA78Oiy+3h/bvthlbuYKP6u1RtzG6lu/N6vzdrgpAWnws
   g==;
X-CSE-ConnectionGUID: 39q5SZJHTq2h4ClzuY0u6A==
X-CSE-MsgGUID: xDLjR0K4SOG51Hq1iNCYYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="85059372"
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="85059372"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 07:28:40 -0700
X-CSE-ConnectionGUID: l049SbdvTfWg8rH+G4Kxww==
X-CSE-MsgGUID: 0L2s8jSJSPeoCdJL37FHrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="248147282"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 17 Jun 2026 07:28:38 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wZrFs-00000000UYg-0efU;
	Wed, 17 Jun 2026 14:28:36 +0000
Date: Wed, 17 Jun 2026 22:28:08 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Xiang Gao <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:fixes] BUILD SUCCESS
 27f2d085bd72abe4235689d34d8654cfc876d568
Message-ID: <202606172251.DmnalBez-lkp@intel.com>
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
branch HEAD: 27f2d085bd72abe4235689d34d8654cfc876d568  erofs: fix EFSCORRUPTED on multi-algorithm images in z_erofs_map_sanity_check()

elapsed time: 22595m

configs tested: 37
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha        allnoconfig    gcc-16.1.0
alpha       allyesconfig    gcc-16.1.0
arc         allmodconfig    gcc-16.1.0
arc          allnoconfig    gcc-16.1.0
arm          allnoconfig    clang-23
arm64        allnoconfig    gcc-16.1.0
csky         allnoconfig    gcc-16.1.0
hexagon     allmodconfig    clang-23
hexagon      allnoconfig    clang-23
i386         allnoconfig    gcc-14
loongarch    allnoconfig    clang-20
m68k         allnoconfig    gcc-16.1.0
microblaze   allnoconfig    gcc-16.1.0
mips        allmodconfig    gcc-16.1.0
mips         allnoconfig    gcc-16.1.0
nios2       allmodconfig    gcc-11.5.0
nios2        allnoconfig    gcc-11.5.0
openrisc    allmodconfig    gcc-16.1.0
openrisc     allnoconfig    gcc-16.1.0
parisc      allmodconfig    gcc-16.1.0
parisc       allnoconfig    gcc-16.1.0
parisc      allyesconfig    gcc-16.1.0
powerpc     allmodconfig    gcc-16.1.0
powerpc      allnoconfig    gcc-16.1.0
riscv        allnoconfig    gcc-16.1.0
s390        allmodconfig    clang-23
s390         allnoconfig    clang-23
s390        allyesconfig    gcc-16.1.0
sh          allmodconfig    gcc-16.1.0
sh           allnoconfig    gcc-16.1.0
sh          allyesconfig    gcc-16.1.0
sparc        allnoconfig    gcc-16.1.0
sparc64     allmodconfig    clang-20
um           allnoconfig    clang-16
um          allyesconfig    gcc-14
x86_64       allnoconfig    clang-22
xtensa       allnoconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

