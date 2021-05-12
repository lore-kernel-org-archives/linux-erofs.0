Return-Path: <SRS0=IhhL=KH=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CA1C433B4
	for <linux-erofs@archiver.kernel.org>; Wed, 12 May 2021 08:50:55 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BCE7613EE
	for <linux-erofs@archiver.kernel.org>; Wed, 12 May 2021 08:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BCE7613EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Fg7mY5NrJz2yZ2
	for <linux-erofs@archiver.kernel.org>; Wed, 12 May 2021 18:50:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=intel.com (client-ip=134.134.136.100; helo=mga07.intel.com;
 envelope-from=lkp@intel.com; receiver=<UNKNOWN>)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Fg7mT3zCxz2xvN
 for <linux-erofs@lists.ozlabs.org>; Wed, 12 May 2021 18:50:42 +1000 (AEST)
IronPort-SDR: J6YrALfBTnJPlZdLBsZq+YPsP53RvVQGHPXxLNo8KL+RZQUL98ivm7o82u8ma22qwumkv4hfwq
 EwjpYiNefHOQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="263582177"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; d="scan'208";a="263582177"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 12 May 2021 01:50:36 -0700
IronPort-SDR: WrzOk78yuzHaVpksydzynV/JfWtM5pnEheC5uiPiE+DCGfRr3dIpECl0R7bpLg00VdZ2VmnD8b
 Mitau9CWxMMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; d="scan'208";a="435107147"
Received: from lkp-server01.sh.intel.com (HELO 1e931876798f) ([10.239.97.150])
 by fmsmga008.fm.intel.com with ESMTP; 12 May 2021 01:50:33 -0700
Received: from kbuild by 1e931876798f with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1lgkZd-0000D6-79; Wed, 12 May 2021 08:50:33 +0000
Date: Wed, 12 May 2021 16:49:56 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Subject: [xiang-erofs:fixes] BUILD SUCCESS
 46f2e04484aee056c97f79162da83ac7d2d621bb
Message-ID: <609b96b4.nE9gpCenKr4R3yDg%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git fixes
branch HEAD: 46f2e04484aee056c97f79162da83ac7d2d621bb  erofs: update documentation about data compression

elapsed time: 1426m

configs tested: 152
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
x86_64                           allyesconfig
riscv                            allmodconfig
i386                             allyesconfig
riscv                            allyesconfig
powerpc                    amigaone_defconfig
mips                      malta_kvm_defconfig
arm                           u8500_defconfig
sh                            hp6xx_defconfig
sh                  sh7785lcr_32bit_defconfig
powerpc                     tqm8541_defconfig
powerpc                 mpc834x_itx_defconfig
powerpc                     rainier_defconfig
powerpc                      ppc64e_defconfig
arm                         s3c2410_defconfig
arm                           viper_defconfig
openrisc                  or1klitex_defconfig
m68k                          amiga_defconfig
mips                           xway_defconfig
sh                           se7712_defconfig
arm                          collie_defconfig
powerpc                     ppa8548_defconfig
mips                     decstation_defconfig
m68k                        m5407c3_defconfig
arm                            xcep_defconfig
powerpc                   currituck_defconfig
mips                         tb0226_defconfig
arm                        clps711x_defconfig
powerpc                  storcenter_defconfig
powerpc                     stx_gp3_defconfig
xtensa                  cadence_csp_defconfig
sh                           se7721_defconfig
sh                          polaris_defconfig
mips                           ip27_defconfig
sh                           se7751_defconfig
arm                            pleb_defconfig
powerpc                     pseries_defconfig
xtensa                generic_kc705_defconfig
arc                                 defconfig
arm                             mxs_defconfig
arm                           tegra_defconfig
ia64                             alldefconfig
mips                       lemote2f_defconfig
arm                        spear3xx_defconfig
arm                              alldefconfig
sh                          lboxre2_defconfig
powerpc                       maple_defconfig
xtensa                         virt_defconfig
arc                 nsimosci_hs_smp_defconfig
sh                        edosk7760_defconfig
mips                       capcella_defconfig
openrisc                            defconfig
sparc64                             defconfig
arm                        neponset_defconfig
powerpc                  mpc866_ads_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                      bamboo_defconfig
riscv                             allnoconfig
s390                                defconfig
nios2                         3c120_defconfig
xtensa                    xip_kc705_defconfig
powerpc                    socrates_defconfig
powerpc                    mvme5100_defconfig
mips                            e55_defconfig
arm                         axm55xx_defconfig
powerpc                 xes_mpc85xx_defconfig
mips                        jmr3927_defconfig
sh                        dreamcast_defconfig
mips                        workpad_defconfig
powerpc                     pq2fads_defconfig
arm                           sama5_defconfig
powerpc                   lite5200b_defconfig
mips                     loongson1c_defconfig
mips                          malta_defconfig
m68k                          sun3x_defconfig
powerpc64                        alldefconfig
s390                          debug_defconfig
m68k                        m5307c3_defconfig
powerpc                 linkstation_defconfig
arm                       netwinder_defconfig
sh                           sh2007_defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
xtensa                           allyesconfig
h8300                            allyesconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a003-20210511
i386                 randconfig-a001-20210511
i386                 randconfig-a005-20210511
i386                 randconfig-a004-20210511
i386                 randconfig-a002-20210511
i386                 randconfig-a006-20210511
x86_64               randconfig-a012-20210511
x86_64               randconfig-a015-20210511
x86_64               randconfig-a011-20210511
x86_64               randconfig-a013-20210511
x86_64               randconfig-a016-20210511
x86_64               randconfig-a014-20210511
i386                 randconfig-a016-20210511
i386                 randconfig-a014-20210511
i386                 randconfig-a011-20210511
i386                 randconfig-a015-20210511
i386                 randconfig-a012-20210511
i386                 randconfig-a013-20210511
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a003-20210511
x86_64               randconfig-a004-20210511
x86_64               randconfig-a001-20210511
x86_64               randconfig-a005-20210511
x86_64               randconfig-a002-20210511
x86_64               randconfig-a006-20210511

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
