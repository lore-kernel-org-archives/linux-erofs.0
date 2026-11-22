Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48520606A32A
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXDdR0T6Rz2yQG;
	Sun, 22 Nov 2026 14:12:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795317131;
	cv=none; b=WkHUyorHQzFykMoFjH+4oOEYnaj0NMewf+Cr+SEobre2Xg3ei+dL9+Tcl9d4jJ4F1xMXbz+Z7ZExUcctLu37LZQDMLvO3SB3d1zEPjkkJ1pbbQ5V5sxGqAwkIB38I00ww8kwwzad1/nij6S83HJ+7EJR1AIVQNqTpl45PFVqF+lDXamQ5Mln4d3lOIfDBEQy7/l9jaaX8VRh1KubezISLnKQmtLC7HmuFt14ZNooLpQkDfdxOlL4rJ73SlFeoh2LvltFrcq87GDI4/gul/3NILBIqV34yo9/JoRHq/e8hAZAan+s6LnGy2eq3LJcmrMr6TC2+iJesF2/BQJiJmE1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795317131; c=relaxed/relaxed;
	bh=pzj026Pw3u7TCg6fcU61XBmFQt2ZGMmoyynDkc5E00Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BxuWD+B74BxrzcqoWL0IB6lKmsqXYpU5LFykArAiyOrfoYugkkslAaoqDX2GtQVQFGyUNqPRlDvHtsfmsSI/wDmlkU86N27+22lTM46DRdXICuZLiQotGFoIlZGWmyJ6Ap8q0XU4cpnYHjoOqJZRMND6eB0Y8VpK02q0SM0kq08R4dlESLdVIBEcFt7ABPwU11gSPcw0GUfJHBHXF7f6gPqPTaqfk9zgsfet/a70NQXwwWUXGBFtolyhfpWR+XI9QMX78ku2kozVmFNebRt2s6nwq4KDK4duY+tZxfCGlWChFDjI+rJDlv7jSCjqx62LVFUMbGdXA5xuVlyjYcj6Mg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org) smtp.mailfrom=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mails.ucas.ac.cn (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org)
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXDdL4ZTxz2yMk
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 14:12:05 +1100 (AEDT)
Received: from localhost.localdomain (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnUvy6WwJrpQZzAQ--.19540S2;
	Sun, 22 Nov 2026 11:04:33 +0800 (CST)
From: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
To: linux-erofs@lists.ozlabs.org
Cc: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>,
	Gao Xiang <xiang@kernel.org>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH 0/4] erofs-utils: mkfs: add --hot-file-list for cold-start locality
Date: Sun, 22 Nov 2026 11:04:19 +0800
Message-ID: <cover.1795283997.git.yanmengdie24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnUvy6WwJrpQZzAQ--.19540S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KryxWw1fJw1DZr1ftw1kKrg_yoW8KF17p3
	98Ka4fJrZ5Z342y393Zr40ga4fXayrAry5W3W7XryxZFy5Jr1vqas5KFn0gFyUGrWrGayU
	Zry2v398urn8A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvj14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr
	1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS
	5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
	twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5X
	dbUUUUU
X-CM-SenderInfo: 51dqzv5qjgxvysu6ztxlovh3xfdvhtffof0/
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

When a container image is lazily loaded, its first start reads a small
and mostly fixed set of files, whose data is spread across the image in
directory traversal order.  This turns the cold start into many small
random reads.

This series adds a --hot-file-list option to mkfs.erofs:

  mkfs.erofs --hot-file-list=startup.list foo.erofs rootfs/

The list holds one image-relative path per line, typically recorded
from a startup trace.  Data of the listed regular files is allocated
ahead of other files in list order, while unlisted files keep their
relative order.  Directories and symlinks along the listed paths are
prioritized as well.  Paths are resolved inside the image root, and
missing entries are reported and skipped.  Without the option, the
output is unchanged.

Patch 1 adds the list parser and a hot pass in erofs_mkfs_dump_tree()
for local directories.  Patch 2 supports compression and keeps hot
files out of fragments, since the packed inode is written last.
Patches 3 and 4 add tar and OCI imports, where paths are resolved
against the final imported tree.

With elasticsearch:8.13.0 and a list recorded from a real startup (610
regular files, 441 MB), reading the hot files in order from a cold loop
device took 573 ms instead of 793 ms (-28%, median of 15 pairs).

Tested with local directory, tar and OCI sources and various compression
options; image contents were verified with fsck.erofs and kernel mounts.

A regression test for experimental-tests is sent separately.

This series is based on erofs-utils dev at 652a204d0ec6.

Thanks,
Mengdie Yan

Mengdie Yan (4):
  erofs-utils: mkfs: prioritize hot files in directory sources
  erofs-utils: mkfs: preserve hot file placement during compression
  erofs-utils: mkfs: support hot file lists for full TAR imports
  erofs-utils: mkfs: support hot file lists for full OCI imports

 include/erofs/hotfile.h  |  25 ++
 include/erofs/internal.h |  11 +
 lib/Makefile.am          |   2 +
 lib/compress.c           |  19 +-
 lib/hotfile.c            | 754 +++++++++++++++++++++++++++++++++++++++
 lib/inode.c              | 202 ++++++++++-
 man/mkfs.erofs.1         |  24 ++
 mkfs/main.c              |  65 ++++
 8 files changed, 1091 insertions(+), 11 deletions(-)
 create mode 100644 include/erofs/hotfile.h
 create mode 100644 lib/hotfile.c


base-commit: 652a204d0ec628c887df88c95f76073502704c52
-- 
2.50.1 (Apple Git-155)


