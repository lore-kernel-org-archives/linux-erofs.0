Return-Path: <SRS0=DQIy=FI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9996DC433FE
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Dec 2020 17:21:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECD1022AAB
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Dec 2020 17:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECD1022AAB
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cnfd723smzDrcZ
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 04:21:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607102491;
	bh=r2hUiqeeVN/0DzlTnttN4Uhlwi+5YUksyBJwHTXf/QU=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=H+Wdc3AR2Z5LP5toTvoXOtcfyhjg6b9Rv5FaHYZcDLlqqv1gzB/jpAU2kkR1oTjV3
	 pQnTRivk7khJmjfWy2v3J6/elWAezivSjDteeTfvxOU7Mlnt+F1KEWvG4SbttB9EWj
	 e/PYMSdaCORpBp7JtGTJ6nP4EcLKIt/Xi0qrH4/j8c6lxDOMYbXv7Pmuqd1+lR+wnE
	 NJMgIcgKXTGW4AoXV2/XQwyac8iH8AZbqu5OG7r+RVBKpARjcqoSF2qFEK2rqDZr7X
	 KlNk90sYfFQJt85zG29MUlc5IF3ZUaFSVWriMtgATOdVoj4XTgKyH+tr517aRczuGB
	 kk2vY2UuaMJ8g==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.65.83; helo=sonic313-20.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=hZEF3e2k; dkim-atps=neutral
