From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 6 Aug 2018 11:07:07 +0800
Subject: [PATCH v3] staging: erofs: disable compiling temporarile
In-Reply-To: <20180802173319.GB24125@kroah.com>
References: <20180802143455.9214-1-chao@kernel.org>
 <20180802173319.GB24125@kroah.com>
Message-ID: <c89ff718-b88b-feb7-03e2-d0dc1c1cade1@huawei.com>

Hi Greg,

On 2018/8/3 1:33, Greg KH wrote:
> Sorry, I already took the first version in my tree.  Don't worry about

For staging-{test,next} maintaining thing, before merge window, if we want to
remove or replace one merged patch in staging tree, what we can do is:
a. ask you for help to remove/replace it directly; or
b. submit a revert-patch first, and then send another fixed patch.

What kind of way we should use or you prefer to?

Thanks,

> it for now you can fix this up after 4.19-rc1 is out when we enable the
> filesystem again.
> 
> thanks,
> 
> greg k-h
> 
> .
> 
