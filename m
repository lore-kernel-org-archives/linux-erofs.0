From: hch@lst.de (Christoph Hellwig)
Date: Tue, 20 Nov 2018 17:16:51 +0100
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com> <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
Message-ID: <20181120161651.GB2629@lst.de>

On Mon, Nov 19, 2018@04:49:27PM -0800, Sagi Grimberg wrote:
>
>> The only user in your final tree seems to be the loop driver, and
>> even that one only uses the helper for read/write bios.
>>
>> I think something like this would be much simpler in the end:
>
> The recently submitted nvme-tcp host driver should also be a user
> of this. Does it make sense to keep it as a helper then?

I did take a brief look at the code, and I really don't understand
why the heck it even deals with bios to start with.  Like all the
other nvme transports it is a blk-mq driver and should iterate
over segments in a request and more or less ignore bios.  Something
is horribly wrong in the design.
