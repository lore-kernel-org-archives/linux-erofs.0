Return-Path: <SRS0=HeWW=7R=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76166C433DF
	for <linux-erofs@archiver.kernel.org>; Thu,  4 Jun 2020 15:26:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B681D206E6
	for <linux-erofs@archiver.kernel.org>; Thu,  4 Jun 2020 15:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="isTCnIQb";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GG8LqDVp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B681D206E6
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49d8ks2r82zDqrm
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Jun 2020 01:26:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1591284389;
	bh=fxwEcg9w7OZIKdE3jeeOjW/bfIisvBV2bbz8KwE8TnU=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:From;
	b=isTCnIQbFdEzHjz0bfhZR9mZB3ZmcNvGwIoTCRNb68FKgIdbAT3jBXkCxXad97qDl
	 stHm/PHMU8QAudgwZjTiohzr3JQO97yoeDo3W8wwa8qL/2iL+XnaNQjjHFDm37Q8sx
	 x66NDGW5bJ+p7U6Oxjgljcf5QMwzwjSxI013VBSK1VlufL+/SXH28pdaIPxpy5LYLo
	 VwIhHFX34iwNZ4i8xKCAaVEW+j3Jql3JrvNVTfdZcTMxdVCtVtXpH1uRVjPrWNbapv
	 Zfnk8l+Qar6VEQjVs3r5nSWL+jLTFC8uECjzkyZGdytMIJFXo81xu7glxhl13oZCR6
	 dnf+8ccnv5AJw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=google.com (client-ip=2a00:1450:4864:20::22b;
 helo=mail-lj1-x22b.google.com; envelope-from=forwarding-noreply@google.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256
 header.s=20161025 header.b=GG8LqDVp; dkim-atps=neutral
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com
 [IPv6:2a00:1450:4864:20::22b])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49d8kH38mczDqMf
 for <linux-erofs@lists.ozlabs.org>; Fri,  5 Jun 2020 01:25:57 +1000 (AEST)
Received: by mail-lj1-x22b.google.com with SMTP id b6so7846151ljj.1
 for <linux-erofs@lists.ozlabs.org>; Thu, 04 Jun 2020 08:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:date:message-id:subject:from:to
 :content-transfer-encoding;
 bh=fxwEcg9w7OZIKdE3jeeOjW/bfIisvBV2bbz8KwE8TnU=;
 b=GG8LqDVpzh7pwMVPeH3Kd26+pW87xWqR6IbOW/UMlVepTCK9Oq32GkMFgoURa2Vcxq
 yWk17BRXGBuX58B73vAumDN4oUwyS5fzDQ12SQPVJDjRpSIAvXCQWh7t/AYH78z2lZh/
 ZioLVF8xcQm9dO6vrx9Y4DuhBv0zn1cKF14walNo3PVBk5N1JT6evgEttNQ29Bbq2R+D
 TXD40rPKCEycZJvhzSMUpzEJKTPH1upaJNzJ/TgzTJ2/+kiOtl3WLmtVUqzWboylkQLK
 KNs4loBxqs/8tpojA2amKgoqUGSqUbhZv/f7UW8ZZ+RLLfbv75iMDLh4H5hpqYdJKDL7
 EbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:date:message-id:subject:from:to
 :content-transfer-encoding;
 bh=fxwEcg9w7OZIKdE3jeeOjW/bfIisvBV2bbz8KwE8TnU=;
 b=fgtgZzfCJQYTYUV8sfwxLouIpvsc3EFYiTra6jrJ0GFg+ChfU31rFcKG4ej7JMvm7P
 tQ5gJDrl9weyYCfunLYDxuF9knFslsiFFZjYABhPku2UdNwOemKUp7ETZEqxHD/4wVTy
 7V2C2SLQuPDflMQL/pULbf0DFmqFy21K5lxEWkuKciW4fWJBrJppJ7VMob8zFxiKybEw
 QALG5YWihVA71uvF1J6lo2ZLUXD0+9dghpPsp3O/ex2PJxk64iTDR7Mf9YBQbjaTMHHE
 lfwrP5aUkKbiEQC9P+bnh2lmYcXKteqmhansetaqCZ4kxzaLkD0kPFXjVt8nJMsDGVa9
 3sfg==
X-Gm-Message-State: AOAM530I5luc5wGlIn7rnZCOwCL5wdEmZ8io/x10iYU/HZj3ZOycaHI5
 PSs+d+OfmXfV32WaszXSAz9LSoN041ZiFG5GOZMhJjt9yQqeILpMF10=
X-Google-Smtp-Source: ABdhPJx4tquTxFFBKHzgISUWOlfjWmHfsO+ffkoyAUUCnyUTF/EoYmOHmGFEte2N7GP9x/lygS+qnQk3vMdF08K58TdyKZiLnCb9Jw==
MIME-Version: 1.0
X-Received: by 2002:a2e:998f:: with SMTP id w15mr2363507lji.463.1591284349085; 
 Thu, 04 Jun 2020 08:25:49 -0700 (PDT)
X-Google-Address-Confirmation: 9WpnwHBH5ysv_syeZcT557XG-4Q
Date: Thu, 4 Jun 2020 23:25:48 +0800
Message-ID: <CALJidXEizkAe=o3cnLqK2FaJsBL1OyC1uz9t7LNG=dbr+hfTEA@mail.gmail.com>
Subject: =?UTF-8?B?KCM1NjUwMjIxNDkpIEdtYWlsIOi9rOWPkeehruiupCAtIOS7jiBibHVjZXJsZWVAZ21haQ==?=
 =?UTF-8?B?bC5jb20g5o6l5pS26YKu5Lu2?=
