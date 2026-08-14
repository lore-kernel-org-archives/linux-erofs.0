Return-Path: <linux-erofs+bounces-4226-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A825C5B572
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 20:55:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMDyz31Rkz2yS0;
	Sat, 15 Aug 2026 06:55:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786740955;
	cv=none; b=cLPurCBx/ejY2O2V1Iu24S1Ux3dpQ7mE/rS/79jW8C4vR4YODYxbm4AfYl7OkBf2EXwMKClxsGh+aD24d+GVzc13RI7V/01Oo44/LGO8DCQd5ttn0ORpqiJ0acIaLuYa/HpucDkhsDZCUjjtkrR1dZfe1Kmj99dFInv8OwOB2Q6lbf1W+AJM/bkrXEQvVC7MQ9t7rf1PdVdZnS4u9lw8/ni67dbFZ9TFJ7/K1ZJby55qcoN6Arx4bMIsB83yoVWlrxmicjoOMPYQI1xW4eSrYVL9NhB3gLwYFLhEwEo/wd2BcJgo5ifUivUf5vvoYiLL9+6xWWRkNg9NNZ2DNFPXlg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786740955; c=relaxed/relaxed;
	bh=1heJPzMaBEY7pWxsPekMRYHar1jRyRzcJj5CVsxCGzE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=T/5PMqXLqPplsoFO7bA2w1e78rMTqHkrLBrRSAxOEzwqv/+SV1xgKmDCCVxUlTMlVNadIkVETRUm6SxWEstFb+p8RJ8FDWYkTZZUkZGlDrOxh9sh/F6HLkf63WuMvujR/x1eLIIjqIGOcaSYVAn3K05ArLn4PXiBHOusZpJWm4OmVR7POyX4bAVufbQELU3KNrgX3RmYBwwoinNaNallwcwuQys9YRhcSim9V43cJe5czyYQiOSygZ0iPGcfXigUvEUjqJiYHQ3kNLTnKKxUXxVoc69fSdyQrThJkphQGScbwMcqghiCY68ttN5Q5NTJqsU+idRTwKaMXIiAtoWRTg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PxgxOsF5; dkim-atps=neutral; spf=pass (client-ip=198.175.65.17; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PxgxOsF5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.17; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMDyv4mnNz2xyk
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 06:55:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786740953; x=1818276953;
  h=date:from:to:cc:subject:message-id;
  bh=AxbiE4qEmZ4w1FLY7OAZFJ4VoNOV3v06lW0qS47n95w=;
  b=PxgxOsF5KWCMyXuo4jjka5N/gMBP4H9C/fGV+AOx7hCnegH+1+ZH6cQu
   MytxkghwlEsJgzBgR3Fpxq4W2y+jqmdcP+rEjwCIdsmlnqSkVhgu5iAFt
   2HcIr8yhm/ZmB3lsyr4eCO53JdllLb/VfcYIkqgoHj9hl8ZfvksHSYzzz
   ePd2xSwwEAYLBt+Jm4ldyk+Y2L6QJtXUMIZw2jk/WHB4bH9rRvUZ+PZDN
   i16AtIPdtrFTBLdCsejTDuOyIQaCryKDjkvjQJ4AL36u05mWji3M6xF64
   c+fuGClICb1pstjyKjtdOlvRPoqxa3aX5g8/5FpffTXJQoqHrgNhYmZJL
   w==;
X-CSE-ConnectionGUID: RT7RUN8FSEixb18ix9j/gQ==
X-CSE-MsgGUID: NTFRnFrKT/qCU7WREptMcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="87345161"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="87345161"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 13:55:44 -0700
X-CSE-ConnectionGUID: FkBRrr9sSg+m0NRwX6QaIw==
X-CSE-MsgGUID: vPzrJoW2TCuV6PLoJMx1cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="262555544"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 14 Aug 2026 13:55:44 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuywH-00000000aAq-0VGw;
	Fri, 14 Aug 2026 20:55:41 +0000
Date: Sat, 15 Aug 2026 04:55:05 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [xiang-erofs:dev] BUILD SUCCESS
 69a7da56adc40e42211905946b65d938ae14747a
Message-ID: <202608150454.2bsrcnuV-lkp@intel.com>
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
branch HEAD: 69a7da56adc40e42211905946b65d938ae14747a  erofs: guard on-disk algorithm IDs against Z_EROFS_COMPRESSION_MAX

elapsed time: 746m

configs tested: 16
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                 allnoconfig    gcc-16.1.0
alpha                allyesconfig    gcc-16.1.0
alpha                   defconfig    gcc-16.1.0
arc                  allmodconfig    gcc-16.1.0
arc                  allyesconfig    gcc-16.1.0
csky                 allmodconfig    gcc-16.1.0
i386                 allmodconfig    gcc-14
loongarch               defconfig    clang-24
mips       sb1250_swarm_defconfig    gcc-16.1.0
nios2                allmodconfig    gcc-11.5.0
nios2                 allnoconfig    gcc-11.5.0
parisc               allmodconfig    gcc-16.1.0
parisc               allyesconfig    gcc-16.1.0
parisc                  defconfig    gcc-16.1.0
powerpc              g5_defconfig    gcc-16.1.0
sh                      defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

