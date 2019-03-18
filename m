From: willy@infradead.org (Matthew Wilcox)
Date: Sun, 17 Mar 2019 19:27:04 -0700
Subject: [PATCH v2 for-4.19 RESEND 2/2] staging: erofs: fix race when the
 managed cache is enabled
In-Reply-To: <d1f70678-2215-d626-ed87-b024d6e5763c@huawei.com>
References: <20190314044253.2944-1-gaoxiang25@huawei.com>
 <20190314044253.2944-2-gaoxiang25@huawei.com>
 <d1f70678-2215-d626-ed87-b024d6e5763c@huawei.com>
Message-ID: <20190318022704.GP19508@bombadil.infradead.org>

On Mon, Mar 18, 2019@09:59:19AM +0800, Gao Xiang wrote:
> ping?
> 
> Hi Greg,
> I have no idea of this patch since Matthew makes no response after
> modification... And this series is still not backported to 4.19 till now...
> 
> What should I do next? Can this series be accepted for linux-4.19? :(

I don't understand why we're trying to backport a piece of core kernel
infrastructure for the benefit of a driver that's still in staging.
