Return-Path: <SRS0=iJNB=W2=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C35AC3A5A6
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 14:23:47 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACA4323407
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Aug 2019 14:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACA4323407
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46KhYC3vQDzDqsb
	for <linux-erofs@archiver.kernel.org>; Sat, 31 Aug 2019 00:23:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=huawei.com
 (client-ip=45.249.212.189; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46KhXw4kQgzDqJH
 for <linux-erofs@lists.ozlabs.org>; Sat, 31 Aug 2019 00:23:28 +1000 (AEST)
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 0C3D9B9824D70BB06F5C;
 Fri, 30 Aug 2019 22:23:22 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 30 Aug 2019 22:23:21 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 30 Aug 2019 22:23:21 +0800
Date: Fri, 30 Aug 2019 22:22:33 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Pratik Shinde <pratikshinde320@gmail.com>
Subject: Re: [PATCH] erofs: using switch-case while checking the inode type.
Message-ID: <20190830142233.GA241393@architecture4>
References: <20190830095615.10995-1-pratikshinde320@gmail.com>
 <20190830115947.GA10981@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190830115947.GA10981@hsiangkao-HP-ZHAN-66-Pro-G1>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.140.130.215]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
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
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Aug 30, 2019 at 07:59:48PM +0800, Gao Xiang wrote:
> Hi Pratik,
> 
> The subject line could be better as '[PATCH v2] xxxxxx'...
> 
> On Fri, Aug 30, 2019 at 03:26:15PM +0530, Pratik Shinde wrote:
> > while filling the linux inode, using switch-case statement to check
> > the type of inode.
> > switch-case statement looks more clean here.
> > 
> > Signed-off-by: Pratik Shinde <pratikshinde320@gmail.com>
> 
> I have no problem of this patch, and I will do a test and reply
> you "Reviewed-by:" in hours (I'm doing another patchset to resolve
> what Christoph suggested again)...

Reviewed-by: Gao Xiang <gaoxiang25@huawei.com>

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> > ---
> >  fs/erofs/inode.c | 18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> > index 80f4fe9..6336cc1 100644
> > --- a/fs/erofs/inode.c
> > +++ b/fs/erofs/inode.c
> > @@ -190,22 +190,28 @@ static int fill_inode(struct inode *inode, int isdir)
> >  	err = read_inode(inode, data + ofs);
> >  	if (!err) {
> >  		/* setup the new inode */
> > -		if (S_ISREG(inode->i_mode)) {
> > +		switch (inode->i_mode & S_IFMT) {
> > +		case S_IFREG:
> >  			inode->i_op = &erofs_generic_iops;
> >  			inode->i_fop = &generic_ro_fops;
> > -		} else if (S_ISDIR(inode->i_mode)) {
> > +			break;
> > +		case S_IFDIR:
> >  			inode->i_op = &erofs_dir_iops;
> >  			inode->i_fop = &erofs_dir_fops;
> > -		} else if (S_ISLNK(inode->i_mode)) {
> > +			break;
> > +		case S_IFLNK:
> >  			/* by default, page_get_link is used for symlink */
> >  			inode->i_op = &erofs_symlink_iops;
> >  			inode_nohighmem(inode);
> > -		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
> > -			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
> > +			break;
> > +		case S_IFCHR:
> > +		case S_IFBLK:
> > +		case S_IFIFO:
> > +		case S_IFSOCK:
> >  			inode->i_op = &erofs_generic_iops;
> >  			init_special_inode(inode, inode->i_mode, inode->i_rdev);
> >  			goto out_unlock;
> > -		} else {
> > +		default:
> >  			err = -EFSCORRUPTED;
> >  			goto out_unlock;
> >  		}
> > -- 
> > 2.9.3
> > 
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
