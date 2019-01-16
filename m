From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Wed, 16 Jan 2019 13:45:53 +0300
Subject: [PATCH 3/5] staging: erofs: decrease the shrink count in
 erofs_workgroup_get
In-Reply-To: <20190116085956.21004-3-gaoxiang25@huawei.com>
References: <20190116085956.21004-1-gaoxiang25@huawei.com>
 <20190116085956.21004-3-gaoxiang25@huawei.com>
Message-ID: <20190116104553.GE4482@kadam>

On Wed, Jan 16, 2019@04:59:54PM +0800, Gao Xiang wrote:
> It is more suitable to update in erofs_workgroup_get since
> it's actually the one matched with erofs_workgroup_put.
> 

This patch is fine.  No need to resend.

Reviewed-by: Dan Carpenter <dan.carpenter at oracle.com>

But for future reference, I found the commit message a bit confusing.
Ideally, I would understand basically what the commit does and why
without needing to read the diff.

I mostly just read the subject or the commit message, either or, instead
of reading both.  (This is not really true.)  My email client looks like
this.  (Also not true).

https://marc.info/?l=linux-driver-devel&m=154762932712086&w=2

While none of that was strictly true, it is a little bit true-ish...
So please, assume that some people will start reading the commit message
without reading the subject.

I sort of thought from reading the commit message that it was a bugfix
or a behavior change.  A better commit message would be:

staging: erofs: move shrink accounting inside the function

This patch moves the &erofs_global_shrink_cnt accounting from the caller
to erofs_workgroup_get().  It's cleaner and it matches erofs_workgroup_put()
better.  No behavior change.

regards,
dan carpenter
