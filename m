Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336C606A333
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vp/8lsUb
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZ9x4Yqrz2ygD;
	Sun, 15 Nov 2026 00:05:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661541;
	cv=none; b=Gv2Pnoe+ctmyMfC8dGxHkjNMFzhx4kI3+HoBw6FONuA0BEtCQDH/fGU31AgvwC3xqKmMp7T/vobSzXir7Ks76fVJlIUGNTES+TilLiGpwJgxKzkh5jfhTT/N0L5aSLeyLKNssF8hytMtMROsbRdwReTqTPKM38mkTOCc2Z5/rCcr+tc4C9CzwGLZCl8s3NeL3Z24GbPfW0xl46TUtNPSq5usZ+Yxq4oqC8LviudyWK6ibL7uw5UmMVtD7AFukira4Q6qFM1OzmaoyAcmxBJdiZ0p68zJDqFx/NSMpn2FyoPwFAnDVygr112m6oKRxxjE9j7CTo9P+Sg4l4oLH7scbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661541; c=relaxed/relaxed;
	bh=CJQu819tgn1Q7KG3DzWeopl4zGjNY06MsJ8ooIiMWRc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UeLfgYqZwOUTvjc/nE86R/IBa0e5dmnOEx7i3JBL+dfw3v5yowEMTXlo7gxlEy6wzEtbO44oos7tpeiPfFR2+Ur7jlgIqpknytjgoRVtoVnVwLtaqzWXDb8jrrBPFIsJdK+tEksrwDqGtqQ+2guhhtze7hM97hh8n+fTh7i4qfk4LB+Vx0OksGQqRYJ76fiMUXn7w9FqjdWRoA6+YNAUq0XA6I3kOv2P4D2+g7iguVYaRsx01UMSP7x8bb/0qEQhDjnF0drn9WrDED2RvYwODNQRq0rFmjJRbgIeEQPd1IPDCtg3ll22t+eFh+t5qcZmCS6zhB2WFKRabA1DIaxs6A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vp/8lsUb; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vp/8lsUb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZ9w2fX0z2xjv;
	Sun, 15 Nov 2026 00:05:40 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76C6260F01;
	Sat, 14 Nov 2026 13:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E561F000C4;
	Sat, 14 Nov 2026 13:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661537;
	bh=CJQu819tgn1Q7KG3DzWeopl4zGjNY06MsJ8ooIiMWRc=;
	h=From:Subject:Date:To:Cc;
	b=Vp/8lsUbHRSKrh4ttKx/RVHJB7Ec7ONHIIW64irL2cjjacaR6J3rc/TVx34YmN2JY
	 hD7p4Lvjsdv8bdSTtvVg3Uo8hJbSv98inn/as02deo60GIBVbfirXFgWB/Mcxz4xgu
	 eNSZC0qRLBqbNvr4t9rxw1I+3C99Y5V4g0RNH0aW7CMG7xAojpfebDeeIxHa/hV/bK
	 rTGxkqIXzRUJBPtygJ+V6kczZ6fMZdsmbXQvq7GJF04QCZhqWlHP/dZDEjF9dxkMRO
	 bgT7mx1rfBdc7CasG01hMs/lp2dY+CVgKWNLT/1dXr8V6zJu13+oGNRULDYK5HyWcp
	 5xD4EImziW4Gg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
 storage
Date: Sat, 14 Nov 2026 14:01:41 +0100
Message-Id: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WOQQ6CMBBFr2JmbZuWkNK6MjHxAG4NCygDVEhLW
 kAN4e5SWLr8f/68vAUCeoMBLqcFPM4mGGe3kJxPoNvCNkhMtWVIWCI4Z4q8ne9I79xAhoBT5Yh
 UTKYpFxJrDtvb4LE2nx35hMf9BvlRhql8oR4jLM7KIiApfWF1G6uIpRFLDyyN97hrTRid/+6CM
 9+hhwtn/y4zJ4ykWimpMqGFzq4deos9db6BfF3XHzBro2XwAAAA
X-Change-ID: 20261109-work-loop-pseudo-890844168ef1
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Alexander Mikhalitsyn <alex@amutable.com>, Breno Leitao <leitao@debian.org>, 
 Casey Schaufler <casey@schaufler-ca.com>, Chuck Lever <cel@kernel.org>, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=11058; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1K5fqA8aYSFKqf+hZmwJu8L6D/XIowRL9F+k2izC4+I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iEnN4p/wft6Sgg3772gac+ROEzmmcSOrZ4f1rddhB
 RrfCvY86yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI0xOG/7GX+s0nhAj+YWd+
 7PfmzuuVXtolzr/nsKTMzc7ROfLNoZfhf1He254pcgrflbqY9lh2nVZVKVy6ZZGJ5E1Ny1XLT7L
 k8wEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Loop happily takes any regular file with ->read_iter() as a backing
file and any file that also has ->write_iter() as a writable one. A few
examples:

* /proc/kcore attaches read-only as a loop device the size of the
  kernel's virtual address space (64 PiB with 5-level paging)
