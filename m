From: joseph.qi@linux.alibaba.com (Joseph Qi)
Date: Tue, 28 May 2019 08:50:06 +0800
Subject: [PATCH 2/3] mm: remove cleancache.c
In-Reply-To: <20190527103207.13287-3-jgross@suse.com>
References: <20190527103207.13287-1-jgross@suse.com>
 <20190527103207.13287-3-jgross@suse.com>
Message-ID: <7c75d310-1beb-08f3-d590-b4ff2c42cbcd@linux.alibaba.com>



On 19/5/27 18:32, Juergen Gross wrote:
> With the removal of tmem and xen-selfballoon the only user of
> cleancache is gone. Remove it, too.
> 
> Signed-off-by: Juergen Gross <jgross at suse.com>
> ---
>  Documentation/vm/cleancache.rst  | 296 ------------------------------------
>  Documentation/vm/frontswap.rst   |  10 +-
>  Documentation/vm/index.rst       |   1 -
>  MAINTAINERS                      |   7 -
>  drivers/staging/erofs/data.c     |   6 -
>  drivers/staging/erofs/internal.h |   1 -
>  fs/block_dev.c                   |   5 -
>  fs/btrfs/extent_io.c             |   9 --
>  fs/btrfs/super.c                 |   2 -
>  fs/ext4/readpage.c               |   6 -
>  fs/ext4/super.c                  |   2 -
>  fs/f2fs/data.c                   |   3 +-
>  fs/mpage.c                       |   7 -
>  fs/ocfs2/super.c                 |   2 -

For ocfs2 part,
Reviewed-by: Joseph Qi <joseph.qi at linux.alibaba.com>

>  fs/super.c                       |   3 -
>  include/linux/cleancache.h       | 124 ---------------
>  include/linux/fs.h               |   5 -
>  mm/Kconfig                       |  22 ---
>  mm/Makefile                      |   1 -
>  mm/cleancache.c                  | 317 ---------------------------------------
>  mm/filemap.c                     |  11 --
>  mm/truncate.c                    |  15 +-
