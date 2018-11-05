From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 5 Nov 2018 15:03:06 +0100
Subject: [PATCH v3 2/2] staging: erofs: Modify conditional checks
In-Reply-To: <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
Message-ID: <20181105140306.GA20228@kroah.com>

On Mon, Nov 05, 2018@12:35:03PM +0000, Bhagyashri P. Dighole wrote:
> Fix coding style alignment issues detected by checkpatch.pl
> Use ! for NULL test rather than explicitly comparing to NULL.
> 
> Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> ---
>  drivers/staging/erofs/data.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Why did you send this patch twice?

And what changed in it from v1 and v2?  Always put that information
below the --- line.

Please fix this up and resend the whole series with that information.

thanks,

greg k-h
