Return-Path: <SRS0=CCRZ=WQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE0EC3A589
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Aug 2019 16:37:56 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6929622DD3
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Aug 2019 16:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="M9KS8kPG";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="B+zO8fhN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6929622DD3
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Cc0f1G3XzDrKh
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 02:37:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1566319074;
	bh=Idlia2WgXbbkqPYc5sXM0JQkkEYI2ZnhaCLZU6ndjRc=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=M9KS8kPGpV3tfiESywP5UT+O8R58DwYlqVXYJe4QYPt/7B2CSEaKDezzudL28cdUf
	 ryvecVgQLiiW/QwClxFYiA7EFfVDAxRaKpmDZzmHggZlVoHF7VYQz5EHi+0uANd4ez
	 LUZOOemx5iaN6S4BClZfhz3QnMNLwR5EOPsLfWLkHVLC5Sl8ax29ksGezeeO/RpPyV
	 bG+/+BF6ji/GxWB923ucU2M89TMDxg2o/fpsv4xUswqyWiEquKTB/24jkTDZxb3oUX
	 fG0CNn+GplGuP8XsnqdwjwgOicee6yONfeeD1a0BpiuSnCjDj1MS3utPdL1H6kkknN
	 URk6r+QqauE4g==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=77.238.178.146; helo=sonic308-18.consmr.mail.ir2.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="B+zO8fhN"; 
 dkim-atps=neutral
Received: from sonic308-18.consmr.mail.ir2.yahoo.com
 (sonic308-18.consmr.mail.ir2.yahoo.com [77.238.178.146])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46CbyD2JqQzDrNh
 for <linux-erofs@lists.ozlabs.org>; Wed, 21 Aug 2019 02:35:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1566318938; bh=o9vRKnpFEnLbPLxepx60AGesPRvtXbUJjyPA3Au598I=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
 b=B+zO8fhNU6IuuMsi6QgPfUMZ/MCqtCI4vBm6C+gJTG9qGcDiX/bevSJsT45fUOsO+ylnqmUXnn9IvG2KLw2cc+3+k6j9hN60VH7ty5JIhuZsec57dsZx2KwZFPCFkYheoybdEBVrUmRQHp9xkz4lXSHZQHNqymc1n0UDUD3X2hskXO0/icbkwWfqkB04U/rReKlug/JXJ5l3UjIvvKlC2ATFJnDJRb8h96ty2UyhQWhIHY4WUgiVX3y9CNZWvOaGsxqxVZqU6FqxmIsO6Sri1Iui6TnZJ0i4aqkJ4GWsK2GnbHa933Jh7JtzJouKyosSVkaznEwUQaYkc59Sy45Cgg==
X-YMail-OSG: JleghXsVM1mRsu3yw7aM5pR_OjB973vGgPy6yzz7abvVrTwQMouyTbVLsGIk44A
 NB_d3W7myS2YUPeQYV.1IKDLfOUHa5KCT_V0czZuup_YNFKJjR08N8Kd_n8jhtkQDbklaOQEXuVs
 r9BGoUlAdmavWs5pUvsTVDXWNmAYKtfeC4agunqjG4VHkEDJY2qkOmJgQCC8_gnbXWvh8yUFvPN_
 N2ObBIbi9zDQ5FbSedencC0SbnXew0IUfJyLwlzz2rll2mQw6PEkLG7esJbDv_jDdg2Yy10yMA25
 A2lEPHApS0JRj_2K.EPRudw2xh1EensDGGZ067Qh1MmHfD4E0gUqoBnbAJ6pRBgntmmnGRy7WtwR
 73dCG4BECMPQ8RE9LG1NmKrSHiBKfSGUfJCMQVVs8iYSHtc45joO90EzXTTD.jIgyBVdhm49eelq
 Uhuk4LcnWYtFgk5quKCV3jArYgmVBrO.BvWJ9H2v8PEnqrkx2DJmkH2RqHeHNbLURwWHnl1Wknd7
 onjuuvrUNZsTWKdiPpfVU_nUYNPOnVm_umuzNop0dPq1n7TBS81_VlE3gZtI_khwhAY39l9c.Jky
 Vo8FLsTpj6jQDgwOWZsePUhoZRQKnQm9WZlkW_dRB4kZ.OTtTe2w2aD5Ey71MmfvamBzoGN0189_
 q_Nc9twa1dJ5Z3gNwQhk_agw8tnRUT36oz0m7o01MN11SChJxOd56WcH8WgPuXkreXkZGQnKorne
 9IvpAg_pAJR2PU4oA8xzauuBXPZcudIlcJzj.FQH3xC1WGYciDjBUAQXyDSi5yj3mQX2xIMJBaEq
 VLuaBMDI0V8k1p14Hk.TIxt3NF4xw7CBePIyXeqbwX3oubvxaJ5LhAH6FhEZ.fokNIH0DucaBB5x
 OoBpIGGd5edCK0ZXz3sb6BykLSvI8YyA_cJYpGeFRCjXIl98uidC1_n5x6YxmjrC7qTKuT3HlUlB
 CVLcD7tjYnrTIwIAMiYitVR4Rk2K0KPAhnVR9Pa1qBGDRTA.A5TVeOK2zkBwhUmItDNmpPU5igft
 goQpojWo_tob9niY0s2HjbEi3bixfspaAmKByR.g5OiDdRq26Vs3yI8u5OqsaJuLx58Kxkt1AfSU
 opLZudlYDVU_vb1pA55RojioK9ce7W3d2fmBWRer.VqkLfShjFS8gJ2.3L0puRmu8HdpsTUqCfC3
 F36JyHEF9NikVEuwWNwiZFs9281R.V7dPlvwnr_4Ag4HTVle3a4uoxM5lb1LTWoy7fyh_bvDkHNn
 WITbxyf_gZsE9n8Oowu2csrRoPvp_BMptqizu_w--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic308.consmr.mail.ir2.yahoo.com with HTTP; Tue, 20 Aug 2019 16:35:38 +0000
