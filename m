From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 8 Aug 2019 12:26:42 +0800
Subject: [PATCH 10/13] iomap: use a function pointer for dio submits
In-Reply-To: <20190805215458.GH7689@dread.disaster.area>
References: <20190802220048.16142-1-rgoldwyn@suse.de>
 <20190802220048.16142-11-rgoldwyn@suse.de>
 <20190804234321.GC7689@dread.disaster.area>
 <1565021323.13240.14.camel@suse.com>
 <20190805215458.GH7689@dread.disaster.area>
Message-ID: <20190808042640.GA28630@138>

On Tue, Aug 06, 2019@07:54:58AM +1000, Dave Chinner wrote:
> On Mon, Aug 05, 2019@04:08:43PM +0000, Goldwyn Rodrigues wrote:
> > On Mon, 2019-08-05@09:43 +1000, Dave Chinner wrote:
> > > On Fri, Aug 02, 2019@05:00:45PM -0500, Goldwyn Rodrigues wrote:
> > > > From: Goldwyn Rodrigues <rgoldwyn at suse.com>
> > > > 
> > > > This helps filesystems to perform tasks on the bio while
> > > > submitting for I/O. Since btrfs requires the position
> > > > we are working on, pass pos to iomap_dio_submit_bio()
> > > > 
> > > > The correct place for submit_io() is not page_ops. Would it
> > > > better to rename the structure to something like iomap_io_ops
> > > > or put it directly under struct iomap?
> > > > 
> > > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn at suse.com>
> > > > ---
> > > >  fs/iomap/direct-io.c  | 16 +++++++++++-----
> > > >  include/linux/iomap.h |  1 +
> > > >  2 files changed, 12 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > > > index 5279029c7a3c..a802e66bf11f 100644
> > > > --- a/fs/iomap/direct-io.c
> > > > +++ b/fs/iomap/direct-io.c
> > > > @@ -59,7 +59,7 @@ int iomap_dio_iopoll(struct kiocb *kiocb, bool
> > > > spin)
> > > >  EXPORT_SYMBOL_GPL(iomap_dio_iopoll);
> > > >  
> > > >  static void iomap_dio_submit_bio(struct iomap_dio *dio, struct
> > > > iomap *iomap,
> > > > -		struct bio *bio)
> > > > +		struct bio *bio, loff_t pos)
> > > >  {
> > > >  	atomic_inc(&dio->ref);
> > > >  
> > > > @@ -67,7 +67,13 @@ static void iomap_dio_submit_bio(struct
> > > > iomap_dio *dio, struct iomap *iomap,
> > > >  		bio_set_polled(bio, dio->iocb);
> > > >  
> > > >  	dio->submit.last_queue = bdev_get_queue(iomap->bdev);
> > > > -	dio->submit.cookie = submit_bio(bio);
> > > > +	if (iomap->page_ops && iomap->page_ops->submit_io) {
> > > > +		iomap->page_ops->submit_io(bio, file_inode(dio-
> > > > >iocb->ki_filp),
> > > > +				pos);
> > > > +		dio->submit.cookie = BLK_QC_T_NONE;
> > > > +	} else {
> > > > +		dio->submit.cookie = submit_bio(bio);
> > > > +	}
> > > 
> > > I don't really like this at all. Apart from the fact it doesn't work
> > > with block device polling (RWF_HIPRI), the iomap architecture is
> > 
> > That can be added, no? Should be relayed when we clone the bio.
> 
> No idea how that all is supposed to work when you split a single bio
> into multiple bios. I'm pretty sure the iomap code is broken for
> that case, too -  Jens was silent on how to fix other than to say
> "it wasn't important so we didn't care to make sure it worked". So
> it's not clear to me exactly how block polling is supposed to work
> when a an IO needs to be split into multiple submissions...
> 
> > > supposed to resolve the file offset -> block device + LBA mapping
> > > completely up front and so all that remains to be done is build and
> > > submit the bio(s) to the block device.
> > > 
> > > What I see here is a hack to work around the fact that btrfs has
> > > implemented both file data transformations and device mapping layer
> > > functionality as a filesystem layer between file data bio building
> > > and device bio submission. And as the btrfs file data mapping
> > > (->iomap_begin) is completely unaware that there is further block
> > > mapping to be done before block device bio submission, any generic
> > > code that btrfs uses requires special IO submission hooks rather
> > > than just calling submit_bio().
> > > 
> > > I'm not 100% sure what the solution here is, but the one thing we
> > > must resist is turning the iomap code into a mess of custom hooks
> > > that only one filesystem uses. We've been taught this lesson time
> > > and time again - the iomap infrastructure exists because stuff like
> > > bufferheads and the old direct IO code ended up so full of special
> > > case code that it ossified and became unmodifiable and
> > > unmaintainable.
> > > 
> > > We do not want to go down that path again. 
> > > 
> > > IMO, the iomap IO model needs to be restructured to support post-IO
> > > and pre-IO data verification/calculation/transformation operations
> > > so all the work that needs to be done at the inode/offset context
> > > level can be done in the iomap path before bio submission/after
> > > bio completion. This will allow infrastructure like fscrypt, data
> > > compression, data checksums, etc to be suported generically, not
> > > just by individual filesystems that provide a ->submit_io hook.
> > > 
> > > As for the btrfs needing to slice and dice bios for multiple
> > > devices?  That should be done via a block device ->make_request
> > > function, not a custom hook in the iomap code.
> > 
> > btrfs differentiates the way how metadata and data is
> > handled/replicated/stored. We would still need an entry point in the
> > iomap code to handle the I/O submission.
> 
> This is a data IO path. How metadata is stored/replicated is
> irrelevant to this code path...
> 
> > > That's why I don't like this hook - I think hiding data operations
> > > and/or custom bio manipulations in opaque filesystem callouts is
> > > completely the wrong approach to be taking. We need to do these
> > > things in a generic manner so that all filesystems (and block
> > > devices!) that use the iomap infrastructure can take advantage of
> > > them, not just one of them.
> > > 
> > > Quite frankly, I don't care if it takes more time and work up front,
> > > I'm tired of expedient hacks to merge code quickly repeatedly biting
> > > us on the arse and wasting far more time sorting out than we would
> > > have spent getting it right in the first place.
> > 
> > Sure. I am open to ideas. What are you proposing?
> 
> That you think about how to normalise the btrfs IO path to fit into
> the standard iomap/blockdev model, rather than adding special hacks
> to iomap to allow an opaque, custom, IO model to be shoe-horned into
> the generic code.
> 
> For example, post-read validation requires end-io processing,
> whether it be encryption, decompression, CRC/T10 validation, etc. The
> iomap end-io completion has all the information needed to run these
> things, whether it be a callout to the filesystem for custom
> processing checking, or a generic "decrypt into supplied data page"
> sort of thing. These all need to be done in the same place, so we
> should have common support for this. And I suspect the iomap should
> also state in a flag that something like this is necessary (e.g.
> IOMAP_FL_ENCRYPTED indicates post-IO decryption needs to be run).

Add some word to this topic, I think introducing a generic full approach
to IOMAP for encryption, decompression, verification is hard to meet all
filesystems, and seems unnecessary, especially data compression is involved.

Since the data decompression will expand the data, therefore the logical
data size is not same as the physical data size:

1) IO submission should be applied to all physical data, but data
   decompression will be eventually applied to logical mapping.
   As for EROFS, it submits all physical pages with page->private
   points to management structure which maintain all logical pages
   as well for further decompression. And time-sharing approach is
   used to save the L2P mapping array in these allocated pages itself.

   In addition, IOMAP also needs to consider fixed-sized output/input
   difference which is filesystem specific and I have no idea whether
   involveing too many code for each requirement is really good for IOMAP;

2) The post-read processing order is another negotiable stuff.
   Although there is no benefit to select verity->decrypt rather than
   decrypt->verity; but when compression is involved, the different
   orders could be selected by different filesystem users:

    1. decrypt->verity->decompress

    2. verity->decompress->decrypt

    3. decompress->decrypt->verity

   1. and 2. could cause less computation since it processes
   compressed data, and the security is good enough since
   the behavior of decompression algorithm is deterministic.
   3 could cause more computation.

All I want to say is the post process is so complicated since we have
many selection if encryption, decompression, verification are all involved.

Maybe introduce a core subset to IOMAP is better for long-term
maintainment and better performance. And we should consider it
more carefully.

Thanks,
Gao Xiang

> 
> Similarly, on the IO submit side we have need for a pre-IO
> processing hook. That can be used to encrypt, compress, calculate
> data CRCs, do pre-IO COW processing (XFS requires a hook for this),
> etc.
> 
> These hooks are needed for for both buffered and direct IO, and they
> are needed for more filesystems than just btrfs. fscrypt will need
> them, XFS needs them, etc. So rather than hide data CRCs,
> compression, and encryption deep inside the btrfs code, pull it up
> into common layers that are called by the generic code. THis will
> leave with just the things like mirroring, raid, IO retries, etc
> below the iomap code, and that's all stuff that can be done behind a
> ->make_request function that is passed a bio...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david at fromorbit.com
