Return-Path: <linux-erofs+bounces-4209-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6034AC5B572
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:15:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKrBD4syTz303K;
	Thu, 13 Aug 2026 00:15:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544148;
	cv=none; b=BfTSUnGJBTxnH5HWePQaWfohv7yU/Xjnwhcx7goOgQiHGiLKAg9z+34B9byDVxP6S7QerNaCugMyy2cUXC/+Fvak3Jl9hhhLBK7ZzNj0fGtiA9ZsSg9POnlZOLs877ILKWkjLuAl44thYcaSMgIA6HlNUYQsSUyB382sHAUAEV2Y5zq3/D423+/zuxtnwnvoGRGQUM3UFxdXqqWXSoHrTRY1icju4fuSuQucgbfjsdFOfkfXtJsDDYj3n8To3/EYcUStfEv7V6nHFytTbdSCPgZNu2Uv1lsarofwygz6bJb4qOeMifKnkkua43Ip2hN0GVy09bdysVFpYDb+P2qTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544148; c=relaxed/relaxed;
	bh=n+PB/14dynfGTgEvg56tmlBoHCaPYfuBKg1lvFQeTx8=;
	h=From:To:cc:Subject:MIME-Version:Date:Message-ID:Content-Type; b=WSoi93L1grJ2ACrTetumD/nSck1DxQtgBjpt52j8c721RVJodGLdeajIbwKqX3GxDVV7cMGjdOjb+gp5WwmNXfk1/uE60GELUOKIbiS0vABQuvy/DmHjs7O1rRIYyTcMOMi8oD6qoDw48z8WRT0lYpIabdzi9NYZVbf12Xrg8UYRP+VfvuWGwUfueSsehCrweaug9CQdckh/8RA9tA8g5RH4Sm9bKEumruWvhKC/oyQoHetzzzwJQjrkkUJ+pHWCy9XelBerpr6qxi+JdQwiF5qXfMYSBvj+SCH0aWQ66HqqVUXFBUngmc8qFTr4Av8HRybyQDO5fDp8Yo7Cl07zTQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L+9TrXP3; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Lc74xHt3; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L+9TrXP3;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Lc74xHt3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKrB86112z302l
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:15:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786544138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=n+PB/14dynfGTgEvg56tmlBoHCaPYfuBKg1lvFQeTx8=;
	b=L+9TrXP37YHxYGzhr4ZwfOhWNUHMgkapAxEs0iTEKyrHBgDJdn1J8ohOTUgR8qUQT0fU5o
	Q5YAd1CSAROPqPP+Zr2ApowlqpF4yXogP/8v7PGGhvkZZl91DtUr+B7P4KQ+RkPcm2ntW9
	UK/kAVyIx6I6VMJiAs2nLGDLik4vQi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786544139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=n+PB/14dynfGTgEvg56tmlBoHCaPYfuBKg1lvFQeTx8=;
	b=Lc74xHt3qkzAJ8hmIPGTsDEMbT2GpAHNidoYoWV9SjBGKvYkHOV+d9QUPCnq9jmcVoRCXZ
	gsd9wWnPD8tHmL70wJSsT2hzx+tCZ7ADnNREzqt8Mpv5MxQRrqAyMrBoF0SZSfGuGv0bIN
	VeHBLBhRQ7RbkOqrBB1aH8j5BjlO1Jg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-WItuefNBPBaXwSr9J6nZ8w-1; Wed,
 12 Aug 2026 10:15:34 -0400
X-MC-Unique: WItuefNBPBaXwSr9J6nZ8w-1
X-Mimecast-MFC-AGG-ID: WItuefNBPBaXwSr9J6nZ8w_1786544133
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E2DD195608F;
	Wed, 12 Aug 2026 14:15:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BEEF0427;
	Wed, 12 Aug 2026 14:15:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>
cc: dhowells@redhat.com, Gao Xiang <xiang@kernel.org>,
    Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
    linux-erofs@lists.ozlabs.org, bpf@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cachefiles,netfs: sunset ondemand mode
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
Date: Wed, 12 Aug 2026 15:15:27 +0100
Message-ID: <1046393.1786544127@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: N2u6d8R4HgmhHgO3yKeBsAcT56CooXq8vOT-NKK_npc_1786544133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1046392.1786544127.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable

From: Gao Xiang <xiang@kernel.org>

It was an effort to enhance fscache as a kernel cache for lazy
pulling (at least according to previous Incremental FS discussion [1])
and EROFS over fscache was the in-tree user of this mode.

fscache has since evolved to be netfslib-oriented, serving network
filesystem inodes via the netfs library, but EROFS never acts as a
network filesystem and we need to cache golden filesystem images rather
than individual EROFS inodes.

Since EROFS over fscache is now removed, clean up netfs/fscache/
cachefiles upstream too.

[1] https://lore.kernel.org/r/CAOQ4uxi4dzxArY24YO=3D+kBCK2gGoq3Ptb8WkzCqSog=
PgU_R3dQ@mail.gmail.com

[dh] Fixed up comments on:
https://sashiko.dev/#/patchset/20260716103030.3065561-1-dhowells%40redhat.c=
om
https://sashiko.dev/#/patchset/20260722130218.78958-1-dhowells%40redhat.com

Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-erofs@lists.ozlabs.org
cc: bpf@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 Documentation/filesystems/caching/cachefiles.rst |  179 -----
 fs/cachefiles/Kconfig                            |   12=20
 fs/cachefiles/Makefile                           |    1=20
 fs/cachefiles/daemon.c                           |   96 --
 fs/cachefiles/interface.c                        |    8=20
 fs/cachefiles/internal.h                         |  134 ----
 fs/cachefiles/io.c                               |   26=20
 fs/cachefiles/namei.c                            |    8=20
 fs/cachefiles/ondemand.c                         |  761 ------------------=
-----
 include/linux/netfs.h                            |    9=20
 include/trace/events/cachefiles.h                |  184 -----
 include/uapi/linux/cachefiles.h                  |   68 --
 kernel/bpf/btf.c                                 |    7=20
 13 files changed, 9 insertions(+), 1484 deletions(-)

diff --git a/Documentation/filesystems/caching/cachefiles.rst b/Documentati=
on/filesystems/caching/cachefiles.rst
index b3ccc782cb3b..adfb7d079027 100644
--- a/Documentation/filesystems/caching/cachefiles.rst
+++ b/Documentation/filesystems/caching/cachefiles.rst
@@ -28,8 +28,6 @@ Cache on Already Mounted Filesystem
=20
  (*) Debugging.
=20
- (*) On-demand Read.
-
=20
 Overview
 =3D=3D=3D=3D=3D=3D=3D=3D
@@ -483,180 +481,3 @@ the control file.  For example::
 =09echo $((1|4|8)) >/sys/module/cachefiles/parameters/debug
=20
 will turn on all function entry debugging.
-
-
-On-demand Read
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-
-When working in its original mode, CacheFiles serves as a local cache for =
a
-remote networking fs - while in on-demand read mode, CacheFiles can boost =
the
-scenario where on-demand read semantics are needed, e.g. container image
-distribution.
-
-The essential difference between these two modes is seen when a cache miss
-occurs: In the original mode, the netfs will fetch the data from the remot=
e
-server and then write it to the cache file; in on-demand read mode, fetchi=
ng
-the data and writing it into the cache is delegated to a user daemon.
-
-``CONFIG_CACHEFILES_ONDEMAND`` should be enabled to support on-demand read=
 mode.
-
-
-Protocol Communication
-----------------------
-
-The on-demand read mode uses a simple protocol for communication between k=
ernel
-and user daemon. The protocol can be modeled as::
-
-=09kernel --[request]--> user daemon --[reply]--> kernel
-
-CacheFiles will send requests to the user daemon when needed.  The user da=
emon
-should poll the devnode ('/dev/cachefiles') to check if there's a pending
-request to be processed.  A POLLIN event will be returned when there's a p=
ending
-request.
-
-The user daemon then reads the devnode to fetch a request to process.  It =
should
-be noted that each read only gets one request. When it has finished proces=
sing
-the request, the user daemon should write the reply to the devnode.
-
-Each request starts with a message header of the form::
-
-=09struct cachefiles_msg {
-=09=09__u32 msg_id;
-=09=09__u32 opcode;
-=09=09__u32 len;
-=09=09__u32 object_id;
-=09=09__u8  data[];
-=09};
-
-where:
-
-=09* ``msg_id`` is a unique ID identifying this request among all pending
-=09  requests.
-
-=09* ``opcode`` indicates the type of this request.
-
-=09* ``object_id`` is a unique ID identifying the cache file operated on.
-
-=09* ``data`` indicates the payload of this request.
-
-=09* ``len`` indicates the whole length of this request, including the
-=09  header and following type-specific payload.
-
-
-Turning on On-demand Mode
--------------------------
-
-An optional parameter becomes available to the "bind" command::
-
-=09bind [ondemand]
-
-When the "bind" command is given no argument, it defaults to the original =
mode.
-When it is given the "ondemand" argument, i.e. "bind ondemand", on-demand =
read
-mode will be enabled.
-
-
-The OPEN Request
-----------------
-
-When the netfs opens a cache file for the first time, a request with the
-CACHEFILES_OP_OPEN opcode, a.k.a an OPEN request will be sent to the user
-daemon.  The payload format is of the form::
-
-=09struct cachefiles_open {
-=09=09__u32 volume_key_size;
-=09=09__u32 cookie_key_size;
-=09=09__u32 fd;
-=09=09__u32 flags;
-=09=09__u8  data[];
-=09};
-
-where:
-
-=09* ``data`` contains the volume_key followed directly by the cookie_key.
-=09  The volume key is a NUL-terminated string; the cookie key is binary
-=09  data.
-
-=09* ``volume_key_size`` indicates the size of the volume key in bytes.
-
-=09* ``cookie_key_size`` indicates the size of the cookie key in bytes.
-
-=09* ``fd`` indicates an anonymous fd referring to the cache file, through
-=09  which the user daemon can perform write/llseek file operations on the
-=09  cache file.
-
-
-The user daemon can use the given (volume_key, cookie_key) pair to disting=
uish
-the requested cache file.  With the given anonymous fd, the user daemon ca=
n
-fetch the data and write it to the cache file in the background, even when
-kernel has not triggered a cache miss yet.
-
-Be noted that each cache file has a unique object_id, while it may have mu=
ltiple
-anonymous fds.  The user daemon may duplicate anonymous fds from the initi=
al
-anonymous fd indicated by the @fd field through dup().  Thus each object_i=
d can
-be mapped to multiple anonymous fds, while the usr daemon itself needs to
-maintain the mapping.
-
-When implementing a user daemon, please be careful of RLIMIT_NOFILE,
-``/proc/sys/fs/nr_open`` and ``/proc/sys/fs/file-max``.  Typically these n=
eedn't
-be huge since they're related to the number of open device blobs rather th=
an
-open files of each individual filesystem.
-
-The user daemon should reply the OPEN request by issuing a "copen" (comple=
te
-open) command on the devnode::
-
-=09copen <msg_id>,<cache_size>
-
-where:
-
-=09* ``msg_id`` must match the msg_id field of the OPEN request.
-
-=09* When >=3D 0, ``cache_size`` indicates the size of the cache file;
-=09  when < 0, ``cache_size`` indicates any error code encountered by the
-=09  user daemon.
-
-
-The CLOSE Request
------------------
-
-When a cookie withdrawn, a CLOSE request (opcode CACHEFILES_OP_CLOSE) will=
 be
