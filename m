Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA83606A31A
	for <linux-erofs@archiver.kernel.org>; Sat, 24 Oct 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQc79JBu
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jBkhx4h8Vz2xTl;
	Sun, 25 Oct 2026 02:44:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792856673;
	cv=none; b=OzAK9hyd4Y9hHjTLPRP2Jqis2IR3xnh6muha6PBPNHJx1uMIsB4Q77yll8CcO5BuUAQ4C9HaW3dCCyb3+dI8vePbYjNqNk8ogwUi1T000w+/JdRyRe+6x8KFKrZEomILDHUdhoRIiHFy5wH1h4NU1qhb0TcuEbR6pmUkmuxDgCEn8xfjtz+Y1rToJvR+gGhJKTnmbsCHQjO72mqVP+kGKq3lg6Uwbj1EXkXQQW6sMZNITTAToA8JwHlJsVTHV6xf6+nJ5gy0xVrCcIKYfZU5RHcllu3Hq23OT6sCpKA3rLFeXWGTvzfUOX7zM8lForIUTaKkiIE5qokxEkxiSFTyZA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792856673; c=relaxed/relaxed;
	bh=M6TQVSamAzwLMPxaqFPL5NaSDoDqBf5EprTHNAtf1EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdNY0DQb6SFNXIV/xrBa1naWZE2B2srl6Rsg6bBbGAo0mey6WCr3+To3Nt8QjwrP+Bm/WG20MjnGI2o3jOYlFhSvQyu3jyH8s5OGHyt0wR3VhuhfYlvEHeNNHZefNEihlqajUxIyJIi61XkS5jGiq1W5H2sx7BEcnjlujYNhZ1EJMa7GtMU9P0O0aIr8fRbVUqemoRIEPm3bvZygS4j6hrG3hE9RJfPBTNsRmNcgJhAIgZoG6c5y1iWzqO2/xdb5DNUbBIttatKvc15ZV5nE/uUmX3841fNpozt0ee9qhxePomgop1bgRW/NrsA2G5Be9+/a473UfZMgse63K6cKCg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQc79JBu; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQc79JBu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jBkhw1mBbz2xSV
	for <linux-erofs@lists.ozlabs.org>; Sun, 25 Oct 2026 02:44:32 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C418B60207;
	Sat, 24 Oct 2026 15:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485651F01825;
	Sat, 24 Oct 2026 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792856667;
	bh=M6TQVSamAzwLMPxaqFPL5NaSDoDqBf5EprTHNAtf1EU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MQc79JBuDD/+ho5oEHlitFIgJFndomV1JzwcJHKCD3l1xdquRxfJapXhuRQja3koE
	 iKLqPfiMR4E9uhqRkCWOoan0SkSCyQpN8A0jum4ZduryIWjlxp7c0Inew/wxI1U9V9
	 Z+y0ZMAIMUzZndIL88WSzr0ihnSG3bN2yeWqQ2UDUf5DKmtIK+PV9ntxyRHQthGs/X
	 u8zLc/XBF/r6jSuIa/8/rqHAdOPI+9pWqakIanfqcO1ne8e3Ah94JDf+U5JgvZLdCF
	 ifUBfsesn7D1c69WibtCT/GESAqhhX0dbzrCuGtPx0jcg2M2Pb4gMzV+vP/7yu40vn
	 D+3Ske6agu2FQ==
Date: Sat, 24 Oct 2026 17:44:22 +0200
From: Gao Xiang <xiang@kernel.org>
To: YoungWoo Rim <xsapiens75@gmail.com>
Cc: security@kernel.org, xiang@kernel.org, linux-erofs@lists.ozlabs.org
Subject: Re: erofs: use of uninitialized variable in erofs_real_inode()
Message-ID: <atzSVuvqYKgmvDmO@MacBookPro>
Mail-Followup-To: YoungWoo Rim <xsapiens75@gmail.com>, security@kernel.org,
	xiang@kernel.org, linux-erofs@lists.ozlabs.org
References: <CAM_WGAzh1WWJgdK=NV+MR9bU8Bn8Pe14QJW73y=XUjGt032ybA@mail.gmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHd6eXN5NA8tH78Z"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_WGAzh1WWJgdK=NV+MR9bU8Bn8Pe14QJW73y=XUjGt032ybA@mail.gmail.com>
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--xHd6eXN5NA8tH78Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

