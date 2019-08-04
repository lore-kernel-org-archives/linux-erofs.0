From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 4 Aug 2019 23:51:15 +0800
Subject: [PATCH v2] erofs-utils: code for handling incorrect debug level.
In-Reply-To: <08f63a50-105c-d97a-8db1-db486e9616a2@gmail.com>
References: <20190804081943.20666-1-pratikshinde320@gmail.com>
 <20190804101644.GA19667@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CAGu0czRmt9X7yPmhj=7umo3wPoAt3Z_V2hYGV==kb2eohy2Skw@mail.gmail.com>
 <20190804113130.GA3993@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CAGu0czSs3jPuQGqHsravmR9ta0qyQUsP9pah7XieQzjj8Rz5uw@mail.gmail.com>
 <c07418b2-f8d7-8e9a-487b-99ffb1d18ad5@gmail.com>
 <20190804152547.GB6233@hsiangkao-HP-ZHAN-66-Pro-G1>
 <08f63a50-105c-d97a-8db1-db486e9616a2@gmail.com>
Message-ID: <20190804154951.GA7446@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Guifu,

On Sun, Aug 04, 2019@11:41:47PM +0800, Li Guifu wrote:
> GAO
> 	it's a good suggest, you're right

I know that you don't have outgoing email permission when you are at work.
I think you need to request this permission from your boss again.

And could you take some spare time off work and review erofs-utils patches?
That is of great help to erofs community. :)

Thanks,
Gao Xiang