-sent to the user daemon.  This tells the user daemon to close all anonymou=
s fds
-associated with the given object_id.  The CLOSE request has no extra paylo=
ad,
-and shouldn't be replied.
-
-
-The READ Request
-----------------
-
-When a cache miss is encountered in on-demand read mode, CacheFiles will s=
end a
-READ request (opcode CACHEFILES_OP_READ) to the user daemon. This tells th=
e user
-daemon to fetch the contents of the requested file range.  The payload is =
of the
-form::
-
-=09struct cachefiles_read {
-=09=09__u64 off;
-=09=09__u64 len;
-=09};
-
-where:
-
-=09* ``off`` indicates the starting offset of the requested file range.
-
-=09* ``len`` indicates the length of the requested file range.
-
-
-When it receives a READ request, the user daemon should fetch the requeste=
d data
-and write it to the cache file identified by object_id.
-
-When it has finished processing the READ request, the user daemon should r=
eply
-by using the CACHEFILES_IOC_READ_COMPLETE ioctl on one of the anonymous fd=
s
-associated with the object_id given in the READ request.  The ioctl is of =
the
-form::
-
-=09ioctl(fd, CACHEFILES_IOC_READ_COMPLETE, msg_id);
-
-where:
-
-=09* ``fd`` is one of the anonymous fds associated with the object_id
-=09  given.
-
-=09* ``msg_id`` must match the msg_id field of the READ request.
diff --git a/fs/cachefiles/Kconfig b/fs/cachefiles/Kconfig
index c5a070550ee3..afb25b6af5aa 100644
--- a/fs/cachefiles/Kconfig
+++ b/fs/cachefiles/Kconfig
@@ -26,15 +26,3 @@ config CACHEFILES_ERROR_INJECTION
 =09help
 =09  This permits error injection to be enabled in cachefiles whilst a
 =09  cache is in service.
-
-config CACHEFILES_ONDEMAND
-=09bool "Support for on-demand read"
-=09depends on CACHEFILES
-=09default n
-=09help
-=09  This permits userspace to enable the cachefiles on-demand read mode.
-=09  In this mode, when a cache miss occurs, responsibility for fetching
-=09  the data lies with the cachefiles backend instead of with the netfs
-=09  and is delegated to userspace.
-
-=09  If unsure, say N.
diff --git a/fs/cachefiles/Makefile b/fs/cachefiles/Makefile
index c37a7a9af10b..16d811f1a2fa 100644
--- a/fs/cachefiles/Makefile
+++ b/fs/cachefiles/Makefile
@@ -16,6 +16,5 @@ cachefiles-y :=3D \
 =09xattr.o
=20
 cachefiles-$(CONFIG_CACHEFILES_ERROR_INJECTION) +=3D error_inject.o
-cachefiles-$(CONFIG_CACHEFILES_ONDEMAND) +=3D ondemand.o
=20
 obj-$(CONFIG_CACHEFILES) :=3D cachefiles.o
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 4117b145ac94..1a66e0af2837 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -76,10 +76,6 @@ static const struct cachefiles_daemon_cmd cachefiles_dae=
mon_cmds[] =3D {
 =09{ "inuse",=09cachefiles_daemon_inuse=09=09},
 =09{ "secctx",=09cachefiles_daemon_secctx=09},
 =09{ "tag",=09cachefiles_daemon_tag=09=09},
-#ifdef CONFIG_CACHEFILES_ONDEMAND
-=09{ "copen",=09cachefiles_ondemand_copen=09},
-=09{ "restore",=09cachefiles_ondemand_restore=09},
-#endif
 =09{ "",=09=09NULL=09=09=09=09}
 };
=20
@@ -113,9 +109,6 @@ static int cachefiles_daemon_open(struct inode *inode, =
struct file *file)
 =09INIT_LIST_HEAD(&cache->volumes);
 =09INIT_LIST_HEAD(&cache->object_list);
 =09spin_lock_init(&cache->object_list_lock);
-=09refcount_set(&cache->unbind_pincount, 1);
-=09xa_init_flags(&cache->reqs, XA_FLAGS_ALLOC);
-=09xa_init_flags(&cache->ondemand_ids, XA_FLAGS_ALLOC1);
=20
 =09/* set default caching limits
 =09 * - limit at 1% free space and/or free files
@@ -134,54 +127,6 @@ static int cachefiles_daemon_open(struct inode *inode,=
 struct file *file)
 =09return 0;
 }
=20
-void cachefiles_flush_reqs(struct cachefiles_cache *cache)
-{
-=09struct xarray *xa =3D &cache->reqs;
-=09struct cachefiles_req *req;
-=09unsigned long index;
-
-=09/*
-=09 * Make sure the following two operations won't be reordered.
-=09 *   1) set CACHEFILES_DEAD bit
-=09 *   2) flush requests in the xarray
-=09 * Otherwise the request may be enqueued after xarray has been
-=09 * flushed, leaving the orphan request never being completed.
-=09 *
-=09 * CPU 1=09=09=09CPU 2
-=09 * =3D=3D=3D=3D=3D=09=09=09=3D=3D=3D=3D=3D
-=09 * flush requests in the xarray
-=09 *=09=09=09=09test CACHEFILES_DEAD bit
-=09 *=09=09=09=09enqueue the request
-=09 * set CACHEFILES_DEAD bit
-=09 */
-=09smp_mb();
-
-=09xa_lock(xa);
-=09xa_for_each(xa, index, req) {
-=09=09req->error =3D -EIO;
-=09=09complete(&req->done);
-=09=09__xa_erase(xa, index);
-=09}
-=09xa_unlock(xa);
-
-=09xa_destroy(&cache->reqs);
-=09xa_destroy(&cache->ondemand_ids);
-}
-
-void cachefiles_put_unbind_pincount(struct cachefiles_cache *cache)
-{
-=09if (refcount_dec_and_test(&cache->unbind_pincount)) {
-=09=09cachefiles_daemon_unbind(cache);
-=09=09cachefiles_open =3D 0;
-=09=09kfree(cache);
-=09}
-}
-
-void cachefiles_get_unbind_pincount(struct cachefiles_cache *cache)
-{
-=09refcount_inc(&cache->unbind_pincount);
-}
-
 /*
  * Release a cache.
  */
@@ -194,16 +139,14 @@ static int cachefiles_daemon_release(struct inode *in=
ode, struct file *file)
 =09ASSERT(cache);
=20
 =09set_bit(CACHEFILES_DEAD, &cache->flags);
-
-=09if (cachefiles_in_ondemand_mode(cache))
-=09=09cachefiles_flush_reqs(cache);
+=09cachefiles_daemon_unbind(cache);
=20
 =09/* clean up the control file interface */
 =09cache->cachefilesd =3D NULL;
 =09file->private_data =3D NULL;
+=09cachefiles_open =3D 0;
=20
-=09cachefiles_put_unbind_pincount(cache);
-
+=09kfree(cache);
 =09_leave("");
 =09return 0;
 }
@@ -266,10 +209,7 @@ static ssize_t cachefiles_daemon_read(struct file *fil=
e, char __user *_buffer,
 =09if (!test_bit(CACHEFILES_READY, &cache->flags))
 =09=09return 0;
=20
-=09if (cachefiles_in_ondemand_mode(cache))
-=09=09return cachefiles_ondemand_daemon_read(cache, _buffer, buflen);
-=09else
-=09=09return cachefiles_do_daemon_read(cache, _buffer, buflen);
+=09return cachefiles_do_daemon_read(cache, _buffer, buflen);
 }
