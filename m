From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 2 Aug 2019 14:14:30 +0800
Subject: [PATCH] erofs-utils: error handling for incorrect dbg lvl &
 compression algorithm
In-Reply-To: <CAGu0czT-HLnhAKQV6OhtgNu83fGDdHKu7+NZK15m-K7md3zVUQ@mail.gmail.com>
References: <20190801191809.13675-1-pratikshinde320@gmail.com>
 <20190802014323.GA3911@138>
 <CAGu0czT-HLnhAKQV6OhtgNu83fGDdHKu7+NZK15m-K7md3zVUQ@mail.gmail.com>
Message-ID: <20190802061430.GA11313@138>

[maybe better to add linux-erofs to record all the discusssions...]

On Fri, Aug 02, 2019@10:53:12AM +0530, Pratik Shinde wrote:
> Hi Gao,
> 
> I think you misunderstood, the code change is for 'debug level' and not
> 'compressor level'. whose valid range is 0-9.
> otherwise erofs_err() will not print anything.

Sorry... You are right and I think it is useful, but could you use another way
rather than hard-coded "0-9" directly? maybe we need to update
include/erofs/print.h as well to avoid hard-coded "such cfg.c_dbg_lvl >= 7"...

maybe it could be
enum {
	EROFS_ERR = 0,
	....
	EROFS_DEBUG = 9,
};

> Regarding the check for compressor algorithm name: the current code has no
> problem, I just thought it will be good
> valid it in mkfs_parse_options_cfg() itself. In the current code, its
> detected after we allocate entire super-block buffer.
> thats the reason why I mentioned  'early check'.

Hmmm... I think there are little difference, if it really needs,
how about adding a callback in compressor call .show_name()
to avoid hard-code as well...

(IMO, I think there is little difference checking in
z_erofs_compress_init() later, rare prople care about buffer init :)...)

Thanks,
Gao Xiang

> 
> --Pratik.
> 
> On Fri, Aug 2, 2019@7:13 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
> 
> > Hi Pratik,
> >
> > On Fri, Aug 02, 2019@12:48:09AM +0530, Pratik Shinde wrote:
> > > handling the case of incorrect debug level.
> > > also, an early check for valid compression algorithm.
> > >
> > > Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
> > > ---
> > >  mkfs/main.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/mkfs/main.c b/mkfs/main.c
> > > index fdb65fd..4231d13 100644
> > > --- a/mkfs/main.c
> > > +++ b/mkfs/main.c
> > > @@ -105,10 +105,22 @@ static int mkfs_parse_options_cfg(int argc, char
> > *argv[])
> > >                               }
> > >                       }
> > >                       cfg.c_compr_alg_master = strndup(optarg, i);
> > > +                     if (strcmp(cfg.c_compr_alg_master, "lz4")
> > > +                         && strcmp(cfg.c_compr_alg_master, "lz4hc")) {
> > > +                             erofs_err("invalid compressor algorithm
> > %s",
> > > +                                       cfg.c_comprz_erofs_compress_init_alg_master);
> > > +                             return -EINVAL;
> > > +                     }
> >
> > It should be do in the compressors, and we have:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/lib/compressor.c?h=dev#n74
> >
> > I'd like to know if some problems are out with the above code...
> >
> > >                       break;
> > >
> > >               case 'd':
> > >                       cfg.c_dbg_lvl = parse_num_from_str(optarg);
> > > +                     if (cfg.c_dbg_lvl < 0 || cfg.c_dbg_lvl > 9) {
> >
> > I think we cannot directly do like the above since
> > not all compression algorithm levels are 0~9 (and the default level could
> > be -1).
> > take a look at struct erofs_compressor and it has
> >         int default_level;
> >         int best_level;
> > I think maybe we have to define "worst_level" as well, and
> > it could be better do the above check in "int z_erofs_compress_init(void)"
> >
> > Thanks,
> > Gao Xiang
> >
> > > +                             fprintf(stderr,
> > > +                                     "invalid debug level %d\n",
> > > +                                     cfg.c_dbg_lvl);
> > > +                             return -EINVAL;
> > > +                     }
> > >                       break;
> > >
> > >               case 'E':
> > > --
> > > 2.9.3
> > >
> >
