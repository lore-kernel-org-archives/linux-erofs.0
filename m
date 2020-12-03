Return-Path: <SRS0=qOHo=FH=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8E2C63777
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Dec 2020 08:47:45 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DA8D20C56
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Dec 2020 08:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DA8D20C56
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CmqGj41rzzDrQ2
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Dec 2020 19:47:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1606985261;
	bh=hS3ibs4caZkahrzgcMN2TAJo2B2H5Muwb2NidDYlIzQ=;
	h=Date:To:Subject:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:From;
	b=Tc4hffqepHw3tC/6DSvB8zdGoom1S6BCbfqAMZW4KNgQpWUBfMNHDCa2l38R2csCN
	 Z7N4mpb0AnjUs54vI2gSH7MlBzVtfrULYsfs+LuWePrTikJd4Houe5ZIIy9Xv6EMP+
	 oebv6g/75VW3BDJcL0qs7MrXFbBXBp8DhHYPYxelBT6N3esqo9aSqmPz/OZVbLqSSN
	 5e1FsVF0diaCqUSP7TePeebji0mYDk1LJtlQXdvu0Wbawx93Mesm6+VkrpN5JW7Lea
	 5VF0UijQXivc3APavOlXU/kLi0HBEo6RcFej0arxQTsq+1SYKpf7GA1aqVQkR1RCjM
	 68ipi3w+ioqGw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=boldwhite24.com (client-ip=80.211.42.67;
 helo=mail.boldwhite24.com; envelope-from=diego.sanchez@boldwhite24.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none)
 header.from=boldwhite24.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=boldwhite24.com header.i=@boldwhite24.com
 header.a=rsa-sha256 header.s=mail header.b=JBZaLaJW; 
 dkim-atps=neutral
Received: from mail.boldwhite24.com (mail.boldwhite24.com [80.211.42.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CmqD76DJVzDrMF
 for <linux-erofs@lists.ozlabs.org>; Thu,  3 Dec 2020 19:45:27 +1100 (AEDT)
Received: by mail.boldwhite24.com (Postfix, from userid 1001)
 id 00F56A2E0A; Thu,  3 Dec 2020 08:45:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=boldwhite24.com;
 s=mail; t=1606985120;
 bh=hS3ibs4caZkahrzgcMN2TAJo2B2H5Muwb2NidDYlIzQ=;
 h=Date:From:To:Subject:From;
 b=JBZaLaJWi5anokhwKhyLY1XkBN2wSoqyv+r9ELsaVUDY54RtxvzFFNN9672Bk1mG8
 D9/M1OPI7JOiJ23jJiPJF1HSOE5MuG1J1s+nid6IPMrrXf0kYoJgl7VUWyvhjw3//V
 ye+LUukvkPO8622FSvmuotf6pmcXASx9omdzDlbhUcxgrWMWPoNjNGvl2GDAMZPRXN
 XJZkVwt2OkZyx7HlvQtn0nuyRshT17MTuIDaWKE7ov1F/ASDG+Nf0O0KwJvzQo2wDr
 3W1NQp74zq/wPAm0HOX/O1bj08PqOZvBsr/VA8Q7DWcyWyr2DNbhpWurB6N2Y4Ba69
 bGRlbq9zwnrjw==
Received: by mail.boldwhite24.com for <linux-erofs@lists.ozlabs.org>;
 Thu,  3 Dec 2020 08:45:13 GMT
Message-ID: <20201203074501-0.1.2m.amiu.0.ea8me8wtj4@boldwhite24.com>
Date: Thu,  3 Dec 2020 08:45:13 GMT
To: <linux-erofs@lists.ozlabs.org>
Subject: Disinfection
X-Mailer: mail.boldwhite24.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
From: =?utf-8?q?_Diego_S=C3=A1nchez_via_Linux-erofs?=
 <linux-erofs@lists.ozlabs.org>
Reply-To: =?UTF-8?Q? Diego_S=C3=A1nchez ?= <diego.sanchez@boldwhite24.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Good morning,

looking for companies interested in raising additional capital by diversi=
fying their offer in soaps, liquids and gels for hand disinfection and co=
smetics for body and hair care.

The distribution of innovative products corresponding to the current pref=
erences of customers in the field of hygiene and preventive healthcare al=
lows our partners to gain new markets and achieve better economic results=
=2E

In addition to products with bactericidal action, our range includes show=
er gels, shampoos and hair conditioners, as well as efficient, concentrat=
ed detergents.

The versatility (suitable for all skin types) combined with an affordable=
 price means that customers make an informed choice of a product among ot=
hers available on the market.

Are you interested in cooperation?

Diego S=C3=A1nchez
