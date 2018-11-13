From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Nov 2018 08:15:14 +0800
Subject: [PATCH 1/3] staging: erofs: unzip_vle.c: Replace comparison to
 NULL.
In-Reply-To: <1542055439-24444-2-git-send-email-sicilia.cristian@gmail.com>
References: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
 <1542055439-24444-2-git-send-email-sicilia.cristian@gmail.com>
Message-ID: <4afeb152-b205-792f-8289-95d1fddb19ef@huawei.com>

Hi Cristian,

On 2018/11/13 4:43, Cristian Sicilia wrote:
> Replace equal to NULL with logic unary operator,
> and removing not equal to NULL comparison.
> 
> Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>

Indeed, I have several pending changes for this file...
But these coding style fixes looks good to me. I will rebase them on your work...

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
