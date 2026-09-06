Return-Path: <linux-erofs+bounces-4481-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B2FC79F8C
	for <linux-erofs@archiver.kernel.org>; Sun,  6 Sep 2026 05:35:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hczSm5j1qz2yvD;
	Sun, 06 Sep 2026 15:35:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.7
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788672952;
	cv=none; b=EdTr5C1UQaVNoC2q2evwoc2pP4/jXz9tZ0SninNJ1Dy+tEIEL0SS4uA/xDSPrAEE5GfDxMi9gnJCcfyS1XBVlezzSKxnQQIvN+SbVqaICCEiAS584AAY9crEZdoliaMTTWPosjDQ4FfsroyXo5iW+h0IvmE9YpATvjysKQnax29B1LB/3WQF5pmWmJFALzT6U65rOoRz+r3jaFRjzS5+6DllnTS/sj+M6PyPjtWhkQv72VT0i1rUvhGndJTEgksLoOlzpJb7sTvXW8fcJPo5NFICUt659TdW0s6d4FuVqGfj/v9q3tU1xvstBnzUmWJ6GtyJpHTD1CfknAq+7Wo9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788672952; c=relaxed/relaxed;
	bh=baQdiLZwnOOhuB4cDBNyeRph5mSjuet7hk3J9Pqd7uk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=PE3vo5Y3mhKqavIEo0HRF6CwziqKdA5cwL3Br4Qei3ofnrcYRvXjmFXqYc4QQCk838OGR45wdxn89W/dNgnPEv0rnerNS3ltRR+/j9c974kC1qnI+bHZ6RIF0s1JVim2goL/PTquusOeLizHmpQ+Up/Ze4oFtez8ga2Xc8WbIVsrCkLes39jxA6i5Ekd/GZ5JH/ADeCYS3ECzTxep6ivYYezmsGfBRqqMeAM3TfmZZr2rGjdRQENXxgQZAffEd4xjVD/6EsacZJE01xl815IlAFWAZMq4H43SiNRt14fpsOmhPAOLsidxSziUrENvC9Mwg9v3Fq6c/T1CmX7O6YWZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SWAe8Pzv; dkim-atps=neutral; spf=pass (client-ip=192.198.163.7; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SWAe8Pzv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.7; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hczSj4Yyvz2xyh
	for <linux-erofs@lists.ozlabs.org>; Sun, 06 Sep 2026 15:35:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788672950; x=1820208950;
  h=date:from:to:cc:subject:message-id;
  bh=90xuL/PDhK7ev1wDh+CK08s0GhHK3E5A7XCR4EPV9D0=;
  b=SWAe8Pzv576NIvfNp2aq985k7rAarERcG/96D3q2uMQOEPpcuar5Xbpu
   ZGq/drsX8fjqYQoAdfCODJPRR4NcQSrYAGXu5hlxU87ZvJJR4wkfd/Q1b
   qfElc4+fDLNwMVBBKmP9JpGJqPAr0f//u9B1YT6HHF2n6NfS6dyb89NAZ
   hWL2PR6jaYf31KsfAONGEkZwJgSwOY2S/PefQQTeRmWHbSAm7YkChHqD/
   n+idU5HdhFR/X6xTG8YngVpVI+8wfKcutTeqskGCOR4y4h3T7N1IKJZZo
   C4U4ngIZvCDNCZBO/0o8h42S8ZdGTLNRM6GntqJfqbyt1EW4J+Rhpp0OM
   w==;
X-CSE-ConnectionGUID: GvVZotEYRleE8bVGidyWEA==
X-CSE-MsgGUID: uq+MIt2hTc+YxSsa97rmtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11897"; a="114658111"
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="114658111"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 22:35:41 -0700
X-CSE-ConnectionGUID: KS+VMnt3TvG3XG8VscUZRw==
X-CSE-MsgGUID: kUoA3C7bRKO0nDzpSGy9wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="270942214"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 05 Sep 2026 22:35:41 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x35XW-000000001Pb-1Hw1;
	Sun, 06 Sep 2026 05:35:38 +0000
Date: Sun, 06 Sep 2026 13:34:59 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev-test] BUILD SUCCESS
 82e664cf1219c459c33aae931b222cf951af9cb7
Message-ID: <202609061356.Ts5dvKqG-lkp@intel.com>
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
branch HEAD: 82e664cf1219c459c33aae931b222cf951af9cb7  erofs: disable LZ4 rolling decompression for now

elapsed time: 3760m

configs tested: 55
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

