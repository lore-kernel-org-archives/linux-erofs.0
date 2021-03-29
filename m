Return-Path: <SRS0=P42h=I3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76C9C433E1
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Mar 2021 01:23:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A64456193A
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Mar 2021 01:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A64456193A
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4F7vwg1HV2z301k
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Mar 2021 12:23:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1616981011;
	bh=lbdPCd1M7K4gCTK9b66cSm+R762Vik52PQj05uWhct0=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=dc/su5f8xNefa0lDZ9FEazR5oX91Wkx3Vjp7AW+NwWeKGRvC6WRdOizvnr2XcsgYv
	 Vb/jZ2xl5uUb+WH2rxL0lhO+DFGGCRETj5thI0o2gp5m7OGk0LAnruN/EXgDbn8e0t
	 7muWixQEAgiAkGRy89yZQF+bwKFrS5ZOLbUhBX3KOH8w9Yc7Ea0YufIpYPfGXKyiWC
	 4gk1CnC/nq8rCRoTbUx+xUDry0KI7YdRe5LCpFqkExWt6oN5p6OviDaTpaC+I9V1AN
	 fqX8mJMnr+qnJPbRXLLZETybvszBFZc7h0NM77mJWsLg19zwWu4FermqIJGl6cjupB
	 YaoJz+oiNJ7qw==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.66.147; helo=sonic317-21.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=jEmpxTLy; dkim-atps=neutral
Received: from sonic317-21.consmr.mail.gq1.yahoo.com
 (sonic317-21.consmr.mail.gq1.yahoo.com [98.137.66.147])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4F7vwc14NQz2yyk
 for <linux-erofs@lists.ozlabs.org>; Mon, 29 Mar 2021 12:23:26 +1100 (AEDT)
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1616981002; bh=SnNF7gcUk5Chy54qmwZjHB+GeTr+H0G5EsPcePFYf3C=;
 h=X-Sonic-MF:From:To:Subject:Date:From:Subject;
 b=YSFjXFq4w1XuQA9zPZViNh1lC/xHhRFZHwTnX1HhSsvRB0Rxqt2TjQtbBtpbZ+6/PgMCG1iae3SHD7pYblZ3Ouw67MtAHPiIv2ShJxmMOfzveqVbdiW1GR8HJyYxEqOrjV+uBmpN2fAPRrNpof2ufKg2PTsf0PbBIWWf19QkX3MOhUzdXl1RZKj742XlWsap3je//MI+jjPxcSvZOo09l6rTUiZy/2EwamorNr1wt3/fhsssimWHUMkuuplLC1R3MPMXxUD2uA+ygavZM2W4DwS+E+x8YpaIrsJ9vxCjIjGxN+hYHZbSERkvHeGr8lFHlI8APr9wkPdBHlFQsdWNoQ==
