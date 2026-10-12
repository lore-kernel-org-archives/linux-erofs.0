Return-Path: <linux-erofs+bounces-4706-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EEABCA9ED0
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 15:53:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3MSW3L3Jz30WJ;
	Tue, 13 Oct 2026 02:53:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791820395;
	cv=none; b=JD5vKmDnsPIU6v6MTNOpSu2u2oGcoyRjHLlT3m5Lpv+5PCL34PY5w03iBmbPUhACAb4OmGXx7JFl0NNpnPaeBN4LiiXynHzLxudQT+qvKFM0BndYWJuIO0aR+IdLJUFtpPn3LQ7GAFOsVydWc9wI9uXB4wo8gk8CI3DXUdMV9rI32WQUNamVLZZyQDLF/e+DwVy/zuQLHmwWVIu7XpEn6bmQWT9L8K+CK7rKEw+lnV18mw63OhMGapuNCHgZs8/nArDm20Euw0LVeMdDHFa563j/XQWd6YltPnCQH8GPwluQ5QUG3jG//9zCSaz91M7B7mYkiVx8usnzfjXAu3f/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791820395; c=relaxed/relaxed;
	bh=foPf9N2UdFErN6Q+/8B1HWoJgzxGUOzzwkT0HqRELq4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Ql82RI0P4NRyPDEi9xsIVkj4aD3ez8qKWjFVHrTTXc1LkCc8bTpEC5KVUJ8bZbSdisxFh0GK9tsJTF2iuB473S31dJii0jBJfbq4UCW8TpgFGmHzrcX+hHMAEmaSEeV0fuM6AbjrXCyAsp0VvxKjKvm29yXtrLJbOEZCPnbS2n814lBUd4req4yhVbmi/Tkfmo8eCXhJTWUX2s9KPcpefybtT1fLFrkFe65G/nIu0adFgfVIAGMl67EtoH3pmMIGZnPssoCeY2Cw4ZXrD4frkr129v1Q32JwAI7NvSXW2/bbCWVJMHPos8R636s82e1yUJQhq7hn6PeIL3/0otROgw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nURC4Jl+; dkim-atps=neutral; spf=pass (client-ip=192.198.163.15; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nURC4Jl+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=192.198.163.15; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3MSP4b4mz2xwZ
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 02:53:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791820390; x=1823356390;
  h=date:from:to:cc:subject:message-id;
  bh=Ggc6N8738vGamy4NkD6Za77cKIkT3EpXg7+GyVri9NY=;
  b=nURC4Jl+IFqJO7MAhpJRQj8EstdK6EeAQN8j5qPyRMZDfZ1wOJYiYZUw
   rlw0qiOH/4w0Nzmg6Zc0ehWcIoe6XIbjupLdzV3LTprBHv2PRSk4dQIIz
   xosu8+g1I7oQVk3dMlCCdBdYQt9AoGG9lqwu6wWEfjujvIpfzy/BwiYUV
   zUcHKf5W0I3+dREpset27NAPa6k2sqpoF9BzTizj5c5k3fudl2kzhjS7/
   gJ0/8j4E7mcZnF2VgojcWJPMkjj/mvsVULJ+eZlO0SWJbJLQsQe9Cf27k
   J2iRiPsInqHHkMHNKTRCdF/dv3qzjpUZJcHvNyi8feg6R+OfITyeomUR0
   g==;
X-CSE-ConnectionGUID: RMk7uQkkRA6IvUqG4dEhFQ==
X-CSE-MsgGUID: 57ZBgoslQyymBNhnPU2GBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="537662"
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="537662"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 08:53:04 -0700
X-CSE-ConnectionGUID: 3d25pPfFR8670Wgdoh6TfA==
X-CSE-MsgGUID: k3vLK2dZQTKT/4lHBwN0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="890114"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 12 Oct 2026 08:53:01 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGIKh-00000000BkD-26Kg;
	Mon, 12 Oct 2026 15:52:59 +0000
Date: Mon, 12 Oct 2026 23:52:09 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev] BUILD SUCCESS
 cd0f17a0406f7a77bc240e425f5b0e1e1d2a83b4
Message-ID: <202610122306.ljANFqBD-lkp@intel.com>
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
branch HEAD: cd0f17a0406f7a77bc240e425f5b0e1e1d2a83b4  MAINTAINERS: erofs: update my email address

elapsed time: 1154m

