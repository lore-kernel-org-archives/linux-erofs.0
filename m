Return-Path: <linux-erofs+bounces-1311-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EA6CCF9F8
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Nov 2025 11:27:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4d0Tnp6QQfz2ygD;
	Mon,  3 Nov 2025 22:27:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1762169230;
	cv=none; b=Jpkx7r8KN1lO6g5Ir8lBjWf+V/XRBiChIyM2vZ8NFRjDVlmftAvxQB16RB5xhdi/4hxZ95oKB63nEYG0OQHbnSqV8nCcI4aR7BXiE5GrcumFkz1dml7pvQk2O+ukTZjrNnOlEjNmujLQOr4tByPyq+QjobmEzO3g0Zb3GU+uicZDqz3OMdfHzTVWMAf1y60diy7msvMlwEifbkiAtkd4WcGgkB6bRAMbfFmXi+PifrL3fNnL12jqdE3KzzebxuMK17wz999WrO0UzDzuZbL2z5RW0+iyt5azxsr29vgRrQHxi/fbUKZ+hxup5WM1aZ7yt4/UCj6hkW72P7ay0Sdd6w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1762169230; c=relaxed/relaxed;
	bh=fHJ7QjW7mKlAjBSNqYKoWotiuGCkV811q86OwFkE3Po=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kq3d5B5TiRRzdGX4n497LK2ZDefWndhIyzwr1lcjEMF44Bmbf49z50oIBzU/XX/aW75IcivGs69pwTlOivV0a5oIbA7/+zN0Ts2Uf2Jk8DyIQmgKqOzwM9Bx3UVU6IzvKD9HHhCY7g1ORdMSa1aWrHDrTwttEnfbeBiIzZnvYTFLXdCHkk0NXbevOTjTgJckc7cRa+HQEXJoc9jjuCc3a4CAvyTSEiLnoNXtif0ZNNpEVN+d5QJGXqmr6Cv0IGxmiJ9R0fHbrX75h78pfRE2S9hp9GGTmGEVrhrGyxtzu241l+KM5QfuHMqORJrgF1YjP5zoAyKgTrCwLh4NQ1B7zg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=tOCc3t6S; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=tOCc3t6S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4d0Tnn4Krtz2xS9
	for <linux-erofs@lists.ozlabs.org>; Mon,  3 Nov 2025 22:27:09 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C6CE60010;
	Mon,  3 Nov 2025 11:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC19C4CEE7;
	Mon,  3 Nov 2025 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762169227;
	bh=lhzfkd31EG7n+Ixv/igI3+Gf703FGmQM7qRQJFJp0Qw=;
	h=From:Subject:Date:To:Cc:From;
	b=tOCc3t6STGGHOu4PLoLSVcx2ZERkZuOWSvzibGMT41ZGBRpIxlVE2zM1wLM+azWtH
	 CXXQGIJgbXlc4pcoRZtrzPJBiRn2hNf2/PbT/iNXFU2YIyvK0O7lN6n7fqiQQYTO2r
	 S56nbKvJ4HDD/uhFYpS26gFpe/IhaVKOKNlTiWp0aqWh4hwlqba2gsW6PZDF6KkHdI
	 E+oJviYEkXUIXAHGonrWTVUJv1hwTKl6B8YFLz0kRGg15k9tggVBLQa7N3uhapM5Nc
	 viKpN5F642JfzfFux44DBO5hMf/JMg3KDrCcXbNBHWJEt2O66oU42LbKV3hFGWzv9A
	 wqaRHQ0v5Nj0Q==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/16] credentials guards: the easy cases
Date: Mon, 03 Nov 2025 12:26:48 +0100
Message-Id: <20251103-work-creds-guards-simple-v1-0-a3e156839e7f@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAHiRCGkC/x3MywqDMBCF4VeRWXdsklLBvkrpIiZjHEyjzNALi
 O/e2NXhW5x/AyVhUrg1Gwi9WXkpFfbUQJh8SYQcq8EZd7XWXPCzyIxBKCqml5c6ys81E3a2p9E
 5Y6JzUO+r0Mjff/r+qB68Eg7iS5iO4CKcuKDP+TyTFMrYtbZvjzLs+w9xb521mAAAAA==
X-Change-ID: 20251103-work-creds-guards-simple-619ef2200d22
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-nfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-96507
X-Developer-Signature: v=1; a=openpgp-sha256; l=1846; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lhzfkd31EG7n+Ixv/igI3+Gf703FGmQM7qRQJFJp0Qw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRyTGznOJ82MaJ8XWnoh3/NO3lLb6h8yImtPLv/+h1jC
 e5mxnVzO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby8TrDP6sCI8VCs9D/G65P
 bPwsuGZ70B29nREygeYBau+6rjhq8jL8r3xlPHfHIidL93WWJ/7kuJ6X7QrbtfGkzHO7T3IHEh6
 85QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

This converts all users of override_creds() to rely on credentials
guards. Leave all those that do the prepare_creds() + modify creds +
override_creds() dance alone for now. Some of them qualify for their own
variant.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
Christian Brauner (16):
      cred: add {scoped_}with_creds() guards
      aio: use credential guards
      backing-file: use credential guards for reads
      backing-file: use credential guards for writes
      backing-file: use credential guards for splice read
      backing-file: use credential guards for splice write
      backing-file: use credential guards for mmap
      binfmt_misc: use credential guards
      erofs: use credential guards
      nfs: use credential guards in nfs_local_call_read()
      nfs: use credential guards in nfs_local_call_write()
      nfs: use credential guards in nfs_idmap_get_key()
      smb: use credential guards in cifs_get_spnego_key()
      act: use credential guards in acct_write_process()
      cgroup: use credential guards in cgroup_attach_permissions()
      net/dns_resolver: use credential guards in dns_query()

 fs/aio.c                     |   6 +-
 fs/backing-file.c            | 147 ++++++++++++++++++++++---------------------
 fs/binfmt_misc.c             |   7 +--
 fs/erofs/fileio.c            |   6 +-
 fs/nfs/localio.c             |  59 +++++++++--------
 fs/nfs/nfs4idmap.c           |   7 +--
 fs/smb/client/cifs_spnego.c  |   6 +-
 include/linux/cred.h         |  12 ++--
 kernel/acct.c                |   6 +-
 kernel/cgroup/cgroup.c       |  10 ++-
 net/dns_resolver/dns_query.c |   6 +-
 11 files changed, 133 insertions(+), 139 deletions(-)
---
base-commit: fea79c89ff947a69a55fed5ce86a70840e6d719c
change-id: 20251103-work-creds-guards-simple-619ef2200d22


