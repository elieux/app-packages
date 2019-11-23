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

    ms=("msvbvm[0-9]+"
        "ucrtbase"
        "mfcm?[0-9]+[a-z]+"
        "msvc[rp][0-9]+"
        "vc([ao]mp|corlib|runtime)[0-9]+"
        "concrt[0-9]+"
        "pgort[0-9]+"
        "api-ms-win-[0-9a-z-]+")
    find "${1}" -iname '*.dll' | grep -Eif <(for m in "${ms[@]}"; do echo "/${m}[.]dll$"; done) | xargs -r rm
}

_pickarch() {
    local f n

    for f in "${@}"
    do
        n="$(echo "${f}" | sed -r 's/_[0-9]+[.]/./')"
        case "$(file "${f}")" in
        *x86-64*|*assembly*) mv -f "${f}" "${n}" ;;
        *) rm "${f}" ;;
        esac
    done
}
