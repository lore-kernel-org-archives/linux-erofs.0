From: valdis.kletnieks@vt.edu (valdis.kletnieks@vt.edu)
Date: Tue, 12 Mar 2019 14:40:36 -0400
Subject: [PATCH 1/1] staging: erofs: Add function comment for erofs/super.c
In-Reply-To: <CAKsu7qwsSeN3XT=f-cz6wOMdwAHHhDJpWnNk_2epHu5J+F0+VA@mail.gmail.com>
References: <CAKsu7qwsSeN3XT=f-cz6wOMdwAHHhDJpWnNk_2epHu5J+F0+VA@mail.gmail.com>
Message-ID: <17926.1552416036@turing-police>

On Tue, 12 Mar 2019 23:33:47 +0530, arshad hussain said:
> Re-sending. Previous patch I put in very old kernel-newbies address.
>
> Subject: [PATCH 1/1] staging: erofs: Add function comment for
>  erofs/super.c
>
> This patch adds functions comment for file erofs/super.c in
> sphinx format.
>
> Signed-off-by: Arshad Hussain <arshad.super at gmail.com>
> ---
>  drivers/staging/erofs/super.c | 133 ++++++++++++++++++++++++++++++++++++++++
+-
>  1 file changed, 130 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 15c784fba879..6d2b93d94839 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -30,6 +30,11 @@ static void init_once(void *ptr)
>         inode_init_once(&vi->vfs_inode);
>  }
>
> +/*

Actually, if you're trying to do sphinx/kerneldoc format, the first line of the
block comment should be '/**' with two asterisks.

Also, all kernel patches should be cc'd to linux-kernel at vger.kernel.org as well as
the maintainers and subsystem lists.