X-YMail-OSG: 61mBMcgVM1nWyj.5k5Q3kdOAMtWvaqVJF.S3ihvYQHWrqZvC1dSr5q8CzqGhHx6
 c37rsaUJv9eDROuujfCtclGxF4Yj1T94PK1ToINonOe_tLqroyfnkHOsyGfR8KdF09cQpZJ9nEHW
 UyOxRhLFzyR2nTrK3C2LYFYk0RdZnZMdQbYsWGMGYQK0zSFJDo8B7dUjN_Vk4udkA9wb6xXnGgSw
 7vizCmznFbDq_wDGF4S8iVuH6N5cFSRbFgHnN1Abo.T0xWUNPu7B4ps06jSt_QrS2TdzT2pL6O5i
 yZsQKj5lRFhyOgYnUphQFqjcy1o21QKMXZqjC5sbWZ5Cc8VL4jy0iVoou8mrtyDm2Ds_R6bPa6.u
 VbxjgPTlIUlHVT.ZOgR59KZsIut_PLkH.Jz0c1bhisf8WpNT.amPT_ArDgEVXvUIE5hVPpcfUPjh
 0aX1crP9.WQvzMHBmKSwbdY0FW82XhROp4GGPoutc8O04XDb9sJxOhF0AtjYBNXgMOrMNG5x4VT8
 IdUoVLMnXXAz4983t3cqypLWdwF0_H5AZi9NX4nAIujROJ.b9epgfaE0q27GpYKrPJpZ_kXgDY_M
 hOFCSo6dwKznOc1SPvxTCWy3rL1ZfTHo8HJ3jQvA9x6RGrBPJKPViqZ2ADA0q6DLe4klSf43YS0z
 cF6IaM98UMW_t16kCUVMycxuiXjtz6A6xYVxeQwIwkrnWP0qJ_C2tFZMj9v98SRaNMgp9uvMT5Nn
 Pw_w3VVZvp5R15jiZw8U51NP4DAJv0UvOFPuJYpHAb75BE5ww5pVMa_rvrt5TpjlvELvmHfy1yvb
 ZNF0LegodSkIHjwhdj2ktYsH1Sq6oOqbios93CuSFlN6zh5RwTtPj8Hy9DehDINBXz188v842U4.
 vc2KNHLNNTDMzXtGKAzZQ1H15WeRNj0n6zsmc6zn16moyKj30IUIMzc2Okv0BYzTQmJ..Tq37Q4l
 umrIcHOm6wCSEu3U4cFn9aHyZ9y4goHAswKnSCpG_Uod8MQ1RjvbTVp477BB2n2.e64HfPopDJbr
 N8L2RAVtNzIo0QvPp0dQt2zMSZkfkVrIwT2.26z7GAVgJ2hZPxVvb6SB.U.SDyz98Vb7qYPc6xwq
 nTYgNUEh.I.5zcfIQu.bKX7omMr8yRZ7iG4Guh6MT.DyPeYHsk.MFDWtmZfvuoSfNZuCVVb_xDQM
 GTPJOr.gqVZYpCMWNT6tn.KhJnhxt07K4zQ88xSt75fJjTg2kqOJmgQriASMg9Q4j6nBfIpkbU6z
 96L_I2ysrNcPqQaUmIJJTosowWUOzhCQTA8h69UZBm248ZSkhz1etQJRba5hgqbuqTkLF5pQMFW6
 euyofpBuYtxFozPbwn64ONGX_rR0BFnLM255E2grgoXqZyKMIMhMhzLr1N67kT4MD9AUrWmyKxxh
 OaagX8jmNCXDPbU6o8LtZJlPhLxGoNe6w1W7_53S96DhCcqmZR8R5WgfQkLqhXVn3EUFEteTtnNw
 3sIuoS16TwECAQq4AbB3N2Ycy45NU4UXf4KHE3YHaChUS6ppDANU_H8KZ7IkVgHk7Yyqm_adeYvQ
 q5RonTiVSVtLS_RJpoUowxd4cPM7vCGNb0Ln2FyBtC96jdhV0gUNqxiBKEUHfL9KtL.ngOKgkEEh
 X0dufgo.nrO0tqruNCb15sUErJ5IsKj5QqRqxwNMrjVwlAHNe8M22hMpbrPv1e9gI5v_OZXfBcAi
 XnrtKZhuqoyOgDURzWuGIO_pBjDgHN0NoehFJ7cYYl48zFt.WL3nnty9Qa.yUbRjo4mko.2s7mjZ
 sDnzZmisiSTJQWKURSeb79NYj7w8Z6eCKMJwEWVm0MTYmBOUxtJ3csKTCyjykyZwAJQLmvlS3kkJ
 K0mChj9wzoNv8AS9E.5Au7zQ9mWskIPYf9qkah627i.idV9lWbMZUmzQslvlGINtalrs8k6Ya6Vn
 whd7zWiSFbna9LBRUAumVSmqWg.u.CZIfnIoqItdbTh2DpJeW3iWRKnroIXAT6ZnXCp1YSLVIqm.
 0GR.4aacFKEDkw6quNGxUwTawWGDuXHUHTQZp2FAf9F.NhhbV1viy3y_TDzPb76sU0irPrSvAQ5C
 6Kx9eOFkQXfQHcn190uo0f64M5eTndahyFtXFTgH6Xm2os9b37_sEX5_MXVj5AwpxXnGkqowq5py
 J4KYMoNF9Cdq.U8QPlois5i7KUhyWhkrDR3QfQr4_6.f86LxNyDuFz7GLxSw8jfVsAplHCP7PNm.
 YX6u0epj8EIOnQRIqOXUa7LPLqpyYaZnFbZyN8chZW38r0j0jvn.GthQM08KOWSMGhElImILFukJ
 M7ZDLbWf6Mn8Sq4se7D8whCjdDwSJk.XC35eP.z6GyiI4UZXFZI3YsIhajR5OohmxhGAWDzY_3yW
 aM5qRo9v5NpAVsY8w54oPZqeBuCKqeXf.YOwuGiiYRATPCjGacrpcpJlMhOL6FpoVzSn5rrg.Mpx
 _WCpfU9Ey4dMCdhg_Ntnm2WRO8km7jphr_uf.Gm.I69JVf_c9nQ2pfV5WRNiC.qpzjjsPnCk4Mgk
 1.w0K15IBqk7kokS7pKU7qMIIThq2iMtvOINv0P41mzBcMrEzMmVKw06y22WnDJukjTyo.guAnZL
 jqO51OUjf8kuotueCxQGam26PYIE7iXJaigjPmyKY2X7vfVl3Nz5BCddGhVAS2Cr3f4qevkeDrl7
 WsyFb.5UASLVsca1hVA--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic317.consmr.mail.gq1.yahoo.com with HTTP; Mon, 29 Mar 2021 01:23:22 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP
 Server) with ESMTPA ID 3d9d64f8790c67205a0f6cb47abdabe6; 
 Mon, 29 Mar 2021 01:23:20 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
 Chao Yu <chao@kernel.org>
