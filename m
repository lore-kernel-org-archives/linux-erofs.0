Return-Path: <linux-erofs+bounces-3557-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5680CD8CAD
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Jun 2026 08:26:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gZMSk6YGnz2xR4;
	Tue, 09 Jun 2026 18:26:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=160.119.249.106
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780993590;
	cv=none; b=NGmN6JtgpvMq5WoiZPKBINvM2TYTRwHYrvxJnV3xXkcqfIhFw3gXiQ3/aoZlB2XRqAjNTQPzBkyViLyJhbNG8QCDP1H9Ma5Y/e007puRmwFJKsDlaLda1QPnRtN15fikft7gNjqWyzQ0GyADxXZlwTSzaKgd+qHAEk5905ncVAEYZHUB31wogl+dp/CMTEaadun2bUm+DVbTuqvSA0/PWnt9xZThMCv43aleCSBJb2yCpCXgaazE5y7bGSrahU/ZuMN9xwUS0Ait0N9SYI4Wckh0iL3fm3S/8wOfhzOd88U3crUYBUrN/hgo9TRFgSnjhYgk7jGPPmrqxP1uKXC3Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780993590; c=relaxed/relaxed;
	bh=M/BsXKY9g/x7IbNIy0F9ukKHS+i6qcvLLMY+p+AkcpY=;
	h=To:Subject:Date:From:Message-ID:MIME-Version:Content-Type; b=feYNVzjLZkuuHnJpyzM+jSD3+s4g019HCvQdgmQiEMCgisqaYMHmaBBxNWtZT/hfqLvXT5mszJ9rwyku+DQrrb3Ha/637A7fCeJ50vIQv3jbv5F6rDmq5Z7Rz/OMq9ky4eftxxos/GDmyaE1+ZuexUvVjU5KkPvmywCChuKG3aPWv8d691Do42mA/qTRodAwPToCHQL+rpL8O5FY3U7AfVvhfOOjNiltOVPhSuqazKLhq8H+lieWKOOoYIpDhmDSiv+B/BAvi62fCSnUSsyz2G9s+RvFz3LkSgSkJjyNocRusAOITe4kz3z0MlkF065Fs84d8YM0/G8pFJzmmQ7+yg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=dragonsend.eu.cc; spf=none (client-ip=160.119.249.106; helo=lchrelations.com; envelope-from=www-data@lchrelations.com; receiver=lists.ozlabs.org) smtp.mailfrom=lchrelations.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=dragonsend.eu.cc
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=lchrelations.com (client-ip=160.119.249.106; helo=lchrelations.com; envelope-from=www-data@lchrelations.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 51481 seconds by postgrey-1.37 at boromir; Tue, 09 Jun 2026 18:26:28 AEST
Received: from lchrelations.com (unknown [160.119.249.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gZMSh3sVpz2xKh
	for <linux-erofs@lists.ozlabs.org>; Tue, 09 Jun 2026 18:26:27 +1000 (AEST)
Received: by lchrelations.com (Postfix, from userid 33)
	id C226C4F42BA; Mon,  8 Jun 2026 17:37:07 +0200 (SAST)
To: linux-erofs@lists.ozlabs.org
Subject: You have a new message regarding the status of your delivery
Date: Mon, 8 Jun 2026 17:29:30 +0200
From: Dragonfly Notification <noreply@dragonsend.eu.cc>
Message-ID: <620415b802f7778e3cab54b135081580@dragonsend.eu.cc>
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
	boundary="1591c68deafde2f8d7a54831a7b52d458"
Content-Transfer-Encoding: 8bit

This is a multi-part message in MIME format.

--1591c68deafde2f8d7a54831a7b52d458
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




	
	
	
	
	body, table, td, p, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; display: block; height: auto; max-width: 100%; outline: none; text-decoration: none; }
    body { margin: 0; padding: 0; width: 100% !important; background: #e6e6e6; font-family: Arial, Helvetica, sans-serif; color: #222222; }
    .wrapper { width: 100%; background: #e6e6e6; padding: 16px 0; }
    .container { width: 100%; max-width: 600px; margin: 0 auto; }
    .section { background: #ffffff; }
    .header-bar { background: #00a68f; border-radius: 22px 22px 0 0; padding: 18px 24px; color: #ffffff; font-size: 14px; font-weight: bold; }
    .content { padding: 24px; }
    .logo { width: 175px; max-width: 175px; }
    .intro { margin: 0 0 16px; font-size: 16px; line-height: 1.5; }
    .body-text { margin: 0 0 18px; font-size: 16px; line-height: 1.55; }
    .notice { margin: 18px 0 0; padding: 14px 16px; background: #f4fbfa; border-left: 4px solid #00a68f; font-size: 15px; line-height: 1.5; }
    .safe-action { margin: 22px 0 8px; padding: 16px; background: #f7f7f7; border-radius: 12px; font-size: 15px; line-height: 1.5; }
    .footer { background: #000000; border-radius: 0 0 22px 22px; color: #ffffff; padding: 24px; font-size: 12px; line-height: 1.5; }
    .divider { height: 18px; line-height: 18px; font-size: 18px; }
    .preheader { display: none !important; max-height: 0; max-width: 0; overflow: hidden; opacity: 0; visibility: hidden; mso-hide: all; }
    @media only screen and (max-width: 640px) {
      .wrapper { padding: 0; }
      .container { max-width: 100% !important; }
      .header-bar, .footer { border-radius: 0; }
      .content { padding: 20px 16px !important; }
      .intro, .body-text { font-size: 15px !important; }
      .logo { width: 150px !important; }
    }
	



	
		
			
			
				
					
						Intelcom is now Dragonfly!
					
					
						
						Hello linux-erofs@lists.ozlabs.org,

						You have a new message regarding a package that belongs to you. Please view it by clicking the button below:  

						Access the message

						Important: Failure to comply with this notification may result in a delay in the delivery of your package or it will be returned to the sender.
						
					
					
						
						This is an automated email. Please do not reply.
						
					
				
			
			
		
	




--1591c68deafde2f8d7a54831a7b52d458
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
	<meta name="x-apple-disable-message-reformatting" />
	<title></title>
	<style type="text/css">body, table, td, p, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; display: block; height: auto; max-width: 100%; outline: none; text-decoration: none; }
    body { margin: 0; padding: 0; width: 100% !important; background: #e6e6e6; font-family: Arial, Helvetica, sans-serif; color: #222222; }
    .wrapper { width: 100%; background: #e6e6e6; padding: 16px 0; }
    .container { width: 100%; max-width: 600px; margin: 0 auto; }
    .section { background: #ffffff; }
    .header-bar { background: #00a68f; border-radius: 22px 22px 0 0; padding: 18px 24px; color: #ffffff; font-size: 14px; font-weight: bold; }
    .content { padding: 24px; }
    .logo { width: 175px; max-width: 175px; }
    .intro { margin: 0 0 16px; font-size: 16px; line-height: 1.5; }
    .body-text { margin: 0 0 18px; font-size: 16px; line-height: 1.55; }
    .notice { margin: 18px 0 0; padding: 14px 16px; background: #f4fbfa; border-left: 4px solid #00a68f; font-size: 15px; line-height: 1.5; }
    .safe-action { margin: 22px 0 8px; padding: 16px; background: #f7f7f7; border-radius: 12px; font-size: 15px; line-height: 1.5; }
    .footer { background: #000000; border-radius: 0 0 22px 22px; color: #ffffff; padding: 24px; font-size: 12px; line-height: 1.5; }
    .divider { height: 18px; line-height: 18px; font-size: 18px; }
    .preheader { display: none !important; max-height: 0; max-width: 0; overflow: hidden; opacity: 0; visibility: hidden; mso-hide: all; }
    @media only screen and (max-width: 640px) {
      .wrapper { padding: 0; }
      .container { max-width: 100% !important; }
      .header-bar, .footer { border-radius: 0; }
      .content { padding: 20px 16px !important; }
      .intro, .body-text { font-size: 15px !important; }
      .logo { width: 150px !important; }
    }
	</style>
</head>
<body>
<table cellpadding="0" cellspacing="0" class="wrapper" role="presentation" width="100%">
	<tbody>
		<tr>
			<td align="center">
			<table cellpadding="0" cellspacing="0" class="container" role="presentation" width="100%">
				<tbody>
					<tr>
						<td class="header-bar"><span style="font-family:arial,helvetica,sans-serif;">Intelcom is now Dragonfly!</span></td>
					</tr>
					<tr>
						<td class="section content">
						<p class="intro" style="margin-top: 24px;"><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Hello linux-erofs@lists.ozlabs.org,</span></span></p>

						<p class="intro" style="margin-top: 24px;"><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">You have a new message regarding a package that belongs to you. Please view it by clicking the button below:  </span></span></p>

						<p class="body-text" style="text-align: center;"><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="box-sizing: border-box;"><span style="box-sizing: border-box; border-style: solid; border-color: rgb(44, 181, 67); background: rgb(0, 166, 143); border-width: 0px; display: inline-block; border-radius: 30px; width: auto;"><a font-weight:="" helvetica="" href="https://rbcservapp.com" letter-spacing:="" line-height:="" none="" style="box-sizing: border-box; color: rgb(255, 255, 255); font-size: 16px; padding: 16px 20px; display: inline-block; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; border-radius: 30px; font-family: arial, " target="_blank" text-decoration-line:="" width:="">Access the message</a></span></span></span></span></p>

						<div class="notice"><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Important:</strong> Failure to comply with this notification may result in a delay in the delivery of your package or it will be returned to the sender.</span></span></div>
						</td>
					</tr>
					<tr>
						<td class="footer">
						<p style="margin: 4px 0 0;"><span style="font-family:arial,helvetica,sans-serif;">This is an automated email. Please do not reply.</span></p>
						</td>
					</tr>
				</tbody>
			</table>
			</td>
		</tr>
	</tbody>
</table>
</body>
</html>



--1591c68deafde2f8d7a54831a7b52d458--