Received: by smtp405.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID add83dbc90a00add290994e4b332bea6; 
 Tue, 20 Aug 2019 16:35:33 +0000 (UTC)
Date: Wed, 21 Aug 2019 00:35:08 +0800
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] erofs: move erofs out of staging
Message-ID: <20190820163504.GA7780@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190818162201.GA16269@infradead.org>
 <20190818172938.GA14413@sol.localdomain>
 <20190818174702.GA17633@infradead.org>
 <20190818181654.GA1617@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818201405.GA27398@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190819160923.GG15198@magnolia>
 <20190819203051.GA10075@hsiangkao-HP-ZHAN-66-Pro-G1>
 <bdb91cbf-985b-5a2c-6019-560b79739431@gmx.com>
 <ad62636f-ef1b-739f-42cc-28d9d7ed86da@huawei.com>
 <20190820155623.GA10232@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820155623.GA10232@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
 Dave Chinner <david@fromorbit.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
 devel <devel@driverdev.osuosl.org>, Christoph Hellwig <hch@infradead.org>,
 "Darrick J. Wong" <darrick.wong@oracle.com>,
 Richard Weinberger <richard@nod.at>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 Eric Biggers <ebiggers@kernel.org>, torvalds <torvalds@linux-foundation.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Pavel Machek <pavel@denx.de>,
 David Sterba <dsterba@suse.cz>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Ted,

On Tue, Aug 20, 2019 at 11:56:23AM -0400, Theodore Y. Ts'o wrote:
> On Tue, Aug 20, 2019 at 10:24:11AM +0800, Chao Yu wrote:
> > Out of curiosity, it looks like every mainstream filesystem has its own
> > fuzz/injection tool in their tool-set, if it's really such a generic
> > requirement, why shouldn't there be a common tool to handle that, let specified
> > filesystem fill the tool's callback to seek a node/block and supported fields
> > can be fuzzed in inode. It can help to avoid redundant work whenever Linux
> > welcomes a new filesystem....
> 
> The reason why there needs to be at least some file system specific
> code for fuzz testing is because for efficiency's sake, you don't want
> to fuzz every single bit in the file system, but just the ones which
> are most interesting (e.g., the metadata blocks).  For file systems
> which use checksum to protect against accidental corruption, the file
> system fuzzer needs to also fix up the checksums (since you can be
> sure malicious attackers will do this).

I personally agree with your idea, some fs specfic code needed at least.

> 
> What you *can* do is to make the file system specific portion of the
> work as small as possible.  Great work in this area is Professor Kim's
> Janus[1][2] and Hydra[2] work.  (Hydra is about to be published at SOSP 19,
> and was partially funded from a Google Faculty Research Work.)

For EROFS, it's a special case since it is a RO fs, and erofs mkfs
will generate reproducable images (which means, for one dir trees,
it only generates exact one result except for build time).

For this reason (read only), the fastest way to do fault injection
for EROFS is to modify mkfs and inject some faults when writing
each metadata to the generated images, that is all what I'm done
that night. I think it has similar effect since EROFS is an RO fs
for some given dirs (except for it cannot modify a specfic field
from a given image, but from its source dir). Actually I found 6
issues related with corrupted compressed images, and it can now
run smoothly for about an hour.

https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=experimental-fuzzer

What we will do next is to develop an independent fuzzer, which
need the ability of parsing the filesystem image (which share
common code with erofs-fuse to parse the filesystem) and then
it can inject some faults to the original image.

> 
> [1] https://taesoo.kim/pubs/2019/xu:janus.pdf
> [2] https://github.com/sslab-gatech/janus
> [3] https://github.com/sslab-gatech/hydra
> 
> > > Personally speaking, debugging tool is way more important than a running
> > > kernel module/fuse.
> > > It's human trying to write the code, most of time is spent educating
> > > code readers, thus debugging tool is way more important than dead cold code.
> 
> I personally find that having a tool like e2fsprogs' debugfs program
> to be really handy.  It's useful for creating regression test images;
> it's useful for debugging results from fuzzing systems like Janus;
> it's useful for examining broken file systems extracted from busted
> Android handsets during dogfood to root cause bugs which escaped
> xfstests testing; etc.

Yes, what I want to say is that these fses (ext4, xfs, btrfs, ...) do
awesome work by many people for many time. But I personally have 2 hand,
24 hours (including work hours) a day only.

I will refer to these debugfs / xfs_db / btrfs ins dump-tree great work
to get your experience and develop our EROFS tools. I learn a lot from
this topic.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> 						- Ted
