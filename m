From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Thu, 11 Oct 2018 11:44:13 +0300
Subject: [PATCH] staging: erofs: harden inode lookup for 32-bit platforms
In-Reply-To: <20181009140713.29629-1-gaoxiang25@huawei.com>
References: <20181009140713.29629-1-gaoxiang25@huawei.com>
Message-ID: <20181011084413.3sovzgsj6pzyrml7@mwanda>

On Tue, Oct 09, 2018@10:07:13PM +0800, Gao Xiang wrote:
> This patch introduces inode hash function, test and set callbacks,
> and iget5_locked to find the right inode for 32-bit platforms.
> 

The way I read this changelog, we're trying to deal with corrupt file
systems?  Is that correct?  Presumably in the current code it could lead
to a Oops or something?

regards,
dan carpenter
