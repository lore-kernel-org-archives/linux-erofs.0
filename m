From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 23 Jan 2019 14:55:32 +0800
Subject: [LSF/MM TOPIC] EROFS, our smartphone practice and the next
Message-ID: <f44b1696-2f73-3637-9964-d73e3d5832b7@huawei.com>

Hi,

Our team would like to give a topic about EROFS real practice in
our HUAWEI smartphone in the past 2018 year.

Actually, we attempted to apply data compression technology on our
consumer electronics with very limited memory, but to provide high
performance in order to keep great user experience. 

We tried squashfs 3 years ago with no luck since it causes serious
memory issue on our internal heavy workload and internal beta test
(ex, Camera opening), it still behaves poor after turning down its
blocksize to reduce its read amplification.

After some research on squashfs, we found that its fundamental on-disk
format could be better and more flexable since its (meta)data cannot
be designed inline and its directory structure cannot perform well
in random name lookup.

And we also observed some efforts to tune squashfs from Google and they
ran into a stone wall [1]. Therefore, instead of keeping the historical
burden, we planned to design a more lightweight filesystem than squashfs
with modern features and high performance to build better products and
serve our consumers, EROFS.

Actually EROFS is designed as a better filesystem solution for the
following scenarios:
 - read-only storage media or

 - part of a fully trusted read-only solution, which means it needs to
   be immutable and bit-for-bit identical to the official golden image
   for their releases due to security and other considerations and

 - hope to save some extra storage space with guaranteed end-to-end
   performance by using reduced metadata and transparent file
   compression, especially for those embedded devices with limited
   memory (ex, smartphone);

and the document (first release) is also available at [2]. A rather
simple on-disk format, fixed-output compression and in-place decompression
are introduced in EROFS by design.

In this topic, we would like to share the issue and experience of real-time
decompression in these consumer embeded devices, EROFS detailed design,
benchmark, testdata when landing EROFS to our smartphones, and comparsion
with exist squashfs, compressed btrfs, etc... These all can be shown
months after.

We also would like to discuss our EROFS future roadmap including but not
limited to:
 - Decompression tuning;
 - Data encryption (used as a part of tamper resistance);
 - Data deduplication;
 - More compression algorithms other than lz4;
 - (Selectable) bootloader & FUSE support only for compatibility and other OSs;
 - ...

and HUAWEI kernel storage team will keep actively contributing and expend
it to more widely scenarios. We also hope that more people could join us to
make EROFS better since there are still a lot of stuffs to do. 

Thanks,

[1] https://lkml.org/lkml/2017/9/22/814
[2] https://lists.ozlabs.org/pipermail/linux-erofs/2019-January/001242.html
