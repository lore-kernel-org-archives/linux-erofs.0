From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 10:19:56 +0100
Subject: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
In-Reply-To: <20181115221847.GD9348@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com> <20181115202028.GC9348@vader>
 <20181115210510.GA24908@redhat.com> <20181115221847.GD9348@vader>
Message-ID: <20181116091956.GA17604@lst.de>

On Thu, Nov 15, 2018@02:18:47PM -0800, Omar Sandoval wrote:
> My only reason to prefer unsigned int is consistency. unsigned int is
> much more common in the kernel:
> 
> $ ag --cc -s 'unsigned\s+int' | wc -l
> 129632
> $ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
> 22435
> 
> checkpatch also warns on plain unsigned.

Talk about chicken and egg.  unsigned is perfectly valid C, and being
shorter often helps being more readable.  checkpath is as so often
wrongly opinionated..
