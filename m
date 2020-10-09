Return-Path: <SRS0=2U3h=DQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A66AC433E7
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Oct 2020 02:32:40 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C31221527
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Oct 2020 02:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="cr7t6hRn";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="sAjSB8vq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C31221527
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C6sYJ6QgrzDqWn
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Oct 2020 13:32:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602210756;
	bh=pmRRyRv70S7g+dNIrE2/1Gww4NgLpbh8PcyHyYWwCqE=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=cr7t6hRn9f1poFSzrovwEFVMJqh00qokCLwfwddB18YIOlbH9oqMQD1sAd16bROqk
	 hIx3bDyI5TO+ysHRrr/9che3nlDsbVr3CqAUIkwX0FOJ38enuVZJ92biFs/UA0kkFu
	 7btIFb9TjvOiSFf0qjcPfgP3CC2t+vpot3Ni125z7ritvsAgbf4u+iIkCMx36TamWD
	 vlBu11isELcoB0Gp5QgWbRaMqUKpqXMkQThmigecanTfOvb1tjZo74BCHkOUIed/JV
	 xKQ3a1h/y2doF4E3Dd4IrN8bP1pjO1fUBjv2r4LNF3ABYh9cDgwaSpG5GBOmLdXNHL
	 I8bWqJ3db5HIQ==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.69.84; helo=sonic314-21.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=sAjSB8vq; dkim-atps=neutral
Received: from sonic314-21.consmr.mail.gq1.yahoo.com
 (sonic314-21.consmr.mail.gq1.yahoo.com [98.137.69.84])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C6sY52GYFzDqQ8
 for <linux-erofs@lists.ozlabs.org>; Fri,  9 Oct 2020 13:32:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1602210737; bh=JrYjtV8ku/EDDXe5Mi85vszK0SX025BY5ZIWrV1c45Q=;
 h=Date:From:To:Subject:References:In-Reply-To:From:Subject;
 b=sAjSB8vqPQ59o4fyCOSk4V2SA/vKerb/1ZnRyPtMpY64zUT+d/3TuDJoU8z8UctlCGsy+JBkMoRvpIL3f6yBdAhiY9DuBzaQK2jA9OQB4iUMJ1W1pq/aN4rFDQCXP20llap331mW3ei7DRH/ionwrn9mQ6KdkEv5o2QUynE0m/eYpmtPFXDc8udb6C4wej+euQwZTiveKVgKu/KPQlogntcMBD6sl5/9VLMs3tPnRQdiCbRbDtGB3oCm+PLcmvSohxyqXJGkIlydDGVlxe5i5tgwbmGeU4V6D0z+m8z7EzNaiY2OKlg3GAHWtPPnlTeXX0TLOr41bcyLMqc09cRRAA==
