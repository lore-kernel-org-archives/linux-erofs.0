From: sagi@grimberg.me (Sagi Grimberg)
Date: Tue, 20 Nov 2018 21:35:07 -0800
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <20181121050359.GA31915@ming.t460p>
References: <20181115085306.9910-10-ming.lei@redhat.com>
 <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
 <20181121034415.GA8408@ming.t460p>
 <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
 <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>
 <20181121050359.GA31915@ming.t460p>
Message-ID: <fc268b0e-61b5-aacc-67be-cb7b266c6d8f@grimberg.me>


>> Wait, I see that the bvec is still a single array per bio. When you said
>> a table I thought you meant a 2-dimentional array...
> 
> I mean a new 1-d table A has to be created for multiple bios in one rq,
> and build it in the following way
> 
>             rq_for_each_bvec(tmp, rq, rq_iter)
>                      *A = tmp;
> 
> Then you can pass A to iov_iter_bvec() & send().
> 
> Given it is over TCP, I guess it should be doable for you to preallocate one
> 256-bvec table in one page for each request, then sets the max segment size as
> (unsigned int)-1, and max segment number as 256, the preallocated table
> should work anytime.

256 bvec table is really a lot to preallocate, especially when its not
needed, I can easily initialize the bvec_iter on the bio bvec. If this
involves preallocation of the worst-case than I don't consider this to
be an improvement.
