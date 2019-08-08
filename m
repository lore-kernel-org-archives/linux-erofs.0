From: ebiggers@kernel.org (Eric Biggers)
Date: Wed, 7 Aug 2019 22:49:36 -0700
Subject: [PATCH 10/13] iomap: use a function pointer for dio submits
In-Reply-To: <20190808042640.GA28630@138>
References: <20190802220048.16142-1-rgoldwyn@suse.de>
 <20190802220048.16142-11-rgoldwyn@suse.de>
 <20190804234321.GC7689@dread.disaster.area>
 <1565021323.13240.14.camel@suse.com>
 <20190805215458.GH7689@dread.disaster.area>
 <20190808042640.GA28630@138>
Message-ID: <20190808054936.GA5319@sol.localdomain>

On Thu, Aug 08, 2019@12:26:42PM +0800, Gao Xiang wrote:
> > 
> > > > That's why I don't like this hook - I think hiding data operations
> > > > and/or custom bio manipulations in opaque filesystem callouts is
> > > > completely the wrong approach to be taking. We need to do these
> > > > things in a generic manner so that all filesystems (and block
> > > > devices!) that use the iomap infrastructure can take advantage of
> > > > them, not just one of them.
> > > > 
> > > > Quite frankly, I don't care if it takes more time and work up front,
> > > > I'm tired of expedient hacks to merge code quickly repeatedly biting
> > > > us on the arse and wasting far more time sorting out than we would
> > > > have spent getting it right in the first place.
> > > 
> > > Sure. I am open to ideas. What are you proposing?
> > 
> > That you think about how to normalise the btrfs IO path to fit into
> > the standard iomap/blockdev model, rather than adding special hacks
> > to iomap to allow an opaque, custom, IO model to be shoe-horned into
> > the generic code.
> > 
> > For example, post-read validation requires end-io processing,
> > whether it be encryption, decompression, CRC/T10 validation, etc. The
> > iomap end-io completion has all the information needed to run these
> > things, whether it be a callout to the filesystem for custom
> > processing checking, or a generic "decrypt into supplied data page"
> > sort of thing. These all need to be done in the same place, so we
> > should have common support for this. And I suspect the iomap should
> > also state in a flag that something like this is necessary (e.g.
> > IOMAP_FL_ENCRYPTED indicates post-IO decryption needs to be run).
> 
> Add some word to this topic, I think introducing a generic full approach
> to IOMAP for encryption, decompression, verification is hard to meet all
> filesystems, and seems unnecessary, especially data compression is involved.
> 
> Since the data decompression will expand the data, therefore the logical
> data size is not same as the physical data size:
> 
> 1) IO submission should be applied to all physical data, but data
>    decompression will be eventually applied to logical mapping.
>    As for EROFS, it submits all physical pages with page->private
>    points to management structure which maintain all logical pages
>    as well for further decompression. And time-sharing approach is
>    used to save the L2P mapping array in these allocated pages itself.
> 
>    In addition, IOMAP also needs to consider fixed-sized output/input
>    difference which is filesystem specific and I have no idea whether
>    involveing too many code for each requirement is really good for IOMAP;
> 
> 2) The post-read processing order is another negotiable stuff.
>    Although there is no benefit to select verity->decrypt rather than
>    decrypt->verity; but when compression is involved, the different
>    orders could be selected by different filesystem users:
> 
>     1. decrypt->verity->decompress
> 
>     2. verity->decompress->decrypt
> 
>     3. decompress->decrypt->verity
> 
>    1. and 2. could cause less computation since it processes
>    compressed data, and the security is good enough since
>    the behavior of decompression algorithm is deterministic.
>    3 could cause more computation.
> 
> All I want to say is the post process is so complicated since we have
> many selection if encryption, decompression, verification are all involved.
> 
> Maybe introduce a core subset to IOMAP is better for long-term
> maintainment and better performance. And we should consider it
> more carefully.
> 

FWIW, the only order that actually makes sense is decrypt->decompress->verity.

Decrypt before decompress, i.e. encrypt after compress, because only the
plaintext can be compressible; the ciphertext isn't.

Verity last, on the original data, because otherwise the file hash that
fs-verity reports would be specific to that particular inode on-disk and
therefore would be useless for authenticating the file's user-visible contents.

[By "verity" I mean specifically fs-verity.  Integrity-only block checksums are
a different case; those can be done at any point, but doing them on the
compressed data would make sense as then there would be less to checksum.

And yes, compression+encryption leaks information about the original data, so
may not be advisable.  My point is just that if the two are nevertheless
combined, it only makes sense to compress the plaintext.]

- Eric
