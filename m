Return-Path: <SRS0=AxDc=XO=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FE2C3A5A6
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Sep 2019 12:44:50 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E867217D6
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Sep 2019 12:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sirena.org.uk header.i=@sirena.org.uk header.b="kPTsS/OR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E867217D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46YxPq3KyTzF3nR
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Sep 2019 22:44:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=sirena.co.uk
 (client-ip=172.104.155.198; helo=heliosphere.sirena.org.uk;
 envelope-from=broonie@sirena.co.uk; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=sirena.org.uk header.i=@sirena.org.uk
 header.b="kPTsS/OR"; dkim-atps=neutral
X-Greylist: delayed 1605 seconds by postgrey-1.36 at bilbo;
 Thu, 19 Sep 2019 22:44:36 AEST
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk
 [172.104.155.198])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest
 SHA256) (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46YxPc2bXfzF3Cl
 for <linux-erofs@lists.ozlabs.org>; Thu, 19 Sep 2019 22:44:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=npxzgMYuz7Lmn3LK2CAeoMDd5OUlrKZbXfDUSAVwL5A=; b=kPTsS/ORZ4BMR1uIXzcMkstaQ
 y+dVdTUFMhHfGXc3SGM7YRhgO8z5wGffm/eTeuCQyd3N/t9yDJQSxvNGxAYnLMvsGs7JVEPymX2yq
 hWTg5fgSMGZRqxXjWGyPObx33aOtzwfhTNy8cFyN+C0YDDE9EMhAgdMKJGCfaPjHIl9bQ=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net
 ([82.37.168.47] helo=ypsilon.sirena.org.uk)
 by heliosphere.sirena.org.uk with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <broonie@sirena.co.uk>)
 id 1iAvNU-0002SP-UB; Thu, 19 Sep 2019 12:17:40 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
 id 0F4D52742939; Thu, 19 Sep 2019 13:17:39 +0100 (BST)
Date: Thu, 19 Sep 2019 13:17:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: erofs -next tree inclusion request
Message-ID: <20190919121739.GG3642@sirena.co.uk>
References: <20190919120110.GA48697@architecture4>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <20190919120110.GA48697@architecture4>
X-Cookie: I'll be Grateful when they're Dead.
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2019 at 08:01:10PM +0800, Gao Xiang wrote:

> Could you kindly help add the erofs -next tree to linux-next?

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev

> This can test all erofs patches with the latest linux-next tree
> and make erofs better...

That seems like a good idea however since we're in the merge window and=20
the only things that should be being added to -next right now are fixes
I'll hold off on doing this myself.  Stephen will be back on the 30th
(just after merge window closes), I'm sure he'll be happy to add the
tree but in case this gets lost in all the mail from the time he's been
travelling you might want to remind him after that.

If you have a separate fixes branch I'd be happy to add that right now.

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2DceMACgkQJNaLcl1U
h9BUKAf+Jen0knGB2FZlvH24tHoPHbsAK0LhctKiAhTdj4BYGgSV/K1VjmZxb+lb
6Hyoh0cyemAu638LeDosBqq4gl6w2j/I4QhWPrVy/m6cJhnrJTYbXbRrL2ok29Uv
04BE/HSweGvNY3JKDsh3ownlkz4UCmY/uslUUp+ngKtmnGrxfdWRWDqnSJ6/aG7k
cr82gP+z8cgEBly0RTELrXEQWRGOI/LiFyJMKd3gSBIdmOJsiwzWDrI7snd2GxW8
bLDNM5BFIj4uyFnC8RMLiMKnAElZ6EPeRQqaG5yzmb47s32FvhVkuZvsBtx8jjL4
poSBO66Ogg227m5ZenWQSz2vrcnCaA==
=/DQ/
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