(Cc linux-erofs@lists.ozlabs.org to record this.)

Sorry, I checked your reproducer (I reattach this in this reply):
you're deliberately set in-memory inodes as I_FREEING with your
crafted kernel module (your reproducer is actually a crafted
kernel module instead of a userspace workload, not sure if it's
LLM-generated):

 ...

                        /* Set I_FREEING on all real inodes */
                        spin_lock(&vis->ishare_lock);
                        list_for_each_entry(real_iter, &vis->ishare_list, ishare_list) {
                                spin_lock(&real_iter->vfs_inode.i_lock);
                                inode_state_set(&real_iter->vfs_inode, I_FREEING);
                                spin_unlock(&real_iter->vfs_inode.i_lock);
                        }
                        spin_unlock(&vis->ishare_lock);
 ...

That violates the following Linux VFS constraints:

 - I_FREEING should be **only** set after i_count == 0:
       see evict_inodes() or iput_final()
   your kernel module violates this constraint.

 - If i_count == 0 and I_FREEING is set, the particular in-memory
   inode won't be reused anymore: see find_inode() ->
   __wait_on_freeing_inode().

Actually I found a real issue out of mmap() path of the page cache
sharing feature, the timing is like:

 1) Mount an EROFS filesystem with inode_share enabled and map
    a shared file into a process's address space;

 2) Close the original file descriptors and release other references
    to the original EROFS inodes.  The VMA continues to hold the
    shared backing file.

 3) Under inode/dentry cache reclaim, the original EROFS inodes can
    become unreferenceable and enter eviction. erofs_evict_inode()
    removes each original inode from the shared list through
    erofs_ishare_free_inode(). 

 4) Access a previously untouched folio in the still-live mapping.
    The page fault can invoke read_folio() on the shared
    pseudo-inode's address space;

 5) erofs_real_inode() attempts to obtain a reference to an
    original inode, but no candidate may be successfully acquired.

However, page cache sharing is marked as an experimental feature and
it needs privilege to mount (with a specific mount option), so I
think it's just another normal bug that needs to be resolved.

I disclose my finding based on these facts, and I will send out
a proper fix about the issue I described above later.

Thanks,
Gao Xiang

