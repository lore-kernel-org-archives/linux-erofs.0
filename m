From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 12:05:00 +0100
Subject: [PATCH 07/10] staging: erofs: separate into init_once / always
In-Reply-To: <66b90226-5d0e-7344-5220-908aa243b014@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-8-gaoxiang25@huawei.com>
 <20181122102339.GG3189@kroah.com>
 <66b90226-5d0e-7344-5220-908aa243b014@huawei.com>
Message-ID: <20181122110500.GC5287@kroah.com>

On Thu, Nov 22, 2018@06:34:10PM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On 2018/11/22 18:23, Greg Kroah-Hartman wrote:
> >> +
> >> +	DBG_BUGON(work->nr_pages);
> >> +	DBG_BUGON(work->vcnt);
> > How can these ever be triggered?  I understand the need for debugging
> > code when you are writing code, but at this point it shouldn't be needed
> > anymore, right?
> 
> I need to avoid some fields is not 0 when the new workgroup is created (because
> work->nr_pages and work->vcnt == 0 usually after the previous workgroup is freed).
> But that is not obvious, it is promised by the current logic.

Then delete these lines if they can never happen :)

> In order to not introduce such a issue in the future, or there are some potential
> race (work->nr_pages and work->vcnt != 0 when the previous workgroup == 0), it need
> to be noticed to developpers as early as possible.

Then make it a real call, do not wrap it in odd macros that do not
really explain why it is "debugging only".  Your code is "real" now,
make the logic real for all developers and users.

thanks,

greg k-h
