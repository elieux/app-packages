_eqver() {
    local r v

    for v in "${@}"
    do
        if [ -n "${r}" -a "${r}" != "${v}" ]
        then
            echo "Version mismatch between ${r} and ${v}."
        fi
        r="${v}"
    done
    echo "${r}"
}

_lc() {
    local d f n

    for f in "${@}"
    do
        d="$(dirname "${f}")"
        f="$(basename "${f}")"
        n="$(echo "${f}" | tr 'A-Z' 'a-z')"
        if test "${f}" != "${n}"
        then
            mv "${d}/${f}" "${d}/${n}"
        fi
    done
}

_dl() {
    (
        cd "${SRCDEST}"
        download_file "${1}"
    )
}

_dlread() {
    local tmp

    tmp=".tmp"
    rm -f "${SRCDEST}/${tmp}"
    _dl "${tmp}::${1}" &> /dev/null
    cat "${SRCDEST}/${tmp}"
    rm "${SRCDEST}/${tmp}"
}

_rmmsdll() {
    local ms

    ms=("msvbvm[0-9]+[.]dll"
        "ucrtbase.dll"
        "mfcm?[0-9]+[a-z]+[.]dll"
        "msvc[rp][0-9]+[.]dll"
        "vc([ao]mp|corlib|runtime)[0-9]+[.]dll"
        "concrt[0-9]+[.]dll"
        "pgort[0-9]+[.]dll"
        "api-ms-win-[0-9a-z-]+[.]dll")
    # find "${1}" -iname '*.dll' | grep -Exf <(for m in "${ms[@]}"; do echo "${m}"; done) | xargs -r rm
}
