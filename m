From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 Aug 2018 00:09:34 +0800
Subject: [PATCH 2/6] staging: erofs: formatting fix to NULL comparison
In-Reply-To: <1535642042-5336-2-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
 <1535642042-5336-2-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <747d9c74-02cd-fa39-9870-ae17dbddf366@aol.com>

Hi Pavel,

On 2018/8/30 23:13, Pavel Zemlyanoy wrote:
> This patch does not change the logic, it only
> corrects the formatting and checkpatch checks by
> to NULL comparison.
> 
> The patch fixes 5 checks of type:
> "Comparison to NULL could be written".
> 
> Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>

Sorry about the late reply. I am on vacation now.

Personally, I use "== NULL" or "!= NULL" on purpose, since it is more 
emphasized than the checkpatch.pl suggested way, and I tend to use the nullptr explicitly.

BTW, It seems other filesystems still use "== NULL" or "!= NULL" explicitly, too, eg:
xfs, ext4, ext2, ocfs2, etc... You could 'grep' in the fs directory... 

Other commits look good for me at glance.

Thanks,
Gao Xiang