* sysfs attributes attach read-write as 4096 byte loop devices
* using /sys/kernel/mm/transparent_hugepage/enabled for the loop device
  and writing a block to the loop device changes the THP setting

It's not just silly. It's abusable (is that a word?). Loop calls
->read_iter() and ->write_iter() of the backing file directly from its
kworker which runs with kernel credentials.

But pseudo files enforce part of their access rules at read and write
against the caller. So dozens of sysfs ->show() and ->store() methods
call capable().

But setting up a loop device requires no capabilities. It only requires
access to the device nodes. So whoever has a loop device skips all of
the capable() checks.

A couple of fun examples:

On v7.4-rc1 uid 0 without any capabilities can't kill a process of uid
1000 and can't poison its memory either:

    $ grep CapEff /proc/self/status
    CapEff: 0000000000000000
    $ kill -9 327
    bash: kill: (327) - Operation not permitted
    $ echo 0x220689000 > /sys/devices/system/memory/hard_offline_page
    bash: echo: write error: Operation not permitted

But put hard_offline_page behind a loop device, write a block
containing 0x220689000 to the loop device and the loop worker happily
does it:

    Memory failure: 0x220689: recovery action for dirty LRU page: Recovered
    MCE: Killing victim:327 due to hardware memory corruption fault at 7f468e972000

That hard_offline_page is a write-only file doesn't stop loop from
using it as a writable backing file either.

Other fun examples:

(1) soft-block radios via /sys/class/rfkill/rfkill*/soft
    (CAP_NET_ADMIN)

(2) change the reboot mode via /sys/kernel/reboot/mode (CAP_SYS_BOOT)

(3) reconfigure md arrays via /sys/block/md*/md/. md_attr_store()
    requires CAP_SYS_ADMIN for every md attribute.

