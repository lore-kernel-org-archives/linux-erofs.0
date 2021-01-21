Return-Path: <SRS0=hezN=GY=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49ECC433E0
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Jan 2021 16:40:31 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 224A023A1C
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Jan 2021 16:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 224A023A1C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mail.scut.edu.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DM7RZ63mfzDrS7
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Jan 2021 03:40:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=mail.scut.edu.cn (client-ip=202.38.213.20; helo=mail.scut.edu.cn;
 envelope-from=sehuww@mail.scut.edu.cn; receiver=<UNKNOWN>)
Received: from mail.scut.edu.cn (stumail1.scut.edu.cn [202.38.213.20])
 by lists.ozlabs.org (Postfix) with ESMTP id 4DM7Qx2nr1zDqW5
 for <linux-erofs@lists.ozlabs.org>; Fri, 22 Jan 2021 03:39:52 +1100 (AEDT)
Received: from DESKTOP-N4CECTO.huww98.cn (unknown [59.53.40.31])
 by front (Coremail) with SMTP id AWSowADn7eFDrglgpLbbAQ--.1175S4;
 Fri, 22 Jan 2021 00:39:33 +0800 (CST)
From: Hu Weiwen <sehuww@mail.scut.edu.cn>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 0/7] Setup tests
Date: Fri, 22 Jan 2021 00:37:08 +0800
Message-Id: <20210121163715.10660-1-sehuww@mail.scut.edu.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AWSowADn7eFDrglgpLbbAQ--.1175S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJF47Cr1xAw1ktryftry7ZFb_yoW5AF4xp3
 s0kr1Fqw1xCF97Cw1S9wnrZ3Z8KFWxJr1UA347Ar10yF1jvr1j9w4xKrnxAr43Wr40gw47
 Zas2vrWfWr1rAwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
 6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
 4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_JwCF
 04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
 18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vI
 r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
 1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
 0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUjYLkUUUUU=
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAHBlepTBDfZQATsL
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi all,

I have successfully got all tests work on GitHub Actions, including:

make check (skip all tests that requires mount)
sudo make check (mount with kernel support)
FSTYPE=erofsfuse make check (mount with erofsfuse)
make distcheck

Each test is run on two configuration: build with lz4 v1.8.3, and build without
lz4.

Note that fuse related tests will need this patch [1] to success.

[1]: https://lore.kernel.org/linux-erofs/20210121163143.9481-1-sehuww@mail.scut.edu.cn/

Hu Weiwen (7):
  erofs-utils: tests: fix when lz4 is not enabled
  erofs-utils: tests: fix on out-of-tree build
  erofs-utils: tests: fix memory leakage in fssum
  erofs-utils: tests: fix distcheck
  erofs-utils: tests: check battach on full buffer block
  erofs-utils: tests: fix fuse build order
  erofs-utils: tests: enable GitHub Actions

 .github/workflows/c.yml          | 49 ++++++++++++++++++++++++++++
 .gitignore                       |  2 ++
 Makefile.am                      |  3 +-
 lib/Makefile.am                  | 19 ++++++++++-
 tests/Makefile.am                | 26 +++++++++++++++
 tests/common/rc                  |  2 +-
 tests/erofs/001                  |  2 +-
 tests/erofs/{001.out => 001-out} |  0
 tests/erofs/002                  |  2 +-
 tests/erofs/{002.out => 002-out} |  0
 tests/erofs/003                  |  2 +-
 tests/erofs/{003.out => 003-out} |  0
 tests/erofs/004                  |  2 +-
 tests/erofs/{004.out => 004-out} |  0
 tests/erofs/005                  |  2 +-
 tests/erofs/{005.out => 005-out} |  0
 tests/erofs/006                  |  2 +-
 tests/erofs/{006.out => 006-out} |  0
 tests/erofs/007                  |  4 +--
 tests/erofs/{007.out => 007-out} |  0
 tests/erofs/008                  |  2 +-
 tests/erofs/{008.out => 008-out} |  0
 tests/erofs/009                  |  2 +-
 tests/erofs/{009.out => 009-out} |  0
 tests/erofs/010                  |  2 +-
 tests/erofs/{010.out => 010-out} |  0
 tests/erofs/011                  |  2 +-
 tests/erofs/{011.out => 011-out} |  0
 tests/erofs/012                  |  2 +-
 tests/erofs/{012.out => 012-out} |  0
 tests/erofs/013                  |  2 +-
 tests/erofs/{013.out => 013-out} |  0
 tests/erofs/014                  |  2 +-
 tests/erofs/{014.out => 014-out} |  0
 tests/erofs/015                  | 55 ++++++++++++++++++++++++++++++++
 tests/erofs/015-out              |  2 ++
 tests/src/Makefile.am            |  5 +--
 tests/src/fssum.c                | 31 ++++++++++--------
 38 files changed, 190 insertions(+), 34 deletions(-)
 create mode 100644 .github/workflows/c.yml
 rename tests/erofs/{001.out => 001-out} (100%)
 rename tests/erofs/{002.out => 002-out} (100%)
 rename tests/erofs/{003.out => 003-out} (100%)
 rename tests/erofs/{004.out => 004-out} (100%)
 rename tests/erofs/{005.out => 005-out} (100%)
 rename tests/erofs/{006.out => 006-out} (100%)
 rename tests/erofs/{007.out => 007-out} (100%)
 rename tests/erofs/{008.out => 008-out} (100%)
 rename tests/erofs/{009.out => 009-out} (100%)
 rename tests/erofs/{010.out => 010-out} (100%)
 rename tests/erofs/{011.out => 011-out} (100%)
 rename tests/erofs/{012.out => 012-out} (100%)
 rename tests/erofs/{013.out => 013-out} (100%)
 rename tests/erofs/{014.out => 014-out} (100%)
 create mode 100755 tests/erofs/015
 create mode 100644 tests/erofs/015-out

--
2.30.0