Received: from sonic313-20.consmr.mail.gq1.yahoo.com
 (sonic313-20.consmr.mail.gq1.yahoo.com [98.137.65.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cnfcv0ctGzDrcN
 for <linux-erofs@lists.ozlabs.org>; Sat,  5 Dec 2020 04:21:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1607102474; bh=PnPmhkUjsnLKuXsyFZiM4dUXK2cWo8nDn13Y8WIUi2Y=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject;
 b=hZEF3e2kEAEpuPsLcSLf3tjJiWzpWEHfSj+uP6XU+5yKjtjeyM7rkPknfMZlm+j0uWh8Dq+9nohRKSAv3GSyG3YanVNSaKbECvnNRZPGv2vQQQwu/NGnr2JcVR6QicrCA7T7rpFgR61cYQwPip7rAcicBUHXU7/8TL5FhpWORv2U9jgHZqvIZEhGfXk6f4Cprv3NX/lOij0mqAVi+WdMh9d+p02jyI+5MuR/2gFND/ZoqWgEbxzrubWIbuI0IDREpeBuO0Q8KKvRsqq8WlXOHjCf6FS9+B8a23i+MsTvjToEy1fvlqBwV7qz1WWSVZeMS/e+hhrqC0YTFt/c/CuyYw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1607102474; bh=oi8hhJ+TfGSi3hjdyR3soGza4JcHgrjz8O5DDRTSFxF=;
 h=From:To:Subject:Date:From:Subject;
 b=CqD3I8o8XfP5DozOgF1fgun0ZZHL5vLXvNM3/kn6RcQG1qOjHA0Vz3SgpahjhPLDJGbTNcmXgjw8ELYARGyRhtqNBomPbqz4hTx+H4YV7L8vHhZE15kXHAvh2rbf50UgVwAPAd7vdudae6Jf+H+nKtA6fZtWy2EKpo5ZFnPAYUwn534tUZAMPOdSGn1UENkjtn3cvnNZONOFgpL4cG7hy81SuMWQkpuCIMJZrYa5JjdZRxnbPWye7Vq2xk4bXT1kYs9/IWQX3BSkpD5CE4aXaLRKs6tb8J27ncEev3NPthopPTUaMFYRypFOMlXycAuU4ncUFzgZ7doUP1zn0aDVow==
X-YMail-OSG: 8R3ewqUVM1n9kOMC_OCAWgIGoWgAEQo.Fc.I7Igd91dAK_0uw0ZOPCJdPwoCI0.
 xY2qOR1kLvr4i9GvXnItAaleiO_hZo.bjPdPyNyhd2jzk2RGt0eFFQqfijb2y8KKWQVSUitf0H1s
 eITZNVNqeuLLigXjUPN4nV54YWzZBjS87jRd9cmCuP8ycnUmphPq.55Z3LfSLO3YRXMNVcVyrPVP
 F_R6iHjb_a2HEhiMLUziYzh.iUVlOCbWmTYin5Pqt855CBrhvZTPZv.5MbylpE2LG5ZUVjdnC7E2
 T8G5cin95uBgL7XS9ZdQORN43KiyYffhcNfzUcAaz2PW_d7VvKmAhPisDhXohGXRcU9N09Pqeb8K
 Bcxasut6JSINLRbx3cP3LKVoyC2SzM1EH7tglVe.WTAwxNHrQnEc_4sCMtRULyHy2zq67bMlIgbf
 uNlywDR7o.1H2ypJGsxDcC53FNgJLNzhIwKOd0TY.zdisdq3JVBeNztLUQqkRDrOb90pE6zlSerW
 IVVd6BfUOqkdzSlA.2tK7c1s1rmiDwlfX3qeSE0JOAjTKL0RGr40FBJVkVPTdM1Wo5uCeQWbzFr9
 sf93ct4GLuK2ocKPfd9_32Nuint6i5gLcMtJ4AqfcA9ASL6QeUKBlITfeMTdi6ofWcuochyX4kgb
 Ccx0YniXBt78IAUFFNXHs7KZvhmpdwkn8bEjrcIQe3tao0hvXUV2Ofse_6JtP7WGmAfAE1vUccQA
 rUW8U4_9GCcRFrYj9h3s4dD7xv.xGf.lWVcMO.pDjWVA6v4MkypjYCsy2BS.fnRnesZhDVHCZ2PJ
 tk5pO_Tn7KGyoZXStzYCZ_SPbagpu7aVogtjaHDeSLqQvTRqfZ.3dFdzt18j6YxAdt5ifyuVcGyH
 3fbWJUNUoAppcdzlVHL89SjiEBN0XnmSj.NLrwG86508Td5J.8mNT39Fyd.1c6.oqKT1sBCYhvRe
 jwBPPwDkYLfk2iyiND1YhZ4LCKNf3LdHHLIEPVV.x9923Hr5brOSLkOifXkSjYVQITI_JoE7hm5I
 w1aNhapf2_5fklixn8xBcAqVPdtkBaMnKtBmz594cVo4ohk.z5p.8bDM_UgeaSdoHRgf7TK81hYg
 GP97Fjoi160dM3_RFUDXJ6_KMR8pof2sDGeZ55bj6bGrG4HkG46Y67kTZtEaHjKOs7vAQiqlLdJn
 pqVa2b0xl_iOGA7fghcXAVp6rzjf7m7KlCGo18A5PrvHMF_0D1ljF2qiQObUcFGKSyvo99a7gn_o
 kou0nl8FOl2Pk2MoGremQx_DXPyQQISupsL150lDnRsKF7h2yyOO3..4KTUaAjpt_J0ciPYz1VaB
 hnYJDP3RwCnpowxQJJhPv74h67_upmfdG6wiS15PNbVG_0GIdWbWaEqSyAMm1YOT_l_NH.Z09lcu
 3d6SrcR_84.MJdP5598MYBQtDtB5UY7x2HSLRcdOmRbcnZl_d4IUI.hSSSxUzCHvTpEqU2Foyy7d
 .SvhR6S56YlZkwvhMwJCLWutPBnENJs.CYCX5KffgAUtAr1XLbn3LUTFQ_7j8_FhX7N0Ie6X5YQU
 ITysBEUd0dHNQCM6nBVSkbacnOyy7im4Ldx3xtRaiHaoYr3vTlHuHBoL6sTkyEVGbkda_ZqQIfaD
 LRKqfXlokg2NG7IUGP.PeeZly6gOqm7s1pov652mIYol9y.OVJlUF3oA7Kec148eCqXIPVj.vSmN
 DZLuWPe6G6WGYAtA.M.SfRR8DAPyZq_fXCIu8a8Puf6M0ik7GEKQHSHO8YOwER7btzH4KNpRQM.v
 XAPUB7MuzOrTYHaXmYCc_KWmvmjM1dak9LPgArRNvC4wCFsR81.PFoxIMVojT9bnkxt69CETCcU5
 gdJqv61x2VXVVq87r1sCnMxAeAg04OzzWS6rRkIwsvx.5QRQGkVjn3gm9dPC7i2BbDqHG3vuxK_X
 R8MfnampOl.XvKBXg6NvUS7mA_Y5Sth99THTMeUbMGlkKzyPPbwAlJLtyx2lHnDN_dqzeoDz.3uD
 PQp8MrYU1XHvQGauJyFecMX3rkPEwD_8UrNJQHyUIqMEs4CruyUBn0RJ1pOu.dJLQv2d_Togflpi
 ..YQM3CXg.AlNWhXYuVUwsfuMIV_7JEPnHgT1x5CxSuSFkx9PpECHSLpMelNeJov0cA996O3YYrW
 W45s2eDmp0SAXj22_0_kuGDthXzALqytvuw_WNCy6dTVPpGVFtI5oN5kXRshaXjtM1lcwzyd349l
 .NdQ1AwcrL4Z9CP4GCh3wfaYeHElcVTE5XLDUUzlrlf6YBeHwx58bqkXKhb9ccgvtfs3TL1VuRD2
 uwnHItfw4iJIczieO0Z3goQ4C0DD8yjeFadTbX8y81WJBMKYTNlj49jW7oCcketsO8IdfK1vLa.4
 USEzo1w9_zHgge_5wKPeDAJQcTIEzjcImOkHM6bfAcFPoQX4av5FkzfDCS2ce.l_IZBgwJoEtLf7
 YFM1Ghfx8nfwIVOTNbKAepAzua6SYB6a9AIPqfwREXdHRH.TxzzWAJGbos3TZ6KrvuAZ.uxvrJyg
 y7SY.3LvTz9s2Jvgh62N3zR8-
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic313.consmr.mail.gq1.yahoo.com with HTTP; Fri, 4 Dec 2020 17:21:14 +0000
Received: by smtp423.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 08fdc92c5476471ec5c1d3f3f35296c7; 
 Fri, 04 Dec 2020 17:21:10 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: fix cross-device sub-mounts
Date: Sat,  5 Dec 2020 01:20:42 +0800
Message-Id: <20201204172042.24180-2-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20201204172042.24180-1-hsiangkao@aol.com>
References: <20201204172042.24180-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@redhat.com>

From: Gao Xiang <hsiangkao@aol.com>

Use device ID and inode number to identify hardlinks
rather than inode number only.

Fixes: a17497f0844a ("erofs-utils: introduce inode operations")
Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
 include/erofs/internal.h |  7 ++++++-
 lib/inode.c              | 18 ++++++++++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index bf13c166ba16..ac5b270329e2 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -112,7 +112,12 @@ EROFS_FEATURE_FUNCS(sb_chksum, compat, COMPAT_SB_CHKSUM)
 struct erofs_inode {
 	struct list_head i_hash, i_subdirs, i_xattrs;
 
-	unsigned int flags;
+	union {
+		/* (erofsfuse) runtime flags */
+		unsigned int flags;
+		/* (mkfs.erofs) device ID containing source file */
+		u32 dev;
+	};
 	unsigned int i_count;
 	struct erofs_inode *i_parent;
 
diff --git a/lib/inode.c b/lib/inode.c
index 1cf813daa396..cad94270e6bc 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -35,7 +35,7 @@ static unsigned char erofs_type_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFLNK >> S_SHIFT]  = EROFS_FT_SYMLINK,
 };
 
-#define NR_INODE_HASHTABLE	64
+#define NR_INODE_HASHTABLE	16384
 
 struct list_head inode_hashtable[NR_INODE_HASHTABLE];
 
@@ -54,14 +54,14 @@ static struct erofs_inode *erofs_igrab(struct erofs_inode *inode)
 }
 
 /* get the inode from the (source) inode # */
