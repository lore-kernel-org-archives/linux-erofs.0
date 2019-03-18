From: gregkh@linuxfoundation.org (Greg KH)
Date: Mon, 18 Mar 2019 16:38:16 +0100
Subject: [PATCH v3] staging: erofs: Add whitespace after declaration
In-Reply-To: <20190318153224.GA3596@bharath12345-Inspiron-5559>
References: <20190318153224.GA3596@bharath12345-Inspiron-5559>
Message-ID: <20190318153816.GA15943@kroah.com>

On Mon, Mar 18, 2019@09:02:24PM +0530, Bharath Vedartham wrote:
> Add whitespace after declaration. Fixed the checkpatch.pl warning.
> 
> ---

No signed-off-by?

> changes since v2
> 	- mutt gave me a lot of problems. Hence 3 patches for a really
> 	  small problem.
> 	- Fixed the extra missing line.
> 
> Signed-off-by: Bharath Vedartham <linux.bhar at gmail.com>

It needs to be above the --- line, otherwise it will be stripped off
when applied.

v4 please?

thanks,

greg k-h
