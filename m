From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 10 Sep 2018 10:10:27 +0200
Subject: [PATCH v3] staging: erofs: use explicit unsigned int type
In-Reply-To: <20180909183753.11021-1-linux@weissschuh.net>
References: <5c44a63b-041d-1fce-0748-53c0b44f5983@huawei.com>
 <20180909183753.11021-1-linux@weissschuh.net>
Message-ID: <20180910081027.GA31845@kroah.com>

On Sun, Sep 09, 2018@08:37:53PM +0200, Thomas Wei?schuh wrote:
> Changes since v1:
> 
> * Removed changes that conflicted with
>   [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
> * Added patch description
> 
> Changes since v2:
> 
> * Fixed conflicts with other patchsets
> * Don't introduce new style issues
> 

These changes belong below the --- line, not above it.  I'm not sure if
git will handle this line:

> -- >8 --

Correctly or not, have you tried it?

thanks,

greg k-h
