From: dhowells@redhat.com (David Howells)
Date: Thu, 06 Sep 2018 11:09:48 +0100
Subject: [PATCH 2/2 dhowells/mount-api] staging: erofs: update .mount and
 .remount_sb
In-Reply-To: <1536224508-66168-2-git-send-email-gaoxiang25@huawei.com>
References: <1536224508-66168-2-git-send-email-gaoxiang25@huawei.com>
 <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <18040.1536228588@warthog.procyon.org.uk>

Gao Xiang <gaoxiang25@huawei.com> wrote:

> This patch updates .mount and .remount_sb after
> commit ("vfs: Require specification of size of
> mount data for internal mounts") in reference to
> drivers/usb/gadget/function/f_fs.c.
> 
> Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

I've folded this into my patch.

David
