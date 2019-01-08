From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 8 Jan 2019 07:42:33 +0100
Subject: [PATCH 0/2] staging: erofs: fixed -Wmissing-prototype warnings.
In-Reply-To: <20190107182516.21511-1-jeremy@azazel.net>
References: <20190107182516.21511-1-jeremy@azazel.net>
Message-ID: <20190108064233.GC29171@kroah.com>

On Mon, Jan 07, 2019@06:25:14PM +0000, Jeremy Sowden wrote:
> Fixes for -Wmissing-prototype warnings in the erofs driver.  One group of
> functions have been made static; for the second, prototypes have been moved to a
> head
> 
> Jeremy Sowden (2):
>   staging: erofs: fixed -Wmissing-prototype warnings.
>   staging: erofs: fixed -Wmissing-prototype warnings.

You sent two different patches that did different things, yet they had
identical subject lines :(

Please fix that up, and resend.

greg k-h
