Return-Path: <linux-erofs+bounces-4088-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC2FC55179
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 11:49:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDFMf6jlrz30F0;
	Mon, 03 Aug 2026 21:49:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=37.120.164.117
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785757774;
	cv=none; b=bDJZgeM9eJA1VjCco+Hba7AxFDuZQUcxSa3hMY2Sx3ALBovS2az+FhitI20vA33Sx9dRZUq/JW4s5WEN0I/tj6sI86fqZ+JK4WSeh/WcyVqqxzl3wdyG5XU86ve9PcBoKauavhRdNg/E3t6zekwsD89CF7XPeUwcI3pQ7rOZXCjVbqSUJl4AzMl5+xzijtBLWlekHtSfKtSYgCcRh2MoEFzMdLwqGApVMQQfsnTbvxRPmglVYV+mRsGuAzONH+hJVAcfHOfSkv+MxZOMA3HH1tviurNL9IwBTCDadDxUfcv5/AfEq9NhrjqsCV6IwomLnB8f6uidrLUQuw/Jd8FA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785757774; c=relaxed/relaxed;
	bh=Pio5xJUkxxEeiUj08aKQdpONfEq7woNed7bDi0Jr+No=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ob8+tuPwV8j57pH6vACDGALU2+WdO61FGAXxikzVkmtQ0QKh+X9/YxlGVcl8vbNkZiGXYW/kWKPUtSKEJlihE12jjiCfHBrx8j+0cledJ5ZsLP7QBNNKk5gdnWna2N5zVvsamMRuY08vi5iRVBpHFkxSqmxszjzK2PaLjRhtefveFKjCRHQqbEk29LQPW9SvhFI9zSHlkHqUnlfpZV0qbrgFQIxnga9d8PqOh5S6mHIOhlx8WpC+iO0WOboo9qSqc7gQgVCp+Ve4zIhz7jWHSA4eao3EyY9N1UXfRmFCdxxuFAk1wnhc7InW6gFGANRYuy8egMYSuQioFvQ0GmVidw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de; dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=vk6/w84h; dkim-atps=neutral; spf=pass (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org) smtp.mailfrom=piware.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=piware.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=piware.de header.i=@piware.de header.a=rsa-sha256 header.s=2025 header.b=vk6/w84h;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=piware.de (client-ip=37.120.164.117; helo=mail.piware.de; envelope-from=martin@piware.de; receiver=lists.ozlabs.org)
Received: from mail.piware.de (mail.piware.de [37.120.164.117])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDFMb1zG3z30Dq
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 21:49:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=piware.de; s=2025;
	t=1785757763; bh=6ptqNUC1PUmdSnHBU9umuAPZF93QJdJN80umKCveU4M=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=vk6/w84hNtaTxpqYX9wzl6Lcf414TWxq6ZREa7ePFLQLW+T/nc+jKCyOYenaunQ6I
	 r2fvusNuv21QhGRWEYQCKcGoknl+z/GGRp/7FsZO8O5SoEWqwq50n+JAtJPt/6E/fQ
	 SDBgjTWgnFm9OmzXAKf/OEaCJk3wWSgES5Et0GowS9gTfcSBh1oW2bk05C8NNuTfGJ
	 rk08d1IlfixE8H4sGa97EjI+nAsRAPxE5Ria0x+uFezXwcfAgWQnbhMq6tS/n1B8B0
	 xDAhxPhJzKJ2SvlsRKyzgeNBNVohoxJQqi8ZM8LB5Q+UwAOCRmJ/uFVUSwwPuF4UVv
	 TK/sZt0RwnRCw==
Received: from piware.de (localhost [127.0.0.1])
	by mail.piware.de (Postfix) with ESMTP id D3500FF866;
	Mon, 03 Aug 2026 13:49:23 +0200 (CEST)
Date: Mon, 3 Aug 2026 13:49:05 +0200
From: Martin Pitt <martin@piware.de>
To: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
Subject: Re: [PATCH] erofs-utils: mkfs: emit an inode's xattrs in a canonical
 order
Message-ID: <anCAMSZK9ow3eGQD@piware.de>
References: <ampZ6MVV1nN3YzQ_@piware.de>
 <am9FM_v9vAAzlR5H@XiangdeMacBook-Pro.local>
 <am9GZFlgLYn9HFci@XiangdeMacBook-Pro.local>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <am9GZFlgLYn9HFci@XiangdeMacBook-Pro.local>

Hello Gao,

Gao Xiang [2026-08-02 21:30 +0800]:
> > Thanks for the patch!
> > 
> > I wonder if the following diff works too (but untested):
> > 
> > Since I'd like to unify comp_shared_xattritem, if yes, could you resend
> > a new version (or if some bug happens) as this so I could merge this.
> > 
> 
> Sorry... It should be 

That's a nice idea, thanks!