On Sat, Oct 24, 2026 at 05:33:55PM +0900, YoungWoo Rim wrote:
> Hi,
> 
> I'd like to report a security vulnerability in the EROFS page cache sharing
> feature (CONFIG_EROFS_FS_PAGE_CACHE_SHARE).
> 
> ## Summary
> 
> erofs_real_inode() in fs/erofs/ishare.c declares a local pointer variable
> `realinode` without initialization. Under a race condition during concurrent
> filesystem unmount, all igrab() calls within the function can fail, causing
> the uninitialized stack value to be returned. All callers immediately
> dereference this value without NULL checking, leading to kernel oops/panic
> or potential information leakage.
> 
> ## Affected Versions
> 
> All kernel versions from v7.0 through v7.3-rc7 (latest mainline) with
> CONFIG_EROFS_FS_PAGE_CACHE_SHARE=y. Verified by inspecting source directly
> from kernel.org on 2026-10-24:
> 
>   - v7.0.0:   vulnerable (struct inode *realinode; — no init)
>   - v7.0.9:   vulnerable
>   - v7.2.9:   vulnerable
>   - v7.3-rc7: vulnerable
> 
> This is distinct from CVE-2026-80697 (f_path NULL in backing files).
> 
> ## Vulnerable Code
> 
> fs/erofs/ishare.c, erofs_real_inode(), lines 175-199:
> 
>   struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
>   {
>       struct erofs_inode *vi, *vi_share;
>       struct inode *realinode;                   // NOT initialized
> 
>       *need_iput = false;
>       if (!erofs_is_ishare_inode(inode))
>           return inode;
> 
>       vi_share = EROFS_I(inode);
>       spin_lock(&vi_share->ishare_lock);
>       DBG_BUGON(list_empty(&vi_share->ishare_list));
>       list_for_each_entry(vi, &vi_share->ishare_list, ishare_list) {
>           realinode = igrab(&vi->vfs_inode);
>           if (realinode) {
>               *need_iput = true;
>               break;
>           }
>       }
>       spin_unlock(&vi_share->ishare_lock);
> 
>       DBG_BUGON(!realinode);                    // no-op in release builds
>       return realinode;                         // returns stack garbage
>   }
> 
> ## Race Window
> 
> The VFS inode freeing path sets I_FREEING (inode.c:1951) before calling
> evict() -> erofs_evict_inode() -> erofs_ishare_free_inode() -> list_del().
> 
> Between I_FREEING being set and list_del() completing:
>   - igrab() returns NULL (because I_FREEING is set)
>   - The inode is still in ishare_list (not yet removed)
> 
> If all inodes in ishare_list are in this state simultaneously (e.g., two
> EROFS mounts being unmounted concurrently), the loop exhausts without
> assigning realinode. Alternatively, if list_del() completes first, the
> list becomes empty and the loop body never executes.
> 
> Both paths leave realinode uninitialized in release builds (DBG_BUGON
> is compiled out).
> 
> ## Impact
> 
>   - Denial of Service: kernel oops/panic from dereferencing stack garbage
>   - Information Leak: if the garbage value points to valid kernel memory,
>     erofs_err() at zdata.c:1898 logs realinode->i_sb and
>     EROFS_I(realinode)->nid to dmesg
> 
> ## Reproduction
> 
> Tested on Linux v7.0.0 (aarch64, QEMU) with
> CONFIG_EROFS_FS_PAGE_CACHE_SHARE=y,
> CONFIG_KASAN=y. Bug confirmed via a kernel module that deterministically
> simulates the race condition by setting I_FREEING on all real inodes in
> the ishare_list before calling igrab().
> 
> ### Environment
>   - Kernel: 7.0.0 (built from kernel.org source)
>   - erofs-utils: 1.9.4 (mkfs.erofs --xattr-inode-digest)
>   - Mount options: -o loop,domain_id=test,inode_share
> 
> ### Steps
>   1. Create two EROFS images with identical file content and fingerprint
> xattrs
>   2. Mount both with domain_id + inode_share (shared inode created)
>   3. Load kernel module that:
>      a. Finds the shared inode (ino=0, pseudo_erofs FS) via ishare_list
>      b. Lists real inodes: 2 entries (ino=54 from each mount)
>      c. Sets I_FREEING on both (simulating concurrent unmount race)
>      d. Calls igrab() on each — both return NULL
>      e. realinode variable left UNINITIALIZED
> 
> ### Kernel log (dmesg) output
> 
>   TRIGGER: FOUND shared inode! ino=0
>   TRIGGER: real[0] ino=54 state=0x0 cnt=1
>   TRIGGER: real[1] ino=54 state=0x0 cnt=1
>   TRIGGER: 2 real inodes. Setting I_FREEING...
>   TRIGGER: igrab(ino=54) = NULL
>   TRIGGER: igrab(ino=54) = NULL
>   TRIGGER: ========================================
>   TRIGGER: *** BUG CONFIRMED ***
>   TRIGGER: ALL igrab returned NULL
>   TRIGGER: realinode is UNINITIALIZED
>   TRIGGER: ========================================
> 
> The full kernel module source and dmesg trace are available upon request.
> 
> ## Proposed Patch
> 
> The minimal fix initializes the variable and adds caller-side NULL checks:
> 
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -178,7 +178,7 @@
> -    struct inode *realinode;
> +    struct inode *realinode = NULL;
> @@ -197,7 +197,8 @@
> -    DBG_BUGON(!realinode);
> +    if (unlikely(!realinode))
> +        pr_warn_ratelimited("erofs: ishare has no live real inode\n");
>      return realinode;
> 
> Additionally, all six callers (fileio.c:160,175; data.c:389,407;
> zdata.c:1885,1913) should check for NULL before dereferencing:
> 
>   struct inode *realinode = erofs_real_inode(..., &need_iput);
>   if (unlikely(!realinode)) {
>       folio_unlock(folio);  // or simply return for readahead
>       return -EIO;
>   }
> 
> I can provide a complete patch series if needed.
> 
> ## Threat Assessment
> 
> The primary threat is Denial of Service (kernel panic). A secondary risk
> is kernel address information leakage via dmesg, which could aid KASLR
> bypass if chained with a separate write vulnerability. Remote Code
> Execution is not feasible with this vulnerability alone — all
> dereferences are reads, there is no function pointer invocation through
> the fake inode, and EROFS is a read-only filesystem with no userdata →
> kernel memory write path.
> 
>   - Primary: DoS (High) — kernel oops/panic
>   - Secondary: Info Leak (Medium) — kernel heap addresses in dmesg
>   - RCE: Not applicable standalone
> 
> ## Classification
> 
>   - CWE-457: Use of Uninitialized Variable
>   - CWE-362: Concurrent Execution Using Shared Resource with
>              Improper Synchronization (Race Condition)
>   - Estimated CVSS 3.1: 5.3-6.5 (Medium)
> 
> ## CVE Request
> 
> Could you please assign a CVE ID for this issue? This vulnerability is
> distinct from CVE-2026-80697, which addresses a different bug (NULL
> f_path in backing files) in the same feature.
> 
> ## Disclosure
> 
> I am happy to coordinate on a disclosure timeline. I would suggest
> a standard 90-day embargo from the date of this report, but I am
> flexible and will follow the kernel security team's preferred process.
> 
> If you prefer encrypted communication, I can provide a PGP public key.
> 
> Regards,
> Youngwoo Rim
> .

