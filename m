Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47373C3DA6E
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jan 2024 10:49:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4T4mg15Lznz3btQ
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jan 2024 21:49:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4T4mfs5slLz30gL
	for <linux-erofs@lists.ozlabs.org>; Wed,  3 Jan 2024 21:48:51 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VztwKxL_1704278925;
Received: from 30.222.32.222(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VztwKxL_1704278925)
          by smtp.aliyun-inc.com;
          Wed, 03 Jan 2024 18:48:46 +0800
Message-ID: <1616817c-7759-41f1-8c6b-568fb7357212@linux.alibaba.com>
Date: Wed, 3 Jan 2024 18:48:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Request for Assistance: Decompressing EROFS Image without
 Mounting
To: =?UTF-8?B?546L56GV?= <wangshuo16@xiaomi.com>,
 "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
References: <e751bfc68f524227ad8ad98faa8102af@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <e751bfc68f524227ad8ad98faa8102af@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi,

On 2024/1/3 18:12, 王硕 via Linux-erofs wrote:
> Dear develoers,
> 
> 
> I hope this email finds you well. My name is wang shuo, and I am reaching out to seek your expertise regarding decompressing an EROFS (Enhanced Read-Only File System) image without the need for mounting. I have come across a unique situation where I do not have permission to create a loop device for mounting the image, and I am exploring alternative methods to access its content.
> 
> 
> I understand that the typical approach involves mounting the EROFS image to obtain its contents. However, due to specific constraints in my environment, this approach is not feasible for me. Therefore, I am reaching out to you to inquire if there are alternative methods or tools available that would allow me to decompress the EROFS image directly without the necessity of mounting it.
> 
> 
> Your expertise in this area would be immensely valuable, and any guidance or recommendations you can provide will be highly appreciated. If there are specific tools, scripts, or techniques that you could suggest, it would greatly assist me in overcoming the challenges I currently face.
> 
> 

Doesn't
fsck.erofs --extract dir_path <img>

meet your requirement?

Thanks,
Gao Xiang

> I am grateful for your time and consideration in this matter. Thank you for your dedication to the developer community, and I look forward to hearing from you soon.> 
> 
> Best regards,
> 
> 
> wang shuo
> 
> wangshuo16@xiaomi.com
> 
> #/******本邮件及其附件含有小米公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！ This e-mail and its attachments contain confidential information from XIAOMI, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!******/#
