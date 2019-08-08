From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 8 Aug 2019 16:57:45 +0800
Subject: [PATCH 10/13] iomap: use a function pointer for dio submits
In-Reply-To: <20190808081647.GI7689@dread.disaster.area>
References: <20190802220048.16142-1-rgoldwyn@suse.de>
 <20190802220048.16142-11-rgoldwyn@suse.de>
 <20190804234321.GC7689@dread.disaster.area>
 <1565021323.13240.14.camel@suse.com>
 <20190805215458.GH7689@dread.disaster.area>
 <20190808042640.GA28630@138>
 <20190808054936.GA5319@sol.localdomain>
 <20190808081647.GI7689@dread.disaster.area>
Message-ID: <20190808085745.GE28630@138>

Hi Dave,

On Thu, Aug 08, 2019@06:16:47PM +1000, Dave Chinner wrote:
> On Wed, Aug 07, 2019@10:49:36PM -0700, Eric Biggers wrote:
> > FWIW, the only order that actually makes sense is decrypt->decompress->verity.
> 
> *nod*
> 
> Especially once we get the inline encryption support for fscrypt so
> the storage layer can offload the encrypt/decrypt to hardware via
> the bio containing plaintext. That pretty much forces fscrypt to be
> the lowest layer of the filesystem transformation stack.  This
> hardware offload capability also places lots of limits on what you
> can do with block-based verity layers below the filesystem. e.g.
> using dm-verity when you don't know if there's hardware encryption
> below or software encryption on top becomes problematic...
> 
> So really, from a filesystem and iomap perspective, What Eric says
> is the right - it's the only order that makes sense...

Don't be surprised there will be a decrypt/verity/decompress
all-in-one hardware approach for such stuff. 30% random IO (no matter
hardware or software approach) can be saved that is greatly helpful
for user experience on embedded devices with too limited source.

and I really got a SHA256 CPU hardware bug years ago.

I don't want to talk more on tendency, it depends on real scenerio
and user selection (server or embedded device).

For security consideration, these approaches are all the same
level --- these approaches all from the same signed key and
storage source, all transformation A->B->C or A->C->B are equal.

For bug-free, we can fuzzer compression/verity algorithms even
the whole file-system stack. There is another case other than
security consideration.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david at fromorbit.com
