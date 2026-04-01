Return-Path: <linux-erofs+bounces-3158-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D7610F6FC2
	for <linux-erofs@archiver.kernel.org>; Wed,  1 Apr 2026 15:08:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fm7fp2Jt7z2xS3;
	Thu, 02 Apr 2026 02:08:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::b14a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775056130;
	cv=none; b=FtLW1OO/ICkXLPcfoS/+iGLPOx/LY9U8pH4Gkwx0/LcY53GSNWnYXXrrqqRTBMpr4sYMu19saBOdWT7Lqo6tCnsQgWda7pTOO4eZptTEJZNOzgJ7+ZtUMVI3F1ZedkE4fLiPdPxY5bVqJE3f82Ap1Sn82IXJYGCxnB0EJ/zeTz2pT8vwSXOuPC4LEFn8dJUqbRoFjPtyoRkJm9AlxyYkLytNZyRSDKxBPLWh+sBcViRVeybidOdvx/aQ2Z35XuMvX8oVxHA+7ZSTSm7IMvAku/jt0qTXtNRHXXd1PHfv4rQrDAwxaH89Iu5Dll/79GWINM8lcv8a1L1aw9xakjJOgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775056130; c=relaxed/relaxed;
	bh=zm9Koiu7zNlVYqzZCz8CStmnrWGZgNciLdGJSK4GbLM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=hqgKf2H0K5qHgvMRZycq3j8zkklX/EnFyVyFi7TnoLiltNGJrDs9JQhukN6B2V+6uC+FPg+X30+3eIsxUbXNP7axY0K0+l5Z9QVxAbCOQ9OChuTFOSDDKQG8BKgYas+VRSx7Nwjjhmvbak8iiHnsJweewmvswghSUlzAUpvzWXGng5mAzj9sqiDI+ADr/MRUcx9XcbuwKFvLydOmHlqisrwjBFmUNNun5JLyR7G51jzYhML18/uS5qeRIqv/BkHFyfLM3Z5eGu/6TAqasf0wh8wqcPZltAjHAcd0c8vNS3xAyUklMlfPniNduezlI6VmuAmK+LupirK2aUXbPsaieg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=SoZheoIk; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::b14a; helo=mail-yx1-xb14a.google.com; envelope-from=gsoc-support@google.com; receiver=lists.ozlabs.org) smtp.mailfrom=google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=SoZheoIk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=google.com (client-ip=2607:f8b0:4864:20::b14a; helo=mail-yx1-xb14a.google.com; envelope-from=gsoc-support@google.com; receiver=lists.ozlabs.org)
