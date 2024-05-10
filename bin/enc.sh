#!/bin/bash

# Project: enc.sh - create decryption script with embedded encrypted contents of provided file
#
# Copyright (c) 2021 Michael Moedt (mmoedt@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following condition:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
[[ "${ITERATIONS}" -gt 10000 ]] || ITERATIONS="100100"

PROGNAME="${0}"
INFILE="${1}"

function print_usage() {
    cat <<EOF
Usage: ${PROGNAME} <input-file>

Outputs to {input-file}.decrypt.sh, containing the encrypted data.
To decrypt, run this resulting file and provide the passphrase.

EOF
}

function enc_main() {
    OUTFILE="${INFILE}.decrypt.sh"
    if [[ -e "${OUTFILE}" ]]; then
        echo "** WARNING: Output file '${OUTFILE}' already exists; will be overwriting it"
        echo "Press ENTER to continue, CTRL-C to abort.."
        read ENTER
    fi
    if [[ ! -e "${INFILE}" ]]; then
        echo "** ERROR: The specified input file does not exist"
        return 1
    fi
    if [[ "${PASSPHRASE}" != "" ]]; then
        echo "Using PASSPHRASE environment variable"
    else
        NEED_PASS=1
        while [[ ${NEED_PASS} == 1 ]]; do {
            echo -n "Please enter the passphrase: "
            read PASSPHRASE
            if [[ "${PASSPHRASE}" == "" ]]; then
                echo "Empty PASSPHRASE entered .. aborting"
                return 2
            fi
            echo -n "Please re-enter the passphrase: "
            read PASSPHRASE2
            if [[ "${PASSPHRASE}" == "${PASSPHRASE2}" ]]; then
                NEED_PASS=0
                echo "OK - got it"
            else
                echo "ERROR: Second entry doesn't match the first"
            fi
        } done
    fi

    DSTAMP="$(date +%Y%m%d.%H%M%S)"
    CIPHER_OPTIONS="-aes-256-cbc -md sha256 -pbkdf2 -iter ${ITERATIONS} -salt -base64"

    cat > "${OUTFILE}" <<EOF
#!/bin/bash

    if [[ "\${1}" != "" ]]; then
        OUTFILE="\${1}"
    else
        OUTFILE="${INFILE}"
        echo "Using output file '\${OUTFILE}'"
        if [[ -e "\${OUTFILE}" ]]; then
           echo "WARNING: Output file exists, and will be overwritten"
           echo "Press ENTER to continue, CTRL-C to abort.."
           read ENTER
        fi
    fi
    if [[ "\${PASSPHRASE}" != "" ]]; then
        echo "Using PASSPHRASE environment variable"
    else
        echo -n "Please enter the passphrase: "
        read PASSPHRASE
        if [[ "${PASSPHRASE}" == "" ]]; then
            echo "Empty PASSPHRASE entered .. aborting"
            exit 2
        fi
    fi

    echo "Attempting to decrypt to '\${OUTFILE}'..."
    > \${OUTFILE}
    export PASSPHRASE
    openssl enc ${CIPHER_OPTIONS} -pass env:PASSPHRASE -d -v <<EOF |
EOF

    export PASSPHRASE
    cat "${INFILE}" | gzip | openssl enc ${CIPHER_OPTIONS} -pass env:PASSPHRASE -e -v 2> enc.openssl.stderr.${DSTAMP} >> "${OUTFILE}"

    cat >> "${OUTFILE}" <<EOF2
EOF
 gzip -d > \${OUTFILE}

echo "done!"
exit

# Verbose output from encryption script:
#
EOF2
    cat enc.openssl.stderr.${DSTAMP} | sed -r 's/^/# /' >> "${OUTFILE}"
    echo "Done!  Inspect '${OUTFILE}' for the results."
    rm enc.openssl.stderr.${DSTAMP}

    return 0
}

if [[ "${INFILE}" == "" ]]; then
    print_usage
else
    enc_main
fi
