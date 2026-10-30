Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EBB606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Oct 2026 09:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=H2yeLGp6
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jGFtd4Yd8z2yQJ;
	Fri, 30 Oct 2026 20:20:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:cf8:acf:41::8"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793352009;
	cv=none; b=MXzisDDAU8fqCUSoj5y0NFDZXyVbAt3eGrLIvQW0gmztDaa+GuYLG3qUWKguVbd3vJhEmMd9rRnL3RMOQJPdGii3kir8K3EVjEPF2S8C0JWpHmOkE1F2PfXL4xYpdNsFz9Q+ZtQhBf4wCH9IdFtKqfJybDkg5e8ZxN0HTfufPY/8us5UUWv0XAp1Fc5qI4tKMVkZmlXwfLTNENAHZkCJmCLWkG7mBb5bUS3r1AgmmzXm/GrTH0PGIBF1SgTIXf7GOMqOKIa9O1BxSoowqoOZk9dqg26Odr+w1aEU3dfXjk4uVg86p4L6z6lsGBxWlvk4SUixVJNCaU/5TddG/Vx2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793352009; c=relaxed/relaxed;
	bh=7Wt5tl5CZ2TYnYGmzrc8xzq6oScOz56KiW4EHFpEIEY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y6rc4qJp+hXebYqRcJwSbWng9/xp1HPo2GHF3GY8jmvIRKTNJxE1NGgcF0ZjSHNwGQpoFS6V2kpeI12aQ480Y5sR6MEs4clc/Mts1zV2Wiu1dqedheQbzFo5McRDSAoOnmK4Fvo15cNYVdzKPOfk6dUJfzJtbiDi+LNvepvxIVDJvTo5atGVNxMLxhIjmqwwkD6hg+Zd+vbQ8J4gVcpOsZuWNLIO4PG3GhZtB2yPClVB7SIE0YgCw6mqapH0Y5MDBu9ddSAYMrBFZbJhWjXNSb0UQRkrvdFk3+L8yJJtNHFJfsY+vajhUQ/dJgX2KL6iDH8wFtmfddt/EyHD1gMmow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=H2yeLGp6; dkim-atps=neutral; spf=pass (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=H2yeLGp6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from jpms-ob02-os7.noc.sony.co.jp (jpms-ob02-os7.noc.sony.co.jp [IPv6:2001:cf8:acf:41::8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jGFtb2HlHz2yFj
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Oct 2026 20:20:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1793352008; x=1824888008;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7Wt5tl5CZ2TYnYGmzrc8xzq6oScOz56KiW4EHFpEIEY=;
  b=H2yeLGp6Sfo7LQDo2BLZR+mjIGTaAw2d2fe7vUBUNNzV3LZLXW/M0HBY
   0pY2HYZSrlJdfw4U/uRni64ZvdLVyLDUYpfd1cBVyBaVIRFG/wIB82bno
   +8fsevpYvD5A3iZtFlguKcbNawhmlrEotomeEuU4lQ7B236jFlZ0pKOep
   Yn8MwvJg29P8HnMDNaOxYrtH52LYQRshYH8ksti7V19iVsh8wS1waSzNr
   IV/2DxrzV3eSo4iFwGH+67e1IlpWVN8xHD9xonIfgRXLfXVIGSO3JX3lJ
   rhzgQhpF95fXby3pgZYn4HyUPpAxjMOp0FeigxTv9aAsDK8XVSINRRZud
   A==;
X-CSE-ConnectionGUID: DcwMbfV4QNy2TKmcrstu0Q==
X-CSE-MsgGUID: ldbaAREFQXCa3pJIgWYizA==
Received: from unknown (HELO jpmta-ob01-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::6])
  by jpms-ob02-os7.noc.sony.co.jp with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 30 Oct 2026 18:19:56 +0900
X-CSE-ConnectionGUID: oXH0Xu+1SdCp0QRvWfYX8Q==
X-CSE-MsgGUID: pmZMgzzaQ6aavglwTOAWFg==
X-IronPort-AV: E=Sophos;i="6.27,166,1786978800"; 
   d="scan'208";a="78581257"
Received: from unknown (HELO cscsh-5109200313.ap.sony.com) ([43.82.111.223])
  by jpmta-ob01-os7.noc.sony.co.jp with ESMTP; 30 Oct 2026 18:19:56 +0900
From: Friendy Su <friendy.su@sony.com>
To: xiang@kernel.org,
	bluce.lee@aliyun.com,
	jnhuang95@gmail.com,
	hudsonzhu@tencent.com,
	zhaoyifan28@huawei.com
Cc: linux-erofs@lists.ozlabs.org,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>
Subject: [PATCH v1] erofs-utils: tests: add test for fanotify FAN_PRE_ACCESS event
Date: Fri, 30 Oct 2026 17:17:13 +0800
Message-Id: <20261030091713.101900-1-friendy.su@sony.com>
X-Mailer: git-send-email 2.34.1
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
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SB_I_ALLOW_HSM is set in kernel for erofs. Add a test to verify 2 cases below.

case 1: with bdev-based device, FAN_PRE_ACCESS event is triggered.

 # SCRATCH_DEV=/dev/pmem1 make check TESTS=erofs/033

PASS: erofs/033
=============
1 test passed
=============

case 2: with file-backed image, FAN_PRE_ACCESS event fails to mark.

 # SCRATCH_DEV=erofs.img make check TESTS=erofs/033

fs-monitor not started
PASS: erofs/033
=============
1 test passed
=============

Signed-off-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
---
 tests/erofs/033        |  85 +++++++++++++++++++++++
 tests/erofs/033.out    |   2 +
 tests/src/Makefile.am  |   6 +-
 tests/src/fs-monitor.c | 151 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 243 insertions(+), 1 deletion(-)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out
 create mode 100644 tests/src/fs-monitor.c

diff --git a/tests/erofs/033 b/tests/erofs/033
new file mode 100755
index 0000000..fab6d56
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,85 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# 033 - check FAN_PRE_ACCESS fanotify event
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS="/")
+
+# get standard environment, filters and checks
+. "${srcdir}/common/rc"
+
+cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+_require_erofs
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+echo "QA output created by $seq"
+
+if [ -z $SCRATCH_DEV ]; then
+	SCRATCH_DEV=$tmp/erofs_$seq.img
+	rm -f SCRATCH_DEV
+fi
+
+localdir="$tmp/$seq"
+rm -rf $localdir
+mkdir -p $localdir
+
+# create a file for mmap()
+dd if=/dev/urandom of=$localdir/file-2M bs=2M count=1 >> $seqre.full 2>&1
+
+MKFS_OPTIONS="$MKFS_OPTIONS -x1"
+_scratch_mkfs $localdir >> $seqres.full 2>&1 || _fail "failed to mkfs"
+
+# _scratch_mount always mount with '-o loop', file backed mount
+# can not be tested. So mount with ${MOUNT_PROG} directly.
+#_scratch_mount 2>>$seqres.full
+${MOUNT_PROG} ${SCRATCH_DEV} ${SCRATCH_MNT} 2>>$seqres.full
+
+# start fanotify event monitor
+src/fs-monitor ${SCRATCH_MNT} > $tmp.fsmonitor 2>&1 &
+
+fsmonitor_pid=$!
+sleep 1
+
+ps -p ${fsmonitor_pid} > /dev/null
+
+if [ $? -ne 0 ]; then
+	echo "fs-monitor not started" | tee -a $seqres.full >&2
+	if [ ! -f ${SCRATCH_DEV} ]; then
+		echo "fanotify monitor failed to start on non-file-backed image"
+	fi
+	${UMOUNT_PROG} ${SCRATCH_MNT}
+	echo Silence is golden
+	status=0
+	exit 0
+fi
+
+echo "fs-monitor started" | tee -a $seqres.full >&2
+
+# do mmap(), FAN_PRE_ACCESS event will be triggered
+xfs_io -r -c "mmap -r 0 2M" -c close ${SCRATCH_MNT}/file-2M >> $seqres.full
+
+sleep 1
+
+# kill fs-monitor process anyway
+kill -TERM ${fsmonitor_pid}
+
+cat $tmp.fsmonitor >>$seqres.full
+
+(cat $tmp.fsmonitor | grep -q "FAN_PRE_ACCESS EVENT" > /dev/null) || \
+	echo "No FAN_PRE_ACCESS EVENT"
+
+#_scratch_unmount
+${UMOUNT_PROG} ${SCRATCH_MNT}
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/033.out b/tests/erofs/033.out
new file mode 100644
index 0000000..c5d2914
--- /dev/null
+++ b/tests/erofs/033.out
@@ -0,0 +1,2 @@
+QA output created by 033
+Silence is golden
diff --git a/tests/src/Makefile.am b/tests/src/Makefile.am
index 16de41a..d645539 100644
--- a/tests/src/Makefile.am
+++ b/tests/src/Makefile.am
@@ -3,7 +3,7 @@
 
 AUTOMAKE_OPTIONS	= foreign
 check_PROGRAMS		=
-noinst_PROGRAMS		= fssum
+noinst_PROGRAMS		= fssum fs-monitor
 
 fssum_CFLAGS = -Wall -I$(top_srcdir)/include
 fssum_LDADD = $(top_builddir)/lib/liberofs.la
@@ -15,3 +15,7 @@ badlz4_SOURCES = badlz4.c
 badlz4_CFLAGS = ${liblz4_CFLAGS}
 badlz4_LDADD = ${liblz4_LIBS}
 endif
+
+check_PROGRAMS += fs-monitor
+fs_monitor_CFLAGS = -Wall -I$(top_srcdir)/include
+fs_monitor_SOURCES = fs-monitor.c
diff --git a/tests/src/fs-monitor.c b/tests/src/fs-monitor.c
new file mode 100644
index 0000000..07b7a2a
--- /dev/null
+++ b/tests/src/fs-monitor.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Partly copied from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/fanotify/fs-monitor.c
+ */
+
+#include <errno.h>
+#include <err.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/fanotify.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <poll.h>
+
+static void handle_pre_access_event(int fd,
+	       struct fanotify_event_metadata *event)
+{
+	struct fanotify_event_info_header *info;
+	struct fanotify_event_info_range *range;
+	struct fanotify_response response;
+	int off;
+
+
+	for (off = sizeof(*event) ; off < event->event_len;
+	     off += info->len) {
+		info = (struct fanotify_event_info_header *)
+			((char *) event + off);
+
+		switch (info->info_type) {
+		case FAN_EVENT_INFO_TYPE_RANGE:
+			range = (struct fanotify_event_info_range *) info;
+
+			printf("FAN_PRE_ACCESS event range: \n");
+			printf("offset = 0x%llx, count = 0x%llx\n",
+					range->offset, range->count);
+
+			response.fd = event->fd;
+                        response.response = FAN_ALLOW;
+			if (write(fd, &response, sizeof(response)) < 0)
+					perror("Send FAN_PRE_ACCESS response failed");
+
+			break;
+		default:
+			printf("\tUnknown info type=%d len=%d:\n",
+			       info->info_type, info->len);
+			break;
+		}
+
+		fflush(stdout);
+	}
+}
+
+static void handle_notifications(int fd, char *buffer, int len)
+{
+	struct fanotify_event_metadata *event =
+		(struct fanotify_event_metadata *) buffer;
+
+	for (; FAN_EVENT_OK(event, len); event = FAN_EVENT_NEXT(event, len)) {
+
+		if (event->mask == FAN_PRE_ACCESS) {
+
+			/* This msg will be checked in test case */
+			printf("FAN_PRE_ACCESS EVENT (len=%d)\n", event->event_len);
+
+			handle_pre_access_event(fd, event);
+		}
+
+		/* TODO: Add more event handler here */
+
+		printf("---\n\n");
+		fflush(stdout);
+	}
+
+}
+
+int main(int argc, char **argv)
+{
+	int fd, poll_num, opt, nfds;
+	int check = 0;
+	char buffer[BUFSIZ];
+	struct pollfd fds[1];
+
+	if (argc < 2) {
+		printf("Missing path argument\n");
+		return 1;
+	}
+
+	while ((opt = getopt(argc, argv, "c")) != -1) {
+		switch (opt) {
+		case 'c':
+			check = 1;
+			break;
+		default:
+			fprintf(stderr, "Usage: %s [-c] path\n",
+				argv[0]);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	fd = fanotify_init(FAN_CLOEXEC | FAN_CLASS_PRE_CONTENT | FAN_NONBLOCK,
+                        O_RDONLY);
+	if (check)
+		exit(fd < 0);
+
+	if (fd < 0) {
+		perror("fanotify_init");
+		errx(1, "fanotify_init");
+	}
+
+	if (fanotify_mark(fd, FAN_MARK_ADD | FAN_MARK_FILESYSTEM,
+                          FAN_PRE_ACCESS, AT_FDCWD, argv[optind])) {
+		perror("fanotify_mark");
+		errx(1, "fanotify_mark");
+	}
+
+	printf("fanotify active\n");
+	fflush(stdout);
+
+	fds[0].fd = fd;
+        fds[0].events = POLLIN;
+
+	nfds = 1;
+
+	while (1) {
+	        poll_num = poll(fds, nfds, -1);
+                if (poll_num == -1) {
+                        if (errno == EINTR)	/* Interrupted by a signal */
+                                continue;	/* Restart poll() */
+
+                        perror("poll");		/* Unexpected error */
+                        exit(EXIT_FAILURE);
+                }
+
+		if (poll_num > 0) {
+
+                        if (fds[0].revents & POLLIN) {
+		                int n = read(fd, buffer, sizeof(buffer));
+		                if (n == -1 && errno != EAGAIN) {
+					perror("read");
+					exit(EXIT_FAILURE);
+				}
+
+				handle_notifications(fd, buffer, n);
+			}
+		}
+	}
+
+	return 0;
+}
-- 
2.34.1