=20
 /*
@@ -358,28 +298,13 @@ static __poll_t cachefiles_daemon_poll(struct file *f=
ile,
 =09=09=09=09=09   struct poll_table_struct *poll)
 {
 =09struct cachefiles_cache *cache =3D file->private_data;
-=09XA_STATE(xas, &cache->reqs, 0);
-=09struct cachefiles_req *req;
 =09__poll_t mask;
=20
 =09poll_wait(file, &cache->daemon_pollwq, poll);
 =09mask =3D 0;
=20
-=09if (cachefiles_in_ondemand_mode(cache)) {
-=09=09if (!xa_empty(&cache->reqs)) {
-=09=09=09xas_lock(&xas);
-=09=09=09xas_for_each_marked(&xas, req, ULONG_MAX, CACHEFILES_REQ_NEW) {
-=09=09=09=09if (!cachefiles_ondemand_is_reopening_read(req)) {
-=09=09=09=09=09mask |=3D EPOLLIN;
-=09=09=09=09=09break;
-=09=09=09=09}
-=09=09=09}
-=09=09=09xas_unlock(&xas);
-=09=09}
-=09} else {
-=09=09if (test_bit(CACHEFILES_STATE_CHANGED, &cache->flags))
-=09=09=09mask |=3D EPOLLIN;
-=09}
+=09if (test_bit(CACHEFILES_STATE_CHANGED, &cache->flags))
+=09=09mask |=3D EPOLLIN;
=20
 =09if (test_bit(CACHEFILES_CULLING, &cache->flags))
 =09=09mask |=3D EPOLLOUT;
@@ -779,14 +704,7 @@ static int cachefiles_daemon_bind(struct cachefiles_ca=
che *cache, char *args)
 =09=09return -EBUSY;
 =09}
=20
-=09if (IS_ENABLED(CONFIG_CACHEFILES_ONDEMAND)) {
-=09=09if (!strcmp(args, "ondemand")) {
-=09=09=09set_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags);
-=09=09} else if (*args) {
-=09=09=09pr_err("Invalid argument to the 'bind' command\n");
-=09=09=09return -EINVAL;
-=09=09}
-=09} else if (*args) {
+=09if (*args) {
 =09=09pr_err("'bind' command doesn't take an argument\n");
 =09=09return -EINVAL;
 =09}
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index a08250d244ea..50a000310a8c 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -32,11 +32,6 @@ struct cachefiles_object *cachefiles_alloc_object(struct=
 fscache_cookie *cookie)
 =09if (!object)
 =09=09return NULL;
=20
-=09if (cachefiles_ondemand_init_obj_info(object, volume)) {
-=09=09kmem_cache_free(cachefiles_object_jar, object);
-=09=09return NULL;
-=09}
-
 =09refcount_set(&object->ref, 1);
=20
 =09spin_lock_init(&object->lock);
@@ -94,7 +89,6 @@ void cachefiles_put_object(struct cachefiles_object *obje=
ct,
 =09=09ASSERTCMP(object->file, =3D=3D, NULL);
=20
 =09=09kfree(object->d_name);
-=09=09cachefiles_ondemand_deinit_obj_info(object);
 =09=09cache =3D object->volume->cache->cache;
 =09=09fscache_put_cookie(object->cookie, fscache_cookie_put_object);
 =09=09object->cookie =3D NULL;
@@ -374,8 +368,6 @@ static void cachefiles_withdraw_cookie(struct fscache_c=
ookie *cookie)
 =09=09spin_unlock(&cache->object_list_lock);
 =09}
=20
-=09cachefiles_ondemand_clean_object(object);
-
 =09if (object->file) {
 =09=09cachefiles_begin_secure(cache, &saved_cred);
 =09=09cachefiles_clean_up_object(object, cache);
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index b62cd3e9a18e..c93324e0f98c 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -15,8 +15,6 @@
 #include <linux/fscache-cache.h>
 #include <linux/cred.h>
 #include <linux/security.h>
-#include <linux/xarray.h>
-#include <linux/cachefiles.h>
=20
 #define CACHEFILES_DIO_BLOCK_SIZE 4096
=20
@@ -44,21 +42,6 @@ struct cachefiles_volume {
 =09struct dentry=09=09=09*fanout[256];=09/* Fanout subdirs */
 };
=20
-enum cachefiles_object_state {
-=09CACHEFILES_ONDEMAND_OBJSTATE_CLOSE, /* Anonymous fd closed by daemon or=
 initial state */
-=09CACHEFILES_ONDEMAND_OBJSTATE_OPEN, /* Anonymous fd associated with obje=
ct is available */
-=09CACHEFILES_ONDEMAND_OBJSTATE_REOPENING, /* Object that was closed and i=
s being reopened. */
-=09CACHEFILES_ONDEMAND_OBJSTATE_DROPPING, /* Object is being dropped. */
-};
-
-struct cachefiles_ondemand_info {
-=09struct work_struct=09=09ondemand_work;
-=09int=09=09=09=09ondemand_id;
-=09enum cachefiles_object_state=09state;
-=09struct cachefiles_object=09*object;
-=09spinlock_t=09=09=09lock;
-};
-
 /*
  * Backing file state.
  */
@@ -74,13 +57,8 @@ struct cachefiles_object {
 =09enum cachefiles_content=09=09content_info:8;=09/* Info about content pr=
esence */
 =09unsigned long=09=09=09flags;
 #define CACHEFILES_OBJECT_USING_TMPFILE=090=09=09/* Have an unlinked tmpfi=
le */
-#ifdef CONFIG_CACHEFILES_ONDEMAND
-=09struct cachefiles_ondemand_info=09*ondemand;
-#endif
 };
=20
-#define CACHEFILES_ONDEMAND_ID_CLOSED=09-1
-
 /*
  * Cache files cache definition
  */
@@ -119,35 +97,12 @@ struct cachefiles_cache {
 #define CACHEFILES_DEAD=09=09=091=09/* T if cache dead */
 #define CACHEFILES_CULLING=09=092=09/* T if cull engaged */
 #define CACHEFILES_STATE_CHANGED=093=09/* T if state changed (poll trigger=
) */
-#define CACHEFILES_ONDEMAND_MODE=094=09/* T if in on-demand read mode */
 =09char=09=09=09=09*rootdirname;=09/* name of cache root directory */
 =09char=09=09=09=09*tag;=09=09/* cache binding tag */
-=09refcount_t=09=09=09unbind_pincount;/* refcount to do daemon unbind */
-=09struct xarray=09=09=09reqs;=09=09/* xarray of pending on-demand request=
s */
-=09unsigned long=09=09=09req_id_next;
-=09struct xarray=09=09=09ondemand_ids;=09/* xarray for ondemand_id allocat=
ion */
-=09u32=09=09=09=09ondemand_id_next;
-=09u32=09=09=09=09msg_id_next;
 =09u32=09=09=09=09secid;=09=09/* LSM security id */
 =09bool=09=09=09=09have_secid;=09/* whether "secid" was set */
 };
=20
-static inline bool cachefiles_in_ondemand_mode(struct cachefiles_cache *ca=
che)
-{
-=09return IS_ENABLED(CONFIG_CACHEFILES_ONDEMAND) &&
-=09=09test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags);
-}
-
-struct cachefiles_req {
-=09struct cachefiles_object *object;
-=09struct completion done;
-=09refcount_t ref;
-=09int error;
-=09struct cachefiles_msg msg;
-};
-
-#define CACHEFILES_REQ_NEW=09XA_MARK_1
-
 #include <trace/events/cachefiles.h>
=20
 static inline
@@ -190,9 +145,6 @@ extern int cachefiles_has_space(struct cachefiles_cache=
 *cache,
  * daemon.c
  */
 extern const struct file_operations cachefiles_daemon_fops;
-extern void cachefiles_flush_reqs(struct cachefiles_cache *cache);
-extern void cachefiles_get_unbind_pincount(struct cachefiles_cache *cache)=
;
-extern void cachefiles_put_unbind_pincount(struct cachefiles_cache *cache)=
;
=20
 /*
  * error_inject.c
@@ -298,90 +250,6 @@ extern struct file *cachefiles_create_tmpfile(struct c=
achefiles_object *object);
 extern bool cachefiles_commit_tmpfile(struct cachefiles_cache *cache,
 =09=09=09=09      struct cachefiles_object *object);
=20
-/*
- * ondemand.c
- */
-#ifdef CONFIG_CACHEFILES_ONDEMAND
-extern ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *ca=
che,
-=09=09=09=09=09char __user *_buffer, size_t buflen);
-
-extern int cachefiles_ondemand_copen(struct cachefiles_cache *cache,
-=09=09=09=09     char *args);
-
-extern int cachefiles_ondemand_restore(struct cachefiles_cache *cache,
-=09=09=09=09=09char *args);
-
-extern int cachefiles_ondemand_init_object(struct cachefiles_object *objec=
t);
-extern void cachefiles_ondemand_clean_object(struct cachefiles_object *obj=
ect);
-
-extern int cachefiles_ondemand_read(struct cachefiles_object *object,
-=09=09=09=09    loff_t pos, size_t len);
-
-extern int cachefiles_ondemand_init_obj_info(struct cachefiles_object *obj=
,
-=09=09=09=09=09struct cachefiles_volume *volume);
-extern void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *=
obj);
-
-#define CACHEFILES_OBJECT_STATE_FUNCS(_state, _STATE)=09\
-static inline bool=09=09=09=09=09=09=09=09\
-cachefiles_ondemand_object_is_##_state(const struct cachefiles_object *obj=
ect) \
-{=09=09=09=09=09=09=09=09=09=09=09=09\
-=09return object->ondemand->state =3D=3D CACHEFILES_ONDEMAND_OBJSTATE_##_S=
TATE; \
-}=09=09=09=09=09=09=09=09=09=09=09=09\
-=09=09=09=09=09=09=09=09=09=09=09=09\
-static inline void=09=09=09=09=09=09=09=09\
-cachefiles_ondemand_set_object_##_state(struct cachefiles_object *object) =
\
-{=09=09=09=09=09=09=09=09=09=09=09=09\
-=09object->ondemand->state =3D CACHEFILES_ONDEMAND_OBJSTATE_##_STATE; \
-}
-
-CACHEFILES_OBJECT_STATE_FUNCS(open, OPEN);
-CACHEFILES_OBJECT_STATE_FUNCS(close, CLOSE);
-CACHEFILES_OBJECT_STATE_FUNCS(reopening, REOPENING);
-CACHEFILES_OBJECT_STATE_FUNCS(dropping, DROPPING);
-
-static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles=
_req *req)
-{
-=09return cachefiles_ondemand_object_is_reopening(req->object) &&
-=09=09=09req->msg.opcode =3D=3D CACHEFILES_OP_READ;
-}
-
-#else
-static inline ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_ca=
che *cache,
-=09=09=09=09=09char __user *_buffer, size_t buflen)
-{
-=09return -EOPNOTSUPP;
-}
-
-static inline int cachefiles_ondemand_init_object(struct cachefiles_object=
 *object)
