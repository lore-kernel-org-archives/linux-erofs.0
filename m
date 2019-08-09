From: willy@infradead.org (Matthew Wilcox)
Date: Fri, 9 Aug 2019 13:45:17 -0700
Subject: [PATCH 10/13] iomap: use a function pointer for dio submits
In-Reply-To: <20190808054936.GA5319@sol.localdomain>
References: <20190802220048.16142-1-rgoldwyn@suse.de>
 <20190802220048.16142-11-rgoldwyn@suse.de>
 <20190804234321.GC7689@dread.disaster.area>
 <1565021323.13240.14.camel@suse.com>
 <20190805215458.GH7689@dread.disaster.area>
 <20190808042640.GA28630@138>
 <20190808054936.GA5319@sol.localdomain>
Message-ID: <20190809204517.GR5482@bombadil.infradead.org>

On Wed, Aug 07, 2019@10:49:36PM -0700, Eric Biggers wrote:
> On Thu, Aug 08, 2019@12:26:42PM +0800, Gao Xiang wrote:
> >     1. decrypt->verity->decompress
> > 
> >     2. verity->decompress->decrypt
> > 
> >     3. decompress->decrypt->verity
> > 
> >    1. and 2. could cause less computation since it processes
> >    compressed data, and the security is good enough since
> >    the behavior of decompression algorithm is deterministic.
> >    3 could cause more computation.
> > 
> > All I want to say is the post process is so complicated since we have
> > many selection if encryption, decompression, verification are all involved.
> > 
> > Maybe introduce a core subset to IOMAP is better for long-term
> > maintainment and better performance. And we should consider it
> > more carefully.
> > 
> 
> FWIW, the only order that actually makes sense is decrypt->decompress->verity.

That used to be true, but a paper in 2004 suggested it's not true.
Further work in this space in 2009 based on block ciphers:
https://arxiv.org/pdf/1009.1759

It looks like it'd be computationally expensive to do, but feasible.

> Decrypt before decompress, i.e. encrypt after compress, because only the
> plaintext can be compressible; the ciphertext isn't.
