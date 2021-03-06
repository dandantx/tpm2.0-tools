#;**********************************************************************;
#
# Copyright (c) 2016, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, 
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation 
# and/or other materials provided with the distribution.
#
# 3. Neither the name of Intel Corporation nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
# THE POSSIBILITY OF SUCH DAMAGE.
#;**********************************************************************;

#!/bin/sh
##before this script, you should make sure all kinds of context already loaded 

context_p=
halg=

ctx_count=`ls |grep -c context_load`
if [ $ctx_count -le 1 ];then
	echo "we should execute test_algs.sh first!"
	wait 5
    ./test_algs.sh
fi

rm test_algs_*.log sign_*  verifysig_*  tickt_verify*

#for  halg_p in 0x0004 0x000B 0x000C 0x000D 0x0012  
for  context_p in `ls context_load*`   
  do
   for halg in 0x0004 0x000B 0x000C
     do
	
   tpm2_sign -c $context_p  -g $halg  -m secret.data -s sign_"$context_p"_"$halg"
	if [ $? != 0 ];then
		echo "sign for sign_"$context_p"_"$halg"  fail, pelase check the environment or parameters!"
		echo " sign for sign_"$context_p"_"$halg" fail" >>test_algs_sign_error.log
	else
		echo "sign for sign_"$context_p"_"$halg"  pass" >>test_algs_sign_pass.log
	 
		for halg_ver in 0x0004 0x000B 0x000C 0x000D 0x0012
		  do
	
			tpm2_verifysignature -c  $context_p  -g $halg_ver -m secret.data -s sign_"$context_p"_"$halg" -t tickt_verify_sign_"$context_p"_"$halg"_"$halg_ver".out                                
			 if [ $? != 0 ];then
				echo "verifysignature for sign_"$context_p"_"$halg"_"$halg_ver"  fail, pelase check the environment or parameters!"
				echo " verifysignature for sign_"$context_p"_"$halg"_"$halg_ver"  fail"  >>test_algs_verifysignature_error.log
			else
				echo " verifysignature for sign_"$context_p"_"$halg"_"$halg_ver"  pass" >>test_algs_verifysignature_pass.log
			fi

		 done

	fi

 done
done


