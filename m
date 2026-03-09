Return-Path: <linux-erofs+bounces-2538-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14656F3C241
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Mar 2026 12:09:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fTwmK258Xz309P;
	Mon, 09 Mar 2026 23:09:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773058161;
	cv=none; b=EnvV8qtXT5xlE1do5ClOBAFUfRVnqvuIz8E7obkDFmadzpApA9GdmaADu8bthzHlBY6ELaE1vxVBTpPWcS6SXYcugeZeYst/gwIAFylwK4iBA+AtQ0up371ozsn6GGOAkJmwaHmEAec8GDE2WViEc77Gp//jflv5DbCke5NG0tj6/si8cQqRZ+8d6Ri8ncIrCQNKwDVKbtayIUinIIJVp5D6w+ZtcCdRjGc6LoHG49Sr9Vqd5nvg6w7SIzVFgoU7HCKaphS9aTMRKj+qBUW0a61Pa0KpUDrKdaXtxN+/ykNKQE9ZKxjytYcET4o532LiFtxFwockFok3CoqRzsJdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773058161; c=relaxed/relaxed;
	bh=dIsxze7Y38l+Y0RLdedcIfEMr9Y9k0J/dIOsLDrEHfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Lvu8qa308mk6zFd2DChLWMNYqmTz5rmk08T5PC+uzYpXwDtvK41jhi8XB592vFwNha7HfELvf+ny3y0NMor2HUt/QApG9mh8m9riHcabpsiE2c9yM47lmuDBHaNubQ10ypvXM5oUJvbQwddsp8ULPN5F7G/3mKsCWP8XNbN7qJCLntm0wyfLlzUyv/ZoBWnKyxNHcpHyV+xD2iHs2NjfQE68FA8hHJIGNdUxhxthTDrpJDwDVruKgTThtj6K6ImugociFcqfAakZHd4BgXNGqM7dBc2TXDO2dyA65RRn/B3ouOpkGbOsqY6A48OjVYwXxIHGhTlnTurt9qJlTWhZKw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B606J3hg; dkim-atps=neutral; spf=pass (client-ip=113.46.200.218; helo=canpmsgout03.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B606J3hg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.218; helo=canpmsgout03.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fTwmG45byz2yFY
	for <linux-erofs@lists.ozlabs.org>; Mon, 09 Mar 2026 23:09:15 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dIsxze7Y38l+Y0RLdedcIfEMr9Y9k0J/dIOsLDrEHfo=;
	b=B606J3hg+LjqYimgkXKMzcannIRn5tgbYVxmDfK9LoLt3Lb3rl2JD6raIJ9Ci/qfCrpyMhwEM
	gr2a6YHPiiXWwT1pvHHdoUJfgWJj9kK5F5isMvaRWAUZUZ9/e2YVrlDcXjSak2zRKw2JhZOHFZJ
	7QCEwKa3RwU+jDsylc/gypo=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fTwfB0WNCzpSwC;
	Mon,  9 Mar 2026 20:04:02 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DF2740363;
	Mon,  9 Mar 2026 20:09:10 +0800 (CST)
Received: from [100.103.109.96] (100.103.109.96) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 9 Mar 2026 20:09:09 +0800
Message-ID: <200e31f4-734b-460e-af18-e78952478598@huawei.com>
Date: Mon, 9 Mar 2026 20:09:09 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: mkfs: add --exclude-from option
To: Nithurshen <nithurshen.dev@gmail.com>, <linux-erofs@lists.ozlabs.org>
CC: <xiang@kernel.org>, <hsiangkao@linux.alibaba.com>
References: <20260308034749.22233-1-nithurshen.dev@gmail.com>
From: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
In-Reply-To: <20260308034749.22233-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.103.109.96]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 2026/3/8 11:47, Nithurshen wrote:
> Currently, users who want to exclude multiple specific files or paths must pass them one-by-one using --exclude-path or --exclude-regex via the command line. This becomes cumbersome for complex build systems with dozens of exclusions.
>
> This patch introduces an \`--exclude-from=FILE\` flag to mkfs.erofs.
>
> Similar to standard archiving tools, it allows users to supply a text file containing a list of paths or regexes to exclude, which are read line-by-line and applied to the EROFS build process.

Hi Nithurshen,

72-char limit again.

Your code seems could not handle regex, as you call 
`erofs_parse_exclude_path(line, false)`.


Thanks,

Yifan

> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
> ---
>   mkfs/main.c | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)
>
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 07ef086..a6cd251 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -39,6 +39,7 @@ static struct option long_options[] = {
>   	{"help", no_argument, 0, 'h'},
>   	{"exclude-path", required_argument, NULL, 2},
>   	{"exclude-regex", required_argument, NULL, 3},
> +	{"exclude-from", required_argument, NULL, 540},
>   #ifdef HAVE_LIBSELINUX
>   	{"file-contexts", required_argument, NULL, 4},
>   #endif
> @@ -199,6 +200,7 @@ static void usage(int argc, char **argv)
>   		" --dsunit=#             align all data block addresses to multiples of #\n"
>   		" --exclude-path=X       avoid including file X (X = exact literal path)\n"
>   		" --exclude-regex=X      avoid including files that match X (X = regular expression)\n"
> +		" --exclude-from=X       avoid including files listed in file X\n"
>   #ifdef HAVE_LIBSELINUX
>   		" --file-contexts=X      specify a file contexts file to setup selinux labels\n"
>   #endif
> @@ -1246,6 +1248,39 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
>   		case 7:
>   			params->fixed_uid = params->fixed_gid = 0;
>   			break;
> +		case 540: {
> +			FILE *f = fopen(optarg, "r");
> +			if (!f) {
> +				erofs_err("failed to open exclude file: %s", optarg);
> +				return -errno;
> +			}
> +
> +			char *line = NULL;
> +			size_t len = 0;
> +			ssize_t read;
> +
> +			while ((read = getline(&line, &len, f)) != -1) {
> +				if (read > 0 && line[read - 1] == '\n') {
> +					line[read - 1] = '\0';
> +					read--;
> +				}
> +
> +				if (read == 0) continue;
> +
> +				opt = erofs_parse_exclude_path(line, false);
> +				if (opt) {
> +					erofs_err("failed to parse exclude path from file: %s",
> +						  erofs_strerror(opt));
> +					free(line);
> +					fclose(f);
> +					return opt;
> +				}
> +			}
> +			free(line);
> +			fclose(f);
> +			break;
> +			}
> +
>   #ifndef NDEBUG
>   		case 8:
>   			cfg.c_random_pclusterblks = true;

