From: jotun9935@gmail.com (=?UTF-8?B?6rmA7ISx6rK9?=)
Date: Thu, 13 Dec 2018 12:29:47 +0900
Subject: [PATCH] staging: erofs: Add a blank line after declarations
In-Reply-To: <9d1280a1-d4bd-d64d-20ff-1468408f9607@huawei.com>
References: <20181212155023.45294-1-jotun9935@gmail.com>
 <9d1280a1-d4bd-d64d-20ff-1468408f9607@huawei.com>
Message-ID: <CAHw2A4mmtktjnb3rrWF3x4B-Hn1mq3sCZkXNmsQ+Gi=_tiH3=w@mail.gmail.com>

Thank you. I appreciate it for your prompt reply.


As a result of checking through 'checkpatch.pl', there was only one coding
style problem in 'erofs / inode.c' file.


I will check for other files and send the patch file soon.


Thanks,

Sungkyung Kim

2018? 12? 13? (?) ?? 10:51, Gao Xiang <gaoxiang25 at huawei.com>?? ??:

> Hi Sungkyung,
>
> On 2018/12/12 23:50, Sungkyung Kim wrote:
> > Fix a warning from checkpathch.pl: 'Missing a blank line after
> > declarations'
> >
> > Signed-off-by: Sungkyung Kim <jotun9935 at gmail.com>
> > ---
> >  drivers/staging/erofs/inode.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/staging/erofs/inode.c
> b/drivers/staging/erofs/inode.c
> > index 04c61a9d7b76..82b6ad5badff 100644
> > --- a/drivers/staging/erofs/inode.c
> > +++ b/drivers/staging/erofs/inode.c
> > @@ -278,6 +278,7 @@ struct inode *erofs_iget(struct super_block *sb,
> >       if (inode->i_state & I_NEW) {
> >               int err;
> >               struct erofs_vnode *vi = EROFS_V(inode);
> > +
>
> Thanks for your patch, is there a only one 'Missing a blank line after
> declarations' in erofs?
>
> If not, could you have time check the other files? That is my personal
> thought, and
> I cc-ed the staging mailing list as well.
>
> Thanks,
> Gao Xiang
>
> >               vi->nid = nid;
> >
> >               err = fill_inode(inode, isdir);
> >
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20181213/33ba85dd/attachment.html>