-struct erofs_inode *erofs_iget(ino_t ino)
+struct erofs_inode *erofs_iget(dev_t dev, ino_t ino)
 {
 	struct list_head *head =
-		&inode_hashtable[ino % NR_INODE_HASHTABLE];
+		&inode_hashtable[(ino ^ dev) % NR_INODE_HASHTABLE];
 	struct erofs_inode *inode;
 
 	list_for_each_entry(inode, head, i_hash)
-		if (inode->i_ino[1] == ino)
+		if (inode->i_ino[1] == ino && inode->dev == dev)
 			return erofs_igrab(inode);
 	return NULL;
 }
@@ -764,6 +764,7 @@ int erofs_fill_inode(struct erofs_inode *inode,
 	strncpy(inode->i_srcpath, path, sizeof(inode->i_srcpath) - 1);
 	inode->i_srcpath[sizeof(inode->i_srcpath) - 1] = '\0';
 
+	inode->dev = st->st_dev;
 	inode->i_ino[1] = st->st_ino;
 
 	if (erofs_should_use_inode_extended(inode)) {
@@ -778,7 +779,8 @@ int erofs_fill_inode(struct erofs_inode *inode,
 	}
 
 	list_add(&inode->i_hash,
-		 &inode_hashtable[st->st_ino % NR_INODE_HASHTABLE]);
+		 &inode_hashtable[(st->st_ino ^ st->st_dev) %
+				  NR_INODE_HASHTABLE]);
 	return 0;
 }
 
@@ -824,12 +826,12 @@ struct erofs_inode *erofs_iget_from_path(const char *path, bool is_src)
 		return ERR_PTR(-errno);
 
 	/*
-	 * lookup in hash table first, if it already exists we have a
-	 * hard-link, just return it. Also don't lookup for directories
+	 * lookup in hash table first, if it already exists we have
+	 * a hard-link, just return it. Don't lookup for directories
 	 * since hard-link directory isn't allowed.
 	 */
 	if (!S_ISDIR(st.st_mode)) {
-		inode = erofs_iget(st.st_ino);
+		inode = erofs_iget(st.st_dev, st.st_ino);
 		if (inode)
 			return inode;
 	}
-- 
2.24.0

