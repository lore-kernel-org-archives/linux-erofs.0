Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4646B606D80C
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Nov 2026 08:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJY3GxeA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNNmd16R3z2xKx;
	Mon, 09 Nov 2026 19:51:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794214273;
	cv=none; b=LU06euCROwTuGgtnAqHHPdtIGXlN43hqtUT+H9/jqSv16vn3poR2Z6MXzQ0CdHyt/+bKr2C+gpqBit6RPzMHKk6qtdesGP+4XD57IBuY9ROGHYoZdKv7fgW3AafxMJpcLo8M32hvpxXa/fKlFBQHRQzW+qdCmpEU84U5SBWSYM0HY/4qMIW5CvjLg+PpH0Spl5jNzw1CR+4vAhfzBpdk+R87jxTUA86yaOnJTHbV+jdBXwmSumDOYNHAf5LZ0Y0mAvrmNJ6Kh++8eArf2k/UP5yA4QeFoyrUBQDPtxwp8k+ynQEcxLOLJ0xVj30m9D3x8o3yBKDHnh3+93sD9XmVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794214273; c=relaxed/relaxed;
	bh=eNKFrA+ko6rnOdXYtG1zGE/rwkNRk9n2i7kmMjkEuac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icVpPsi5t5zEQ1CT2UhtpNEGdth+H9dpACNrXPTRHtYUvKvpi3ThZB42p/BZePw49EuZmTI07ZarXTD+n624jHCf9Awr1c1l9aaMaO/XC0DN6k6nLQdxdbQiY6/OUJS2FUzP6YRkIZt1vuMnqT7SrnAK0e6uPrmrdQU784SKAFvyyOKvFCzlmJHXW0H1XbvUHoPEVmzscnp4YfHrMMkwaxiGy6BuXDD7vxDH9mR95cAxGuZf7+53BJIlTO3ZB2mf1bLf+nT2FjG9lk0x3PfGH6B/tKrwT3M5e2f36XhShDFlwVuoHSlpNZomRfzxWlqU7rr1lrNrrVeas4SqAUChEA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJY3GxeA; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJY3GxeA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNNmb1MRLz2xBK
	for <linux-erofs@lists.ozlabs.org>; Mon, 09 Nov 2026 19:51:11 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 593884033F;
	Mon,  9 Nov 2026 08:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557571F0089F;
	Mon,  9 Nov 2026 08:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794214268;
	bh=eNKFrA+ko6rnOdXYtG1zGE/rwkNRk9n2i7kmMjkEuac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WJY3GxeAcJggiVpAoJt6ujfrnoqGY9ow88cE5WXahhhBXlIfZ5VfJfdSW3Q1quQuO
	 7LXWfliZW83Ui8DDoWq1xTWrHVa5gsLP5kF71krTm7aiM9lg+URNrxPe7Jg7/1seFt
	 BE3zwnX6QqPU8sdWtkrf75NO4JPrzX2PRVVfGNGt/CY0MoDd50+lCfkhvkI2wYHpNV
	 vrCaqRnpK/HWOAPh8vzF5SArLoBBtsjeEgr0AePmhVKEmf1hAWHjx0brxjPNrrrQOj
	 /IdWI3LR0VITqiVjE22dgeoFJuXtyV7cxGyq3oeQmL2qy2/gtoGr0Oca0DnBWB+UMP
	 ShpulYZVM0BwA==
Date: Mon, 9 Nov 2026 09:51:01 +0100
From: Gao Xiang <xiang@kernel.org>
To: Wenyuan Xu <sereno.xu@deepseek.com>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 2/2] erofs-utils: mkfs: fix origin xattrs when merging
 layers
Message-ID: <avGJdXYTfqiRDPRP@MacBookPro.fritz.box>
Mail-Followup-To: Wenyuan Xu <sereno.xu@deepseek.com>, xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
References: <20261107042703.3392000-1-sereno.xu@deepseek.com>
 <20261107042703.3392000-2-sereno.xu@deepseek.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261107042703.3392000-2-sereno.xu@deepseek.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Wenyuan,

On Sat, Nov 07, 2026 at 04:27:03AM +0000, Wenyuan Xu wrote:
> Only supplement empty trusted.overlay.origin xattrs on whiteout parents
> during incremental builds or multi-source rebuilds. Ordinary local
> directory builds and single-source rebuilds should not synthesize this
> merge marker.
> 
> Preserve any existing origin xattr instead of appending a duplicate
> empty entry.
> 
> Fixes: 8680f3cf94ef ("erofs-utils: mkfs: enable incremental builds for local files")
> Assisted-by: LLM
> Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>

Can the following diff resolve the issue as well? (untested)
If possible, could you ask LLM to refine this way?

Thanks,
Gao Xiang


diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 19e38fb..1eeb78f 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -269,6 +269,7 @@ struct erofs_inode {
 	char idata_type;
 	bool lazy_tailblock;
 	bool opaque;
+	bool origin;
 	/* OVL: non-merge dir that may contain whiteout entries */
 	bool whiteouts;
 	bool dot_omitted;
diff --git a/lib/tar.c b/lib/tar.c
index 72d867c..2f3e189 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -1080,7 +1080,6 @@ out_eot:
 		 * needed if the tar tree is used soon, thus we have no chance
 		 * to generate it from xattrs.  No impact to mergefs.
 		 */
-		d->inode->opaque = true;
 		ret = erofs_set_opaque_xattr(d->inode);
 		goto out;
 	} else if (th->typeflag == '1') {	/* hard link cases */
diff --git a/lib/xattr.c b/lib/xattr.c
index c670b12..59281d3 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -452,7 +452,7 @@ static bool erofs_is_skipped_xattr(const char *key)
 }
 
 static int read_xattrs_from_file(struct erofs_sb_info *sbi, const char *path,
-				 mode_t mode, struct list_head *ixattrs)
+				 mode_t mode, struct erofs_inode *inode)
 {
 	ssize_t kllen = erofs_sys_llistxattr(path, NULL, 0);
 	char *keylst, *key, *klend;
@@ -507,10 +507,16 @@ static int read_xattrs_from_file(struct erofs_sb_info *sbi, const char *path,
 			goto err;
 		}
 
-		if (ixattrs) {
-			ret = erofs_inode_xattr_add(ixattrs, item);
+		if (inode) {
+			ret = erofs_inode_xattr_add(&inode->i_xattrs, item);
 			if (ret < 0)
 				goto err;
+			if (!strcmp(key, OVL_XATTR_OPAQUE))
+				inode->opaque = S_ISDIR(inode->i_mode);
+			if (!strcmp(key, OVL_XATTR_ORIGIN)) {
+				inode->origin = true;
+				inode->whiteouts |= S_ISDIR(inode->i_mode);
+			}
 		}
 	}
 	free(keylst);
@@ -520,8 +526,8 @@ out:
 	item = erofs_get_selabel_xattr(sbi, path, mode);
 	if (IS_ERR(item))
 		return PTR_ERR(item);
-	if (item && ixattrs)
-		ret = erofs_inode_xattr_add(ixattrs, item);
+	if (item && inode)
+		ret = erofs_inode_xattr_add(&inode->i_xattrs, item);
 	return ret;
 
 err:
@@ -595,12 +601,18 @@ static void erofs_removexattr(struct erofs_inode *inode, const char *key)
 
 int erofs_set_opaque_xattr(struct erofs_inode *inode)
 {
+	if (inode->opaque)
+		return 0;
+	inode->opaque = true;
 	return erofs_vfs_setxattr(inode, OVL_XATTR_OPAQUE, "y", 1);
 }
 
 void erofs_clear_opaque_xattr(struct erofs_inode *inode)
 {
+	if (!inode->opaque)
+		return;
 	erofs_removexattr(inode, OVL_XATTR_OPAQUE);
+	inode->opaque = false;
 }
 
 bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
@@ -610,6 +622,9 @@ bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
 
 int erofs_set_origin_xattr(struct erofs_inode *inode)
 {
+	if (inode->origin)
+		return 0;
+	inode->origin = true;
 	return erofs_vfs_setxattr(inode, OVL_XATTR_ORIGIN, NULL, 0);
 }
 
@@ -659,10 +674,9 @@ static int erofs_droid_xattr_set_caps(struct erofs_inode *inode)
 int erofs_scan_file_xattrs(struct erofs_inode *inode)
 {
 	int ret;
-	struct list_head *ixattrs = &inode->i_xattrs;
 
 	ret = read_xattrs_from_file(inode->sbi, inode->i_srcpath,
-				    inode->i_mode, ixattrs);
+				    inode->i_mode, inode);
 	if (ret < 0)
 		return ret;
 
@@ -721,11 +735,9 @@ int erofs_read_xattrs_from_disk(struct erofs_inode *inode)
 				goto out;
 			}
 			DBG_BUGON(ret != size);
-		} else if (S_ISDIR(inode->i_mode) &&
-			   !strcmp(key, OVL_XATTR_ORIGIN)) {
-			ret = 0;
-			inode->whiteouts = true;
-			continue;
+		} else if (!strcmp(key, OVL_XATTR_ORIGIN)) {
+			inode->origin = true;
+			inode->whiteouts |= S_ISDIR(inode->i_mode);
 		}
 
 		ret = erofs_vfs_setxattr(inode, key, value, size);
-- 
2.50.1 (Apple Git-155)


