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
#!/bin/bash

Atype=
gAlg=
GAlg=
gAlgList="0x04 0x0B"
AtypeList="o e n"
STATUS=0

if [[ "$@" == *"--384"* ]]; then
    gAlgList="$gAlgList 0x0C"
fi

if [[ "$@" == *"--512"* ]]; then
    gAlgList="$gAlgList 0x0D"
fi

if [[ "$@" == *"--sm3256"* ]]; then
    gAlgList="$gAlgList 0x12"
fi

if [[ "$@" == *"--platform"* ]]; then
    AtypeList="$AtypeList p"
fi

rm -f /home/$USER/createprimary.error.log /home/$USER/ctx.cpri.*

for gAlg in $gAlgList
    do 
        for GAlg in 0x01 0x08 0x23 0x25
            do 
                for Atype in $AtypeList
                    do 
                    tpm2_createprimary -A $Atype -g $gAlg -G $GAlg -C /home/$USER/ctx.cpri."$Atype".g"$gAlg".G"$GAlg"
                    if [ $? != 0 ];then 
                    echo "tpm2_createprimary error: Atype=$Atype gAlg=$gAlg GAlg=$GAlg"
                    echo "tpm2_createprimary error: Atype=$Atype gAlg=$gAlg GAlg=$GAlg" >> /home/$USER/createprimary.error.log
                    STATUS=1
                    fi
                done
        done
done
exit $STATUS
