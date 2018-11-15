From: ming.lei@redhat.com (Ming Lei)
Date: Thu, 15 Nov 2018 16:53:03 +0800
Subject: [PATCH V10 16/19] block: document usage of bio iterator helpers
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
Message-ID: <20181115085306.9910-17-ming.lei@redhat.com>

Now multi-page bvec is supported, some helpers may return page by
page, meantime some may return segment by segment, this patch
documents the usage.

Cc: Dave Chinner <dchinner at redhat.com>
Cc: Kent Overstreet <kent.overstreet at gmail.com>
Cc: Mike Snitzer <snitzer at redhat.com>
Cc: dm-devel at redhat.com
Cc: Alexander Viro <viro at zeniv.linux.org.uk>
Cc: linux-fsdevel at vger.kernel.org
Cc: Shaohua Li <shli at kernel.org>
Cc: linux-raid at vger.kernel.org
Cc: linux-erofs at lists.ozlabs.org
Cc: David Sterba <dsterba at suse.com>
Cc: linux-btrfs at vger.kernel.org
Cc: Darrick J. Wong <darrick.wong at oracle.com>
Cc: linux-xfs at vger.kernel.org
Cc: Gao Xiang <gaoxiang25 at huawei.com>
Cc: Christoph Hellwig <hch at lst.de>
Cc: Theodore Ts'o <tytso at mit.edu>
Cc: linux-ext4 at vger.kernel.org
Cc: Coly Li <colyli at suse.de>
Cc: linux-bcache at vger.kernel.org
Cc: Boaz Harrosh <ooo at electrozaur.com>
Cc: Bob Peterson <rpeterso at redhat.com>
Cc: cluster-devel at redhat.com
Signed-off-by: Ming Lei <ming.lei at redhat.com>
---
 Documentation/block/biovecs.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
index 25689584e6e0..bfafb70d0d9e 100644
--- a/Documentation/block/biovecs.txt
+++ b/Documentation/block/biovecs.txt
@@ -117,3 +117,29 @@ Other implications:
    size limitations and the limitations of the underlying devices. Thus
    there's no need to define ->merge_bvec_fn() callbacks for individual block
    drivers.
+
+Usage of helpers:
+=================
+
+* The following helpers whose names have the suffix of "_all" can only be used
+on non-BIO_CLONED bio, and usually they are used by filesystem code, and driver
+shouldn't use them because bio may have been split before they got to the driver:
+
+	bio_for_each_segment_all()
+	bio_first_bvec_all()
+	bio_first_page_all()
+	bio_last_bvec_all()
+
+* The following helpers iterate over single-page bvec, and the local
+variable of 'struct bio_vec' or the reference records single-page IO
+vector during the itearation:
+
+	bio_for_each_segment()
+	bio_for_each_segment_all()
+
+* The following helper iterates over multi-page bvec, and each bvec may
+include multiple physically contiguous pages, and the local variable of
+'struct bio_vec' or the reference records multi-page IO vector during the
+itearation:
+
+	bio_for_each_bvec()
-- 
2.9.5
