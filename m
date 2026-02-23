Return-Path: <linux-erofs+bounces-2360-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3D8E98E06
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Feb 2026 08:40:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fKDnV2mBpz2yDk;
	Mon, 23 Feb 2026 19:40:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.161.72
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771836014;
	cv=none; b=ZH0btfznG73c+hv+0BCh4FBZtRhKBeMEPhFn52ADoWp+RPV93EGQjb6vt8H7QpzYZIa0UJovFrxXwID/k9ZGH0i1RJPHr2PkzvLD4WKx96e5mxNi0764Xg/KI4PEsghX1NKGTxLCxGb2TNVMLhea30OR18cFjPf9DOQxqgGqRLSPSzot4YZYB0xjCWMp0Wglfs1vB3fcGjD86Jt+XFrrZvzzrBE/ztopBiuaOo3Fe4DanD2TjyrOBJIL8JuVo13ge0ynzTOafqHDzy06xIkPSURH+YijIIkZpEpcIdxZVRmig1+jDOqXm2oL0hXptPcNpJMDX8hILg72P7JHK7g26w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771836014; c=relaxed/relaxed;
	bh=nUp2sLsTQG2be743RxBuEK2iTbA/TXBt6KIKc8LeryU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=NjJolF8XhBeMRRYe5OmFLHdq00hVQ5sGHJdtXkY5WzUXF6WMP7ZXbj/T4a7oEhGmmPMbvEMknw3182lz5yL7PpntaK07ct2aHHsOhxfW5rUwff11hBmqMEGiRjdimHL3FXsDH2r2boHXvOMBFDEx5g9vmhNr/z7BSZ83H2ijZgx1o9duux6z0I03WkDkGl5kO95j0cNW2OV4CYB0lnMHkLOx20gLfYFOZEq0f0BhPAPoWcug/qMXC+OOx/akecmAh1lp2mDmFOucPQErbNtuyUZhDYfAMtdr5HMtjfVbcOh5WBkLMeAR0I9j8yoqlAuiH9fC9FoIG2Kw/oTgzFjFHQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass (client-ip=209.85.161.72; helo=mail-oo1-f72.google.com; envelope-from=3abkcaqkbafebhi3t44xat881w.z77z4xdbxav76cx6c.v75@m3kw2wvrgufz5godrsrytgd7.apphosting.bounces.google.com; receiver=lists.ozlabs.org) smtp.mailfrom=m3kw2wvrgufz5godrsrytgd7.apphosting.bounces.google.com
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=m3kw2wvrgufz5godrsrytgd7.apphosting.bounces.google.com (client-ip=209.85.161.72; helo=mail-oo1-f72.google.com; envelope-from=3abkcaqkbafebhi3t44xat881w.z77z4xdbxav76cx6c.v75@m3kw2wvrgufz5godrsrytgd7.apphosting.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fKDnS3Jkjz2xN8
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Feb 2026 19:40:11 +1100 (AEDT)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-676c2e00f3fso65033831eaf.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 23 Feb 2026 00:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771836008; x=1772440808;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nUp2sLsTQG2be743RxBuEK2iTbA/TXBt6KIKc8LeryU=;
        b=kEMvRdZyQfQ4yMtkBkgAXun366iXmioYSzXkz1376/sN/6jbCIcMLat1ZpyH8tu1ru
         mJewKMYlbKEU8CMW+cJRHJxOgrEbY4DGw25eI6K7HoJz4R1bTZVNCb1X+SVbeLv0yprP
         qYJ2WtcYx5SO4sOH0JtIVet/b6D+OxRFpnw5fND/SfjxrWAm4nOCnb4zhyhr2VS3tMcJ
         zkzgagZP81xWrKHe7/7xadWioUc5RLoLiokcQliyXqjl3iTDGTlKzIBfW4yn6y9l6l1h
         Ux80jyUGCptS6KsAbYtDpfkuTV/Sf898hMlPTeUjQ9rdeK6vWo+dS5HDIZw+G0EqRhhf
         W4mg==
X-Forwarded-Encrypted: i=1; AJvYcCU5mYmm5vEOaYff6ZoJQokuh56sjcDhcpc9XN1QDk6y9rNx6Q7cBY59gRUR7gloIru3LDpHcfj0sMwJ+A==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwRYA44CoJz9RycbYb6bMmntx6ecCM4W4T4njfDXwLx+K7Q7Flu
	hQM3GUjywrULAlX75DPYWTuhxmtzTFCcpJY2pAgcGfl5+G5usBS/IHlgCmEyjoHedpl8K/Ongdq
	dgCQH7WIl7chRX+wASJjbFaOIcTR6Gcu6bn54dFecx1WgpqaSlCyVoXbl1b4=
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
X-Received: by 2002:a05:6820:468c:b0:679:c41f:edf with SMTP id
 006d021491bc7-679c41f0fcdmr3630394eaf.29.1771836008198; Mon, 23 Feb 2026
 00:40:08 -0800 (PST)
Date: Mon, 23 Feb 2026 00:40:08 -0800
In-Reply-To: <20260223032641.1859381-1-ziy@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699c1268.050a0220.340abe.0d38.GAE@google.com>
Subject: [syzbot ci] Re: Zero page->private when freeing pages
From: syzbot ci <syzbot+cid1b0d4bbb448f87c@syzkaller.appspotmail.com>
To: airlied@gmail.com, akpm@linux-foundation.org, aliceryhl@google.com, 
	arve@android.com, axboe@kernel.dk, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, christian.koenig@amd.com, 
	cl@gentwo.org, cmllamas@google.com, dave@stgolabs.net, david@kernel.org, 
	dennis@kernel.org, dev.jain@arm.com, dhavale@google.com, dlemoal@kernel.org, 
	dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, 
	guochunhai@vivo.com, hannes@cmpxchg.org, harry.yoo@oracle.com, 
	jackmanb@google.com, jefflexu@linux.alibaba.com, johannes.thumshirn@wdc.com, 
	katrinzhou@tencent.com, kernelxing@tencent.com, kprateek.nayak@amd.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, lihongbo22@huawei.com, 
	linux-block@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	maarten.lankhorst@linux.intel.com, matthew.auld@intel.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	mripard@kernel.org, npache@redhat.com, ray.huang@amd.com, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, sandeen@redhat.com, 
	simona@ffwll.ch, surenb@google.com, tj@kernel.org, tkjos@android.com, 
	tzimmermann@suse.de, vbabka@kernel.org, xiang@kernel.org, zbestahu@gmail.com, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Zero page->private when freeing pages
https://lore.kernel.org/all/20260223032641.1859381-1-ziy@nvidia.com
* [PATCH v1 01/11] relay: zero page->private when freeing pages
* [PATCH v1 02/11] mm/slub: zero page->private when freeing pages
* [PATCH v1 03/11] drm/ttm: zero page->private when freeing pages
* [PATCH v1 04/11] blk-mq: zero page->private when freeing pages
* [PATCH v1 05/11] watch_queue: zero page->private when freeing pages
* [PATCH v1 06/11] binder: zero page->private when freeing pages
* [PATCH v1 07/11] null_blk: zero page->private when freeing pages
* [PATCH v1 08/11] percpu: zero page->private when freeing pages
* [PATCH v1 09/11] erofs: zero page->private when freeing pages
* [PATCH v1 10/11] mm/huge_memory: add page->private check back in __split_folio_to_order()
* [PATCH v1 11/11] mm/page_alloc: check page->private upon page free

and found the following issue:
WARNING in __free_frozen_pages

Full report is available here:
https://ci.syzbot.org/series/10f470ac-46ac-4e38-902d-dc86ae743494

***

WARNING in __free_frozen_pages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      a6fdc327de4678e54b5122441c970371014117b0
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0586347c-8ef1-427f-8a9c-7f6c08b616a9/config

Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
Registered RDS/infiniband transport
Registered RDS/tcp transport
tipc: Activated (version 2.0.0)
NET: Registered PF_TIPC protocol family
tipc: Started in single node mode
smc: adding smcd device lo without pnetid
NET: Registered PF_SMC protocol family
9pnet: Installing 9P2000 support
NET: Registered PF_CAIF protocol family
NET: Registered PF_IEEE802154 protocol family
Key type dns_resolver registered
Key type ceph registered
libceph: loaded (mon/osd proto 15/24)
batman_adv: B.A.T.M.A.N. advanced 2025.5 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
sched_clock: Marking stable (19970046340, 93374727)->(20073238384, -9817317)
registered taskstats version 1
Loading compiled-in X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: 98092a222e11368da223b039d625e21c3e2e069c'
zswap: loaded using pool 842
Demotion targets for Node 0: null
Demotion targets for Node 1: null
debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
------------[ cut here ]------------
page->private
WARNING: mm/page_alloc.c:1433 at __free_frozen_pages+0x78e/0xe10, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__free_frozen_pages+0x78e/0xe10
Code: 5f 5d e9 05 1e 00 00 48 b8 00 00 00 00 00 fc ff df 0f b6 44 05 00 84 c0 0f 85 d7 02 00 00 c7 03 ff ff ff ff e9 22 fc ff ff 90 <0f> 0b 90 e9 8d fc ff ff bd 01 00 00 00 83 f8 05 0f 85 bb fe ff ff
RSP: 0000:ffffc900000676e0 EFLAGS: 00010282
RAX: 1ffffd4000bad935 RBX: ffffea0005d6c9a8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffea0005d6c9b4
RBP: ffffea0005d6c9b8 R08: ffffea0005d6c9b7 R09: 1ffffd4000bad936
R10: dffffc0000000000 R11: fffff94000bad937 R12: ffffea0005d6c980
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818de64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 destroy_args+0x15d/0x570
 debug_vm_pgtable+0x3f8/0x410
 do_one_initcall+0x250/0x8d0
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x51e/0xb90
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