> ---
>  include/erofs/importer.h |   1 +
>  lib/inode.c              |   2 +-
>  lib/xattr.c              |   2 +
>  mkfs/main.c              |   2 +
>  tests/Makefile.am        |   3 +
>  tests/erofs/033          | 122 +++++++++++++++++++++++++++++++++++++++
>  tests/erofs/033.out      |   2 +
>  7 files changed, 133 insertions(+), 1 deletion(-)
>  create mode 100755 tests/erofs/033
>  create mode 100644 tests/erofs/033.out
> 
> diff --git a/include/erofs/importer.h b/include/erofs/importer.h
> index 5141965..b8dcaf8 100644
> --- a/include/erofs/importer.h
> +++ b/include/erofs/importer.h
> @@ -54,6 +54,7 @@ struct erofs_importer_params {
>  	bool dirdata_in_metazone;
>  	bool hard_dereference;
>  	bool ovlfs_strip;
> +	bool ovlfs_merge;		/* build involves overlayfs-style merging */
>  	bool dot_omitted;
>  	bool no_xattrs;			/* don't store extended attributes */
>  	bool no_zcompact;
> diff --git a/lib/inode.c b/lib/inode.c
> index da29b5a..185bcfc 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -2134,7 +2134,7 @@ static int erofs_mkfs_handle_inode(const struct erofs_mkfs_btctx *ctx,
>  	/* strip all unnecessary overlayfs xattrs when ovlfs_strip is enabled */
>  	if (params->ovlfs_strip)
>  		erofs_clear_opaque_xattr(inode);
> -	else if (inode->whiteouts)
> +	else if (params->ovlfs_merge && inode->whiteouts)
>  		erofs_set_origin_xattr(inode);
>  
>  	if (!S_ISDIR(inode->i_mode)) {
> diff --git a/lib/xattr.c b/lib/xattr.c
> index a0ac76f..01a8547 100644
> --- a/lib/xattr.c
> +++ b/lib/xattr.c
> @@ -619,6 +619,8 @@ bool erofs_get_opaque_from_disk(struct erofs_inode *inode)
>  
>  int erofs_set_origin_xattr(struct erofs_inode *inode)
>  {
> +	if (erofs_inode_has_xattr(inode, OVL_XATTR_ORIGIN))
> +		return 0;
>  	return erofs_vfs_setxattr(inode, OVL_XATTR_ORIGIN, NULL, 0);
>  }
>  
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 93123c1..06d868a 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -1899,6 +1899,8 @@ int main(int argc, char **argv)
>  	importer_params.source = cfg.c_src_path;
>  	importer_params.no_datainline = mkfs_no_datainline;
>  	importer_params.dot_omitted = mkfs_dot_omitted;
> +	importer_params.ovlfs_merge = incremental_mode ||
> +		(source_mode == EROFS_MKFS_SOURCE_REBUILD && rebuild_src_count > 1);
>  	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON &&
>  	    !mkfscfg.chunkbits && !mkfscfg.total_zcfgs) {
>  		erofs_err("Compression is not enabled.  Turn on chunk-based data deduplication instead.");
> diff --git a/tests/Makefile.am b/tests/Makefile.am
> index 363b93d..bfd1fc2 100644
> --- a/tests/Makefile.am
> +++ b/tests/Makefile.am
> @@ -135,6 +135,9 @@ TESTS += erofs/031
>  # 032 - check that the xattr layout does not depend on listxattr(2) order
>  TESTS += erofs/032
>  
> +# 033 - preserve existing origin and only add empty origin when merging
> +TESTS += erofs/033
> +
>  # NEW TEST CASE HERE
>  # TESTS += erofs/999
>  
> diff --git a/tests/erofs/033 b/tests/erofs/033
> new file mode 100755
> index 0000000..1da7bca
> --- /dev/null
> +++ b/tests/erofs/033
> @@ -0,0 +1,122 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0+
> +#
> +# Only supplement missing origin xattrs on whiteout parents when merging.
> +# Existing origin values must survive without duplicate xattr names.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS="/")
> +
> +. "${srcdir}/common/rc"
> +
> +cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +_require_root
> +_require_erofs
> +_require_xattr
> +command -v getfattr >/dev/null 2>&1 || _notrun "getfattr isn't installed"
> +
> +rm -f $seqres.full
> +
> +localdir=$tmp/$seq
> +mkdir -p "$localdir/source" "$localdir/base" || _fail "mkdir failed"
> +
> +# Probe capabilities as root alone does not guarantee CAP_MKNOD/SYS_ADMIN.
> +mknod "$localdir/probe" c 0 0 >> $seqres.full 2>&1 ||
> +	_notrun "cannot create whiteouts"
> +setfattr -n trusted.overlay.origin -v xxx "$localdir/source" \
> +	>> $seqres.full 2>&1 || _notrun "cannot set trusted xattrs"
> +getfattr -n trusted.overlay.origin --only-values "$localdir/source" \
> +	> "$localdir/probe-value" 2>> $seqres.full ||
> +	_notrun "cannot read trusted xattrs"
> +[ "$(cat "$localdir/probe-value")" = xxx ] ||
> +	_notrun "trusted xattrs are not visible"
> +setfattr -x trusted.overlay.origin "$localdir/source" \
> +	>> $seqres.full 2>&1 || _fail "cannot remove probe xattr"
> +
> +echo "QA output created by $seq"
> +
> +for state in absent empty value; do
> +	mkdir "$localdir/source/$state" || _fail "mkdir failed"
> +	mknod "$localdir/source/$state/whiteout" c 0 0 \
> +		>> $seqres.full 2>&1 || _fail "cannot create whiteout"
> +done
> +setfattr -n trusted.overlay.origin -v '' "$localdir/source/empty" \
> +	>> $seqres.full 2>&1 || _fail "cannot set empty origin"
> +setfattr -n trusted.overlay.origin -v xxx "$localdir/source/value" \
> +	>> $seqres.full 2>&1 || _fail "cannot set nonempty origin"
> +echo base > "$localdir/base/file"
> +
> +# Dumping all matching names also catches duplicate names: getxattr alone
> +# would retrieve the same first value for each occurrence of the name.
> +check_origin()
> +{
> +	getfattr --absolute-names -d -m '^trusted\.overlay\.origin$' \
> +		"$SCRATCH_MNT/$1" > "$localdir/attrs" 2>> $seqres.full ||
> +		_fail "cannot read $case_name/$1 xattrs"
> +	cat "$localdir/attrs" >> $seqres.full
> +	actual=$(sed -n '/^trusted\.overlay\.origin=/p' "$localdir/attrs")
> +	[ "$actual" = "$2" ] || _fail "unexpected origin in $case_name/$1"
> +	[ -c "$SCRATCH_MNT/$1/whiteout" ] ||
> +		_fail "whiteout lost in $case_name/$1"
> +}
> +
> +build_image()
> +{
> +	$MKFS_EROFS_PROG "$@" >> $seqres.full 2>&1 ||
> +		_fail "mkfs failed for $case_name"
> +}
> +
> +case_name=localdir
> +SCRATCH_DEV=$localdir/source.erofs
> +build_image "$SCRATCH_DEV" "$localdir/source"
> +_scratch_mount >> $seqres.full 2>&1
> +check_origin absent ''
> +check_origin empty 'trusted.overlay.origin=""'
> +check_origin value 'trusted.overlay.origin="xxx"'
> +_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
> +
> +case_name=single-source
> +SCRATCH_DEV=$localdir/single.erofs
> +build_image --clean=data "$SCRATCH_DEV" "$localdir/source.erofs"
> +_scratch_mount >> $seqres.full 2>&1
> +check_origin absent ''
> +check_origin value 'trusted.overlay.origin="xxx"'
> +_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
> +
> +case_name=base
> +build_image "$localdir/base.erofs" "$localdir/base"
> +
> +for case_name in multi-source incremental-localdir incremental-rebuild; do
> +	SCRATCH_DEV=$localdir/$case_name.erofs
> +	case $case_name in
> +	multi-source)
> +		build_image --clean=data "$SCRATCH_DEV" \
> +			"$localdir/base.erofs" "$localdir/source.erofs"
> +		;;
> +	incremental-*)
> +		cp "$localdir/base.erofs" "$SCRATCH_DEV" || _fail "copy failed"
> +		if [ "$case_name" = incremental-localdir ]; then
> +			source=$localdir/source
> +		else
> +			source=$localdir/source.erofs
> +		fi
> +		build_image --incremental=data "$SCRATCH_DEV" "$source"
> +		;;
> +	esac
> +	_scratch_mount >> $seqres.full 2>&1
> +	check_origin absent 'trusted.overlay.origin=""'
> +	check_origin empty 'trusted.overlay.origin=""'
> +	check_origin value 'trusted.overlay.origin="xxx"'
> +	[ "$(cat "$SCRATCH_MNT/file")" = base ] ||
> +		_fail "base file lost in $case_name"
> +	_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
> +done
> +
> +echo Silence is golden
> +status=0
> +exit 0
> diff --git a/tests/erofs/033.out b/tests/erofs/033.out
> new file mode 100644
> index 0000000..c5d2914
> --- /dev/null
> +++ b/tests/erofs/033.out
> @@ -0,0 +1,2 @@
> +QA output created by 033
> +Silence is golden
> -- 
> 2.43.0
> 
> 