-{
-=09return 0;
-}
-
-static inline void cachefiles_ondemand_clean_object(struct cachefiles_obje=
ct *object)
-{
-}
-
-static inline int cachefiles_ondemand_read(struct cachefiles_object *objec=
t,
-=09=09=09=09=09   loff_t pos, size_t len)
-{
-=09return -EOPNOTSUPP;
-}
-
-static inline int cachefiles_ondemand_init_obj_info(struct cachefiles_obje=
ct *obj,
-=09=09=09=09=09=09struct cachefiles_volume *volume)
-{
-=09return 0;
-}
-static inline void cachefiles_ondemand_deinit_obj_info(struct cachefiles_o=
bject *obj)
-{
-}
-
-static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles=
_req *req)
-{
-=09return false;
-}
-#endif
-
 /*
  * security.c
  */
@@ -430,8 +298,6 @@ do {=09=09=09=09=09=09=09\
 =09pr_err("I/O Error: " FMT"\n", ##__VA_ARGS__);=09\
 =09fscache_io_error((___cache)->cache);=09=09\
 =09set_bit(CACHEFILES_DEAD, &(___cache)->flags);=09\
-=09if (cachefiles_in_ondemand_mode(___cache))=09\
-=09=09cachefiles_flush_reqs(___cache);=09\
 } while (0)
=20
 #define cachefiles_io_error_obj(object, FMT, ...)=09=09=09\
diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index d879b80a0bed..9540ec25b3cb 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -390,7 +390,6 @@ cachefiles_do_prepare_read(struct netfs_cache_resources=
 *cres,
 =09size_t len =3D *_len;
 =09loff_t off, to;
 =09ino_t ino =3D file ? file_inode(file)->i_ino : 0;
-=09int rc;
=20
 =09_enter("%zx @%llx/%llx", len, start, i_size);
=20
@@ -403,8 +402,7 @@ cachefiles_do_prepare_read(struct netfs_cache_resources=
 *cres,
 =09if (test_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &cookie->flags)) {
 =09=09__set_bit(NETFS_SREQ_COPY_TO_CACHE, _flags);
 =09=09why =3D cachefiles_trace_read_no_data;
-=09=09if (!test_bit(NETFS_SREQ_ONDEMAND, _flags))
-=09=09=09goto out_no_object;
+=09=09goto out_no_object;
 =09}
=20
 =09/* The object and the file may be being created in the background. */
@@ -421,7 +419,6 @@ cachefiles_do_prepare_read(struct netfs_cache_resources=
 *cres,
 =09object =3D cachefiles_cres_object(cres);
 =09cache =3D object->volume->cache;
 =09cachefiles_begin_secure(cache, &saved_cred);
-retry:
 =09off =3D cachefiles_inject_read_error();
 =09if (off =3D=3D 0)
 =09=09off =3D vfs_llseek(file, start, SEEK_DATA);
@@ -474,14 +471,6 @@ cachefiles_do_prepare_read(struct netfs_cache_resource=
s *cres,
=20
 download_and_store:
 =09__set_bit(NETFS_SREQ_COPY_TO_CACHE, _flags);
-=09if (test_bit(NETFS_SREQ_ONDEMAND, _flags)) {
-=09=09rc =3D cachefiles_ondemand_read(object, start, len);
-=09=09if (!rc) {
-=09=09=09__clear_bit(NETFS_SREQ_ONDEMAND, _flags);
-=09=09=09goto retry;
-=09=09}
-=09=09ret =3D NETFS_INVALID_READ;
-=09}
 out:
 =09cachefiles_end_secure(cache, saved_cred);
 out_no_object:
@@ -501,18 +490,6 @@ static enum netfs_io_source cachefiles_prepare_read(st=
ruct netfs_io_subrequest *
 =09=09=09=09=09  &subreq->flags, subreq->rreq->inode->i_ino);
 }
=20
-/*
- * Prepare an on-demand read operation, shortening it to a cached/uncached
- * boundary as appropriate.
- */
-static enum netfs_io_source
-cachefiles_prepare_ondemand_read(struct netfs_cache_resources *cres,
-=09=09=09=09 loff_t start, size_t *_len, loff_t i_size,
-=09=09=09=09 unsigned long *_flags, ino_t ino)
-{
-=09return cachefiles_do_prepare_read(cres, start, _len, i_size, _flags, in=
o);
-}
-
 /*
  * Prepare for a write to occur.
  */
@@ -731,7 +708,6 @@ static const struct netfs_cache_ops cachefiles_netfs_ca=
che_ops =3D {
 =09.prepare_read=09=09=3D cachefiles_prepare_read,
 =09.prepare_write=09=09=3D cachefiles_prepare_write,
 =09.prepare_write_subreq=09=3D cachefiles_prepare_write_subreq,
-=09.prepare_ondemand_read=09=3D cachefiles_prepare_ondemand_read,
 =09.query_occupancy=09=3D cachefiles_query_occupancy,
 };
=20
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 8a9f6be15828..88955249a1a6 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -442,10 +442,6 @@ struct file *cachefiles_create_tmpfile(struct cachefil=
es_object *object)
 =09if (!cachefiles_mark_inode_in_use(object, file_inode(file)))
 =09=09WARN_ON(1);
=20
-=09ret =3D cachefiles_ondemand_init_object(object);
-=09if (ret < 0)
-=09=09goto err_unuse;
-
 =09ni_size =3D object->cookie->object_size;
 =09ni_size =3D round_up(ni_size, CACHEFILES_DIO_BLOCK_SIZE);
=20
@@ -546,10 +542,6 @@ static bool cachefiles_open_file(struct cachefiles_obj=
ect *object,
 =09}
 =09_debug("file -> %pd positive", dentry);
=20
-=09ret =3D cachefiles_ondemand_init_object(object);
-=09if (ret < 0)
-=09=09goto error_fput;
-
 =09ret =3D cachefiles_check_auxdata(object, file);
 =09if (ret < 0)
 =09=09goto check_failed;
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
deleted file mode 100644
index 0849eaf583cd..000000000000
--- a/fs/cachefiles/ondemand.c
+++ /dev/null
@@ -1,761 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-#include <linux/anon_inodes.h>
-#include <linux/uio.h>
-#include "internal.h"
-
-struct ondemand_anon_file {
-=09struct file *file;
-=09int fd;
-};
-
-static inline void cachefiles_req_put(struct cachefiles_req *req)
-{
-=09if (refcount_dec_and_test(&req->ref))
-=09=09kfree(req);
-}
-
-static int cachefiles_ondemand_fd_release(struct inode *inode,
-=09=09=09=09=09  struct file *file)
-{
-=09struct cachefiles_object *object =3D file->private_data;
-=09struct cachefiles_cache *cache;
-=09struct cachefiles_ondemand_info *info;
-=09int object_id;
-=09struct cachefiles_req *req;
-=09XA_STATE(xas, NULL, 0);
-
-=09if (!object)
-=09=09return 0;
-
-=09info =3D object->ondemand;
-=09cache =3D object->volume->cache;
-=09xas.xa =3D &cache->reqs;
-
-=09xa_lock(&cache->reqs);
-=09spin_lock(&info->lock);
-=09object_id =3D info->ondemand_id;
-=09info->ondemand_id =3D CACHEFILES_ONDEMAND_ID_CLOSED;
-=09cachefiles_ondemand_set_object_close(object);
-=09spin_unlock(&info->lock);
-
-=09/* Only flush CACHEFILES_REQ_NEW marked req to avoid race with daemon_r=
ead */
-=09xas_for_each_marked(&xas, req, ULONG_MAX, CACHEFILES_REQ_NEW) {
-=09=09if (req->msg.object_id =3D=3D object_id &&
-=09=09    req->msg.opcode =3D=3D CACHEFILES_OP_CLOSE) {
-=09=09=09complete(&req->done);
-=09=09=09xas_store(&xas, NULL);
-=09=09}
-=09}
-=09xa_unlock(&cache->reqs);
-
-=09xa_erase(&cache->ondemand_ids, object_id);
-=09trace_cachefiles_ondemand_fd_release(object, object_id);
-=09cachefiles_put_object(object, cachefiles_obj_put_ondemand_fd);
-=09cachefiles_put_unbind_pincount(cache);
-=09return 0;
-}
-
-static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
-=09=09=09=09=09=09 struct iov_iter *iter)
-{
-=09struct cachefiles_object *object =3D kiocb->ki_filp->private_data;
-=09struct cachefiles_cache *cache =3D object->volume->cache;
-=09struct file *file;
-=09size_t len =3D iter->count, aligned_len =3D len;
-=09loff_t pos =3D kiocb->ki_pos;
-=09const struct cred *saved_cred;
-=09int ret;
-
-=09spin_lock(&object->lock);
-=09file =3D object->file;
-=09if (!file) {
-=09=09spin_unlock(&object->lock);
-=09=09return -ENOBUFS;
-=09}
-=09get_file(file);
-=09spin_unlock(&object->lock);
-
-=09cachefiles_begin_secure(cache, &saved_cred);
-=09ret =3D __cachefiles_prepare_write(object, file, &pos, &aligned_len, le=
n, true);
-=09cachefiles_end_secure(cache, saved_cred);
-=09if (ret < 0)
-=09=09goto out;
-
-=09trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
-=09ret =3D __cachefiles_write(object, file, pos, iter, NULL, NULL);
-=09if (ret > 0)
-=09=09kiocb->ki_pos +=3D ret;
-
-out:
-=09fput(file);
-=09return ret;
-}
-
-static loff_t cachefiles_ondemand_fd_llseek(struct file *filp, loff_t pos,
-=09=09=09=09=09    int whence)
-{
-=09struct cachefiles_object *object =3D filp->private_data;
-=09struct file *file;
-=09loff_t ret;
-
-=09spin_lock(&object->lock);
-=09file =3D object->file;
-=09if (!file) {
-=09=09spin_unlock(&object->lock);
-=09=09return -ENOBUFS;
-=09}
-=09get_file(file);
-=09spin_unlock(&object->lock);
-
-=09ret =3D vfs_llseek(file, pos, whence);
-=09fput(file);
-
-=09return ret;
-}
-
-static long cachefiles_ondemand_fd_ioctl(struct file *filp, unsigned int i=
octl,
-=09=09=09=09=09 unsigned long id)
-{
-=09struct cachefiles_object *object =3D filp->private_data;
-=09struct cachefiles_cache *cache =3D object->volume->cache;
-=09struct cachefiles_req *req;
-=09XA_STATE(xas, &cache->reqs, id);
-
-=09if (ioctl !=3D CACHEFILES_IOC_READ_COMPLETE)
-=09=09return -EINVAL;
-
-=09if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
-=09=09return -EOPNOTSUPP;
-
-=09xa_lock(&cache->reqs);
-=09req =3D xas_load(&xas);
-=09if (!req || req->msg.opcode !=3D CACHEFILES_OP_READ ||
-=09    req->object !=3D object) {
-=09=09xa_unlock(&cache->reqs);
-=09=09return -EINVAL;
-=09}
-=09xas_store(&xas, NULL);
-=09xa_unlock(&cache->reqs);
-
-=09trace_cachefiles_ondemand_cread(object, id);
-=09complete(&req->done);
-=09return 0;
-}
-
-static const struct file_operations cachefiles_ondemand_fd_fops =3D {
-=09.owner=09=09=3D THIS_MODULE,
-=09.release=09=3D cachefiles_ondemand_fd_release,
-=09.write_iter=09=3D cachefiles_ondemand_fd_write_iter,
-=09.llseek=09=09=3D cachefiles_ondemand_fd_llseek,
-=09.unlocked_ioctl=09=3D cachefiles_ondemand_fd_ioctl,
-};
-
-/*
- * OPEN request Completion (copen)
- * - command: "copen <id>,<cache_size>"
- *   <cache_size> indicates the object size if >=3D0, error code if negati=
ve
- */
-int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
-{
-=09struct cachefiles_req *req;
-=09struct fscache_cookie *cookie;
-=09struct cachefiles_ondemand_info *info;
-=09char *pid, *psize;
-=09unsigned long id;
-=09long size;
-=09int ret;
-=09XA_STATE(xas, &cache->reqs, 0);
-
-=09if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
-=09=09return -EOPNOTSUPP;
-
-=09if (!*args) {
-=09=09pr_err("Empty id specified\n");
-=09=09return -EINVAL;
-=09}
-
-=09pid =3D args;
-=09psize =3D strchr(args, ',');
-=09if (!psize) {
-=09=09pr_err("Cache size is not specified\n");
-=09=09return -EINVAL;
-=09}
-
-=09*psize =3D 0;
-=09psize++;
-
-=09ret =3D kstrtoul(pid, 0, &id);
-=09if (ret)
-=09=09return ret;
-
-=09xa_lock(&cache->reqs);
-=09xas.xa_index =3D id;
-=09req =3D xas_load(&xas);
-=09if (!req || req->msg.opcode !=3D CACHEFILES_OP_OPEN ||
-=09    !req->object->ondemand->ondemand_id) {
-=09=09xa_unlock(&cache->reqs);
-=09=09return -EINVAL;
-=09}
-=09xas_store(&xas, NULL);
-=09xa_unlock(&cache->reqs);
-
-=09info =3D req->object->ondemand;
-=09/* fail OPEN request if copen format is invalid */
-=09ret =3D kstrtol(psize, 0, &size);
-=09if (ret) {
-=09=09req->error =3D ret;
-=09=09goto out;
-=09}
-
-=09/* fail OPEN request if daemon reports an error */
-=09if (size < 0) {
-=09=09if (!IS_ERR_VALUE(size)) {
-=09=09=09req->error =3D -EINVAL;
-=09=09=09ret =3D -EINVAL;
-=09=09} else {
-=09=09=09req->error =3D size;
-=09=09=09ret =3D 0;
-=09=09}
-=09=09goto out;
-=09}
-
-=09spin_lock(&info->lock);
-=09/*
-=09 * The anonymous fd was closed before copen ? Fail the request.
-=09 *
-=09 *             t1             |             t2
-=09 * ---------------------------------------------------------
-=09 *                             cachefiles_ondemand_copen
-=09 *                             req =3D xa_erase(&cache->reqs, id)
-=09 * // Anon fd is maliciously closed.
-=09 * cachefiles_ondemand_fd_release
-=09 * xa_lock(&cache->reqs)
-=09 * cachefiles_ondemand_set_object_close(object)
-=09 * xa_unlock(&cache->reqs)
-=09 *                             cachefiles_ondemand_set_object_open
-=09 *                             // No one will ever close it again.
-=09 * cachefiles_ondemand_daemon_read
-=09 * cachefiles_ondemand_select_req
-=09 *
-=09 * Get a read req but its fd is already closed. The daemon can't
-=09 * issue a cread ioctl with an closed fd, then hung.
-=09 */
-=09if (info->ondemand_id =3D=3D CACHEFILES_ONDEMAND_ID_CLOSED) {
-=09=09spin_unlock(&info->lock);
-=09=09req->error =3D -EBADFD;
-=09=09goto out;
-=09}
-=09cookie =3D req->object->cookie;
-=09cookie->object_size =3D size;
-=09if (size)
-=09=09clear_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &cookie->flags);
-=09else
-=09=09set_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &cookie->flags);
-=09trace_cachefiles_ondemand_copen(req->object, id, size);
-
-=09cachefiles_ondemand_set_object_open(req->object);
-=09spin_unlock(&info->lock);
-=09wake_up_all(&cache->daemon_pollwq);
-
-out:
-=09spin_lock(&info->lock);
-=09/* Need to set object close to avoid reopen status continuing */
-=09if (info->ondemand_id =3D=3D CACHEFILES_ONDEMAND_ID_CLOSED)
-=09=09cachefiles_ondemand_set_object_close(req->object);
-=09spin_unlock(&info->lock);
-=09complete(&req->done);
-=09return ret;
-}
-
-int cachefiles_ondemand_restore(struct cachefiles_cache *cache, char *args=
)
-{
-=09struct cachefiles_req *req;
-
-=09XA_STATE(xas, &cache->reqs, 0);
-
-=09if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
-=09=09return -EOPNOTSUPP;
-
-=09/*
-=09 * Reset the requests to CACHEFILES_REQ_NEW state, so that the
-=09 * requests have been processed halfway before the crash of the
-=09 * user daemon could be reprocessed after the recovery.
-=09 */
-=09xas_lock(&xas);
-=09xas_for_each(&xas, req, ULONG_MAX)
-=09=09xas_set_mark(&xas, CACHEFILES_REQ_NEW);
-=09xas_unlock(&xas);
-
-=09wake_up_all(&cache->daemon_pollwq);
-=09return 0;
-}
-
-static int cachefiles_ondemand_get_fd(struct cachefiles_req *req,
-=09=09=09=09      struct ondemand_anon_file *anon_file)
-{
-=09struct cachefiles_object *object;
-=09struct cachefiles_cache *cache;
-=09struct cachefiles_open *load;
-=09u32 object_id;
-=09int ret;
-
-=09object =3D cachefiles_grab_object(req->object,
-=09=09=09cachefiles_obj_get_ondemand_fd);
-=09cache =3D object->volume->cache;
-
-=09ret =3D xa_alloc_cyclic(&cache->ondemand_ids, &object_id, NULL,
-=09=09=09      XA_LIMIT(1, INT_MAX),
-=09=09=09      &cache->ondemand_id_next, GFP_KERNEL);
-=09if (ret < 0)
-=09=09goto err;
-
-=09anon_file->fd =3D get_unused_fd_flags(O_WRONLY);
-=09if (anon_file->fd < 0) {
-=09=09ret =3D anon_file->fd;
-=09=09goto err_free_id;
-=09}
-
-=09anon_file->file =3D anon_inode_getfile_fmode("[cachefiles]",
-=09=09=09=09&cachefiles_ondemand_fd_fops, object,
-=09=09=09=09O_WRONLY, FMODE_PWRITE | FMODE_LSEEK);
-=09if (IS_ERR(anon_file->file)) {
-=09=09ret =3D PTR_ERR(anon_file->file);
-=09=09goto err_put_fd;
-=09}
-
-=09spin_lock(&object->ondemand->lock);
-=09if (object->ondemand->ondemand_id > 0) {
-=09=09spin_unlock(&object->ondemand->lock);
-=09=09/* Pair with check in cachefiles_ondemand_fd_release(). */
-=09=09anon_file->file->private_data =3D NULL;
-=09=09ret =3D -EEXIST;
-=09=09goto err_put_file;
-=09}
-
-=09load =3D (void *)req->msg.data;
-=09load->fd =3D anon_file->fd;
-=09object->ondemand->ondemand_id =3D object_id;
-=09spin_unlock(&object->ondemand->lock);
-
-=09cachefiles_get_unbind_pincount(cache);
-=09trace_cachefiles_ondemand_open(object, &req->msg, load);
-=09return 0;
-
-err_put_file:
-=09fput(anon_file->file);
-=09anon_file->file =3D NULL;
-err_put_fd:
-=09put_unused_fd(anon_file->fd);
-=09anon_file->fd =3D ret;
-err_free_id:
-=09xa_erase(&cache->ondemand_ids, object_id);
-err:
-=09spin_lock(&object->ondemand->lock);
-=09/* Avoid marking an opened object as closed. */
-=09if (object->ondemand->ondemand_id <=3D 0)
-=09=09cachefiles_ondemand_set_object_close(object);
-=09spin_unlock(&object->ondemand->lock);
-=09cachefiles_put_object(object, cachefiles_obj_put_ondemand_fd);
-=09return ret;
-}
-
-static void ondemand_object_worker(struct work_struct *work)
-{
-=09struct cachefiles_ondemand_info *info =3D
-=09=09container_of(work, struct cachefiles_ondemand_info, ondemand_work);
-
-=09cachefiles_ondemand_init_object(info->object);
-}
-
-/*
- * If there are any inflight or subsequent READ requests on the
- * closed object, reopen it.
- * Skip read requests whose related object is reopening.
- */
-static struct cachefiles_req *cachefiles_ondemand_select_req(struct xa_sta=
te *xas,
-=09=09=09=09=09=09=09      unsigned long xa_max)
-{
-=09struct cachefiles_req *req;
-=09struct cachefiles_object *object;
-=09struct cachefiles_ondemand_info *info;
-
-=09xas_for_each_marked(xas, req, xa_max, CACHEFILES_REQ_NEW) {
-=09=09if (req->msg.opcode !=3D CACHEFILES_OP_READ)
-=09=09=09return req;
-=09=09object =3D req->object;
-=09=09info =3D object->ondemand;
-=09=09if (cachefiles_ondemand_object_is_close(object)) {
-=09=09=09cachefiles_ondemand_set_object_reopening(object);
-=09=09=09queue_work(fscache_wq, &info->ondemand_work);
-=09=09=09continue;
-=09=09}
-=09=09if (cachefiles_ondemand_object_is_reopening(object))
-=09=09=09continue;
-=09=09return req;
-=09}
-=09return NULL;
-}
-
-static inline bool cachefiles_ondemand_finish_req(struct cachefiles_req *r=
eq,
-=09=09=09=09=09=09  struct xa_state *xas, int err)
-{
-=09if (unlikely(!xas || !req))
-=09=09return false;
-
-=09if (xa_cmpxchg(xas->xa, xas->xa_index, req, NULL, 0) !=3D req)
-=09=09return false;
-
-=09req->error =3D err;
-=09complete(&req->done);
-=09return true;
-}
-
-ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
-=09=09=09=09=09char __user *_buffer, size_t buflen)
-{
-=09struct cachefiles_req *req;
-=09struct cachefiles_msg *msg;
-=09size_t n;
-=09int ret =3D 0;
-=09struct ondemand_anon_file anon_file;
-=09XA_STATE(xas, &cache->reqs, cache->req_id_next);
-
-=09xa_lock(&cache->reqs);
-=09/*
-=09 * Cyclically search for a request that has not ever been processed,
-=09 * to prevent requests from being processed repeatedly, and make
-=09 * request distribution fair.
-=09 */
-=09req =3D cachefiles_ondemand_select_req(&xas, ULONG_MAX);
-=09if (!req && cache->req_id_next > 0) {
-=09=09xas_set(&xas, 0);
-=09=09req =3D cachefiles_ondemand_select_req(&xas, cache->req_id_next - 1)=
;
-=09}
-=09if (!req) {
-=09=09xa_unlock(&cache->reqs);
-=09=09return 0;
-=09}
-
-=09msg =3D &req->msg;
-=09n =3D msg->len;
-
-=09if (n > buflen) {
-=09=09xa_unlock(&cache->reqs);
-=09=09return -EMSGSIZE;
-=09}
-
-=09xas_clear_mark(&xas, CACHEFILES_REQ_NEW);
-=09cache->req_id_next =3D xas.xa_index + 1;
-=09refcount_inc(&req->ref);
-=09cachefiles_grab_object(req->object, cachefiles_obj_get_read_req);
-=09xa_unlock(&cache->reqs);
-
-=09if (msg->opcode =3D=3D CACHEFILES_OP_OPEN) {
-=09=09ret =3D cachefiles_ondemand_get_fd(req, &anon_file);
-=09=09if (ret)
-=09=09=09goto out;
-=09}
-
-=09msg->msg_id =3D xas.xa_index;
-=09msg->object_id =3D req->object->ondemand->ondemand_id;
-
-=09if (copy_to_user(_buffer, msg, n) !=3D 0)
-=09=09ret =3D -EFAULT;
-
-=09if (msg->opcode =3D=3D CACHEFILES_OP_OPEN) {
-=09=09if (ret < 0) {
-=09=09=09fput(anon_file.file);
-=09=09=09put_unused_fd(anon_file.fd);
-=09=09=09goto out;
-=09=09}
-=09=09fd_install(anon_file.fd, anon_file.file);
-=09}
-out:
-=09cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
-=09/* Remove error request and CLOSE request has no reply */
-=09if (ret || msg->opcode =3D=3D CACHEFILES_OP_CLOSE)
-=09=09cachefiles_ondemand_finish_req(req, &xas, ret);
-=09cachefiles_req_put(req);
-=09return ret ? ret : n;
-}
-
-typedef int (*init_req_fn)(struct cachefiles_req *req, void *private);
-
-static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
-=09=09=09=09=09enum cachefiles_opcode opcode,
-=09=09=09=09=09size_t data_len,
-=09=09=09=09=09init_req_fn init_req,
-=09=09=09=09=09void *private)
-{
-=09struct cachefiles_cache *cache =3D object->volume->cache;
-=09struct cachefiles_req *req =3D NULL;
-=09XA_STATE(xas, &cache->reqs, 0);
-=09int ret;
-
-=09if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
-=09=09return 0;
-
-=09if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-=09=09ret =3D -EIO;
-=09=09goto out;
-=09}
-
-=09req =3D kzalloc(sizeof(*req) + data_len, GFP_KERNEL);
-=09if (!req) {
-=09=09ret =3D -ENOMEM;
-=09=09goto out;
-=09}
-
-=09refcount_set(&req->ref, 1);
-=09req->object =3D object;
-=09init_completion(&req->done);
-=09req->msg.opcode =3D opcode;
-=09req->msg.len =3D sizeof(struct cachefiles_msg) + data_len;
-
-=09ret =3D init_req(req, private);
-=09if (ret)
-=09=09goto out;
-
-=09do {
-=09=09/*
-=09=09 * Stop enqueuing the request when daemon is dying. The
-=09=09 * following two operations need to be atomic as a whole.
-=09=09 *   1) check cache state, and
-=09=09 *   2) enqueue request if cache is alive.
-=09=09 * Otherwise the request may be enqueued after xarray has been
-=09=09 * flushed, leaving the orphan request never being completed.
-=09=09 *
-=09=09 * CPU 1=09=09=09CPU 2
-=09=09 * =3D=3D=3D=3D=3D=09=09=09=3D=3D=3D=3D=3D
-=09=09 *=09=09=09=09test CACHEFILES_DEAD bit
-=09=09 * set CACHEFILES_DEAD bit
-=09=09 * flush requests in the xarray
-=09=09 *=09=09=09=09enqueue the request
-=09=09 */
-=09=09xas_lock(&xas);
-
-=09=09if (test_bit(CACHEFILES_DEAD, &cache->flags) ||
-=09=09    cachefiles_ondemand_object_is_dropping(object)) {
-=09=09=09xas_unlock(&xas);
-=09=09=09ret =3D -EIO;
-=09=09=09goto out;
-=09=09}
-
-=09=09/* coupled with the barrier in cachefiles_flush_reqs() */
-=09=09smp_mb();
-
-=09=09if (opcode =3D=3D CACHEFILES_OP_CLOSE &&
-=09=09    !cachefiles_ondemand_object_is_open(object)) {
-=09=09=09WARN_ON_ONCE(object->ondemand->ondemand_id =3D=3D 0);
-=09=09=09xas_unlock(&xas);
-=09=09=09ret =3D -EIO;
-=09=09=09goto out;
-=09=09}
-
-=09=09/*
-=09=09 * Cyclically find a free xas to avoid msg_id reuse that would
-=09=09 * cause the daemon to successfully copen a stale msg_id.
-=09=09 */
-=09=09xas.xa_index =3D cache->msg_id_next;
-=09=09xas_find_marked(&xas, UINT_MAX, XA_FREE_MARK);
-=09=09if (xas.xa_node =3D=3D XAS_RESTART) {
-=09=09=09xas.xa_index =3D 0;
-=09=09=09xas_find_marked(&xas, cache->msg_id_next - 1, XA_FREE_MARK);
-=09=09}
-=09=09if (xas.xa_node =3D=3D XAS_RESTART)
-=09=09=09xas_set_err(&xas, -EBUSY);
-
-=09=09xas_store(&xas, req);
-=09=09if (xas_valid(&xas)) {
-=09=09=09cache->msg_id_next =3D xas.xa_index + 1;
-=09=09=09xas_clear_mark(&xas, XA_FREE_MARK);
-=09=09=09xas_set_mark(&xas, CACHEFILES_REQ_NEW);
-=09=09}
-=09=09xas_unlock(&xas);
-=09} while (xas_nomem(&xas, GFP_KERNEL));
-
-=09ret =3D xas_error(&xas);
-=09if (ret)
-=09=09goto out;
-
-=09wake_up_all(&cache->daemon_pollwq);
-wait:
-=09ret =3D wait_for_completion_killable(&req->done);
-=09if (!ret) {
-=09=09ret =3D req->error;
-=09} else {
-=09=09ret =3D -EINTR;
-=09=09if (!cachefiles_ondemand_finish_req(req, &xas, ret)) {
-=09=09=09/* Someone will complete it soon. */
-=09=09=09cpu_relax();
-=09=09=09goto wait;
-=09=09}
-=09}
-=09cachefiles_req_put(req);
-=09return ret;
-out:
-=09/* Reset the object to close state in error handling path.
-=09 * If error occurs after creating the anonymous fd,
-=09 * cachefiles_ondemand_fd_release() will set object to close.
-=09 */
-=09if (opcode =3D=3D CACHEFILES_OP_OPEN &&
-=09    !cachefiles_ondemand_object_is_dropping(object))
-=09=09cachefiles_ondemand_set_object_close(object);
-=09kfree(req);
-=09return ret;
-}
-
-static int cachefiles_ondemand_init_open_req(struct cachefiles_req *req,
-=09=09=09=09=09     void *private)
-{
-=09struct cachefiles_object *object =3D req->object;
-=09struct fscache_cookie *cookie =3D object->cookie;
-=09struct fscache_volume *volume =3D object->volume->vcookie;
-=09struct cachefiles_open *load =3D (void *)req->msg.data;
-=09size_t volume_key_size, cookie_key_size;
-=09void *volume_key, *cookie_key;
-
-=09/*
-=09 * Volume key is a NUL-terminated string. key[0] stores strlen() of the
-=09 * string, followed by the content of the string (excluding '\0').
-=09 */
-=09volume_key_size =3D volume->key[0] + 1;
-=09volume_key =3D volume->key + 1;
-
-=09/* Cookie key is binary data, which is netfs specific. */
-=09cookie_key_size =3D cookie->key_len;
-=09cookie_key =3D fscache_get_key(cookie);
-
-=09if (!(object->cookie->advice & FSCACHE_ADV_WANT_CACHE_SIZE)) {
-=09=09pr_err("WANT_CACHE_SIZE is needed for on-demand mode\n");
-=09=09return -EINVAL;
-=09}
-
-=09load->volume_key_size =3D volume_key_size;
-=09load->cookie_key_size =3D cookie_key_size;
-=09memcpy(load->data, volume_key, volume_key_size);
-=09memcpy(load->data + volume_key_size, cookie_key, cookie_key_size);
-
-=09return 0;
-}
-
-static int cachefiles_ondemand_init_close_req(struct cachefiles_req *req,
-=09=09=09=09=09      void *private)
-{
-=09struct cachefiles_object *object =3D req->object;
-
-=09if (!cachefiles_ondemand_object_is_open(object))
-=09=09return -ENOENT;
-
-=09trace_cachefiles_ondemand_close(object, &req->msg);
-=09return 0;
-}
-
-struct cachefiles_read_ctx {
-=09loff_t off;
-=09size_t len;
-};
-
-static int cachefiles_ondemand_init_read_req(struct cachefiles_req *req,
-=09=09=09=09=09     void *private)
-{
-=09struct cachefiles_object *object =3D req->object;
-=09struct cachefiles_read *load =3D (void *)req->msg.data;
-=09struct cachefiles_read_ctx *read_ctx =3D private;
-
-=09load->off =3D read_ctx->off;
-=09load->len =3D read_ctx->len;
-=09trace_cachefiles_ondemand_read(object, &req->msg, load);
-=09return 0;
-}
-
-int cachefiles_ondemand_init_object(struct cachefiles_object *object)
-{
-=09struct fscache_cookie *cookie =3D object->cookie;
-=09struct fscache_volume *volume =3D object->volume->vcookie;
-=09size_t volume_key_size, cookie_key_size, data_len;
-
-=09if (!object->ondemand)
-=09=09return 0;
-
-=09/*
-=09 * CacheFiles will firstly check the cache file under the root cache
-=09 * directory. If the coherency check failed, it will fallback to
-=09 * creating a new tmpfile as the cache file. Reuse the previously
-=09 * allocated object ID if any.
-=09 */
-=09if (cachefiles_ondemand_object_is_open(object))
-=09=09return 0;
-
-=09volume_key_size =3D volume->key[0] + 1;
-=09cookie_key_size =3D cookie->key_len;
-=09data_len =3D sizeof(struct cachefiles_open) +
-=09=09   volume_key_size + cookie_key_size;
-
-=09return cachefiles_ondemand_send_req(object, CACHEFILES_OP_OPEN,
-=09=09=09data_len, cachefiles_ondemand_init_open_req, NULL);
-}
-
-void cachefiles_ondemand_clean_object(struct cachefiles_object *object)
-{
-=09unsigned long index;
-=09struct cachefiles_req *req;
-=09struct cachefiles_cache *cache;
-
-=09if (!object->ondemand)
-=09=09return;
-
-=09cachefiles_ondemand_send_req(object, CACHEFILES_OP_CLOSE, 0,
-=09=09=09cachefiles_ondemand_init_close_req, NULL);
-
-=09if (!object->ondemand->ondemand_id)
-=09=09return;
-
-=09/* Cancel all requests for the object that is being dropped. */
-=09cache =3D object->volume->cache;
-=09xa_lock(&cache->reqs);
-=09cachefiles_ondemand_set_object_dropping(object);
-=09xa_for_each(&cache->reqs, index, req) {
-=09=09if (req->object =3D=3D object) {
-=09=09=09req->error =3D -EIO;
-=09=09=09complete(&req->done);
-=09=09=09__xa_erase(&cache->reqs, index);
-=09=09}
-=09}
-=09xa_unlock(&cache->reqs);
-
-=09/* Wait for ondemand_object_worker() to finish to avoid UAF. */
-=09cancel_work_sync(&object->ondemand->ondemand_work);
-}
-
-int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
-=09=09=09=09struct cachefiles_volume *volume)
-{
-=09if (!cachefiles_in_ondemand_mode(volume->cache))
-=09=09return 0;
-
-=09object->ondemand =3D kzalloc_obj(struct cachefiles_ondemand_info);
-=09if (!object->ondemand)
-=09=09return -ENOMEM;
-
-=09object->ondemand->object =3D object;
-=09spin_lock_init(&object->ondemand->lock);
-=09INIT_WORK(&object->ondemand->ondemand_work, ondemand_object_worker);
-=09return 0;
-}
-
-void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *object)
-{
-=09kfree(object->ondemand);
-=09object->ondemand =3D NULL;
-}
-
-int cachefiles_ondemand_read(struct cachefiles_object *object,
-=09=09=09     loff_t pos, size_t len)
-{
-=09struct cachefiles_read_ctx read_ctx =3D {pos, len};
-
-=09return cachefiles_ondemand_send_req(object, CACHEFILES_OP_READ,
-=09=09=09sizeof(struct cachefiles_read),
-=09=09=09cachefiles_ondemand_init_read_req, &read_ctx);
-}
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index cc8d6500d059..a8702bd52d3a 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -191,7 +191,6 @@ struct netfs_io_subrequest {
 #define NETFS_SREQ_COPY_TO_CACHE=090=09/* Set if should copy the data to t=
he cache */
 #define NETFS_SREQ_CLEAR_TAIL=09=091=09/* Set if the rest of the read shou=
ld be cleared */
 #define NETFS_SREQ_MADE_PROGRESS=094=09/* Set if we transferred at least s=
ome data */
-#define NETFS_SREQ_ONDEMAND=09=095=09/* Set if it's from on-demand read mo=
de */
 #define NETFS_SREQ_BOUNDARY=09=096=09/* Set if ends on hard boundary (eg. =
ceph object) */
 #define NETFS_SREQ_HIT_EOF=09=097=09/* Set if short due to EOF */
 #define NETFS_SREQ_IN_PROGRESS=09=098=09/* Unlocked when the subrequest co=
