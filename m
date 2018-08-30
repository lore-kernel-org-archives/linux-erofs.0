From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 30 Aug 2018 03:54:58 -0700
Subject: [PATCH] staging: erofs: formatting unzip_vle_lz4.c
In-Reply-To: <1535625607-14281-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535625607-14281-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <20180830105458.GA31019@kroah.com>

On Thu, Aug 30, 2018@01:40:07PM +0300, Pavel Zemlyanoy wrote:
> This patch changes the coding style for unzip_vle_lz4.c,
> following the accepted formatting rules.
> 
> Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
> ---
>  drivers/staging/erofs/unzip_vle_lz4.c | 72 ++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 35 deletions(-)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch did many different things all at once, making it difficult
  to review.  All Linux kernel patches need to only do one thing at a
  time.  If you need to do multiple things (such as clean up all coding
  style issues in a file/driver), do it in a sequence of patches, each
  one doing only one thing.  This will make it easier to review the
  patches to ensure that they are correct, and to help alleviate any
  merge issues that larger patches can cause.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
