Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F8CEE49A0
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Aug 2023 01:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1692667024;
	bh=PyNKln6QpzvJsp+uUe84YdiuadZLDGhmt8zTvh3ayO8=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=UPaET2HtvmowOufVDHA+gtWgU4jMY+6niDMM8GixoQ8V9m7q1cH/K7b1rCLD3BPgs
	 tcLf5wOK4CkZpBsWB9peN6BS8NqT0iuUgoFhLX4v3lx+/LRJz76/EzypIi44Tf8n19
	 5CNorn+SCNpfq4CxDFnvdTqlkWTx2F+7qYHAxsxQy/7mevQWfmkCHWIKQz7FguhwZ1
	 HA23OaNkfl2rW+X5KjI4f/EaPvk/orkZvHzQ9hJ70cmNmlKehocpa5j3q84TQ13D2N
	 WP3dc6dPB74p6W9WIyyUD8k8c7WMMWO7zYVer62RjGKjYMF4fQLotmb5/31oijEfRw
	 GyHqStfXUypYQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RVBJw0K4rz30fF
	for <linux-erofs@archiver.kernel.org>; Tue, 22 Aug 2023 11:17:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.189; helo=szxga03-in.huawei.com; envelope-from=guoxuenan@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RVBJm6tPPz2y1Y
	for <linux-erofs@lists.ozlabs.org>; Tue, 22 Aug 2023 11:16:56 +1000 (AEST)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RVBF70q64zLp9X;
	Tue, 22 Aug 2023 09:13:47 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 22 Aug 2023 09:16:50 +0800
Message-ID: <039de23f-7a72-7863-5718-d7f8eaaafdce@huawei.com>
Date: Tue, 22 Aug 2023 09:16:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH] erofs-utils: mkfs: introduce multi-thread compression
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, <linux-erofs@lists.ozlabs.org>,
	Yifan Zhao <zhaoyifan@sjtu.edu.cn>
References: <20230819180104.4824-1-zhaoyifan@sjtu.edu.cn>
 <8e890c0d-bddb-139d-def0-9e5fac977d37@linux.alibaba.com>
 <3c645595-e612-f6a2-f301-4bc28f845a6d@huawei.com>
 <ea93ff7d-fa24-5151-0504-020f0278c57b@linux.alibaba.com>
In-Reply-To: <ea93ff7d-fa24-5151-0504-020f0278c57b@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Guo Xuenan via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Guo Xuenan <guoxuenan@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi  Xiang,

On 2023/8/21 13:20, Gao Xiang wrote:
>
>
> On 2023/8/21 13:11, Guo Xuenan via Linux-erofs wrote:
>> Hi，Xiang
>>
>> Is there a develop branch for multi-thread compression，
>> then we can work together to make it better.
>
> If needed, an erofs-utils fork can be made for collaboration
> on github.
>
> What's your github username (and yifan's github username as
> well)?  Let me send some invitation to you.
>
OK, got the invitation, thanks  :)

Best regards
Xuenan
> Thanks,
> Gao Xiang
>
>>
>> Thanks
>> Xuenan
>
-- 
Guo Xuenan [OS Kernel Lab]
-----------------------------
Email: guoxuenan@huawei.com