mpletes */
@@ -374,14 +373,6 @@ struct netfs_cache_ops {
 =09=09=09     loff_t *_start, size_t *_len, size_t upper_len,
 =09=09=09     loff_t i_size, bool no_space_allocated_yet);
=20
-=09/* Prepare an on-demand read operation, shortening it to a cached/uncac=
hed
-=09 * boundary as appropriate.
-=09 */
-=09enum netfs_io_source (*prepare_ondemand_read)(struct netfs_cache_resour=
ces *cres,
-=09=09=09=09=09=09      loff_t start, size_t *_len,
-=09=09=09=09=09=09      loff_t i_size,
-=09=09=09=09=09=09      unsigned long *_flags, ino_t ino);
-
 =09/* Query the occupancy of the cache in a region, returning where the
 =09 * next chunk of data starts and how long it is.
 =09 */
diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cache=
files.h
index 6e3b1424eea4..9259bc71049e 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -31,10 +31,6 @@ enum cachefiles_obj_ref_trace {
 =09cachefiles_obj_see_lookup_failed,
 =09cachefiles_obj_see_withdraw_cookie,
 =09cachefiles_obj_see_withdrawal,
-=09cachefiles_obj_get_ondemand_fd,
-=09cachefiles_obj_put_ondemand_fd,
-=09cachefiles_obj_get_read_req,
-=09cachefiles_obj_put_read_req,
 };
