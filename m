From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 27 Aug 2018 14:57:05 +0800
Subject: EROFS filesystem testdata (part I)
Message-ID: <5765b7d8-b3f4-4448-baa6-c28fe61ac8a5@huawei.com>

Hi,

Here is the first part of the current EROFS filesystem testdata I just tested (2018/08/27).

Dataset: enwik8 (100000000 byte, 95.37MB) [1]

Test purpose: little extra memory consumption compared with SQUASHFS due to EROFS in-place decompression approach

Test environment: HUAWEI R&D cloud (Intel(R) Xeon(R) CPU E5-2690 v2 @ 3.00GHz * 8, 16GB RAM, Magnetic storage)
                  and tested in QEMU Virtual machine configured with -smp 4 -m 512M

Test program versions:
 mkfs-erofs (prelimitary huawei version) [2]
 mksquashfs version 4.3 (2014/05/12)
 mke2fs 1.42.9 (4-Feb-2014)

Linux kernel version:
 4.19 rc1

File sizes:
 orig           100000000 byte
 squashfs_4k     64884736 byte     (mksquashfs enwik8 enwik8_4k.squashfs.img -comp lz4 -Xhc -b 4096 -noappend)
 erofs_4k        61669376 byte [3] (mkfs.erofs.x86_64 -zlz4hc -d9 enwik8.erofs.img enwik8)
 squashfs_8k     59813888 byte     (mksquashfs enwik8 enwik8_8k.squashfs.img -comp lz4 -Xhc -b 8192 -noappend)
 squashfs_128k   44720128 byte     (mksquashfs enwik8 enwik8_128k.squashfs.img -comp lz4 -Xhc -noappend)

Teststeps:
 1) mount -t erofs/squashfs /dev/sdb /tmp
 2) time cat /tmp/enwik8 > /dev/null
 3) free
 4) poweroff & repeat

erofs_4k
 real(s)           3.00    3.78    3.69    3.54    3.57
 user(s)           0.02    0.02    0.02    0.02    0.02
 sys(s)            2.35    2.30    2.27    1.97    2.24
 mem_used(KB)    121520  122304  121820  121980  121464
 mem_free(KB)    370940  370156  370640  370480  370996

squashfs_4k
 real(s)          18.00   21.16   21.42   20.58   20.33
 user(s)           0.04    0.04    0.05    0.03    0.04
 sys(s)            5.08    5.81    5.87    5.54    6.01
 mem_used(KB)    185108  184596  184528  184504  184552
 mem_free(KB)    307352  307864  307932  307956  307908

squashfs_8k
 real(s)          15.78   15.47   15.52   14.22   15.21
 user(s)           0.03    0.02    0.03    0.02    0.02
 sys(s)            5.66    5.60    5.95    5.26    5.73
 mem_used(KB)    179400  179528  179480  179668  179748
 mem_free(KB)    313060  312932  312980  312792  312712

squashfs_128k
 real(s)           4.30    4.36    4.15    3.73    4.23
 user(s)           0.02    0.02    0.02    0.01    0.02
 sys(s)            3.67    3.76    3.59    3.24    3.68
 mem_used(KB)    165396  165692  166048  166004  165936
 mem_free(KB)    327064  326768  326412  326456  326524

ext4 [4]
 real(s)           0.56    0.43    0.59    0.44    0.47
 user(s)           0.03    0.01    0.03    0.02    0.02
 sys(s)            0.46    0.37    0.51    0.37    0.40
 mem_used(KB)    119560  120316  119676  119972  119740
 mem_free(KB)    372900  372144  372784  372488  372720

[1] In zip format: http://mattmahoney.net/dc/enwik8.zip
    Detailed description: http://mattmahoney.net/dc/textdata.html
[2] https://github.com/hsiangkao/erofs_mkfs_binary    (preview version, still buggy now)
[3] currently, EROFS supports VLE-4k only because it is useful and it will be used in our Android products.
[4] In order to monitor memory usage easily, QEMU is used but it has slow decompression speed.
    lzbench testdata (HUAWEI R&D cloud, lzbench -elz4)
     lzbench 1.7.3 (64-bit Linux)   Assembled by P.Skibinski
     Compressor name         Compress. Decompress. Compr. size  Ratio Filename
     memcpy                   2673 MB/s  2700 MB/s   100000000 100.00 enwik8/enwik8
     lz4 1.8.2                 289 MB/s  2144 MB/s    57262281  57.26 enwik8/enwik8
     done... (cIters=1 dIters=1 cTime=1.0 dTime=2.0 chunkSize=1706MB cSpeed=0MB)

    lzbench testdata (QEMU Virtual machine configured with -smp 4 -m 512M in HUAWEI R&D cloud, lzbench -elz4)
     lzbench 1.7.3 (64-bit Linux)   Assembled by P.Skibinski
     Compressor name         Compress. Decompress. Compr. size  Ratio Filename
     memcpy                    632 MB/s   768 MB/s   100000000 100.00 /tmp/enwik8
     lz4 1.8.2                  15 MB/s    39 MB/s    57262281  57.26 /tmp/enwik8
     done... (cIters=1 dIters=1 cTime=1.0 dTime=2.0 chunkSize=1706MB cSpeed=0MB)


Thanks,
Gao Xiang