X-YMail-OSG: CtrlBIMVM1lvrxMPT0ryU7hd_uYwxnM0UQtEqmmXX.siIwXhjV.tm9i3XIpVvxK
 4gR9wH1n1iILMMmv.pHw4CHqeOvuwOUeceMDufYKCDW9J7v8_ZXVpxsQ.hkv6RlAgn5W30P9KsFj
 f1Mm3MOCvk2tb8kVgX2APrPOH5HAVH.BXIHO0hPwYdqSg7kFsqU0seeLeLG5BK.KDxEtmKlKQVfJ
 52tu7qJ3YARaR8y14GieZL63r9FB4JkJ_SjYpDnVNVlXD0u.JHWMgzxr_mjwlVMfZchGs_WlgwcR
 8RezqM5OWe0wJZltqTDiCA6xD2PNrFKscb1oDm5h_WeiK9PPzih1NBBlS8GN8It2DRjhB9Vu.mGz
 t__hizEFtPIORhLC1TSMA8dQS3l0SP_95W2OEahRgejLucifYmm_VatzaRbBHqlzRPZrHJrcICwE
 zBP6qafiSNpo83Er.YsO7fSvwS4L8VDSNmQpWMwevUOIDQ1Y4Wx9cddAQR0Mfjnmv8ZksdMByiu_
 yRRHVDVdwpvBmYH6BJ5Sqi2oupqGIKTUrrNtJZtocnDipa5knucJ0Ar7RrrMFRHVgitbNJ4aJOfS
 nIf8JArDaO6.QrF82YB4yNCiGm_KlmgXW1qhZV8h9GBlVlL9cYyOXkM.t1V8PNliEzKpmC8SDC5O
 O9lN6vgd4D2bXYHcmpI3bH.iv2Ml9usH7RgIcIGBV5D.TDBNAwkVvAxlmNAPoTLLthgOz_Rchg9l
 x7QfiSdmYlJFWDt08_pO4EziStVk7blDZAsxZnTcNa7nQiHDSrGPmPgqcNZntqzmGxZjDKpaHxof
 pKeF1nnKiFZdfeu8XDRQC60WhBPZmL5BMlP_v5PTWMBylK2BVGVH08ROqgO14HEb9OygcKz7mpQJ
 uXnA8THBWw7mdSCVqsBx_FYUy1iJnK_dlGYclnaNLYyn3N0KX__i6LvQWwD5cKsLb8E4rVLChE6S
 Qz9p2LcHeos.B.nIlHFO6cspe5aa40ezpj9Y7eiVN.w.dq5nDp7CmKV9cvmOQX_YB_gWX_ZwXYAf
 f8HZfZbguop9KWqOBa_WBaydk0xTmHJ4spz4TizaqXRSX853rK2NyxqW3_dpZj6Bel6FQZt9Mc6p
 tJD7OpAQRR_rbAqHPD.sJ7K2MDjUWeQr32ZBlimXXdOizHtkfjXlUZ6n3PBVHz355OQkQePjlLKP
 WTBJsWI9RgygPqf.kjONhGZACt4qvsQMuq_isg2AbJZd07Uid258RDVffM9QnxfwgfeYfaozyvM.
 iOW8VAfMBOmwV7eAkvSAUw3iluxIbkWye9BuuYuef760u8pEJ5XuekbF1Hzpi7ywTXOybDRkWs5P
 8uEJxLqNrJxVKfivAGPVZRrvnPYyQ66a7AxXUKQ5dEe9LQimjuPlhZihDq8A5PqftCNyyMgGZXqx
 seMTmccAw6ebXwGHBfrpklqJeRIYmzE0r3espqMk01i6tFYzXcr4T8BvDqcPvX0abkdySVEcutCq
 M12Dw7XAqSCxE53qvZdkYdf2w44.y5NzJ.8ZKNpOqzbiABQ--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic314.consmr.mail.gq1.yahoo.com with HTTP; Fri, 9 Oct 2020 02:32:17 +0000
Received: by smtp415.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA
 ID 9dda53905ddd5c3249f23a887588986d; 
 Fri, 09 Oct 2020 02:32:13 +0000 (UTC)
Date: Fri, 9 Oct 2020 10:32:02 +0800
To: Li Guifu <bluce.lee@aliyun.com>, Li Guifu <bluce.liguifu@huawei.com>,
 linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v2] AOSP: erofs-utils: add fs_config support
Message-ID: <20201009023048.GA16011@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20200928213549.17580-1-hsiangkao@aol.com>
 <20200929051302.3324-1-hsiangkao@aol.com>
 <20201007150215.GA30128@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007150215.GA30128@hsiangkao-HP-ZHAN-66-Pro-G1>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16804
 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
 Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
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

On Wed, Oct 07, 2020 at 11:02:18PM +0800, Gao Xiang via Linux-erofs wrote:
> On Tue, Sep 29, 2020 at 01:13:02PM +0800, Gao Xiang wrote:
> > So that mkfs can directly generate images with fs_config.
> > All code for AOSP is wraped up with WITH_ANDROID macro.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> > ---
> > changes since v1:
> >  - fix compile issues on Android / Linux build;
> >  - tested with Android system booting;
> 
> Guifu, some feedback on this?
> I'd like to merge it for AOSP preparation.

I will merge this if still no response at the end of this
week. Since this main logic has already been used by other
Android vendors for months and I do need to go forward on
AOSP stuff.

Thanks,
Gao Xiang

> 
