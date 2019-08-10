From: ebiggers@kernel.org (Eric Biggers)
Date: Fri, 9 Aug 2019 17:31:36 -0700
Subject: [PATCH 10/13] iomap: use a function pointer for dio submits
In-Reply-To: <20190809234554.GA25734@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190802220048.16142-1-rgoldwyn@suse.de>
 <20190802220048.16142-11-rgoldwyn@suse.de>
 <20190804234321.GC7689@dread.disaster.area>
 <1565021323.13240.14.camel@suse.com>
 <20190805215458.GH7689@dread.disaster.area>
 <20190808042640.GA28630@138>
 <20190808054936.GA5319@sol.localdomain>
 <20190809204517.GR5482@bombadil.infradead.org>
 <20190809234554.GA25734@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <20190810003135.GF100971@gmail.com>

On Sat, Aug 10, 2019@07:45:59AM +0800, Gao Xiang wrote:
> Hi Willy,
> 
> On Fri, Aug 09, 2019@01:45:17PM -0700, Matthew Wilcox wrote:
> > On Wed, Aug 07, 2019@10:49:36PM -0700, Eric Biggers wrote:
> > > On Thu, Aug 08, 2019@12:26:42PM +0800, Gao Xiang wrote:
> > > >     1. decrypt->verity->decompress
> > > > 
> > > >     2. verity->decompress->decrypt
> > > > 
> > > >     3. decompress->decrypt->verity
> > > > 
> > > >    1. and 2. could cause less computation since it processes
> > > >    compressed data, and the security is good enough since
> > > >    the behavior of decompression algorithm is deterministic.
> > > >    3 could cause more computation.
> > > > 
> > > > All I want to say is the post process is so complicated since we have
> > > > many selection if encryption, decompression, verification are all involved.
> > > > 
> > > > Maybe introduce a core subset to IOMAP is better for long-term
> > > > maintainment and better performance. And we should consider it
> > > > more carefully.
> > > > 
> > > 
> > > FWIW, the only order that actually makes sense is decrypt->decompress->verity.
> > 
> > That used to be true, but a paper in 2004 suggested it's not true.
> > Further work in this space in 2009 based on block ciphers:
> > https://arxiv.org/pdf/1009.1759
> > 
> > It looks like it'd be computationally expensive to do, but feasible.
> 
> Yes, maybe someone cares where encrypt is at due to their system design.
> 
> and I thought over these days, I have to repeat my thought of verity
> again :( the meaningful order ought to be "decrypt->verity->decompress"
> rather than "decrypt->decompress->verity" if compression is involved.
> 
> since most (de)compress algorithms are complex enough (allocate memory and
> do a lot of unsafe stuffes such as wildcopy) and even maybe unsafe by its
> design, we cannot do verity in the end for security consideration thus
> the whole system can be vulnerable by this order from malformed on-disk
> data. In other words, we need to verify on compressed data.
> 
> Fsverity is fine for me since most decrypt algorithms is stable and reliable
> and no compression by its design, but if some decrypt software algorithms is
> complicated enough, I'd suggest "verity->decrypt" as well to some extent.
> 
> Considering transformation "A->B->C->D->....->verity", if any of "A->B->C
> ->D->..." is attacked by the malformed on-disk data... It would crash or
> even root the whole operating system.
> 
> All in all, we have to verify data earlier in order to get trusted data
> for later complex transformation chains.
> 
> The performance benefit I described in my previous email, it seems no need
> to say again... please take them into consideration and I think it's no
> easy to get a unique generic post-read order for all real systems.
> 

While it would be nice to protect against filesystem bugs, it's not the point of
fs-verity.  fs-verity is about authenticating the contents the *user* sees, so
that e.g. a file can be distributed to many computers and it can be
authenticated regardless of exactly what other filesystem features were used
when it was stored on disk.  Different computers may use:

- Different filesystems
- Different compression algorithms (or no compression)
- Different compression strengths, even with same algorithm
- Different divisions of the file into compression units
- Different encryption algorithms (or no encryption)
- Different encryption keys, even with same algorithm
- Different encryption nonces, even with same key

All those change the on-disk data; only the user-visible data stays the same.

Bugs in filesystems may also be exploited regardless of fs-verity, as the
attacker (able to manipulate on-disk image) can create a malicious file without
fs-verity enabled, somewhere else on the filesystem.

If you actually want to authenticate the full filesystem image, you need to use
dm-verity, which is designed for that.

- Eric