(4) reconfigure scsi disks via /sys/class/scsi_disk/*/allow_restart and
    friends (CAP_SYS_ADMIN)

(5) read dmi-sysfs attributes (CAP_SYS_ADMIN)

And an unprivileged container that was handed a loop device can change
gro_flush_timeout of its own network devices. That usually requires
CAP_NET_ADMIN in the initial user namespace (via sysfs and via netlink).

I've reproduced that all on v7.4-rc1.

Aaaand zloop, the nvme target's file backend, the scsi target's fileio
backend, fuse passthrough and the usb mass storage gadget have the same
problem. erofs takes pseudo files as images for file-backed mounts as
well. It reads them with the mounter's credentials though so that's just
silly and not abusable.

Fwiw, device mapper doesn't need anything. It only takes block devices.
md's deprecated bitmap file is fine as well. It maps the file with
bmap() which no pseudo filesystem implements.

So this series adds SB_I_PSEUDO to state that the regular files of a
filesystem are kernel interfaces and not storage and makes all seven
refuse such files.

I didn't want to sprinkle SB_I_PSEUDO over all pseudo filesystems one by
one. Instead there's now a common initialization point for all of them
via fc_init_pseudo().

init_pseudo() uses it for the internal pseudo filesystems and all
mountable pseudo filesystems call it from their ->init_fs_context().

kernfs does it once in kernfs_get_tree(). It raises SB_I_PSEUDO,
SB_I_NOEXEC and SB_I_NODEV. Pseudo filesystems never hold executables or
device nodes. Some of them raised SB_I_NOEXEC and SB_I_NODEV already,
most didn't.

I went through every single one of them. None of them needs to execute
anything. The files that can be mmap()ed map data and the tracing ring
buffer refuses VM_EXEC anyway.

SB_I_NODEV is cleared again by devpts, binderfs and selinuxfs. The first
two did that already. selinuxfs needs it because Android init opens
/sys/fs/selinux/null by path as /dev/null doesn't exist yet at that
point. Note that systemd mounts most of these filesystems with noexec
and nodev already.

file_check_backing() looks at d_real_inode(). overlayfs happily stacks on
top of sysfs, cgroup2, debugfs, tracefs, configfs and securityfs and
reads of such overlayfs files are served by the pseudo file. Only procfs
and binfmt_misc are refused as they set s_stack_depth to
FILESYSTEM_MAX_STACK_DEPTH.

Whether all pseudo filesystems should refuse stacking is a separate
discussion. overlayfs reads the lower file with the mounter's
credentials so a root-mounted overlayfs on top of a sysfs directory
hands capability gated reads to every reader. With SB_I_PSEUDO overlayfs
could easily refuse them.

The first three patches are independent fixes. Loop never checked
whether its backing file is open for reading. It relied on
vfs_iter_read() refusing such files. Direct I/O never went through
vfs_iter_read() and since v6.15 buffered I/O doesn't either. So whoever
has a loop device can read files they could only open for writing. And
the nvme target's file backend and the scsi target's fileio backend call
->read_iter() and ->write_iter() without checking that they exist.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Add file_check_backing() and use it in all consumers. It replaces
  file_is_pseudo() and the open-coded file type, open mode and method
  checks.
- nvmet, fileio and zloop refuse everything that isn't a regular file
  or, for nvmet and fileio, a block device.
- fileio: check the protection file as well. (sashiko)
- acct: refuse files on all pseudo filesystems. (Alexander)
- selftests: add nvmet (Bui), fileio, zloop, link, FIFO and character
  device tests.
- Collect tags. They are dropped on the patches that changed.
- Link to v1: https://patch.msgid.link/20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org

---
Christian Brauner (42):
      loop: refuse backing files that aren't open for reading
      nvmet: check that the file backend supports ->{read,write}_iter
      target: fileio: check that the backing file supports ->{read,write}_iter
      fs: add SB_I_PSEUDO
      kernfs: use fc_init_pseudo()
      proc: use fc_init_pseudo()
      binfmt_misc: use fc_init_pseudo()
      mqueue: use fc_init_pseudo()
      bpf: use fc_init_pseudo() for bpffs
      nullfs: use fc_init_pseudo()
      failfs: use fc_init_pseudo()
      rust_binderfs: use fc_init_pseudo()
      devpts: use fc_init_pseudo()
      debugfs: use fc_init_pseudo()
      tracefs: use fc_init_pseudo()
      configfs: use fc_init_pseudo()
      securityfs: use fc_init_pseudo()
      selinux: use fc_init_pseudo() for selinuxfs
      smack: use fc_init_pseudo() for smackfs
      apparmor: use fc_init_pseudo() for apparmorfs
      nfsd: use fc_init_pseudo()
      sunrpc: use fc_init_pseudo() for rpc_pipefs
      fuse: use fc_init_pseudo() for fusectl
      efivarfs: use fc_init_pseudo()
      pstore: use fc_init_pseudo()
      xenfs: use fc_init_pseudo()
      openpromfs: use fc_init_pseudo()
      ocfs2: use fc_init_pseudo() for dlmfs
      s390/hypfs: use fc_init_pseudo()
      powerpc/spufs: use fc_init_pseudo()
      usb: gadget: f_fs: use fc_init_pseudo()
      usb: gadget: gadgetfs: use fc_init_pseudo()
      fs: add file_check_backing()
      loop: refuse files on pseudo filesystems as backing files
      zloop: refuse zone files on pseudo filesystems
      nvmet: refuse files on pseudo filesystems as namespace backing files
      target: fileio: refuse files on pseudo filesystems as backing files
      fuse: refuse files on pseudo filesystems as passthrough backing files
      usb: gadget: f_mass_storage: refuse files on pseudo filesystems
      erofs: refuse files on pseudo filesystems as backing files
      acct: refuse files on pseudo filesystems
      selftests/filesystems: add backing file tests for pseudo files

 arch/powerpc/platforms/cell/spufs/inode.c          |   2 +
 arch/s390/hypfs/inode.c                            |   2 +
 drivers/android/binder/rust_binderfs.c             |   3 +-
 drivers/block/loop.c                               |  14 +-
 drivers/block/zloop.c                              |   5 +-
 drivers/nvme/target/io-cmd-file.c                  |   4 +
 drivers/target/target_core_file.c                  |  14 +
 drivers/usb/gadget/function/f_fs.c                 |   2 +
 drivers/usb/gadget/function/storage_common.c       |  11 +-
 drivers/usb/gadget/legacy/inode.c                  |   2 +
 drivers/xen/xenfs/super.c                          |   2 +
 fs/binfmt_misc.c                                   |   5 +-
 fs/configfs/mount.c                                |   2 +
 fs/debugfs/inode.c                                 |   2 +
 fs/devpts/inode.c                                  |   2 +
 fs/efivarfs/super.c                                |   2 +
 fs/erofs/super.c                                   |   5 +-
 fs/failfs.c                                        |   3 +-
 fs/fuse/backing.c                                  |   4 +
 fs/fuse/control.c                                  |   2 +
 fs/kernfs/mount.c                                  |   4 +-
 fs/libfs.c                                         |   2 +-
 fs/nfsd/nfsctl.c                                   |   2 +
 fs/nullfs.c                                        |   3 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |   2 +
 fs/openpromfs/inode.c                              |   2 +
 fs/proc/root.c                                     |   4 +-
 fs/pstore/inode.c                                  |   2 +
 fs/read_write.c                                    |  48 ++
 fs/tracefs/inode.c                                 |   2 +
 include/linux/fs.h                                 |   2 +
 include/linux/fs/super_types.h                     |   1 +
 include/linux/pseudo_fs.h                          |  11 +
 ipc/mqueue.c                                       |   3 +-
 kernel/acct.c                                      |   6 +-
 kernel/bpf/inode.c                                 |   4 +-
 net/sunrpc/rpc_pipe.c                              |   2 +
 security/apparmor/apparmorfs.c                     |   2 +
 security/inode.c                                   |   2 +
 security/selinux/selinuxfs.c                       |   5 +
 security/smack/smackfs.c                           |   2 +
 tools/testing/selftests/filesystems/.gitignore     |   1 +
 tools/testing/selftests/filesystems/Makefile       |   2 +-
 tools/testing/selftests/filesystems/config         |  14 +
 .../selftests/filesystems/pseudo_backing_test.c    | 570 +++++++++++++++++++++
 45 files changed, 747 insertions(+), 39 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261109-work-loop-pseudo-890844168ef1


