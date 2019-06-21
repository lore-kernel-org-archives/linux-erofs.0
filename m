From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 21 Jun 2019 17:50:50 +0800
Subject: [PATCH v2 6/8] staging: erofs: introduce LZ4 decompression inplace
In-Reply-To: <20190620160719.240682-7-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-7-gaoxiang25@huawei.com>
Message-ID: <bf1ebb0f-3039-d7d1-95cd-f49cadd6085e@huawei.com>

On 2019/6/21 0:07, Gao Xiang wrote:
> compressed data will be usually loaded into last pages of
> the extent (the last page for 4k) for in-place decompression
> (more specifically, in-place IO), as ilustration below,
> 
>          start of compressed logical extent
>            |                          end of this logical extent
>            |                           |
>      ______v___________________________v________
> ... |  page 6  |  page 7  |  page 8  |  page 9  | ...
>     |__________|__________|__________|__________|
>            .                         ^ .        ^
>            .                         |compressed|
>            .                         |   data   |
>            .                           .        .
>            |<          dstsize        >|<margin>|
>                                        oend     iend
>            op                        ip
> 
> Therefore, it's possible to do decompression inplace (thus no
> memcpy at all) if the margin is sufficient and safe enough [1],
> and it can be implemented only for fixed-size output compression
> compared with fixed-size input compression.
> 
> No memcpy for most of in-place IO (about 99% of enwik9) after
> decompression inplace is implemented and sequential read will
> be improved of course (see the following patches for test results).
> 
> [1] https://github.com/lz4/lz4/commit/b17f578a919b7e6b078cede2d52be29dd48c8e8c
>     https://github.com/lz4/lz4/commit/5997e139f53169fa3a1c1b4418d2452a90b01602
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
