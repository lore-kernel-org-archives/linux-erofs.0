Return-Path: <SRS0=sNXf=EK=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CACAC2D0A3
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2020 01:12:01 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D5C53223C7
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2020 01:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aznQ+nR3";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MTS5HILh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5C53223C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CQpXG50L0zDqcR
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2020 12:11:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=aznQ+nR3; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=MTS5HILh; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CQpX72KZBzDqZC
 for <linux-erofs@lists.ozlabs.org>; Wed,  4 Nov 2020 12:11:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604452304;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=AYAxNjRS1Y5VJEBPFoYSMpdltV+UvYhl9mJNVdZdbpE=;
 b=aznQ+nR3PMW1f+C1DzEP0ADIl2Ub90D5ILT3HWAcNH19kxp3Y7vk8cI81f78Tp0V1vXusA
 Nhr+O9tZH6KogfCdMKBQ4uw4kBvt9WxeGDgEnwrHvIVbYcav4zWyrAGis/Esbr2WAfeJUV
 9zB6pWVKJ9p+a/lAc20Sh/cOxq0nUGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604452305;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=AYAxNjRS1Y5VJEBPFoYSMpdltV+UvYhl9mJNVdZdbpE=;
 b=MTS5HILhmj65Us/VNpNYr41zxi5/tMedtbr3isUbtxLy8ACXWOiyFt/Cv2Z+BnzXiddjQG
 QJBIJlWwqW1kXdWdC77XEJea/GT9bD14Kg9C7DIJ9LBb7VkBw06GQdU1Y28Y3nl39NuyGd
 7k6qbAyj48wyI0FUSBoHfbIlxS3kaBc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-DnDBf2QtPIiox6HNCROsTg-1; Tue, 03 Nov 2020 20:11:42 -0500
X-MC-Unique: DnDBf2QtPIiox6HNCROsTg-1
Received: by mail-pg1-f198.google.com with SMTP id v2so5353871pgv.2
 for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2020 17:11:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=AYAxNjRS1Y5VJEBPFoYSMpdltV+UvYhl9mJNVdZdbpE=;
 b=IO1YgW2iZDtTu0rCCkeJYPB8p19mccuFvDnuPAfAnQC7eOHVXERJ43L40EXpL7fZdA
 hAauMPB0aBI0yY+kjGUHBlh2GgCp1/y1hKJ+CTKD+xVIBn3FLq9JMWivz0RYYEolvW/a
 MOsxqbXBibU6m8LcBr4e9NjvTzQIMZq4ntdAOUITEvppY0/6PYJrhedrVq11hBQTd8Wx
 x80CgnCBqsIKuchEqqo2Cnr2P3nqSu+YLn4OEHh9vXP1ohwCgQKjF4HeTqFNi0mNI/+p
 wZJMCltd4Z2fKr05s/IufT+fOI+qhTQaFAurJhejLM4RLtXEuJoOfp/F56qyPnCb+CUl
 zfyQ==
X-Gm-Message-State: AOAM533b9gBFCRmK+29fMD3pWasyGtY0CoYRXLuCZ0FwaM+0Q6ajqZY6
 ciiw5qgMIU6c1XwLHCD+aAMJmtkB4R6q4+SEhP5YrM7I0Of6xcBEC6imADRMvaS5bpxivVFF7bQ
 831jo/LiXi+GtLkUoffNX60Qo
X-Received: by 2002:a63:7347:: with SMTP id d7mr20014977pgn.63.1604452301753; 
 Tue, 03 Nov 2020 17:11:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxpFMxUi9XiP5r4aFL+JnajpzEAMHAmmzeMKlz0Y0PbIM9eMsx1I6wdXXPSSMhWhLzlvIYCg==
X-Received: by 2002:a63:7347:: with SMTP id d7mr20014962pgn.63.1604452301538; 
 Tue, 03 Nov 2020 17:11:41 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id t30sm326265pfg.99.2020.11.03.17.11.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Nov 2020 17:11:41 -0800 (PST)
Date: Wed, 4 Nov 2020 09:11:30 +0800
From: Gao Xiang <hsiangkao@redhat.com>
To: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 1/4] erofs: fix setting up pcluster for temporary pages
Message-ID: <20201104011130.GA982972@xiangao.remote.csb>
References: <20201022145724.27284-1-hsiangkao.ref@aol.com>
 <20201022145724.27284-1-hsiangkao@aol.com>
 <f1f24a38-97f7-e9cf-03c8-2c95814b98a3@huawei.com>
MIME-Version: 1.0
In-Reply-To: <f1f24a38-97f7-e9cf-03c8-2c95814b98a3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hsiangkao@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: stable@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Nov 04, 2020 at 09:05:56AM +0800, Chao Yu wrote:
> On 2020/10/22 22:57, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > pcluster should be only set up for all managed pages instead of
> > temporary pages. Since it currently uses page->mapping to identify,
> > the impact is minor for now.
> > 
> > Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
> > Cc: <stable@vger.kernel.org> # 5.5+
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks, I've also added a note to the commit message like this,
"
[ Update: Vladimir reported the kernel log becomes polluted
  because PAGE_FLAGS_CHECK_AT_FREE flag(s) set if the page
  allocation debug option is enabled. ]
"
Will apply all of this to -fixes branch.

Thanks,
Gao Xiang

> 
> Thanks,
> 

