From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 24 Jul 2019 10:13:59 +0800
Subject: [PATCH] erofs-utils: Add missing error code handling.
In-Reply-To: <CAGu0czQQmASDKw0VF4EN=A0hR56U09+TFxnUoxeG6HHO2APcOg@mail.gmail.com>
References: <20190723200429.7132-1-pratikshinde320@gmail.com>
 <980200eb-fa95-2de2-d68c-c52a323a540b@huawei.com>
 <CAGu0czQQmASDKw0VF4EN=A0hR56U09+TFxnUoxeG6HHO2APcOg@mail.gmail.com>
Message-ID: <d64513ae-c77c-d136-f29b-9a2f55280ca0@huawei.com>



On 2019/7/24 10:11, Pratik Shinde wrote:
> This is stranger. Even this mail of yours is not showing up in mail archives. Let me resend the patch

My personal email hsiangkao at aol.com didn't receive the patch as well...
(Friendly reminder, take a look at the following comment in the code...)

Thanks,
Gao Xiang

> 
> 
> -Pratik
> 
> On Wed, 24 Jul, 2019, 7:04 AM Gao Xiang, <gaoxiang25@huawei.com <mailto:gaoxiang25@huawei.com>> wrote:
> 
>     Hi Pratik,
> 
>     This patch isn't in erofs mailing list. I don't know what is wrong...
>     Could you resend the patch? It'd be better in the mailing list....
> 
>     On 2019/7/24 4:04, Pratik Shinde wrote:
>     > Handling error conditions that are missing in few scenarios.
>     >
>     > Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com <mailto:pratikshinde320 at gmail.com>>
>     > ---
>     >? lib/inode.c | 10 ++++++++--
>     >? mkfs/main.c | 10 ++++++++--
>     >? 2 files changed, 16 insertions(+), 4 deletions(-)
>     >
>     > diff --git a/lib/inode.c b/lib/inode.c
>     > index 179aa26..08d38c0 100644
>     > --- a/lib/inode.c
>     > +++ b/lib/inode.c
>     > @@ -752,8 +752,14 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
>     >? ? ? ?}
>     >? ? ? ?closedir(_dir);
>     >?
>     > -? ? ?erofs_prepare_dir_file(dir);
>     > -? ? ?erofs_prepare_inode_buffer(dir);
>     > +? ? ?ret = erofs_prepare_dir_file(dir);
>     > +? ? ?if(!ret)
>     > +? ? ? ? ? ? ?goto err_closedir;
>     > +
>     > +? ? ?ret = erofs_prepare_inode_buffer(dir);
>     > +? ? ?if(!ret)
>     > +? ? ? ? ? ? ?goto err_closedir;
>     > +
>     >? ? ? ?if (IS_ROOT(dir))
>     >? ? ? ? ? ? ? ?erofs_fixup_meta_blkaddr(dir);
>     >?
>     > diff --git a/mkfs/main.c b/mkfs/main.c
>     > index 1348587..9c9530d 100644
>     > --- a/mkfs/main.c
>     > +++ b/mkfs/main.c
>     > @@ -200,18 +200,24 @@ int main(int argc, char **argv)
>     >? ? ? ?if (err) {
>     >? ? ? ? ? ? ? ?if (err == -EINVAL)
>     >? ? ? ? ? ? ? ? ? ? ? ?usage();
>     > -? ? ? ? ? ? ?return 1;
>     > +? ? ? ? ? ? ?return err;
> 
>     current erofs-utils will return 1; when failure...
>     If you suggest to return the real error code, could you fix the following as well?
>     and it should be return -err; since a positive error code is perfered? I have no idea....
> 
>     253 exit:
>     254? ? ? ? ?z_erofs_compress_exit();
>     255? ? ? ? ?dev_close();
>     256? ? ? ? ?erofs_exit_configure();
>     257
>     258? ? ? ? ?if (err) {
>     259? ? ? ? ? ? ? ? ?erofs_err("\tCould not format the device : %s\n",
>     260? ? ? ? ? ? ? ? ? ? ? ? ? ?erofs_strerror(err));
>     261? ? ? ? ? ? ? ? ?return 1;
>     262? ? ? ? ?}
>     263? ? ? ? ?return err;
> 
>     Thanks,
>     Gao Xiang
> 
>     >? ? ? ?}
>     >?
>     >? ? ? ?err = dev_open(cfg.c_img_path);
>     >? ? ? ?if (err) {
>     >? ? ? ? ? ? ? ?usage();
>     > -? ? ? ? ? ? ?return 1;
>     > +? ? ? ? ? ? ?return err;
>     >? ? ? ?}
>     >?
>     >? ? ? ?erofs_show_config();
>     >?
>     >? ? ? ?sb_bh = erofs_buffer_init();
>     > +? ? ?if(IS_ERR(sb_bh)) {
>     > +? ? ? ? ? ? ?err = PTR_ERR(sb_bh);
>     > +? ? ? ? ? ? ?erofs_err("Failed to initialize super block buffer head : %s",
>     > +? ? ? ? ? ? ? ? ? ? ? ?erofs_strerror(err));
>     > +? ? ? ? ? ? ?goto exit;
>     > +? ? ?}
>     >? ? ? ?err = erofs_bh_balloon(sb_bh, EROFS_SUPER_END);
>     >? ? ? ?if (err < 0) {
>     >? ? ? ? ? ? ? ?erofs_err("Failed to balloon erofs_super_block: %s",
>     >
> 
