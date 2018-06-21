From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:40:14 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 00/12] erofs: introduce erofs file
 system
Message-ID: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>

Hi all,

Read-only file systems are used in many cases, such as read-only storage media.
We are now focusing on the Android device which several read-only partitions exist.
Due to limited read-only solutions, a new read-only file system EROFS
(Extendable Read-Only File System) is introduced.

As the other read-only file systems, several meta regions in generic file systems
such as free space bitmap are omitted. But the difference is that EROFS focuses
more on performance than purely on saving storage space as much as possible.

Furthermore, we also add the compression support called z_erofs.

Traditional file systems with the compression support use the fixed-sized input
compression, the output compressed units could be arbitrary lengths.
However, data is accessed in the block unit for block devices, which means
(A) if the accessed compressed data is not buffered, some data read from
the physical block cannot be further utilized, which is illustrated as follows:
       
   ++-----------++-----------++         ++-----------++-----------++
...||           ||           ||   ...   ||           ||           ||  ... original data
   ++-----------++-----------++         ++-----------++-----------++
    \                         /          \                         /
       \                   /                \                    /
          \             /                      \               /
      ++---|-------++--|--------++       ++-----|----++--------|--++
      ||xxx|       ||  |xxxxxxxx||  ...  ||xxxxx|    ||        |xx||  compressed data
      ++---|-------++--|--------++       ++-----|----++--------|--++

The shadow regions read from the block device but cannot be used for decompression.

(B) If the compressed data is also buffered, it will increase the memory overhead.
Because these are compressed data, it cannot be directly used, and we don't know
when the corresponding compressed blocks are accessed, which is not friendly to
the random read.

In order to reduce the proportion of the data which cannot be directly decompressed,
larger compressed sizes are preferred to be selected, which is also not friendly to
the random read.

Erofs implements the compression in a different approach, the details of which will
be discussed in the next section.

In brief, the following points summarize our design at a high level:

1) Use page-sized blocks so that there are no buffer heads.

2) By introducing a more general inline data / xattr, metadata and small data have
the opportunity to be read with the inode metadata at the same time.

3) Introduce another shared xattr region in order to store the common xattrs (eg.
selinux labels) or xattrs too large to be suitable for meta inline.

4) Metadata and data could be mixed by design, so it could be more flexible for mkfs
to organize files and data.

5) instead of using the fixed-sized input compression, we put forward a new fixed
output compression to make the full use of IO (which means all data from IO can be
decompressed), reduce the read amplification, improve random read and keep the
relatively lower compression ratios, illustrated as follows:


        |---- varient-length extent ----|------ VLE ------|---  VLE ---|
         /> clusterofs                  /> clusterofs     /> clusterofs /> clusterofs
   ++---|-------++-----------++---------|-++-----------++-|---------++-|
...||   |       ||           ||         | ||           || |         || | ... original data
   ++---|-------++-----------++---------|-++-----------++-|---------++-|
   ++->cluster<-++->cluster<-++->cluster<-++->cluster<-++->cluster<-++
        size         size         size         size         size  
         \                             /                 /            /
          \                      /              /            /
           \               /            /            /
            ++-----------++-----------++-----------++
        ... ||           ||           ||           || ... compressed clusters
            ++-----------++-----------++-----------++
            ++->cluster<-++->cluster<-++->cluster<-++
                 size         size         size

   A cluster could have more than one blocks by design, but currently we only have the
page-sized cluster implementation (page-sized fixed output compression can also have
better compression ratio than fixed input compression).

   All compressed clusters have a fixed size but could be decompressed into extents with
arbitrary lengths.

   In addition, if a buffered IO reads the following shadow region (x), we could make a more
   customized path (to replace generic_file_buffered_read) which only reads one compressed
   cluster and makes the partial page available.
         /> clusterofs
   ++---|-------++
...||   | xxxx  || ...
   ||---|-------||

Some numbers using fixed output compression (VLE, cluster size = block size = 4k) on
the server and Android phone (kirin970 platform):

Server (magnetic disk):

compression  EROFS seq read  EXT4 seq read        EROFS random read  EXT4 random read
ratio           bw[MB/s]       bw[MB/s]             bw[MB/s] (20%)    bw[MB/s] (20%)

  4              480.3          502.5                   69.8               11.1
 10              472.3          503.3                   56.4               10.0
 15              457.6          495.3                   47.0               10.9
 26              401.5          511.2                   34.7               11.1
 35              389.1          512.5                   28.0               11.0
 48              375.4          496.5                   23.2               10.6
 53              370.2          512.0                   21.8               11.0
 66              349.2          512.0                   19.0               11.4
 76              310.5          497.3                   17.3               11.6
 85              301.2          512.0                   16.0               11.0
 94              292.7          496.5                   14.6               11.1