> [  130.613096] TRIGGER: target=/mnt/erofs1/file.bin
> [  130.613128] TRIGGER: ino=54 mapping=ffff00000d344b80 i_data=ffff00000d344b80 redir=0
> [  130.613136] TRIGGER: ishare_list empty=0 sb_type=erofs
> [  130.613142] TRIGGER: peer[0] ino=0 sb=pseudo_erofs mapping=ffff00000d3445e8 i_data=ffff00000d3445e8 redir=0
> [  130.613150] TRIGGER: peer[1] ino=54 sb=erofs mapping=ffff00000d344050 i_data=ffff00000d344050 redir=0
> [  130.613157] TRIGGER: 2 peers in list
> [  130.613161] TRIGGER: FOUND shared inode! ino=0
> [  130.616348] TRIGGER: real[0] ino=54 state=0x0 cnt=1
> [  130.617044] TRIGGER: real[1] ino=54 state=0x0 cnt=1
> [  130.617112] TRIGGER: 2 real inodes. Setting I_FREEING...
> [  130.617129] TRIGGER: igrab(ino=54) = NULL
> [  130.617134] TRIGGER: igrab(ino=54) = NULL
> [  130.617139] TRIGGER: ========================================
> [  130.617144] TRIGGER: *** BUG CONFIRMED ***
> [  130.617148] TRIGGER: ALL igrab returned NULL
> [  130.617152] TRIGGER: realinode is UNINITIALIZED
> [  130.617156] TRIGGER: ========================================
> [  130.617163] TRIGGER: done




--xHd6eXN5NA8tH78Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=trigger_ishare_bug.c
Content-Transfer-Encoding: 8bit

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/namei.h>
#include "/home/user/linux-7.0/fs/erofs/internal.h"

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Trigger erofs ishare uninit variable bug");

static char *target = "/mnt/erofs1/file.bin";
module_param(target, charp, 0444);

