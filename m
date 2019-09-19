Return-Path: <SRS0=AxDc=XO=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F11C3A5A6
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Sep 2019 14:40:08 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 351EB2067B
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Sep 2019 14:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="VHCKrKe8";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="LvX3/OFc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 351EB2067B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Yzyq2T72zF4yZ
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Sep 2019 00:40:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1568904003;
	bh=WJ+QCViY7kk6f8CnO1D15lIEY30blefAAea69W1yVnQ=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=VHCKrKe8osAKKMJAgEFgmmbvo2oHt7hdSgzkaE/Sudic6Pn72uY+OsKOeF7ASLSBc
	 O6qqduDuhvoxSpWJ32KMm4PBV9L61bx6jM2btyXfirfq2YrRqxzi60SpUtGa/+H/o7
	 YQO7CzocW3cx4mLycP1m9oj6JrigPA15Zr7gk02aw3YwIqk73jPdhOLMCSso3m8cTM
	 r5jCCVfff4HZ6iOBFSH5b907RWejXkye3qb6xxvvPRGiuYJ49MRtSJvmF+ZpDPIz0v
	 cCdOXEk6jJLUdIB3XRlm3cl7mgajbpH3pKSm3VzA04cpaqEnqK2Opk6//AueKtM1Vf
	 70sEGRrlLFGyA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=98.137.69.57; helo=sonic316-33.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="LvX3/OFc"; 
 dkim-atps=neutral
Received: from sonic316-33.consmr.mail.gq1.yahoo.com
 (sonic316-33.consmr.mail.gq1.yahoo.com [98.137.69.57])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46YzyS5wl5zF4Nd
 for <linux-erofs@lists.ozlabs.org>; Fri, 20 Sep 2019 00:39:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1568903977; bh=qvpy+ovGR6FPZ93+sFuofMU46weY7iNTSQ/65dQcwh8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=LvX3/OFcaWf4dhDrxzcfuhMtlF0Qo+blYbSSSVTPlPTy7J3jKHx+k53vQtNS/a/8/6Sd0cff/tLL924P14sKy88NrNdEp44uM8urzvCaDzS0kth+eUMTLslcjUaXRZNAvj8lb0/2H7wGLSV+yreldr9HVq33MDKC0vm+BhbjezZNlp0cH/1UyXGkUANrwUwdpXQ1zV/QuZVm3cb2uQPVwRFZE3HMqReJ4/eBhzCezdr3Kp0NhMBvjGjRuVqfP+gz/SqRrU2ce2z3zYYdfkQFNSok8/i+jbUazzuodo0hJuaZsNc8GJU6qsFyAQ6cGvGPfLPPQChsIgImNob41KZgaA==
X-YMail-OSG: N_6BpMEVRDvd.miR6A7lED5GPdAEx7ojsA--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic316.consmr.mail.gq1.yahoo.com with HTTP; Thu, 19 Sep 2019 14:39:37 +0000
Received: by smtp405.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 50f03e35e4d03b35efeb76c0a57e355e; 
 Thu, 19 Sep 2019 14:37:35 +0000 (UTC)
Date: Thu, 19 Sep 2019 22:37:22 +0800
To: Mark Brown <broonie@kernel.org>
Subject: Re: erofs -next tree inclusion request
Message-ID: <20190919143722.GA5363@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190919120110.GA48697@architecture4>
 <20190919121739.GG3642@sirena.co.uk>
 <20190919122328.GA82662@architecture4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919122328.GA82662@architecture4>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Mailer: WebService/1.1.14303 hermes Apache-HttpAsyncClient/4.1.4
 (Java/1.8.0_181)
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-erofs@lists.ozlabs.org,
 Miao Xie <miaoxie@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
 linux-next@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Mark,

On Thu, Sep 19, 2019 at 08:23:28PM +0800, Gao Xiang wrote:
> Hi Mark,
> 
> On Thu, Sep 19, 2019 at 01:17:39PM +0100, Mark Brown wrote:
> > On Thu, Sep 19, 2019 at 08:01:10PM +0800, Gao Xiang wrote:
> > 
> > > Could you kindly help add the erofs -next tree to linux-next?
> > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev
> > 
> > > This can test all erofs patches with the latest linux-next tree
> > > and make erofs better...
> > 
> > That seems like a good idea however since we're in the merge window and 
> > the only things that should be being added to -next right now are fixes
> > I'll hold off on doing this myself.  Stephen will be back on the 30th
> > (just after merge window closes), I'm sure he'll be happy to add the
> > tree but in case this gets lost in all the mail from the time he's been
> > travelling you might want to remind him after that.
> > 
> > If you have a separate fixes branch I'd be happy to add that right now.
> 
> Thanks for the -fixes information and detailed reminder (I didn't notice
> that, sorry...)
> 
> I will do a -fix only branch later for urgent and trivial fixes.

The fixes only -fixes branch is
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git fixes

Thanks for taking time on this stuff...

Thanks,
Gao Xiang

> 
> For -next, it's okay to wait for Stephen of course :) ...
> 
> Thanks,
> Gao Xiang
> 
