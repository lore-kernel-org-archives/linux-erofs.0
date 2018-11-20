From: ying.huang@intel.com (Huang, Ying)
Date: Tue, 20 Nov 2018 10:45:03 +0800
Subject: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
In-Reply-To: <20181119090415.GM16736@ming.t460p> (Ming Lei's message of "Mon, 
 19 Nov 2018 17:04:16 +0800")
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-16-ming.lei@redhat.com>
 <20181116015936.GJ23828@vader> <20181119090415.GM16736@ming.t460p>
Message-ID: <87o9ak8o28.fsf@yhuang-dev.intel.com>

Ming Lei <ming.lei at redhat.com> writes:

> On Thu, Nov 15, 2018@05:59:36PM -0800, Omar Sandoval wrote:
>> On Thu, Nov 15, 2018@04:53:02PM +0800, Ming Lei wrote:
>> > Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
>> > increase BIO_MAX_PAGES for it.
>> 
>> You mentioned to it in the cover letter, but this needs more explanation
>> in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
>> multipage bvecs remove that requirement?
>
> CONFIG_THP_SWAP needs to split one TH page into normal pages and adds
> them all to one bio. With multipage-bvec, it just takes one bvec to
> hold them all.

Yes.  CONFIG_THP_SWAP needs to put 512 normal sub-pages into one bio to
write the 512 sub-pages together.  With the help of multipage-bvec, it
needs just bvect to hold 512 normal sub-pages.

Best Regards,
Huang, Ying

> thanks,
> Ming
