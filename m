From: hch@lst.de (Christoph Hellwig)
Date: Wed, 21 Nov 2018 09:46:08 +0100
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <fc268b0e-61b5-aacc-67be-cb7b266c6d8f@grimberg.me>
References: <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
 <20181121034415.GA8408@ming.t460p>
 <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
 <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>
 <20181121050359.GA31915@ming.t460p>
 <fc268b0e-61b5-aacc-67be-cb7b266c6d8f@grimberg.me>
Message-ID: <20181121084608.GA29622@lst.de>

On Tue, Nov 20, 2018@09:35:07PM -0800, Sagi Grimberg wrote:
>> Given it is over TCP, I guess it should be doable for you to preallocate one
>> 256-bvec table in one page for each request, then sets the max segment size as
>> (unsigned int)-1, and max segment number as 256, the preallocated table
>> should work anytime.
>
> 256 bvec table is really a lot to preallocate, especially when its not
> needed, I can easily initialize the bvec_iter on the bio bvec. If this
> involves preallocation of the worst-case than I don't consider this to
> be an improvement.

Ok, I took a look at the nvme-tcp code and it seems you care about
bios because you want a contiguos bio chunk for sending it down
the networking code.  Yes, in that case we sort of need to iterate
over bios.  But you already have a special case for discard, so you
don't really need any of the magic in the bio_bvecs() helper either
can can just count bi_vcnt in the bio.
