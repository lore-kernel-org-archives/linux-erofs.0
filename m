From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Fri, 22 Feb 2019 09:35:22 +0100
Subject: [PATCH for-4.19 00/12] erofs fixes for linux-4.19.y
In-Reply-To: <20190220091854.19242-1-gaoxiang25@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
Message-ID: <20190222083522.GB16734@kroah.com>

On Wed, Feb 20, 2019@05:18:42PM +0800, Gao Xiang wrote:
> This series backports bugfixes already merged in linux upstream
> which we found these issues in our commerical products, which
> are serious and should be fixed immediately.
> 
> Note that it also includes some xarray modification since
> upcoming patches heavily needs it, which can reduce more
> conflicts later.
> 
> All patches have been tested again as a whole.

Some of these patches are not in 4.20, so if a user were to move to that
kernel, they would see a "regression" in the filesystem functionality,
right?  That's not ok, and because of that reason alone, I can't take
this whole series for 4.19.y right now.

So can you prepare a set of patches for 4.20.y also with the missing
patches you have included here?

Also, are all of these really "fixes"?  They feel like they are basic
"get things working properly" type of patches.  The BUG_ONs are not
really fixes as no one _should_ be hitting those in a normal system,
right?  Are they really necessary for systems running 4.19?

thanks,

greg k-h
