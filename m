From: jeremy@azazel.net (Jeremy Sowden)
Date: Tue, 8 Jan 2019 09:08:50 +0000
Subject: [PATCH 0/2] staging: erofs: fixed -Wmissing-prototype warnings.
In-Reply-To: <5b305a6a-b50d-fd27-4675-88cdeffa577b@huawei.com>
References: <20190107182516.21511-1-jeremy@azazel.net>
 <5b305a6a-b50d-fd27-4675-88cdeffa577b@huawei.com>
Message-ID: <20190108090850.GB20615@azazel.net>

On 2019-01-08,@09:46:18 +0800, Gao Xiang wrote:
> On 2019/1/8 2:25, Jeremy Sowden wrote:
> > Fixes for -Wmissing-prototype warnings in the erofs driver.  One
> > group of functions have been made static; for the second, prototypes
> > have been moved to a head
>
> Is -Wmissing-prototypes required for the current linux kernel?
> I cannot see this warning in my personal kernel compilation...
>
> Functions your fix have already been added proper erofs prefix,
> therefore it wouldn't pollute the global namespace:
> z_erofs_vle_work_release
> z_erofs_unzip_lz4
> erofs_try_to_release_workgroup
>
> erofs_workgroup_free_rcu
> z_erofs_map_blocks_iter

There was a request for help to fix these warnings on the
driverdev-devel mailing list last Novemeber (I've also attached the
message):

  http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-November/128432.html

Currently, the flag is only enabled by passing W=1 to make, but since it
is useful, the idea is to fix all the current warnings and enable it in
the main build.

J.
-------------- next part --------------
An embedded message was scrubbed...
From: Borislav Petkov <bp@alien8.de>
Subject: HELP WANTED: Fix -Wmissing-prototypes warnings
Date: Fri, 9 Nov 2018 18:44:10 +0100
Size: 6710
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190108/1c2a4ac1/attachment.mht>
