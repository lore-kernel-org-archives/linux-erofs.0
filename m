Return-Path: <linux-erofs+bounces-2570-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F01BDFD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXg0t9Xz2xlx;
	Tue, 10 Mar 2026 23:01:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::119"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144083;
	cv=none; b=cJOcnisWZxrG6Vt3dM9Ans5KyA4/4qGGzzt45DSZZoMcbBST9zOt1TS3NFhg1eSooPDiGV9GBgN95iW+p86lPpgubLlz/DEPd98N0CItZ82k3z/TIcJlgtpgYbIFS/Ab6o/ZhkoDM2E+zfbqunFeNVN3f7Ru2EPbmfXX2Ch7+6roYa4ypk2lZJxUN3p5EQW0mv4kTpdjMeVgjmLLrNqhRuJmXt/0iwPhOkPxej5Td1KmVdOx9r1PPa4/R6nsPb8LCGLicuZZvQQ7aX5uBGRCPoAsfDHhBo+GThpx2bAQxofOxUPjEIjN9OIo/TM5EwzPtplc6nXo8Bd6RPFpervYDw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144083; c=relaxed/relaxed;
	bh=TMYuXsAwXlZPj+pNBI19fXQVyelGTABQZdwu3TAkE2A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PfhcNsUr+C4giCKsHWKPGvmGFoYGGkGmp97NELT6hKO/TNaNXfvOFCGl+Q1Ds34Weekl0HUYhLH6SECgklSw3iB7AELbcFDFtSQRL61x5WR6av4bimO7c2DxCBT3Ou0Gh0X1xUF4B1vWSPUouxa+2msHyAX5pq1RL0tQE9v5XujDFWu9x0G3KbnAYqVVfDe/kKppRPti7jHhA4i5/c+htq9LpoK9Zy1dMA1jQPUytu7KBxEYDrLpt5ez0JXGZEyQrYvPXoc+McLdyx+t1AJxk6gKpprRWEiVfXA3s16++Wol28v6fiU0+fNl9iruIFOZtm7KNdvZho0BeVP9qquNog==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=AHWaJPiB; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=AHWaJPiB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXb0Dj2z3cC9
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=lEmCou71DQIv3rJiH+2ZIvzOcBQ45/hCLHA8fjFTjEM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AHWaJPiBsL+GwFoetOExpKLG9cmnqvpt8xMBxHRmuFnKfjqJNAZAD1Wuu27hEzCjp
	 yo/8LH57/iizP+bjiVmoMZwTMOiCMC/XLDqy5SSCcm+OQZZ/0iP8EPctZ2sQqxK7Ab
	 XT9/JQSyTpsDOlLEGnKt3l1avwq96+RDdo3lipF8=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d40-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:41 +0100
Subject: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2257; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=lEmCou71DQIv3rJiH+2ZIvzOcBQ45/hCLHA8fjFTjEM=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYJfb+qOowLIkUmfJbwapQWgbBrCmoY2MGV1
 kQO676TIO+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGCQAKCRA0LQZT0ays
 264GB/0ePCsoEZ4dvusK/+59DK+nFUG4TMYrwfcQ9Aw8geb+nDTbFBXmGXKhwNE0FGNMoZ9u6w0
 6Z8ff6aHriAkc9Kt7Cgo70KOX6BjUy2bKgpnqJ9UCEmLABUocGsnikIoRM/S+kmqBXC+hSxD7sM
 X70l7rxeP1jyVHxWJrxfa6E/R35lI3vjpmjnsYcBxz/fgBeGY30s+ys1gafR9RwiFHF5/fl9jcb
 Y3J+3Pom6JCnaZYPGyS2UG84plp5l+rENGjhP2UWug9tGkZ5pwYbuR79z7QaUT6EEnR3YbR314t
 8SpG12KL4Vc7ZU5W2GsSc9E64021CyFWbNdSoNZGwreTwyp2
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-764F0E1F-76E75FCD/0/0
X-purgate-type: clean
X-purgate-size: 2259
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 kernel/trace/fprobe.c                | 2 +-
 kernel/trace/kprobe_event_gen_test.c | 2 +-
 kernel/trace/trace_events_hist.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index dcadf1d23b8a31f571392d0c49cbd22df1716b4f..a94ce810d83b90f55d1178a9bd29c78fd068df4c 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -607,7 +607,7 @@ static int fprobe_module_callback(struct notifier_block *nb,
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((node = rhashtable_walk_next(&iter)) && !IS_ERR(node))
+		while (!IS_ERR_OR_NULL((node = rhashtable_walk_next(&iter))))
 			fprobe_remove_node_in_module(mod, node, &alist);
 
 		rhashtable_walk_stop(&iter);
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index 5a4b722b50451bfdee42769a6d3be39c055690d1..a1735ca273f0b756aa1fcfcdab30ddad9bc51c5f 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -75,7 +75,7 @@ static struct trace_event_file *gen_kretprobe_test;
 
 static bool trace_event_file_is_valid(struct trace_event_file *input)
 {
-	return input && !IS_ERR(input);
+	return !IS_ERR_OR_NULL(input);
 }
 
 /*
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 73ea180cad555898693e92ee397a1c9493c7c167..59df215e1dfd9349eca1c0823ed709ec7285f766 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3973,7 +3973,7 @@ trace_action_create_field_var(struct hist_trigger_data *hist_data,
 	 */
 	field_var = create_target_field_var(hist_data, system, event, var);
 
-	if (field_var && !IS_ERR(field_var)) {
+	if (!IS_ERR_OR_NULL(field_var)) {
 		save_field_var(hist_data, field_var);
 		hist_field = field_var->var;
 	} else {

-- 
2.43.0


