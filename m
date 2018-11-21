From: sagi@grimberg.me (Sagi Grimberg)
Date: Tue, 20 Nov 2018 20:42:04 -0800
Subject: [PATCH V10 09/19] block: introduce bio_bvecs()
In-Reply-To: <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com> <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
 <20181121034415.GA8408@ming.t460p>
 <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
Message-ID: <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>


>> Yeah, that is the most common example, given merge is enabled
>> in most of cases. If the driver or device doesn't care merge,
>> you can disable it and always get single bio request, then the
>> bio's bvec table can be reused for send().
> 
> Does bvec_iter span bvecs with your patches? I didn't see that change?

Wait, I see that the bvec is still a single array per bio. When you said
a table I thought you meant a 2-dimentional array...

Unless I'm not mistaken, I think that the change is pretty simple then.
However, nvme-tcp still needs to be bio aware unless we have some
abstraction in place.. Which will mean that nvme-tcp will need to
open-code bio_bvecs.
