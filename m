From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 8 Aug 2019 19:21:39 +0800
Subject: [PATCH 10/13] iomap: use a function pointer for dio submits
In-Reply-To: <20190808091632.GF28630@138>
References: <20190802220048.16142-1-rgoldwyn@suse.de>
 <20190802220048.16142-11-rgoldwyn@suse.de>
 <20190804234321.GC7689@dread.disaster.area>
 <1565021323.13240.14.camel@suse.com>
 <20190805215458.GH7689@dread.disaster.area>
 <20190808042640.GA28630@138>
 <20190808054936.GA5319@sol.localdomain>
 <20190808081647.GI7689@dread.disaster.area>
 <20190808091632.GF28630@138>
Message-ID: <20190808112139.GG28630@138>

On Thu, Aug 08, 2019@05:29:47PM +0800, Gao Xiang wrote:
> On Thu, Aug 08, 2019@06:16:47PM +1000, Dave Chinner wrote:
> > On Wed, Aug 07, 2019@10:49:36PM -0700, Eric Biggers wrote:
> > > FWIW, the only order that actually makes sense is decrypt->decompress->verity.
> > 
> > *nod*
> > 
> > Especially once we get the inline encryption support for fscrypt so
> > the storage layer can offload the encrypt/decrypt to hardware via
> > the bio containing plaintext. That pretty much forces fscrypt to be
> > the lowest layer of the filesystem transformation stack.  This
> > hardware offload capability also places lots of limits on what you
> > can do with block-based verity layers below the filesystem. e.g.
> > using dm-verity when you don't know if there's hardware encryption
> > below or software encryption on top becomes problematic...

...and I'm not talking of fs-verity, I personally think fs-verity
is great. I am only talking about a generic stuff.

In order to know which level becomes problematic, there even could
be another choice "decrypt->verity1->decompress->verity2" for such
requirement (assuming verity1/2 themselves are absolutely bug-free),
verity1 can be a strong merkle tree and verity2 is a weak form (just
like a simple Adler-32/crc32 in compressed block), thus we can locate
whether it's a decrypt or decompress bug.

Many compression algorithm containers already have such a weak
form such as gzip algorithm, so there is no need to add such
an extra step to postprocess.

and I have no idea which (decrypt->verity1->decompress->verity2 or
decrypt->decompress->verity) is faster since verity2 is rather simple.
However, if we use the only strong form in the end, there could be
a lot of extra IO and expensive multiple-level computations if files
are highly compressible.

On the other hand, such verity2 can be computed offline / avoided
by fuzzer tools for read-only scenerios (for example, after building
these images and do a full image verification with the given kernel)
in order to make sure its stability (In any case, I'm talking about
how to make those algorithms bug-free).

All I want to say is I think "decrypt->verity->decompress" is
reasonable as well.

Thanks,
Gao Xiang

> 
> Add a word, I was just talking benefits between "decrypt->decompress->
> verity" and "decrypt->verity->decompress", I think both forms are
> compatible with inline en/decryption. I don't care which level
> "decrypt" is at... But maybe some user cares. Am I missing something?
> 
> Thanks,
> Gao Xiang
> 
