_extract_subdir() {
    local _file="$(get_filename "${1}")"
    local _dir="${_file%.*}"
    if type bsdtar | head -1 | grep -q 'is a function'
    then
        local _original_bsdtar="$(type bsdtar | tail +2)"
    fi
    bsdtar() {
        local _extra_args=()
        if [ "${1}" = "-xf" ]
        then
            mkdir -p "${_dir}"
            _extra_args=(-C "${_dir}")
        fi
        /usr/bin/bsdtar "${_extra_args[@]}" "${@}"
    }
    extract_file "${_file}"
    unset -f bsdtar
    eval "${_original_bsdtar}"
}

extract_http@subdir() {
    _extract_subdir "${@}"
}

download_http@subdir() {
    download_file "${1/@subdir:/:}"
}

extract_https@subdir() {
    _extract_subdir "${@}"
}

download_https@subdir() {
    download_file "${1/@subdir:/:}"
}

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

_despace() {
    local d f n

    for f in "${@}"
    do
        d="$(dirname "${f}")"
        f="$(basename "${f}")"
        n="$(echo "${f}" | tr ' ' '_')"
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

_dotnet() {
    local runtimetarget="$(cat "${1}.deps.json" | /mingw64/bin/jq -r '.runtimeTarget.name')"
    local netcore="$(cat "${1}.deps.json" | /mingw64/bin/jq --arg runtimetarget "${runtimetarget}" -r '.targets[$runtimetarget] | keys | .[] | select(test("^runtimepack[.]Microsoft[.]NETCore[.]App[.][Rr]untime[.]win-x64/"))')"
    local windowsdesktop="$(cat "${1}.deps.json" | /mingw64/bin/jq --arg runtimetarget "${runtimetarget}" -r '.targets[$runtimetarget] | keys | .[] | select(test("^runtimepack[.]Microsoft[.]WindowsDesktop[.]App[.][Rr]untime[.]win-x64/"))')"

    cat "${1}.deps.json" | /mingw64/bin/jq -r --arg runtimetarget "${runtimetarget}" --arg netcore "${netcore}" --arg windowsdesktop "${windowsdesktop}" '.targets[$runtimetarget] | (.[$netcore], .[$windowsdesktop]) | (.runtime, .native) | select(.) | keys | .[]' | dos2unix | sort | uniq | (cd "$(dirname "${1}")" && xargs rm -f)

    cat "${1}.deps.json" | /mingw64/bin/jq -r --arg runtimetarget "${runtimetarget}" --arg netcore "${netcore}" --arg windowsdesktop "${windowsdesktop}" 'del(.targets[$runtimetarget][$netcore]) | del(.targets[$runtimetarget][$windowsdesktop])' > "${1}.deps.json.tmp"
    mv -f "${1}.deps.json.tmp" "${1}.deps.json"

    cat "${1}.runtimeconfig.json" | /mingw64/bin/jq '.runtimeOptions |= (.framework = .includedFrameworks[-1] | del(.includedFrameworks))' > "${1}.runtimeconfig.json.tmp"
    mv -f "${1}.runtimeconfig.json.tmp" "${1}.runtimeconfig.json"
}

_rmmsdll() {
    local ms

    ms=("msvbvm[0-9]+"
        "ucrtbase"
        "mfcm?[0-9]+[a-z]+"
        "msvc[rp][0-9]+(_([0-9]|codecvt_ids|atomic_wait))?"
        "vc([ao]mp|corlib|runtime)[0-9]+(_[0-9])?"
        "concrt[0-9]+"
        "pgort[0-9]+"
        "api-ms-win-[0-9a-z-]+")
    find "${1}" -iname '*.dll' | grep -Eif <(for m in "${ms[@]}"; do echo "/${m}[.]dll$"; done) | xargs -r rm
}

_pickarch() {
    local d f n

    for f in "${@}"
    do
        d="$(dirname "${f}")"
        f="$(basename "${f}")"
        n="$(echo "${f}" | sed -r -e 's/_[0-9]+[.]/./' -e 's/[.]duplicate[0-9]+$//')"
        case "$(file "${d}/${f}")" in
        *x86-64*|*assembly*) mv -f "${d}/${f}" "${d}/${n}" ;;
        *) rm "${d}/${f}" ;;
        esac
    done
}