=20
 enum fscache_why_object_killed {
@@ -129,11 +125,7 @@ enum cachefiles_error_trace {
 =09EM(cachefiles_obj_see_lookup_cookie,=09"SEE lookup_cookie")=09\
 =09EM(cachefiles_obj_see_lookup_failed,=09"SEE lookup_failed")=09\
 =09EM(cachefiles_obj_see_withdraw_cookie,=09"SEE withdraw_cookie")=09\
-=09EM(cachefiles_obj_see_withdrawal,=09"SEE withdrawal")=09\
-=09EM(cachefiles_obj_get_ondemand_fd,      "GET ondemand_fd")=09\
-=09EM(cachefiles_obj_put_ondemand_fd,      "PUT ondemand_fd")=09\
-=09EM(cachefiles_obj_get_read_req,=09=09"GET read_req")=09=09\
-=09E_(cachefiles_obj_put_read_req,=09=09"PUT read_req")
+=09E_(cachefiles_obj_see_withdrawal,=09"SEE withdrawal")
=20
 #define cachefiles_coherency_traces=09=09=09=09=09\
 =09EM(cachefiles_coherency_check_aux,=09"BAD aux ")=09=09\
@@ -687,180 +679,6 @@ TRACE_EVENT(cachefiles_io_error,
 =09=09      __entry->error)
 =09    );
=20
-TRACE_EVENT(cachefiles_ondemand_open,
-=09    TP_PROTO(struct cachefiles_object *obj, struct cachefiles_msg *msg,
-=09=09     struct cachefiles_open *load),
-
-=09    TP_ARGS(obj, msg, load),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09msg_id)
-=09=09    __field(unsigned int,=09object_id)
-=09=09    __field(unsigned int,=09fd)
-=09=09    __field(unsigned int,=09flags)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->msg_id=09=3D msg->msg_id;
-=09=09    __entry->object_id=09=3D msg->object_id;
-=09=09    __entry->fd=09=09=3D load->fd;
-=09=09    __entry->flags=09=3D load->flags;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x mid=3D%x oid=3D%x fd=3D%d f=3D%x",
-=09=09      __entry->obj,
-=09=09      __entry->msg_id,
-=09=09      __entry->object_id,
-=09=09      __entry->fd,
-=09=09      __entry->flags)
-=09    );
-
-TRACE_EVENT(cachefiles_ondemand_copen,
-=09    TP_PROTO(struct cachefiles_object *obj, unsigned int msg_id,
-=09=09     long len),
-
-=09    TP_ARGS(obj, msg_id, len),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09msg_id)
-=09=09    __field(long,=09=09len)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->msg_id=09=3D msg_id;
-=09=09    __entry->len=09=3D len;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x mid=3D%x l=3D%lx",
-=09=09      __entry->obj,
-=09=09      __entry->msg_id,
-=09=09      __entry->len)
-=09    );
-
-TRACE_EVENT(cachefiles_ondemand_close,
-=09    TP_PROTO(struct cachefiles_object *obj, struct cachefiles_msg *msg)=
,
-
-=09    TP_ARGS(obj, msg),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09msg_id)
-=09=09    __field(unsigned int,=09object_id)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->msg_id=09=3D msg->msg_id;
-=09=09    __entry->object_id=09=3D msg->object_id;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x mid=3D%x oid=3D%x",
-=09=09      __entry->obj,
-=09=09      __entry->msg_id,
-=09=09      __entry->object_id)
-=09    );
-
-TRACE_EVENT(cachefiles_ondemand_read,
-=09    TP_PROTO(struct cachefiles_object *obj, struct cachefiles_msg *msg,
-=09=09     struct cachefiles_read *load),
-
-=09    TP_ARGS(obj, msg, load),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09msg_id)
-=09=09    __field(unsigned int,=09object_id)
-=09=09    __field(loff_t,=09=09start)
-=09=09    __field(size_t,=09=09len)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->msg_id=09=3D msg->msg_id;
-=09=09    __entry->object_id=09=3D msg->object_id;
-=09=09    __entry->start=09=3D load->off;
-=09=09    __entry->len=09=3D load->len;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x mid=3D%x oid=3D%x s=3D%llx l=3D%zx",
-=09=09      __entry->obj,
-=09=09      __entry->msg_id,
-=09=09      __entry->object_id,
-=09=09      __entry->start,
-=09=09      __entry->len)
-=09    );
-
-TRACE_EVENT(cachefiles_ondemand_cread,
-=09    TP_PROTO(struct cachefiles_object *obj, unsigned int msg_id),
-
-=09    TP_ARGS(obj, msg_id),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09msg_id)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->msg_id=09=3D msg_id;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x mid=3D%x",
-=09=09      __entry->obj,
-=09=09      __entry->msg_id)
-=09    );
-
-TRACE_EVENT(cachefiles_ondemand_fd_write,
-=09    TP_PROTO(struct cachefiles_object *obj, struct inode *backer,
-=09=09     loff_t start, size_t len),
-
-=09    TP_ARGS(obj, backer, start, len),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09backer)
-=09=09    __field(loff_t,=09=09start)
-=09=09    __field(size_t,=09=09len)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->backer=09=3D backer->i_ino;
-=09=09    __entry->start=09=3D start;
-=09=09    __entry->len=09=3D len;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x iB=3D%x s=3D%llx l=3D%zx",
-=09=09      __entry->obj,
-=09=09      __entry->backer,
-=09=09      __entry->start,
-=09=09      __entry->len)
-=09    );
-
-TRACE_EVENT(cachefiles_ondemand_fd_release,
-=09    TP_PROTO(struct cachefiles_object *obj, int object_id),
-
-=09    TP_ARGS(obj, object_id),
-
-=09    TP_STRUCT__entry(
-=09=09    __field(unsigned int,=09obj)
-=09=09    __field(unsigned int,=09object_id)
-=09=09=09     ),
-
-=09    TP_fast_assign(
-=09=09    __entry->obj=09=3D obj ? obj->debug_id : 0;
-=09=09    __entry->object_id=09=3D object_id;
-=09=09=09   ),
-
-=09    TP_printk("o=3D%08x oid=3D%x",
-=09=09      __entry->obj,
-=09=09      __entry->object_id)
-=09    );
-
 #endif /* _TRACE_CACHEFILES_H */