Received: from mail-yx1-xb14a.google.com (mail-yx1-xb14a.google.com [IPv6:2607:f8b0:4864:20::b14a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fm7fm1939z2xLt
	for <linux-erofs@lists.ozlabs.org>; Thu, 02 Apr 2026 02:08:47 +1100 (AEDT)
Received: by mail-yx1-xb14a.google.com with SMTP id 956f58d0204a3-65019e029c1so9476395d50.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 01 Apr 2026 08:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775056124; x=1775660924; darn=lists.ozlabs.org;
        h=mime-version:subject:references:in-reply-to:message-id:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zm9Koiu7zNlVYqzZCz8CStmnrWGZgNciLdGJSK4GbLM=;
        b=SoZheoIkyPEqzHPLUY3NrdptDfANCrK3NlqbnAel3kRWqFcQnhXGKOmT4EJ0rSzo3E
         eH+hH45W4xHVVNkBIoblqeCt46BSTE6Y/UzQSJ7jON1TLFBDcjKQ+pmjRm1+iaqkYJkO
         Sqmb+FFOEuiiIiuQFXrCGHzv/Qv+9dMMOy8KLBkPIUNlVtIsBNJie0PbCdegxcZxdpnz
         5eqNHsWsdV6M4nEE5sGMiFf6Z9V8cBhM1XQzoYzfC17pYoTVWBtIVpcggJiK+wpL0M1n
         5OGW+lS68LWZ32V85PuC+ca+6ehwZ6SSwEkgyLxlScazNsGKaDTtV/jNbTaJnblZFlol
         5eKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775056124; x=1775660924;
        h=mime-version:subject:references:in-reply-to:message-id:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zm9Koiu7zNlVYqzZCz8CStmnrWGZgNciLdGJSK4GbLM=;
        b=e8jT9MD6NvsCK9wZhsUR4P2kGepzPu0AojJQ9M1w9jIN5JTEzo+bIrUIlEjSy9jJvS
         UEl9Hq4yXxyRISEt2k/6jLDPKNc5uFTSrpZPyOHo1vTPJ90asTrO+KQz13IbusqFVmWQ
         gs6DDZp708yjvrpGCdBxvK7X4P99UoomgUlxIDOGR9dOSKi5qLiQgae6PRk7B/dOAcrf
         c2g8vDhGLSpuUuy8n3yAPwu4CWZytpKsqLR2aolw1SqjOCWeOamoybcXQpDBxjeGTHxB
         b8CKcqnJi9XG/+PN8vnwSo9oFVYmvB817LW+dMy9P1XNeLo9ja0bgVqTtEZ3QbueFMTf
         KO1g==
X-Gm-Message-State: AOJu0YzY0ep4jDswRDHBoXN5a8v3FWiUazgYf8pYvXDAE9UQ3BJAjZ62
	wYeEZvhsh4NfMkQMfCf4mVKFHuvG4lXhnyOg6ekxj+i/eGPwaayrZ8iYkrtucxaNtqKIf6Kr7ML
	PKqnGs+tspD5znaXV6TBpfxREc/AmgGjWNktZ/1LgarqBP961O8q6sjIDyDFY+RrPVogX2U7Emx
	zwGH0cyROjqjZzWpXS0Q==
X-Received: by 2002:a05:690e:4402:b0:64a:db39:f002 with SMTP id 956f58d0204a3-6502fcd984cmr3335122d50.0.1775056124223;
        Wed, 01 Apr 2026 08:08:44 -0700 (PDT)
Received: from smtp02-ia6-sp4.mta.salesforce.com (smtp02-ia6-sp4.mta.salesforce.com. [13.110.242.177])
        by gmr-mx.google.com with ESMTPS id 956f58d0204a3-6503a95c22esi3017d50.4.2026.04.01.08.08.44
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 08:08:44 -0700 (PDT)
Authentication-Results:  mx2-ia6-sp4.mta.salesforce.com x-tls.subject="/C=US/ST=California/L=San Francisco/O=salesforce.com, inc./OU=0:app;1:ia6;2:ia6-sp4;3:na247;4:prod/CN=na247-app1-27-ia6.ops.sfdc.net"; auth=pass (cipher=TLS_AES_256_GCM_SHA384)
Received: from [10.224.205.92] ([10.224.205.92:41198] helo=na247-app1-27-ia6.ops.sfdc.net)
	by mx2-ia6-sp4.mta.salesforce.com (envelope-from <gsoc-support@google.com>)
	(ecelerity 4.7.0.20112 r(msys-ecelerity:salesforce/4.7/sb1)) with ESMTPS (cipher=TLS_AES_256_GCM_SHA384
	subject="/C=US/ST=California/L=San Francisco/O=salesforce.com, inc./OU=0:app;1:ia6;2:ia6-sp4;3:na247;4:prod/CN=na247-app1-27-ia6.ops.sfdc.net") 
	id FA/5C-36148-CF43DC96; Wed, 01 Apr 2026 15:08:44 +0000
Date: Wed, 1 Apr 2026 15:08:44 +0000 (GMT)
From: GSoC Support <gsoc-support@google.com>
To: "bushrahz.giki@gmail.com" <bushrahz.giki@gmail.com>
Cc: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Message-ID: <d_rMO000000000000000000000000000000000000000000000TCTM2J00loEVDwndQfigB8rc9Ozi4Q@sfdc.net>
In-Reply-To: <CA+ug3icM1dnMfjtesxSFtM9yJWCxzfG6oyeur1KGPQ8384G-Qw@mail.gmail.com>
References: <CA+ug3icM1dnMfjtesxSFtM9yJWCxzfG6oyeur1KGPQ8384G-Qw@mail.gmail.com>
Subject: =?UTF-8?Q?RE:_Request_for_Late_Proposal_Su?=
 =?UTF-8?Q?bmission_=E2=80=93_Medical_Emergency_Dur?=
 =?UTF-8?Q?ing_Application_Period____[_ref:?=
 =?UTF-8?Q?!00D1U013lbu.!500Kd0300s0L:ref_]?=
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_290_1908080714.1775056124148"
X-SFDC-LK: 00D1U0000013lbu
X-SFDC-User: 0056e00000EKg1f
X-Sender: postmaster@salesforce.com
X-mail_abuse_inquiries: https://www.salesforce.com/company/legal/abuse
X-SFDC-ORGTYPE: ACTIVE
X-SFDC-CORRELATION-ID: 0003cniipmogj54m
X-SFDCOrgRelay: 00D1U0000013lbu
X-SFDC-Binding: 1WrIRBV94myi25uB
X-SFDC-EmailCategory: quickActionEmail
X-SFDC-EntityId: 500Kd0000300s0L
X-SFDC-Interface: internal
X-SFDC-Restrict: ^(.*)
X-SFDCRelayAddr: gmr-smtp-in.l.google.com
X-SFDCRelayPort: 25
X-SFDCTLS: 0

------=_Part_290_1908080714.1775056124148
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Registration and proposal submissions for Google Summer of Code 2026 closed=
 on March 31 at 18:00 UTC.

To maintain fairness for all participants, we do not grant extensions or ex=
ceptions for any reason. This includes:

Misinterpretations of the timeline
Technical issues or submission errors
Internet outages
Any other reason

As stated in our guidelines, it is the applicant's responsibility to submit=
 well in advance of the deadline.

While the window for this year has closed, we encourage you to:

Review the Contributor Guide at g.co/gsoc: Specifically the "Choosing an Or=
ganization" section.
Stay Connected: Engage with organizations independently to prepare for futu=
re applications.

Note: Due to our team's small size, we cannot respond to further inquiries =
regarding missed deadlines. We hope to see your application in a future cyc=
le!

Best,

GSoC Admins





--------------- Original Message ---------------
From: Bushrah Zulfiqar [bushrahz.giki@gmail.com]
Sent: 4/1/2026 6:22 AM
To: linux-erofs@lists.ozlabs.org; gsoc-support@google.com
Subject: Request for Late Proposal Submission =E2=80=93 Medical Emergency D=
uring Application Period
Dear Google Summer of Code Admissions Team,

I hope this message finds you well. I am writing to respectfully request yo=
ur consideration for a late proposal submission for GSoC 2026, due to an un=
foreseen medical emergency that prevented me from submitting my application=
 before the deadline.

During the final days of the application window, I was hospitalized due to =
a medical emergency that required immediate attention and several days of r=
ecovery. Unfortunately, this coincided directly with the submission deadlin=
e, making it impossible for me to finalize and submit my proposal in time.

I want to emphasize that this was not a case of poor planning or procrastin=
ation. I had been actively preparing for months and was well on track to su=
bmit before the deadline. Specifically:

=E2=80=A2 I identified my target organization and project well in advance a=
nd had been studying the codebase for over two weeks to deeply understand t=
he architecture, design patterns, and contribution workflow.
=E2=80=A2 I made code contributions to the repository, demonstrating both m=
y technical ability and my commitment to the project.
=E2=80=A2 I prepared detailed documentation and notes on my understanding o=
f the codebase, the problem space, and my proposed approach.
=E2=80=A2 My proposal was substantially complete and only needed final revi=
ew before submission.

I fully understand that deadlines exist for good reason and that making exc=
eptions is not taken lightly. However, I am humbly requesting that you cons=
ider my situation and, if at all possible, allow me to submit my proposal l=
ate. I am happy to provide medical documentation to verify the nature and t=
iming of my emergency.

This opportunity means a great deal to me. GSoC has been a goal I have been=
 working toward with genuine dedication, and I would be deeply grateful for=
 any accommodation that might be possible.

Thank you sincerely for your time and consideration. I completely understan=
d if the policy does not allow for exceptions, but I wanted to at least rea=
ch out and explain my circumstances.

Warm regards,
Bushrah Zulfiqar
bushrahz.giki@gmail.com


--

Lucila Ort=C3=ADz | GSoC Admin

Google Summer of Code 2026

184 Mentoring Orgs announced
Contributor apps open March 16 - 31

g.co/gsoc
ref:!00D1U013lbu.!500Kd0300s0L:ref
------=_Part_290_1908080714.1775056124148
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
<head>
=09<title></title>
</head>
<body>
<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">Registration and proposal submissions for Google Summer =
of Code 2026 closed on </span></span></span></span></span></span><span styl=
e=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span style=
=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span style=
=3D"font-weight:700"><span style=3D"font-style:normal"><span style=3D"text-=
decoration:none">March 31 at 18:00 UTC</span></span></span></span></span></=
span><span style=3D"font-size:11pt; font-variant:normal; white-space:pre-wr=
ap"><span style=3D"font-family:Arial,sans-serif"><span style=3D"color:#0000=
00"><span style=3D"font-weight:400"><span style=3D"font-style:normal"><span=
 style=3D"text-decoration:none">.</span></span></span></span></span></span>=
</p>

<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">To maintain fairness for all participants, we do not gra=
nt extensions or exceptions for any reason. This includes:</span></span></s=
pan></span></span></span></p>

<ul>
=09<li aria-level=3D"1" style=3D"list-style-type:disc"><span style=3D"font-=
size:11pt; font-variant:normal; white-space:pre-wrap"><span style=3D"font-f=
amily:Arial,sans-serif"><span style=3D"color:#000000"><span style=3D"font-w=
eight:400"><span style=3D"font-style:normal"><span style=3D"text-decoration=
:none">Misinterpretations of the timeline</span></span></span></span></span=
></span></li>
=09<li aria-level=3D"1" style=3D"list-style-type:disc"><span style=3D"font-=
size:11pt; font-variant:normal; white-space:pre-wrap"><span style=3D"font-f=
amily:Arial,sans-serif"><span style=3D"color:#000000"><span style=3D"font-w=
eight:400"><span style=3D"font-style:normal"><span style=3D"text-decoration=
:none">Technical issues or submission errors</span></span></span></span></s=
pan></span></li>
=09<li aria-level=3D"1" style=3D"list-style-type:disc"><span style=3D"font-=
size:11pt; font-variant:normal; white-space:pre-wrap"><span style=3D"font-f=
amily:Arial,sans-serif"><span style=3D"color:#000000"><span style=3D"font-w=
eight:400"><span style=3D"font-style:normal"><span style=3D"text-decoration=
:none">Internet outages</span></span></span></span></span></span></li>
=09<li aria-level=3D"1" style=3D"list-style-type:disc"><span style=3D"font-=
size:11pt; font-variant:normal; white-space:pre-wrap"><span style=3D"font-f=
amily:Arial,sans-serif"><span style=3D"color:#000000"><span style=3D"font-w=
eight:400"><span style=3D"font-style:normal"><span style=3D"text-decoration=
:none">Any other reason</span></span></span></span></span></span></li>
</ul>

<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">As stated in our guidelines, it is the applicant&#39;s r=
esponsibility to submit well in advance of the deadline.</span></span></spa=
n></span></span></span></p>

<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">While the window for this year has closed, we encourage =
you to:</span></span></span></span></span></span></p>

<ul>
=09<li aria-level=3D"1" style=3D"list-style-type:disc"><span style=3D"font-=
size:11pt; font-variant:normal; white-space:pre-wrap"><span style=3D"font-f=
amily:Arial,sans-serif"><span style=3D"color:#000000"><span style=3D"font-w=
eight:700"><span style=3D"font-style:normal"><span style=3D"text-decoration=
:none">Review the Contributor Guide at g.co/gsoc:</span></span></span></spa=
n></span></span><span style=3D"font-size:11pt; font-variant:normal; white-s=
pace:pre-wrap"><span style=3D"font-family:Arial,sans-serif"><span style=3D"=
color:#000000"><span style=3D"font-weight:400"><span style=3D"font-style:no=
rmal"><span style=3D"text-decoration:none"> Specifically the &quot;Choosing=
 an Organization&quot; section.</span></span></span></span></span></span></=
li>
=09<li aria-level=3D"1" style=3D"list-style-type:disc"><span style=3D"font-=
size:11pt; font-variant:normal; white-space:pre-wrap"><span style=3D"font-f=
amily:Arial,sans-serif"><span style=3D"color:#000000"><span style=3D"font-w=
eight:700"><span style=3D"font-style:normal"><span style=3D"text-decoration=
:none">Stay Connected:</span></span></span></span></span></span><span style=
=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span style=
=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span style=
=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"text-=
decoration:none"> Engage with organizations independently to prepare for fu=
ture applications.</span></span></span></span></span></span></li>
</ul>

<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:700"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">Note:</span></span></span></span></span></span><span sty=
le=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span styl=
e=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span styl=
e=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"text=
-decoration:none"> Due to our team&#39;s small size, we cannot respond to f=
urther inquiries regarding missed deadlines. We hope to see your applicatio=
n in a future cycle!</span></span></span></span></span></span></p>

<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">Best,</span></span></span></span></span></span></p>

<p style=3D"line-height:1.38; margin-top:16px; margin-bottom:16px"><span st=
yle=3D"font-size:11pt; font-variant:normal; white-space:pre-wrap"><span sty=
le=3D"font-family:Arial,sans-serif"><span style=3D"color:#000000"><span sty=
le=3D"font-weight:400"><span style=3D"font-style:normal"><span style=3D"tex=
t-decoration:none">GSoC Admins</span></span></span></span></span></span></p=
>
<br />
<br clear=3D"none" />
<br clear=3D"none" />
<br clear=3D"none" />
--------------- Original Message ---------------<br clear=3D"none" />
<b>From:</b> Bushrah Zulfiqar [bushrahz.giki@gmail.com]<br clear=3D"none" /=
>
<b>Sent:</b> 4/1/2026 6:22 AM<br clear=3D"none" />
<b>To:</b> linux-erofs@lists.ozlabs.org; gsoc-support@google.com<br clear=
=3D"none" />
<b>Subject:</b> Request for Late Proposal Submission &ndash; Medical Emerge=
ncy During Application Period<br clear=3D"none" />
&nbsp;
<div dir=3D"ltr">Dear Google Summer of Code Admissions Team,<br clear=3D"no=
ne" />
<br clear=3D"none" />
I hope this message finds you well. I am writing to respectfully request yo=
ur consideration for a late proposal submission for GSoC 2026, due to an un=
foreseen medical emergency that prevented me from submitting my application=
 before the deadline.<br clear=3D"none" />
<br clear=3D"none" />
During the final days of the application window, I was hospitalized due to =
a medical emergency that required immediate attention and several days of r=
ecovery. Unfortunately, this coincided directly with the submission deadlin=
e, making it impossible for me to finalize and submit my proposal in time.<=
br clear=3D"none" />
<br clear=3D"none" />
I want to emphasize that this was not a case of poor planning or procrastin=
ation. I had been actively preparing for months and was well on track to su=
bmit before the deadline. Specifically:<br clear=3D"none" />
<br clear=3D"none" />
&bull; I identified my target organization and project well in advance and =
had been studying the codebase for over two weeks to deeply understand the =
architecture, design patterns, and contribution workflow.<br clear=3D"none"=
 />
&bull; I made code contributions to the repository, demonstrating both my t=
echnical ability and my commitment to the project.<br clear=3D"none" />
&bull; I prepared detailed documentation and notes on my understanding of t=
he codebase, the problem space, and my proposed approach.<br clear=3D"none"=
 />
&bull; My proposal was substantially complete and only needed final review =
before submission.<br clear=3D"none" />
<br clear=3D"none" />
I fully understand that deadlines exist for good reason and that making exc=
eptions is not taken lightly. However, I am humbly requesting that you cons=
ider my situation and, if at all possible, allow me to submit my proposal l=
ate. I am happy to provide medical documentation to verify the nature and t=
iming of my emergency.<br clear=3D"none" />
<br clear=3D"none" />
This opportunity means a great deal to me. GSoC has been a goal I have been=
 working toward with genuine dedication, and I would be deeply grateful for=
 any accommodation that might be possible.<br clear=3D"none" />
<br clear=3D"none" />
Thank you sincerely for your time and consideration. I completely understan=
d if the policy does not allow for exceptions, but I wanted to at least rea=
ch out and explain my circumstances.<br clear=3D"none" />
<br clear=3D"none" />
Warm regards,<br clear=3D"none" />
Bushrah Zulfiqar<br clear=3D"none" />
<a href=3D"mailto:bushrahz.giki@gmail.com" shape=3D"rect" target=3D"_blank"=
>bushrahz.giki@gmail.com</a><br clear=3D"none" />
&nbsp;</div>
<br />
<br />
--<br />
<br />
Lucila Ort&iacute;z | GSoC Admin<br />
<br />
Google Summer of Code 2026<br />
<br />
184 Mentoring Orgs announced<br />
Contributor apps open March 16 - 31<br />
<br />
g.co/gsoc<img alt=3D"" src=3D"https://googleospo.my.salesforce.com/servlet/=
servlet.ImageServer?oid=3D00D1U0000013lbu&esid=3D018Kd000016oYpF&from=3Dext=
"><br><br>ref:!00D1U013lbu.!500Kd0300s0L:ref</body>
</html>
------=_Part_290_1908080714.1775056124148--

