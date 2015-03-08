rp_module_id="lr-fba"
rp_module_desc="Arcade emu - Final Burn Alpha port for libretro"
rp_module_menus="2+"

function depends_lr-fba() {
    getDepends gcc-4.8 g++-4.8
}

function sources_lr-fba() {
    gitPullOrClone "$md_build" git://github.com/libretro/fba-libretro.git
}

function build_lr-fba() {
    cd svn-current/trunk/
    make -f makefile.libretro clean
    make -f makefile.libretro CC="gcc-4.8" CXX="g++-4.8" platform=armvhardfloat
    md_ret_require="$md_build/svn-current/trunk/fb_alpha_libretro.so"
}

function install_lr-fba() {
    md_ret_files=(
        'svn-current/trunk/fba.chm'
        'svn-current/trunk/fb_alpha_libretro.so'
        'svn-current/trunk/gamelist-gx.txt'
        'svn-current/trunk/gamelist.txt'
        'svn-current/trunk/whatsnew.html'
        'svn-current/trunk/preset-example.zip'
    )
}

function configure_lr-fba() {
    # remove old install folder
    rm -rf "$rootdir/$md_type/fbalibretro"

    mkRomDir "fba-libretro"
    ensureSystemretroconfig "fba"

    # system-specific shaders, fba
    iniConfig " = " "" "$configdir/fba/retroarch.cfg"
    iniSet "input_remapping_directory" "$configdir/fba/"

    setESSystem "Final Burn Alpha" "fba-libretro" "~/RetroPie/roms/fba-libretro" ".fba .FBA .zip .ZIP" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$emudir/retroarch/bin/retroarch -L $md_inst/fb_alpha_libretro.so --config $configdir/all/retroarch.cfg --appendconfig $configdir/fba/retroarch.cfg %ROM%\" \"$md_id\"" "arcade" "fba"
}
