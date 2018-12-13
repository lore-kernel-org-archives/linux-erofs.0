From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 13 Dec 2018 11:42:56 +0800
Subject: [PATCH] staging: erofs: Add a blank line after declarations
In-Reply-To: <CAHw2A4mmtktjnb3rrWF3x4B-Hn1mq3sCZkXNmsQ+Gi=_tiH3=w@mail.gmail.com>
References: <20181212155023.45294-1-jotun9935@gmail.com>
 <9d1280a1-d4bd-d64d-20ff-1468408f9607@huawei.com>
 <CAHw2A4mmtktjnb3rrWF3x4B-Hn1mq3sCZkXNmsQ+Gi=_tiH3=w@mail.gmail.com>
Message-ID: <f782280e-79a4-87a7-bf98-d95c895f2a85@huawei.com>



On 2018/12/13 11:29, ??? wrote:
> Thank you. I appreciate it for your?prompt reply.
> 
> 
> As a result of checking through 'checkpatch.pl <http://checkpatch.pl>', there was only one coding style problem in 'erofs / inode.c' file.
> 
> 
> I will check for other files and send the patch file soon.

Yes, if you confirm that this is the only one place, I think this patch is ok for me personally. :)

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Sungkyung Kim?
> 
> 
> 2018? 12? 13? (?) ?? 10:51, Gao Xiang <gaoxiang25 at huawei.com <mailto:gaoxiang25 at huawei.com>>?? ??:
> 
>     Hi Sungkyung,
> 
>     On 2018/12/12 23:50, Sungkyung Kim wrote:
>     > Fix a warning from checkpathch.pl <http://checkpathch.pl>: 'Missing a blank line after
>     > declarations'
>     >
>     > Signed-off-by: Sungkyung Kim <jotun9935 at gmail.com <mailto:jotun9935 at gmail.com>>
>     > ---
>     >? drivers/staging/erofs/inode.c | 1 +
>     >? 1 file changed, 1 insertion(+)
>     >
>     > diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
>     > index 04c61a9d7b76..82b6ad5badff 100644
>     > --- a/drivers/staging/erofs/inode.c
>     > +++ b/drivers/staging/erofs/inode.c
>     > @@ -278,6 +278,7 @@ struct inode *erofs_iget(struct super_block *sb,
>     >? ? ? ?if (inode->i_state & I_NEW) {
>     >? ? ? ? ? ? ? ?int err;
>     >? ? ? ? ? ? ? ?struct erofs_vnode *vi = EROFS_V(inode);
>     > +
> 
>     Thanks for your patch, is there a only one 'Missing a blank line after declarations' in erofs?
> 
>     If not, could you have time check the other files? That is my personal thought, and
>     I cc-ed the staging mailing list as well.
> 
>     Thanks,
>     Gao Xiang
> 
>     >? ? ? ? ? ? ? ?vi->nid = nid;
>     >?
>     >? ? ? ? ? ? ? ?err = fill_inode(inode, isdir);
>     >
> 