=20
 /* This part must be outside protection */
diff --git a/include/uapi/linux/cachefiles.h b/include/uapi/linux/cachefile=
s.h
deleted file mode 100644
index 78caa73e5343..000000000000
--- a/include/uapi/linux/cachefiles.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _LINUX_CACHEFILES_H
-#define _LINUX_CACHEFILES_H
-
-#include <linux/types.h>
-#include <linux/ioctl.h>
-
-/*
- * Fscache ensures that the maximum length of cookie key is 255. The volum=
e key
- * is controlled by netfs, and generally no bigger than 255.
- */
-#define CACHEFILES_MSG_MAX_SIZE=091024
-
-enum cachefiles_opcode {
-=09CACHEFILES_OP_OPEN,
-=09CACHEFILES_OP_CLOSE,
-=09CACHEFILES_OP_READ,
-};
-
-/*
- * Message Header
- *
- * @msg_id=09a unique ID identifying this message
- * @opcode=09message type, CACHEFILE_OP_*
- * @len=09=09message length, including message header and following data
- * @object_id=09a unique ID identifying a cache file
- * @data=09message type specific payload
- */
-struct cachefiles_msg {
-=09__u32 msg_id;
-=09__u32 opcode;
-=09__u32 len;
-=09__u32 object_id;
-=09__u8  data[];
-};
-
-/*
- * @data contains the volume_key followed directly by the cookie_key. volu=
me_key
- * is a NUL-terminated string; @volume_key_size indicates the size of the =
volume
- * key in bytes. cookie_key is binary data, which is netfs specific;
- * @cookie_key_size indicates the size of the cookie key in bytes.
- *
- * @fd identifies an anon_fd referring to the cache file.
- */
-struct cachefiles_open {
-=09__u32 volume_key_size;
-=09__u32 cookie_key_size;
-=09__u32 fd;
-=09__u32 flags;
-=09__u8  data[];
-};
-
-/*
- * @off=09=09indicates the starting offset of the requested file range
- * @len=09=09indicates the length of the requested file range
- */
-struct cachefiles_read {
-=09__u64 off;
-=09__u64 len;
-};
-
-/*
- * Reply for READ request
- * @arg for this ioctl is the @id field of READ request.
- */
-#define CACHEFILES_IOC_READ_COMPLETE=09_IOW(0x98, 1, int)
-
-#endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c4673a54c4ba..7e25051dc1ea 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6676,13 +6676,6 @@ static const struct bpf_raw_tp_null_args raw_tp_null=
_args[] =3D {
 =09{ "cachefiles_mark_inactive", 0x1 },
 =09{ "cachefiles_vfs_error", 0x1 },
 =09{ "cachefiles_io_error", 0x1 },
-=09{ "cachefiles_ondemand_open", 0x1 },
-=09{ "cachefiles_ondemand_copen", 0x1 },
-=09{ "cachefiles_ondemand_close", 0x1 },
-=09{ "cachefiles_ondemand_read", 0x1 },
-=09{ "cachefiles_ondemand_cread", 0x1 },
-=09{ "cachefiles_ondemand_fd_write", 0x1 },
-=09{ "cachefiles_ondemand_fd_release", 0x1 },
 =09/* ext4, from ext4__mballoc event class */
 =09{ "ext4_mballoc_discard", 0x10 },
 =09{ "ext4_mballoc_free", 0x10 },