100              538.9          512.0                   11.4               10.8

Kirin970 (A73 Big-core 2361Mhz, A53 little-core 0Mhz, DDR 1866Mhz):

compression  EROFS seq read  EXT4 seq read        EROFS random read  EXT4 random read
ratio           bw[MB/s]       bw[MB/s]             bw[MB/s] (20%)    bw[MB/s] (20%)

  4              546.7          544.3                    157.7              57.9
 10              535.7          521.0                    152.7              62.0
 15              529.0          520.3                    125.0              65.0
 26              418.0          526.3                     97.6              63.7
 35              367.7          511.7                     89.0              63.7
 48              415.7          500.7                     78.2              61.2
 53              423.0          566.7                     72.8              62.9
 66              334.3          537.3                     69.8              58.3
 76              387.3          546.0                     65.2              56.0
 85              306.3          546.0                     63.8              57.7
 94              345.0          589.7                     59.2              49.9
100              579.7          556.7                     62.1              57.7

* currently we use workqueue for the read-ahead process, which is still has some
minor issues and the value of sequential read is effected by work queue scheduling.



This patchset is only for opensource archive use, the file system still has issues
and will be work in progress in the coming few months.


We will make a developing tree and an independent mailing list in a few days.



Any comments are welcome :-)



Recently TODO list:
1) Add a documentation on the on-disk layout and kernel file system design;

2) Remove all Linux kernel version macros and devide it into separated kernel version tree;

3) the open source of erofs-mkfs is _still_ in progress, it will be released as soon as
   the internal process ends.
   
4) VLE decompression code still needs to do more optimization and cleanup.


Thanks,


Gao Xiang (12):
  erofs: add on-disk layout
  erofs: add erofs in-memory stuffs
  erofs: add super block operations
  erofs: add raw address_space operations
  erofs: add inode operations
  erofs: add directory operations
  erofs: add namei functions
  erofs: definitions for the various kernel version temporarily
  erofs: update Kconfig and Makefile
  erofs: introduce xattr & acl support
  erofs: introduce a customized LZ4 decompression
  erofs: introduce VLE decompression support (experimental)

 fs/Kconfig               |    1 +
 fs/Makefile              |    1 +
 fs/erofs/Kconfig         |   88 ++++
 fs/erofs/Makefile        |    9 +
 fs/erofs/data.c          |  569 +++++++++++++++++++++++++
 fs/erofs/dir.c           |  143 +++++++
 fs/erofs/erofs_fs.h      |  258 ++++++++++++
 fs/erofs/inode.c         |  287 +++++++++++++
 fs/erofs/internal.h      |  413 ++++++++++++++++++
 fs/erofs/lz4defs.h       |  227 ++++++++++
 fs/erofs/namei.c         |  250 +++++++++++
 fs/erofs/pagevec.h       |  184 ++++++++
 fs/erofs/staging.h       |   83 ++++
 fs/erofs/super.c         |  422 +++++++++++++++++++
 fs/erofs/unzip.c         | 1039 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip.h         |  119 ++++++
 fs/erofs/unzip_generic.c |  295 +++++++++++++
 fs/erofs/unzip_lz4.c     |  221 ++++++++++
 fs/erofs/unzip_vle.h     |   79 ++++
 fs/erofs/xattr.c         |  678 ++++++++++++++++++++++++++++++
 fs/erofs/xattr.h         |   93 +++++
 21 files changed, 5459 insertions(+)
 create mode 100644 fs/erofs/Kconfig
 create mode 100644 fs/erofs/Makefile
 create mode 100644 fs/erofs/data.c
 create mode 100644 fs/erofs/dir.c
 create mode 100644 fs/erofs/erofs_fs.h
 create mode 100644 fs/erofs/inode.c
 create mode 100644 fs/erofs/internal.h
 create mode 100644 fs/erofs/lz4defs.h
 create mode 100644 fs/erofs/namei.c
 create mode 100644 fs/erofs/pagevec.h
 create mode 100644 fs/erofs/staging.h
 create mode 100644 fs/erofs/super.c
 create mode 100644 fs/erofs/unzip.c
 create mode 100644 fs/erofs/unzip.h
 create mode 100644 fs/erofs/unzip_generic.c
 create mode 100644 fs/erofs/unzip_lz4.c
 create mode 100644 fs/erofs/unzip_vle.h
 create mode 100644 fs/erofs/xattr.c
 create mode 100644 fs/erofs/xattr.h

-- 
1.9.1