Subject: [PATCH v2 1/4] erofs: introduce erofs_sb_has_xxx() helpers
Date: Mon, 29 Mar 2021 09:23:05 +0800
Message-Id: <20210329012308.28743-2-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210329012308.28743-1-hsiangkao@aol.com>
References: <20210329012308.28743-1-hsiangkao@aol.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@redhat.com>

Introduce erofs_sb_has_xxx() to make long checks short, especially
for later big pcluster & LZMA features.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/decompressor.c | 3 +--
 fs/erofs/internal.h     | 9 +++++++++
 fs/erofs/super.c        | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 34e73ff76f89..80e8871aef71 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -124,8 +124,7 @@ static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out)
 	support_0padding = false;
 
 	/* decompression inplace is only safe when 0padding is enabled */
-	if (EROFS_SB(rq->sb)->feature_incompat &
-	    EROFS_FEATURE_INCOMPAT_LZ4_0PADDING) {
+	if (erofs_sb_has_lz4_0padding(EROFS_SB(rq->sb))) {
 		support_0padding = true;
 
 		while (!src[inputmargin & ~PAGE_MASK])
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 30e63b73a675..d29fc0c56032 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -218,6 +218,15 @@ static inline erofs_off_t iloc(struct erofs_sb_info *sbi, erofs_nid_t nid)
 	return blknr_to_addr(sbi->meta_blkaddr) + (nid << sbi->islotbits);
 }
 
+#define EROFS_FEATURE_FUNCS(name, compat, feature) \
+static inline bool erofs_sb_has_##name(struct erofs_sb_info *sbi) \
+{ \
+	return sbi->feature_##compat & EROFS_FEATURE_##feature; \
+}
+
+EROFS_FEATURE_FUNCS(lz4_0padding, incompat, INCOMPAT_LZ4_0PADDING)
+EROFS_FEATURE_FUNCS(sb_chksum, compat, COMPAT_SB_CHKSUM)
+
 /* atomic flag definitions */
 #define EROFS_I_EA_INITED_BIT	0
 #define EROFS_I_Z_INITED_BIT	1
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0445d09b6331..991b99eaf22a 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -149,7 +149,7 @@ static int erofs_read_superblock(struct super_block *sb)
 	}
 
 	sbi->feature_compat = le32_to_cpu(dsb->feature_compat);
-	if (sbi->feature_compat & EROFS_FEATURE_COMPAT_SB_CHKSUM) {
+	if (erofs_sb_has_sb_chksum(sbi)) {
 		ret = erofs_superblock_csum_verify(sb, data);
 		if (ret)
 			goto out;
-- 
2.20.1