> 
> ?? 2019/8/4 23:25, Gao Xiang ????:
> > Hi Guifu,
> > 
> > On Sun, Aug 04, 2019@08:57:58PM +0800, Li Guifu wrote:
> > > Shinde and Gao
> > >   Does the variable name of debug level use another name ? like d ?
> > >   The i is usual a temporary increase or decrease self variable.
> > 
> > I think we can use a common varible name in order to avoid
> > too many temporary variables, maybe `i' is not the best
> > naming, but `i' also stands for "a integer".
> > 
> > Maybe we can give a better naming? can you name it and
> > submit another patch? I personally don't like define too
> > many used-once variables... How do you think?
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > ?? 2019/8/4 19:39, Pratik Shinde ????:
> > > > Hi Gao,
> > > > 
> > > > I Agree with your suggestion. Thanks for the additional code change. I
> > > > think thats pretty much our final patch. :)
> > > > 
> > > > -Pratik
> > > > 
> > > > On Sun, 4 Aug, 2019, 5:01 PM Gao Xiang, <hsiangkao@gmx.com> wrote:
> > > > 
> > > > > Hi Pratik,
> > > > > 
> > > > > On Sun, Aug 04, 2019@04:03:49PM +0530, Pratik Shinde wrote:
> > > > > > Hi Gao,
> > > > > > 
> > > > > > I used fprintf here because we are printing this error message in case of
> > > > > > invalid 'cfg.c_dbg_lvl'. Hence I thought
> > > > > > we cannot rely on erofs_err().
> > > > > > e.g
> > > > > > $ mkfs.erofs -d -1 <erofs image> <directory>
> > > > > > In this case debug level is '-1' which is invalid.If we try to print the
> > > > > > error message using erofs_err() with c_dbg_lvl = -1,
> > > > > > it will not print anything.
> > > > > 
> > > > > Yes, so c_dbg_lvl should be kept in default level (0) before
> > > > > checking its vaildity I think.
> > > > > 
> > > > > > While applying the minor fixup, just reset the c_dbg_lvl to 0 , so that
> > > > > > erofs_err() will be able to log the error message.
> > > > > 
> > > > > Since there could be some messages already printed with erofs_xxx before
> > > > > mkfs_parse_options_cfg(), I think we can use default level (0) before
> > > > > checking its vaildity and switch to the given level after it, as below:
> > > > > 
> > > > >                   case 'd':
> > > > > -                       cfg.c_dbg_lvl = parse_num_from_str(optarg);
> > > > > +                       i = atoi(optarg);
> > > > > +                       if (i < EROFS_MSG_MIN || i > EROFS_MSG_MAX) {
> > > > > +                               erofs_err("invalid debug level %d", i);
> > > > > +                               return -EINVAL;
> > > > > +                       }
> > > > > +                       cfg.c_dbg_lvl = i;
> > > > > 
> > > > > 
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?h=dev&id=26097242976cce68e21d8b569dfda63fb68f356c
> > > > > 
> > > > > Do you agree? :)
> > > > > 
> > > > > Thanks,
> > > > > Gao Xiang
> > > > > 
> > > > > > 
> > > > > > --Pratik.
> > > > > > 
> > > > > > 
> > > > > > On Sun, Aug 4, 2019@3:47 PM Gao Xiang <hsiangkao@aol.com> wrote:
> > > > > > 
> > > > > > > On Sun, Aug 04, 2019@01:49:43PM +0530, Pratik Shinde wrote:
> > > > > > > > handling the case of incorrect debug level.
> > > > > > > > Added an enumerated type for supported debug levels.
> > > > > > > > Using 'atoi' in place of 'parse_num_from_str'.
> > > > > > > > 
> > > > > > > > Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
> > > > > > > > ---
> > > > > > > >    include/erofs/print.h | 18 +++++++++++++-----
> > > > > > > >    mkfs/main.c           | 19 ++++++++-----------
> > > > > > > >    2 files changed, 21 insertions(+), 16 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/include/erofs/print.h b/include/erofs/print.h
> > > > > > > > index bc0b8d4..296cbbf 100644
> > > > > > > > --- a/include/erofs/print.h
> > > > > > > > +++ b/include/erofs/print.h
> > > > > > > > @@ -12,6 +12,15 @@
> > > > > > > >    #include "config.h"
> > > > > > > >    #include <stdio.h>
> > > > > > > > 
> > > > > > > > +enum {
> > > > > > > > +     EROFS_MSG_MIN = 0,
> > > > > > > > +     EROFS_ERR     = 0,
> > > > > > > > +     EROFS_WARN    = 2,
> > > > > > > > +     EROFS_INFO    = 3,
> > > > > > > > +     EROFS_DBG     = 7,
> > > > > > > > +     EROFS_MSG_MAX = 9
> > > > > > > > +};
> > > > > > > > +
> > > > > > > >    #define FUNC_LINE_FMT "%s() Line[%d] "
> > > > > > > > 
> > > > > > > >    #ifndef pr_fmt
> > > > > > > > @@ -19,7 +28,7 @@
> > > > > > > >    #endif
> > > > > > > > 
> > > > > > > >    #define erofs_dbg(fmt, ...) do {                             \
> > > > > > > > -     if (cfg.c_dbg_lvl >= 7) {                               \
> > > > > > > > +     if (cfg.c_dbg_lvl >= EROFS_DBG) {                       \
> > > > > > > >                 fprintf(stdout,                                 \
> > > > > > > >                         pr_fmt(fmt),                            \
> > > > > > > >                         __func__,                               \
> > > > > > > > @@ -29,7 +38,7 @@
> > > > > > > >    } while (0)
> > > > > > > > 
> > > > > > > >    #define erofs_info(fmt, ...) do {                            \
> > > > > > > > -     if (cfg.c_dbg_lvl >= 3) {                               \
> > > > > > > > +     if (cfg.c_dbg_lvl >= EROFS_INFO) {                      \
> > > > > > > >                 fprintf(stdout,                                 \
> > > > > > > >                         pr_fmt(fmt),                            \
> > > > > > > >                         __func__,                               \
> > > > > > > > @@ -40,7 +49,7 @@
> > > > > > > >    } while (0)
> > > > > > > > 
> > > > > > > >    #define erofs_warn(fmt, ...) do {                            \
> > > > > > > > -     if (cfg.c_dbg_lvl >= 2) {                               \
> > > > > > > > +     if (cfg.c_dbg_lvl >= EROFS_WARN) {                      \
> > > > > > > >                 fprintf(stdout,                                 \
> > > > > > > >                         pr_fmt(fmt),                            \
> > > > > > > >                         __func__,                               \
> > > > > > > > @@ -51,7 +60,7 @@
> > > > > > > >    } while (0)
> > > > > > > > 
> > > > > > > >    #define erofs_err(fmt, ...) do {                             \
> > > > > > > > -     if (cfg.c_dbg_lvl >= 0) {                               \
> > > > > > > > +     if (cfg.c_dbg_lvl >= EROFS_ERR) {                       \
> > > > > > > >                 fprintf(stderr,                                 \
> > > > > > > >                         "Err: " pr_fmt(fmt),                    \
> > > > > > > >                         __func__,                               \
> > > > > > > > @@ -64,4 +73,3 @@
> > > > > > > > 
> > > > > > > > 
> > > > > > > >    #endif
> > > > > > > > -
> > > > > > > > diff --git a/mkfs/main.c b/mkfs/main.c
> > > > > > > > index fdb65fd..d915d00 100644
> > > > > > > > --- a/mkfs/main.c
> > > > > > > > +++ b/mkfs/main.c
> > > > > > > > @@ -30,16 +30,6 @@ static void usage(void)
> > > > > > > >         fprintf(stderr, " -EX[,...] X=extended options\n");
> > > > > > > >    }
> > > > > > > > 
> > > > > > > > -u64 parse_num_from_str(const char *str)
> > > > > > > > -{
> > > > > > > > -     u64 num      = 0;
> > > > > > > > -     char *endptr = NULL;
> > > > > > > > -
> > > > > > > > -     num = strtoull(str, &endptr, 10);
> > > > > > > > -     BUG_ON(num == ULLONG_MAX);
> > > > > > > > -     return num;
> > > > > > > > -}
> > > > > > > > -
> > > > > > > >    static int parse_extended_opts(const char *opts)
> > > > > > > >    {
> > > > > > > >    #define MATCH_EXTENTED_OPT(opt, token, keylen) \
> > > > > > > > @@ -108,7 +98,14 @@ static int mkfs_parse_options_cfg(int argc, char
> > > > > > > *argv[])
> > > > > > > >                         break;
> > > > > > > > 
> > > > > > > >                 case 'd':
> > > > > > > > -                     cfg.c_dbg_lvl = parse_num_from_str(optarg);
> > > > > > > > +                     cfg.c_dbg_lvl = atoi(optarg);
> > > > > > > > +                     if (cfg.c_dbg_lvl < EROFS_MSG_MIN
> > > > > > > > +                         || cfg.c_dbg_lvl > EROFS_MSG_MAX) {
> > > > > > > > +                             fprintf(stderr,
> > > > > > > > +                                     "invalid debug level %d\n",
> > > > > > > > +                                     cfg.c_dbg_lvl);
> > > > > > > 
> > > > > > > How about using erofs_err as my previous patch attached?
> > > > > > > I wonder if there are some specfic reasons to directly use fprintf
> > > > > instead?
> > > > > > > 
> > > > > > > I will apply it with this minor fixup (no need to resend again), if you
> > > > > > > have
> > > > > > > other considerations, reply me in this thread, thanks. :)
> > > > > > > 
> > > > > > > Thanks,
> > > > > > > Gao Xiang
> > > > > > > 
> > > > > > > > +                             return -EINVAL;
> > > > > > > > +                     }
> > > > > > > >                         break;
> > > > > > > > 
> > > > > > > >                 case 'E':
> > > > > > > > --
> > > > > > > > 2.9.3
> > > > > > > > 
> > > > > > > 
> > > > > 
> > > > 
