From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Aug 2019 20:41:37 +0800
Subject: [PATCH v7 08/24] erofs: add namei functions
In-Reply-To: <20190813122332.GA17429@138>
References: <20190813091326.84652-1-gaoxiang25@huawei.com>
 <20190813091326.84652-9-gaoxiang25@huawei.com>
 <20190813114821.GB11559@amd> <20190813122332.GA17429@138>
Message-ID: <20190813124136.GB17429@138>

On Tue, Aug 13, 2019@08:23:32PM +0800, Gao Xiang wrote:
> Hi Pavel,
> 
> On Tue, Aug 13, 2019@01:48:21PM +0200, Pavel Machek wrote:

[]

> There is something needing to be concerned, is, whether namei() should
> report any potential on-disk issues or just return -ENOENT for these
> corrupted dirs, I think I tend to use the latter one.
>

Add a word, I didn't mean for any cases return -ENOENT, just this
one only since this is the hottest path in every lookup. Other
places should have reported any potential issues as much as
possible if it finds.

Thanks,
Gao Xiang
 
> 
> > 
> > 								Pavel
> > -- 
> > DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> > HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> 
> 
