From: torvalds@linux-foundation.org (Linus Torvalds)
Date: Thu, 15 Aug 2019 09:13:19 -0700
Subject: [PATCH v8 07/24] erofs: add directory operations
In-Reply-To: <20190815044155.88483-8-gaoxiang25@huawei.com>
References: <20190815044155.88483-1-gaoxiang25@huawei.com>
 <20190815044155.88483-8-gaoxiang25@huawei.com>
Message-ID: <CAHk-=wiUs+b=iVKM3mVooXgVk7cmmC67KTmnAuL0cd_cMMVAKw@mail.gmail.com>

On Wed, Aug 14, 2019@9:42 PM Gao Xiang <gaoxiang25@huawei.com> wrote:
>
> +
> +static const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
> +       [EROFS_FT_UNKNOWN]      = DT_UNKNOWN,
> +       [EROFS_FT_REG_FILE]     = DT_REG,
> +       [EROFS_FT_DIR]          = DT_DIR,
> +       [EROFS_FT_CHRDEV]       = DT_CHR,
> +       [EROFS_FT_BLKDEV]       = DT_BLK,
> +       [EROFS_FT_FIFO]         = DT_FIFO,
> +       [EROFS_FT_SOCK]         = DT_SOCK,
> +       [EROFS_FT_SYMLINK]      = DT_LNK,
> +};

Hmm.

The EROFS_FT_XYZ values seem to match the normal FT_XYZ values, and
we've lately tried to just have filesystems use the standard ones
instead of having a (pointless) duplicate conversion between the two.

And then you can use the common "fs_ftype_to_dtype()" to convert from
FT_XYZ to DT_XYZ.

Maybe I'm missing something, and the EROFS_FT_x list actually differs
from the normal FT_x list some way, but it would be good to not
introduce another case of this in normal filesystems, just as we've
been getting rid of them.

See for example commit e10892189428 ("ext2: use common file type conversion").

               Linus
