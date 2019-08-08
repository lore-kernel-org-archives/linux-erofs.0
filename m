From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 8 Aug 2019 17:29:47 +0800
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
Message-ID: <20190808091632.GF28630@138>

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

Add a word, I was just talking benefits between "decrypt->decompress->
verity" and "decrypt->verity->decompress", I think both forms are
compatible with inline en/decryption. I don't care which level
"decrypt" is at... But maybe some user cares. Am I missing something?

Thanks,
Gao Xiang