> diff --git a/lib/xattr.c b/lib/xattr.c
> index a9486e4..6a8775b 100644
> --- a/lib/xattr.c
> +++ b/lib/xattr.c
> @@ -400,17 +400,44 @@ static struct erofs_xattritem *erofs_get_selabel_xattr(struct erofs_sb_info *sbi
>  	return NULL;
>  }
>  
> +static int erofs_comp_xattritem(const void *a, const void *b)
> +{
> [...]
> +	ret = memcmp(ia->kvbuf, ib->kvbuf, min(la, lb));
> +	if (ret != 0)
> +		return ret;
> +	return cmpsgn(la, lb);

This actually fixes the already existing sorting on main, too: The previous
`la > lb` never returned -1, so the sorting was half-broken.

> +	 * Keep each inode's xattrs ordered by name.  listxattr(2) makes no
> +	 * promise about the order it reports, and tmpfs varies it from inode
> +	 * to inode, so appending in listing order would emit the same set of
> +	 * xattrs differently from run to run and make images unreproducible.
> +	 */
> +	list_for_each_entry(pos, hlist, list)
> +		if (erofs_comp_xattritem(item, pos->item) < 0)

The items need &, otherwise it reinterprets the first 8 bytes of struct
erofs_xattritem, and you get bogus results. I fixed that.

There is a plot twist: Last week, when I investigated that and wrote the
reproducer, I was still on Fedora 44's 7.1.4 kernel, and the reproducer
reliably failed. Now I updated to 7.1.5, and it passes. This is probably the
effect of https://lkml.iu.edu/2602.2/00479.html and/or
https://lkml.org/lkml/2026/2/27/1141 , but it might explain why you may not
have seen the result. Funny timing! In other words, with recent kernels
tmpfs now reports the xattrs in insertion order instead of random.

But it still differs between running on *different* file systems, so the
justification stands, just the reproducer changed. I changed it to accept a set
of directories, defaulting to /tmp (which is usually tmpfs on modern distros)
and /var/tmp (which ought to be disk-backed, btrfs in my case). With the fix,
the erofs image comes out identical in both cases, while it differed between
backing file systems even on 7.1.5 (just that *within* the tmpfs runs it is
stable now). I also updated it to set 10 xattrs instead of 3, for more
confidence.

master (running against mkfs.erofs in $PATH, i.e. usr/bin/):

| ❱❱❱ ./xattr-order-reproducer.sh
| mkfs: mkfs.erofs
| 
| directory filesystem image sha256     listxattr order
| /tmp      tmpfs      52fae7f85e2a81fb weight mount_point mm aa_long_attribute_name growfs gpt_type_uuid zz verity gpt_label roothash
| /tmp      tmpfs      c55b5a4f737722f9 growfs aa_long_attribute_name mount_point weight gpt_label verity mm gpt_type_uuid roothash zz
| /tmp      tmpfs      f28ade3709861f8f mount_point mm growfs zz gpt_label aa_long_attribute_name roothash weight gpt_type_uuid verity
| /tmp      tmpfs      c5958ec278a8ab40 aa_long_attribute_name gpt_type_uuid growfs mm weight gpt_label roothash zz mount_point verity
| /var/tmp  btrfs      b4c0e159a27297f1 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
| /var/tmp  btrfs      b4c0e159a27297f1 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
| /var/tmp  btrfs      b4c0e159a27297f1 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
| /var/tmp  btrfs      b4c0e159a27297f1 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
|
| 8 identical trees: 5 distinct listxattr order(s), 5 distinct image(s)
| FAIL: mkfs.erofs output depends on listxattr(2) order


this fix, in the built tree:

| ❱❱❱ ./xattr-order-reproducer.sh mkfs/mkfs.erofs
| mkfs: mkfs/mkfs.erofs
| 
| directory filesystem image sha256     listxattr order
| /tmp      tmpfs      3dc0a62cd704a430 gpt_label aa_long_attribute_name zz mm weight growfs verity gpt_type_uuid mount_point roothash
| /tmp      tmpfs      3dc0a62cd704a430 verity aa_long_attribute_name growfs mount_point mm gpt_label roothash gpt_type_uuid zz weight
| /tmp      tmpfs      3dc0a62cd704a430 zz weight verity gpt_type_uuid roothash mount_point aa_long_attribute_name growfs mm gpt_label
| /tmp      tmpfs      3dc0a62cd704a430 mount_point roothash weight verity aa_long_attribute_name zz growfs mm gpt_label gpt_type_uuid
| /var/tmp  btrfs      3dc0a62cd704a430 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
| /var/tmp  btrfs      3dc0a62cd704a430 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
| /var/tmp  btrfs      3dc0a62cd704a430 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
| /var/tmp  btrfs      3dc0a62cd704a430 mount_point gpt_label roothash mm aa_long_attribute_name growfs gpt_type_uuid weight verity zz
|
| 8 identical trees: 5 distinct listxattr order(s), 1 distinct image(s)
| PASS: output is independent of listxattr(2) order

I paste the updated reproducer here. (Still AI-slop-y, sorry -- this is
throwaway code, and I spent my time on cleaning up the actual patch)

I'll post a PATCH v2 now. I feel the urge to set "Co-Authored-By: you", as you
did the refactoring. Shall I do that? That would then require your S-o-B I
think? I added a Suggested-By: for now.

Thanks,

Martin


#!/bin/sh
# Reproducer: mkfs.erofs output depends on listxattr(2) order.
#
# mkfs.erofs stores an inode's extended attributes in the order listxattr(2)
# reports them. That order is not specified, and filesystems disagree about it:
# tmpfs reports the order the attributes were set in (and on some kernels a
# random order per inode), while ext4 and btrfs report their own on-disk order.
# So building the very same tree can produce different images.
#
# Every run below writes identical content and sets the same xattrs on the root
# inode in the same order; only the staging directory differs. That is what
# systemd-repart does when it builds a DDI: it stages each partition in a fresh
# mkdtemp() directory and sets its user.validatefs.* xattrs there before calling
# mkfs.erofs.
#
# It sets ten attributes where repart sets three, because with only three a
# broken comparison can still come out consistent by chance and pass this test.
#
# The staging directories default to /tmp and /var/tmp, which by convention are a
# tmpfs and a disk-backed filesystem. Pass other directories to compare a
# different pair.
#
# Usage: ./xattr-order-reproducer.sh [path-to-mkfs.erofs] [runs-per-dir] [dir...]
#
# Exit status: 0 output is independent of listxattr order, 1 it is not,
# 77 prerequisites missing (autotools "skipped" convention).

set -eu

MKFS=${1:-mkfs.erofs}
RUNS=${2:-4}
if [ $# -gt 2 ]; then
	shift 2
	DIRS=$*
else
	DIRS="/tmp /var/tmp"
fi

# -x first: command -v does not look up a bare relative path such as mkfs/mkfs.erofs.
[ -x "$MKFS" ] || command -v "$MKFS" >/dev/null 2>&1 || { echo "cannot run $MKFS"; exit 77; }
command -v setfattr >/dev/null 2>&1 || { echo "need setfattr from the attr package"; exit 77; }
# getfattr sorts its output, so it cannot show the order listxattr(2) reported.
command -v python3 >/dev/null 2>&1 || { echo "need python3 to read the listxattr order"; exit 77; }

# The first three are what repart sets; the rest vary in length and share prefixes,
# so a comparison that is subtly wrong cannot order them correctly by accident.
ATTRS="gpt_label=root-x86-64
	gpt_type_uuid=2c7357ed-ebd2-46d9-aec1-23d437ec2bf5
	mount_point=/
	roothash=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
	verity=yes
	growfs=no
	weight=1000
	mm=short
	zz=short
	aa_long_attribute_name=padding"

CLEAN=
trap 'rm -rf $CLEAN' EXIT

RESULTS=$(mktemp -d "${TMPDIR:-/tmp}/erofs-xattr-order.XXXXXX")
CLEAN=$RESULTS
: > "$RESULTS/images"
: > "$RESULTS/orders"

echo "mkfs: $MKFS"
echo
printf '%-9s %-10s %-16s %s\n' directory filesystem 'image sha256' 'listxattr order'

for dir in $DIRS; do
	[ -d "$dir" ] || { echo "$dir does not exist"; exit 77; }
	work=$(mktemp -d "$dir/erofs-xattr-order.XXXXXX")
	CLEAN="$CLEAN $work"

	i=1
	while [ "$i" -le "$RUNS" ]; do
		src=$work/src$i
		mkdir -p "$src/dir"
		echo payload > "$src/dir/file"

		# Always set in this order; listxattr(2) need not report it back this way.
		for kv in $ATTRS; do
			setfattr -n "user.validatefs.${kv%%=*}" -v "${kv#*=}" "$src"
		done

		order=$(python3 -c \
			'import os, sys; print(*(n.rsplit(".", 1)[-1] for n in os.listxattr(sys.argv[1])))' \
			"$src")

		# -T and -U pin the timestamp and the filesystem UUID, so the xattr order
		# is the only thing that can differ between runs.
		SOURCE_DATE_EPOCH=1739577600 "$MKFS" --quiet -T1739577600 \
			-U 5230d7cf-f2ce-43ed-9ae2-39e7e2fe48ca "$src.img" "$src"

		sha=$(sha256sum < "$src.img" | cut -d' ' -f1)
		echo "$sha" >> "$RESULTS/images"
		echo "$order" >> "$RESULTS/orders"
		printf '%-9s %-10s %-16s %s\n' \
			"$dir" "$(stat -f -c %T "$src")" "$(echo "$sha" | cut -c1-16)" "$order"
		i=$((i + 1))
	done
done

echo
distinct=$(sort -u "$RESULTS/images" | wc -l)
orders=$(sort -u "$RESULTS/orders" | wc -l)
echo "$(wc -l < "$RESULTS/images") identical trees: $orders distinct listxattr order(s), $distinct distinct image(s)"

if [ "$distinct" -ne 1 ]; then
	echo "FAIL: mkfs.erofs output depends on listxattr(2) order"
	exit 1
fi

if [ "$orders" -eq 1 ]; then
	echo "PASS, but inconclusive: every directory reported the same order."
	echo "Pass directories on filesystems that disagree, e.g. $0 $MKFS $RUNS /tmp \$HOME"
else
	echo "PASS: output is independent of listxattr(2) order"
fi

