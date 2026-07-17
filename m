Return-Path: <linux-erofs+bounces-3932-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EECBC44507
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Jul 2026 08:28:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1jjG44d6z3by2;
	Fri, 17 Jul 2026 18:28:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784276898;
	cv=none; b=GtTBwf/kWORVwBsEv3FpomFgN+AkfvIA14iCaDMT9tl56WkwER2ug7/Ny51qGBX1tanToQR4cvfmt6/9+vAvjDDukTldYvsyCbS8Z1OpWDvTlYZ0ATDJqQ0sKAjgzRIF+WGI7ORRp5NRhTmfwtCl676ARxn4QHmQTAWGNnMgIVUj6YPqwL/bU0HbfFD6RDK4jccZRn9hTsypxg4MdsrO7OPZjSRoi3gsXWgB6veSaf8t71DoTAa8169Q/9jYB9tXvLfk1+fO6TcdECmp/LH+rajBirM7k8xCFPg1Mr92kfi69ns8lj0ZwSZYZoMUxJBdbsb1Y0nhJ9R9JzBmu7yowg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784276898; c=relaxed/relaxed;
	bh=gg2p8ch1DMmROYcsLY+IZC3iNc6EQCfFEq5F4T0NAfI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lD0fiT3iN2RneeEcBi/kzQXzdxTFvvCLG67ZGSz4WhuwNP2sV52EbHP97jy2guU6Ygsb9BTlUhraYnnZTw0cLz8Vee9fPszpH63AAlN6RRRII2y31wplZA0UGN5nYS8vnzmFuotls5DroBuAaqJkEj3tyguVBkhWR3RLcUNjbatmK+zY/tucw5lWQu9OuY6/6iOWLjd6SvZ6JRmSbI84xCfb3oosJmXmHPEDt2VwqX+PVeWXC4LKD004yvwfzNzTzH+oV3g/rcI0k7VnF14STg2g0Obj61DYWq2LyBKZZdskB83NnywYUH+c5eiP1Fj62xM8SY5XNwAE3hlqwbnc6A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FlRFsv2f; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QYhZoyji; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FlRFsv2f;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QYhZoyji;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1jjF2zClz3bxR
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 18:28:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784276891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gg2p8ch1DMmROYcsLY+IZC3iNc6EQCfFEq5F4T0NAfI=;
	b=FlRFsv2fxz12wo9UI5kG2GayFIFQsSWJOwuFPjZ7aSdfsjlaCx1EIqbQHltYVfUwBFdvWO
	9+YZS3IAa+PNBLgyd+fDlg2RBGmF/3wwPj9PFPF3Z77DIUhVP3fC+NcvTy8cYe0v/yOYzH
	BbYMTJxeWYw+adkqQNifBclvB6vpBvo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784276892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gg2p8ch1DMmROYcsLY+IZC3iNc6EQCfFEq5F4T0NAfI=;
	b=QYhZoyjiPaedRinRXGVi9l/tWwgUCKUcDghp87dGkcbuDC/IYoAxFK/DQlNqQkeV1x/3ra
	EoFZ+N9H3stO/9TKyTjcQMZ13NnYXB4Keap2rmF3SoaKhjxWOtVz+V7fl0us6yALUY1ymD
	DUM6m8m0bnLfr9DqSsVfB+lwXqZMlyY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-g3m0lyqOMLm-sTvtvFWwiA-1; Fri,
 17 Jul 2026 04:28:08 -0400
X-MC-Unique: g3m0lyqOMLm-sTvtvFWwiA-1
X-Mimecast-MFC-AGG-ID: g3m0lyqOMLm-sTvtvFWwiA_1784276887
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2FB018009EA;
	Fri, 17 Jul 2026 08:28:06 +0000 (UTC)
Received: from localhost (unknown [10.44.33.219])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFE6E180056E;
	Fri, 17 Jul 2026 08:28:05 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-erofs@lists.ozlabs.org,  cyphar@cyphar.com,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] erofs: accept source file descriptor via fsconfig
In-Reply-To: <a3ee4538-6273-4d25-90d0-8dbaac092a38@linux.alibaba.com> (Gao
	Xiang's message of "Fri, 17 Jul 2026 11:42:39 +0800")
References: <20260714154917.489993-1-gscrivan@redhat.com>
	<a3ee4538-6273-4d25-90d0-8dbaac092a38@linux.alibaba.com>
Date: Fri, 17 Jul 2026 10:28:04 +0200
Message-ID: <87cxwm2f6z.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: fZPDrrxt5IZNVNKU-eEvsn9ptyXtOt_pDdVnILGOe5E_1784276887
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Gao Xiang <hsiangkao@linux.alibaba.com> writes:

> Hi Giuseppe,
>
> On 2026/7/14 23:48, Giuseppe Scrivano wrote:
>> Allow userspace to pass an already-opened file descriptor as the mount
>> source instead of a path string.  This is useful for tools that already
>> hold an fd to the image, such as composefs reusing an existing erofs
>> backing file.
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>
> Use the current erofs-utils testsuite, the following tests seems skipped incorrectly.
>
> [Error 22] Invalid argument
> SKIP: erofs/008
> [Error 22] Invalid argument
> SKIP: erofs/009
> [Error 22] Invalid argument
> SKIP: erofs/010
> [Error 22] Invalid argument
> SKIP: erofs/011
>
> [Error 22] Invalid argument
> SKIP: erofs/017
> [Error 22] Invalid argument
> SKIP: erofs/018
>
> And the kernel message shows:
> [  116.477816] erofs: source is unsupported
> ...
>
> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b experimental-tests
> $ sudo make check
>
> Thanks,
> Gao Xiang

it seems to be caused by the different error returned by erofs_fc_get_tree.

Would you be fine if I amend this on top of v3?

Thanks,
Giuseppe



diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index d7baf9f34dc0..829ae530d7ca 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -791,17 +791,22 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 static int erofs_fc_get_tree(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
-	struct file *file = sbi->dif0.file;
+	int ret;
 
-	if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) || !file) {
-		int ret;
+	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && sbi->dif0.file) {
+		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode) ||
+		    !sbi->dif0.file->f_mapping->a_ops->read_folio) {
+			errorfc(fc, "source is unsupported");
+			return -EINVAL;
+		}
+		return get_tree_nodev(fc, erofs_fc_fill_super);
+	}
 
-		ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
-			IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
-				GET_TREE_BDEV_QUIET_LOOKUP : 0);
-		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ||
-		    ret != -ENOTBLK)
-			return ret;
+	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
+		IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
+			GET_TREE_BDEV_QUIET_LOOKUP : 0);
+	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && ret == -ENOTBLK) {
+		struct file *file;
 
 		if (!fc->source)
 			return invalf(fc, "No source specified");
@@ -809,13 +814,12 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 		if (IS_ERR(file))
 			return PTR_ERR(file);
 		sbi->dif0.file = file;
+
+		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
+		    sbi->dif0.file->f_mapping->a_ops->read_folio)
+			return get_tree_nodev(fc, erofs_fc_fill_super);
 	}
-	if (!S_ISREG(file_inode(file)->i_mode) ||
-	    !file->f_mapping->a_ops->read_folio) {
-		errorfc(fc, "source is unsupported");
-		return -EINVAL;
-	}
-	return get_tree_nodev(fc, erofs_fc_fill_super);
+	return ret;
 }
 
 static int erofs_fc_reconfigure(struct fs_context *fc)


