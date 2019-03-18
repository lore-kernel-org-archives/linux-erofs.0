From: julianmr97@gmail.com (Julian Merida)
Date: Sun, 17 Mar 2019 23:10:24 -0300
Subject: [PATCH] staging: erofs: fix parenthesis alignment
In-Reply-To: <df0b465d-22d1-1356-f493-6c4910513781@huawei.com>
References: <20190312041827.6176-1-julianmr97@gmail.com>
 <df0b465d-22d1-1356-f493-6c4910513781@huawei.com>
Message-ID: <CAG=bvsotyXYemfKfZMnQ=0R_HiCVwmBghfR7+mw4+DSgS8JK0g@mail.gmail.com>

Sorry for the delay, I've been busy and I couldn't check the code before.
Sorry for those mistakes, I agree. That is how the should be. I am going to
edit them and resend the patch to you.

Regards, Julian Merida

El mar., 12 de mar. de 2019 a la(s) 02:37, Gao Xiang (gaoxiang25 at huawei.com)
escribi?:

>
>
> On 2019/3/12 12:18, Julian Merida wrote:
> > -             err = z_erofs_vle_work_add_page(builder,
> > -                     newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE);
> > +             err =
> > +             z_erofs_vle_work_add_page(builder, newpage,
> > +                                       Z_EROFS_PAGE_TYPE_EXCLUSIVE);
>
> Why not ?
>                 err = z_erofs_vle_work_add_page(builder, newpage,
>
> Z_EROFS_PAGE_TYPE_EXCLUSIVE);
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190317/ce3bc037/attachment.htm>