static int __init trigger_init(void)
{
	struct path p;
	struct inode *inode;
	struct erofs_inode *vi, *tmp;
	int ret, cnt;

	pr_err("TRIGGER: target=%s\n", target);

	ret = kern_path(target, LOOKUP_FOLLOW, &p);
	if (ret) {
		pr_err("TRIGGER: kern_path: %d\n", ret);
		return ret;
	}

	inode = p.dentry->d_inode;
	vi = EROFS_I(inode);

	pr_err("TRIGGER: ino=%lu mapping=%px i_data=%px redir=%d\n",
	       inode->i_ino, inode->i_mapping, &inode->i_data,
	       inode->i_mapping != &inode->i_data);
	pr_err("TRIGGER: ishare_list empty=%d sb_type=%s\n",
	       list_empty(&vi->ishare_list),
	       inode->i_sb->s_type->name);

	/* Walk the ishare_list from this inode's perspective */
	cnt = 0;
	list_for_each_entry(tmp, &vi->ishare_list, ishare_list) {
		struct inode *ti = &tmp->vfs_inode;
		pr_err("TRIGGER: peer[%d] ino=%lu sb=%s mapping=%px i_data=%px redir=%d\n",
		       cnt, ti->i_ino, ti->i_sb->s_type->name,
		       ti->i_mapping, &ti->i_data,
		       ti->i_mapping != &ti->i_data);
		cnt++;
		if (cnt > 20) break;
	}
	pr_err("TRIGGER: %d peers in list\n", cnt);

	/*
	 * If any peer has redirected mapping, use its mapping->host
	 * as the shared inode. Or if a peer is on erofs_anon_fs_type,
	 * that IS the shared inode.
	 */
	cnt = 0;
	list_for_each_entry(tmp, &vi->ishare_list, ishare_list) {
		struct inode *ti = &tmp->vfs_inode;
		if (ti->i_sb->s_type == &erofs_anon_fs_type) {
			struct erofs_inode *vis = tmp;
			struct erofs_inode *real_iter;
			int rcnt = 0;

			pr_err("TRIGGER: FOUND shared inode! ino=%lu\n", ti->i_ino);

			/* Count real inodes in the shared inode's list */
			spin_lock(&vis->ishare_lock);
			list_for_each_entry(real_iter, &vis->ishare_list, ishare_list) {
				pr_err("TRIGGER: real[%d] ino=%lu state=0x%lx cnt=%d\n",
				       rcnt, real_iter->vfs_inode.i_ino,
				       (unsigned long)inode_state_read(&real_iter->vfs_inode),
				       atomic_read(&real_iter->vfs_inode.i_count));
				rcnt++;
			}
			spin_unlock(&vis->ishare_lock);

			pr_err("TRIGGER: %d real inodes. Setting I_FREEING...\n", rcnt);

			/* Set I_FREEING on all real inodes */
			spin_lock(&vis->ishare_lock);
			list_for_each_entry(real_iter, &vis->ishare_list, ishare_list) {
				spin_lock(&real_iter->vfs_inode.i_lock);
				inode_state_set(&real_iter->vfs_inode, I_FREEING);
				spin_unlock(&real_iter->vfs_inode.i_lock);
			}
			spin_unlock(&vis->ishare_lock);

			/* Test igrab — same as erofs_real_inode() */
			{
				struct erofs_inode *vi_iter;
				struct inode *realinode;
				int got = 0;

				spin_lock(&vis->ishare_lock);
				list_for_each_entry(vi_iter, &vis->ishare_list, ishare_list) {
					realinode = igrab(&vi_iter->vfs_inode);
					pr_err("TRIGGER: igrab(ino=%lu) = %s\n",
					       vi_iter->vfs_inode.i_ino,
					       realinode ? "OK" : "NULL");
					if (realinode) {
						got = 1;
						break;
					}
				}
				spin_unlock(&vis->ishare_lock);

				if (!got) {
					pr_err("TRIGGER: ========================================\n");
					pr_err("TRIGGER: *** BUG CONFIRMED ***\n");
					pr_err("TRIGGER: ALL igrab returned NULL\n");
					pr_err("TRIGGER: realinode is UNINITIALIZED\n");
					pr_err("TRIGGER: ========================================\n");
				} else {
					pr_err("TRIGGER: igrab succeeded (bug not triggered)\n");
					iput(realinode);
				}
			}

			/* Restore inode states */
			spin_lock(&vis->ishare_lock);
			list_for_each_entry(real_iter, &vis->ishare_list, ishare_list) {
				spin_lock(&real_iter->vfs_inode.i_lock);
				inode_state_clear_raw(&real_iter->vfs_inode, I_FREEING);
				spin_unlock(&real_iter->vfs_inode.i_lock);
			}
			spin_unlock(&vis->ishare_lock);

			break;
		}
		cnt++;
		if (cnt > 20) break;
	}

	if (cnt > 20)
		pr_err("TRIGGER: shared inode not found in list\n");

	path_put(&p);
	pr_err("TRIGGER: done\n");
	return -EAGAIN;
}

static void __exit trigger_exit(void) {}
module_init(trigger_init);
module_exit(trigger_exit);

--xHd6eXN5NA8tH78Z--

