From: sagi@grimberg.me (Sagi Grimberg)
Date: Mon, 19 Nov 2018 16:49:27 -0800
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <20181116134541.GH3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com> <20181116134541.GH3165@lst.de>
Message-ID: <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>


> The only user in your final tree seems to be the loop driver, and
> even that one only uses the helper for read/write bios.
> 
> I think something like this would be much simpler in the end:

The recently submitted nvme-tcp host driver should also be a user
of this. Does it make sense to keep it as a helper then?