To: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
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
From: =?utf-8?b?R21haWwg5bCP57uE5pWs5LiKIHZpYSBMaW51eC1lcm9mcw==?=
 <linux-erofs@lists.ozlabs.org>
Reply-To: =?UTF-8?B?R21haWwg5bCP57uE5pWs5LiK?= <forwarding-noreply@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Ymx1Y2VybGVlQGdtYWlsLmNvbSDlt7Lor7fmsYLoh6rliqjlsIbpgq7ku7bovazlj5HliLDmgqjn
moTnlLXlrZDpgq7ku7blnLDlnYAgbGludXgtZXJvZnNAbGlzdHMub3psYWJzLm9yZ+OAgg0K56Gu
6K6k5Luj56CB77yaNTY1MDIyMTQ5DQoNCuimgeiuqSBibHVjZXJsZWVAZ21haWwuY29tIOiHquWK
qOWwhumCruS7tui9rOWPkeWIsOaCqOeahOWcsOWdgO+8jOivt+eCueWHu+S4i+mdoueahOmTvuaO
peehruiupOivt+axgu+8mg0KDQpodHRwczovL21haWwtc2V0dGluZ3MuZ29vZ2xlLmNvbS9tYWls
L3ZmLSU1QkFOR2pkSjhSaDkwRU16emNYWFkxR0pIYW1PRE92N2hOQU1YNlE3cEt1Ui0tVUY5TFJ2
UlA1VW04Z0J1cDRaRUgzNG1EbktnYUV4ekc5N3doS3dtVXhJNUxoWTZtTkFURVpmMWFYN1pKWVEl
NUQtUFJYTXRtMlhFZUZQbjhVWWlXMWdnNllVeHhjDQoNCuWmguaenOaCqOeCueWHu+atpOmTvuaO
peWQjuWPkeeOsOWug+WPr+iDveW3suaNn+Wdj++8jOivt+WkjeWItuatpOmTvuaOpeW5tuWwhuWF
tueymOi0tOWIsOaWsOeahOa1j+iniOWZqOeql+WPo+S4reOAguWmguaenOaCqOaXoOazleiuv+mX
ruatpOmTvuaOpe+8jOWImeaCqOWPr+S7peWwhuehruiupOS7o+eggSA1NjUwMjIxNDkNCuWPkemA
geiHsyBibHVjZXJsZWVAZ21haWwuY29t44CCDQoNCuaEn+iwouaCqOS9v+eUqCBHbWFpbO+8gQ0K
DQpHbWFpbCDlsI/nu4TmlazkuIoNCg0K5aaC5p6c5oKo5LiN5om55YeG5q2k6K+35rGC77yM5YiZ
5LiN6ZyA6KaB5omn6KGM6L+b5LiA5q2l5pON5L2c44CC6Zmk6Z2e5oKo54K55Ye75LiK6Z2i55qE
6ZO+5o6l56Gu6K6k5q2k6K+35rGC77yM5ZCm5YiZIGJsdWNlcmxlZUBnbWFpbC5jb20NCuWwseaX
oOazleiHquWKqOWwhumCruS7tui9rOWPkeWIsOaCqOeahOeUteWtkOmCruS7tuWcsOWdgOOAguWm
guaenOaCqOaXoOaEj+S4reeCueWHu+S6huatpOmTvuaOpe+8jOS9huW5tuS4jeaDs+iuqSBibHVj
ZXJsZWVAZ21haWwuY29tDQroh6rliqjlsIbpgq7ku7bovazlj5HliLDmgqjnmoTlnLDlnYDvvIzo
r7fngrnlh7vku6XkuIvpk77mjqXlj5bmtojmraTpqozor4HvvJoNCmh0dHBzOi8vbWFpbC1zZXR0
aW5ncy5nb29nbGUuY29tL21haWwvdWYtJTVCQU5HamRKOXBUXy14VHUteVhhYmdTajgxMWdJVGhG
XzdVSVFFVkFkWmNxaUVfcnFhLTU5T2VncEJzSEJ0V1pHOUU5dXRFQ1dIOTRnSjl6WF81Sk1hcFk1
dlU5dVgtYzhjRkY3elBLTEVhQSU1RC1QUlhNdG0yWEVlRlBuOFVZaVcxZ2c2WVV4eGMNCg0K6KaB
6K+m57uG5LqG6Kej5Li65LuA5LmI5oKo5Lya5pS25Yiw5q2k6YKu5Lu277yM6K+36K6/6Zeu77ya
aHR0cDovL3N1cHBvcnQuZ29vZ2xlLmNvbS9tYWlsL2Jpbi9hbnN3ZXIucHk/YW5zd2VyPTE4NDk3
MyZobD16aF9DTuOAgg0KDQror7fkuI3opoHlm57lpI3mraTpgq7ku7bjgILlpoLmnpzmgqjopoHk
uI4gR29vZ2xlLmNvbSDlsI/nu4TogZTns7vvvIzor7fnmbvlvZXmgqjnmoTluJDlj7fvvIzngrnl
h7vku7vkvZXpobXpnaLpobbpg6jnmoTigJzluK7liqnigJ3vvIznhLblkI7ngrnlh7vigJzluK7l
iqnkuK3lv4PigJ3lupXpg6jnmoTigJzkuI7miJHku6zogZTns7vigJ3jgIINCg==
