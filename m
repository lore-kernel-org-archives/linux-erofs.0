Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1970606A323
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 05:32:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQ8DH00Zlz2yKn;
	Thu, 12 Nov 2026 16:32:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.57
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794461566;
	cv=none; b=IKybBeeY6XYfIoh2vZn3eNrQIhsmGCXcqddkBtjsdxy8NEQkOsM4MbaJ/Su25cv6HEHNbPQgQZUkga8qM3bxZPjujDT2IBUdgt2TFJ7SgnX2kIPcAOm4vpGAhzIONtrML+a46yjkkS9Cer5NfxELN6f1AXOv0+y/G45VP5ATI7HZfazZ3hg0P/CFyE5ohtQ+7Lpp54n+/bCfX7jMabRUIVKkX43f6tPKufbPQe/TYkudBJ2vCBWaCN9crdgUJ1YldqRoXf90lHOxvUeur0b7wrpwFH7xUaCWmgOCuvDxCwIUtE2qWo+MQH1AFnFns3uHmrPeVUJoouKtsCOKOP2tnA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794461566; c=relaxed/relaxed;
	bh=wqPSUrj7Bt8DK8VNrE/ER9XXu71CmlCizLFS+zAMHoI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Nd0v5x9QAiEi1OeHhygYjoU+jwKK1WwMuB54kq7dnYJ/SkV+DRbcV1CEPu89rAbVdT04nJNqGsJJ7vpAlcZXsnoqp2qneOUNkaTIKtcTZuk+Felehfl+jAPAT89UzjOmELwq/WMSVYyG9jN2R+aqoOzlh+3k42BdoXVX5t2dCnV0DcSnnJBN1yMHFECKZ9RTXZxnY2+34nBvj5gTMdiQ4Bk/kvG9JjvUqEC7NQHT58uCy4WDpGa8FNxX83XJyGPJCV2RBgjvCtwt0Ojq8NKh/Jgx3+Qho9cU6WJpfEhPoJs7XB6HQ7bkDQ/zOSdQRp0ZvHfoCSz6UHXFGwhSzBgXow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.57; helo=out28-57.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.57; helo=out28-57.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-57.mail.aliyun.com (out28-57.mail.aliyun.com [115.124.28.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQ8DD1rJFz2y8F
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 16:32:41 +1100 (AEDT)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.0993831|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0963169-0.00895397-0.894729;FP=17073822583275324218|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037034138;MF=hudson@cyzhu.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.k0Hb9TS_1794461552;
Received: from smtpclient.apple(mailfrom:hudson@cyzhu.com fp:SMTPD_---.k0Hb9TS_1794461552 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 13:32:32 +0800
Content-Type: text/plain;
	charset=utf-8
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
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] docs: erofs: refine the on-disk overview
From: hudsonZhu <hudson@cyzhu.com>
In-Reply-To: <20261112021905.36269-1-xiang.gao@docker.com>
Date: Thu, 12 Nov 2026 13:32:22 +0800
Cc: linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78C49082-EE86-431E-A97E-20CEEF2FB352@cyzhu.com>
References: <20261112021905.36269-1-xiang.gao@docker.com>
To: Gao Xiang <xiang.gao@docker.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Xiang,

> Each inode can be located directly using the following formula:
>     inode offset =3D meta_blkaddr  block_size + 32  nid

Does this formula also apply to inodes stored in the metabox?

Thanks,
Chengyu

> 2026=E5=B9=B411=E6=9C=8812=E6=97=A5 10:19=EF=BC=8CGao Xiang =
<xiang.gao@docker.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The existing on-disk summary mainly describes inode and shared xattr
> metadata views, leaving the overall layout and design rationale =
unclear.
>=20
> Expand the summary and refine the terminology and wording while =
keeping
> the section a high-level overview.
>=20
> Assisted-by: chatgpt:gpt-6.1-sol
> Signed-off-by: Gao Xiang <xiang.gao@docker.com>
> ---
> Documentation/filesystems/erofs.rst | 100 ++++++++++++++++++++--------
> 1 file changed, 72 insertions(+), 28 deletions(-)
>=20
> diff --git a/Documentation/filesystems/erofs.rst =
b/Documentation/filesystems/erofs.rst
> index 02caf3b061fe..0633e69aa71e 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -171,13 +171,27 @@ Each mounted filesystem will have a directory in =
/sys/fs/erofs based on its
> device name (i.e., /sys/fs/erofs/sda).
> (see also Documentation/ABI/testing/sysfs-fs-erofs)
>=20
> -On-disk details
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +On-disk format
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This section provides a high-level overview.  For the latest complete =
on-disk
> +format specification, see:
> +
> +- https://erofs.docs.kernel.org/en/latest/ondisk/
>=20
> Summary
> -------
> -Different from other read-only file systems, an EROFS volume is =
designed
> -to be as simple as possible::
> +
> +EROFS keeps its on-disk format as simple as possible to minimize the =
need
> +for metadata consistency checks.
> +
> +The guiding principle is that malformed or deliberately crafted =
metadata
> +may describe a corrupt filesystem, but its effects should remain =
confined
> +to the data and metadata exposed to userspace: garbage filesystems =
return
> +garbage (meta)data to users, and nothing more.  Violating this rule =
is
> +unsafe and must be prevented by our on-disk design.
> +
> +::
>=20
>                                 |-> aligned with the block size
>    ____________________________________________________________
> @@ -185,15 +199,45 @@ to be as simple as possible::
>   |_|__|_|_____|__________|_____|______|__________|_____|______|
>   0 +1K
>=20
> -All data areas should be aligned with the block size, but metadata =
areas
> -may not. All metadata can be now observed in two different spaces =
(views):
> +Apart from the EROFS superblock, which starts at byte offset 1024, =
metadata
> +and data regions have no fixed locations or boundaries and may be =
interleaved
> +throughout the image.  As a result, inodes do not need to reside in a =
fixed
> +central table, allowing incremental builds, although the image =
creator may
> +still choose to group all inodes together.
> +
> +All data except inline data must be aligned to the filesystem block =
size
> +[#unencoded_data]_ to enable efficient block I/O, support memory =
mapping,
> +and avoid unnecessary data copies.  Metadata does not require block =
alignment.
> +
> +.. [#unencoded_data] Strictly speaking, data refers to unencoded =
data;
> +   encoded inodes are outside the scope of EROFS core metadata.
> +
> +EROFS core metadata consists only of the superblock, inodes, and =
directory
> +entries stored in directory inode data.  The physical locations of =
inode
> +data are recorded as block numbers to avoid block-alignment checks.
> +
> +Only a few superblock fields, including the root nid (see below), are =
needed
> +to parse the filesystem tree.  Most of the remaining fields provide =
filesystem
> +statistics reported to userspace and should not affect the core =
filesystem
> +logic.
> +
> +Encoded inodes, which contain encoded data such as compressed data =
(including
> +compressed directories), use a distinct inode "datalayout" number =
that allows
> +them to be identified or rejected when reading the inode metadata.  =
Support for
> +encoded layouts is optional and can be explicitly disabled at runtime =
if there
> +are security concerns about parsing compressed data in the kernel.
> +
> +There are two metadata views: one for inode metadata and one for =
shared
> +extended attributes.  Both can also be located in a special hidden =
inode
> +called "metabox", which provides a unified way to compress inode and =
xattr
> +metadata:
>=20
> - 1. Inode metadata space
> + 1. Inode metadata view
>=20
> -    Each valid inode should be aligned with an inode slot, which is a =
fixed
> -    value (32 bytes) and designed to be kept in line with compact =
inode size.
> +    Each valid inode is aligned to a 32-byte inode slot, matching the
> +    size of a compact inode.
>=20
> -    Each inode can be directly found with the following formula:
> +    Each inode can be located directly using the following formula:
>          inode offset =3D meta_blkaddr * block_size + 32 * nid
>=20
>     ::
> @@ -224,8 +268,8 @@ may not. All metadata can be now observed in two =
different spaces (views):
>                                             |-> aligned with 4B
>                                                         |-> aligned =
with 4B
>=20
> -    Inode could be 32 or 64 bytes, which can be distinguished from a =
common
> -    field which all inode versions have -- i_format::
> +    Inodes can be 32 or 64 bytes, distinguished by the i_format field =
common
> +    to both formats::
>=20
>         __________________               __________________
>        |     i_format     |             |     i_format     |
> @@ -236,29 +280,29 @@ may not. All metadata can be now observed in two =
different spaces (views):
>                                         |                  |
>                                         |__________________| 64 bytes
>=20
> -    Xattrs, extents, data inline are placed after the corresponding =
inode with
> -    proper alignment, and they could be optional for different data =
mappings.
> -    _currently_ total 5 data layouts are supported:
> +    Xattrs, extents, and inline data follow the corresponding inode =
with
> +    proper alignment.  Their presence depends on the inode's =
datalayout.
> +    Five data layouts are currently supported:
>=20
>     =3D=3D  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -     0  flat file data without data inline (no extent);
> -     1  fixed-sized output data compression (with non-compacted =
indexes);
> -     2  flat file data with tail packing data inline (no extent);
> -     3  fixed-sized output data compression (with compacted indexes, =
v5.3+);
> -     4  chunk-based file (v5.15+).
> +     0  Flat inode data without inline data (no extents);
> +     1  Encoded inode
> +     2  Flat inode data with inline tail data (no extents);
> +     3  Encoded inode (compact indexes)
> +     4  Chunk-based file (v5.15+).
>     =3D=3D  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> -    The size of the optional xattrs is indicated by i_xattr_count in =
inode
> -    header. Large xattrs or xattrs shared by many different files can =
be
> -    stored in shared xattrs metadata rather than inlined right after =
inode.
> +    The size of the optional xattrs is indicated by i_xattr_count in =
the inode
> +    header.  Large xattrs or xattrs shared by many files can be =
stored in
> +    shared xattr metadata rather than inlined immediately after the =
inode.
>=20
> - 2. Shared xattrs metadata space
> + 2. Shared xattrs metadata view
>=20
> -    Shared xattrs space is similar to the above inode space, started =
with
> -    a specific block indicated by xattr_blkaddr, organized one by one =
with
> -    proper align.
> +    The shared xattr metadata view is similar to the inode metadata =
view.
> +    It starts at the block indicated by xattr_blkaddr, with entries =
stored
> +    sequentially with proper alignment.
>=20
> -    Each share xattr can also be directly found by the following =
formula:
> +    Each shared xattr can be located directly using the following =
formula:
>          xattr offset =3D xattr_blkaddr * block_size + 4 * xattr_id
>=20
> ::
> --=20
> 2.54.0 (Apple Git-157)
>=20