configs tested: 440
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2102-20261011    gcc-12.5.0 cocci
alpha                randconfig-r2103-20261011    gcc-15.2.0 cocci
alpha                randconfig-r2106-20261011    clang-24   cocci
alpha                randconfig-r2106-20261011    gcc-13.4.0 cocci
alpha                randconfig-r2111-20261011    gcc-12.5.0 cocci
alpha                randconfig-r2201-20261011    gcc-8.5.0  smatch
alpha                randconfig-r2304-20261011    gcc-16.1.0 sparse
alpha                randconfig-r2309-20261011    clang-24   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261012    gcc-8.5.0
arc                   randconfig-1001-20261012    gcc-8.5.0
arc                   randconfig-2000-20261011    gcc-8.5.0
arc                   randconfig-2001-20261011    gcc-8.5.0
arc                  randconfig-r2104-20261011    gcc-12.5.0 cocci
arc                  randconfig-r2107-20261011    gcc-12.5.0 cocci
arc                  randconfig-r2108-20261011    gcc-10.5.0 cocci
arc                  randconfig-r2109-20261011    gcc-16.1.0 cocci
arc                  randconfig-r2201-20261010    gcc-16.1.0 smatch
arc                  randconfig-r2309-20261011    gcc-13     sparse
arc                  randconfig-r2310-20261011    clang-19   sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261012    gcc-8.5.0
arm                   randconfig-1001-20261012    gcc-8.5.0
arm                   randconfig-1002-20261012    gcc-8.5.0
arm                   randconfig-1003-20261012    gcc-8.5.0
arm                   randconfig-2000-20261011    gcc-8.5.0
arm                   randconfig-2001-20261011    gcc-8.5.0
arm                  randconfig-r2106-20261011    gcc-16.1.0 cocci
arm                  randconfig-r2107-20261011    gcc-9.5.0  cocci
arm                  randconfig-r2109-20261011    clang-24   cocci
arm                  randconfig-r2300-20261011    gcc-8.5.0  sparse
arm                  randconfig-r2301-20261011    gcc-16.1.0 sparse
arm                  randconfig-r2303-20261011    gcc-8.5.0  sparse
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261012    clang-24
arm64                 randconfig-1001-20261012    clang-24
arm64                 randconfig-1002-20261012    clang-24
arm64                 randconfig-1003-20261012    clang-24
arm64                 randconfig-2000-20261011    gcc-16.1.0
arm64                 randconfig-2001-20261011    gcc-16.1.0
arm64                randconfig-r2100-20261011    clang-21   cocci
arm64                randconfig-r2101-20261011    gcc-16.1.0 cocci
arm64                randconfig-r2108-20261011    clang-24   cocci
arm64                randconfig-r2108-20261011    gcc-12.5.0 cocci
arm64                randconfig-r2300-20261011    gcc-8.5.0  sparse
arm64                randconfig-r2308-20261011    clang-19   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261012    clang-24
csky                  randconfig-1001-20261012    clang-24
csky                  randconfig-2000-20261011    gcc-16.1.0
csky                  randconfig-2001-20261011    gcc-16.1.0
csky                 randconfig-r2101-20261011    gcc-12.5.0 cocci
csky                 randconfig-r2102-20261011    gcc-12.5.0 cocci
csky                 randconfig-r2104-20261011    gcc-12.5.0 cocci
csky                 randconfig-r2110-20261011    gcc-16.1.0 cocci
csky                 randconfig-r2110-20261011    gcc-9.5.0  cocci
csky                 randconfig-r2201-20261011    gcc-11.5.0 smatch
csky                 randconfig-r2202-20261011    gcc-9.5.0  smatch
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261012    clang-17
hexagon               randconfig-1001-20261012    clang-17
hexagon               randconfig-2000-20261011    gcc-16.1.0
hexagon               randconfig-2001-20261011    gcc-16.1.0
hexagon              randconfig-r2103-20261011    clang-24   cocci
hexagon              randconfig-r2107-20261011    clang-24   cocci
hexagon              randconfig-r2108-20261011    clang-21   cocci
hexagon              randconfig-r2111-20261011    clang-24   cocci
hexagon              randconfig-r2200-20261011    clang-17   smatch
hexagon              randconfig-r2302-20261011    clang-22   sparse
hexagon              randconfig-r2307-20261011    clang-19   sparse
hexagon              randconfig-r2308-20261011    clang-24   sparse
hexagon              randconfig-r2310-20261011    clang-22   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261012    clang-22
i386        buildonly-randconfig-1001-20261012    clang-22
i386        buildonly-randconfig-1002-20261012    clang-22
i386        buildonly-randconfig-1003-20261012    clang-22
i386        buildonly-randconfig-1004-20261012    clang-22
i386        buildonly-randconfig-1005-20261012    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261012    gcc-14
i386                  randconfig-1001-20261012    gcc-14
i386                  randconfig-1002-20261012    gcc-14
i386                  randconfig-1003-20261012    gcc-14
i386                  randconfig-1004-20261012    gcc-14
i386                  randconfig-1005-20261012    gcc-14
i386                  randconfig-1006-20261012    gcc-14
i386                  randconfig-1007-20261012    clang-22
i386                  randconfig-1008-20261012    clang-22
i386                  randconfig-1009-20261012    clang-22
i386                  randconfig-1010-20261012    clang-22
i386                  randconfig-1011-20261012    clang-22
i386                  randconfig-1012-20261012    clang-22
i386                  randconfig-1013-20261012    clang-22
i386                  randconfig-2000-20261011    gcc-8.5.0
i386                  randconfig-2001-20261011    gcc-8.5.0
i386                  randconfig-2100-20261011    gcc-14     cocci
i386                  randconfig-2101-20261011    gcc-14     cocci
i386                  randconfig-2102-20261011    gcc-14     cocci
i386                  randconfig-2103-20261011    gcc-14     cocci
i386                  randconfig-2104-20261011    gcc-14     cocci
i386                  randconfig-2105-20261011    gcc-14     cocci
i386                  randconfig-2200-20261011    clang-22   smatch
i386                  randconfig-2300-20261010    gcc-14     sparse
i386                  randconfig-2300-20261011    gcc-14     sparse
i386                  randconfig-2301-20261010    gcc-14     sparse
i386                  randconfig-2301-20261011    gcc-14     sparse
i386                  randconfig-2302-20261010    clang-22   sparse
i386                  randconfig-2302-20261011    gcc-14     sparse
i386                 randconfig-r2101-20261011    clang-24   cocci
i386                 randconfig-r2104-20261011    clang-24   cocci
i386                 randconfig-r2108-20261011    gcc-14     cocci
i386                 randconfig-r2200-20261011    clang-22   smatch
i386                 randconfig-r2300-20261011    clang-22   sparse
i386                 randconfig-r2300-20261011    gcc-16.1.0 sparse
i386                 randconfig-r2301-20261011    gcc-8.5.0  sparse
i386                 randconfig-r2303-20261011    gcc-16.1.0 sparse
i386                 randconfig-r2311-20261011    gcc-13     sparse
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261012    clang-17
loongarch             randconfig-1001-20261012    clang-17
loongarch             randconfig-2000-20261011    gcc-8.5.0
loongarch             randconfig-2001-20261011    gcc-8.5.0
loongarch            randconfig-r2102-20261011    gcc-14     cocci
loongarch            randconfig-r2102-20261011    gcc-16.1.0 cocci
loongarch            randconfig-r2104-20261011    gcc-16.1.0 cocci
loongarch            randconfig-r2301-20261011    gcc-8.5.0  sparse
loongarch            randconfig-r2305-20261011    clang-22   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    clang-24
m68k                        m5275evb_defconfig    clang-24
m68k                        m5329evb_defconfig    gcc-16.1.0
m68k                 randconfig-r2101-20261011    gcc-14     cocci
m68k                 randconfig-r2104-20261011    gcc-9.5.0  cocci
m68k                 randconfig-r2202-20261011    gcc-16.1.0 smatch
m68k                 randconfig-r2302-20261011    clang-22   sparse
m68k                 randconfig-r2306-20261011    clang-22   sparse
m68k                 randconfig-r2310-20261011    gcc-13     sparse
m68k                 randconfig-r2311-20261011    clang-22   sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2103-20261011    gcc-14     cocci
microblaze           randconfig-r2104-20261011    gcc-13.4.0 cocci
microblaze           randconfig-r2105-20261011    gcc-12.5.0 cocci
microblaze           randconfig-r2107-20261011    gcc-16.1.0 cocci
microblaze           randconfig-r2109-20261011    gcc-15.2.0 cocci
microblaze           randconfig-r2303-20261011    clang-22   sparse
microblaze           randconfig-r2305-20261011    clang-22   sparse
microblaze           randconfig-r2306-20261011    clang-24   sparse
microblaze           randconfig-r2307-20261011    clang-22   sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ip27_defconfig    gcc-16.1.0
mips                            ip30_defconfig    clang-24
mips                 randconfig-r2100-20261011    clang-24   cocci
mips                 randconfig-r2100-20261011    gcc-16.1.0 cocci
mips                 randconfig-r2106-20261011    clang-24   cocci
mips                 randconfig-r2202-20261011    gcc-15.2.0 smatch
mips                 randconfig-r2302-20261011    gcc-16.1.0 sparse
mips                 randconfig-r2302-20261011    gcc-8.5.0  sparse
mips                 randconfig-r2303-20261011    clang-22   sparse
mips                 randconfig-r2305-20261011    gcc-8.5.0  sparse
mips                 randconfig-r2306-20261011    gcc-13     sparse
mips                 randconfig-r2310-20261011    clang-24   sparse
mips                           rb532_defconfig    clang-24
nios2                          10m50_defconfig    gcc-16.1.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261012    clang-17
nios2                 randconfig-1001-20261012    clang-17
nios2                 randconfig-2000-20261011    gcc-8.5.0
nios2                 randconfig-2001-20261011    gcc-8.5.0
nios2                randconfig-r2102-20261011    gcc-16.1.0 cocci
nios2                randconfig-r2103-20261011    gcc-12.5.0 cocci
nios2                randconfig-r2105-20261011    clang-24   cocci
nios2                randconfig-r2106-20261011    gcc-8.5.0  cocci
nios2                randconfig-r2107-20261011    clang-24   cocci
nios2                randconfig-r2108-20261011    gcc-16.1.0 cocci
nios2                randconfig-r2110-20261011    gcc-12.5.0 cocci
nios2                randconfig-r2200-20261011    gcc-8.5.0  smatch
nios2                randconfig-r2301-20261011    gcc-16.1.0 sparse
nios2                randconfig-r2308-20261011    clang-22   sparse
nios2                randconfig-r2311-20261011    clang-19   sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2100-20261011    gcc-12.5.0 cocci
openrisc             randconfig-r2105-20261011    gcc-16.1.0 cocci
openrisc             randconfig-r2107-20261011    gcc-16.1.0 cocci
openrisc             randconfig-r2111-20261011    gcc-16.1.0 cocci
openrisc             randconfig-r2200-20261011    gcc-16.1.0 smatch
openrisc             randconfig-r2201-20261011    gcc-9.5.0  smatch
openrisc             randconfig-r2300-20261011    gcc-16.1.0 sparse
openrisc             randconfig-r2304-20261011    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261012    gcc-8.5.0
parisc                randconfig-1001-20261012    gcc-8.5.0
parisc                randconfig-2000-20261011    gcc-8.5.0
parisc                randconfig-2001-20261011    gcc-8.5.0
parisc               randconfig-r2101-20261011    gcc-12.5.0 cocci
parisc               randconfig-r2102-20261011    gcc-12.5.0 cocci
parisc               randconfig-r2108-20261011    gcc-12.5.0 cocci
parisc               randconfig-r2110-20261011    clang-24   cocci
parisc               randconfig-r2111-20261011    gcc-16.1.0 cocci
parisc               randconfig-r2307-20261011    clang-24   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                     amigaone_defconfig    gcc-16.1.0
powerpc                    bluestone_defconfig    clang-24
powerpc                       ep88xc_defconfig    clang-24
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc                    motionpro_defconfig    gcc-16.1.0
powerpc                  mpc837x_rdb_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261012    gcc-8.5.0
powerpc               randconfig-1001-20261012    gcc-8.5.0
powerpc               randconfig-2000-20261011    clang-22
powerpc               randconfig-2001-20261011    clang-22
powerpc              randconfig-r2100-20261011    gcc-12.5.0 cocci
powerpc              randconfig-r2100-20261011    gcc-16.1.0 cocci
powerpc              randconfig-r2109-20261011    gcc-14     cocci
powerpc              randconfig-r2200-20261011    clang-21   smatch
powerpc              randconfig-r2301-20261011    clang-22   sparse
powerpc              randconfig-r2302-20261011    gcc-8.5.0  sparse
powerpc              randconfig-r2304-20261011    clang-22   sparse
powerpc              randconfig-r2304-20261011    gcc-8.5.0  sparse
powerpc              randconfig-r2311-20261011    clang-24   sparse
powerpc                       tqm8xx_defconfig    clang-24
powerpc64             randconfig-1000-20261012    gcc-8.5.0
powerpc64             randconfig-1001-20261012    gcc-8.5.0
powerpc64             randconfig-2000-20261011    clang-22
powerpc64             randconfig-2001-20261011    clang-22
powerpc64            randconfig-r2104-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2105-20261011    clang-24   cocci
powerpc64            randconfig-r2106-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2109-20261011    clang-21   cocci
powerpc64            randconfig-r2202-20261011    gcc-10.5.0 smatch
powerpc64            randconfig-r2304-20261011    gcc-8.5.0  sparse
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261012    clang-24
riscv                 randconfig-1001-20261012    clang-24
riscv                 randconfig-2000-20261011    gcc-13.4.0
riscv                 randconfig-2000-20261011    gcc-8.5.0
riscv                 randconfig-2001-20261011    gcc-13.4.0
riscv                 randconfig-2001-20261011    gcc-8.5.0
riscv                randconfig-r2100-20261011    clang-24   cocci
riscv                randconfig-r2101-20261011    gcc-16.1.0 cocci
riscv                randconfig-r2110-20261011    clang-24   cocci
riscv                randconfig-r2110-20261011    gcc-8.5.0  cocci
riscv                randconfig-r2305-20261011    gcc-16.1.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261012    clang-24
s390                  randconfig-1001-20261012    clang-24
s390                  randconfig-2000-20261011    clang-17
s390                  randconfig-2000-20261011    gcc-13.4.0
s390                  randconfig-2001-20261011    clang-24
s390                  randconfig-2001-20261011    gcc-13.4.0
s390                 randconfig-r2105-20261011    gcc-9.5.0  cocci
s390                 randconfig-r2109-20261011    gcc-12.5.0 cocci
s390                 randconfig-r2111-20261011    gcc-12.5.0 cocci
s390                 randconfig-r2111-20261011    gcc-9.5.0  cocci
s390                 randconfig-r2201-20261011    gcc-15.2.0 smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261012    clang-24
sh                    randconfig-1001-20261012    clang-24
sh                    randconfig-2000-20261011    gcc-13.4.0
sh                    randconfig-2001-20261011    gcc-13.4.0
sh                    randconfig-2001-20261011    gcc-16.1.0
sh                   randconfig-r2103-20261011    gcc-16.1.0 cocci
sh                   randconfig-r2107-20261011    gcc-11.5.0 cocci
sh                   randconfig-r2110-20261011    gcc-16.1.0 cocci
sh                   randconfig-r2303-20261011    gcc-16.1.0 sparse
sh                           rsk7201_defconfig    gcc-16.1.0
sh                           rsk7203_defconfig    gcc-16.1.0
sh                           sdk7780_defconfig    gcc-16.1.0
sparc                             alldefconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261012    clang-20
sparc                 randconfig-1001-20261012    clang-20
sparc                 randconfig-2000-20261010    gcc-8.5.0
sparc                 randconfig-2000-20261011    gcc-8.5.0
sparc                 randconfig-2001-20261010    gcc-16.1.0
sparc                 randconfig-2001-20261011    gcc-8.5.0
sparc                randconfig-r2100-20261011    gcc-14     cocci
sparc                randconfig-r2102-20261011    clang-24   cocci
sparc                randconfig-r2107-20261011    gcc-16.1.0 cocci
sparc                randconfig-r2108-20261011    gcc-16.1.0 cocci
sparc                randconfig-r2110-20261011    gcc-16.1.0 cocci
sparc                randconfig-r2111-20261011    clang-24   cocci
sparc                randconfig-r2300-20261011    gcc-8.5.0  sparse
sparc                randconfig-r2304-20261011    gcc-8.5.0  sparse
sparc                randconfig-r2308-20261011    gcc-13     sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261012    clang-20
sparc64               randconfig-1001-20261012    clang-20
sparc64               randconfig-2000-20261010    gcc-8.5.0
sparc64               randconfig-2000-20261011    gcc-8.5.0
sparc64               randconfig-2001-20261010    clang-21
sparc64               randconfig-2001-20261011    gcc-8.5.0
sparc64              randconfig-r2102-20261011    clang-21   cocci
sparc64              randconfig-r2103-20261011    clang-21   cocci
sparc64              randconfig-r2103-20261011    gcc-16.1.0 cocci
sparc64              randconfig-r2104-20261011    clang-24   cocci
sparc64              randconfig-r2106-20261011    gcc-12.5.0 cocci
sparc64              randconfig-r2111-20261011    clang-24   cocci
sparc64              randconfig-r2304-20261011    clang-22   sparse
sparc64              randconfig-r2305-20261011    gcc-16.1.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261012    clang-20
um                    randconfig-1001-20261012    clang-20
um                    randconfig-2000-20261010    clang-24
um                    randconfig-2000-20261011    gcc-8.5.0
um                    randconfig-2001-20261010    clang-24
um                    randconfig-2001-20261011    gcc-8.5.0
um                   randconfig-r2101-20261011    clang-21   cocci
um                   randconfig-r2105-20261011    gcc-16.1.0 cocci
um                   randconfig-r2106-20261011    gcc-9.5.0  cocci
um                   randconfig-r2109-20261011    gcc-12.5.0 cocci
um                   randconfig-r2109-20261011    gcc-16.1.0 cocci
um                   randconfig-r2202-20261011    gcc-14     smatch
um                   randconfig-r2302-20261011    gcc-16.1.0 sparse
um                   randconfig-r2302-20261011    gcc-8.5.0  sparse
um                   randconfig-r2305-20261011    gcc-8.5.0  sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261012    clang-22
x86_64      buildonly-randconfig-1001-20261012    clang-22
x86_64      buildonly-randconfig-1002-20261012    clang-22
x86_64      buildonly-randconfig-1003-20261012    clang-22
x86_64      buildonly-randconfig-1004-20261012    clang-22
x86_64      buildonly-randconfig-1005-20261012    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261012    clang-22
x86_64                randconfig-1001-20261012    clang-22
x86_64                randconfig-1002-20261012    clang-22
x86_64                randconfig-1003-20261012    clang-22
x86_64                randconfig-1004-20261012    clang-22
x86_64                randconfig-1005-20261012    clang-22
x86_64                randconfig-1006-20261012    clang-22
x86_64                randconfig-1007-20261012    clang-22
x86_64                randconfig-1008-20261012    clang-22
x86_64                randconfig-1009-20261012    clang-22
x86_64                randconfig-1010-20261012    clang-22
x86_64                randconfig-1011-20261012    clang-22
x86_64                randconfig-1012-20261012    gcc-14
x86_64                randconfig-1013-20261012    gcc-14
x86_64                randconfig-1014-20261012    gcc-14
x86_64                randconfig-1015-20261012    gcc-14
x86_64                randconfig-1016-20261012    gcc-14
x86_64                randconfig-1017-20261012    gcc-14
x86_64                randconfig-2000-20261011    clang-22
x86_64                randconfig-2001-20261011    clang-22
x86_64                randconfig-2100-20261011    gcc-12     cocci
x86_64                randconfig-2100-20261011    gcc-14     cocci
x86_64                randconfig-2101-20261011    gcc-14     cocci
x86_64                randconfig-2102-20261011    gcc-14     cocci
x86_64                randconfig-2103-20261011    gcc-14     cocci
x86_64                randconfig-2104-20261011    clang-22   cocci
x86_64                randconfig-2104-20261011    gcc-14     cocci
x86_64                randconfig-2105-20261011    gcc-14     cocci
x86_64                randconfig-2200-20261011    clang-22   smatch
x86_64                randconfig-2300-20261010    clang-22   sparse
x86_64                randconfig-2300-20261011    gcc-14     sparse
x86_64                randconfig-2301-20261010    clang-22   sparse
x86_64                randconfig-2301-20261011    gcc-14     sparse
x86_64                randconfig-2302-20261010    clang-22   sparse
x86_64                randconfig-2302-20261011    gcc-14     sparse
x86_64               randconfig-r2105-20261011    clang-22   cocci
x86_64               randconfig-r2202-20261011    clang-22   smatch
x86_64               randconfig-r2300-20261011    clang-22   sparse
x86_64               randconfig-r2301-20261011    clang-22   sparse
x86_64               randconfig-r2305-20261011    gcc-8.5.0  sparse
x86_64               randconfig-r2307-20261011    gcc-13     sparse
x86_64               randconfig-r2309-20261011    clang-19   sparse
x86_64               randconfig-r2309-20261011    clang-22   sparse
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
xtensa                randconfig-1000-20261012    clang-20
xtensa                randconfig-1001-20261012    clang-20
xtensa                randconfig-2000-20261010    gcc-10.5.0
xtensa                randconfig-2000-20261011    gcc-8.5.0
xtensa                randconfig-2001-20261010    gcc-16.1.0
xtensa                randconfig-2001-20261011    gcc-8.5.0
xtensa               randconfig-r2101-20261011    gcc-12.5.0 cocci
xtensa               randconfig-r2303-20261011    gcc-8.5.0  sparse
xtensa               randconfig-r2306-20261011    clang-19   sparse
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

