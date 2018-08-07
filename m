From: gregkh@linuxfoundation.org (Greg KH)
Date: Tue, 7 Aug 2018 11:17:47 +0200
Subject: [PATCH v3] staging: erofs: disable compiling temporarile
In-Reply-To: <c89ff718-b88b-feb7-03e2-d0dc1c1cade1@huawei.com>
References: <20180802143455.9214-1-chao@kernel.org>
 <20180802173319.GB24125@kroah.com>
 <c89ff718-b88b-feb7-03e2-d0dc1c1cade1@huawei.com>
Message-ID: <20180807091747.GA24468@kroah.com>

On Mon, Aug 06, 2018@11:07:07AM +0800, Chao Yu wrote:
> Hi Greg,
> 
> On 2018/8/3 1:33, Greg KH wrote:
> > Sorry, I already took the first version in my tree.  Don't worry about
> 
> For staging-{test,next} maintaining thing, before merge window, if we want to
> remove or replace one merged patch in staging tree, what we can do is:
> a. ask you for help to remove/replace it directly; or
> b. submit a revert-patch first, and then send another fixed patch.

Or better yet:
	- submit a follow-on patch that fixes things up properly.

thanks

greg k-h
